# NAME

plenv - perl binary manager

# SYNOPSIS

    plenv help

    # list available perl versions
    plenv available

    # install perl5 binary
    plenv install 5.16.2 -Dusethreads

    # execute command on current perl
    plenv exec ack

    # change global default perl to 5.16.2
    plenv global 5.16.2

    # change local perl to 5.14.0
    plenv local 5.14.0

    # run this command after install cpan module, contains executable script.
    plenv rehash

    # install cpanm to current perl
    plenv install-cpanm

    # migrate modules(install all installed modules for 5.8.9 to 5.16.2 environment.)
    plenv migrate-modules 5.8.9 5.16.2

    # locate a program file in the plenv's path
    plenv which cpanm

    # display version
    plenv --version

# DESCRIPTION

Use plenv to pick a Perl version for your application and guarantee
that your development environment matches production. Put plenv to work
with \[Carton\](http://github.com/miyagawa/carton/) for painless Perl upgrades and bulletproof deployments.

# plenv vs. perlbrew

plenv supports project local version determination.

i.e. .perl-version file support.

# INSTALLATION

## INSTALL FROM Homebrew

You can use homebrew to install plenv.

    $ brew install plenv

## INSTALL WITH GIT

1\. Check out plenv into ~/.plenv/

    $ git clone git://github.com/tokuhirom/plenv.git ~/.plenv

2\. Add ~/.plenv/bin/ to your $PATH for access to the \`plenv\` command-line utility.

    $ echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile

    **Ubuntu note**: Modify your `~/.profile` instead of `~/.bash_profile`.

    **Zsh note**: Modify your `~/.zshrc` file instead of `~/.bash_profile`.

# SETUP SHELL SETTINGS

- Add \`plenv init\` to your shell to enable shims and autocompletion.

        $ echo 'eval "$(plenv init -)"' >> ~/.bash_profile

    _Same as in previous step, use \`~/.profile\` on Ubuntu, \`~/.zshrc\` for Zsh._

- Restart your shell as a login shell so the path changes take effect.

    You can now begin using plenv.

        $ exec $SHELL -l

# Perl version detection

plenv detects current perl version with following order.

- PLENV\_VERSION environment variable
- .perl-version file in current and upper directories.
- global settings(~/.plenv/version)
- use system perl

# DEPENDENCIES

    * Perl 5.8.1+
    * wget or curl or fetch.

# FAQ

- How can I install cpanm?

    Try to use following command.

        % plenv install-cpanm

    This command install cpanm to current environment.

- What should I do for installing the module which I used for new Perl until now? 

    You can use ` migrate-modules ` subcommand.

        % plenv migrate-modules 5.8.2 5.16.2

    It make a list of installed modules in 5.8.2, and install these modules to 5.16.2 environment.

- How can I enable -g option without slowing down binary?

    Use following command.

        % plenv install 5.16.2 -DDEBUGGING=-g

# BUG REPORTING

Plese use github issues: [http://github.com/tokuhirom/plenv/](http://github.com/tokuhirom/plenv/).

# AUTHOR

Tokuhiro Matsuno <tokuhirom AAJKLFJEF@ GMAIL COM>

# SEE ALSO

[App::perlbrew](http://search.cpan.org/perldoc?App::perlbrew) provides same feature. But plenv provides project local file: __ .perl-version __.

Most of part was inspired from [rbenv](https://github.com/sstephenson/rbenv).

# LICENSE

## plenv itself

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## rbenv

plenv uses rbenv code

    (The MIT license)

    Copyright (c) 2013 Sam Stephenson

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
