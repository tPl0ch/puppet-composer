# == Type: composer::dump_autoload
#
# Dumps the composer autoloader either globally or locally
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013-2015 Thomas Ploch
#
define composer::dump_autoload(
  $optimize  = false,
  $no_dev    = false,
  $global    = false,
  $user      = undef,
  $logoutput = false,
  $timeout   = 300,
  $tries     = 3,
) {
  require ::composer

  validate_bool($global, $optimize, $no_dev)

  Exec {
    path        => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}",
    environment => "COMPOSER_HOME=${composer::composer_home}",
    user        => $user,
  }

  $composer_path = "${composer::target_dir}/${composer::composer_file}"
  $exec_name    = "composer_clearcache_${title}"

  $optimize_arg = $optimize ? {
    true    => ' -o',
    default => '',
  }

  $no_dev_arg = $no_dev ? {
    true    => ' --no-dev',
    default => '',
  }

  $composer_cmd = $global ? {
    true    => "global dump-autoload${optimize_arg}${no_dev_arg}",
    default => "dump-autoload${optimize_arg}${no_dev_arg}",
  }

  $cmd = "${composer::php_bin} ${composer_path} ${composer_cmd}"

  exec { $exec_name:
    command => $cmd,
    tries   => $tries,
    timeout => $timeout,
    user    => $user,
  }
}
