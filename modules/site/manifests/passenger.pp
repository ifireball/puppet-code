# Class: site::passenger
#
# Tweak the PuppetLabs ::passenger class to use the native Fedora RPM instead of
# compiling from a GEM file
#
class site::passenger {
  class { '::passenger':
    passenger_provider => 'yum',
    passenger_package => 'mod_passenger',
    passenger_version => 'latest',
    mod_passenger_location => '/usr/lib64/httpd/modules/mod_passenger.so'
  }
  # Use resource collection to make sure the ::passenger class does not clobber
  # the module configuration file shipped with the RPM package
  File <| title == '/etc/httpd/conf.d/passenger.conf' |> {
    content => undef,
  }
}

