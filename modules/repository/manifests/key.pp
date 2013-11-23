# Define: repository::key
#
# Manage package repository keys
#
define repository::key($source) {
  include repository::key_basedir
  $prefix = $repository::key_basedir::key_path_prefix
  $suffix = $repository::key_basedir::key_path_suffix
  $keypath = "$prefix$name$suffix"
  file { "repository-key-$name":
    path => $keypath,
    source => $source,
    owner => $repository::key_basedir::key_owner,
    group => $repository::key_basedir::key_group,
    mode => $repository::key_basedir::key_mode,
  }
  exec { "import-repository-key-$name":
    command => $::osfamily ? {
      'RedHat' => "/bin/rpm --import $keypath",
    },
    subscribe => File["repository-key-$name"],
    refreshonly => true,
  }
  # TODO: Use 'onlyif' to figure out if key is already registered rather then
  # using 'refreshonly' here
}
