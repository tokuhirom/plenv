use strict;
use warnings;
use utf8;
use Test::More;
use File::stat;

plan skip_all => "It's only for developers" unless -d '.git';

ok(-x 'bin/plenv');

done_testing;

