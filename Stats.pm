package Stats;
use User;
use strict; 
use warnings;
use POSIX qw(strftime);

use constant FALSE => 0;
use constant TRUE => 1;

sub new{
 
  my ($class) = @_;
  my ($this) = {
    'logLines'  => 0,
    'nickList'  => [],
    'date'      => strftime("%Y-%m-%d", localtime()),
    'time'      => strftime("%H:%M:%S", localtime()),
    'logTime'   => 0
  };

  bless($this, $class);
  return $this;
}

sub getLogLines{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'logLines'};
  }
}

sub getNickList{
  my ($this) = @_;
  my $string = "";
  if (ref($this)){
    foreach my $nickey (@{$this->{"nickList"}}){
       $string .="$nickey->{'name'} ";
    }
    return $string;
  }
}

sub getDate{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'date'};
  }
}

sub getTime{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'time'};
  }
}

sub getLogTime{
  my ($this) = @_;
  if (ref($this)){
    return $this->{'logTime'};
  }
}

sub log(){
  
  my ($this,$cmd) = @_;
  if ($cmd eq "JOIN" or
      $cmd eq "NICK" or 
      $cmd eq "PRIVMSG"){
  
   $this->{'logLines'} += 1;
  }
}

sub listNick(){
 
  my ($this,@nicks) = @_;
  my $newNick = "";

  foreach my $key (@nicks){
    
    while ($key){
      if ($key =~ m/(\w+)/){
        $newNick = $1;
        $key = $';
        $this->addNick($newNick);
      }
    }
  }
}

sub addNick{
  my ($this,$newNick) = @_;
  my $present = FALSE;
  for my $i (@{$this->{'nickList'}}){
    if ($i eq $newNick){
      $present = TRUE;
    }
  }
  my $newNickObject = User->new($newNick);
  push((@{$this->{'nickList'}}), $newNickObject) if ($present == FALSE);
}

sub printNickList{
 
  my ($this) = @_;  
  foreach my $nickey (@{$this->{"nickList"}}){
    print "$nickey->{'name'} \n";
  }  
}

sub getCurrentNick{
}

1;
