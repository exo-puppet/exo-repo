class repo::update {
  case $::operatingsystem {
    /(Ubuntu)/ : { include repo::deb::update }
    default    : { fail("The ${module_name} module is not supported on ${::operatingsystem}") }
  }
}
