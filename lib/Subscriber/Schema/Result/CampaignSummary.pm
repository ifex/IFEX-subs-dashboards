package Subscriber::Schema::Result::CampaignSummary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Subscriber::Schema::Result::CampaignSummary

=cut

__PACKAGE__->table("campaign_summary");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  is_auto_increment: 1
  is_nullable: 0
  size: 11

=head2 campaign_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20d3228)
  is_nullable: 0
  size: 11

=head2 type

  data_type: TINYINT
  default_value: undef
  is_nullable: 0
  size: 1

=head2 mon

  data_type: DATE
  default_value: undef
  is_nullable: 0
  size: 10

=head2 num

  data_type: INT
  default_value: undef
  extra: HASH(0x20cf5c0)
  is_nullable: 0
  size: 11

=head2 total

  data_type: INT
  default_value: undef
  extra: HASH(0x20d2590)
  is_nullable: 0
  size: 11

=head2 list_id

  data_type: INT
  default_value: undef
  extra: HASH(0x20d19c0)
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
  "campaign_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
  "type",
  { data_type => "TINYINT", default_value => undef, is_nullable => 0, size => 1 },
  "mon",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 10 },
  "num",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 0,
    size => 11,
  },
  "total",
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
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("mon", ["campaign_id", "type", "mon"]);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-06-16 01:28:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JrKuO5gmAB8bKIp/iQ/YZQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
