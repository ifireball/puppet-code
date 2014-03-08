# Global site configuration file
#
# This is where node classifications go
#
node puppetmaster {
  include site::puppet::master
}

node factory11 {
  include site::common
  include ichinga::server
}

node default {
  include site::common
}

