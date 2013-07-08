class repo::config {
  case $::operatingsystem {
    /(Ubuntu)/ : { include repo::deb::config }
    default    : { fail("The ${module_name} module is not supported on ${::operatingsystem}") }
  }
}
