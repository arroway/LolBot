package MyTests;
use strict;
use warnings;

#TODO: log the messages in a file

sub new{

  my ($class,$name,$total) = @_;
  my ($this) = {
    'name'   => $name,
    'countT' => 0,
    'totalT' => $total,
    'result' => ""
  };

  bless($this, $class);
  return $this;
}

sub test{
  
  my ($this,$label, $value, $expected) = @_;
  
  if ($value eq $expected){
    $this->{'countT'} += 1;
    print "[OK]\t$label is $value.\n";
  }
  else{
    print "[!! FAIL !!]\t$label is $value instead of $expected.\n";
  }
}

sub myTestsDone{

  my ($this) = @_;
  my $diff = $this->{'totalT'} - $this->{'countT'};

  if ($diff == 0){
    $this->{'result'} = "All tests passed for $this->{'name'}.\n";
    return $this->{'result'};
  }
  else{
    $this->{'result'} = "$diff tests failed for $this->{'name'}.\n";
    return $this->{'result'};
  }
}

1;
