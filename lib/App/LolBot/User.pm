package App::LolBot::User;

use App::LolBot::Database;
use strict;
use warnings;

sub new{

  my ($class, $name) = @_;
  my ($this) = {
    'db'            => App::LolBot::Database->connect(),
    'name'          => $name,
    'capslock'      => 0,
    'exclamative'   => 0,
    'interrogative' => 0,
    'lol'           => 0,
    'log'           => 0
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
    $this->{'log'} = 0;
  }
}

#sub loadData{
#  my ($this) = @_;
#  App::LolBot::Database->do("INSERT INTO nicknames (name, capslock, exclamative, interrogative, lol, log) VALUES ('$this->{'name'}', 
#    $this->{'capslock'}, 
#    $this->{'exclamative'}, 
#    $this->{'interrogative'}, 
#    $this->{'lol'},
#    $this->{'log'})");
  #App::LolBot::Database->commit();
#}

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
    print "$this->{'lol'}\n";
    return $this->{'lol'};
  }
}

sub getLog{
  my ($this) = @_;
  if (ref($this)){
    print "$this->{'log'}\n";
    return $this->{'log'};
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
    App::LolBot::Database->update($this->{'name'}, "capslock", $this->{'capslock'});
  }
}

sub findExclamative{
  
  my ($this,$line) = @_;
  #XXX
  if ($line =~ m/[\!]/ ){
    $this->{'exclamative'} += 1;
    App::LolBot::Database->update($this->{'name'}, "exclamative", $this->{'exclamative'});
  }  
}

sub findInterrogative{
  
  my ($this,$line) = @_;
  #XXX
  if ($line =~ m/[\?]/ ){
    $this->{'interrogative'} += 1;
    App::LolBot::Database->update($this->{'name'}, "interrogative", $this->{'interrogative'});
  }  
}

sub findLol{
  
  my ($this,$msg) = @_;
  print "findlol line: $msg\n";
  while ($msg =~ m/lol/g){
    $this->{'lol'} += 1;
    App::LolBot::Database->update($this->{'name'}, "lol", $this->{'lol'});
  }
}

sub logUser{
  my ($this) = @_;
  $this->{'log'} += 1;
  App::LolBot::Database->update($this->{'name'}, "log", $this->{'log'});
 
}

1;
