package PerlDevOps::Model::Kubernetes;
use Mojo::Base -base;

sub add {
  my ($self, $product) = @_;
  return $self->pg->db->insert('product', $product, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('product')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('product', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('product', {id => $id});
}

sub save {
  my ($self, $id, $product) = @_;
  $self->pg->db->update('product', $product, {id => $id});
}

1;