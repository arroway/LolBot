#! /usr/bin/env perl;

use strict;
use warnings;
use testStats;
use testUser;

my $testStats = testStats->new();
my $testUser = testUser->new();

$testStats->run();
$testUser->run();

print "\n\n***** RESULTS: *****\n\n";
print "$testStats->{'result'}";
print "$testUser->{'result'}";
