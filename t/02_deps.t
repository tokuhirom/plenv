use strict;
use warnings;
use utf8;
use Test::More;

BEGIN {
    plan skip_all => 'Do not run this test case without carton dir' unless -d 'share/plenv/lib/perl5';
}

use lib::core::only;
use lib 'lib';
use lib 'share/plenv/lib/perl5/';

use_ok 'Devel::PatchPerl';
use_ok 'App::plenv';
use_ok 'Module::Metadata';
note "version: $version::VERSION";

done_testing;

