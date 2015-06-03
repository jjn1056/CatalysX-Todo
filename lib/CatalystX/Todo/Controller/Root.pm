package CatalystX::Todo::Controller::Root;

use Moose;
use MooseX::MethodAttributes;
use Catalyst::ActionSignatures;
use HTTP::Exception;

extends 'Catalyst::Controller';

sub root() :Chained(/) PathPart('')  {  }

  sub list($res, View::HTML $html, Model::Schema::TodoList $todo)
   :Chained(root/) PathPart('') {
    $res->body(
      $html->select('.data-row')
        ->apply_resultset($todo)
        ->to_fh);
  } 

sub default :Default { HTTP::Exception->throw(404) }

__PACKAGE__->config(namespace=>'');
__PACKAGE__->meta->make_immutable;
