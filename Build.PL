use strict;
use warnings;
use lib 'inc';
use Module::Build::Pluggable (
    '+Module::Build::Pluggable::CPANfile',
);

my $build = Module::Build::Pluggable->new(
    license              => 'perl',
    dynamic_config       => 0,
    dist_abstract        => "Yet another Perl5 installation manager",
    dist_author          => "Tokuhiro Matsuno",

    requires             => {
        perl => '5.008005',
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'App-plenv',
    module_name => 'App::plenv',

    script_files => ['bin/plenv'],

    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    create_readme  => 0,
    create_license => 0,
);
$build->create_build_script();
