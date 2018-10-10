package PerlDevOps::Model::KubeCluster;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $kubeCluster) = @_;
  return $self->pg->db->insert('kube_cluster', $kubeCluster, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('kube_cluster')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('kube_cluster', '*', {id => $id})->hash;
}

sub find_by_cluster {
  my ($self, $cluster) = @_;
  return $self->pg->db->select('kube_cluster', '*', {cluster => $cluster})->hashes->to_array;
}

sub find_cluster_no_config_ssh {
  my ($self, $cluster) = @_;
  return $self->pg->db->select('kube_cluster', '*', {cluster => $cluster, ssh => 0})->hashes->to_array;
}

sub find_by_cluster_type {
  my ($self, $cluster,$type) = @_;
  return $self->pg->db->select('kube_cluster', '*', {cluster => $cluster, type => $type})->hashes->to_array;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('kube_cluster', {id => $id});
}

sub remove_by_cluster {
  my ($self, $cluster) = @_;
  $self->pg->db->delete('kube_cluster', {cluster => $cluster});
}

sub save {
  my ($self, $id, $kubeCluster) = @_;
  $self->pg->db->update('kube_cluster', $kubeCluster, {id => $id});
}

1;