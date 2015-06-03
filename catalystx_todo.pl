use File::Spec;
use Catalyst::Plugin::MapComponentDependencies::Utils ':ALL';

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
  },
  'View::HTML' => {
    extension => 'html',
  }
};

return $config;
