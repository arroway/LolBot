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

  sub addNick{
    my ($this,$newNick) = @_;
    my $present = FALSE;
    for my $nick (@{$this->{'nickList'}}){
      if ($nick->{'name'} eq $newNick){
        $present = TRUE;
    }
  }
  my $newNickObject = User->new($newNick);
  push((@{$this->{'nickList'}}), $newNickObject) if ($present == FALSE);
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

sub printNickList{
 
  my ($this) = @_;  
  foreach my $nickey (@{$this->{"nickList"}}){
    print "$nickey->{'name'} \n";
  }  
}

sub InitNickList{
  
  my ($foo, @nicklist) = @_;
  $stats->listNick($nicklist[0]); 
  $stats->printNickList();
}

sub newJoin{

  my ($prefix) = @_;
  my $userNick = "";
  if ($prefix =~ m/:(.*)!/){
    $userNick = $1;
  }
  $stats->addNick($userNick);
  $stats->printNickList();
}

sub changeNick{

  my ($userNick) = @_;
  if($userNick =~ m/:(.*)/){
    $userNick = $1;
  }
  $stats->addNick($userNick);
  $stats->printNickList();
}

sub recLol{
  
  my ($userNick,$msg) = @_;
  my @nickList = (@{$stats->{'nickList'}}); 
  for (my $i=0; $i< @nickList; $i++){
     if ($userNick eq $nickList[$i]->{'name'}){
       $nickList[$i]->findLol($msg);
       my $lolCount = $nickList[$i]->getLol();
       print "$userNick getLol: $lolCount \n";
     }
   }
}

sub getCurrentNick{
}

1;
