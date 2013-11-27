# Class: site::utils::vim
#
# Site-wide VIM setup
#
class site::utils::vim(
  $vimfiles = '/usr/share/vim/vimfiles',
  $packages = [ 'vim-enhanced', 'vim-X11' ],
) {
  package { $packages:
    ensure => 'latest',
  }
  $autoload = "$vimfiles/autoload"
  $plugin = "$vimfiles/plugin"
  $bundle = "$vimfiles/bundle"
  File {
    require => Package[$packages],
    owner => 'root',
    group => 'root',
    mode => '644',
  }
  file {
    "$autoload/pathogen.vim":
      source => 'puppet:///modules/site/vim/pathogen/autoload/pathogen.vim';
    "$plugin/zzz-site-config.vim":
      source => 'puppet:///modules/site/vim/zzz-site-config.vim';
    $bundle:
      ensure => 'directory',
      recurse => true,
      purge => true,
      links => 'manage',
      source => 'puppet:///modules/site/vim/bundle';
  }
}
