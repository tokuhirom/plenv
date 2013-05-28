#!/bin/bash
rm libexec/*
cp ~/.rbenv/libexec/* libexec/
rename 's/rbenv/plenv/' libexec/*
perl -i -pe 's/RUBY/PERL/g; s/rbenv/plenv/g;s/RBENV/PLENV/g;s/Ruby/Perl/g;s/ruby/perl/g' libexec/*
chmod +x libexec/*
grep sstephenson libexec/* plugins/*/*
