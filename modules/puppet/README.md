# puppet-puppet

## Overview

Puppet module to solve the chicken and egg problem : Manage puppet masters and
agents from puppet.

## Examples

Example puppet agent :

    class { 'puppet::agent':
      forcenoop     => true,
      service       => false,
      cron_enable   => true,
      cron_silent   => true,
      puppet_server => 'puppet.example.com',
    }

The noop related options are especially useful for small deployments where
there is no testing environment but there is a Dashboard or similar, since
no changes will be automatically made, but all pending changes will appear
and be easy to review. The included `repuppet` script can then be run on
nodes where changes are to be applied.

Example puppet master with Passenger, PuppetDB and sending reports to a local
Dashboard (configured separately) :

    class { 'puppet::master':
      runtype              => 'passenger',
      reports              => 'http',
      storeconfigs         => true,
      storeconfigs_backend => 'puppetdb',
    }

When enabling the `puppet::master` class, the `puppet::agent`'s main
configuration is then changed to be `puppetagent.conf`, and both it and a
`puppetmaster.conf` are automatically concatenated together as `puppet.conf`
when either changes.

This is because it isn't trivial to use a different configuration for each.

Example puppet master with the default webrick service run and MySQL for
stored configurations (configured separately) :

    class { 'puppet::master':
      runtype      => 'service',
      certname     => 'puppet.example.com',
      storeconfigs => true,
      dbadapter    => 'mysql',
      dbserver     => 'localhost',
      dbname       => 'puppet',
      dbuser       => 'puppet',
      dbpassword   => 'password123',
      dbsocket     => '/var/lib/mysql/mysql.sock',
      extraopts    => {
        'masterlog' => '/var/log/puppet/puppetmaster.log',
        'autoflush' => 'true',
      },  
    }

