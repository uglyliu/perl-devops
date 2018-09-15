package PerlDevOps::Model::ProductVersion;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $productVersion) = @_;
  return $self->pg->db->insert('product_version', $productVersion, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('product_version')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('product_version', '*', {id => $id})->hash;
}

sub findAll {
  my ($self, $productId) = @_;
  return $self->pg->db->select('product_version', '*', {productId => $productId})->hashes->to_array;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('product_version', {id => $id});
}

sub save {
  my ($self, $id, $productVersion) = @_;
  $self->pg->db->update('product_version', $productVersion, {id => $id});
}

1;