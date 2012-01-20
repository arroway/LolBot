#! /usr/bin/env perl;

use App::LolBot::Bot;
use strict;
use warnings;

#use File::Basename 'dirname';
#use File::Spec;

#use lib join '/', File::Spec->splitdir(dirname(__FILE__)), 'lib';
#use lib join '/', File::Spec->splitdir(dirname(__FILE__)), '..', 'lib';


#$ENV{LOLBOT_APP} ||= "LolBot";

my $bot = App::LolBot::Bot->new();
$bot->run();
