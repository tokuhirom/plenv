use inc::Module::Install;
name 'App-plenv';
all_from 'lib/App/plenv.pm';

# requires '';


readme_markdown_from 'lib/App/plenv.pm';
tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests('xt');
# use_test_base;
auto_include;
WriteAll;
