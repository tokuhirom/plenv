package Test::Module::Build::Pluggable;
use strict;
use warnings;
use utf8;

use File::Temp qw/tempdir/;
use Cwd;
use Test::SharedFork;
use File::Basename ();
use File::Path ();

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;
    my $self = bless {
        %args
    }, $class;
    $self->{origcwd} = Cwd::getcwd();
    $self->{dir} = tempdir(CLEANUP => 1);
    $self->{libdir} = tempdir(CLEANUP => 1);
    unshift @INC, $self->{libdir};
    chdir $self->{dir};
    return $self;
}

sub DESTROY {
    my $self = shift;
    chdir($self->{origcwd});
}

sub write_plugin {
    my ($self, $package, $content) = @_;

    my $ofile = do {
        my $path = $package;
        $path =~ s!::!/!g;
        $path .= ".pm";
        File::Spec->catfile($self->{libdir}, $path);
    };
    File::Path::mkpath(File::Basename::dirname($ofile));
    open my $fh, '>', $ofile or die "Cannot open $ofile, $!";
    print {$fh} $content;
    close $fh;
}

sub write_file {
    my ($self, $fname, $content) = @_;

    if (my $dir = File::Basename::dirname($fname)) {
        File::Path::mkpath($dir);
    }

    open my $fh, '>', $fname or die "Cannot open $fname: $!";
    print $fh $content;
    close $fh;
}

sub read_file {
    my ($self, $fname) = @_;
    open my $fh, '<', $fname or die "Cannot open $fname: $!";
    local $/;
    scalar(<$fh>);
}

sub run_build_script {
    my $self = shift;

    my $pid = fork();
    die "fork failed: $!" unless defined $pid;
    if ($pid) { # parent
        waitpid $pid, 0;
    } else { # child
        do 'Build';
        ::ok(!$@) or ::diag $@;
        exit 0;
    }
}

sub run_build_pl {
    my ($self, @args) = @_;

    my $pid = fork();
    die "fork failed: $!" unless defined $pid;
    if ($pid) { # parent
        waitpid $pid, 0;
    } else { # child
        local @ARGV = @args;
        do 'Build.PL';
        ::ok(-f 'Build', 'Created Build file') or ::diag $@;
        exit 0;
    }
}

1;
__END__

=head1 NAME

Test::Module::Build::Pluggable - Test your plugin

=head1 SYNOPSIS

    my $test = Test::Module::Build::Pluggable->new();
    $test->write_file('Build.PL', <<'...');
    ...
    $test->run_build_pl();
    $test->run_build_script();
    # test...

