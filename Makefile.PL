#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Dashboard';
all_from 'lib/Dashboard.pm';

requires 'Catalyst::Runtime' => '5.80021';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'YAML::XS';
requires 'DBIx::Class';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Template';
requires 'XML::Bare';
requires 'SOAP::Lite';
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
