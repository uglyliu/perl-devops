package PerlDevOps::Model::Server;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $server) = @_;
  return $self->pg->db->insert('server', $assets, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('server')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('server', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('server', {id => $id});
}

sub save {
  my ($self, $id, $server) = @_;
  $self->pg->db->update('server', $server, {id => $id});
}

1;