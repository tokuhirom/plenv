DUMMY_VERSION = $(PWD)/versions/dummy

PLENV_ROOT := $(PWD)
PATH := $(PWD)/bin:$(PATH)
SHELL := /bin/bash
export PLENV_ROOT PATH SHELL

copy-from-rbenv:
	bash ./author/copy-from-rbenv.sh

test: ext/test-simple-bash shims/perl _force
	( eval "$$(plenv init -)"; eval prove -v test/ )

ext/test-simple-bash:
	git clone https://github.com/ingydotnet/test-simple-bash.git $@

shims/perl:
	mkdir -p $(DUMMY_VERSION)/bin
	touch $(DUMMY_VERSION)/bin/perl
	( eval "$$(plenv init -)"; plenv rehash )
	rm -fr $(DUMMY_VERSION)
	[ -e $@ ] || exit 1

_force:
