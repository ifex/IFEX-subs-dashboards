#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Dashboard::Utils qw/config schema encrypt_email/;
use Net::Mailout;
use Data::Dumper;

my %campaign_type = (
    open => 1,
    click => 2,
);

my $config = config();
my $schema = schema();

my $mailout_conf = $config->{source}->{mailout};
my $mailout = Net::Mailout->new( user => $mailout_conf->{user}, pass => $mailout_conf->{pass} );

### check site
my $site = $schema->resultset('Site')->find( { domain => 'www.industrymailout.com' } );
$site ||= $schema->resultset('Site')->create( { name => 'Mailout', domain => 'www.industrymailout.com' } );
my $site_id = $site->id;

my $MailoutManager = $mailout->MailoutManager;
my %mailout;
my $rs = $schema->resultset('List')->search( { site_id => $site_id } );
while (my $r = $rs->next) {
    # we need skip alerts
    next if $r->remote_id == 13841 or $r->remote_id == 25505;
    
    print "GetMailouts " . $r->remote_id . "\n";
    my $mailouts = $MailoutManager->GetMailouts($r->remote_id); # maillistid
    sleep 1;
    next unless $mailouts and $mailouts->{Mailout}; # <GetMailoutsResult />
    foreach my $mo (@{ $mailouts->{Mailout} }) {
        my $created = $mo->{DateSent};
        $created = substr($created, 0, 10);
        $created =~ s/T/ /;
        
        my $summary = $MailoutManager->GetSummaryReport($mo->{Id});
        
        ### create campaigns
        my $campaign = $schema->resultset('Campaign')->update_or_create( {
            name    => $mo->{Subject},
            created => $created,
            list_id => $r->id,
            remote_id => $mo->{Id},
            site_id => $site_id,
            total_recipients => $summary->{TotalSent} || 0,
        }, {
            key => 'remote_campaign_id'
        }  );
        $mailout{$mo->{Id}} = {
            campaign_id => $campaign->id,
            list_id     => $r->id,
        };
    }
}

my $MailoutReporter = $mailout->MailoutReporter;
print "get LockReadConfirmations\n";
my $batchid = $MailoutReporter->LockReadConfirmations(10, 1000);
my @info = $MailoutReporter->GetLockedReadConfirmations($batchid);
my $total = scalar(@info); my $flag = 0;
foreach my $i (@info) {
    $flag++;
    print "$flag/$total on $i->{Subscriberid}\n";
    my $campaign_id = $mailout{$i->{Mailoutid}}->{campaign_id};
    my $list_id = $mailout{$i->{Mailoutid}}->{list_id};
    next unless $campaign_id and $list_id;
    my $type = $campaign_type{open};
    my $email = encrypt_email($i->{Email});
    my $created = $i->{UTCDateCreated};
    $created = substr($created, 0, 10);
    $created =~ s/T/ /;
    
    $schema->resultset('Email')->update_or_create( {
        remote_id => $i->{Id},
        email => $email,
        subscriber_id => $i->{Subscriberid},
        type  => $type,
        list_id => $list_id,
        site_id => $site_id,
        created => $created,
        campaign_id => $campaign_id
    }, {
        key => 'remote_id'
    }  );
}

print "get LockUrlClicks\n";
$batchid = $MailoutReporter->LockUrlClicks(10, 1000);
@info = $MailoutReporter->GetLockedUrlClicks($batchid);
$total = scalar(@info); $flag = 0;
foreach my $i (@info) {
    $flag++;
    print "$flag/$total on $i->{Subscriberid}\n";
    my $campaign_id = $mailout{$i->{Mailoutid}}->{campaign_id};
    my $list_id = $mailout{$i->{Mailoutid}}->{list_id};
    next unless $campaign_id and $list_id;
    my $type = $campaign_type{click};
    my $email = encrypt_email($i->{Email});
    my $created = $i->{UTCDateCreated};
    $created = substr($created, 0, 10);
    $created =~ s/T/ /;
    
    $schema->resultset('Email')->update_or_create( {
        remote_id => $i->{Id},
        email => $email,
        subscriber_id => $i->{Subscriberid},
        type  => $type,
        list_id => $list_id,
        site_id => $site_id,
        created => $created,
        campaign_id => $campaign_id
    }, {
        key => 'remote_id'
    }  );
}

# rebuild campaign_summary
$schema->resultset('CampaignSummary')->rebuild();

1;