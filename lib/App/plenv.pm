package App::plenv;
use strict;
use warnings;
use 5.008002;
our $VERSION = 'v1.6.0';



1;
__END__

=head1 NAME

App::plenv - perl binary manager

=head1 DESCRIPTION

See L<plenv>

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 SEE ALSO

L<App::perlbrew> provides same feature. But plenv provides project local file: B< .perl-version >.

Most of part was inspired from L<rbenv|https://github.com/sstephenson/rbenv>.

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
