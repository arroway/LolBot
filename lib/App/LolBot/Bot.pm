package App::LolBot::Bot;

use Any::Moose;
use App::LolBot::Server;
use App::LolBot::Stats;
use POSIX qw(strftime);

has host => (
  isa => 'Str',
  is => 'rw',
);

has port => (
  isa => 'Int',
  is => 'rw',
);

has chan => (
  isa => 'Str',
  is => 'rw',
);

has nickname => (
  isa => 'Str',
  is => 'rw',
);

has server => (
  isa => 'App::LolBot::Server',
  is => 'rw',
);

has stats => (
  isa => 'App::LolBot::Stats',
  is => 'rw',
);


#Connection to a IRC Server
sub connect {
  my $self = shift;

  print "Connecting on " . $self->host . ":" . $self->port . "...\n";

  $self->server(
    App::LolBot::Server->new(
      host => $self->host,
      port => $self->port)
  );

  $self->server->init_socket();
}
 
#For collecting stats about the chan users.
sub collect_statistics {
  my $self = shift;

  print "New stats collector is being created...\n";
  
  $self->stats(
    App::LolBot::Stats->new(
      db => App::LolBot::Database->instance(),
      logLines => 0,
      date => strftime("%Y-%m-%d", localtime()),
      time => strftime("%Y-%m-%d", localtime()),
      #logTime => 0,
    )
  );
}

sub run {
  my $self = shift;
  
  print "*** LolBot initialization... ***\n";
  
  $self->connect();
  $self->collect_statistics();

  print "\nLet's run ! \n\n";

  while(1){

    while(my ($prefix, $cmd, @args) = $self->server->recv()){

      #Identify the bot on the server
      if ($cmd eq "NOTICE" && $args[0] eq "AUTH"){

        print "Identifying itself  on the server...\n";
        
        $self->server->send("NICK", $self->nickname);
	      $self->server->send("USER", ($self->nickname, $self->nickname, $self->host, ":" . $self->nickname));
      }

      if ($cmd eq "376"){
        print "Joining channel " . $self->chan . "...\n";
        $self->server->send("JOIN", ($self->chan));
      }

      #Answer to the ping of the server to stay connected
      $self->server->send("PONG", ($args[@args-1])) if ($cmd eq "PING");
    
      #Deal with new nicknames   
      $self->stats->init_nick_list(@args) if ($cmd eq "353");
      $self->stats->new_join($prefix) if ($cmd eq "JOIN");
      $self->stats->change_nick($args[1]) if ($cmd eq "NICK");


      if ($cmd eq "PRIVMSG"){
      
        my ($chan, $msg) = @args;
        my $user_nick = "";
        if ($prefix =~ m/:(\w+)!/){
          $user_nick = $1;
        }

        $self->stats->log_user($user_nick);
        $self->stats->rec_stats($user_nick,$msg);
        
      }

      $self->stats->log($cmd);
    }
  }
}

1;
