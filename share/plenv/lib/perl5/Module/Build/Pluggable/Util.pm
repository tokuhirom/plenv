package Module::Build::Pluggable::Util;
use strict;
use warnings;
use utf8;

# copied from M::B::Base
sub add_prereqs {
    my ( $class, $builder, $type, $module, $version ) = @_;
    my $p = $builder->{properties};
    $version = 0 unless defined $version;
    if ( exists $p->{$type}{$module} ) {
        return
          if $builder->compare_versions( $version, '<=', $p->{$type}{$module} );
    }
    $builder->log_verbose("Adding to $type\: $module => $version\n");
    $p->{$type}{$module} = $version;
    return 1;
}

1;

