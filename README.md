# NAME

plenv - perl binary manager

# SYNOPSIS

    plenv help

    # list available perl versions
    plenv install --list

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
with [Carton](http://github.com/miyagawa/carton/) for painless Perl upgrades and bulletproof deployments.

# plenv vs. perlbrew

Like perlbrew, plenv installs perls under your home directory and lets you install modules locally, and allows you to switch to arbitrary perl versions on your shell.

Unlike perlbrew, plenv is implemented in bash, and provides simple shell script wrappers (called "shims") for each perl executable files. It doesn't export any shell functions that switches `PATH` before running commands.

Unlike perlbrew, plenv allows you to set local perl version per directory, using `.perl-version` file.

Unlike perlbrew, plenv doesn't provide built-in local::lib integrations, but [plenv-contrib](https://github.com/miyagawa/plenv-contrib) implements `use` and `lib` commands for a replacement.

## INSTALLATION

**Compatibility note**: plenv is _incompatible_ with perlbrew. Please make
  sure to fully uninstall perlbrew and remove any references to it from
  your shell initialization files before installing plenv.

If you're on Mac OS X, consider
[installing with Homebrew](#homebrew-on-mac-os-x).


### Basic GitHub Checkout

This will get you going with the latest version of plenv and make it
easy to fork and contribute any changes back upstream.

1. Check out plenv into `~/.plenv`.

    ~~~ sh
    $ git clone https://github.com/tokuhirom/plenv.git ~/.plenv
    ~~~

2. Add `~/.plenv/bin` to your `$PATH` for access to the `plenv`
   command-line utility.

    ~~~ sh
    $ echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
    ~~~

    **Ubuntu note**: Modify your `~/.profile` instead of `~/.bash_profile`.

    **Zsh note**: Modify your `~/.zshrc` file instead of `~/.bash_profile`.

3. Add `plenv init` to your shell to enable shims and autocompletion.

    ~~~ sh
    $ echo 'eval "$(plenv init -)"' >> ~/.bash_profile
    ~~~

    _Same as in previous step, use `~/.profile` on Ubuntu._
    
    **Zsh note**: Use `echo 'eval "$(plenv init - zsh)"' >> ~/.zshrc`

4. Restart your shell as a login shell so the path changes take effect.
    You can now begin using plenv.

    ~~~ sh
    $ exec $SHELL -l
    ~~~

5. Install [perl-build](https://github.com/tokuhirom/perl-build),
   which provides an `plenv install` command that simplifies the
   process of installing new Perl versions.

    ~~~
    $ git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
    $ plenv install 5.18.0
    ~~~

   As an alternative, you can download and compile Perl yourself into
   `~/.plenv/versions/`.

6. Rebuild the shim executables. You should do this any time you
   install a new Perl executable (for example, when installing a new
   Perl version, or when installing a cpanm that provides a command).

    ~~~
    $ plenv rehash
    ~~~

#### Upgrading

If you've installed plenv manually using git, you can upgrade your
installation to the cutting-edge version at any time.

~~~ sh
$ cd ~/.plenv
$ git pull
~~~

To use a specific release of plenv, check out the corresponding tag:

~~~ sh
$ cd ~/.plenv
$ git fetch
$ git checkout 2.0.0
~~~

### Homebrew on Mac OS X

You can also install plenv using the
[Homebrew](http://mxcl.github.com/homebrew/) package manager on Mac OS
X.

~~~
$ brew update
$ brew install plenv
$ brew install perl-build
~~~

To later update these installs, use `upgrade` instead of `install`.

Afterwards you'll still need to add `eval "$(plenv init -)"` to your
profile as stated in the caveats. You'll only ever have to do this
once.


### Neckbeard Configuration

Skip this section unless you must know what every line in your shell
profile is doing.

`plenv init` is the only command that crosses the line of loading
extra commands into your shell. Here's what `plenv init` actually does:

1. Sets up your shims path. This is the only requirement for plenv to
   function properly. You can do this by hand by prepending
   `~/.plenv/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty
   useful. Sourcing `~/.plenv/completions/plenv.bash` will set that
   up. There is also a `~/.plenv/completions/plenv.zsh` for Zsh
   users.

3. Rehashes shims. From time to time you'll need to rebuild your
   shim files. Doing this automatically makes sure everything is up to
   date. You can always run `plenv rehash` manually.

4. Installs the sh dispatcher. This bit is also optional, but allows
   plenv and plugins to change variables in your current shell, making
   commands like `plenv shell` possible. The sh dispatcher doesn't do
   anything crazy like override `cd` or hack your shell prompt, but if
   for some reason you need `plenv` to be a real script rather than a
   shell function, you can safely skip it.

Run `plenv init -` for yourself to see exactly what happens under the
hood.

# DEPENDENCIES

    * Perl 5.8.1+
    * bash
    * curl(If you want to use plenv install-cpanm)

### FreeBSD users

Mount fdescfs on `/dev/fd` for using bash.
Please add following line to `/etc/fstab` and restart.

```
fdesc	/dev/fd		fdescfs		rw	0	0
```

## Command Reference

Like `git`, the `plenv` command delegates to subcommands based on its
first argument. The most common subcommands are:

### plenv local

Sets a local application-specific perl version by writing the version
name to a `.perl-version` file in the current directory. This version
overrides the global version, and can be overridden itself by setting
the `PLENV_VERSION` environment variable or with the `plenv shell`
command.

    $ plenv local 5.8.2

When run without a version number, `plenv local` reports the currently
configured local version. You can also unset the local version:

    $ plenv local --unset

Previous versions of plenv stored local version specifications in a
file named `.plenv-version`. For backwards compatibility, plenv will
read a local version specified in an `.plenv-version` file, but a
`.perl-version` file in the same directory will take precedence.

### plenv global

Sets the global version of perl to be used in all shells by writing
the version name to the `~/.plenv/version` file. This version can be
overridden by an application-specific `.perl-version` file, or by
setting the `plenv_VERSION` environment variable.

    $ plenv global 5.8.2

The special version name `system` tells plenv to use the system perl
(detected by searching your `$PATH`).

When run without a version number, `plenv global` reports the
currently configured global version.

### plenv shell

Sets a shell-specific perl version by setting the `plenv_VERSION`
environment variable in your shell. This version overrides
application-specific versions and the global version.

    $ plenv shell 5.8.2

When run without a version number, `plenv shell` reports the current
value of `plenv_VERSION`. You can also unset the shell version:

    $ plenv shell --unset

Note that you'll need plenv's shell integration enabled (step 3 of
the installation instructions) in order to use this command. If you
prefer not to use shell integration, you may simply set the
`PLENV_VERSION` variable yourself:

    $ export PLENV_VERSION=5.8.2

### plenv versions

Lists all perl versions known to plenv, and shows an asterisk next to
the currently active version.

    $ plenv versions
      system
      5.12.0
      5.14.0
      5.16.1
      5.16.2
      5.17.11
      5.17.7
      5.17.8
      5.18.0
      5.18.0-RC3
      5.18.0-RC4
    * 5.19.0 (set by /home/tokuhirom/.plenv/version)
      5.6.2
      5.8.1
      5.8.2
      5.8.3
      5.8.5
      5.8.9

### plenv version

Displays the currently active perl version, along with information on
how it was set.

    $ plenv version
    5.19.0 (set by /home/tokuhirom/.plenv/version)

### plenv rehash

Installs shims for all perl executables known to plenv (i.e.,
`~/.plenv/versions/*/bin/*`). Run this command after you install a new
version of perl, or install a cpanm that provides commands.

    $ plenv rehash

### plenv which

Displays the full path to the executable that plenv will invoke when
you run the given command.

    $ plenv which cpanm
    /home/tokuhirom/.plenv/versions/5.19.0/bin/cpanm

### plenv whence

Lists all perl versions with the given command installed.

    $ plenv whence plackup
    5.17.11
    5.17.7
    5.18.0
    5.18.0-RC4
    5.19.0

# FAQ

- How can I install cpanm?

    Try using the following command:

        % plenv install-cpanm

    This command installs cpanm in the current environment.

    If you are installing via a proxy and encounter problems you can set curl arguments via PLENV_INSTALL_CPANM (default is **-p**):

        % PLENV_INSTALL_CPANM="-v" plenv install-cpanm

- How can I install the modules I used in another Perl environment in my new one?

    You can use the ` migrate-modules ` subcommand.

        % plenv migrate-modules 5.8.2 5.16.2

    It makes a list of the installed modules in 5.8.2, and installs the newest versions of those modules
    to the 5.16.2 environment. Note that because the module version won't necessarily be the same between
    the two versions, there may be changes that affect compatibility, dependencies, or other behaviors
    your applications depend on.

    You can reuse installed modules from a binary-compatible perl version
    directly without reinstalling. For example, if you have installed lots of
    modules in 5.18.1 and install a variant of 5.18.1 with dtrace support,
    you might not want to migrate all those modules.

        % plenv install 5.18.1 -Dusedtrace --as 5.18.1-dtrace
        % plenv shell 5.18.1-dtrace
        % PERL5LIB=$(PLENV_VERSION=5.18.1 perl -e'print join ":",@INC') perl <command>

- How can I enable -g option without slowing down binary?

    Use following command.

        % plenv install 5.16.2 -DDEBUGGING=-g

# BUG REPORTING

Plese use github issues: [http://github.com/tokuhirom/plenv/](http://github.com/tokuhirom/plenv/).

# AUTHOR

Tokuhiro Matsuno <tokuhirom AAJKLFJEF@ GMAIL COM>

# SEE ALSO

[App::perlbrew](http://search.cpan.org/perldoc?App::perlbrew) provides the same features. But plenv provides project local file: __ .perl-version __.

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
