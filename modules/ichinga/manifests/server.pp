# Class: ichinga::server
#
# Setup an ichinga monitoring server
#
class ichinga::server {
  include ichinga::repo
  Package { require => Class['ichinga::repo'], }
}

