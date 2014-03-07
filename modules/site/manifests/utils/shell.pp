# Class: site::utils:shell
#
# Site-wide shell setup
#
class site::utils::shell($profile_d = '/etc/profile.d') {
  File {
    owner => 'root',
    group => 'root',
    mode => 644,
  }
  file {
    $profile_d:
      ensure => directory;
    "$profile_d/zzz_site_bashrc.sh":
      source => 'puppet:///modules/site/shell/zzz_site_bashrc.sh';
  }
}

