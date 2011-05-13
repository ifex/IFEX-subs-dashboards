#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Dashboard::Utils qw/schema/;

my $schema = schema();
$schema->resultset('CampaignSummary')->rebuild();

1;