package PerlDevOps::Model::Assets;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $assets) = @_;
  return $self->pg->db->insert('assets', $assets, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('assets')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('assets', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('assets', {id => $id});
}

sub save {
  my ($self, $id, $assets) = @_;
  $self->pg->db->update('assets', $assets, {id => $id});
}

1;