copy-from-rbenv:
	bash ./author/copy-from-rbenv.sh

test: ext/test-simple-bash _force
	prove -v test/

ext/test-simple-bash:
	git clone git@github.com:ingydotnet/test-simple-bash $@

_force:
