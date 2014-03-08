# Class: site::common
#
# Common configuration for all site servers
#
class site::common {
  if $::osfamily == 'Debian' {
    include apt
  }
  include stdlib 

  include site::puppet::agent
  include site::sudo
  include site::utils::shell
  include site::utils::vim
  include site::groups
  include site::users
}
