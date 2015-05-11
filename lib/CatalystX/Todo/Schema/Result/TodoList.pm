use strict;
use warnings;

package CatalystX::Todo::Schema::Result::TodoList;

use base 'CatalystX::Todo::Schema::Result';

__PACKAGE__->load_components('Ordered');
__PACKAGE__->table('todo_list');
__PACKAGE__->add_columns(
  todolist_id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  fk_status_id => {
    data_type => 'integer',
    is_foreign_key => 1,
  },
  description => { data_type => 'varchar' },
  priority => {
    data_type => 'integer',
    is_auto_increment => 1,
  });

__PACKAGE__->position_column('priority');
__PACKAGE__->grouping_column('todolist_id');
__PACKAGE__->set_primary_key('todolist_id');
__PACKAGE__->belongs_to(
  status => '::Status',
  { 'foreign.status_id' => 'self.fk_status_id' },
  { proxy => [{current_status=>'name'}] });

1;
