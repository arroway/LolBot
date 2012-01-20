#! /usr/bin/env perl;

use MyTests;
use strict;
use warnings;

require 'bot.pl';

my $nbTests = 1;

#my $server = Irc->new();
my $t = MyTests->new($nbTests);

my @nicklist = "arroway lolbot you";
recInitNickLIst(@nicklist);
$t->test->("recInitNickList", recInitNickLIst(@nicklist), "arroway lolbot you");
##5

print "\n***** There is one new nickname.\n";


$t->myTestsDone();
