# == Class: composer::params
#
# The parameters for the composer class and corresponding definitions
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
class composer::params {
  case $::osfamily {
    'Debian': {
      $target_dir      = '/usr/local/bin'
      $composer_file   = 'composer'
      $download_method = 'curl'
      $logoutput       = false
      $tmp_path        = '/home/vagrant'
      $php_package     = 'php5-cli'
    }
    'RedHat': {
    	$target_dir = '/usr/bin'
    	$composer_file = 'composer'
    	$download_method = 'curl'
    	$logoutput = false
    	$tmp_path = '/tmp'
    	$php_package = 'php'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
