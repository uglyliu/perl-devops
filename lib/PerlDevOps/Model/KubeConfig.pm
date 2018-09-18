package PerlDevOps::Model::KubeConfig;
use Mojo::Base -base;

sub add {
  my ($self, $kubeConfig) = @_;
  return $self->pg->db->insert('kub_config', $kubeConfig, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('kub_config')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('kub_config', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('kub_config', {id => $id});
}

sub save {
  my ($self, $id, $kubeConfig) = @_;
  $self->pg->db->update('kub_config', $kubeConfig, {id => $id});
}

1;