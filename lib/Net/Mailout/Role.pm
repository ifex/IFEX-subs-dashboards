package Net::Mailout::Role;

use Moose::Role;
use SOAP::Lite;
use Carp;

has 'user'  => ( is => 'rw', required => 1 );
has 'pass'  => ( is => 'rw', required => 1 );
has 'proxy' => ( is => 'ro', required => 1 );
has 'xmlns' => ( is => 'ro', required => 1 );

has 'soap' => (
    is => 'rw',
    lazy_build => 1
);

sub _build_soap {
    my ($self) = @_;
    
    return SOAP::Lite
        ->proxy( $self->proxy )
        ->on_action( sub {sprintf '%s/%s', @_} )
        ->uri( $self->xmlns );
}

has 'soap_header' => (
    is => 'rw',
    lazy_build => 1
);

sub _build_soap_header {
    my ($self) = @_;

    my $soap = $self->soap;
    my $method = SOAP::Data->name('Login')->attr({xmlns => $self->xmlns});
    my $result = $soap->call( $method, 
        SOAP::Data->name('username')->value($self->user)->type(''),
        SOAP::Data->name('password')->value($self->pass)->type('')
    )->result;
    
    unless ($result->{Success} eq 'true') {
        croak $result->{ErrorMessages}->{string};
    }
    
    return SOAP::Header->name('SessionHeader')->attr(
        {xmlns => $self->xmlns},
        \SOAP::Header->value(
            SOAP::Header->name('SessionID')->value($result->{SessionID})->type(''),
            SOAP::Header->name('ServerUrl')->value($result->{ServerUrl})->type('')
        )
    );
}

no Moose::Role;

1;