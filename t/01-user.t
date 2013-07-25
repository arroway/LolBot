#! /usr/bin/env/ perl -Tw

use strict;
use warnings;

use Test::More tests => 60;
use App::LolBot::User;

BEGIN { use_ok('App::LolBot::User') };

my $u = App::LolBot::User->new(
	name => 'toto'
);

ok(defined $u, 						'New user object is defined');
ok($u->isa('App::LolBot::User'), 			'and is the right class');
is($u->capslock, 0,					'Capslock attribute initial value at 0');

my $msg = "This is a basic test message.";
$u->find_capslock($msg);
is($u->capslock, 0, 					"capslock not found: $msg");

$msg = "THIS IS A BASIC TEST MESSAGE.";
$u->find_capslock($msg);
is($u->capslock, 1, 					"capslock found: $msg");

$msg = "THIS IS A basic message.";
$u->find_capslock($msg);
is($u->capslock, 1, 					"capslock not found: $msg");

$msg = "THIS IS A bASIC TEST MESSAGE.";
$u->find_capslock($msg);
is($u->capslock, 1, 					"capslock not found: $msg");

$msg = "123456";
$u->find_capslock($msg);
is($u->capslock, 1, 					"capslock not found: $msg");

$msg = "!!!!??.";
$u->find_capslock($msg);
is($u->capslock, 1, 					"capslock not found: $msg");

$msg = "This is a basic test message";
$u->find_facepalm($msg);
is($u->facepalm, 0, 					"facepalm not found: $msg");

$msg = "*me facepalm";
$u->find_facepalm($msg);
is($u->facepalm, 1, 					"facepalm found: $msg");

$msg = "toto face palm";
$u->find_facepalm($msg);
is($u->facepalm, 2, 					"facepalm found: $msg");

$msg = "This is a basic message.";
$u->find_interrogative($msg);
is($u->interrogative, 0, 				"interrogative not found: $msg");

$msg = "Is this a basic message?";
$u->find_interrogative($msg);
is($u->interrogative, 1, 				"interrogative found: $msg");

$msg = "Is this a basic message??";
$u->find_interrogative($msg);
is($u->interrogative, 3, 				"interrogative found: $msg");

$msg = "?";
$u->find_interrogative($msg);
is($u->interrogative, 4, 				"interrogative found: $msg");

$msg = "This is a basic message";
$u->find_lol($msg);
is($u->lol, 0, 						"lol not found: $msg");

$msg = "This is lol";
$u->find_lol($msg);
is($u->lol, 1, 						"lol found: $msg");

$msg = "This is lol lol";
$u->find_lol($msg);
is($u->lol, 3, 						"lol found: $msg");

$msg = "This is lolol";
$u->find_lol($msg);
is($u->lol, 4, 						"lol found: $msg");

$msg = "This is loooool";
$u->find_lol($msg);
is($u->lol, 5, 						"lol found: $msg");

$msg = "This is loul";
$u->find_lol($msg);
is($u->lol, 6, 						"lol found: $msg");

$msg = "This is lulz";
$u->find_lol($msg);
is($u->lol, 7, 						"lol found: $msg");

$msg = "This is LOL";
$u->find_lol($msg);
is($u->lol, 8, 						"lol found: $msg");

is($u->log, 0, 						"log user initialized at 0");
$u->log_user();
is($u->log, 1, 						"log user once");

$msg = "This is a message";
$u->find_osef($msg);
is($u->osef, 0, 					"osef not found: $msg");

$msg = "mais osef";
$u->find_osef($msg);
is($u->osef, 1, 					"osef found: $msg");

$msg = "mais OSEF";
$u->find_osef($msg);
is($u->osef, 2, 					"osef found: $msg");

$msg = "mais osef OSEF";
$u->find_osef($msg);
is($u->osef, 4, 					"osef found: $msg");

$msg = "This is a message.";
$u->find_sad($msg);
is($u->sad, 0, 						"sad not found: $msg");

$msg = "This is a sad message :(";
$u->find_sad($msg);
is($u->sad, 1, 						"sad found: $msg");

$msg = "This is a sad message :( :'( :/";
$u->find_sad($msg);
is($u->sad, 4, 						"sad found: $msg");

$msg = "This is a sad message :((";
$u->find_sad($msg);
is($u->sad, 5, 						"sad found: $msg");

$msg = "This is a message.";
$u->find_happy($msg);
is($u->happy, 0, 					"happy not found: $msg");

$msg = "This is a happy message :)";
$u->find_happy($msg);
is($u->happy, 1, 					"happy found: $msg");

$msg = "This is a happy message :) :D :') :'D";
$u->find_happy($msg);
is($u->happy, 5, 					"happy found: $msg");

$msg = "This is a happy message ^_^";
$u->find_happy($msg);
is($u->happy, 6, 					"happy found: $msg");

$msg = "This is a happy message ^^";
$u->find_happy($msg);
is($u->happy, 7, 					"happy found: $msg");

$msg = "This is a message.";
$u->find_amazed($msg);
is($u->amazed, 0, 					"amazed not found: $msg");

$msg = "This is a message :o";
$u->find_amazed($msg);
is($u->amazed, 1, 					"amazed found: $msg");

$msg = "This is a message :oooo";
$u->find_amazed($msg);
is($u->amazed, 2, 					"amazed found: $msg");

$msg = "This is a message :o :O";
$u->find_amazed($msg);
is($u->amazed, 4, 					"amazed found: $msg");

$msg = "This is a message: oh";
$u->find_amazed($msg);
is($u->amazed, 4, 					"amazed not found: $msg");

$msg = "This is a message.";
$u->find_confused($msg);
is($u->confused, 0, 					"confused not found: $msg");

$msg = "This is a message :x";
$u->find_confused($msg);
is($u->confused, 1, 					"confused found: $msg");

$msg = "This is a message :xxx";
$u->find_confused($msg);
is($u->confused, 2, 					"confused found: $msg");

$msg = "This is a message :x :X";
$u->find_confused($msg);
is($u->confused, 4, 					"confused found: $msg");

$msg = "This is a message.";
$u->find_fpga($msg);
is($u->fpga, 0, 					"fpga not found: $msg");

$msg = "This is a fpga message.";
$u->find_fpga($msg);
is($u->fpga, 1, 					"fpga found: $msg");

$msg = "This is a fpga arduilol message.";
$u->find_fpga($msg);
is($u->fpga, 3, 					"fpga found: $msg");

$msg = "This is a message.";
$u->find_win($msg);
is($u->win, 0, 						"win not found: $msg");

$msg = "This is a \\o/ message.";
$u->find_win($msg);
is($u->win, 1, 						"win found: $msg");

$msg = "This is a \\o/\\o/ message.";
$u->find_win($msg);
is($u->win, 3, 						"win found: $msg");

$msg = "This is a message.";
$u->find_demoralized($msg);
is($u->demoralized, 0, 					"demoralized not found: $msg");

$msg = "This is a -_- message.";
$u->find_demoralized($msg);
is($u->demoralized, 1, 					"demoralized found: $msg");

$msg = "This is a -_- message -_-.";
$u->find_demoralized($msg);
is($u->demoralized, 3, 					"demoralized found: $msg");

is($u->rage, 0, 					"Rage initialized at 0");
$u->add_rage();
is($u->rage, 1, 					"Add rage once");


