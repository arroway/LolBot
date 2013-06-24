package App::LolBot;

use Any::Moose;

use App::LolBot::Bot;
use App::LolBot::Stats;
use App::LolBot::User;

our $VERSION = '0.01';

=head1 NAME

LolBot

=head1 SYNOPSIS

  App::LolBot is a Perl extension to run an IRC bot and do some parsing stuff to get statistics about IRC users of the chan.

=head1 DESCRIPTION

The bot connects on a given IRC chan and collect information from the discussion. The data are stored in a sqlite database. 

Requirements: 
DBI

The statistics can be displayed on a webpage - an example made with the Mojolicious framework is under development.

=head1 AUTHOR

Stephanie Ouillon

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Stephanie Ouillon

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut

1;
__END__
