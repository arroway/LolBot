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
  my @args = ("dbi:SQLite::data.db", {AutoCommit => 1, RaiseError => 0});
  $DB = DBI->connect(@args);
  $DB->do("CREATE TABLE nicknames (name           VARCHAR(50) PRIMARY KEY,
                                   capslock       INTEGER,
                                   exclamative     INTEGER,
                                   interrogative  INTEGER,
                                   lol            INTEGER,
                                   log            INTEGER  
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

sub insert {

  my ($class, $name) = @_;
  my $query = "INSERT INTO nicknames VALUES (\"$name\", NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL)";
  $DB->do($query);
}

sub update {

  my ($class, $userNick, $attribute, $value) = @_;
  my $query = "UPDATE nicknames SET \"$attribute\"  = \"$value\"  WHERE name = \"$userNick\"";
  $DB->do($query);
}

sub disconnect {

  my ($class) = @_;
  $DB->disconnect();
}

1;
