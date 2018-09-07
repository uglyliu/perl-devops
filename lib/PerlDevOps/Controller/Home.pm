package PerlDevOps::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
  my $self = shift;

  # Render template "home/index.html.ep" with message
  $self->render();
}

1;