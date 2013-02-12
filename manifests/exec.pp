# == Type: composer::exec
#
# Either installs from composer.json or updates project or specific packages
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
define composer::exec (
  $cmd,
  $cwd,
  $packages          = [],
  $prefer_source     = false,
  $prefer_dist       = false,
  $dry_run           = false,
  $no_custom_installers = true,
  $no_scripts           = true,
  $optimize          = false,
  $no_interaction    = true,
  $dev               = false,
  $logoutput         = false,
  $verbose           = false
) {
  require composer
  require git

  if $cmd != 'install' and $cmd != 'update' {
    fail("Only types 'install' and 'update' are allowed, $type given")
  }

  if $prefer_source and $prefer_dist {
    fail("Only one of \$prefer_source or \$prefer_dist can be true.")
  }

  $command = "php ${composer::target_dir}/${composer::composer_file} ${cmd}"

  exec { "composer_update_${title}":
    command   => template('composer/exec.erb'),
    cwd       => $cwd,
    logoutput => $logoutput,
    path      => [ $composer::target_dir ],
  }
}