package App::LolBot::Database;
use Moose;
use MooseX::Singleton;
use DBI;                                                                      
use base qw(DBI);

# The Database module is a singleton
has db => (
  isa => 'Object',
  is => 'rw',
  default => sub {
    my $self = shift;
    my @args = ("dbi:SQLite::data.db", {AutoCommit => 1, RaiseError => 0});
    my $db = DBI->connect(@args);
    $db->do("CREATE TABLE nicknames (name     VARCHAR(50) PRIMARY KEY,
                                   capslock       INTEGER,
                                   facepalm       INTEGER,
                                   interrogative  INTEGER,
                                   lol            INTEGER,
                                   log            INTEGER,
		                   osef           INTEGER,
                                   sad            INTEGER,
                                   happy          INTEGER,
                                   amazed         INTEGER,
                                   confused       INTEGER,
                                   fpga           INTEGER,
                                   rage           INTEGER  
                                   )");
    $db->do("CREATE TABLE lolbot (id          INTEGER PRIMARY KEY,
                                  lines       INTEGER,
				  random      VARCHAR(255)
                                  )");
    $db->do("INSERT INTO lolbot VALUES (1, 0, \"\")");
    return $db;
  }
);

sub do {
  my $self = shift;
  my ($query) = @_;
  $self->db->do($query);
  
}

sub commit {
  my $self = shift;
  $self->db->commit();
}

sub insert {
  my $self = shift;
  my ($name) = @_;
  my $query = "INSERT INTO nicknames VALUES (\"$name\", NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL)";
  $self->db->do($query);
}

sub update {
  my $self = shift;
  my ($userNick, $attribute, $value) = @_;
  my $query = "UPDATE nicknames SET \"$attribute\"  = \"$value\"  WHERE name = \"$userNick\"";
  $self->db->do($query);
}

sub bot_update {
  my $self = shift;
  my ($attribute, $value) = @_;
  my $query = "UPDATE lolbot SET \"$attribute\"  = \"$value\"  WHERE id = 1";
  $self->db->do($query);
} 

sub disconnect {

  my $self = shift;
  $self->db->disconnect();
}

1;
