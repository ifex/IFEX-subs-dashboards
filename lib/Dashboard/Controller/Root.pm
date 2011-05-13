package Dashboard::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # get all sites
    $c->stash->{site_rs} = $c->model('DBIC')->schema->resultset('Site');
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;

}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Dashboard::Controller::Root - Root Controller for Dashboard

=head1 DESCRIPTION

=head1 AUTHOR

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

