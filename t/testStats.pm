#! /usr/bin/env perl;

package testStats;
use Stats;
use MyTests;
use strict;
use warnings;

sub new{
  my ($class) = @_;
  my ($this) = {
    'name'   => 'testStats',
    'result' => ''
  }; 

  bless($this, $class);
  return $this;
}

sub run{

  my ($this) = @_;
  my $nbTests = 14;
  my $stats = Stats->new();


  my $t = MyTests->new(($this->{'name'}),$nbTests);

  print "***** Just after initializtion:\n";

  $t->test("getlogLines", $stats->getLogLines(), 0);
  $t->test("getNickList", $stats->getNickList(), "");
  if ($stats->getDate()){ 
    $t->test("getDate", "not null", "not null"); } 
  else{ 
    $t->test("getDate", "null", "not null"); }
  if ($stats->getTime()){
  $t->test("getTime", "not null", "not null"); } 
  else{
    $t->test("getTime", "null", "not null"); }
    $t->test("getLogTime", $stats->getLogTime(), 0);
  ##5

  print "\n***** There is one new nickname.\n";

  $stats->addNick("arroway");
  $t->test("addNick: getNickList", $stats->getNickList(), "arroway ");

  #reset all, destruct User objects
  #$stats->resetAll();
  ##6

  $stats->listNick("arroway_");
  $t->test("listNick with 1 arg: getNickList", $stats->getNickList(), "arroway arroway_ ");
  ##7

  print "\n***** There are many new nicknames.\n";

  my @nicks = "lolbot you";
  $stats->listNick(@nicks);
  $t->test("listNick with several values: getNickList", $stats->getNickList(), "arroway arroway_ lolbot you ");
  ##8

  print "\n*****The nickname is already registered.\n";
  
  my @nicks = "arroway";
  $stats->listNick(@nicks);
  $t->test("arroway already there: getNickList", $stats->getNickList(), "arroway arroway_ lolbot you ");
  ##9

  print "\n***** How many lines are logged ?\n";

  my @cmd = (undef, "JOIN", "NICK", "PRIVMSG", "HELLO");
  my $count = 1;
  #XXX
  print "XXX: there are warnings with the case undef\n\n";
  foreach my $key (@cmd){
 
      $stats->log($key);
      if ($key eq "JOIN" or 
          $key eq "NICK" or
          $key eq "PRIVMSG"){

          $t->test("getLogLines", $stats->getLogLines(), $count);
          $count += 1;
      }
      else{
        $t->test("getLogLines", $stats->getLogLines(), $count-1);
      }
  }
  ##14

  print "\n--->\t";
  $this->{'result'} = $t->myTestsDone();

}

1;
