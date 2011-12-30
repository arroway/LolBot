#! /usr/bin/env perl;

use strict;
use warnings;
use User;
use MyTests;

my $nbTests = 25;

my $nameUser = "arroway"; 
my $user = User->new($nameUser);
my $t = MyTests->new($nbTests);

print "***** Just after initialization:\n";

$t->test("getName", $user->getName(), $nameUser);
$t->test("getCapslock", $user->getCapslock(), 0);
$t->test("getExclamative", $user->getExclamative(), 0);
$t->test("getInterrogative", $user->getInterrogative(), 0);
##4

print "\n***** With an empty line:\n";

my $line = "";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 0);
$user->findExclamative($line);
$t->test("getExclamative", $user->getExclamative(), 0);
$user->findInterrogative($line);
$t->test("getInterrogative", $user->getInterrogative(), 0);
##7

print "\n***** Note: After each test, the attribute counters are reset.\n";
print   "      We assume the resetAllCounters() function does work.\n";

print "\n***** With a single-letter string \"A\":\n";

$line = "A";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 1);
$user->findExclamative($line);
$t->test("getExclamative", $user->getExclamative(), 0);
$user->findInterrogative($line);
$t->test("getInterrogative", $user->getInterrogative(), 0);
$user->resetAllCounters();
##10


print "\n***** With a single-character string \"!\":\n";

$line = "!";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 0);
$user->findExclamative($line);
$t->test("getExclamative", $user->getExclamative(), 1);
$user->findInterrogative($line);
$t->test("getInterrogative", $user->getInterrogative(), 0);
$user->resetAllCounters();
##13


print "\n***** With a single-character string \"?\":\n";

$line = "?";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 0);
$user->findExclamative($line);
$t->test("getExclamative", $user->getExclamative(), 0);
$user->findInterrogative($line);
$t->test("getInterrogative", $user->getInterrogative(), 1);
$user->resetAllCounters();
##16


print "\n***** With multiple matches: ABCV ! ahvhdf ?\n";

$line = "ABCV ! ahvhdf ?";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 0);
$user->findExclamative($line);
$t->test("getExclamative", $user->getExclamative(), 1);
$user->findInterrogative($line);
$t->test("getInterrogative", $user->getInterrogative(), 1);
$user->resetAllCounters();
##19


#XXX= this one should fail (consider improve the relative regex)
print "\n***** With multiple matches: Alsjdedjf.\n";

$line = "Alsjdedjf";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 0);
$user->resetAllCounters();
##20

print "\n***** With multiple matches: ABCDEFG ZKGVZKHV.\n";

$line = "ABCDEFG ZKGVZKHV";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 1);
$user->resetAllCounters();
#21

print "\n***** With numbers: 1234.\n";

$line = "1234";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 0);
$user->resetAllCounters();
#22


print "\n***** With numbers and letters: 1234 AH AH AH.\n";

$line = "1234 AH AH AH";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 1);
$user->resetAllCounters();
#23


print "\n***** With letters and numbers: AH AH AH A 1234.\n";

$line = "AH AH AH A 1234";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 1);
$user->resetAllCounters();
#24


print "\n***** With ponctuation: HE !.\n";

$line = "HE !";
$user->findCapslock($line);
$t->test("getCapslock", $user->getCapslock(), 1);
$user->resetAllCounters();
#25


print "\n--->\t";
$t->myTestsDone();

