package App::LolBot::Stats;

use Any::Moose;
use App::LolBot::User;
use App::LolBot::Database;
use DBI;
use POSIX qw(strftime);

use constant FALSE => 0;
use constant TRUE => 1;

has db => (
  isa => 'App::LolBot::Database',
  is => 'rw',
);

has logLines => (
  isa => 'Int',
  is => 'rw',
);

has nickList => (
  isa => 'ArrayRef',
  is => 'rw',
  default => sub {
    my $self = shift;
    return [];
  }
);

has date => (
  isa => 'Str',
  is => 'rw',
);

has time => (
  isa => 'Str',
  is => 'rw',
);

#has logTime => (
#);
 
sub loadData{
  my $self = shift;
  foreach my $nickey (@{$self->nickList}){
    $nickey->loadData();
  }  
}

sub getLogLines{
  my $self = shift;
  if (ref($self)){
    return $self->logLines;
  }
}

sub getNickList{
  my $self = shift;
  my $string = "";
  if (ref($self)){
    foreach my $nickey (@{$self->nickList}){
       $string .="$nickey->name ";
    }
    return $string;
  }
}

sub getDate{
  my $self = shift;
  if (ref($self)){
    return $self->date;
  }
}

sub getTime{
  my $self = shift;
  if (ref($self)){
    return $self->time;
  }
}

#sub getLogTime{
#  my $self = shift;
#  if (ref($self)){
#    return $self->{'logTime'};
#  }
#}

sub log(){
  my $self = shift;
  my $cmd = @_;
  if ($cmd eq "JOIN" or
      $cmd eq "NICK" or 
      $cmd eq "PRIVMSG"){
    
    $self->logLines += 1;
  }
}

sub logUser(){
  my $self = shift;
  my $userNick = @_;
  
  my @nickList = (@{$self->nickList}); 
  
  for (my $i=0; $i < @nickList; $i++){
     if ($userNick eq $nickList[$i]->name){
       $nickList[$i]->logUser();
       print "logUser: " . $userNick;
       $nickList[$i]->getLog();
     }
   }
}

sub addNick{
  my $self = shift;
  my ($newNick) = @_;
  my $present = FALSE;
  for my $nick (@{$self->nickList}){
    if ($nick->name eq $newNick){
      $present = TRUE;     
    }
  }

  if ($present == FALSE){
    my $newNickObject = 
      App::LolBot::User->new( 
        db => $self->db,
        name => $newNick,
    );

    push((@{$self->nickList}), $newNickObject);
    App::LolBot::Database->insert($newNick);
  }
}

sub listNick(){
  my $self = shift;
  my (@nicks) = @_;
  my $newNick = "";

  foreach my $key (@nicks){
    
    while ($key){
      if ($key =~ m/(\w+)/){
        $newNick = $1;
        $key = $';
        $self->addNick($newNick);
      }
    }
  }
}

sub printNickList{
 
  my $self = shift;
  foreach my $nickey (@{$self->nickList}){
    print $nickey->name . "\n";
  }  
}

sub InitNickList{
  
  my $self = shift;
  my ($foo, @nicklist) = @_;
  $self->listNick($nicklist[0]); 
  $self->printNickList();
}

sub newJoin{
  my $self = shift;
  my ($prefix) = @_;
  my $userNick = "";
  if ($prefix =~ m/:(.*)!/){
    $userNick = $1;
  }
  $self->addNick($userNick);
  $self->printNickList();
}

sub changeNick{
  my $self = shift;
  my ($userNick) = @_;
  if($userNick =~ m/:(.*)/){
    $userNick = $1;
  }
  $self->addNick($userNick);
  $self->printNickList();
}

sub recStats{
  my $self = shift;
  my ($userNick,$msg) = @_;
  my @nickList = (@{$self->nickList}); 
  
  for (my $i=0; $i< @nickList; $i++){  
    if ($userNick eq $nickList[$i]->name){
 
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
