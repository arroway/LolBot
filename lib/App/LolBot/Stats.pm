package App::LolBot::Stats;

use strict;
use warnings;
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
  default => sub {
    my ($lines) = App::LolBot::Database->select_lines();
    return $lines;
  }
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

sub log(){
  my $self = shift;
  $self->log_lines( $self->log_lines + 1 );
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
    my $nick_obj = 
      App::LolBot::User->new( 
        name => $new_nick,
    );

    push((@{$self->nick_list}), $nick_obj);

    App::LolBot::Database->create_user($new_nick);
    
    # Initialize $new_nick_object attributes
    my ($capslock,
        $facepalm,
        $interrogative,
        $lol,
        $log,
        $osef,
        $sad,
        $happy,
        $amazed,
        $confused,
        $fpga,
        $win,
        $demoralized,
        $rage
        ) = App::LolBot::Database->select_user($new_nick);

    $nick_obj->capslock($capslock) if $capslock;
    $nick_obj->facepalm($facepalm) if $facepalm;
    $nick_obj->interrogative($interrogative) if $interrogative;
    $nick_obj->lol($lol) if $lol;
    $nick_obj->log($log) if $log;
    $nick_obj->osef($osef) if $osef;
    $nick_obj->sad($sad) if $sad;
    $nick_obj->happy($happy) if $happy;
    $nick_obj->amazed($amazed) if $amazed;
    $nick_obj->confused($confused) if $confused;
    $nick_obj->fpga($fpga) if $fpga; 
    $nick_obj->win($win) if $win; 
    $nick_obj->demoralized($demoralized) if $demoralized; 
    $nick_obj->rage($rage) if $rage; 
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
        $self->add_nick($new_nick) unless ($new_nick =~ /(\+?Vervamon|\:?LolBot)/);
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
 
      $nick_list[$i]->find_capslock($msg);
      $nick_list[$i]->find_facepalm($msg);
      $nick_list[$i]->find_interrogative($msg);
      $nick_list[$i]->find_lol($msg);
      $nick_list[$i]->log_user();
      $nick_list[$i]->find_osef($msg);
      $nick_list[$i]->find_sad($msg);
      $nick_list[$i]->find_happy($msg);
      $nick_list[$i]->find_amazed($msg);
      $nick_list[$i]->find_confused($msg);
      $nick_list[$i]->find_fpga($msg);
      $nick_list[$i]->find_win($msg);
      $nick_list[$i]->find_demoralized($msg);
  
      $self->load_data($nick_list[$i]);
      return;
     }
   }
}

sub load_data {
  my $self = shift;
  my $user = shift;

  App::LolBot::Database->update_user($user);
  App::LolBot::Database->update_bot($self->log_lines);
  return;

}

sub print_log {
  my $self = shift;
  my @nick_list = (@{$self->nick_list}); 

  my $string = ':#' . $self->log_lines . ' lignes ';
  $string .= 'depuis ' . $self->date . ' ' . $self->time . ' ';
  
  my %hash = ();
  my $key = '';
  for (my $i=0; $i < @nick_list; $i++){  
    $hash{ $nick_list[$i]->name() } = $nick_list[$i]->log();
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
    $hash{ $nick_list[$i]->name() } = $nick_list[$i]->rage();
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
    $hash{ $nick_list[$i]->name() } = $nick_list[$i]->lol();
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
    $hash{ uc $nick_list[$i]->name() } = $nick_list[$i]->capslock();
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
    $hash{ $nick_list[$i]->name() } = $nick_list[$i]->interrogative();
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
    $hash{ $nick_list[$i]->name() } = $nick_list[$i]->facepalm();
  }
  my @keys = reverse sort { $hash{$a} <=> $hash{$b} } keys %hash; 

  foreach my $key ( @keys ){
    $string .= $key . ' (' . $hash{$key} . '), ';
  }
   
  return $string;
}

1;
