sharpie-deploy_keys
===================

A module to help manage SSH keys and associated aliases in SSH config.
Aliases allow other programs to access gated services without having to muck about with SSH keys.

### Caveats

This package has no stable releases yet.
Specifically, _there are no tests and all interfaces are subject to change_.
**Use in production at your own risk.**

This package also makes a few assumptions:

  - All deploy keys will be owned by root and placed in `/root/.ssh/`.

  - The SSH client configuration for root, `/root/.ssh/config` will be used to manage host aliases.
    This file is currently configured using the concat module which means any changes made outside of `concat::fragment` resources will be wiped out.

These restrictions may be lifted in future versions.
Additionally, the use of concat to manage the SSH config file is a design decision that may change in a future version.

Support
-------

Please log tickets and issues at: https://github.com/Sharpie/puppet-deploy_keys/issues
