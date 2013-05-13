requires 'Perl::Build', '0.13';
requires 'Pod::Find' => 0;
requires 'Pod::Usage' => 0;
requires 'App::cpanminus' => 0;
requires 'Getopt::Long';
requires 'Devel::PatchPerl' => '0.86'; # no IPC::Cmd, fix CVE-2013-1667 patch

on 'configure' => sub {
    requires 'Module::Build' => '0.38';
};

on 'build' => sub {
    requires 'Test::More' => '0.98';
    requires 'Test::Requires' => 0;
    requires 'lib::core::only' => 0;
};

on 'development' => sub [
    requires 'App::cpanminus', 1.6914; # --pure-perl
};
