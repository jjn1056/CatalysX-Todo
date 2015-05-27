use File::Spec;
use Catalyst::Plugin::MapComponentDependencies::Utils ':ALL';
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
    'Model::Path' => {
      adaptor => 'PerRequest',
      from_code => sub {
        my ($adaptor_instance, $coderef, $c, %args) = @_;
        return File::Spec->catfile($args{base_path}, $args{template_part});
      },
    },
    'Model::Form' => {
      from_component => 'Catalyst::Model::HTMLFormhandler',
      roles => ['HTML::Formhandler::Role::ToJSON'],
    },
  },
  'Model::Path' => {
    base_path => '__path_to(root)__',
    extension => 'html',
    template_part => FromCode {
      my ($c, $component_name, $config) = @_;
      return "${\$c->action}.$config->{extension}";
    },
  },
  'Model::Schema' => {
    traits => ['Result'],
    schema_class => 'CatalystX::Todo::Schema',
    connect_info => [ sub { Schema()->storage->dbh } ],
  },
  'View::List' => {
    template => FromModel 'Path',
    response => FromCode { shift->response },
  },
};

return $config;
