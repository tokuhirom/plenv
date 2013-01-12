package Devel::PatchPerl::Plugin;
{
  $Devel::PatchPerl::Plugin::VERSION = '0.76';
}

#ABSTRACT: Devel::PatchPerl plugins explained

use strict;
use warnings;

qq[Plug it in];


__END__
=pod

=head1 NAME

Devel::PatchPerl::Plugin - Devel::PatchPerl plugins explained

=head1 VERSION

version 0.76

=head1 DESCRIPTION

This document explains the L<Devel::PatchPerl> plugin system.

Plugins are a mechanism for providing additional functionality to
L<Devel::PatchPerl>.

Plugins are searched for in the L<Devel::PatchPerl::Plugin> namespace.

=head1 INITIALISATION

The plugin constructor is C<patchperl>.

A plugin is specified using the C<PERL5_PATCHPERL_PLUGIN> environment
variable. It may either be specified in full (ie. C<Devel::PatchPerl::Plugin::Feegle>)
or as the short part (ie. C<Feegle>).

  $ export PERL5_PATCHPERL_PLUGIN=Devel::PatchPerl::Plugin::Feegle

  $ export PERL5_PATCHPERL_PLUGIN=Feegle

When L<Devel::PatchPerl> has identified the perl source patch and done its patching
it will attempt to load the plugin identified. It will then call the class method
C<patchperl> for the plugin package, with the following parameters:

  'version', the Perl version of the source tree;
  'source', the absolute path to the Perl source tree;
  'patchexe', the 'patch' utility that can be used;

Plugins are called with the current working directory being the root of the
Perl source tree, ie. C<source>.

Summarised:

  $ENV{PERL5_PATCHPERL_PLUGIN} = 'Devel::PatchPerl::Plugin::Feegle';

  my $plugin = $ENV{PERL5_PATCHPERL_PLUGIN};

  eval "require $plugin";

  eval {
    $plugin->patchperl( version => $vers, source => $srcdir, patchexe => $patch );
  };

=head1 WHAT CAN PLUGINS DO?

Anything you desire to a Perl source tree.

=head1 WHY USE AN ENVIRONMENT VARIABLE TO SPECIFY PLUGINS?

So that indicating a plugin to use can be specified independently of whatever mechanism is
calling L<Devel::PatchPerl> to do its bidding.

Think L<perlbrew>.

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Chris Williams and Marcus Holland-Moritz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

