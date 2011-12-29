package User;
use strict;
use warnings;


sub new{

  my ($class) = @_;
  my ($this) = {
    'capslock'      => 0,
    'exclamative'   => 0,
    'interrogative' => 0
    #...
  };

  bless($this,$class);
  return $this;
}

sub resetAll{
  my ($this) = @_;
  if (ref($this)){
    $this->{'capslock'} = 0;
    $this->{'exclamative'} = 0;
    $this->{'interrogative'} = 0;
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

sub findCapslock{
  
  #in argument: what has just said the user
  my ($this,$line) = @_;

  #XXX: elaborate regex
  if ($line =~ m/([0-9!\?:;,=\+\(\)\.\/\t\n\r\f])*?/ and
      $line =~ m/[A-Z]+?/ and
      not $line =~ m/[a-z]+?/){
    $this->{'capslock'} += 1;
    #print $this->{'capslock'};
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


1;
