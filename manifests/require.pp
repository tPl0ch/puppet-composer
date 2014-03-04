# == Type: composer::exec
#
# Adds new packages to the composer.json file from the current directory.
#
# Since 'require' is a reserved word, we use 'requirepack' instead
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
define composer::requirepack (
  $cwd,
  $global            = false,
  $packages          = [],
  $prefer_source     = false,
  $prefer_dist       = false,
  $custom_installers = false,
  $scripts           = false,
  $optimize          = false,
  $interaction       = false,
  $dev               = false,
  $logoutput         = false,
  $verbose           = false,
  $refreshonly       = false,
  $user              = undef,
) {
  require composer
  require git

  Exec {
    path        => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}",
    environment => "COMPOSER_HOME=${composer::composer_home}",
    user        => $user,
  }

  if $prefer_source and $prefer_dist {
    fail('Only one of \$prefer_source or \$prefer_dist can be true.')
  }

  if $global {
    $global_opt = 'global'
  }
  else {
    $global_opt = ''
  }

  $command = "${composer::php_bin} ${global_opt} require ${composer::target_dir}/${composer::composer_file}"

  exec { "composer_update_${title}":
    command     => template('composer/exec.erb'),
    cwd         => $cwd,
    logoutput   => $logoutput,
    refreshonly => $refreshonly
  }
}
