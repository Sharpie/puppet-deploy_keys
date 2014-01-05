# == Define: ssh_host_alias
#
# Manages host alias definitions in the SSH client config file for the root
# user.
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
# [*identityfile*]
#   The path to a SSH private key that authenticates all SSH communication
#   using the aliased address. May be empty.
#   Default: ''
#
# [*check_host_key*]
#   A boolean value that controls whether or not the hostname should be checked
#   against the +known_hosts+ file.
#   Default: true
#
# === Authors
#
# Charlie Sharpsteen <source@sharpsteen.net>
#
define deploy_keys::ssh_host_alias (
  $hostname,
  $identityfile = '',
  $check_host_key = true
){
  # TODO: Extend this to handle more than just aliases for the root user.

  concat::fragment{"hostalias-${title}":
    target  => '/root/.ssh/config',
    content => template('deploy_keys/ssh_host_alias.erb'),
  }
}
