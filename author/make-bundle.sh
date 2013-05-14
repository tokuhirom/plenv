#!/bin/bash
minil build
echo 5.8.1 > .perl-version
cpanm --pureperl --no-man-pages -L share/plenv --installdeps .
