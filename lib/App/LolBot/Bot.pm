#! /usr/bin/env perl;
package App::LolBot::Bot;
use strict;
use warnings;
use App::LolBot::Irc;
use App::LolBot::Stats;

sub new {
  
  my ($class) = @_;
  my ($this) = {
    'host'  =>  "irc.minet.net",
    'port'  =>  6667,
    'nick'  =>  "LolBot",
    'chan'  =>  "#pourlesbots"
};

  bless($this, $class);
  return $this;
}

sub run {

  my ($this) = @_;

  my $host = $this->{'host'};
  my $port = $this->{'port'};
  my $nick = $this->{'nick'};
  my $chan = $this->{'chan'};
  my $server = App::LolBot::Irc->new($host, $port);
  my $stats = App::LolBot::Stats->new();

  while(1){

    while(my ($prefix, $cmd, @args) = $server->recv()){

      #Identify the bot on the server
      if ($cmd eq "NOTICE" && $args[0] eq "AUTH"){
        $server->send("NICK", $nick);
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

        $stats->logUser($userNick);
        $stats->recStats($userNick,$msg);
        
      }

      $stats->log($cmd);
    }
  }
}

1;
