package Module::Build::Pluggable::Repository;
use strict;
use warnings;
use utf8;
use parent qw/Module::Build::Pluggable::Base/;

our $VERSION = '0.01';

sub _execute {
    my ($command) = @_;
    `$command`;
}

sub HOOK_configure {
    my $self = shift;
    my $repo = _find_repo(\&_execute);
    if ($repo) {
        $self->builder->meta_merge('resources', {'repository' => $repo});
    } else {
        $self->log_warn("Cannot determine repository URL\n");
    }
}

sub _find_repo {
    my ($execute) = @_;

    if (-e ".git") {
        # TODO support remote besides 'origin'?
        if ($execute->('git remote show -n origin') =~ /URL: (.*)$/m) {
            # XXX Make it public clone URL, but this only works with github
            my $git_url = $1;
            $git_url =~ s![\w\-]+\@([^:]+):!git://$1/!;
            return $git_url;
        } elsif ($execute->('git svn info') =~ /URL: (.*)$/m) {
            return $1;
        }
    } elsif (-e ".svn") {
        if (`svn info` =~ /URL: (.*)$/m) {
            return $1;
        }
    } elsif (-e "_darcs") {
        # defaultrepo is better, but that is more likely to be ssh, not http
        if (my $query_repo = `darcs query repo`) {
            if ($query_repo =~ m!Default Remote: (http://.+)!) {
                return $1;
            }
        }

        open my $handle, '<', '_darcs/prefs/repos' or return;
        while (<$handle>) {
            chomp;
            return $_ if m!^http://!;
        }
    } elsif (-e ".hg") {
        if ($execute->('hg paths') =~ /default = (.*)$/m) {
            my $mercurial_url = $1;
            $mercurial_url =~ s!^ssh://hg\@(bitbucket\.org/)!https://$1!;
            return $mercurial_url;
        }
    } elsif (-e "$ENV{HOME}/.svk") {
        # Is there an explicit way to check if it's an svk checkout?
        my $svk_info = `svk info` or return;
        SVK_INFO: {
            if ($svk_info =~ /Mirrored From: (.*), Rev\./) {
                return $1;
            }

            if ($svk_info =~ m!Merged From: (/mirror/.*), Rev\.!) {
                $svk_info = `svk info /$1` or return;
                redo SVK_INFO;
            }
        }

        return;
    }
}

1;
__END__

=head1 NAME

Module::Build::Pluggable::Repository - set repository information automatically

=head1 SYNOPSIS

    use Module::Build::Pluggable (
        'Repository'
    );

=head1 OPTIONS

There is no options.

=head1 AUTHORS

Ported to M::B::P by Tokuhiro Matsuno

Most of codes taken from L<Module::Install::Repository>

