package Lace::FilterBuilder;

use Moo;

extends 'HTML::Zoom::FilterBuilder';
with 'Lace::Utils';

sub apply_resultset {
  my ($self, $resultset) = @_;
  return my $hz = $self->fill(
    [$resultset->result_source->columns],
    $resultset->all);
}

1;
