#!/bin/bash
mkdir -p libexec completions
rm libexec/*
rm -f completions/*
cp ~/.rbenv/libexec/* libexec/
cp ~/.rbenv/completions/* completions/
rename 's/rbenv/plenv/' libexec/* completions/*
perl -i -pe 's!github.com/sstephenson/rbenv!github.com/tokuhirom/plenv!g; s/RUBY/PERL/g; s/rbenv/plenv/g;s/RBENV/PLENV/g;s/Ruby/Perl/g;s/ruby/perl/g' libexec/* completions/*
chmod +x libexec/*
grep sstephenson libexec/* plugins/*/* completions/*
