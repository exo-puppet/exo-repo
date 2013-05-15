################################################################################
# NEVER USE THIS DIRECTLY : use repo::define
################################################################################
define repo::deb::define ( $file_name, $url, $distribution, $sections, $source, $installed, $key, $key_server ) {
    
    include stdlib
    
    $sections_string = join($sections, ' ')
    $components = $distribution ? {
        ""      => "${::lsbdistcodename} ${sections_string}",
        default => "${sections_string}",
    }
    
    file {"/etc/apt/sources.list.d/${file_name}.list":
        ensure  => $installed ? { true => present, default => absent },
        content => $source ? {
            true    => inline_template ("deb ${url} ${distribution} ${components} \ndeb-src ${url} ${distribution} ${components} \n"),
            default => inline_template ("deb ${url} ${distribution} ${components} \n")
        },
        before  => Exec["repo-update"],
        notify  => Exec["repo-update"],
    }
    
    if ( $key != "" ) {
        info ("Manage GPG Key ${key} installation")
        exec { "gpg-key-${key}":
            command     => "/usr/bin/gpg --keyserver ${key_server} --recv-key ${key} && /usr/bin/gpg -a --export ${key} | /usr/bin/apt-key add -",
            unless      => "/usr/bin/apt-key list | grep ${key}",
            loglevel    => info,
        }
    }
}