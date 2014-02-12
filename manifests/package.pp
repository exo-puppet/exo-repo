define repo::package (
  # allowed values : present | installed | absent | purged | held | latest
  $ensure  = installed,
  # the package name
  $pkg     = false,

  $preseed = false) {

  case $ensure {
    /(present|installed|absent|purged|held|latest)/ : {
      # everything is fine
    }
    default : {
      fail ("The \"ensure\" parameter value is not correct ! use one of [ present | installed | absent | purged | held | latest ] ")
    }
  }
  case $::operatingsystem {
    /(Ubuntu)/ : {
      repo::deb::package { $title:
        ensure  => $ensure,
        pkg     => $pkg ? {
          false   => $title,
          default => $pkg,
        },
        preseed => $preseed,
        require => Class['repo::deb::config'],
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }

}
