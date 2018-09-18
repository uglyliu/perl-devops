package PerlDevOps;
use Mojo::Base 'Mojolicious';
use PerlDevOps::Model::Product;
use PerlDevOps::Model::ProductVersion;
use PerlDevOps::Model::Assets;
use PerlDevOps::Model::Server;
use PerlDevOps::Model::Kubernetes;
use PerlDevOps::Model::KubeConfig;
use Mojo::Pg;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');
  
  $self->secrets($self->config('secrets'));
	
  # Model
  $self->helper(pg => sub { state $pg = Mojo::Pg->new(shift->config('pg')) });
  $self->helper(
    product => sub { state $product = PerlDevOps::Model::Product->new(pg => shift->pg) }
  );
  $self->helper(
    productVersion => sub { state $productVersion = PerlDevOps::Model::ProductVersion->new(pg => shift->pg) }
  );
  $self->helper(
    assets => sub { state $assets = PerlDevOps::Model::Assets->new(pg => shift->pg) }
  );
  $self->helper(
    server => sub { state $server = PerlDevOps::Model::Server->new(pg => shift->pg) }
  );
  $self->helper(
    kubernetes => sub { state $kubernetes = PerlDevOps::Model::Kubernetes->new(pg => shift->pg) }
  );
  $self->helper(
    kubeConfig => sub {state $kubeConfig = PerlDevOps::Model::KubeConfig->new(pg => shift->pg)}
  );

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  my $r = $self->routes;

  #首页
  $r->get('/')->to('home#index');

  #产品线
  $r->get('/product')->to('product#index');
  $r->get('/product/addPage')->to('product#addPage');
  $r->get('/product/editPage/:id')->to('product#editPage');
  $r->post('/product/add')->to('product#add');
  $r->post('/product/edit')->to('product#edit');

  #产品版本管理
  $r->get('/product/version/:id')->to('product_version#index');
  $r->get('/product/version/addPage/:id')->to('product_version#addPage');
  $r->get('/product/version/editPage/:id')->to('product_version#editPage');
  $r->post('/product/version/add')->to('product_version#add');
  $r->post('/product/version/edit')->to('product_version#edit');

  #资产管理
  $r->get('/assets')->to('assets#index');
  $r->get('/assets/addPage')->to('assets#addPage');
  $r->get('/assets/editPage/:id')->to('assets#editPage');
  $r->post('/assets/add')->to('assets#add');
  $r->post('/assets/edit')->to('assets#edit');

  #服务器管理
  $r->get('/assets/server/editPage/:id')->to('server#editPage');
  $r->post('/assets/server/edit')->to('server#edit');


  #k8s
  $r->get('/k8s')->to('kubernetes#index');
  $r->get('/k8s/configPage')->to('kubernetes#configPage');
  $r->post('/k8s/config')->to('kubernetes#config');
  $r->get('/k8s/install')->to('kubernetes#install');
  $r->get('/k8s/status')->to('kubernetes#status');

}

1;
