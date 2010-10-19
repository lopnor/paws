use inc::Module::Install;
name 'Paws';
all_from 'lib/Paws.pm';

requires 'Ark';

tests 't/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
