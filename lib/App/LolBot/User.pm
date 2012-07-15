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
  default => sub {
    my $self = shift;
    my $counter = 0;
    return $counter;
  }
);

has exclamative => (
  isa => 'Int',
  is => 'rw',
  default => sub {
    my $self = shift;
    my $counter = 0;
    return $counter;
  }
);

has interrogative => (
  isa => 'Int',
  is => 'rw',
  default => sub {
    my $self = shift;
    my $counter = 0;
    return $counter;
  }
);

has lol => (
  isa => 'Int',
  is => 'rw',
  default => sub {
    my $self = shift;
    my $counter = 0;
    return $counter;
  }
);

has log => (
  isa => 'Int',
  is => 'rw',
  default => sub {
    my $self = shift;
    my $counter = 0;
    return $counter;
  }
);


sub resetAllCounters{
  my $self = shift;
  if (ref($self)){
    $self->capslock = 0;
    $self->exclamative = 0;
    $self->interrogative = 0;
    $self->lol = 0;
    $self->log = 0;
  }
}

#sub loadData{
#  my ($self) = @_;
#  App::LolBot::Database->do("INSERT INTO nicknames (name, capslock, exclamative, interrogative, lol, log) VALUES ('$self->{'name'}', 
#    $self->{'capslock'}, 
#    $self->{'exclamative'}, 
#    $self->{'interrogative'}, 
#    $self->{'lol'},
#    $self->{'log'})");
  #App::LolBot::Database->commit();
#}

sub getName{
  my $self = shift;
  if (ref($self)){
    return $self->name;
  }
}

sub getCapslock{
  my $self = shift;
  if (ref($self)){
    return $self->capslock;
  }
 
}

sub getExclamative{
  my $self = shift;
  if (ref($self)){
    return $self->exclamative;
  }
}

sub getInterrogative{
  my $self = shift;
  if (ref($self)){
    return $self->interrogative;
  }
}

sub getLol{
  my $self = shift;
  if (ref($self)){
    print "$self->lol\n";
    return $self->lol;
  }
}

sub getLog {
  my $self = shift;
  if (ref($self)){
    print "$self->log\n";
    return $self->log;
  }
}


sub findCapslock{
  
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

sub findExclamative{
  my $self = shift;
  my $line = @_;
  #XXX
  if ($line =~ m/[\!]/ ){
    $self->exclamative += 1;
    App::LolBot::Database->update($self->name, "exclamative", $self->exclamative);
  }  
}

sub findInterrogative{
  my $self = shift;
  my $line = @_;
  #XXX
  if ($line =~ m/[\?]/ ){
    $self->interrogative += 1;
    App::LolBot::Database->update($self->name, "interrogative", $self->interrogative);
  }  
}

sub findLol{
  my $self = shift;
  my $msg = @_;
  print "findlol line: $msg\n";
  while ($msg =~ m/lol/g){
    $self->lol += 1;
    App::LolBot::Database->update($self->name, "lol", $self->lol);
  }
}

sub logUser{
  my $self = shift;
  $self->log += 1;
  App::LolBot::Database->update($self->name, "log", $self->log);
 
}

1;
