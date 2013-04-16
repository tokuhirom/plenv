use strict;
use warnings;
use utf8;
use Test::More;
use File::stat;

ok(stat('bin/plenv')->mode & 0700);

done_testing;

