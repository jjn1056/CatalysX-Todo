package CatalystX::Todo::Controller::Root;

use Moose;
use MooseX::MethodAttributes;
use HTTP::Exception;

extends 'Catalyst::Controller';

sub root :Chained(/) PathPart('') CaptureArgs(0) {  }

  sub list :Chained(root) PathPart('') Args(0) {
    my ($self, $c) = @_;
    $c->view('List')->apply_list($c->model('Schema::TodoList'));
    $c->view('List')->send_response;
  } 

sub default :Default { $_[1]->go('/not_found') }

sub not_found :Action { HTTP::Exception->throw(404) }

__PACKAGE__->config(namespace=>'');
__PACKAGE__->meta->make_immutable;
