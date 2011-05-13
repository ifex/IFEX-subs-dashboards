package Subscriber::Schema::Result::Campaign;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Subscriber::Schema::Result::Campaign

=cut

__PACKAGE__->table("campaigns");

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
  size: 128

=head2 created

  data_type: DATE
  default_value: undef
  is_nullable: 0
  size: 10

=head2 total_recipients

  data_type: INT
  default_value: 0
  extra: HASH(0x20e44c8)
  is_nullable: 0
  size: 11

=head2 site_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20e4f30)
  is_nullable: 0
  size: 11

=head2 list_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20ea438)
  is_nullable: 0
  size: 11

=head2 remote_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20cf4a0)
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
    size => 128,
  },
  "created",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "total_recipients",
  {
    data_type => "INT",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
  "site_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
  "list_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
  "remote_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-06-16 01:28:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Dm128a0+IxP9z2cj824jhg


__PACKAGE__->add_unique_constraint("remote_campaign_id", ["remote_id", "list_id", "site_id"]);

1;
