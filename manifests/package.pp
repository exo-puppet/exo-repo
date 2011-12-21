define repo::package ( $pkg = false,  $preseed = false ) { 
    
    case $::operatingsystem {
        /(Ubuntu)/: {
            repo::deb::package { $title:
                pkg     => $pkg ? {
                    false   => $title,
                    default => $pkg,
                },
                preseed => $preseed,
                require => Class [ "repo::deb::config" ],
            }
        }
        default: {
            fail ("The ${module_name} module is not supported on $::operatingsystem")
        }
    }
    
}