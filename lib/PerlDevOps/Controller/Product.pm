package PerlDevOps::Controller::Product;
use Mojo::Base 'Mojolicious::Controller';

# 产品线首页
sub index {
  my $self = shift;
  # Render template "product/index.html.ep" with message
  
  $self->stash(listData => [1,2,3,4,5,6]);
  $self->render();
}

#产品线详情页
sub detail{
	my $self = shift;
	my $productId = $self -> param("id");
  	# Render template "product/detail.html.ep" with message
  	$self->render(productName => "支付系统",productDesc => "xxx支付系统.....");
}



1;