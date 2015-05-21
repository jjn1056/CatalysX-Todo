package CatalystX::Todo;

use Catalyst qw/
  ConfigLoader
  DataHash
  ConfigLoader
  CurrentComponents
  RedirectTo
  ResponseFrom
  InjectionHelpers
  MapComponentDependencies/;


__PACKAGE__->request_class_traits(['ContentNegotiationHelpers']);
__PACKAGE__->setup;

=head1 NAME

CatalystX::Todo - Example Catalyst Application

=head1 SYNOPSIS

To start the server

    perl -Ilib lib/Catalyst/Todo/Server.pm

=head1 DESCRIPTION

    TBD

=head1 METHODS

This class defines the following methods

=head2 version

Current application version

=head1 AUTHOR
 
John Napiorkowski L<email:jjnapiork@cpan.org>
  
=head1 SEE ALSO
 
L<Catalyst>

=head1 COPYRIGHT & LICENSE
 
Copyright 2015, John Napiorkowski L<email:jjnapiork@cpan.org>
 
This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
