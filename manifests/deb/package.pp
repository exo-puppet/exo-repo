################################################################################
# NEVER USE THIS DIRECTLY : use repo::package
################################################################################
define repo::deb::package ( $pkg, $preseed ) {

  if ( $preseed ) {

    file { "preseed-${name}":
        ensure  => present,
        path    => "${repo::params::preseed_dir}/${name}.preseed",
        owner   => $repo::params::preseed_owner,
        group   => $repo::params::preseed_group,
        mode    => $repo::params::preseed_mode_file,
        content => $preseed,
        require     => Class [ 'repo::install' ],
    }

    exec { "preseed-${name}-load":
        command     => "cat ${repo::params::preseed_dir}/${name}.preseed | debconf-set-selections",
        path        => '/usr/bin:/usr/sbin:/bin:/sbin',
        loglevel    => info,
        require     => File [ "preseed-${name}" ],
    }

    package { $title:
        ensure  => installed,
        name => $pkg,
        require => [ Exec [ "preseed-${name}-load" ], Exec ['repo-update'],  ]
    }

  } else {

    package { $title:
        ensure  => installed,
        name => $pkg,
        require => Exec ['repo-update']
    }

  }
}
