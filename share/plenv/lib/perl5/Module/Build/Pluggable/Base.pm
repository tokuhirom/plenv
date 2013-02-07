package Module::Build::Pluggable::Base;
use strict;
use warnings;
use utf8;
use Class::Method::Modifiers qw/install_modifier/;
use Class::Accessor::Lite (
    ro => [qw/builder/]
);
use Module::Build::Pluggable::Util;

sub new {
    my $class = shift;
    my %args = @_;
    bless { %args }, $class;
}

sub builder_class {
    my $self = shift;
    my $builder = $self->builder;
       $builder = ref $builder if ref $builder;
    return $builder;
}

# build
sub add_before_action_modifier {
    my ($self, $target, $code) = @_;

    my $builder = $self->builder_class;
    unless ($builder) {
        Carp::confess("You can call add_before_action_modifier method from HOOK_build method only.");
    }

    install_modifier($builder, 'before', "ACTION_$target", $code);
}

# build
sub add_action {
    my ($self, $name, $code) = @_;
    my $builder = $self->builder_class;
    unless ($builder) {
        Carp::confess("You can call add_action method from HOOK_build method only.");
    }

    no strict 'refs';
    *{"$builder\::ACTION_$name"} = $code;
}

# configure
sub build_requires {
    my $self = shift;
    Module::Build::Pluggable::Util->add_prereqs($self->builder, 'build_requires', @_);
}

# configure
sub configure_requires {
    my $self = shift;
    Module::Build::Pluggable::Util->add_prereqs($self->builder, 'configure_requires', @_);
}

sub requires {
    my $self = shift;
    Module::Build::Pluggable::Util->add_prereqs($self->builder, 'requires', @_);
}

sub add_extra_compiler_flags {
    my ($self, @flags) = @_;
    $self->builder->extra_compiler_flags(@{$self->builder->extra_compiler_flags}, @flags);
}

sub log_warn { shift->builder->log_warn(@_) }
sub log_info { shift->builder->log_info(@_) }

# taken from  M::I::Can
# Check if we can run some command
sub can_run {
    my ($self, $cmd) = @_;
    require ExtUtils::MakeMaker;

    my $_cmd = $cmd;
    return $_cmd if (-x $_cmd or $_cmd = MM->maybe_command($_cmd));

    for my $dir ((split /$Config::Config{path_sep}/, $ENV{PATH}), '.') {
        next if $dir eq '';
        require File::Spec;
        my $abs = File::Spec->catfile($dir, $cmd);
        return $abs if (-x $abs or $abs = MM->maybe_command($abs));
    }

    return;
}

1;
__END__

=head1 NAME

Module::Build::Pluggable::Base - Base object for plugins

=head1 SYNOPSIS

    package My::Module::Build::Plugin;
    use parent qw/Module::Build::Pluggable::Base/;

=head1 DESCRIPTION

This is a abstract base class for Module::Build::Pluggable.

=head1 METHODS

=over 4

=item $self->builder_class() : Str

Get a class name for Module::Build's subclass.

You cannot call this method in C<HOOK_prepare> and B<HOOK_configure> phase.

=item $self->add_before_action_modifier($action_name: Str, $callback: Code)

    $self->add_before_action_modifier('build' => \&code);

Add a 'before' action method modifier.

You need to call this method in C<HOOK_build> phase.

=item $self->add_action($action_name: Str, $callback: Code)

Add a new action for Module::Build.

You need to call this method in C<HOOK_build> phase.

=item $self->build_requires($module_name:Str[, $version:Str])

Add a build dependencies.

You need to call this method in C<HOOK_configure> phase.

=item $self->configure_requires($module_name:Str[, $version:Str])

Add a configure dependencies.

You need to call this method in C<HOOK_configure> phase.

=item $self->log_info($msg: Str)

Output log in INFO level.

=item $self->log_warn($msg: Str)

Output log in WARN level.

=back

