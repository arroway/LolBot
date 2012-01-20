## Originally written by Guilhem Tiennot    ##
## Excepting some slight committed changes  ##

package App::LolBot::Irc;
use strict;
use warnings;
use IO::Socket;

# Création d'un canal de connexion IRC avec le serveur $host.
# Note : le paramètre $host peut être indifféremment
# un nom de domaine ou une adresse IP.

sub new
{
  my ($class,$host,$port) = @_;
  my $this = {};

  bless($this,$class);
  $this->{SOCKET} = IO::Socket::INET->new(
		      Proto => "tcp",
		      PeerAddr => $host,
		      PeerPort => $port,
		      Blocking => 0
		    )
   or die "Impossible de se connecter au serveur.\n";

  return $this;
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

sub recv
{
  my ($this) = @_;
  my $socket = $this->{SOCKET};
  my $line = <$socket>;
  my @args = (0,0,[]);

  if ($line){
   @args = ($line =~ m/^(\:[^ \t]+[ \t])??([0-9A-Za-z]+?[ \t])([^ \t]+?[ \t])*?(\:.+)?\r\n$/);
  
  # Suppression de l'espace final, s'il est présent
  for (my $i=0; $i<@args; $i++)
  {
    #XXX: Use of uninitialized value $args[..] in pattern match (m//)
    if ($args[$i] =~ m/.*[ \t]$/)
    {
      $args[$i] =~ s/.$//;
    }
  }

  print $line;
  }  
  return @args;
}

# Envoie une commande IRC au serveur.
#
# Le schéma à respecter est le suivant : ($cmd,@args).
#
# Il n'est pas possible d'envoyer des commandes comportant des
# préfixes.

sub send
{
  my ($this,$cmd,@args) = @_;
  my $socket = $this->{SOCKET};

  $cmd = join(" ",$cmd,@args,"\r\n");

  print $socket $cmd;
  print $cmd;
}

1; # Code retour indiquant que le module a été correctement chargé.
