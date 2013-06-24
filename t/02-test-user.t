#! /usr/bin/env perl -Tw;

use strict;
use warnings;
use App::LolBot::User;
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

  my $name_user = "arroway"; 
  my $user = User->new($name_user);
  my $t = MyTests->new($this->{'name'},$nbTests);

  print "***** Just after initialization:\n";

  $t->test("get_name", $user->getName(), $name_user);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $t->test("get_exclamative", $user->get_exclamative(), 0);
  $t->test("get_interrogative", $user->get_interrogative(), 0);
  $t->test("get_lol", $user->get_lol(), 0);
  ##5

  print "\n***** With an empty line:\n";

  my $line = "";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $user->find_exclamative($line);
  $t->test("get_exclamative", $user->get_exclamative(), 0);
  $user->find_interrogative($line);
  $t->test("get_interrogative", $user->get_interrogative(), 0);
  $user->find_lol($line);
  $t->test("get_lol", $user->get_lol(), 0);
  ##9

  print "\n***** Note: After each test, the attribute counters are reset.\n";
  print   "      We assume the reset_all_counters() function does work.\n";

  print "\n***** With a single-letter string \"A\":\n";

  $line = "A";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 1);
  $user->find_exclamative($line);
  $t->test("get_exclamative", $user->get_exclamative(), 0);
  $user->find_interrogative($line);
  $t->test("get_interrogative", $user->get_interrogative(), 0);
  $user->find_lol($line);
  $t->test("get_lol", $user->get_lol(), 0);
  $user->reset_all_counters();
  ##13


  print "\n***** With a single-character string \"!\":\n";

  $line = "!";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $user->find_exclamative($line);
  $t->test("get_exclamative", $user->get_exclamative(), 1);
  $user->find_interrogative($line);
  $t->test("get_interrogative", $user->get_interrogative(), 0);
  $user->reset_all_counters();
  $user->find_lol($line);
  $t->test("get_lol", $user->get_lol(), 0);
  ##17


  print "\n***** With a single-character string \"?\":\n";

  $line = "?";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $user->find_exclamative($line);
  $t->test("get_exclamative", $user->get_exclamative(), 0);
  $user->find_interrogative($line);
  $t->test("get_interrogative", $user->get_interrogative(), 1);
  $user->reset_all_counters();
  $user->find_lol($line);
  $t->test("get_lol", $user->get_lol(), 0);
  ##21


  print "\n***** With multiple matches: ABCV ! ahvhdf ?\n";

  $line = "ABCV ! ahvhdf ?";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $user->find_exclamative($line);
  $t->test("get_exclamative", $user->get_exclamative(), 1);
  $user->find_interrogative($line);
  $t->test("get_interrogative", $user->get_interrogative(), 1);
  $user->find_lol($line);
  $t->test("get_lol", $user->get_lol(), 0);
  $user->reset_all_counters();
  ##25


  #XXX= this one should fail (consider improve the relative regex)
  print "\n***** With multiple matches: Alsjdedjf.\n";

  $line = "Alsjdedjf";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $user->reset_all_counters();
  ##26

  print "\n***** With multiple matches: ABCDEFG ZKGVZKHV.\n";

  $line = "ABCDEFG ZKGVZKHV";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 1);
  $user->reset_all_counters();
  #27

  print "\n***** With numbers: 1234.\n";

  $line = "1234";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 0);
  $user->reset_all_counters();
  #28


  print "\n***** With numbers and letters: 1234 AH AH AH.\n";

  $line = "1234 AH AH AH";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 1);
  $user->reset_all_counters();
  #29


  print "\n***** With letters and numbers: AH AH AH A 1234.\n";

  $line = "AH AH AH A 1234";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 1);
  $user->reset_all_counters();
  #30


  print "\n***** With ponctuation: HE !.\n";

  $line = "HE !";
  $user->find_capslock($line);
  $t->test("get_capslock", $user->get_capslock(), 1);
  $user->reset_all_counters();
  #31


  print "\n***** Find lol in various strings and ways:\n";

  $line = "lol";
  $user->find_lol($line);
  $t->test("lol: get_lol", $user->get_lol(), 1);
  $user->reset_all_counters();

  $line = "LOL";
  $user->find_lol($line);
  $t->test("LOL: get_lol", $user->get_lol(), 1);
  $user->reset_all_counters();

  $line = "LoL";
  $user->find_lol($line);
  $t->test("LoL: get_lol", $user->get_lol(), 1);
  $user->reset_all_counters();

  $line = "this is a lolcat";
  $user->find_lol($line);
  $t->test("This is a lolcat: get_lol", $user->get_lol(), 1);
  $user->reset_all_counters();

  #XXX: counter incremented of only 1
  $line = "LoL LOL lol";
  $user->find_lol($line);
  $t->test("LoL LOL lol: get_lol", $user->get_lol(), 3);
  $user->reset_all_counters();

  ##36

  $this->{'result'} = $t->myTestsDone();
}

1;
