# Class: puppet::params
#
# This class manage the puppet parameters for different OS
class repo::params {
  case $::operatingsystem {
    /(Ubuntu|Debian)/ : {
      $preseed_dir       = '/var/local/preseed'
      $preseed_owner     = 'root'
      $preseed_group     = 'root'
      $preseed_mode_dir  = '700'
      $preseed_mode_file = '600'
    }
    default           : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
