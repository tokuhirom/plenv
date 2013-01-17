package CPAN::Perl::Releases;
{
  $CPAN::Perl::Releases::VERSION = '0.92';
}

#ABSTRACT: Mapping Perl releases on CPAN to the location of the tarballs

use strict;
use warnings;
use vars qw[@ISA @EXPORT_OK];

use Exporter;

@ISA       = qw(Exporter);
@EXPORT_OK = qw(perl_tarballs);

# Data gathered from using findlinks.pl script in this dists tools/
# directory, run over the src/5.0 of a local CPAN mirror.

our $data =
{
  "5.003_07" => {
    "tar.gz" => "A/AN/ANDYD/perl5.003_07.tar.gz",
  },
  "5.004" => {
    "tar.gz" => "C/CH/CHIPS/perl5.004.tar.gz",
  },
  "5.004_01" => {
    "tar.gz" => "T/TI/TIMB/perl5.004_01.tar.gz",
  },
  "5.004_02" => {
    "tar.gz" => "T/TI/TIMB/perl5.004_02.tar.gz",
  },
  "5.004_03" => {
    "tar.gz" => "T/TI/TIMB/perl5.004_03.tar.gz",
  },
  "5.004_04" => {
    "tar.gz" => "T/TI/TIMB/perl5.004_04.tar.gz",
  },
  "5.004_05" => {
    "tar.gz" => "C/CH/CHIPS/perl5.004_05.tar.gz",
  },
  "5.005" => {
    "tar.gz" => "G/GS/GSAR/perl5.005.tar.gz",
  },
  "5.005_01" => {
    "tar.gz" => "G/GS/GSAR/perl5.005_01.tar.gz",
  },
  "5.005_02" => {
    "tar.gz" => "G/GS/GSAR/perl5.005_02.tar.gz",
  },
  "5.005_03" => {
    "tar.gz" => "G/GB/GBARR/perl5.005_03.tar.gz",
  },
  "5.005_04" => {
    "tar.gz" => "L/LB/LBROCARD/perl5.005_04.tar.gz",
  },
  "5.10.0" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.10.0.tar.gz",
  },
  "5.10.0-RC1" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.10.0-RC1.tar.gz",
  },
  "5.10.0-RC2" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.10.0-RC2.tar.gz",
  },
  "5.10.1" => {
    "tar.bz2" => "D/DA/DAPM/perl-5.10.1.tar.bz2",
    "tar.gz" => "D/DA/DAPM/perl-5.10.1.tar.gz",
  },
  "5.11.0" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.11.0.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.11.0.tar.gz",
  },
  "5.11.1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.11.1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.11.1.tar.gz",
  },
  "5.11.2" => {
    "tar.bz2" => "L/LB/LBROCARD/perl-5.11.2.tar.bz2",
    "tar.gz" => "L/LB/LBROCARD/perl-5.11.2.tar.gz",
  },
  "5.11.3" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.11.3.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.11.3.tar.gz",
  },
  "5.11.4" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.11.4.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.11.4.tar.gz",
  },
  "5.11.5" => {
    "tar.bz2" => "S/SH/SHAY/perl-5.11.5.tar.bz2",
    "tar.gz" => "S/SH/SHAY/perl-5.11.5.tar.gz",
  },
  "5.12.0" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.12.0.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.12.0.tar.gz",
  },
  "5.12.1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.12.1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.12.1.tar.gz",
  },
  "5.12.1-RC1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.12.1-RC1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.12.1-RC1.tar.gz",
  },
  "5.12.1-RC2" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.12.1-RC2.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.12.1-RC2.tar.gz",
  },
  "5.12.2" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.12.2.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.12.2.tar.gz",
  },
  "5.12.2-RC1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.12.2-RC1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.12.2-RC1.tar.gz",
  },
  "5.12.3" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.12.3.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.12.3.tar.gz",
  },
  "5.12.4-RC1" => {
    "tar.bz2" => "L/LB/LBROCARD/perl-5.12.4-RC1.tar.bz2",
    "tar.gz" => "L/LB/LBROCARD/perl-5.12.4-RC1.tar.gz",
  },
  "5.12.4-RC2" => {
    "tar.bz2" => "L/LB/LBROCARD/perl-5.12.4-RC2.tar.bz2",
    "tar.gz" => "L/LB/LBROCARD/perl-5.12.4-RC2.tar.gz",
  },
  "5.12.4" => {
    "tar.bz2" => "L/LB/LBROCARD/perl-5.12.4.tar.bz2",
    "tar.gz" => "L/LB/LBROCARD/perl-5.12.4.tar.gz",
  },
  "5.12.5-RC1" => {
    "tar.bz2" => "D/DO/DOM/perl-5.12.5-RC1.tar.bz2",
    "tar.gz" => "D/DO/DOM/perl-5.12.5-RC1.tar.gz",
  },
  "5.12.5-RC2" => {
    "tar.bz2" => "D/DO/DOM/perl-5.12.5-RC2.tar.bz2",
    "tar.gz" => "D/DO/DOM/perl-5.12.5-RC2.tar.gz",
  },
  "5.12.5" => {
    "tar.bz2" => "D/DO/DOM/perl-5.12.5.tar.bz2",
    "tar.gz" => "D/DO/DOM/perl-5.12.5.tar.gz",
  },
  "5.13.0" => {
    "tar.bz2" => "L/LB/LBROCARD/perl-5.13.0.tar.bz2",
    "tar.gz" => "L/LB/LBROCARD/perl-5.13.0.tar.gz",
  },
  "5.13.1" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.13.1.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.13.1.tar.gz",
  },
  "5.13.10" => {
    "tar.bz2" => "A/AV/AVAR/perl-5.13.10.tar.bz2",
    "tar.gz" => "A/AV/AVAR/perl-5.13.10.tar.gz",
  },
  "5.13.11" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.13.11.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.13.11.tar.gz",
  },
  "5.13.2" => {
    "tar.bz2" => "M/MS/MSTROUT/perl-5.13.2.tar.bz2",
    "tar.gz" => "M/MS/MSTROUT/perl-5.13.2.tar.gz",
  },
  "5.13.3" => {
    "tar.bz2" => "D/DA/DAGOLDEN/perl-5.13.3.tar.bz2",
    "tar.gz" => "D/DA/DAGOLDEN/perl-5.13.3.tar.gz",
  },
  "5.13.4" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.13.4.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.13.4.tar.gz",
  },
  "5.13.5" => {
    "tar.bz2" => "S/SH/SHAY/perl-5.13.5.tar.bz2",
    "tar.gz" => "S/SH/SHAY/perl-5.13.5.tar.gz",
  },
  "5.13.6" => {
    "tar.bz2" => "M/MI/MIYAGAWA/perl-5.13.6.tar.bz2",
    "tar.gz" => "M/MI/MIYAGAWA/perl-5.13.6.tar.gz",
  },
  "5.13.7" => {
    "tar.bz2" => "B/BI/BINGOS/perl-5.13.7.tar.bz2",
    "tar.gz" => "B/BI/BINGOS/perl-5.13.7.tar.gz",
  },
  "5.13.8" => {
    "tar.bz2" => "Z/ZE/ZEFRAM/perl-5.13.8.tar.bz2",
    "tar.gz" => "Z/ZE/ZEFRAM/perl-5.13.8.tar.gz",
  },
  "5.13.9" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.13.9.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.13.9.tar.gz",
  },
  "5.14.0" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.0.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.0.tar.gz",
  },
  "5.14.0-RC1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.0-RC1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.0-RC1.tar.gz",
  },
  "5.14.0-RC2" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.0-RC2.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.0-RC2.tar.gz",
  },
  "5.14.0-RC3" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.0-RC3.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.0-RC3.tar.gz",
  },
  "5.14.1-RC1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.1-RC1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.1-RC1.tar.gz",
  },
  "5.14.1" => {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.1.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.1.tar.gz",
  },
  "5.14.2-RC1" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.14.2-RC1.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.14.2-RC1.tar.gz",
  },
  "5.14.2" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.14.2.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.14.2.tar.gz",
  },
  "5.14.3-RC1" => {
    "tar.bz2" => "D/DO/DOM/perl-5.14.3-RC1.tar.bz2",
    "tar.gz" => "D/DO/DOM/perl-5.14.3-RC1.tar.gz",
  },
  "5.14.3-RC2" => {
    "tar.bz2" => "D/DO/DOM/perl-5.14.3-RC2.tar.bz2",
    "tar.gz" => "D/DO/DOM/perl-5.14.3-RC2.tar.gz",
  },
  "5.14.3" => {
    "tar.bz2" => "D/DO/DOM/perl-5.14.3.tar.bz2",
    "tar.gz" => "D/DO/DOM/perl-5.14.3.tar.gz",
  },
  "5.15.0" => {
    "tar.bz2" => "D/DA/DAGOLDEN/perl-5.15.0.tar.bz2",
    "tar.gz" => "D/DA/DAGOLDEN/perl-5.15.0.tar.gz",
  },
  "5.15.1" => {
    "tar.bz2" => "Z/ZE/ZEFRAM/perl-5.15.1.tar.bz2",
    "tar.gz" => "Z/ZE/ZEFRAM/perl-5.15.1.tar.gz",
  },
  "5.15.2" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.15.2.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.15.2.tar.gz",
  },
  "5.15.3" => {
    "tar.bz2" => "S/ST/STEVAN/perl-5.15.3.tar.bz2",
    "tar.gz" => "S/ST/STEVAN/perl-5.15.3.tar.gz",
  },
  "5.15.4" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.15.4.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.15.4.tar.gz",
  },
  "5.15.5" => {
    "tar.bz2" => "S/SH/SHAY/perl-5.15.5.tar.bz2",
    "tar.gz" => "S/SH/SHAY/perl-5.15.5.tar.gz",
  },
  "5.15.6" => {
    "tar.bz2" => "D/DR/DROLSKY/perl-5.15.6.tar.bz2",
    "tar.gz" => "D/DR/DROLSKY/perl-5.15.6.tar.gz",
  },
  "5.15.7" => {
    "tar.bz2" => "B/BI/BINGOS/perl-5.15.7.tar.bz2",
    "tar.gz" => "B/BI/BINGOS/perl-5.15.7.tar.gz",
  },
  "5.15.8" => {
    "tar.bz2" => "C/CO/CORION/perl-5.15.8.tar.bz2",
    "tar.gz" => "C/CO/CORION/perl-5.15.8.tar.gz",
  },
  "5.15.9" => {
    "tar.bz2" => "A/AB/ABIGAIL/perl-5.15.9.tar.bz2",
    "tar.gz" => "A/AB/ABIGAIL/perl-5.15.9.tar.gz",
  },
  "5.16.0-RC0" => {
    "tar.gz" => "R/RJ/RJBS/perl-5.16.0-RC0.tar.gz",
  },
  "5.16.0-RC1" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.0-RC1.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.0-RC1.tar.gz",
  },
  "5.16.0-RC2" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.0-RC2.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.0-RC2.tar.gz",
  },
  "5.16.0" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.0.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.0.tar.gz",
  },
  "5.16.1-RC1" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.1-RC1.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.1-RC1.tar.gz",
  },
  "5.16.1" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.1.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.1.tar.gz",
  },
  "5.16.2-RC1" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.2-RC1.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.2-RC1.tar.gz",
  },
  "5.16.2" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.16.2.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.16.2.tar.gz",
  },
  "5.17.0" => {
    "tar.bz2" => "Z/ZE/ZEFRAM/perl-5.17.0.tar.bz2",
    "tar.gz" => "Z/ZE/ZEFRAM/perl-5.17.0.tar.gz",
  },
  "5.17.1" => {
    "tar.bz2" => "D/DO/DOY/perl-5.17.1.tar.bz2",
    "tar.gz" => "D/DO/DOY/perl-5.17.1.tar.gz",
  },
  "5.17.2" => {
    "tar.bz2" => "T/TO/TONYC/perl-5.17.2.tar.bz2",
    "tar.gz" => "T/TO/TONYC/perl-5.17.2.tar.gz",
  },
  "5.17.3" => {
    "tar.bz2" => "S/SH/SHAY/perl-5.17.3.tar.bz2",
    "tar.gz" => "S/SH/SHAY/perl-5.17.3.tar.gz",
  },
  "5.17.4" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.17.4.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.17.4.tar.gz",
  },
  "5.17.5" => {
    "tar.bz2" => "F/FL/FLORA/perl-5.17.5.tar.bz2",
    "tar.gz" => "F/FL/FLORA/perl-5.17.5.tar.gz",
  },
  "5.17.6" => {
    "tar.bz2" => "R/RJ/RJBS/perl-5.17.6.tar.bz2",
    "tar.gz" => "R/RJ/RJBS/perl-5.17.6.tar.gz",
  },
  "5.17.7" => {
    "tar.bz2" => "D/DR/DROLSKY/perl-5.17.7.tar.bz2",
    "tar.gz" => "D/DR/DROLSKY/perl-5.17.7.tar.gz",
  },
  "5.6.0" => {
    "tar.gz" => "G/GS/GSAR/perl-5.6.0.tar.gz",
  },
  "5.6.1" => {
    "tar.gz" => "G/GS/GSAR/perl-5.6.1.tar.gz",
  },
  "5.6.1-TRIAL1" => {
    "tar.gz" => "G/GS/GSAR/perl-5.6.1-TRIAL1.tar.gz",
  },
  "5.6.1-TRIAL2" => {
    "tar.gz" => "G/GS/GSAR/perl-5.6.1-TRIAL2.tar.gz",
  },
  "5.6.1-TRIAL3" => {
    "tar.gz" => "G/GS/GSAR/perl-5.6.1-TRIAL3.tar.gz",
  },
  "5.6.2" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.6.2.tar.gz",
  },
  "5.7.0" => {
    "tar.gz" => "J/JH/JHI/perl-5.7.0.tar.gz",
  },
  "5.7.1" => {
    "tar.gz" => "J/JH/JHI/perl-5.7.1.tar.gz",
  },
  "5.7.2" => {
    "tar.gz" => "J/JH/JHI/perl-5.7.2.tar.gz",
  },
  "5.7.3" => {
    "tar.gz" => "J/JH/JHI/perl-5.7.3.tar.gz",
  },
  "5.8.0" => {
    "tar.gz" => "J/JH/JHI/perl-5.8.0.tar.gz",
  },
  "5.8.1" => {
    "tar.gz" => "J/JH/JHI/perl-5.8.1.tar.gz",
  },
  "5.8.2" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.2.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.2.tar.gz",
  },
  "5.8.3" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.3.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.3.tar.gz",
  },
  "5.8.4" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.4.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.4.tar.gz",
  },
  "5.8.5" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.5.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.5.tar.gz",
  },
  "5.8.6" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.6.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.6.tar.gz",
  },
  "5.8.7" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.7.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.7.tar.gz",
  },
  "5.8.8" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.8.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.8.tar.gz",
  },
  "5.8.9" => {
    "tar.bz2" => "N/NW/NWCLARK/perl-5.8.9.tar.bz2",
    "tar.gz" => "N/NW/NWCLARK/perl-5.8.9.tar.gz",
  },
  "5.9.0" => {
    "tar.bz2" => "H/HV/HVDS/perl-5.9.0.tar.bz2",
    "tar.gz" => "H/HV/HVDS/perl-5.9.0.tar.gz",
  },
  "5.9.1" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.9.1.tar.gz",
  },
  "5.9.2" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.9.2.tar.gz",
  },
  "5.9.3" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.9.3.tar.gz",
  },
  "5.9.4" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.9.4.tar.gz",
  },
  "5.9.5" => {
    "tar.gz" => "R/RG/RGARCIA/perl-5.9.5.tar.gz",
  },
};

sub perl_tarballs {
  my $vers = shift;
  $vers = shift if eval { $vers->isa(__PACKAGE__) };
  return unless exists $data->{ $vers };
  return { %{ $data->{ $vers } } };
}

q|Acme::Why::Did::I::Not::Read::The::Fecking::Memo|;

__END__

=pod

=head1 NAME

CPAN::Perl::Releases - Mapping Perl releases on CPAN to the location of the tarballs

=head1 VERSION

version 0.92

=head1 SYNOPSIS

  use CPAN::Perl::Releases qw[perl_tarballs];

  my $perl = '5.14.0';

  my $hashref = perl_tarballs( $perl );

  print "Location: ", $_, "\n" for values %{ $hashref };

=head1 DESCRIPTION

CPAN::Perl::Releases is a module that contains the mappings of all C<perl> releases that have been uploaded to CPAN to the
C<authors/id/> path that the tarballs reside in.

This is static data, but newer versions of this module will be made available as new releases of C<perl> are uploaded to CPAN.

=head1 FUNCTIONS

=over

=item C<perl_tarballs>

Takes one parameter, a C<perl> version to search for. Returns an hashref on success or C<undef> otherwise.

The returned hashref will have a key/value for each type of tarball. A key of C<tar.gz> indicates the location
of a gzipped tar file and C<tar.bz2> of a bzip2'd tar file. The values will be the relative path under C<authors/id/>
on CPAN where the indicated tarball will be located.

  perl_tarballs( '5.14.0' );

  Returns a hashref like:

  {
    "tar.bz2" => "J/JE/JESSE/perl-5.14.0.tar.bz2",
    "tar.gz" => "J/JE/JESSE/perl-5.14.0.tar.gz"
  }

Not all C<perl> releases had C<tar.bz2>, but only a C<tar.gz>.

=back

=head1 SEE ALSO

L<http://www.cpan.org/src/5.0/>

L<http://search.cpan.org/faq.html#Is_there_a_API?>

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Chris Williams.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
