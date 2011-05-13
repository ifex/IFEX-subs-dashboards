package Net::Mailout::MailoutManager;

use Moose;
use XML::Bare;
use Carp;

with 'Net::Mailout::Role';

has '+proxy' => ( default => 'http://www.mymailout.net/Industry/WebService/MailoutManager.asmx' );
has '+xmlns' => ( default => 'http://www.mymailout.net/WebService/MailoutManager' );

sub GetMailouts {
    my ($self, $mailinglistid) = @_;

    #SOAP::Trace->import('all');

    my $method = SOAP::Data->name('GetMailouts')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('mailinglistid')->value($mailinglistid)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;

    my $result = $soap->call($method, $data, $soap_header)->result;
    return $result;
}

sub GetSummaryReport {
    my ($self, $mailoutid) = @_;
    
    my $method = SOAP::Data->name('GetSummaryReport')->attr({xmlns => $self->xmlns});
    my $data = SOAP::Data->value(
        SOAP::Data->name('mailoutid')->value($mailoutid)->type('')
    );
    
    my $soap = $self->soap;
    my $soap_header = $self->soap_header;

    my $result = $soap->call($method, $data, $soap_header)->result;
    return $result;
}

1;