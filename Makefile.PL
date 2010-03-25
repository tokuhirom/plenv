use inc::Module::Install;
name 'App-plenv';
all_from 'plenv';

install_script 'plenv';

readme_markdown_from('plenv');
tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests('xt');
auto_include;
WriteAll;
