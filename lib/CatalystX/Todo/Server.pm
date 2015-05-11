use warnings;
use strict;

package CatalystX::Todo::Server;

use CatalystX::Todo;
use Plack::Runner;

sub run { Plack::Runner->run(@_, CatalystX::Todo->to_app) }

return caller(1) ? 1 : run(@ARGV);

=head1 TITLE

CatalystX::Todo::Server - Start the application under a web server

=head1 DESCRIPTION

Start the web application.  Example:

    perl -Ilib  lib/CatalystX/Todo/Server.pm --server Gazelle

=head1 AUTHORS & COPYRIGHT

See L<JJNAPIORK::TicTacToe>.

=head1 LICENSE

See L<JJNAPIORK::TicTacToe>.

=cut
