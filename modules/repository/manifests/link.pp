# Define: repository::link
#
# Manage repository links
#
define repository::link(
  $description = undef,
  $url,
  $key = undef,
  $enabled = true,
  $keyverify = true,
) {
  include repository::link_basedir
  if !is_string($key) {
    $key_url = undef
  } elsif $key !~ /\// {
    include repository::key_basedir
    $key_prefix = $repository::key_basedir::key_path_prefix
    $key_suffix = $repository::key_basedir::key_path_suffix
    $key_url = "file://$key_prefix$key$key_suffix"
    Repository::Key[$key] -> File["repository-link-$name"]
  } elsif $key =~ /^puppet:\/\/\// {
    include repository::key_basedir
    $key_prefix = $repository::key_basedir::key_path_prefix
    $key_suffix = $repository::key_basedir::key_path_suffix
    $key_url = "file://$key_prefix$key$key_suffix"
    repository::key { $name:
      source => $key,
    }
  } else {
    $key_url = $key
  }
  $prefix = $repository::link_basedir::link_path_prefix
  $suffix = $repository::link_basedir::link_path_suffix
  $enabled_num = bool2num($enabled)
  $keyverify_num = bool2num($keyverify)
  file { "repository-link-$name":
    path => "$prefix$name$suffix",
    content => template("repository/link.$::osfamily.erb"),
    owner => $repository::link_basedir::link_owner,
    group => $repository::link_basedir::link_group,
    mode => $repository::link_basedir::link_mode,
  }
}

