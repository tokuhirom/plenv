use strict;
use warnings;
use lib 'inc';
use Module::Build::Pluggable (
    '+Module::Build::Pluggable::Carton',
);

my $build = Module::Build::Pluggable->new(
    license              => 'perl',
    dynamic_config       => 0,

    build_requires       => {
        'Test::More' => '0.98',
        'Test::Requires' => 0,
    },
    configure_requires   => {
        'Module::Build' => '0.38',
        'Module::Build::Pluggable' => '0.04',
    },
    requires             => {
        perl => '5.008005',
        'Perl::Build' => '0.01',
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'App-plenv',
    module_name => 'App::plenv',

    script_files => ['bin/plenv'],

    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
   
    create_readme  => 1,
    create_license => 1,
);
$build->create_build_script();
