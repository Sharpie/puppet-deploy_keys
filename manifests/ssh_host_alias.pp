# == Define: ssh_host_alias
#
# Manages host alias definitions in SSH client config files.
#
# === Parameters
#
# [*namevar*]
#   A name for the alias. For example, providing +internal-repo+ will allow
#   commands that honor the SSH client config to use addresses such as:
#   +git@internal-repo:someuser/somerepo+
#
# [*hostname*]
#   The real hostname that communication should be directed to for SSH commands
#   using the aliased address.
#
# [*config_file*]
#   A string that gives the location of the ssh config file where the alias
#   should be placed.
#
# [*identity_file*]
#   The path to a SSH private key that authenticates all SSH communication
#   using the aliased address. May be empty.
#   Default: ''
#
# [*ensure*]
#   Default: present
#
# === Authors
#
# Charlie Sharpsteen <source@sharpsteen.net>
#
define deploy_keys::ssh_host_alias (
  $hostname,
  $config_file,
  $identity_file = '',
  $ensure = present,
){

  Ssh_config {
    ensure => $ensure,
    target => $config_file,
    host   => $title,
  }

  ssh_config {"Host Alias ${title}: HostName":
    key   => 'HostName',
    value => $hostname,
  }

  unless empty($identity_file) {
    ssh_config {"Host Alias ${title}: IdentityFile":
      key     => 'IdentityFile',
      value   => $identity_file,
      require => File["${identity_file}"],
    }
  }

}
