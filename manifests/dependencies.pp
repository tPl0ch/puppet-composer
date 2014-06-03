# == Class: composer
#
# The dependencies for running composer properly.
#
# === Parameters
#
# Document parameters here.
#
# [*download_method*]
#   Either ```curl``` or ```wget```.
#
# [*method_package*]
#   Specific ```curl``` or ```wget``` Package.
#
# [*php_package*]
#   The Package name of tht PHP CLI package.
#
# [*suhosin_enabled*]
#   If true augeas dependencies are added.
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
class composer::dependencies(
  $download_method = $composer::params::download_method,
  $method_package  = $composer::params::method_package,
  $php_package     = $composer::params::php_package,
  $suhosin_enabled = $composer::params::suhosin_enabled
) inherits composer::params {

  include stdlib
  
  # Define PHP Package if needed.
  unless empty($php_package) {
	  if ! defined(Package[$php_package]) {
	    package { $php_package: ensure => present, }
	  }
  }

  # Using default "Curl" or "Wget" packages for downloading Composer.
  if ! defined(Package[$download_method]) {
    package { $download_method: ensure => present, }
  }

  # Using specific "Curl" of "Wget" packages for downloaing Composer.
  if ! defined(Package[$method_package]) {
    package { $method_package: ensure => present, }
  }

  if $suhosin_enabled == true {
    case $family {

      'Redhat','Centos': {

        # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
        augeas { 'whitelist_phar':
          context     => '/files/etc/suhosin.ini/suhosin',
          changes     => 'set suhosin.executor.include.whitelist phar',
          require     => Package[$php_package],
        }

        # set /etc/cli/php.ini/PHP/allow_url_fopen = On
        augeas{ 'allow_url_fopen':
          context     => '/files/etc/php.ini/PHP',
          changes     => 'set allow_url_fopen On',
          require     => Package[$php_package],
        }
      }

     'Debian': {

        # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
        augeas { 'whitelist_phar':
          context     => '/files/etc/php5/conf.d/suhosin.ini/suhosin',
          changes     => 'set suhosin.executor.include.whitelist phar',
          require     => Package[$php_package],
        }

        # set /etc/php5/cli/php.ini/PHP/allow_url_fopen = On
        augeas { 'allow_url_fopen':
          context     => '/files/etc/php5/cli/php.ini/PHP',
          changes     => 'set allow_url_fopen On',
          require     => Package[$php_package],
        }
      }
    }
  }
}
