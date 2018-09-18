package PerlDevOps::Controller::Kubernetes;
use Mojo::Base 'Mojolicious::Controller';


sub index{
	my $self = shift;

	$self->render();
	 
}

sub install{


}

sub configPage{
	my $self = shift;
	#kubeConfig => $self->kubeConfig->find()
  	$self->render(kubeConfig => {});
}

sub config{



}

sub status{


}

1;
