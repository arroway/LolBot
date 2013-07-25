package App::LolBot::User;

use strict;
use warnings;
use Any::Moose;

has name => (
  isa => 'Str',
  is => 'rw',
);

has capslock => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has facepalm => (
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

has osef => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
); 

has sad => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has happy => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has amazed => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has confused => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has fpga => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has win => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has demoralized => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

has rage => (
  isa => 'Int',
  is => 'rw',
  default => sub {0},
);

sub find_capslock{
  
  #in argument: what has just said the user
  my $self = shift;
  my $msg = shift;

  if ($msg =~ m/([0-9!\?:;,=\+\(\)\[\]\.\/\t\n\r\f])*?/ and
      $msg =~ m/[A-Z]+?/ and
      not $msg =~ m/[a-z]+?/){
    $self->capslock( $self->capslock + 1 );
  }
}

sub find_facepalm {
  my $self = shift;
  my $msg = shift;

  while ($msg =~ m/([^\!]facepalm|[^\!]face\spalm)/ig){
    $self->facepalm( $self->facepalm + 1 );
  }
}
sub find_interrogative{
  my $self = shift;
  my $msg = shift;
  
  while ($msg =~ m/\?/g ){
    $self->interrogative( $self->interrogative + 1 );
  }  
}

sub find_lol{
  my $self = shift;
  my $msg = shift;

  while ($msg =~ m/[^\!]l(o)+l|[^\!]loul|[^\!]lulz/ig){
    $self->lol( $self->lol + 1 );
  }
}

sub log_user{
  my $self = shift;
  $self->log( $self->log + 1 );
}

sub find_osef {
  my $self = shift;
  my $msg = shift;

  while ($msg =~ m/osef/ig) {
    $self->osef( $self->osef + 1);
  }
}

sub find_sad {
  my $self = shift;
  my $msg = shift;

  while ($msg =~ m/:'?(\(|\/)/g) {
    $self->sad ($self->sad + 1);
  }
}

sub find_happy {
  my $self = shift;
  my $msg = shift;

  if ($msg =~ m/:'?(\)|D)|\^_+\^/) {
    $self->happy ($self->happy + 1);
  }
}

sub find_amazed {
  my $self = shift;
  my $msg = shift;

  if ($msg =~ m/:(o|O)/) {
    $self->amazed ($self->amazed + 1);
  }
}

sub find_confused {
  my $self = shift;
  my $msg = shift;

  if ($msg =~ m/:(x|X)/) {
    $self->confused ($self->confused + 1);
  }
}

sub find_fpga {
  my $self = shift;
  my $msg = shift;

  while ($msg =~ m/fpga|arduilol/ig) {
    $self->fpga ($self->fpga + 1);
  }
}

sub find_win {
  my $self = shift;
  my $msg = shift;

  while ($msg =~ m/\\o\//g) {
    $self->win ($self->win + 1);
  }
}

sub find_demoralized {
  my $self = shift;
  my $msg = shift;

  if ($msg =~ m/-_-/) {
    $self->demoralized ($self->demoralized + 1);
  }
}


sub add_rage {
  my $self = shift;
  $self->rage( $self->rage + 1 );
}



1;
