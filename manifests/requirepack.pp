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
  $project_name,
  $cwd,
  $packages          = [],
  $global            = false,
  $prefer_source     = false,
  $update            = false,
  $progress          = false,
  $prefer_dist       = false,
  $update_with_deps  = false,
  $dev               = false,
  $logoutput         = false,
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

  $command = "${composer::php_bin} ${composer::target_dir}/${composer::composer_file} ${global_opt} require ${project_name}"
  notify {$command:}

  exec { "composer_update_${title}":
    command     => template('composer/exec.erb'),
    cwd         => $cwd,
    logoutput   => $logoutput,
    refreshonly => $refreshonly
  }
}
