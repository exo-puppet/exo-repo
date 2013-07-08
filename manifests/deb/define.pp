################################################################################
# NEVER USE THIS DIRECTLY : use repo::define
################################################################################
define repo::deb::define (
  $file_name,
  $url,
  $distribution,
  $sections,
  $source,
  $installed,
  $key,
  $key_server) {
  include stdlib

  $sections_string = join($sections, ' ')

  if $distribution == '' {
    $components = "${::lsbdistcodename} ${sections_string}"
  } elsif $distribution =~ /\/$/ {
    # we ignore the sections if the distribution ends with a / (slash)
    info('As the distribution parameter ends with a / we ignore the sections parameter')
    $components = $distribution
  } else {
    $components = "${distribution} ${sections_string}"
  }

  file { "/etc/apt/sources.list.d/${file_name}.list":
    ensure  => $installed ? {
      true    => present,
      default => absent
    },
    content => $source ? {
      true    => inline_template("deb ${url} ${components} \ndeb-src ${url} ${components} \n"),
      default => inline_template("deb ${url} ${components} \n")
    },
    before  => Exec['repo-update'],
    notify  => Exec['repo-update'],
  }

  if ($key != '') {
    info("Manage GPG Key ${key} installation")

    exec { "gpg-key-${key}":
      command  => "/usr/bin/gpg --keyserver ${key_server} --recv-key ${key} && /usr/bin/gpg -a --export ${key} | /usr/bin/apt-key add -",
      unless   => "/usr/bin/apt-key list | grep ${key}",
      loglevel => info,
    }
  }
}
