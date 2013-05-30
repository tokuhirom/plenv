#!/bin/bash
mkdir -p libexec completions
rm libexec/*
rm -f completions/*
cp ~/.rbenv/libexec/* libexec/
cp ~/.rbenv/completions/* completions/
rename 's/rbenv/plenv/' libexec/* completions/*
/usr/bin/perl -i -pe 's!github.com/sstephenson/rbenv!github.com/tokuhirom/plenv!g; s/RUBY/PERL/g; s/rbenv/plenv/g;s/RBENV/PLENV/g;s/Ruby/Perl/g;s/ruby/perl/g; s/1.9.3-p327/5.18.0/g; s/bundle install/carton install/g' libexec/* completions/*
chmod +x libexec/*
grep sstephenson libexec/* plugins/*/* completions/*

# enable --no-rehash by default
perl -i -pe 's/no_rehash=""/no_rehash=1/' libexec/plenv-init
