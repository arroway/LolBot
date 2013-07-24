use inc::Module::Install;
name('LolBot');
author('Stephanie Ouillon');
license('Perl licence');
version_from('lib/App/LolBot.pm');

requires('Any::Moose');
requires('MooseX::Singleton');
requires('DBI');
requires('DBD::SQLite');

tests("t/*.t");
#extra_tests;
auto_install;
&WriteAll;

