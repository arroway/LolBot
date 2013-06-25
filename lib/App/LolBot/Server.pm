package App::LolBot::Server;

use Any::Moose;
use IO::Socket;

has host => (
  isa => 'Str',
  is => 'rw',
);

has port => (
  isa => 'Int',
  is => 'rw',
);

has socket => (
  isa => 'IO::Socket::INET',
  is => 'rw', 
);

sub init_socket {
  my $self = shift;

  print "Socket init... \n";

  $self->socket(
    IO::Socket::INET->new(
		      Proto => "tcp",
		      PeerAddr => $self->host,
		      PeerPort => $self->port,
		      Blocking => 0
		    )
  
  )
  or die "Can't connect to the server " . $self->host . " at port " . $self->port . "\n";  
}


# Retourne une commande IRC reçue au format ($prefix,$cmd,@args).
#
# Les suffixes constituent un seul argument, toujours le dernier
# du tableau. Ainsi, pour récupérer un suffixe, il faut prendre
# la dernière case du tableau, car il peut y avoir des cases vides
# s'il n'y a pas d'autres arguments.
#
# L'appel à la fonction est non bloquant. Ainsi, si aucune commande
# IRC n'est en attente de traitement au moment de l'appel, la fonction
# renvoie une liste vide.

sub recv {
  my $self = shift;
  my $socket = $self->socket;
  my $line = <$socket>;
  my @args = (0,0,[]);

  if ($line){
    @args = ($line =~ m/^(\:[^ \t]+[ \t])??([0-9A-Za-z]+?[ \t])([^ \t]+?[ \t])*?(\:.+)?\r\n$/);

    print "line: " . $line . "\n";
    print "1: " . $args[0] . "\n";
    print "2: " . $args[1] . "\n";
    print "3: " . $args[2] . "\n";
    print "4: " . $args[3] . "\n";

    #Suppression de l'espace final, s'il est présent
    for (my $i=0; $i<@args; $i++){
      #XXX: Use of uninitialized value $args[..] in pattern match (m//)
      if (defined($args[$i])){
        if ($args[$i] =~ m/.*[ \t]$/){
          $args[$i] =~ s/.$//;
        }
      }
    }
  } 
  return @args;
}

# Envoie une commande IRC au serveur.
#
# Le schéma à respecter est le suivant : ($cmd,@args).
#
# Il n'est pas possible d'envoyer des commandes comportant des
# préfixes.

sub send {
  my $self = shift;
  my ($cmd,@args) = @_;

  my $socket = $self->socket;

  $cmd = join(" ",$cmd,@args,"\r\n");
  print $socket $cmd;
  print $cmd;
}

1; # Code retour indiquant que le module a été correctement chargé.
