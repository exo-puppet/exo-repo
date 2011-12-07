class repo::deb::update {
    
    info ("Refreshing repositories")
    
    exec { "repo-update":
        command     => "/usr/bin/apt-get update && /usr/bin/apt-get autoclean",
        loglevel => info,
        # Another Semaphor for all packages to reference
        alias => "apt_updated"
    }
    
}