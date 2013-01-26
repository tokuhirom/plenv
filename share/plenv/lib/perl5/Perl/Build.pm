package Perl::Build;
use strict;
use warnings;
use utf8;

use 5.008005;
our $VERSION = '0.03';

use File::Basename;
use File::Spec::Functions qw(catfile catdir rel2abs);
use CPAN::Perl::Releases;
use File::pushd qw(pushd);
use File::Temp;

our $CPAN_MIRROR = $ENV{PERL_BUILD_CPAN_MIRROR} || 'http://search.cpan.org/CPAN';

sub available_perls {
    my ( $class, $dist ) = @_;

    my $url = "http://www.cpan.org/src/README.html";
    my $html = http_get( $url, undef, undef );

    unless($html) {
        die "\nERROR: Unable to retrieve the list of perls.\n\n";
    }

    my @available_versions;

    for ( split "\n", $html ) {
        push @available_versions, $1
          if m|<td><a href="http://www.cpan.org/src/.+?">(.+?)</a></td>|;
    }
    s/\.tar\.gz// for @available_versions;

    return @available_versions;
}

# taken from App::perlbrew.pm
{
    my @command;
    sub http_get {
        my ($url, $header, $cb) = @_;

        if (ref($header) eq 'CODE') {
            $cb = $header;
            $header = undef;
        }

        if (! @command) {
            my @commands = (
                # curl's --fail option makes the exit code meaningful
                [qw( curl --silent --location --fail --insecure )],
                [qw( fetch -o - )],
                [qw( wget --no-check-certificate --quiet -O - )],
            );
            for my $command (@commands) {
                my $program = $command->[0];
                my $code = system("$program --version >/dev/null 2>&1") >> 8;
                if ($code != 127) {
                    @command = @$command;
                    last;
                }
            }
            die "You have to install either curl or wget\n"
                unless @command;
        }

        open my $fh, '-|', @command, $url
            or die "open() for '@command $url': $!";

        local $/;
        my $body = <$fh>;
        close $fh;
        die 'Page not retrieved; HTTP error code 400 or above.'
            if $command[0] eq 'curl' # Exit code is 22 on 404s etc
            and $? >> 8 == 22; # exit code is packed into $?; see perlvar
        die 'Page not retrieved: fetch failed.'
            if $command[0] eq 'fetch' # Exit code is not 0 on error
            and $?;
        die 'Server issued an error response.'
            if $command[0] eq 'wget' # Exit code is 8 on 404s etc
            and $? >> 8 == 8;

        return $cb ? $cb->($body) : $body;
    }
}

# @return extracted source directory
sub extract_tarball {
    my ($class, $dist_tarball, $destdir) = @_;

    # Was broken on Solaris, where GNU tar is probably
    # installed as 'gtar' - RT #61042
    my $tarx =
        ($^O eq 'solaris' ? 'gtar ' : 'tar ') .
        ( $dist_tarball =~ m/bz2$/ ? 'xjf' : 'xzf' );
    my $extract_command = "cd @{[ $destdir ]}; $tarx @{[ File::Spec->rel2abs($dist_tarball) ]}";
    system($extract_command) == 0
        or die "Failed to extract $dist_tarball";
    $dist_tarball =~ s{(?:.*/)?([^/]+)\.tar\.(?:gz|bz2)$}{$1};
    return "$destdir/$dist_tarball"; # Note that this is incorrect for blead
}

sub perl_release {
    my ($class, $version) = @_;

    # TODO: switch to metacpan API?
    my $tarballs = CPAN::Perl::Releases::perl_tarballs($version);

    my $x = (values %$tarballs)[0];

    if ($x) {
        my $dist_tarball = (split("/", $x))[-1];
        my $dist_tarball_url = $CPAN_MIRROR . "/authors/id/$x";
        return ($dist_tarball, $dist_tarball_url);
    }

    my $html = http_get("http://search.cpan.org/dist/perl-${version}");

    unless ($html) {
        die "ERROR: Failed to download perl-${version} tarball.";
    }

    my ($dist_path, $dist_tarball) =
        $html =~ m[<a href="(/CPAN/authors/id/.+/(perl-${version}.tar.(gz|bz2)))">Download</a>];
    die "ERROR: Cannot find the tarball for perl-$version\n"
        if !$dist_path and !$dist_tarball;
    my $dist_tarball_url = "http://search.cpan.org${dist_path}";
    return ($dist_tarball, $dist_tarball_url);
}

sub http_mirror {
    my ($class, $url, $path, $on_error) = @_;

    my $header = undef;

    open my $BALL, ">", $path or die "Failed to open $path for writing.\n";

    http_get(
        $url,
        $header,
        sub {
            my ($body) = @_;

            unless ($body) {
                if (ref($on_error) eq 'CODE') {
                    $on_error->($url);
                }
                else {
                    die "ERROR: Failed to download $url.\n"
                }
            }


            print $BALL $body;
        }
    );
    close $BALL;
}

sub install_from_cpan {
    my ($class, $version, %args) = @_;

    my $tarball_dir = $args{tarball_dir}
        || File::Temp::tempdir( CLEANUP => 1 );
    my $build_dir = $args{build_dir}
        || File::Temp::tempdir( CLEANUP => 1 );
    my $dst_path = $args{dst_path}
        or die "Missing mandatory parameter: dst_path";
    my $configure_options = $args{configure_options}
        || ['-de'];

    # download tar ball
    my ($dist_tarball, $dist_tarball_url) = Perl::Build->perl_release($version);
    my $dist_tarball_path = catfile($tarball_dir, $dist_tarball);
    if (-f $dist_tarball_path) {
        print "Use the previously fetched ${dist_tarball}\n";
    }
    else {
        print "Fetching $version as $dist_tarball_path\n";
        Perl::Build->http_mirror( $dist_tarball_url, $dist_tarball_path );
    }

    # and extract tar ball.
    my $dist_extracted_path = Perl::Build->extract_tarball($dist_tarball_path, $build_dir);
    Perl::Build->install(
        src_path          => $dist_extracted_path,
        dst_path          => $dst_path,
        configure_options => $configure_options,
        patchperl         => $args{patchperl},
        test              => $args{test},
    );
}

sub install_from_tarball {
    my ($class, $dist_tarball_path, %args) = @_;

    my $build_dir = $args{build_dir}
        || File::Temp::tempdir( CLEANUP => 1 );
    my $dst_path = $args{dst_path}
        or die "Missing mandatory parameter: dst_path";
    my $configure_options = $args{configure_options}
        || ['-de'];

    my $dist_extracted_path = Perl::Build->extract_tarball($dist_tarball_path, $build_dir);
    Perl::Build->install(
        src_path          => $dist_extracted_path,
        dst_path          => $dst_path,
        configure_options => $configure_options,
        patchperl         => $args{patchperl},
        test              => $args{test},
    );
}

sub install {
    my ($class, %args) = @_;

    my $src_path = $args{src_path}
        or die "Missing mandatory parameter: src_path";
    my $dst_path = $args{dst_path}
        or die "Missing mandatory parameter: dst_path";
    my $configure_options = $args{configure_options}
        or die "Missing mandatory parameter: configure_options";
    my $patchperl = $args{patchperl} || 'patchperl';

    unshift @$configure_options, qq(-Dprefix=$dst_path);

    # clean up environment
    delete $ENV{$_} for qw(PERL5LIB PERL5OPT);

    {
        my $dir = pushd($src_path);

        # clean up
        $class->do_system("rm -f config.sh Policy.sh");

        # apply patches
        $class->do_system($patchperl || 'patchperl');

        # configure
        $class->do_system(['sh', 'Configure', @$configure_options]);
        # patch for older perls
        # XXX is this needed? patchperl do this?
        # if (Perl::Build->perl_version_to_integer($dist_version) < Perl::Build->perl_version_to_integer( '5.8.9' )) {
        #     $class->do_system("$^X -i -nle 'print unless /command-line/' makefile x2p/makefile");
        # }

        # build
        $class->do_system('make');
        if ($args{test}) {
            $class->do_system('make test');
        }
        $class->do_system('make install');
    }
}

sub do_system {
    my ($class, $cmd) = @_;

    if (ref $cmd eq 'ARRAY') {
        $class->info(join(' ', @$cmd));
        system(@$cmd) == 0
            or die "Installation failure: @$cmd";
    } else {
        $class->info($cmd);
        system($cmd) == 0
            or die "Installation failure: $cmd";
    }
}

sub symlink_devel_executables {
    my ($class, $bin_dir) = @_;

    for my $executable (glob("$bin_dir/*")) {
        my ($name, $version) = $executable =~ m/bin\/(.+?)(5\.\d.*)?$/;
        if ($version) {
            my $cmd = "ln -fs $executable $bin_dir/$name";
            $class->info($cmd);
            system($cmd);
        }
    }
}

sub info {
    my ($class, @msg) = @_;
    print @msg, "\n";
}

1;
__END__

=encoding utf8

=head1 NAME

Perl::Build - perl builder

=head1 SYNOPSIS

    # install perl from CPAN
    Perl::Build->install_from_cpan(
        '5.16.2' => (
            dst_path          => '/path/to/perl-5.16.2/',
            configure_options => ['-des'],
        )
    );

    # install perl from tar ball
    Perl::Build->install_from_cpan(
        'path/to/perl-5.16.2.tar.gz' => (
            dst_path          => '/path/to/perl-5.16.2/',
            configure_options => ['-des'],
        )
    );

=head1 DESCRIPTION

This is yet another perl builder module.

B<THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE>.

=head1 METHODS

=over 4

=item Perl::Build->install_from_cpan($version, %args)

Install $version perl from CPAN. This method fetches tar ball from CPAN, build, and install it.

You can pass following options in %args.

=over 4

=item dst_path

Destination directory to install perl.

=item configure_options : ArrayRef(Optional)

Command line arguments for ./Configure.

(Default: ['-de'])

=item tarball_dir(Optional)

Temporary directory to put tar ball.

=item build_dir(Optional)

Temporary directory to build binary.

=item patchperl(Optional)

Path to L<patchperl>. patchperl is a patch set for older perls.

(Default: 'patchperl')

=back

=item Perl::Build->install_from_tarball($dist_tarball_path, %args)

Install perl from tar ball. This method extracts tar ball, build, and install.

You can pass following options in %args.

=over 4

=item dst_path(Required)

Destination directory to install perl.

=item configure_options : ArrayRef(Optional)

Command line arguments for ./Configure.

(Default: ['-de'])

=item build_dir(Optional)

Temporary directory to build binary.

=item patchperl(Optional)

Path to L<patchperl>. patchperl is a patch set for older perls.

(Default: 'patchperl')

=back

=item Perl::Build->install(%args)

Build and install Perl5 from extracted source directory.

=over 4

=item src_path(Required)

Source code directory to build.  That contains extracted Perl5 source code.

=item dst_path(Required)

Destination directory to install perl.

=item configure_options : ArrayRef(Optional)

Command line arguments for ./Configure.

(Default: ['-de'])

=item patchperl(Optional)

Path to L<patchperl>. patchperl is a patch set for older perls.

(Default: 'patchperl')

=item test: Bool(Optional)

If you set this value as true, Perl::Build runs C<< make test >> after building.

(Default: 0)

=back

=item Perl::Build->symlink_devel_executables($bin_dir:Str)

Perl5 binary generated with C< -Dusedevel >, is "perl-5.12.2" form. This method symlinks "perl-5.12.2" to "perl".

=back

=head1 THANKS TO

most of the code was taken from L<App::perlbrew>.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>


=head1 LICENSE

This software takes most of the code from L<App::perlbrew>.

Perl::Build uses same license with perlbrew.

