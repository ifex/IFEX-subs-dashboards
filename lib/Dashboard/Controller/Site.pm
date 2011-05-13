package Dashboard::Controller::Site;

use Moose;
use namespace::autoclean;
use Data::Dump 'dump';

BEGIN { extends 'Catalyst::Controller' }

sub default :Path {
    my ( $self, $c, $site_id ) = @_;
    
    my $st = $self->prepare_site($c, $site_id);
    return $c->res->body("Unknown site_id") unless $st;
    
    my $month = $c->req->param('month');
    my $schema = $c->model('DBIC')->schema;
    my $stats = $schema->resultset('Subscriber')->basic_stats($site_id, 0, $month);
    $c->stash( %$stats );
}

sub prepare_site {
    my ($self, $c, $site_id) = @_;
    
    my $schema = $c->model('DBIC')->schema;
    my $site = $schema->resultset('Site')->find($site_id);
    return 0 unless $site;
    $c->stash->{site}  = $site;
    $c->stash->{lists} = [ $schema->resultset('List')->all ];
    
    return 1;
}
    

__PACKAGE__->meta->make_immutable;

1;
__END__
