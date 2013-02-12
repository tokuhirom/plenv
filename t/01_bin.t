use strict;
use warnings;
use utf8;
use Test::More;

is(system('perl -wc bin/plenv'), 0);

done_testing;

