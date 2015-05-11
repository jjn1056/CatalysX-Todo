package CatalystX::Todo::Controller::Root;

use Moose;
use MooseX::MethodAttributes;
use HTTP::Exception;

extends 'Catalyst::Controller';

sub root :Chained(/) PathPart('') CaptureArgs(0) {  }

  sub test_list :Chained(root) Args(0) {
    my ($self, $c) = @_;

    use Devel::Dwarn;
    Dwarn $c->model('Schema::TodoList')->first->get_columns; 
    $c->res->body('fff');
  } 

sub default :Default { $_[1]->go('/not_found') }

sub not_found :Action { HTTP::Exception->throw(404) }

__PACKAGE__->config(namespace=>'');
__PACKAGE__->meta->make_immutable;
