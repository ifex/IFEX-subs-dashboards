package Subscriber::Schema::Result::Site;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Subscriber::Schema::Result::Site

=cut

__PACKAGE__->table("site");

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
  size: 24

=head2 domain

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 32

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
    size => 24,
  },
  "domain",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("domain", ["domain"]);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-03-27 07:39:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eexGU8eOq5gmP6D7A+srUg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
