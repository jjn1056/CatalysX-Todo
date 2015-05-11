use File::Spec;
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
    'View::List' => { from_class => 'CatalystX::Todo::ListView', adaptor=>'PerRequest' },
    'Model::Schema' => { from_component => 'Catalyst::Model::DBIC::Schema' },
    'Model::Template' => {
      adaptor => 'PerRequest',
      from_code => sub {
        my ($adaptor_instance, $coderef, $c, %args) = @_;
        my $path = File::Spec->catfile($args{base_path}, $args{template});
        warn "$path";
        return $path;
      },
    },
    'Model::Form' => {
      from_component => 'Catalyst::Model::HTMLFormhandler',
      roles => ['HTML::Formhandler::Role::ToJSON'],
    },
  },
  'Model::Template' => {
    base_path => '__path_to(root)__',
    extension => 'html',
  },
  'Model::Schema' => {
    traits => ['Result'],
    schema_class => 'CatalystX::Todo::Schema',
    connect_info => [ sub { Schema()->storage->dbh } ],
  },
 'Plugin::MapComponentDependencies' => {
    map_dependencies => {
      'View::List' => {
        template => 'Model::Template',
        response=> sub { shift->response },
      },
      'Model::Template' => {
        template => sub {
          my ($c, $component_name, $config) = @_;
          return "${\$c->action}.$config->{extension}";
        },
      },
    },
  },
};

return $config;

