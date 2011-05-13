#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Dashboard::Utils' }
Dashboard::Utils->import('config', 'schema');

my $cfg = config();
is $cfg->{name}, 'Dashboard';

my $schema = schema();
isa_ok($schema, 'Subscriber::Schema');

done_testing();

1;