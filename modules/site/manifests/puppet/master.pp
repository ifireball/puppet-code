# Class: site::puppet::master
#
# This class configures the Puppetmastrer server in this site.
#
class site::puppet::master {
  class { 'puppetdb':
    database => 'embedded',
  }
  if $::fqdn != "$hostname.local" {
    $extraopts = {
      'dns_alt_name' => "$hostname.local",
    }
  }
  class { '::puppet::master':
    storeconfigs         => true,
    storeconfigs_backend => 'puppetdb',
    require => Class['puppetdb'],
    extraopts => $extraopts,
  }
}

