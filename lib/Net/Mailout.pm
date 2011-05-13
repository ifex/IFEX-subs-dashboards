package Net::Mailout;

use Moose;
use Net::Mailout::SubscriberManager;
use Net::Mailout::MailoutReporter;
use Net::Mailout::MailoutManager;

has 'user' => ( is => 'rw', required => 1 );
has 'pass' => ( is => 'rw', required => 1 );

has 'SubscriberManager' => (
    is => 'ro',
    lazy_build => 1
);
sub _build_SubscriberManager {
    my $self = shift;
    
    Net::Mailout::SubscriberManager->new(
        user => $self->user,
        pass => $self->pass
    );
}

has 'MailoutReporter' => (
    is => 'ro',
    lazy_build => 1
);
sub _build_MailoutReporter {
    my $self = shift;
    
    Net::Mailout::MailoutReporter->new(
        user => $self->user,
        pass => $self->pass
    );
}

has 'MailoutManager' => (
    is => 'ro',
    lazy_build => 1
);
sub _build_MailoutManager {
    my $self = shift;
    
    Net::Mailout::MailoutManager->new(
        user => $self->user,
        pass => $self->pass
    );
}

1;