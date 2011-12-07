class repo::deb::config {
    # check apt configuration directories
    file { [ "/etc/apt/", "/etc/apt/apt.conf.d", "/etc/apt/preferences.d", "/etc/apt/sources.list.d", "/etc/apt/trusted.gpg.d" ]:
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 644,
        require => Class["repo::install"],
    }
}