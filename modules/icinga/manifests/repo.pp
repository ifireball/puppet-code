# Class: icinga::repo
#
# Setup software repository for installing Icinga
#
class icinga::repo {
  if $::operatingsystem == 'Debian' {
    apt::source { 'icinga-repo':
      location => 'http://debmon.org/debmon',
      release => "debmon-$::lsbdistcodename",
      key => '29D662D2',
      key_source => 'http://debmon.org/debmon/repo.key',
    }
  } else {
    fail "Icinga installation is not supported yet on this OS"
  }
}
