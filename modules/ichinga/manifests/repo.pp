# Class: ichinga::repo
#
# Setup software repository for installing ichinga
#
class ichinga::repo {
  if $::osfamily == 'Debian' {
    apt::source { 'ichinga-repo':
      location => $::operatingsystem ? {
        'Debian' => 'http://debmon.org/debmon',
      },
    }
  }
}
