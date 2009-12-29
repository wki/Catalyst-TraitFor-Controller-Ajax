use inc::Module::Install;

name     'Catalyst-TraitFor-Controller-Ajax';
all_from 'lib/Catalyst/TraitFor/Controller/Ajax.pm';
author   'Wolfgang Kinkeldei <wki@cpan.org>';
license  'perl';

requires 'Catalyst::Runtime' => '5.8';
requires 'MooseX::MethodAttributes::Role';

build_requires 'Test::More';
build_requres 'Test::Exception';

test_requires 'FindBin';

auto_install;

WriteAll;

