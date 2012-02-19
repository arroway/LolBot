package App::LolBot::Stats;

use App::LolBot::User;
use App::LolBot::Database;
use DBI;
use strict; 
use warnings;
use POSIX qw(strftime);

use constant FALSE => 0;
use constant TRUE => 1;

sub new{
 
  my ($class) = @_;
  my ($this) = {
    'db'        => App::LolBot::Database->connect(),
    'logLines'  => 0,
    'nickList'  => [],
    'date'      => strftime("%Y-%m-%d", localtime()),
    'time'      => strftime("%H:%M:%S", localtime()),
    'logTime'   => 0
  };

  bless($this, $class);
  return $this;
}

sub loadData{
  my ($this) = @_;
  foreach my $nickey (@{$this->{"nickList"}}){
    $nickey->loadData();
  }  
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

sub logUser(){
  
  my ($this,$userNick) = @_;
  my @nickList = (@{$this->{'nickList'}}); 
  
  for (my $i=0; $i < @nickList; $i++){
     if ($userNick eq $nickList[$i]->{'name'}){
       $nickList[$i]->logUser();
       print "logUser: " . $userNick;
       $nickList[$i]->getLog();
     }
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
  my $newNickObject = App::LolBot::User->new($newNick);

  if ($present == FALSE){
    push((@{$this->{'nickList'}}), $newNickObject);
    App::LolBot::Database->insert($newNick);
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

sub printNickList{
 
  my ($this) = @_;  
  foreach my $nickey (@{$this->{"nickList"}}){
    print "$nickey->{'name'} \n";
  }  
}

sub InitNickList{
  
  my ($this, $foo, @nicklist) = @_;
  $this->listNick($nicklist[0]); 
  $this->printNickList();
}

sub newJoin{

  my ($this,$prefix) = @_;
  my $userNick = "";
  if ($prefix =~ m/:(.*)!/){
    $userNick = $1;
  }
  $this->addNick($userNick);
  $this->printNickList();
}

sub changeNick{

  my ($this,$userNick) = @_;
  if($userNick =~ m/:(.*)/){
    $userNick = $1;
  }
  $this->addNick($userNick);
  $this->printNickList();
}

sub recStats{
  
  my ($this,$userNick,$msg) = @_;
  my @nickList = (@{$this->{'nickList'}}); 
  
  for (my $i=0; $i< @nickList; $i++){  
    if ($userNick eq $nickList[$i]->{'name'}){
 
      $nickList[$i]->findLol($msg);
      $nickList[$i]->findExclamative($msg);
      $nickList[$i]->findInterrogative($msg);
      $nickList[$i]->findCapslock($msg);
     }
   }
}

sub getCurrentNick{
}

1;
