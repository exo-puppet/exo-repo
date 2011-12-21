################################################################################
# NEVER USE THIS DIRECTLY : use repo::install
################################################################################
class repo::deb::install {
    package { ["dpkg", "apt", "apt-show-versions", "aptitude", "debconf-utils"]:
        ensure  => installed,
        require => Class["repo::params"],
    }
}