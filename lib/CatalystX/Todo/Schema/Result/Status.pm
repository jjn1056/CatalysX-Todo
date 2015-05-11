use strict;
use warnings;

package CatalystX::Todo::Schema::Result::Status;

use base 'CatalystX::Todo::Schema::Result';

__PACKAGE__->table('status');
__PACKAGE__->add_columns(
  status_id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  name => {
    data_type => 'varchar',
  },
);

__PACKAGE__->set_primary_key('status_id');
__PACKAGE__->add_unique_constraint([ qw/name/ ]);
__PACKAGE__->has_many(
  todolist_rs => '::TodoList',
  { 'foreign.fk_status_id' => 'self.status_id' });

1;
