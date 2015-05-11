use Test::DBIx::Class
  -schema_class => 'CatalystX::Todo::Schema',
    qw/TodoList Status Schema/;

Status->populate([
  ['name'],
  ['ready'],
  ['completed'], ]);

TodoList->populate([
  { description => 'get milk', status => { name => 'ready' }},
]);
  
my $config = {
  'default_view' => 'HTML',
  'inject_components' => {
    'Model::Schema' => { from_component => 'Catalyst::Model::DBIC::Schema' },
    'Model::Form' => {
      from_component => 'Catalyst::Model::HTMLFormhandler',
      roles => ['HTML::Formhandler::Role::ToJSON'],
    },
  },
  'Model::Schema' => {
    traits => ['Result'],
    schema_class => 'CatalystX::Todo::Schema',
    connect_info => [ sub { Schema()->storage->dbh } ],
  },
};

return $config;

