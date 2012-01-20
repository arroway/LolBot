#! /usr/bin/env perl;
use strict;
use warnings;
use Stats;

my $stats = Stats->new();

sub recInitNickList{
  
  my ($args) = @_; 
  my @nicklist = ($args =~ m/\:(.*)$/);
  print @nicklist;
  print "\n";
  $stats->listNick(@nicklist);     
  $stats->printNickList();
}


my ($prefix, $cmd, @args) = (":irc.int.rezosup.org", "353", "LolBot = #pourlesbots :LolBot \@arroway");
recInitNickList(@args);
