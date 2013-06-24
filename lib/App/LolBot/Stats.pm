package App::LolBot::Stats;

use Any::Moose;
use App::LolBot::User;
use App::LolBot::Database;
use DBI;
use POSIX qw(strftime);

use constant FALSE => 0;
use constant TRUE => 1;

has db => (
  isa => 'App::LolBot::Database',
  is => 'rw',
);

has log_lines => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has nick_list => (
  isa => 'ArrayRef',
  is => 'rw',
  default => sub {[]},
);

has date => (
  isa => 'Str',
  is => 'rw',
);

has time => (
  isa => 'Str',
  is => 'rw',
);

#has logTime => (
#);
 
sub loadData{
  my $self = shift;
  foreach my $nickey (@{$self->nick_list}){
    $nickey->loadData();
  }  
}

sub get_log_lines{
  my $self = shift;
  return $self->log_lines if ref($self);
}

sub get_nick_list{
  my $self = shift;
  my $string = "";
  if (ref($self)){
    foreach my $nickey (@{$self->nick_list}){
       $string .="$nickey->name ";
    }
    return $string;
  }
}

sub get_date{
  my $self = shift;
  return $self->date if ref($self);
}

sub get_time{
  my $self = shift;
  return $self->time if ref($self);
}

#sub get_log_time{
#  my $self = shift;
#  if (ref($self)){
#    return $self->{'logTime'};
#  }
#}

sub log(){
  my $self = shift;
  my $cmd = @_;
  if ($cmd eq "JOIN" or
      $cmd eq "NICK" or 
      $cmd eq "PRIVMSG"){
    
    $self->log_lines += 1;
  }
}

sub log_user(){
  my $self = shift;
  my $userNick = @_;
  
  my @nick_list = (@{$self->nick_list}); 
  
  for (my $i=0; $i < @nick_list; $i++){
     if ($userNick eq $nick_list[$i]->name){
       $nick_list[$i]->logUser();
       print "logUser: " . $userNick;
       $nick_list[$i]->getLog();
     }
   }
}

sub add_nick{
  my $self = shift;
  my ($new_nick) = @_;
  my $present = FALSE;
  for my $nick (@{$self->nick_list}){
    if ($nick->name eq $new_nick){
      $present = TRUE;     
    }
  }

  if ($present == FALSE){
    my $new_nick_object = 
      App::LolBot::User->new( 
        db => $self->db,
        name => $new_nick,
    );

    push((@{$self->nick_list}), $new_nick_object);
    App::LolBot::Database->insert($new_nick);
  }
}

sub list_nick(){
  my $self = shift;
  my (@nicks) = @_;
  my $new_nick = "";

  foreach my $key (@nicks){
    
    while ($key){
      if ($key =~ m/(\w+)/){
        $new_nick = $1;
        $key = $';
        $self->add_nick($new_nick);
      }
    }
  }
}

sub print_nick_list{
 
  my $self = shift;
  foreach my $nickey (@{$self->nick_list}){
    print $nickey->name . "\n";
  }  
}

sub init_nick_list{
  
  my $self = shift;
  my ($foo, @nicklist) = @_;
  $self->list_nick($nicklist[0]); 
  $self->print_nick_list();
}

sub new_join{
  my $self = shift;
  my ($prefix) = @_;
  my $user_nick = "";
  if ($prefix =~ m/:(.*)!/){
    $user_nick = $1;
  }
  $self->add_nick($user_nick);
  $self->print_nick_list();
}

sub change_nick{
  my $self = shift;
  my ($user_nick) = @_;
  if($user_nick =~ m/:(.*)/){
    $user_nick = $1;
  }
  $self->add_nick($user_nick);
  $self->print_nick_list();
}

sub rec_stats{
  my $self = shift;
  my ($user_nick,$msg) = @_;
  my @nick_list = (@{$self->nick_list}); 
  
  for (my $i=0; $i< @nick_list; $i++){  
    if ($user_nick eq $nick_list[$i]->name){
 
      $nick_list[$i]->find_lol($msg);
      $nick_list[$i]->find_exclamative($msg);
      $nick_list[$i]->find_interrogative($msg);
      $nick_list[$i]->find_capslock($msg);
     }
   }
}

1;
