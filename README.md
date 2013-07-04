# App::LolBot 

This is a custom IRC bot. 

## Main features

* The bot counts every lol/loul/lulz, "facepalm" or question mark written by a user.
* Integrated rage-o-meter: each a user makes a complaint, the LolBot can be manually notified and keeps track of the score.
* The bot detects capslock. 


## Commands

`!log`: number of lines written on the channel since the bot connected, and number of lines per user
`!lol`: number of lol/loul/etc score per user 
`!rage [user]`: command performed by any user of the chan to notify the bot that 'user' complained
`!rage`: displays the results of the previous commands
`!facepalm`: number of facepalm or 'face palm' per user
`!capslock`: number of lines written in capital letters per user
`!questions`: number of questions (question marks) per user
`!help` or `!rtfm`: quick online help for commands


## Installation

CPAN dependencies:
* Any::Moose

To install this module:

~~~ sh
   perl Makefile.PL
   make
   make test (does nothing because of deprecated tests, baaad)
   make install
~~~ 


## Documentation

perldoc to come...


## Roadmap

The next version 0.02 of the LolBot will include persistance of the counters values in order to display the result on a web interface.


## Copyright

Copyright (C) 2013 by Stéphanie Ouillon

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


