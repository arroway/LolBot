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
  $self->log_lines( $self->log_lines + 1 );
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
      if ($key =~ m/([a-zA-Z0-9%~\[\]\(\).<>&@_-\:+]+)/){
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
  my $chan = shift;
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
      $nick_list[$i]->find_facepalm($msg);
      return;
     }
   }
}

sub print_log {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':#' . $self->log_lines . ' lignes ';
  $string .= 'depuis ' . $self->date . ' ' . $self->time . ' ';
  
  my %hash = ();
  my $key = '';
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ $nick_list[$i]->get_name() } = $nick_list[$i]->get_log();
  }
   
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }
  
  return $string;
}


sub print_rage_o_meter {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# Rage-o-meter: '; 
  my %hash = ();
  my $key = '';
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ $nick_list[$i]->get_name() } = $nick_list[$i]->get_rage();
  }
   
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }
  return $string;
}

sub print_lol {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# Top Lol\'ers: ';
  my %hash = ();
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ $nick_list[$i]->get_name() } = $nick_list[$i]->get_lol();
  }
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }

  return $string;
}

sub print_capslock {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# TOP CAPSLOCKERS: ';
  my %hash = ();
  my $key = '';
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ uc $nick_list[$i]->get_name() } = $nick_list[$i]->get_capslock();
  }
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }
   
  return $string;
}

sub print_interrogative {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# Top Questions: ';
  my %hash = ();
  my $key = '';
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ $nick_list[$i]->get_name() } = $nick_list[$i]->get_interrogative();
  }
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }
   
  return $string;
}

sub print_facepalm {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':# Top Facepalms: ';
  my %hash = ();
  my $key = '';
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ $nick_list[$i]->get_name() } = $nick_list[$i]->get_facepalm();
  }
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }
   
  return $string;
}

1;
