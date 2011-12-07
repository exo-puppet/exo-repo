# Class: puppet::params
#
# This class manage the puppet parameters for different OS
class repo::params {
    
    case $::operatingsystem {
        /(Ubuntu|Debian)/: {
            # nothing special for now
        }
        default: {
            fail ("The ${module_name} module is not supported on $::operatingsystem")
        }
    }
}
