# Global site configuration file
#
# This is where node classifications go
#
node puppetmaster {
  include site::puppet::master
}

node default {
  include site::common
}

