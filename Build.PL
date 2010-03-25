use Module::Build;
use inc::latest 'local::lib';

for my $mod ( inc::latest->loaded_modules ) {
    inc::latest->bundle_module( $mod, 'inc' );
}

if (eval "use Pod::Markdown;1") {
    my $parser = Pod::Markdown->new;
    $parser->parse_from_file('plenv');
    open my $fh, '>', 'README.mkdn' or die "$!";
    print $fh $parser->as_markdown;
    close $fh or die $!;
}

my $build = Module::Build->new(
    module_name          => 'App::plenv',
    build_requires       => { 'Test::More' => 0, },
    requries             => {},
    recommends           => {},
    recursive_test_files => 1,
    sign                 => 0,
    create_license       => 1,
    license              => 'artistic_2',
    dist_author          => 'Tokuhiro Matsuno <tokuhirom gmail.com>',
    create_makefile_pl   => 1,
    script_files         => 'plenv',
);
$build->create_build_script;
