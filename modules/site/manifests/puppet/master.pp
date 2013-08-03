# Class: site::puppet::master
#
# This class configures the Puppetmastrer server in this site.
#
class site::puppet::master {
  class { 'puppetdb':
    database => 'embedded',
  }
  class { 'puppet::master':
    storeconfigs         => true,
    storeconfigs_backend => 'puppetdb',
    require => Class['puppetdb'],
  }
  if $::fqdn != "$hostname.local" {
    Class['puppet::master'] {
      extraopts => {
	'dns_alt_name' => "$hostname.local",
      }
    }
  }
}

