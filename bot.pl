#! /usr/bin/env perl;

use strict;
use Irc;
#use Times::HiRes;

my $host = "irc.minet.net";
my $nick = "BotArroway";
my $chan = "#pourlesbots"; 

my $server = Irc->new("irc.minet.net", 6667);

while(1)
{
  #list
  # si on ne reçoit rien
  if (!((my ($prefix, $cmd, @args)) = $server->recv()))
  {
    sleep(1);
    #Times::Hires::usleep(100000);
  }
  else
  {
    if ($cmd eq "NOTICE")
    {
      if ($args[0] eq "AUTH")
      {
        $server->send("NICK", ($nick));
	$server->send("USER", ($nick, $nick, $host, ":$nick"));
      }	
    }
   
    $server->send("JOIN", ($chan)) if ($cmd eq "376");

    $server->send("PONG", ($args[@args-1])) if ($cmd eq "PING");
   
    if ($cmd eq "PRIVMSG"){
      if ($args[@args -1] =~ m/ (bonjour|salut) $nick/i){
        $server->send("PRIVMSG", ($chan, ":Bonjour"));
      }
    }
  }


}

exit 0;
