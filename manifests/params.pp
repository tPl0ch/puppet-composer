# == Class: composer::params
#
# The parameters for the composer class and corresponding definitions
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
# Andrew Johnstone <andrew@ajohnstone.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
class composer::params {
  $composer_home = $::composer_home

  case $::osfamily {
    'Debian': {
      $target_dir      = '/usr/local/bin'
      $composer_file   = 'composer'
      $download_method = 'curl'
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = 'php5-cli'
      $curl_package    = 'curl'
      $wget_package    = 'wget'
    }
    'RedHat': {
      $target_dir      = '/usr/local/bin'
      $composer_file   = 'composer'
      $download_method = 'curl'
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = 'php-cli'
      $curl_package    = 'curl'
      $wget_package    = 'wget'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
