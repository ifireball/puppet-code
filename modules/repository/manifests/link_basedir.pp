# Class: repository::link_basedir
#
# Manage direcotry for repository links
#
class repository::link_basedir (
  $path = $::osfamily ? {
    'RedHat' => '/etc/yum.repos.d',
  },
  $owner = 'root',
  $group = 'root',
  $mode = 755,
  $link_prefix = $::osfamily ? {
    'RedHat' => '',
  },
  $link_suffix = $::osfamily ? {
    'RedHat' => '.repo',
  },
  $link_owner = 'root',
  $link_group = 'root',
  $link_mode = '644',
) {
  file { $path:
    ensure => 'directory',
    owner => $owner,
    group => $group,
    mode => $mode,
  }
  $link_path_prefix = "$path/$link_prefix"
  $link_path_suffix = "$link_suffix"
}

