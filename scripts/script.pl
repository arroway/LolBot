#! /usr/bin/env perl;

use App::LolBot::Bot;
use strict;
use warnings;

#use File::Basename 'dirname';
#use File::Spec;

#use lib join '/', File::Spec->splitdir(dirname(__FILE__)), 'lib';
#use lib join '/', File::Spec->splitdir(dirname(__FILE__)), '..', 'lib';


#$ENV{LOLBOT_APP} ||= "LolBot";

print "Creating new instance of LolBot...\n";

my $bot = App::LolBot::Bot->new(
  host => "irc.minet.net",
  port => 6667,
  chan => "#pourlesbots",
  nickname => "LolBot",
);

print "Bot is to being run...\n";
$bot->run();
