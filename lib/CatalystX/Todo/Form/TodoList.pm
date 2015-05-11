package CatalystX::Todo::Form::TodoList;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler';

has_field 'description' => (
  type => 'Text',
  required => 1);

has_field 'status' => (
  type => 
  'Select',
  required => 1);

has_field 'submit' => (type => 'Submit');

has 'options_move' => (
  is=>'ro',
  isa=>'ArrayRef',
  traits => ['Array'],
  default => sub { [map { $_ => $_ } (qw/ready complete/)] },
  required=>1);


__PACKAGE__->meta->make_immutable;
