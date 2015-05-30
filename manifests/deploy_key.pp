# == Define: deploy_key
#
# Creates resources to facilitate the use of a deployment key:
#
#   - A SSH private key file containing the key.
#
#   - A SSH hostname alias that uses the private key.
#
#   - Optionally, a SSH host key fingerprint that validates the remote host.
#
# === Parameters
#
# [*ssh_dir*]
#   A string giving the location of a +.ssh+ directory for a user. The
#   +deploy_key+ resource expects this directory to exist and does not manage
#   it.
#
# [*owner*]
#   A string giving the user who should own the private key file.
#
# [*group*]
#   A string giving the group who should own the private key file.
#
# [*private_key*]
#   A string containing a private key to be used as the deploy key.
#
# [*hostname*]
#   A string given the hostname to which the deploy grants access.
#
# [*host_key*]
#   An optional hash that contains +type+ and +key+ parameters for a +sshkey+
#   defining the ssh host fingerprint of the hostname.
#   Default: {}
#
# [*ensure*]
#   Default: present
#
# === Authors
#
# Charlie Sharpsteen <source@sharpsteen.net>
#
define deploy_keys::deploy_key (
  $ssh_dir,
  $owner,
  $group,
  $private_key,
  $hostname,
  $host_key     = {},
  $ensure       = present,
){

  $identity_file = "${ssh_dir}/${title}"
  file {$identity_file:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0600',
    content => $private_key,
  }

  unless empty($host_key) {
    # Normally, sshkey would use `$hostname` as the title, however we don't
    # want to "own" the only instance of a host key for a domain. So, we create
    # a bogus title and set the `$hostname` as an alias. This allows the same
    # host_key to be added to multiple accounts and allows us to `ensure =>
    # absent` without destroying something other configuration could depend on.
    sshkey {"${title}-host_key":
      ensure       => $ensure,
      target       => "${ssh_dir}/known_hosts",
      type         => $host_key['type'],
      key          => $host_key['key'],
      host_aliases => [$hostname],
      # This piggybacks onto the autorequire relationship $identity_file may
      # have with $ssh_dir. This allows us to avoid references to $ssh_dir,
      # which may not be managed by a catalog, yet still "do the right thing"
      # in a catalog that enforces the existance of $ssh_dir.
      require => File[$identity_file],
    }
  }

  deploy_keys::ssh_host_alias {$title:
    ensure        => $ensure,
    hostname      => $hostname,
    config_file   => "${ssh_dir}/config",
    identity_file => $identity_file,
  }

}
