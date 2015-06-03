package CatalystX::Todo::View::HTML;

use Moose;
use HTML::Zoom;
use signatures;

extends 'Catalyst::View';

with 'Catalyst::ComponentRole::PathFrom';
with 'Catalyst::Component::InstancePerContext';
 
sub build_per_context_instance($self, $c) {
  $c->res->content_type('text/html');
  return HTML::Zoom
    ->new({zconfig => { filter_builder => 'Lace::FilterBuilder' }})
    ->from_file($self->path_from($c));
}

