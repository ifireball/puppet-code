# Class site::users
#
# Configure site user accounts
#
class site::users($list) {
  site::user { $list: }
}

