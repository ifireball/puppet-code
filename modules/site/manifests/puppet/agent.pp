# Class: site::puppet::agent
#
# This class configures the Puppet agents in this site.
#
class site::puppet::agent {
  class { '::puppet::agent':
    forcenoop     => false,
    service       => false,
    cron_enable   => false,
    cron_silent   => true,
    puppet_server => $::servername,
    agent_extraopts => {
      server => $::servername,
    }
  }
}

