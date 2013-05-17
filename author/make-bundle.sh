#!/bin/bash
minil build
echo 5.8.5 > .perl-version
cpanm --mirror=http://cpan.cpantesters.org/ --pureperl --no-man-pages -L share/plenv --installdeps .
