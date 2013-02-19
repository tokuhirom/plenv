use strict;
use warnings;
use utf8;
use lib::core::only;
use lib 'lib';
use lib 'share/plenv/lib/perl5/';
use Test::More;

use_ok 'Devel::PatchPerl';
use_ok 'App::plenv';
use_ok 'IPC::Cmd';
use_ok 'Module::Metadata';
note "version: $version::VERSION";

done_testing;

