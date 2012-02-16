package App::LolBot::User;

use App::LolBot::Database;
use strict;
use warnings;

sub new{

  my ($class, $name) = @_;
  my ($this) = {
    'db'            => App::LolBot::Database->connect("dbi:SQLite::data.db", {AutoCommit => 1, RaiseError => 0}),
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

sub loadData{
  my ($this) = @_;
  App::LolBot::Database->do("INSERT INTO nicknames (name, capslock, exclamative, interrogative, lol) VALUES ('$this->{'name'}', 
    $this->{'capslock'}, 
    $this->{'exclamative'}, 
    $this->{'interrogative'}, 
    $this->{'lol'})");
  App::LolBot::Database->commit();
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
    print "$this->{'lol'}\n";
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
  
  my ($this,$msg) = @_;
  print "findlol line: $msg\n";
  if ($msg =~ m/(lol)+/i){
    $this->{'lol'} += 1;
    print "in findlol: $this->{'lol'}\n";

  }
}

1;
