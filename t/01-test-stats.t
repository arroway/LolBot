#! /usr/bin/env perl -Tw

use strict;
use warnings;
use App::LolBot::Stats;
use Test::More tests => 14;

BEGIN { use_ok('App::LolBot::Stats') };

require_ok('App::LolBot::User');
require_ok('App::LolBot::Database');
require_ok('DBI');

my $stats = App::LolBot::Stats->new();

is($stats->get_log_lines(), 0);
is($stats->get_nick_list(), "");
my $date = $stats->get_date();
is($stats->get_time(), undef);

print "\n***** There is one new nickname.\n";

$stats->add_nick("arroway");
is($stats->get_nick_list(), "arroway ");

$stats->list_nick("arroway_");
is($stats->get_nick_list(), "arroway arroway_ ");

print "\n***** There are many new nicknames.\n";

my @nicks = "lolbot you";
$stats->list_nick(@nicks);
is($stats->get_nick_list(), "arroway arroway_ lolbot you ");

print "\n*****The nickname is already registered.\n";

@nicks = "arroway";
$stats->list_nick(@nicks);
is($stats->get_nick_list(), "arroway arroway_ lolbot you ");

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

    is($stats->get_log_lines(), $count);
    $count += 1;
  }
  else{
    is($stats->get_log_lines(), $count-1);
  }
}

1;
