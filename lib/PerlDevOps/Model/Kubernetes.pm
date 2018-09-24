package PerlDevOps::Model::Kubernetes;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $kubeConfig) = @_;
  return $self->pg->db->insert('kube_config', $kubeConfig, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('kube_config')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('kube_config', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('kube_config', {id => $id});
}

sub save {
  my ($self, $id, $kubeConfig) = @_;
  $self->pg->db->update('kube_config', $kubeConfig, {id => $id});
}

1;