use strict;
use warnings;

package CatalystX::Todo::Schema::Result;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/
  Helper::Row::RelationshipDWIM
  Helper::Row::SelfResultSet
  TimeStamp
  InflateColumn::DateTime/);

sub default_result_namespace { 'CatalystX::Todo::Schema::Result' }

sub add_columns {
  my @ret = (my $class = shift)
    ->next::method(@_);

  # Since we want this on every table...
  $class->add_column(
    created => {
      data_type => 'datetime',
      retrieve_on_insert => 1,
      default_value => \'current_timestamp',
  }) unless $class->has_column('created');

  return @ret;
}

sub TO_JSON { +{shift->get_columns} }

1;
