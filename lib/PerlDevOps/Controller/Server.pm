package PerlDevOps::Controller::Server;
use Mojo::Base 'Mojolicious::Controller';


#服务器编辑页
sub editPage{
	my $self = shift;
	my $assetsId = $self->param("id");
	my $server = $self->server->find($assetsId);
	$server -> {id} = $assetsId;
 	$self->render(server => $server);
}

sub edit{
	 my $self = shift;
	 my $v = $self->_validation;
	 my $param = $v->output;
	 $self->redirect_to("/assets") if $v->has_error;

	 my $assetsId = $self->param('id');
	
	 $param -> {updateDate} = localtime();
	 $param -> {updateUser} = "admin";

	 $self->server->save($assetsId, $param);
	 $self->redirect_to("/assets");

}

sub _validation {
  	my $self = shift;

	my $v = $self->validation;
	$v->required('id');
	$v->required('manageIp');
	$v->required('intranetIp');

	$v->required('user');
	$v->required('ip');
	$v->required('port');
	$v->required('desc');
	return $v;
}

1;
