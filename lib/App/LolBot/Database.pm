package App::LolBot::Database;
use strict;                                                                   
use warnings;                                                                 
use DBI;                                                                      
use base qw(DBI);


# The Database module is a singleton
my $DB = undef;

sub connect{
  
  my $class = shift;
  return $DB if defined $DB;
  $DB = DBI->connect(@_);
  $DB->do("CREATE TABLE nicknames (name           VARCHAR(50) PRIMARY KEY,
                                   capslock       INTEGER,
                                   exclamative     INTEGER,
                                   interrogative  INTEGER,
                                   lol            INTEGER     
                                   )");
}

sub do {
  
  my ($class, $query) = @_;
  $DB->do($query);
  
}

sub commit {
  
  my ($class) = @_;
  $DB->commit();
}

sub disconnect {

  my ($class) = @_;
  $DB->disconnect();
}

1;
