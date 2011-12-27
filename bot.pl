#! /usr/bin/env perl;

use strict;
use warnings;
use Irc;
use Stats;

my $host = "irc.minet.net";
my $port = 6667;
my $nick = "LolBot";
my $chan = "#pourlesbots"; 

my $server = Irc->new($host,$port); #Connect the bot to the server
my $stats = Stats->new();           #Start a new stats web page

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
    recInitialNickList(@args) if ($cmd eq "353");
    newJoin($prefix) if ($cmd eq "JOIN");
    changeNick($args[1]) if ($cmd eq "NICK");

    #Increment the stats variables for the user that just wrote
    if ($cmd eq "PRIVMSG"){

      #if ($args[@args-1] =~ m/ (bonjour|salut) $nick/i){
      #$userNick = 
      #incr logLines
      #...
      }
    }

    $stats->log($cmd);

}

sub recInitNickList(){
  
  my ($foo, @nicklist) = @_:
  $stats->listNick(@nicklist); 
  $stats->printNicklist();
}
      
sub newJoin(){

  my $prefix = @_;
  my $userNick = ($prefix =~ m/:(.*)@/);
  $stats->addNick($userNick);
  $stats->printNicklist();
}

sub changeNick(){

  my $userNick = @_;
  $stats->addNick($userNick);
  $stats->printNicklist();
}

exit 0;
