package PerlDevOps::Controller::ProductVersion;
use Mojo::Base 'Mojolicious::Controller';



#产品线版本列表
sub index{
	my $self = shift;
	my $productId = $self -> param("id");
	$self->render(product => $self->product->find($productId),
				  productVersion => $self->productVersion->findAll($productId)
	);
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
	 my $version = $self->productVersion->find($self->param("id"));
 	 $self->render(version => $version,product => $self->product->find($version->{productId}));
}

sub add{
	  my $self = shift;
	  my $v = $self->_validation;
	  say $v->output;
	  my $param = $v->output;
	  $self->redirect_to("/product/version/"+($param -> {productId})) if $v->has_error;
	  #版本状态（需求收集、需求评审、ui评审、立项、排期、开发、测试、安全测试、发布、验收）
	  #$param -> {versionStatus} = "0";
	  #版本所处环境（未开始、测试、uat、预热、生产）
	  $param -> {versionEnv} = "0";
	  $param -> {createDate} = localtime();
	  $param -> {createUser} = "admin";
	  
	  my $id = $self->productVersion->add($param);
	  $self->redirect_to("/product/version/"+($param -> {productId}));

}

sub edit{
	 my $self = shift;
	 my $v = $self->_validation;
	 my $param = $v->output;
	 $self->redirect_to("/product/version/"+($param -> {productId})) if $v->has_error;
	 my $id = $self->param('id');
	
	 $param -> {updateDate} = localtime();
	 $param -> {updateUser} = "admin";

	 $self->productVersion->save($id, $param);
	 $self->redirect_to("/product/version/"+($param -> {productId}));

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
