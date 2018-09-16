package PerlDevOps::Controller::Product;
use Mojo::Base 'Mojolicious::Controller';


# 产品线首页
sub index {
  my $self = shift;
  # Render template "product/index.html.ep" with message
  # $self->stash(listData => $self->product->all());
  $self->render(listData => $self->product->all());
}

#产品详情页
sub detail{


}

#添加产品线页面
sub addPage{
	my $self = shift;

	$self->render(product => {});
}

#添加产品线
sub add{
  my $self = shift;
  my $v = $self->_validation;
  return $self->render(action => '/product/addPage', product => {}) if $v->has_error;

  my $param = $v->output;
  #初始状态为“新创建”，之后取版本表的状态：版本名称+版本状态
  $param -> {productStatus} = "新创建";
  $param -> {createDate} = localtime();
  $param -> {createUser} = "admin";
  
  my $id = $self->product->add($param);
  $self->redirect_to('/product');
}


sub editPage {
  my $self = shift;
  $self->render(product => $self->product->find($self->param("id")));
}


sub edit {
 my $self = shift;
 my $v = $self->_validation;
 return $self->render(action => '/product/editPage', post => {}) if $v->has_error;
 my $id = $self->param('id');
 my $param = $v->output;

 $param -> {updateDate} = localtime();
 $param -> {updateUser} = "admin";

 $self->product->save($id, $param);
 $self->redirect_to('/product');
}


sub _validation {
  my $self = shift;

  my $v = $self->validation;
  $v->required('productName');
  $v->required('productWiki');
  $v->required('productManager');
  $v->required('productContact');
  $v->required('devManager');
  $v->required('devContact');
  $v->required('qaManager');
  $v->required('qaContact');
  $v->required('safeManager');
  $v->required('safeContact');
  $v->required('productDesc');
  return $v;
}

1;