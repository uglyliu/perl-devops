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
	
	$self->product->find($productId);
	#$self->render(product => $self->product->find($self->param('id'));
  	$self->render(productName => "支付系统",productDesc => "xxx支付系统.....");
}





#sub addProduct {
#  my $self = shift;
#
#  my $v = $self->_validation;
#  return $self->render(action => 'create', post => {}) if $v->has_error;
#
#  my $id = $self->posts->add($v->output);
#  $self->redirect_to('show_post', id => $id);
#}
#
#sub updateProduct {
#  my $self = shift;
#  my $v = $self->_validation;
#  return $self->render(action => 'edit', post => {}) if $v->has_error;
#  my $id = $self->param('id');
#  $self->posts->save($id, $v->output);
#  $self->redirect_to('show_post', id => $id);
#}


sub _validation {
  my $self = shift;

  my $v = $self->validation;
  $v->required('productName');
  $v->required('productManager');

  return $v;
}

1;