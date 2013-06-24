package App::LolBot::User;

use Any::Moose;

has name => (
  isa => 'Str',
  is => 'rw',
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

has rage => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has capslock => (
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
    $self->rage = 0;
    $self->capslock = 0;
    $self->log = 0;
  }
}

sub get_name{
  my $self = shift;
  return $self->name if ref($self);
}

sub get_capslock{
  my $self = shift;
  return $self->capslock if ref($self);
}

sub get_exclamative{
  my $self = shift;
  return $self->exclamative if ref($self);
}

sub get_interrogative{
  my $self = shift;
  return $self->interrogative if ref($self);
}

sub get_lol{
  my $self = shift;
  return $self->lol if ref($self);
}

sub get_rage {
  my $self = shift;
  return $self->rage if ref($self);
}

sub get_log {
  my $self = shift;
  return $self->log if ref($self);
}

sub find_capslock{
  
  #in argument: what has just said the user
  my $self = shift;
  my $line = shift;

  #XXX: elaborate regex
  if ($line =~ m/([0-9!\?:;,=\+\(\)\.\/\t\n\r\f])*?/ and
      $line =~ m/[A-Z]+?/ and
      not $line =~ m/[a-z]+?/){
    $self->capslock( $self->capslock + 1 );
  }
}

sub find_interrogative{
  my $self = shift;
  my $line = shift;
  #XXX
  if ($line =~ m/\?/g ){
    $self->interrogative( $self->interrogative + 1 );
  }  
}

sub find_lol{
  my $self = shift;
  my $msg = shift;
  while ($msg =~ m/lol/g){
    $self->lol( $self->lol + 1 );
  }
}

sub add_rage {
  my $self = shift;
  $self->rage( $self->rage + 1 );
}

sub log_user{
  my $self = shift;
  $self->log( $self->log + 1 );
}

1;
