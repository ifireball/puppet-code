# Class: site::common
#
# Common configuration for all site servers
#
class site::common {
  include site::puppet::agent
  include site::utils::vim
  include site::groups
  include site::users
}
