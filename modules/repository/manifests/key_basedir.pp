# Class: repository::key_basedir
#
# Manage direcotry for repository keys
#
class repository::key_basedir (
  $path = $::osfamily ? {
    'RedHat' => '/etc/pki/rpm-gpg',
  },
  $owner = 'root',
  $group = 'root',
  $mode = 755,
  $key_prefix = $::osfamily ? {
    'RedHat' => 'RPM-GPG-KEY-',
  },
  $key_suffix = $::osfamily ? {
    'RedHat' => '',
  },
  $key_owner = 'root',
  $key_group = 'root',
  $key_mode = '644',
) {
  file { $path:
    ensure => 'directory',
    owner => $owner,
    group => $group,
    mode => $mode,
  }
  $key_path_prefix = "$path/$key_prefix"
  $key_path_suffix = "$key_suffix"
}

