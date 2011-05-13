#!/usr/bin/perl

use strict;
use warnings;
use lib '/home/fayland/perl5/lib/perl5';
use lib '/home/fayland/perl5/lib/perl5/x86_64-linux-gnu-thread-multi';
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Dashboard::Utils qw/config schema encrypt_email/;
use Net::Mailout;
use Data::Dumper;

################# get two days subscibers, less data
my @d = localtime( time() - 86400 * 2 );
my $utcStartDate = sprintf('%4d-%02d-%02dT00:00:00', $d[5] + 1900, $d[4] + 1, $d[3]);

my $config = config();
my $schema = schema();

my $mailout_conf = $config->{source}->{mailout};
my $mailout = Net::Mailout->new( user => $mailout_conf->{user}, pass => $mailout_conf->{pass} );

### check site
my $site = $schema->resultset('Site')->find( { domain => 'www.industrymailout.com' } );
$site ||= $schema->resultset('Site')->create( { name => 'Mailout', domain => 'www.industrymailout.com' } );
my $site_id = $site->id;

print "GetMailingLists\n";
my $SubscriberManager = $mailout->SubscriberManager;
my @mailinglist = $SubscriberManager->GetMailingLists();
foreach my $list (@mailinglist) {
    my $id = $list->{Id};
    my $ListName = $list->{ListName};
    print "GetAllSubscribers $id, $ListName\n";
    
    my $list = $schema->resultset('List')->update_or_create( {
        name => $ListName,
        remote_id => $id,
        site_id => $site_id
    }, {
        key => 'remote_site_id'
    }  );
    my $list_id = $list->id;
    
    my @subscribers = $SubscriberManager->GetSubscribers( mailinglistid => $id, utcStartDate => $utcStartDate );
    my $total = scalar(@subscribers); my $flag = 1;
    while (my $subscriber = shift @subscribers) {
        my $email = $subscriber->{Email};
        $email = encrypt_email($email);
        
        print "Working on $flag/$total $email\n";
        $flag++;
        
        my $created = $subscriber->{DateCreated}; # 'DateCreated' => '2010-03-24T00:04:37.8130000-06:00'
        $created = substr($created, 0, 19);
        $created =~ s/T/ /;
        my $modified = $subscriber->{DateModified};
        $modified = substr($created, 0, 19);
        $modified =~ s/T/ /;

        $schema->resultset('Subscriber')->update_or_create( {
            email => $email,
            list_id => $list_id,
            site_id => $site_id,
            active  => $subscriber->{Active} eq 'true' ? 1 : 0,
            first_name => $subscriber->{GivenName} || '',
            last_name  => $subscriber->{FamilyName} || '',
            created    => $created,
            modified   => $modified,
            source     => $subscriber->{SpecialField3} || '',
            country    => $subscriber->{Country} || '',
            text_only  => $subscriber->{TextOnly} eq 'true' ? 1 : 0,
            occupation => $subscriber->{SpecialField1} || '',
        }, {
            key => 'email'
        } );
    };
}
