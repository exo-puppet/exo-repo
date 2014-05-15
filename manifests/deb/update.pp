# == Parameters
#   [+frequency_limit+]
#       (OPTIONAL) (default: 0)
#
#       this variable allows to choose the amount of minutes to wait between 2 debian repo updates with apt-get update
#       0     => mean no limit and execute the update each time
#       30    => mean that we wait a minimum of 30 minutes between 2 updates
#       720   => mean that we wait a minimum of 12 hours between 2 updates
#       1444  => mean that we wait a minimum of 1 day between 2 updates (60 minutes x 24 heures = 1440 minutes)
#
class repo::deb::update ($frequency_limit=720, $timestamp_file='/tmp/puppet-apt-get-update.timestamp') {
  info('Refreshing repositories')

  exec { 'repo-update':
    command  => "/usr/bin/apt-get update && /usr/bin/apt-get autoclean && touch -m ${timestamp_file}",
    loglevel => info,
    # Another Semaphor for all packages to reference
    alias    => 'apt_updated',
    # It can be long and create zombie processes
    timeout  => 0,
    # We execute the repo update only if :
    #   - the timestamp file doesn't exists
    #   or
    #   - the timestamp file was modified more than ${frequency_limit} minute ago
    unless => "test -f ${timestamp_file} -a ! -z \"$(find ${timestamp_file} -mmin -${frequency_limit} 2> /dev/null | head -n 1)\""
  }

}
