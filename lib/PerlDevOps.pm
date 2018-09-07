package PerlDevOps;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  my $r = $self->routes;

  #首页
  $r->get('/')->to('home#index');

  #产品线
  $r->get('/product')->to('product#index');

  $r->get('/product/detail/:id')->to('product#detail');
}

1;
