# fish completion for plenv
# Most of part was copied from rbenv.fish bundled with fish shell 

function __fish_plenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'plenv' ]
    return 0
  end

  return 1
end

function __fish_plenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_plenv_executables
  plenv exec --complete
end

function __fish_plenv_installed_perls
  plenv versions --bare
end

function __fish_plenv_official_perls
  perl-build --definitions
end

function __fish_plenv_prefixes
  plenv prefix --complete
end

### commands
complete -f -c plenv -n '__fish_plenv_needs_command' -a commands -d 'List all plenv commands'
complete -f -c plenv -n '__fish_plenv_using_command commands' -a '--complete --sh --no-sh'

### completions
complete -f -c plenv -n '__fish_plenv_needs_command' -a completions

### exec
complete -f -c plenv -n '__fish_plenv_needs_command' -a exec
complete -f -c plenv -n '__fish_plenv_using_command exec' -a '(__fish_plenv_executables)'

### global
complete -f -c plenv -n '__fish_plenv_needs_command' -a global -d 'Set or show the global Perl version'
complete -f -c plenv -n '__fish_plenv_using_command global' -a '(__fish_plenv_installed_perls)'

### help
complete -f -c plenv -n '__fish_plenv_needs_command' -a help

### hooks
complete -f -c plenv -n '__fish_plenv_needs_command' -a hooks

### init
complete -f -c plenv -n '__fish_plenv_needs_command' -a init

### install
complete -f -c plenv -n '__fish_plenv_needs_command' -a install -d 'Install a perl version'
complete -f -c plenv -n '__fish_plenv_using_command install' -a '(__fish_plenv_official_perls)'

### uninstall
complete -f -c plenv -n '__fish_plenv_needs_command' -a uninstall -d 'Unnstall a perl version'
complete -f -c plenv -n '__fish_plenv_using_command uninstall' -a '(__fish_plenv_official_perls)'

### local
complete -f -c plenv -n '__fish_plenv_needs_command' -a local -d 'Set or show the local directory-specific Perl version'
complete -f -c plenv -n '__fish_plenv_using_command local' -a '(__fish_plenv_installed_perls)'

### prefix
complete -f -c plenv -n '__fish_plenv_needs_command' -a prefix -d 'Shows a perl version installed folder'
complete -f -c plenv -n '__fish_plenv_using_command prefix' -a '(__fish_plenv_prefixes)'

### rehash
complete -f -c plenv -n '__fish_plenv_needs_command' -a rehash -d 'Rehash plenv shims (run this after installing binaries)'

### root
complete -f -c plenv -n '__fish_plenv_needs_command' -a root -d 'plenv root folder'

### shell
complete -f -c plenv -n '__fish_plenv_needs_command' -a shell -d 'Set or show the shell-specific Perl version'
complete -f -c plenv -n '__fish_plenv_using_command shell' -a '--unset (__fish_plenv_installed_perls)'

### shims
complete -f -c plenv -n '__fish_plenv_needs_command' -a shims
complete -f -c plenv -n '__fish_plenv_using_command shims' -a '--short'

### version
complete -f -c plenv -n '__fish_plenv_needs_command' -a version  -d 'Show the current Perl version'

### version-file
complete -f -c plenv -n '__fish_plenv_needs_command' -a version-file

### version-file-read
complete -f -c plenv -n '__fish_plenv_needs_command' -a version-file-read

### version-file-write
complete -f -c plenv -n '__fish_plenv_needs_command' -a version-file-write

### version-name
complete -f -c plenv -n '__fish_plenv_needs_command' -a version-name

### version-origin
complete -f -c plenv -n '__fish_plenv_needs_command' -a version-origin

### versions
complete -f -c plenv -n '__fish_plenv_needs_command' -a versions -d 'List all Perl versions known by plenv'

### whence
complete -f -c plenv -n '__fish_plenv_needs_command' -a whence -d 'List all Perl versions with the given command'
complete -f -c plenv -n '__fish_plenv_using_command whence' -a '--complete --path'

### which
complete -f -c plenv -n '__fish_plenv_needs_command' -a which -d 'Show the full path for the given Perl command'
complete -f -c plenv -n '__fish_plenv_using_command which' -a '(__fish_plenv_executables)'

### list-modules
complete -f -c plenv -n '__fish_plenv_needs_command' -a list-modules -d 'List cpan modules in current perl'

### migrate-modules
complete -f -c plenv -n '__fish_plenv_needs_command' -a migrate-modules -d 'Migrate cpan modules from other version'

### install-cpanm
complete -f -c plenv -n '__fish_plenv_needs_command' -a install-cpanm -d 'Install cpanm'
