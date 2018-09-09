package PerlDevOps;
use Mojo::Base 'Mojolicious';
use PerlDevOps::Model::Product;
use PerlDevOps::Model::ProductVersion;
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



  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  my $r = $self->routes;

  #首页
  $r->get('/')->to('home#index');

  #产品线
  $r->get('/product')->to('product#index');
  $r->get('/product/addPage')->to('product#addPage');
  $r->post('/product/add')->to('product#add');
  $r->get('/product/editPage/:id')->to('product#editPage');
  $r->post('/product/edit')->to('product#edit');


  $r->get('/product/version/:id')->to('product_version#index');
}

1;
