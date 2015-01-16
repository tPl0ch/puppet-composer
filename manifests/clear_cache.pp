# == Type: composer::clearcache
#
# Clears the composer cache either globally or locally
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013-2015 Thomas Ploch
#
define composer::clear_cache(
  $global    = false,
  $user      = undef,
  $logoutput = false,
  $timeout   = 300,
  $tries     = 3,
) {
  require ::composer

  validate_bool($global)

  Exec {
    path        => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}",
    environment => "COMPOSER_HOME=${composer::composer_home}",
    user        => $user,
  }

  $composer_path = "${composer::target_dir}/${composer::composer_file}"
  $exec_name    = "composer_clearcache_${title}"

  $composer_cmd = $global ? {
    true    => 'global clearcache',
    default => 'clearcache',
  }

  $cmd = "${composer::php_bin} ${composer_path} ${composer_cmd}"

  exec { $exec_name:
    command => $cmd,
    tries   => $tries,
    timeout => $timeout,
    user    => $user,
  }
}
