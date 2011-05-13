package Net::Mailout::MailoutReporter;

use Moose;
use XML::Bare;
use Carp;

with 'Net::Mailout::Role';

has '+proxy' => ( default => 'http://www.mymailout.net/MyMailout/WebService/MailoutReporter.asmx' );
has '+xmlns' => ( default => 'http://www.mymailout.net/WebService/MailoutReporter' );

sub LockReadConfirmations {
    my ($self, $leaseminutes, $maxrecords) = @_;

    my $method = SOAP::Data->name('LockReadConfirmations')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('leaseminutes')->value($leaseminutes)->type(''),
        SOAP::Data->name('maxrecords')->value($maxrecords)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    # <LockReadConfirmationsResult>string</LockReadConfirmationsResult>
    my ($batchid) = ($xml =~ /\<LockReadConfirmationsResult\>(.*?)\<\/LockReadConfirmationsResult\>/s);
    return $batchid;
}

sub LockReadConfirmationsByMailout {
    my ($self, $mailoutid, $leaseminutes, $maxrecords) = @_;

    #SOAP::Trace->import('all');

    my $method = SOAP::Data->name('LockReadConfirmationsByMailout')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('mailoutid')->value($mailoutid)->type(''),
        SOAP::Data->name('leaseminutes')->value($leaseminutes)->type(''),
        SOAP::Data->name('maxrecords')->value($maxrecords)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    # <LockReadConfirmationsByMailoutResult>string</LockReadConfirmationsByMailoutResult>
    my ($batchid) = ($xml =~ /\<LockReadConfirmationsByMailoutResult\>(.*?)\<\/LockReadConfirmationsByMailoutResult\>/s);
    return $batchid;
}

sub GetLockedReadConfirmations {
    my ($self, $batchid) = @_;

    my $method = SOAP::Data->name('GetLockedReadConfirmations')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('batchid')->value($batchid)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    my @info;
    while ($xml =~ /(\<ReadConfirmationInfo\>(.*?)\<\/ReadConfirmationInfo\>)/g) {
        my $ob = XML::Bare->new(text => $1);
        my $root = $ob->parse();
        
        # fix XML::Bare ->{value}
        my $x = $root->{ReadConfirmationInfo};
        my %y;
        foreach (keys %$x) {
            next if (/^\_/); # _pos, _i
            $y{$_} = $x->{$_}->{value};
        }
        push @info, \%y;
    }

    return wantarray ? @info : \@info;
}

sub LockUrlClicks {
    my ($self, $leaseminutes, $maxrecords) = @_;

    my $method = SOAP::Data->name('LockUrlClicks')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('leaseminutes')->value($leaseminutes)->type(''),
        SOAP::Data->name('maxrecords')->value($maxrecords)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    # <LockUrlClicksResult>string</LockUrlClicksResult>
    my ($batchid) = ($xml =~ /\<LockUrlClicksResult\>(.*?)\<\/LockUrlClicksResult\>/s);
    return $batchid;
}

sub LockUrlClicksByMailout {
    my ($self, $mailoutid, $leaseminutes, $maxrecords) = @_;
    
    #SOAP::Trace->import('all');
    
    my $method = SOAP::Data->name('LockUrlClicksByMailout')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('mailoutid')->value($mailoutid)->type(''),
        SOAP::Data->name('leaseminutes')->value($leaseminutes)->type(''),
        SOAP::Data->name('maxrecords')->value($maxrecords)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    # <LockUrlClicksByMailoutResult>string</LockUrlClicksByMailoutResult>
    my ($batchid) = ($xml =~ /\<LockUrlClicksByMailoutResult\>(.*?)\<\/LockUrlClicksByMailoutResult\>/s);
    return $batchid;
}

sub GetLockedUrlClicks {
    my ($self, $batchid) = @_;

    my $method = SOAP::Data->name('GetLockedUrlClicks')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('batchid')->value($batchid)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;
    
    # to avoid taking too much memory
    $soap->outputxml(1);
    my $xml = $soap->call($method, $data, $soap_header);
    $soap->outputxml(0);
    
    my @info;
    while ($xml =~ /(\<ClickInfo\>(.*?)\<\/ClickInfo\>)/g) {
        my $ob = XML::Bare->new(text => $1);
        my $root = $ob->parse();
        
        # fix XML::Bare ->{value}
        my $x = $root->{ClickInfo};
        my %y;
        foreach (keys %$x) {
            next if (/^\_/); # _pos, _i
            $y{$_} = $x->{$_}->{value};
        }
        push @info, \%y;
    }

    return wantarray ? @info : \@info;
}

1;