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
    i
    #Answer to the ping of the server to stay connected
    $server->send("PONG", ($args[@args-1])) if ($cmd eq "PING");
    
    #Deal with new nicknames   
    recInitNickList(@args) if ($cmd eq "353");
    newJoin($prefix) if ($cmd eq "JOIN");
    changeNick($args[1]) if ($cmd eq "NICK");


    if ($cmd eq "PRIVMSG"){
      
      my ($chan, $msg) = @args;
      my $userNick = "";
      if ($prefix =~ m/:(\w+)!/){
        $userNick = $1;
      }

      recLol($userNick,$msg);
    }

    $stats->log($cmd);
  }
}

sub recInitNickList{
  
  my ($foo, @nicklist) = @_;
  $stats->listNick($nicklist[0]); 
  $stats->printNickList();
}
      
sub newJoin{

  my ($prefix) = @_;
  my $userNick = "";
  print "prefix: $prefix";
  if ($prefix =~ m/:(.*)!/){
    $userNick = $1;
  }
  print "in newJoin: $userNick";
  $stats->addNick($userNick);
  $stats->printNickList();
}

sub changeNick{

  my ($userNick) = @_;
  if($userNick =~ m/:(.*)/){
    $userNick = $1;
  }
  $stats->addNick($userNick);
  $stats->printNickList();
}

sub recLol{
  
  my ($userNick,$msg) = @_;
  my @nickList = (@{$stats->{'nickList'}}); 
  for (my $i=0; $i< @nickList; $i++){
     if ($userNick eq $nickList[$i]->{'name'}){
       $nickList[$i]->findLol($msg);
       my $lolCount = $nickList[$i]->getLol();
       print "$userNick getLol: $lolCount \n";
     }
   }
}

exit 0;
