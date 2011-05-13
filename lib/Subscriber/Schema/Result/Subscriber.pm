package Subscriber::Schema::Result::Subscriber;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Subscriber::Schema::Result::Subscriber

=cut

__PACKAGE__->table("subscriber");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  extra: HASH(0x20ef460)
  is_auto_increment: 1
  is_nullable: 0
  size: 11

=head2 email

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 64

=head2 active

  data_type: TINYINT
  default_value: undef
  is_nullable: 0
  size: 4

=head2 first_name

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 96

=head2 last_name

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 96

=head2 created

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

=head2 modified

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

=head2 source

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 24

=head2 country

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 48

=head2 text_only

  data_type: TINYINT
  default_value: undef
  is_nullable: 0
  size: 1

=head2 occupation

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 64

=head2 list_id

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
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "active",
  { data_type => "TINYINT", default_value => undef, is_nullable => 0, size => 4 },
  "first_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 96,
  },
  "last_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 96,
  },
  "created",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "modified",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "source",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 24,
  },
  "country",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 48,
  },
  "text_only",
  { data_type => "TINYINT", default_value => undef, is_nullable => 0, size => 1 },
  "occupation",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "list_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "site_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("email", ["email", "list_id"]);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-06-16 01:28:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fnk4VpUaSC+D/+iaRsgC3g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
