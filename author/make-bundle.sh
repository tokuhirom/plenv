#!/bin/bash
minil build
echo 5.8.1 > .perl-version
cpanm --self-upgrade
cpanm --pureperl --no-man-pages -L share/plenv --installdeps .
