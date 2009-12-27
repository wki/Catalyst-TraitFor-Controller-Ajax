use inc::Module::Install;

name     'Catalyst-TraitFor-Controller-Ajax';
all_from 'lib/Catalyst/TraitFor/Controller/Ajax.pm';
author   q{Wolfgang Kinkeldei <wki@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

