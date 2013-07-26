package App::LolBot::Database;

use strict;
use warnings;
use Moose;
use MooseX::Singleton;
use DBI;
use DBI qw(:sql_types);
#use base qw(DBI);

# The Database module is a singleton
has db => (
  isa => 'Object',
  is => 'rw',
  default => sub {
    my $self = shift;
    my @args = ("dbi:SQLite:data.db", {RaiseError => 1, AutoCommit => 0});
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
                                   win            INTEGER,
                                   demoralized    INTEGER,
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

sub select_user {
  my $self = shift;
  my $name = shift;

  my $sth = $self->db->prepare("SELECT * FROM nicknames WHERE name = ?");

  eval {
    $sth->bind_param(1, $name, SQL_VARCHAR);
    $sth->execute();
    $sth->commit(); 
  };

  if ($@) {
    warn "Database error: $DBI::errstr\n" if $DBI::errstr;
    $self->db->rollback();
  }

  my ($rname,
      $capslock,
      $facepalm,
      $interrogative,
      $lol,
      $log,
      $osef,
      $sad,
      $happy,
      $amazed,
      $confused,
      $fpga,
      $win,
      $demoralized,
      $rage) = $sth->fetchrow();

  $sth->finish();

  return ($capslock,
      $facepalm,
      $interrogative,
      $lol,
      $log,
      $osef,
      $sad,
      $happy,
      $amazed,
      $confused,
      $fpga,
      $win,
      $demoralized,
      $rage);
}

sub create_user {
  my $self = shift;
  my $name = shift;
  

  my $res = $self->select_user($name);
  if ($res) {
    warn "User $res already exists: abort creation\n";
    return;
  }

  my $query = qq {INSERT INTO nicknames VALUES ( ? , NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL, NOT NULL)};

  my $sth = $self->db->prepare($query);

  eval {
    $sth->bind_param(1, $name, SQL_VARCHAR);
    $sth->execute();
    $sth->commit();
  };

  if ($@) {
    warn "Database error: $DBI::errstr\n" if $DBI::errstr;
    $self->db->rollback();
  }
 
  $sth->finish();
}

sub update_user {
  my $self = shift;
  my $user = shift;

  my $query = qq{ UPDATE nicknames SET capslock = ?, 
                                       facepalm = ?,
                                       interrogative = ?,
                                       lol = ?,
                                       log = ?,
                                       osef = ?,
                                       sad = ?,
                                       happy = ?,
                                       amazed = ?,
                                       confused = ?,
                                       fpga = ?,
                                       win = ?,
                                       demoralized = ?,
                                       rage = ? 
                   WHERE name = ?};
  my $sth = $self->db->prepare($query);

  eval {
    $sth->bind_param(1, $user->capslock, SQL_INTEGER);
    $sth->bind_param(2, $user->facepalm, SQL_INTEGER);
    $sth->bind_param(3, $user->interrogative, SQL_INTEGER);
    $sth->bind_param(4, $user->lol, SQL_INTEGER);
    $sth->bind_param(5, $user->log, SQL_INTEGER);
    $sth->bind_param(6, $user->osef, SQL_INTEGER);
    $sth->bind_param(7, $user->sad, SQL_INTEGER);
    $sth->bind_param(8, $user->happy, SQL_INTEGER);
    $sth->bind_param(9, $user->amazed, SQL_INTEGER);
    $sth->bind_param(10, $user->confused, SQL_INTEGER);
    $sth->bind_param(11, $user->fpga, SQL_INTEGER);
    $sth->bind_param(12, $user->win, SQL_INTEGER);
    $sth->bind_param(13, $user->demoralized, SQL_INTEGER);
    $sth->bind_param(14, $user->rage, SQL_INTEGER);
    $sth->bind_param(15, $user->name, SQL_VARCHAR);
    $sth->execute();
    $sth->commit();
  };

  if ($@) {
    warn "Database error: $DBI::errstr\n" if $DBI::errstr;
    $self->db->rollback();
  }
 
  $sth->finish();
}

sub select_lines {
  my $self = shift;
  
  my $query = qq{ SELECT lines FROM lolbot WHERE id = 1 };
  my $sth = $self->db->prepare($query);

  eval {
    $sth->execute();
    $sth->commit();
  };

  if ($@) {
    warn "Database error: $DBI::errstr\n" if $DBI::errstr;
    $self->db->rollback();
  }
 
  $sth->finish();

}

sub update_bot {
  my $self = shift;
  my $lines = shift;
  
  my $query = qq{ UPDATE lolbot SET lines = ? };
  my $sth = $self->db->prepare($query);

  eval {
    $sth->bind_param(1, $lines, SQL_INTEGER);
    $sth->execute();
    $sth->commit();
  };

  if ($@) {
    warn "Database error: $DBI::errstr\n" if $DBI::errstr;
    $self->db->rollback();
  }
 
  $sth->finish();
} 

1;
