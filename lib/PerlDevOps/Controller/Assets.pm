package PerlDevOps::Controller::Assets;
use Mojo::Base 'Mojolicious::Controller';



#资产列表
sub index{
	my $self = shift;
	$self->render(listData => $self->assets->all());
}

#详情页
sub detail{


}

#添加页面
sub addPage{
	my $self = shift;

	$self->render(assets => {});
}

sub editPage{
	 my $self = shift;
	 my $assets = $self->assets->find($self->param("id"));
 	 $self->render(assets => $assets);
}

sub add{
	  my $self = shift;
	  my $v = $self->_validation;
	  say $v->output;
	  my $param = $v->output;
	  $self->redirect_to("/assets") if $v->has_error;

	  $param -> {idc} = $self->param("idc");
	  $param -> {cabinetNo} =  $self->param("cabinetNo");
	  $param -> {cabinetOrder} =  $self->param("cabinetOrder");
	  $param -> {tags} =  $self->param("tags");

	  my $date = localtime();
	  $param -> {createDate} = $date;
	  $param -> {createUser} = "admin";


	  my $id = $self->assets->add($param);
	  #保存服务器数据,这里需要事务保存	
	  $self->server->add({id => $id,createDate => $date,createUser => "admin"});

	  $self->redirect_to("/assets");

}

sub edit{
	 my $self = shift;
	 my $v = $self->_validation;
	 my $param = $v->output;
	 $self->redirect_to("/assets") if $v->has_error;
	 my $id = $self->param('id');
		
	 $param -> {idc} = $self->param("idc");
	 $param -> {cabinetNo} =  $self->param("cabinetNo");
	 $param -> {cabinetOrder} =  $self->param("cabinetOrder");
	 $param -> {tags} =  $self->param("tags");


	 $param -> {updateDate} = localtime();
	 $param -> {updateUser} = "admin";

	 $self->assets->save($id, $param);
	 $self->redirect_to("/assets");

}

sub _validation {
  	my $self = shift;

	my $v = $self->validation;
	$v->required('assetType');
	$v->required('status');

	return $v;
}

1;
