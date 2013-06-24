package App::LolBot::User;

use App::LolBot::Database;
use Any::Moose;

has db => (
  isa => 'App::LolBot::Database',
  is => 'rw',
);

has name => (
  isa => 'Str',
  is => 'rw',
);

has capslock => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has exclamative => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has interrogative => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has lol => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has log => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);


sub reset_all_counters{
  my $self = shift;
  if (ref($self)){
    $self->capslock = 0;
    $self->exclamative = 0;
    $self->interrogative = 0;
    $self->lol = 0;
    $self->log = 0;
  }
}

#sub load_data{
#  my ($self) = @_;
#  App::LolBot::Database->do("INSERT INTO nicknames (name, capslock, exclamative, interrogative, lol, log) VALUES ('$self->{'name'}', 
#    $self->{'capslock'}, 
#    $self->{'exclamative'}, 
#    $self->{'interrogative'}, 
#    $self->{'lol'},
#    $self->{'log'})");
  #App::LolBot::Database->commit();
#}

sub get_name{
  my $self = shift;
  return $self->name if ref($self);
}

sub get_capslock{
  my $self = shift;
  return $self->capslock if ref($self);
 
}

sub getExclamative{
  my $self = shift;
  return $self->exclamative if ref($self);
}

sub getInterrogative{
  my $self = shift;
  return $self->interrogative if ref($self);
}

sub getLol{
  my $self = shift;
  return $self->lol if ref($self);
}

sub getLog {
  my $self = shift;
  return $self->log if ref($self);
}


sub find_capslock{
  
  #in argument: what has just said the user
  my $self = shift;
  my $line = @_;

  #XXX: elaborate regex
  if ($line =~ m/([0-9!\?:;,=\+\(\)\.\/\t\n\r\f])*?/ and
      $line =~ m/[A-Z]+?/ and
      not $line =~ m/[a-z]+?/){
    $self->capslock += 1;
    App::LolBot::Database->update($self->name, "capslock", $self->capslock);
  }
}

sub find_exclamative{
  my $self = shift;
  my $line = @_;
  #XXX
  if ($line =~ m/[\!]/ ){
    $self->exclamative += 1;
    App::LolBot::Database->update($self->name, "exclamative", $self->exclamative);
  }  
}

sub find_interrogative{
  my $self = shift;
  my $line = @_;
  #XXX
  if ($line =~ m/[\?]/ ){
    $self->interrogative += 1;
    App::LolBot::Database->update($self->name, "interrogative", $self->interrogative);
  }  
}

sub find_lol{
  my $self = shift;
  my $msg = @_;
  print "findlol line: $msg\n";
  while ($msg =~ m/lol/g){
    $self->lol += 1;
    App::LolBot::Database->update($self->name, "lol", $self->lol);
  }
}

sub log_user{
  my $self = shift;
  $self->log += 1;
  App::LolBot::Database->update($self->name, "log", $self->log);
 
}

1;
