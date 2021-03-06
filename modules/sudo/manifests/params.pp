class sudo::params {
  $source_base = "puppet:///modules/${module_name}/"

  case $::osfamily {
    debian: {
      case $::operatingsystem {
        'Ubuntu': {
          $source = "${source_base}sudoers.ubuntu"
        }
        default: {

          case $::lsbdistcodename {
            'wheezy': {
              $source = "${source_base}sudoers.wheezy"
            }
            default: {
              $source = "${source_base}sudoers.deb"
            }
          }
        }
      }
      $package = 'sudo'
      $config_file = '/etc/sudoers'
      $config_dir = '/etc/sudoers.d/'
      $config_file_group = 'root'
    }
    redhat: {
      $package = 'sudo'
      $config_file = '/etc/sudoers'
      $config_dir = '/etc/sudoers.d/'
      $source = $::operatingsystemrelease ? {
        /^5/    => "${source_base}sudoers.rhel5",
        /^6/    => "${source_base}sudoers.rhel6",
        default => "${source_base}sudoers.rhel6",
        }
      $config_file_group = 'root'
    }
    suse: {
      $package = 'sudo'
      $config_file = '/etc/sudoers'
      $config_dir = '/etc/sudoers.d/'
      $source = "${source_base}sudoers.suse"
      $config_file_group = 'root'
    }
    solaris: {
      case $::operatingsystem {
        'OmniOS': {
          $package = 'sudo'
          $config_file = '/etc/sudoers'
          $config_dir = '/etc/sudoers.d/'
          $source = "${source_base}sudoers.omnios"
          $config_file_group = 'root'
        }
        default: {
          case $::kernelrelease {
            '5.11': {
              $package = 'pkg://solaris/security/sudo'
              $config_file = '/etc/sudoers'
              $config_dir = '/etc/sudoers.d/'
              $source = "${source_base}sudoers.solaris"
              $config_file_group = 'root'
            }
            '5.10': {
              $package = 'SFWsudo'
              $config_file = '/opt/sfw/etc/sudoers'
              $config_dir = '/opt/sfw/etc/sudoers.d/'
              $source = "${source_base}sudoers.solaris"
              $config_file_group = 'root'
            }
            default: {
              fail("Unsupported platform: ${::osfamily}/${::operatingsystem}/${kernelrelease}")
            }
          }
        }
      }
    }
    freebsd: {
      $package = 'security/sudo'
      $config_file = '/usr/local/etc/sudoers'
      $config_dir = '/usr/local/etc/sudoers.d/'
      $source = "${source_base}sudoers.freebsd"
      $config_file_group = 'wheel'
    }
    aix: {
      $package = 'sudo'
      $package_source = 'http://www.oss4aix.org/compatible/aix53/sudo-1.8.7-1.aix5.1.ppc.rpm'
      $config_file = '/etc/sudoers'
      $config_dir = '/etc/sudoers.d/'
      $source = "${source_base}sudoers.aix"
      $config_file_group = 'system'
    }
    default: {
      case $::operatingsystem {
        gentoo: {
          $package = 'sudo'
          $config_file = '/etc/sudoers'
          $config_dir = '/etc/sudoers.d/'
          $source = "${source_base}sudoers.deb"
          $config_file_group = 'root'
        }
        archlinux: {
          $package = 'sudo'
          $config_file = '/etc/sudoers'
          $config_dir = '/etc/sudoers.d/'
          $source = "${source_base}sudoers.archlinux"
          $config_file_group = 'root'
        }
        amazon: {
           $package = 'sudo'
           $config_file = '/etc/sudoers'
           $config_dir = '/etc/sudoers.d/'
           $source = $::operatingsystemrelease ? {
             /^5/    => "${source_base}sudoers.rhel5",
             /^6/    => "${source_base}sudoers.rhel6",
             default => "${source_base}sudoers.rhel6",
           }
           $config_file_group = 'root'
        }
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }
}
