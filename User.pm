package User;
use strict;
use warnings;


sub new{

  my ($class, $name) = @_;
  my ($this) = {
    'name'          => $name,
    'capslock'      => 0,
    'exclamative'   => 0,
    'interrogative' => 0,
    'lol'           => 0
    #...
  };

  bless($this,$class);
  return $this;
}

sub resetAllCounters{
  my ($this) = @_;
  if (ref($this)){
    $this->{'capslock'} = 0;
    $this->{'exclamative'} = 0;
    $this->{'interrogative'} = 0;
    $this->{'lol'} = 0;
  }
}

sub getName{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'name'};
  }
}

sub getCapslock{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'capslock'};
  }
 
}

sub getExclamative{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'exclamative'};
  }
}

sub getInterrogative{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'interrogative'};
  }
}

sub getLol{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'lol'};
  }
}

sub findCapslock{
  
  #in argument: what has just said the user
  my ($this,$line) = @_;

  #XXX: elaborate regex
  if ($line =~ m/([0-9!\?:;,=\+\(\)\.\/\t\n\r\f])*?/ and
      $line =~ m/[A-Z]+?/ and
      not $line =~ m/[a-z]+?/){
    $this->{'capslock'} += 1;
  }
}

sub findExclamative{
  
  my ($this,$line) = @_;
  #XXX
  if ($line =~ m/[\!]/ ){
    $this->{'exclamative'} += 1;
  }  
}

sub findInterrogative{
  
  my ($this,$line) = @_;
  #XXX
  if ($line =~ m/[\?]/ ){
    $this->{'interrogative'} += 1;
  }  
}

sub findLol{
  
  my ($this,$line) = @_;
  if ($line =~ m/(lol)+/i){
    $this->{'lol'} += 1;
  }
}

1;
