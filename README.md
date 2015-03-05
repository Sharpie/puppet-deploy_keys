sharpie-deploy_keys
===================

A module to help manage SSH keys and associated aliases in SSH config. Aliases allow SSH-aware programs to access gated services with simple URLs without having to also manage configuration for SSH keys.

Examples
--------

Defining a deploy key for r10k to use when syncing a control repo:

```puppet
deploy_keys::deploy_key {'r10k-control-repo':
  ssh_dir     => '/root/.ssh',
  owner       => 'root',
  group       => 'root',
  private_key => '...'
  hostname    => 'github.com',
  host_key    => {
    type     => 'ssh-rsa',
    host_key => '...',
  }
}
```

Define a SSH alias to use an existing private key:

```puppet
deploy_keys::ssh_alias {'github':
  hostname      => 'github.com',
  config_file   => '/home/someuser/.ssh/config',
  identity_file => '/home/someuser/.ssh/some_private_key',
}
```


Support
-------

Please log tickets and issues at: https://github.com/Sharpie/puppet-deploy_keys/issues
