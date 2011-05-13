package Dashboard::Controller::Campaigns;

use Moose;
use namespace::autoclean;
use Data::Dump 'dump';

BEGIN { extends 'Catalyst::Controller' }

sub default :Path {
    my ( $self, $c, $list_id ) = @_;
    
    my $schema = $c->model('DBIC')->schema;
    my $list = $schema->resultset('List')->find($list_id);
    return $c->res->body("Unknown list_id") unless $list;
    $c->stash->{list} = $list;
    
    # prepare site for nav
    $c->controller('Site')->prepare_site($c, $list->site_id);
    $c->stash->{is_in_campaign} = 1;
    
    my $month = $c->req->param('month');
    my $stats = $schema->resultset('Campaign')->basic_stats($list_id, $month);
    $c->stash( %$stats );
}

__PACKAGE__->meta->make_immutable;

1;
__END__
