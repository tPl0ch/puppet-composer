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
  $packages                 = [],
  $prefer_source            = false,
  $prefer_dist              = false,
  $dry_run                  = false,
  $custom_installers        = false,
  $scripts                  = false,
  $optimize                 = false,
  $interaction              = false,
  $dev                      = true,
  $no_update                = false,
  $no_progress              = false,
  $update_with_dependencies = false,
  $logoutput                = false,
  $verbose                  = false,
  $refreshonly              = false,
  $lock                     = false,
  $timeout                  = undef,
  $user                     = $composer::user,
  $global                   = false,
  $working_dir              = undef,
  $format                   = undef,
  $onlyif                   = undef,
  $unless                   = undef,
) {
  require ::composer

  validate_string($cmd, $cwd)
  validate_bool(
    $lock, $prefer_source, $prefer_dist, $dry_run,
    $custom_installers, $scripts, $optimize, $interaction, $dev,
    $verbose, $refreshonly
  )
  validate_array($packages)

  $m_timeout = $timeout?{
    undef => 300,
    default => $timeout
  }
  Exec {
    path        => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}",
    environment => ["COMPOSER_HOME=${composer::composer_home}", "COMPOSER_PROCESS_TIMEOUT=${m_timeout}"],
    user        => $user,
    timeout     => $timeout
  }

  $exec_cmds = [
    'install',
    'update',
    'require',
    'run-scripts',
    'clear-cache'
  ]

  if member($exec_cmds, $cmd) == false {
    fail(
      "Only types 'install', 'update', 'clear-cache', 'run-scripts' and 'require' are allowed, ${cmd} given"
    )
  }

  if $prefer_source and $prefer_dist {
    fail('Only one of \$prefer_source or \$prefer_dist can be true.')
  }

  # Validate format for clear-cache command
  if $format {
    if $cmd != 'clear-cache' {
      fail('Format only applies when \$cmd is set to `clear-cache`.')
    }
    elsif $format != 'text' and $format != 'json' {
      fail('Invalid format specified. Use \'text\' or \'json\'.')
    }
  }

  $composer_path = "${composer::target_dir}/${composer::composer_file}"

  $command = $global ? {
    true  => "${composer::php_bin} ${composer_path} global ${cmd}",
    false => "${composer::php_bin} ${composer_path} ${cmd}",
  }

  exec { "composer_${cmd}_${title}":
    command     => template("composer/${cmd}.erb"),
    cwd         => $cwd,
    logoutput   => $logoutput,
    refreshonly => $refreshonly,
    user        => $user,
    onlyif      => $onlyif,
    unless      => $unless,
  }
}
