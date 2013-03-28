requires 'Perl::Build', '0.10';
requires 'Pod::Find' => 0;
requires 'Pod::Usage' => 0;
requires 'App::cpanminus' => 0;
requires 'Devel::PatchPerl' => '0.84'; # no IPC::Cmd

on 'configure' => sub {
    requires 'Module::Build' => '0.38';
    requires 'Module::Build::Pluggable' => '0.05';
};

on 'build' => sub {
    requires 'Test::More' => '0.98';
    requires 'Test::Requires' => 0;
    requires 'lib::core::only' => 0;
};
