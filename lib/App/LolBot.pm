package App::LolBot;

use 5.012003;
use strict;
use warnings;

use App::LolBot::Bot;
use App::LolBot::Irc;
use App::LolBot::Stats;
use App::LolBot::User;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use App::LolBot ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

1;
__END__

=head1 NAME

LolBot

=head1 SYNOPSIS

  App::LolBot is a Perl extension to run an IRC bot and do some parsing stuff to get statistics about IRC users of the chan.

=head1 DESCRIPTION

The bot connects on a given IRC chan and collect information from the discussion. The data are stored in a sqlite database. 

Requirements: 
DBI

=head2 EXPORT

None by default.


=head1 SEE ALSO

The statistics can be displayed on a webpage - an example made with the Mojolicious framework is under development.

=head1 AUTHOR

Stephanie Ouillon E<lt>stephanie@minet.net<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Stephanie Ouillon

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
