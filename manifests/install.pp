class repo::install {
    case $::operatingsystem {
        /(Ubuntu)/: {
            include repo::deb::install
        }
        default: {
            fail ("The ${module_name} module is not supported on $::operatingsystem")
        }
    }
}