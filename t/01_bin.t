use strict;
use warnings;
use utf8;
use Test::More;

is(system('perl -wc script/plenv'), 0);

done_testing;

