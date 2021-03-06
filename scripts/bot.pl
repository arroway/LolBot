#! /usr/bin/env perl;

use strict;
use warnings;
use App::LolBot::Irc;
use App::LolBot::Stats;

my $host = "irc.minet.net";
my $port = 6667;
my $nick = "LolBot";
my $chan = "#pourlesbots"; 

my $server = App::LolBot::Irc->new($host,$port); #Connect the bot to the server
my $stats = App::LolBot::Stats->new();           #Start a new stats web page


while(1){

  while(my ($prefix, $cmd, @args) = $server->recv()){

    #Identify the bot on the server
    if ($cmd eq "NOTICE" && $args[0] eq "AUTH"){
       $server->send("NICK", ($nick));
	     $server->send("USER", ($nick, $nick, $host, ":$nick"));
    }

    $server->send("JOIN", ($chan)) if ($cmd eq "376");
    
    #Answer to the ping of the server to stay connected
    $server->send("PONG", ($args[@args-1])) if ($cmd eq "PING");
    
    #Deal with new nicknames   
    $stats->InitNickList(@args) if ($cmd eq "353");
    $stats->newJoin($prefix) if ($cmd eq "JOIN");
    $stats->changeNick($args[1]) if ($cmd eq "NICK");


    if ($cmd eq "PRIVMSG"){
      
      my ($chan, $msg) = @args;
      my $userNick = "";
      if ($prefix =~ m/:(\w+)!/){
        $userNick = $1;
      }

      $stats->recLol($userNick,$msg);
    }

    $stats->log($cmd);
  }
}

exit 0;
