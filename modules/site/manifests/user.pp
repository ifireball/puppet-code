# Define site::user
#
# Configure a user account
#
define site::user(
  $uid = hiera("Site::User[$name]::uid"),
  $gid = hiera("Site::User[$name]::gid"),
  $groups = hiera("Site::User[$name]::groups", unset),
  $comment = hiera("Site::User[$name]::comment", ''),
  $ssh_public = hiera("Site::User[$name]::ssh_public", unset),
  $ssh_public_type = hiera("Site::User[$name]::ssh_public_type", 'ssh-rsa'),
) {
  if $groups == unset {
    $r_groups = [ $name, ]
  } else {
    $r_groups = $groups
  }
  $home = "/home/$name"
  $sshdir = "$home/.ssh"
  group { $name: gid => $gid, } ->
  user { $name:
    uid => $uid,
    gid => $gid,
    groups => $r_groups,
    comment => $comment,
    home => $home,
    managehome => false,
  }
  File {
    owner => $name,
    group => $name,
    mode => 644,
  }
  file { 
    $home: 
      ensure => directory;
    $sshdir: 
      mode => 700,
      ensure => directory;
    "$home/.bashrc": 
      source => 'puppet:///modules/site/user/home/.bashrc';
    "$home/.bash_profile":
      source => 'puppet:///modules/site/user/home/.bash_profile';
    "$home/.bash_logout": 
      source => 'puppet:///modules/site/user/home/.bash_logout';
  }
  unless $ssh_public == unset {
    ssh_authorized_key { "$name@generic":
      key => $ssh_public,
      type => $ssh_public_type,
      user => $name,
      require => File[$sshdir],
    }
  }
}
