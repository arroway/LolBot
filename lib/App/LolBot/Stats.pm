package App::LolBot::Stats;

use Any::Moose;
use App::LolBot::User;
use POSIX qw(strftime);

use constant FALSE => 0;
use constant TRUE => 1;

has log_lines => (
  isa => 'Int',
  is => 'rw',
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

sub get_log_lines{
  my $self = shift;
  return $self->log_lines if ref($self);
}

sub get_nick_list{
  my $self = shift;
  my $string = "";
  if (ref($self)){
    foreach my $nickey (@{$self->nick_list}){
       $string .= "$nickey->name ";
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

sub log(){
  my $self = shift;
  my $cmd = @_;
  if ($cmd eq "JOIN" or
      $cmd eq "NICK" or 
      $cmd eq "PRIVMSG"){
    
    $self->log_lines( $self->log_lines + 1 );
  }
}

sub add_nick{
  my $self = shift;
  my $new_nick = shift;
  my $present = FALSE;
  for my $nick (@{$self->nick_list}){
    if ($nick->name eq $new_nick){
      $present = TRUE;     
    }
  }

  if ($present == FALSE){
    my $new_nick_object = 
      App::LolBot::User->new( 
        name => $new_nick,
    );

    push((@{$self->nick_list}), $new_nick_object);
  }
}

sub list_nick(){
  my $self = shift;
  my @nicks = shift;
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
  my $foo = shift;
  my @nicklist = shift;
  $self->list_nick($nicklist[0]); 
  $self->print_nick_list();
}

sub new_join{
  my $self = shift;
  my $prefix = shift;
  my $user_nick = "";
  if ($prefix =~ m/:(.*)!/){
    $user_nick = $1;
  }
  $self->add_nick($user_nick);
  $self->print_nick_list();
}

sub change_nick{
  my $self = shift;
  my $user_nick = shift;
  if($user_nick =~ m/:(.*)/){
    $user_nick = $1;
  }
  $self->add_nick($user_nick);
  $self->print_nick_list();
}

sub rage_o_meter {
  my $self = shift;
  my $rageur = shift;

  my @nick_list = (@{$self->nick_list}); 
  
  for (my $i=0; $i< @nick_list; $i++){  
    if ($rageur eq $nick_list[$i]->name){
      $nick_list[$i]->add_rage();
      return;
    }
  }
}

sub rec_stats{
  my $self = shift;
  my $user_nick = shift;
  my $msg = shift;
  my @nick_list = (@{$self->nick_list}); 
  
  for (my $i=0; $i< @nick_list; $i++){  
    if ($user_nick eq $nick_list[$i]->name){
 
      $nick_list[$i]->log_user();
      $nick_list[$i]->find_lol($msg);
      $nick_list[$i]->find_interrogative($msg);
      $nick_list[$i]->find_capslock($msg);
      return;
     }
   }
}

sub print_log {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':#' . $self->log_lines . ' lines ';
  $string .= 'since ' . $self->date . ' ' . $self->time . ' ';
  
  for (my $i=0; $i< @nick_list; $i++){  
    $string .= $nick_list[$i]->get_name() . ' (' . $nick_list[$i]->get_logs() . '), ';
  }
  
  return $string;
}


sub print_rage_o_meter {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# Rage-o-meter: '; 
  for (my $i=0; $i< @nick_list; $i++){  
    $string .= $nick_list[$i]->get_name() . ' (' . $nick_list[$i]->get_rage() . '), ';
  }
  
  return $string;
}

sub print_lol {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = '# Top Lol\'ers: ';
  for (my $i=0; $i< @nick_list; $i++){  
    $string .= $nick_list[$i]->get_name() . ' (' . $nick_list[$i]->get_lol() . '), ';
  }

  return $string;
}

sub print_capslock {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# TOP CAPSLOCKERS: ';
  
  for (my $i=0; $i< @nick_list; $i++){  
    $string .= $nick_list[$i]->get_name() . ' (' . $nick_list[$i]->get_capslock() . ') ';
  }
  
  return $string;
}

sub print_interrogative {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# Top Questions ';
  for (my $i=0; $i< @nick_list; $i++){  
    $string .= $nick_list[$i]->get_name() . ' (' . $nick_list[$i]->get_interrogative() . '), ';
  }

  return $string;
}


1;
