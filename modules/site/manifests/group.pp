# Define site::group
#
# Configure a user group
#
define site::group(
  $gid = hiera("Site::Group[$name]::gid"),
) {
  group {$name:
    gid => $gid,
  }
}
