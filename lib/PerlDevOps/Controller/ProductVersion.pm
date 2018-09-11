package PerlDevOps::Controller::ProductVersion;
use Mojo::Base 'Mojolicious::Controller';



#产品线版本列表
sub index{
	my $self = shift;
	my $productId = $self -> param("id");
	$self->render(product => $self->product->find($productId),productVersion => $self->productVersion->find($productId));
  	$self->render();
}


1;
