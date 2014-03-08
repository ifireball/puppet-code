# Class: icinga::repo
#
# Setup software repository for installing Icinga
#
class icinga::repo {
  if $::osfamily == 'Debian' {
    apt::source { 'icinga-repo':
      location => $::operatingsystem ? {
        'Debian' => 'http://debmon.org/debmon',
      },
      release => $::operatingsystem ? {
        'Debian' => "debmon-$::lsbdistcodename",
      },
    }
  } else {
    fail "Icinga installation is not supported yet on this OS"
  }
}
