# == Class: deploy_keys
#
# Manages SSH keys, host keys and client config assets in +/root/.ssh+
#
# === Parameters
#
# [*ssh_keys*]
#   A hash that declares SSH private keys to manage by mapping file paths to
#   hashes of parameters for File resources.
#   All keys created will be owned by the root user.
#   Default: {}
#
# [*host_keys*]
#   A hash that declares known_hosts entries to manage by mapping domain names
#   to hashes of parameters for Sshkey resources.
#   These entries will be placed in the known_hosts file for the root user.
#   Default: {}
#
# [*ssh_host_aliases*]
#   A hash that declares host aliases to manage in the SSH client config by
#   mapping alias names to a hash containing parameters for Ssh_host_alias
#   resources.
#   Default: {}
#
#
# === Authors
#
# Charlie Sharpsteen <source@sharpsteen.net>
#
class deploy_keys (
  $ssh_keys         = {},
  $host_keys        = {},
  $ssh_host_aliases = {},
){

  # FIXME: We need to ensure this is present, but it could be managed by
  # another class! And could have slightly different permissions/attributes!
  # A very plausible example is a recursive file resource that sets the perms.
  file {'/root/.ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '700',
  }

  create_resources('file', $ssh_keys, {
    ensure  => 'file',
    require => File['/root/.ssh'],
    owner   => 'root',
    group   => 'root',
    mode    => '600',
  })

  create_resources('sshkey', $host_keys, {
    ensure  => present,
    type    => 'ssh-rsa',
    target  => '/root/.ssh/known_hosts',
    require => File['/root/.ssh'],
  })

  concat {'/root/.ssh/config':
    owner   => 'root',
    group   => 'root',
    mode    => '600',
    require => File['/root/.ssh'],
  }

  # TODO: Would be better to somehow depend on the key file and on the host key if
  # check_host_key is defined to true.
  create_resources('deploy_keys::ssh_host_alias', $ssh_host_aliases, {
    check_host_key => true,
  })

}
