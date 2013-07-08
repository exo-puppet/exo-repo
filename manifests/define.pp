################################################################################
#
#   This module system repositories (actually only Debian repositories).
#
#   Tested platforms:
#    - Ubuntu 11.10 Oneiric
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# == Parameters
#
# [+file_name+]
#   (MANDATORY) (default: )
#
#   this parameter will be used for the name of the repository configuration file (ubuntu example:
#   /etc/apt/source.list.d/$file_name.list)
#
# [+url+]
#   (MANDATORY) (default: )
#
#   specify the root url of the repository (ubuntu example: http://apt.puppetlabs.com/ubuntu)
#
# [+distribution+]
#   (OPTIONAL) (default: "" )
#
#   distribution can specify an exact path, in which case the sections (components) must be omitted and distribution  must  end
#   with a slash (/).
#
# [+sections+]
#   (OPTIONAL) (default: ["main"] )
#
#   specify the sections of the repository to add (ubuntu example: ["main", "contrib" ] )
#
# [+source+]
#   (OPTIONAL) (default: true )
#
#   specify if the repository to configure contains source package (true) or not (false)
#
# [+installed+]
#   (OPTIONAL) (default: true )
#
#   specify if the configured repository should be installed (true) or not (false).
#   This parameter is usefull to remove a repository already installed.
#
# [+key+]
#   (OPTIONAL) (default: )
#
#   specify a key id to install for the defined repository.
#
# [+key_server+]
#   (OPTIONAL) (default: keyserver.ubuntu.com)
#
#   the key server to use to fetch the gpg key.
#
# == Modules Dependencies
#
# [+stdlib+]
#   the +stdlib+ puppet module is needed for repo::define::deb which use the +join+ method.
#
# == Examples
#
# === Simple Agent Usage
#
# Install the Puppet Lab debian package repository (binaries and sources)
#
#   repo::define { "puppetlab-repo":
#       file_name   => "puppetlabs",
#       url         => "http://apt.puppetlabs.com/ubuntu",
#       sections    => ["main", "contrib" ],
#       source      => true,
#   }
#
################################################################################
define repo::define (
  $file_name    = '',
  $url,
  $distribution = '',
  $sections     = [
    'main'],
  $source       = true,
  $installed    = true,
  $key          = '',
  $key_server   = 'keyserver.ubuntu.com') {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      if ($installed == true) {
        info("Installing ${title} ${::operatingsystem} repository")
      } else {
        info("Removing ${title} ${::operatingsystem} repository")
      }

      repo::deb::define { $title:
        file_name    => $file_name ? {
          /(''|"")/ => $title,
          default   => $file_name,
        },
        url          => $url,
        distribution => $distribution,
        sections     => $sections,
        source       => $source,
        installed    => $installed,
        key          => $key,
        key_server   => $key_server,
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }

}
