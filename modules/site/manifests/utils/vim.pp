# Class: site::utils::vim
#
# Site-wide VIM setup
#
class site::utils::vim(
  $vimfiles = '/usr/share/vim/vimfiles',
  $packages = $::osfamily ? {
    'RedHat' => [ 'vim-enhanced', 'vim-X11' ],
    'Debian' => [ 'vim', 'vim-gnome' ], 
  },
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
    [ $autoload, $plugin, ]:
      ensure => 'directory';
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
