# Class: site::puppet::master
#
# This class configures the Puppetmastrer server in this site.
#
class site::puppet::master inherits site::puppet::agent {
  include site::common
  class { 'puppetdb':
    database => 'embedded',
  }
  if $::fqdn != "$hostname.local" {
    $extraopts = {
      'dns_alt_name' => "$hostname.local",
    }
  }
  #class { 'site::passenger': }
  class { '::puppet::master':
    storeconfigs         => true,
    storeconfigs_backend => 'puppetdb',
    require => Class['puppetdb'],
    extraopts => $extraopts,
  }
  class { 'puppetdb::master::config':
    manage_storeconfigs => false,
    manage_report_processor => false,
  }
}

