package Module::Build::Pluggable::Carton;
use strict;
use warnings;
use utf8;
use base qw(Module::Build::Pluggable::Base);

sub HOOK_build {
    my ($self) = @_;
    $self->add_action('carton', sub {
         system("carton install --path share/plenv/")
            == 0 or die "Cannot install dependent modules by carton";
    });
}

1;

