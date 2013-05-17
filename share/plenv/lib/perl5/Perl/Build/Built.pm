package Perl::Build::Built;

use strict;
use warnings;
use utf8;

use 5.008002;
our $VERSION = '0.20';

use Carp ();
use File::Spec::Functions qw( catdir catfile );

sub run_env {
    my ( $self, @args ) = @_;
    my $config = {};
    if ( ref $args[0] eq 'HASH' ) {
        $config = %{ shift @args };
    }
    if ( $args[0] and ref $args[0] eq 'CODE' ) {
        $config->{code} = shift @args;
    }
    if (@args) {
        Carp::croak( '->run_env(\%config,\&code)'
              . ' or ->run_env(\&code)'
              . ' or ->run_env(\%config)' );
    }
    local $ENV{PATH}    = $self->combined_bin_path;
    local $ENV{MANPATH} = $self->combined_man_path;
    delete local $ENV{PERL5LIB};
    return $config->{code}->();
}

sub new {
    my ( $self, $args ) = @_;
    $args = {} unless defined $args;
    Carp::croak '->new(\%config) required' if not ref $args eq 'HASH';
    Carp::croak 'installed_path is a mandatory parameter'
      unless exists $args->{installed_path};
    return bless $args, $self;
}

sub installed_path {
    return $_[0]->{installed_path};
}

sub bin_path {
    return catdir( $_[0]->{installed_path}, 'bin' );
}

sub man_path {
    return catdir( $_[0]->{installed_path}, 'man' );
}

sub combined_bin_path {
    return $_[0]->bin_path . ':' . $ENV{PATH};
}

sub combined_man_path {
    if ( -d $_[0]->man_path ) {
        return $_[0]->man_path . ':' . $ENV{MANPATH};
    }
    return $ENV{MANPATH};
}

1;

__END__

=pod

=encoding utf8

=for stopwords dir

=head1 NAME

Perl::Build::Built - A utility class to work with recently built perl installs.

=head1 SYNOPSIS

    my $result = Perl::Build->install( ... );
    $result->run_env(sub{
        # Run code on the installed perl
        system('perl', .... );
    });

=head1 METHODS

=over 4

=item $instance->run_env(\&code)

Run C<&code> inside an environment configured to use the built perl.

    $instance->run_env(sub{
        my $cpanm_path = catfile( $instance->bin_path , 'cpanm' );
        system('wget','-O', $cpanm_path, 'http://path/to/cpanm');
        system('chmod', 'u+x', $cpanm_path );
        system('cpanm', "App::cpanoutdated");
        system('perl',.... );
    });

=item Perl::Build::Built->new( \%params )

You probably don't need to call this, ever.

=item $instance->installed_path

Returns the path the Perl was installed to ( Just whatever was passed to C<new> )

=item $instance->bin_path

Returns the path to the 'bin' dir inside the installed Perl target directory.

=item $instance->man_path

Returns the path to the 'man' dir inside the installed Perl target directory.

=item $instance->combined_bin_path

C<bin_path> prefixed onto C<$ENV{PATH}>

=item $instance->combined_man_path

C<man_path> prefixed onto C<$ENV{MANPATH}>

=back

=head1 AUTHOR

=over 4

=item Kent Fredric E<lt>kentnl@cpan.orgE<gt>

=item Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=back

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

