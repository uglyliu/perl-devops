package PerlDevOps::Controller::ProductVersion;
use Mojo::Base 'Mojolicious::Controller';



#产品线版本列表
sub index{
	my $self = shift;
	my $productId = $self -> param("id");
	$self->render(product => $self->product->find($productId),productVersion => $self->productVersion->find($productId));
}

#详情页
sub detail{


}

#添加页面
sub addPage{
	my $self = shift;
	my $productId = $self -> param("id");

	$self->render(product => $self->product->find($productId),version => {});
}

sub editPage{
	 my $self = shift;
 	 $self->render(version => $self->productVersion->find($self->param("id")));
}

sub add{
	  my $self = shift;
	  my $v = $self->_validation;
	  say $v->output;
	  my $param = $v->output;
	  my $productId = $param -> {productId}
	  $self->redirect_to('/product/version/'+$productId) if $v->has_error;

	  $param -> {versionStatus} = "需求收集";
	  $param -> {versionEnv} = "未开始";
	  $param -> {createDate} = localtime();
	  $param -> {createUser} = "admin";
	  
	  my $id = $self->productVersion->add($param);
	  $self->redirect_to('/product/version/'+$productId);

}

sub edit{


}

sub _validation {
  	my $self = shift;

	my $v = $self->validation;
	$v->required('versionName');
	$v->required('versionStatus');

	$v->required('startTime');
	$v->required('endTime');
	$v->required('versionWiki');
	$v->required('productId');

	$v->required('productManager');
	$v->required('productContact');
	$v->required('devManager');
	$v->required('devContact');
	$v->required('qaManager');
	$v->required('qaContact');
	$v->required('safeManager');
	$v->required('safeContact');

	return $v;
}

1;
