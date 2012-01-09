#! /usr/bin/env perl;

package testUser;
use strict;
use warnings;
use User;
use MyTests;

sub new{
  
  my ($class) = @_;
  my ($this) = {
    'name'   => 'testUser',
    'result' => ''
  };

  bless($this, $class);
  return $this;
}

sub run{

  my ($this) = @_;
  my $nbTests = 36;

  my $nameUser = "arroway"; 
  my $user = User->new($nameUser);
  my $t = MyTests->new($this->{'name'},$nbTests);

  print "***** Just after initialization:\n";

  $t->test("getName", $user->getName(), $nameUser);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $t->test("getExclamative", $user->getExclamative(), 0);
  $t->test("getInterrogative", $user->getInterrogative(), 0);
  $t->test("getLol", $user->getLol(), 0);
  ##5

  print "\n***** With an empty line:\n";

  my $line = "";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $user->findExclamative($line);
  $t->test("getExclamative", $user->getExclamative(), 0);
  $user->findInterrogative($line);
  $t->test("getInterrogative", $user->getInterrogative(), 0);
  $user->findLol($line);
  $t->test("getLol", $user->getLol(), 0);
  ##9

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
  $user->findLol($line);
  $t->test("getLol", $user->getLol(), 0);
  $user->resetAllCounters();
  ##13


  print "\n***** With a single-character string \"!\":\n";

  $line = "!";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $user->findExclamative($line);
  $t->test("getExclamative", $user->getExclamative(), 1);
  $user->findInterrogative($line);
  $t->test("getInterrogative", $user->getInterrogative(), 0);
  $user->resetAllCounters();
  $user->findLol($line);
  $t->test("getLol", $user->getLol(), 0);
  ##17


  print "\n***** With a single-character string \"?\":\n";

  $line = "?";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $user->findExclamative($line);
  $t->test("getExclamative", $user->getExclamative(), 0);
  $user->findInterrogative($line);
  $t->test("getInterrogative", $user->getInterrogative(), 1);
  $user->resetAllCounters();
  $user->findLol($line);
  $t->test("getLol", $user->getLol(), 0);
  ##21


  print "\n***** With multiple matches: ABCV ! ahvhdf ?\n";

  $line = "ABCV ! ahvhdf ?";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $user->findExclamative($line);
  $t->test("getExclamative", $user->getExclamative(), 1);
  $user->findInterrogative($line);
  $t->test("getInterrogative", $user->getInterrogative(), 1);
  $user->findLol($line);
  $t->test("getLol", $user->getLol(), 0);
  $user->resetAllCounters();
  ##25


  #XXX= this one should fail (consider improve the relative regex)
  print "\n***** With multiple matches: Alsjdedjf.\n";

  $line = "Alsjdedjf";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $user->resetAllCounters();
  ##26

  print "\n***** With multiple matches: ABCDEFG ZKGVZKHV.\n";

  $line = "ABCDEFG ZKGVZKHV";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 1);
  $user->resetAllCounters();
  #27

  print "\n***** With numbers: 1234.\n";

  $line = "1234";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 0);
  $user->resetAllCounters();
  #28


  print "\n***** With numbers and letters: 1234 AH AH AH.\n";

  $line = "1234 AH AH AH";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 1);
  $user->resetAllCounters();
  #29


  print "\n***** With letters and numbers: AH AH AH A 1234.\n";

  $line = "AH AH AH A 1234";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 1);
  $user->resetAllCounters();
  #30


  print "\n***** With ponctuation: HE !.\n";

  $line = "HE !";
  $user->findCapslock($line);
  $t->test("getCapslock", $user->getCapslock(), 1);
  $user->resetAllCounters();
  #31


  print "\n***** Find lol in various strings and ways:\n";

  $line = "lol";
  $user->findLol($line);
  $t->test("lol: getLol", $user->getLol(), 1);
  $user->resetAllCounters();

  $line = "LOL";
  $user->findLol($line);
  $t->test("LOL: getLol", $user->getLol(), 1);
  $user->resetAllCounters();

  $line = "LoL";
  $user->findLol($line);
  $t->test("LoL: getLol", $user->getLol(), 1);
  $user->resetAllCounters();

  $line = "this is a lolcat";
  $user->findLol($line);
  $t->test("This is a lolcat: getLol", $user->getLol(), 1);
  $user->resetAllCounters();

  #XXX: counter incremented of only 1
  $line = "LoL LOL lol";
  $user->findLol($line);
  $t->test("LoL LOL lol: getLol", $user->getLol(), 1);
  $user->resetAllCounters();

  ##36

  $this->{'result'} = $t->myTestsDone();
}

1;
