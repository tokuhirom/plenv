use Test::More;
eval "use Test::MinimumVersion 0.101080";
plan skip_all => "Test::Minimumversion required for testing perl minimum version" if $@;
all_minimum_version_from_metayml_ok();
