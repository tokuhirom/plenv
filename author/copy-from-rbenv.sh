#!/bin/bash
mkdir -p libexec completions
rm -f completions/*
rm -f \
       libexec/plenv \
       libexec/plenv---version \
       libexec/plenv-commands \
       libexec/plenv-completions \
       libexec/plenv-exec \
       libexec/plenv-global \
       libexec/plenv-help \
       libexec/plenv-hooks \
       libexec/plenv-init \
       libexec/plenv-local \
       libexec/plenv-prefix \
       libexec/plenv-rehash \
       libexec/plenv-root \
       libexec/plenv-sh-rehash \
       libexec/plenv-sh-shell \
       libexec/plenv-shims \
       libexec/plenv-version \
       libexec/plenv-version-file \
       libexec/plenv-version-file-read \
       libexec/plenv-version-file-write \
       libexec/plenv-version-name \
       libexec/plenv-version-origin \
       libexec/plenv-versions \
       libexec/plenv-whence \
       libexec/plenv-which
cp ~/.rbenv/libexec/* libexec/
cp ~/.rbenv/completions/* completions/


rename 's/rbenv/plenv/' libexec/* completions/*
/usr/bin/perl -i -pe 's!github.com/sstephenson/rbenv!github.com/tokuhirom/plenv!g; s/RUBY/PERL/g; s/rbenv/plenv/g;s/RBENV/PLENV/g;s/Ruby/Perl/g;s/ruby/perl/g; s/1.9.3-p327/5.18.0/g; s/bundle install/carton install/g' libexec/* completions/*
chmod +x libexec/*
grep sstephenson libexec/* plugins/*/* completions/*

# enable --no-rehash by default
perl -i -pe 's/no_rehash=""/no_rehash=1/' libexec/plenv-init

git_revision="$(git describe --tags HEAD | sed -e 's/-.*//' 2>/dev/null || true)"
export GIT_REVISION=$git_revision
perl -i -pe 's/version="[0-9.]+"/version="$ENV{GIT_REVISION}"/' libexec/plenv---version
