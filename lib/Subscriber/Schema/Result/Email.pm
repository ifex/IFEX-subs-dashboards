package Subscriber::Schema::Result::Email;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Subscriber::Schema::Result::Email

=cut

__PACKAGE__->table("emails");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  is_auto_increment: 1
  is_nullable: 0
  size: 11

=head2 remote_id

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=head2 email

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 64

=head2 subscriber_id

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=head2 type

  data_type: TINYINT
  default_value: undef
  is_nullable: 0
  size: 1

=head2 site_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20ea630)
  is_nullable: 0
  size: 11

=head2 list_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20d6300)
  is_nullable: 0
  size: 11

=head2 created

  data_type: DATE
  default_value: undef
  is_nullable: 0
  size: 10

=head2 campaign_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20ea210)
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
  "remote_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "subscriber_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "type",
  { data_type => "TINYINT", default_value => undef, is_nullable => 0, size => 1 },
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
  "created",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "campaign_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("remote_id", ["remote_id"]);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-06-16 01:28:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+cxh9oUD8iRr5XDPi5quJQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
