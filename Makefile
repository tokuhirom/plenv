copy-from-rbenv:
	bash ./author/copy-from-rbenv.sh

download-perl-build:
	curl https://raw.github.com/tokuhirom/Perl-Build/master/perl-build  > plugins/perl-build/bin/perl-build
