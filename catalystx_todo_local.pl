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
  'Model::Schema' => {
    connect_info => [ sub { Schema()->storage->dbh } ],
  },
};

return $config;
