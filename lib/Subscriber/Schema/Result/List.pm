package Subscriber::Schema::Result::List;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Subscriber::Schema::Result::List

=cut

__PACKAGE__->table("list");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  is_auto_increment: 1
  is_nullable: 0
  size: 11

=head2 name

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 64

=head2 remote_id

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=head2 site_id

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INT",
    default_value => undef,
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "remote_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "site_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-03-27 07:21:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1/aaaFS6AksoP4iRmd8I6w


__PACKAGE__->add_unique_constraint("remote_site_id", ["remote_id", "site_id"]);
1;
