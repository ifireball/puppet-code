# Class site::groups
#
# Configure site user groups
#
class site::groups($list) {
  site::group{ $list: }
}

