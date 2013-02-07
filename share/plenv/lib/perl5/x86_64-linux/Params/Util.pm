package Params::Util;

=pod

=head1 NAME

Params::Util - Simple, compact and correct param-checking functions

=head1 SYNOPSIS

  # Import some functions
  use Params::Util qw{_SCALAR _HASH _INSTANCE};
  
  # If you are lazy, or need a lot of them...
  use Params::Util ':ALL';
  
  sub foo {
      my $object  = _INSTANCE(shift, 'Foo') or return undef;
      my $image   = _SCALAR(shift)          or return undef;
      my $options = _HASH(shift)            or return undef;
      # etc...
  }

=head1 DESCRIPTION

C<Params::Util> provides a basic set of importable functions that makes
checking parameters a hell of a lot easier

While they can be (and are) used in other contexts, the main point
behind this module is that the functions B<both> Do What You Mean,
and Do The Right Thing, so they are most useful when you are getting
params passed into your code from someone and/or somewhere else
and you can't really trust the quality.

Thus, C<Params::Util> is of most use at the edges of your API, where
params and data are coming in from outside your code.

The functions provided by C<Params::Util> check in the most strictly
correct manner known, are documented as thoroughly as possible so their
exact behaviour is clear, and heavily tested so make sure they are not
fooled by weird data and Really Bad Things.

To use, simply load the module providing the functions you want to use
as arguments (as shown in the SYNOPSIS).

To aid in maintainability, C<Params::Util> will B<never> export by
default.

You must explicitly name the functions you want to export, or use the
C<:ALL> param to just have it export everything (although this is not
recommended if you have any _FOO functions yourself with which future
additions to C<Params::Util> may clash)

=head1 FUNCTIONS

=cut

use 5.00503;
use strict;
require overload;
require Exporter;
require Scalar::Util;
require DynaLoader;

use vars qw{$VERSION @ISA @EXPORT_OK %EXPORT_TAGS};

$VERSION   = '1.07';
@ISA       = qw{
	Exporter
	DynaLoader
};
@EXPORT_OK = qw{
	_STRING     _IDENTIFIER
	_CLASS      _CLASSISA   _SUBCLASS  _DRIVER  _CLASSDOES
	_NUMBER     _POSINT     _NONNEGINT
	_SCALAR     _SCALAR0
	_ARRAY      _ARRAY0     _ARRAYLIKE
	_HASH       _HASH0      _HASHLIKE
	_CODE       _CODELIKE
	_INVOCANT   _REGEX      _INSTANCE  _INSTANCEDOES
	_SET        _SET0
	_HANDLE
};
%EXPORT_TAGS = ( ALL => \@EXPORT_OK );

eval {
	local $ENV{PERL_DL_NONLAZY} = 0 if $ENV{PERL_DL_NONLAZY};
	bootstrap Params::Util $VERSION;
	1;
} unless $ENV{PERL_PARAMS_UTIL_PP};

# Use a private pure-perl copy of looks_like_number if the version of
# Scalar::Util is old (for whatever reason).
my $SU = eval "$Scalar::Util::VERSION" || 0;
if ( $SU >= 1.18 ) { 
	Scalar::Util->import('looks_like_number');
} else {
	eval <<'END_PERL';
sub looks_like_number {
	local $_ = shift;

	# checks from perlfaq4
	return 0 if !defined($_);
	if (ref($_)) {
		return overload::Overloaded($_) ? defined(0 + $_) : 0;
	}
	return 1 if (/^[+-]?[0-9]+$/); # is a +/- integer
	return 1 if (/^([+-]?)(?=[0-9]|\.[0-9])[0-9]*(\.[0-9]*)?([Ee]([+-]?[0-9]+))?$/); # a C float
	return 1 if ($] >= 5.008 and /^(Inf(inity)?|NaN)$/i) or ($] >= 5.006001 and /^Inf$/i);

	0;
}
END_PERL
}





#####################################################################
# Param Checking Functions

=pod

=head2 _STRING $string

The C<_STRING> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a normal non-false string of non-zero length.

Note that this will NOT do anything magic to deal with the special
C<'0'> false negative case, but will return it.

  # '0' not considered valid data
  my $name = _STRING(shift) or die "Bad name";
  
  # '0' is considered valid data
  my $string = _STRING($_[0]) ? shift : die "Bad string";

Please also note that this function expects a normal string. It does
not support overloading or other magic techniques to get a string.

Returns the string as a conveince if it is a valid string, or
C<undef> if not.

=cut

eval <<'END_PERL' unless defined &_STRING;
sub _STRING ($) {
	(defined $_[0] and ! ref $_[0] and length($_[0])) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _IDENTIFIER $string

The C<_IDENTIFIER> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a string that is a valid Perl identifier.

Returns the string as a convenience if it is a valid identifier, or
C<undef> if not.

=cut

eval <<'END_PERL' unless defined &_IDENTIFIER;
sub _IDENTIFIER ($) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^[^\W\d]\w*\z/s) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _CLASS $string

The C<_CLASS> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a string that is a valid Perl class.

This function only checks that the format is valid, not that the
class is actually loaded. It also assumes "normalised" form, and does
not accept class names such as C<::Foo> or C<D'Oh>.

Returns the string as a convenience if it is a valid class name, or
C<undef> if not.

=cut

eval <<'END_PERL' unless defined &_CLASS;
sub _CLASS ($) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^[^\W\d]\w*(?:::\w+)*\z/s) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _CLASSISA $string, $class

The C<_CLASSISA> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a string that is a particularly class, or a subclass of it.

This function checks that the format is valid and calls the -E<gt>isa
method on the class name. It does not check that the class is actually
loaded.

It also assumes "normalised" form, and does
not accept class names such as C<::Foo> or C<D'Oh>.

Returns the string as a convenience if it is a valid class name, or
C<undef> if not.

=cut

eval <<'END_PERL' unless defined &_CLASSISA;
sub _CLASSISA ($$) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^[^\W\d]\w*(?:::\w+)*\z/s and $_[0]->isa($_[1])) ? $_[0] : undef;
}
END_PERL

=head2 _CLASSDOES $string, $role

This routine behaves exactly like C<L</_CLASSISA>>, but checks with C<< ->DOES
>> rather than C<< ->isa >>.  This is probably only a good idea to use on Perl
5.10 or later, when L<UNIVERSAL::DOES|UNIVERSAL::DOES/DOES> has been
implemented.

=cut

eval <<'END_PERL' unless defined &_CLASSDOES;
sub _CLASSDOES ($$) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^[^\W\d]\w*(?:::\w+)*\z/s and $_[0]->DOES($_[1])) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _SUBCLASS $string, $class

The C<_SUBCLASS> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a string that is a subclass of a specified class.

This function checks that the format is valid and calls the -E<gt>isa
method on the class name. It does not check that the class is actually
loaded.

It also assumes "normalised" form, and does
not accept class names such as C<::Foo> or C<D'Oh>.

Returns the string as a convenience if it is a valid class name, or
C<undef> if not.

=cut

eval <<'END_PERL' unless defined &_SUBCLASS;
sub _SUBCLASS ($$) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^[^\W\d]\w*(?:::\w+)*\z/s and $_[0] ne $_[1] and $_[0]->isa($_[1])) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _NUMBER $scalar

The C<_NUMBER> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a number. That is, it is defined and perl thinks it's a number.

This function is basically a Params::Util-style wrapper around the
L<Scalar::Util> C<looks_like_number> function.

Returns the value as a convience, or C<undef> if the value is not a
number.

=cut

eval <<'END_PERL' unless defined &_NUMBER;
sub _NUMBER ($) {
	( defined $_[0] and ! ref $_[0] and looks_like_number($_[0]) )
	? $_[0]
	: undef;
}
END_PERL

=pod

=head2 _POSINT $integer

The C<_POSINT> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a positive integer (of any length).

Returns the value as a convience, or C<undef> if the value is not a
positive integer.

The name itself is derived from the XML schema constraint of the same
name.

=cut

eval <<'END_PERL' unless defined &_POSINT;
sub _POSINT ($) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^[1-9]\d*$/) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _NONNEGINT $integer

The C<_NONNEGINT> function is intended to be imported into your
package, and provides a convenient way to test to see if a value is
a non-negative integer (of any length). That is, a positive integer,
or zero.

Returns the value as a convience, or C<undef> if the value is not a
non-negative integer.

As with other tests that may return false values, care should be taken
to test via "defined" in boolean validy contexts.

  unless ( defined _NONNEGINT($value) ) {
     die "Invalid value";
  }

The name itself is derived from the XML schema constraint of the same
name.

=cut

eval <<'END_PERL' unless defined &_NONNEGINT;
sub _NONNEGINT ($) {
	(defined $_[0] and ! ref $_[0] and $_[0] =~ m/^(?:0|[1-9]\d*)$/) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _SCALAR \$scalar

The C<_SCALAR> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<SCALAR> reference, with content of non-zero length.

For a version that allows zero length C<SCALAR> references, see
the C<_SCALAR0> function.

Returns the C<SCALAR> reference itself as a convenience, or C<undef>
if the value provided is not a C<SCALAR> reference.

=cut

eval <<'END_PERL' unless defined &_SCALAR;
sub _SCALAR ($) {
	(ref $_[0] eq 'SCALAR' and defined ${$_[0]} and ${$_[0]} ne '') ? $_[0] : undef;
}
END_PERL

=pod

=head2 _SCALAR0 \$scalar

The C<_SCALAR0> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<SCALAR0> reference, allowing content of zero-length.

For a simpler "give me some content" version that requires non-zero
length, C<_SCALAR> function.

Returns the C<SCALAR> reference itself as a convenience, or C<undef>
if the value provided is not a C<SCALAR> reference.

=cut

eval <<'END_PERL' unless defined &_SCALAR0;
sub _SCALAR0 ($) {
	ref $_[0] eq 'SCALAR' ? $_[0] : undef;
}
END_PERL

=pod

=head2 _ARRAY $value

The C<_ARRAY> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<ARRAY> reference containing B<at least> one element of any kind.

For a more basic form that allows zero length ARRAY references, see
the C<_ARRAY0> function.

Returns the C<ARRAY> reference itself as a convenience, or C<undef>
if the value provided is not an C<ARRAY> reference.

=cut

eval <<'END_PERL' unless defined &_ARRAY;
sub _ARRAY ($) {
	(ref $_[0] eq 'ARRAY' and @{$_[0]}) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _ARRAY0 $value

The C<_ARRAY0> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<ARRAY> reference, allowing C<ARRAY> references that contain no
elements.

For a more basic "An array of something" form that also requires at
least one element, see the C<_ARRAY> function.

Returns the C<ARRAY> reference itself as a convenience, or C<undef>
if the value provided is not an C<ARRAY> reference.

=cut

eval <<'END_PERL' unless defined &_ARRAY0;
sub _ARRAY0 ($) {
	ref $_[0] eq 'ARRAY' ? $_[0] : undef;
}
END_PERL

=pod

=head2 _ARRAYLIKE $value

The C<_ARRAYLIKE> function tests whether a given scalar value can respond to
array dereferencing.  If it can, the value is returned.  If it cannot,
C<_ARRAYLIKE> returns C<undef>.

=cut

eval <<'END_PERL' unless defined &_ARRAYLIKE;
sub _ARRAYLIKE {
	(defined $_[0] and ref $_[0] and (
		(Scalar::Util::reftype($_[0]) eq 'ARRAY')
		or
		overload::Method($_[0], '@{}')
	)) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _HASH $value

The C<_HASH> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<HASH> reference with at least one entry.

For a version of this function that allows the C<HASH> to be empty,
see the C<_HASH0> function.

Returns the C<HASH> reference itself as a convenience, or C<undef>
if the value provided is not an C<HASH> reference.

=cut

eval <<'END_PERL' unless defined &_HASH;
sub _HASH ($) {
	(ref $_[0] eq 'HASH' and scalar %{$_[0]}) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _HASH0 $value

The C<_HASH0> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<HASH> reference, regardless of the C<HASH> content.

For a simpler "A hash of something" version that requires at least one
element, see the C<_HASH> function.

Returns the C<HASH> reference itself as a convenience, or C<undef>
if the value provided is not an C<HASH> reference.

=cut

eval <<'END_PERL' unless defined &_HASH0;
sub _HASH0 ($) {
	ref $_[0] eq 'HASH' ? $_[0] : undef;
}
END_PERL

=pod

=head2 _HASHLIKE $value

The C<_HASHLIKE> function tests whether a given scalar value can respond to
hash dereferencing.  If it can, the value is returned.  If it cannot,
C<_HASHLIKE> returns C<undef>.

=cut

eval <<'END_PERL' unless defined &_HASHLIKE;
sub _HASHLIKE {
	(defined $_[0] and ref $_[0] and (
		(Scalar::Util::reftype($_[0]) eq 'HASH')
		or
		overload::Method($_[0], '%{}')
	)) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _CODE $value

The C<_CODE> function is intended to be imported into your package,
and provides a convenient way to test for a raw and unblessed
C<CODE> reference.

Returns the C<CODE> reference itself as a convenience, or C<undef>
if the value provided is not an C<CODE> reference.

=cut

eval <<'END_PERL' unless defined &_CODE;
sub _CODE ($) {
	ref $_[0] eq 'CODE' ? $_[0] : undef;
}
END_PERL

=pod

=head2 _CODELIKE $value

The C<_CODELIKE> is the more generic version of C<_CODE>. Unlike C<_CODE>,
which checks for an explicit C<CODE> reference, the C<_CODELIKE> function
also includes things that act like them, such as blessed objects that
overload C<'&{}'>.

Please note that in the case of objects overloaded with '&{}', you will
almost always end up also testing it in 'bool' context at some stage.

For example:

  sub foo {
      my $code1 = _CODELIKE(shift) or die "No code param provided";
      my $code2 = _CODELIKE(shift);
      if ( $code2 ) {
           print "Got optional second code param";
      }
  }

As such, you will most likely always want to make sure your class has
at least the following to allow it to evaluate to true in boolean
context.

  # Always evaluate to true in boolean context
  use overload 'bool' => sub () { 1 };

Returns the callable value as a convenience, or C<undef> if the
value provided is not callable.

Note - This function was formerly known as _CALLABLE but has been renamed
for greater symmetry with the other _XXXXLIKE functions.

The use of _CALLABLE has been deprecated. It will continue to work, but
with a warning, until end-2006, then will be removed.

I apologise for any inconvenience caused.

=cut

eval <<'END_PERL' unless defined &_CODELIKE;
sub _CODELIKE($) {
	(
		(Scalar::Util::reftype($_[0])||'') eq 'CODE'
		or
		Scalar::Util::blessed($_[0]) and overload::Method($_[0],'&{}')
	)
	? $_[0] : undef;
}
END_PERL

=pod

=head2 _INVOCANT $value

This routine tests whether the given value is a valid method invocant.
This can be either an instance of an object, or a class name.

If so, the value itself is returned.  Otherwise, C<_INVOCANT>
returns C<undef>.

=cut

eval <<'END_PERL' unless defined &_INVOCANT;
sub _INVOCANT($) {
	(defined $_[0] and
		(defined Scalar::Util::blessed($_[0])
		or      
		# We used to check for stash definedness, but any class-like name is a
		# valid invocant for UNIVERSAL methods, so we stopped. -- rjbs, 2006-07-02
		Params::Util::_CLASS($_[0]))
	) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _INSTANCE $object, $class

The C<_INSTANCE> function is intended to be imported into your package,
and provides a convenient way to test for an object of a particular class
in a strictly correct manner.

Returns the object itself as a convenience, or C<undef> if the value
provided is not an object of that type.

=cut

eval <<'END_PERL' unless defined &_INSTANCE;
sub _INSTANCE ($$) {
	(Scalar::Util::blessed($_[0]) and $_[0]->isa($_[1])) ? $_[0] : undef;
}
END_PERL

=head2 _INSTANCEDOES $object, $role

This routine behaves exactly like C<L</_INSTANCE>>, but checks with C<< ->DOES
>> rather than C<< ->isa >>.  This is probably only a good idea to use on Perl
5.10 or later, when L<UNIVERSAL::DOES|UNIVERSAL::DOES/DOES> has been
implemented.

=cut

eval <<'END_PERL' unless defined &_INSTANCEDOES;
sub _INSTANCEDOES ($$) {
	(Scalar::Util::blessed($_[0]) and $_[0]->DOES($_[1])) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _REGEX $value

The C<_REGEX> function is intended to be imported into your package,
and provides a convenient way to test for a regular expression.

Returns the value itself as a convenience, or C<undef> if the value
provided is not a regular expression.

=cut

eval <<'END_PERL' unless defined &_REGEX;
sub _REGEX ($) {
	(defined $_[0] and 'Regexp' eq ref($_[0])) ? $_[0] : undef;
}
END_PERL

=pod

=head2 _SET \@array, $class

The C<_SET> function is intended to be imported into your package,
and provides a convenient way to test for set of at least one object of
a particular class in a strictly correct manner.

The set is provided as a reference to an C<ARRAY> of objects of the
class provided.

For an alternative function that allows zero-length sets, see the
C<_SET0> function.

Returns the C<ARRAY> reference itself as a convenience, or C<undef> if
the value provided is not a set of that class.

=cut

eval <<'END_PERL' unless defined &_SET;
sub _SET ($$) {
	my $set = shift;
	_ARRAY($set) or return undef;
	foreach my $item ( @$set ) {
		_INSTANCE($item,$_[0]) or return undef;
	}
	$set;
}
END_PERL

=pod

=head2 _SET0 \@array, $class

The C<_SET0> function is intended to be imported into your package,
and provides a convenient way to test for a set of objects of a
particular class in a strictly correct manner, allowing for zero objects.

The set is provided as a reference to an C<ARRAY> of objects of the
class provided.

For an alternative function that requires at least one object, see the
C<_SET> function.

Returns the C<ARRAY> reference itself as a convenience, or C<undef> if
the value provided is not a set of that class.

=cut

eval <<'END_PERL' unless defined &_SET0;
sub _SET0 ($$) {
	my $set = shift;
	_ARRAY0($set) or return undef;
	foreach my $item ( @$set ) {
		_INSTANCE($item,$_[0]) or return undef;
	}
	$set;
}
END_PERL

=pod

=head2 _HANDLE

The C<_HANDLE> function is intended to be imported into your package,
and provides a convenient way to test whether or not a single scalar
value is a file handle.

Unfortunately, in Perl the definition of a file handle can be a little
bit fuzzy, so this function is likely to be somewhat imperfect (at first
anyway).

That said, it is implement as well or better than the other file handle
detectors in existance (and we stole from the best of them).

=cut

# We're doing this longhand for now. Once everything is perfect,
# we'll compress this into something that compiles more efficiently.
# Further, testing file handles is not something that is generally
# done millions of times, so doing it slowly is not a big speed hit.
eval <<'END_PERL' unless defined &_HANDLE;
sub _HANDLE {
	my $it = shift;

	# It has to be defined, of course
	unless ( defined $it ) {
		return undef;
	}

	# Normal globs are considered to be file handles
	if ( ref $it eq 'GLOB' ) {
		return $it;
	}

	# Check for a normal tied filehandle
	# Side Note: 5.5.4's tied() and can() doesn't like getting undef
	if ( tied($it) and tied($it)->can('TIEHANDLE') ) {
		return $it;
	}

	# There are no other non-object handles that we support
	unless ( Scalar::Util::blessed($it) ) {
		return undef;
	}

	# Check for a common base classes for conventional IO::Handle object
	if ( $it->isa('IO::Handle') ) {
		return $it;
	}


	# Check for tied file handles using Tie::Handle
	if ( $it->isa('Tie::Handle') ) {
		return $it;
	}

	# IO::Scalar is not a proper seekable, but it is valid is a
	# regular file handle
	if ( $it->isa('IO::Scalar') ) {
		return $it;
	}

	# Yet another special case for IO::String, which refuses (for now
	# anyway) to become a subclass of IO::Handle.
	if ( $it->isa('IO::String') ) {
		return $it;
	}

	# This is not any sort of object we know about
	return undef;
}
END_PERL

=pod

=head2 _DRIVER $string

  sub foo {
    my $class = _DRIVER(shift, 'My::Driver::Base') or die "Bad driver";
    ...
  }

The C<_DRIVER> function is intended to be imported into your
package, and provides a convenient way to load and validate
a driver class.

The most common pattern when taking a driver class as a parameter
is to check that the name is a class (i.e. check against _CLASS)
and then to load the class (if it exists) and then ensure that
the class returns true for the isa method on some base driver name.

Return the value as a convenience, or C<undef> if the value is not
a class name, the module does not exist, the module does not load,
or the class fails the isa test.

=cut

eval <<'END_PERL' unless defined &_DRIVER;
sub _DRIVER ($$) {
	(defined _CLASS($_[0]) and eval "require $_[0];" and ! $@ and $_[0]->isa($_[1]) and $_[0] ne $_[1]) ? $_[0] : undef;
}
END_PERL

1;

=pod

=head1 TO DO

- Add _CAN to help resolve the UNIVERSAL::can debacle

- Would be even nicer if someone would demonstrate how the hell to
build a Module::Install dist of the ::Util dual Perl/XS type. :/

- Implement an assertion-like version of this module, that dies on
error.

- Implement a Test:: version of this module, for use in testing

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Params-Util>

For other issues, contact the author.

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 SEE ALSO

L<Params::Validate>

=head1 COPYRIGHT

Copyright 2005 - 2012 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
