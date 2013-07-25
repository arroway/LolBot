package App::LolBot::Bot;

use strict;
use warnings;
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

has lines => (
  isa => 'Int',
  is => 'rw',
  default => sub {0}
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
      log_lines => 0,
      date => strftime("%Y-%m-%d", localtime()),
      time => strftime("%H:%M:%S", localtime()),
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

      if (strftime("%H:%M:%S", localtime()) eq "13:37:00"){
        $self->send(':LEEEEEET', 'PRIVMSG');
        select(undef, undef, undef, 1);
      }

      if ($self->stats->log_lines % 666 == 0 and $self->stats->log_lines != $lines) {
        $self->send(':You\'re so evil!', 'PRIVMSG');
        $lines = $self->stats->log_lines;
      }

      if ($cmd eq "PRIVMSG"){
     
        $self->stats->log();
        
        my  $msg = $args[1];
        my $user_nick = "";
        if ($prefix =~ m/:([a-zA-Z0-9%~\[\]\(\).<>&@_-\:+]+)!/){
          $user_nick = $1;
        }

        if ($msg =~ m/^:c'est qui LolBot/) {
          my $welcome = (':Bonjour, je suis un LolBot. Contrairement à ce que mon nom peut laisser penser, je ne lol pas (pas comme Fallen). !help !rtfm');
          $self->send($welcome, 'PRIVMSG');
        }

        if ($msg =~ m/^:!help$/) {
          my $help = (':LOL LOL LOL LOL LOL LOL LOL *oups*');
          $self->send($help, 'PRIVMSG');
        }

        if ($msg =~ m/^:!rtfm$/) {
          my $rtfm = (':THE FUCKING MANUAL: !rtfm (affiche cette aide), !rage [pseudo] (rage-o-meter), !lol (les lolers psychiatriques), !capslock (CAPSLOCK ! CAPSLOCK !), !questions (qui pose trop de questions ?), !facepalm');
          $self->send_notice($user_nick, $rtfm);
        }

        $self->stats->rage_o_meter($1) if $msg =~m/^:!rage\s([a-zA-Z0-9%~\[\]\(\).<>&@_-\:+]+)$/;
        my $rage = $self->stats->print_rage_o_meter($1) if $msg =~m/^:!rage$/;
        $self->send($rage, 'PRIVMSG') if ($rage);
        
        my $lol = $self->stats->print_lol($1) if $msg =~m/^:!lol$/;
        $self->send($lol, 'PRIVMSG') if ($lol);
        
        my $log = $self->stats->print_log($1) if $msg =~m/^:!log$/;
        $self->send($log, 'PRIVMSG') if ($log);
        
        my $capslock = $self->stats->print_capslock($1) if $msg =~m/^:!capslock$/;
        $self->send($capslock, 'PRIVMSG') if ($capslock);

        my $questions = $self->stats->print_interrogative($1) if $msg =~m/^:!questions$/;
        $self->send($questions, 'PRIVMSG') if ($questions);
        
        my $facepalm = $self->stats->print_facepalm($1) if $msg =~m/^:!facepalm$/;
        $self->send($facepalm, 'PRIVMSG') if ($facepalm);

        $self->stats->rec_stats($user_nick,$msg);
      }
    }
  }
}

sub send {
  my $self = shift;
  my ($output, $cmd) = @_;

  my @args = ($self->chan, $output);
  $self->server->send($cmd, @args);
}

sub send_notice {
  my $self = shift;
  my ($nick, $output) = @_;

  my @args = ($nick, $output);
  $self->server->send('NOTICE', @args);
}

1;
