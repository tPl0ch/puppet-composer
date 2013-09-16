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
  case $::osfamily {
    'Redhat','Centos','Debian': {
      $target_dir      = '/usr/local/bin'
      $composer_file   = 'composer'
      $download_method = 'curl'
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = 'php5-cli'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
