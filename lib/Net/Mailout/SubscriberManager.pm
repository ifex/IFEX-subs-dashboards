package Net::Mailout::SubscriberManager;

use Moose;
use XML::Bare;
use Carp;

with 'Net::Mailout::Role';

has '+proxy' => ( default => 'http://www.mymailout.net/MyMailout/WebService/SubscriberManager.asmx' );
has '+xmlns' => ( default => 'http://www.mymailout.net/WebService/SubscriberManager' );

sub GetMailingLists {
    my ($self) = @_;
    
    my $method = SOAP::Data->name('GetMailingLists')->attr({xmlns => $self->xmlns});
    my $mailinglist = $self->soap->call($method, $self->soap_header)->result->{MailingList};
    return wantarray ? @$mailinglist : $mailinglist;
}

sub GetAllSubscribers {
    my ($self, $mailinglistid) = @_;
    
    #SOAP::Trace->import('all');
    
    my $method = SOAP::Data->name('GetAllSubscribers')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('mailinglistid')->value($mailinglistid)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    my @subscribers;
    while ($xml =~ /(\<Subscriber\>(.*?)\<\/Subscriber\>)/g) {
        my $ob = XML::Bare->new(text => $1);
        my $root = $ob->parse();
        
        # fix XML::Bare ->{value}
        my $x = $root->{Subscriber};
        my %y;
        foreach (keys %$x) {
            next if (/^\_/); # _pos, _i
            $y{$_} = $x->{$_}->{value};
        }
        push @subscribers, \%y;
    }

    return wantarray ? @subscribers : \@subscribers;
}

sub GetSubscribers {
    my $self = shift;
    my $args = @_ % 2 ? shift @_ : { @_ };
    
    my $method = SOAP::Data->name('GetSubscribers')->attr({xmlns => $self->xmlns});
    
    $args->{includeUnsubscribed} = 1 unless exists $args->{includeUnsubscribed};
    $args->{includeActive} = 1       unless exists $args->{includeActive};
    $args->{includeUnconfirmed} = 1  unless exists $args->{includeUnconfirmed};
    $args->{ignoreNewCsvUploads} = 0 unless exists $args->{ignoreNewCsvUploads};
    $args->{ignoreNewWebServiceUploads} = 0 unless exists $args->{ignoreNewWebServiceUploads};
    
    my $data = SOAP::Data->value( 
        SOAP::Data->name('mailinglistid')->value( $args->{mailinglistid} )->type(''),
        SOAP::Data->name('includeUnsubscribed')->value( $args->{includeUnsubscribed} )->type(''),
        SOAP::Data->name('includeActive')->value( $args->{includeActive} )->type(''),
        SOAP::Data->name('includeUnconfirmed')->value( $args->{includeUnconfirmed} )->type(''),
        SOAP::Data->name('utcStartDate')->value( $args->{utcStartDate} )->type(''),
        SOAP::Data->name('ignoreNewCsvUploads')->value( $args->{ignoreNewCsvUploads} )->type(''),
        SOAP::Data->name('ignoreNewWebServiceUploads')->value( $args->{ignoreNewWebServiceUploads} )->type(''),
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);

    my @subscribers;
    while ($xml =~ /(\<Subscriber\>(.*?)\<\/Subscriber\>)/g) {
        my $ob = XML::Bare->new(text => $1);
        my $root = $ob->parse();
        
        # fix XML::Bare ->{value}
        my $x = $root->{Subscriber};
        my %y;
        foreach (keys %$x) {
            next if (/^\_/); # _pos, _i
            $y{$_} = $x->{$_}->{value};
        }
        push @subscribers, \%y;
    }

    return wantarray ? @subscribers : \@subscribers;
}

sub GetRemovedSubscribers {
    my ($self, $mailinglistid, $utcStartDate, $removalreasonid) = @_;
    
    #SOAP::Trace->import('all');
    
    my $method = SOAP::Data->name('GetRemovedSubscribers')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value( 
        SOAP::Data->name('mailinglistid')->value($mailinglistid)->type(''),
        SOAP::Data->name('utcStartDate')->value($utcStartDate)->type(''),
        SOAP::Data->name('removalreasonid')->value($removalreasonid)->type(''),
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);

    my @subscribers;
    while ($xml =~ /(\<Subscriber\>(.*?)\<\/Subscriber\>)/g) {
        my $ob = XML::Bare->new(text => $1);
        my $root = $ob->parse();
        
        # fix XML::Bare ->{value}
        my $x = $root->{Subscriber};
        my %y;
        foreach (keys %$x) {
            next if (/^\_/); # _pos, _i
            $y{$_} = $x->{$_}->{value};
        }
        push @subscribers, \%y;
    }

    return wantarray ? @subscribers : \@subscribers;
}

1;