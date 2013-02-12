# == Class: composer
#
# The parameters for the composer class and corresponding definitions
#
# === Parameters
#
# Document parameters here.
#
# [*target_dir*]
#   The target dir that composer should be installed to.
#   Defaults to ```/usr/local/bin```.
#
# [*composer_file*]
#   The name of the composer binary, which will reside in ```target_dir```.
#
# [*download_method*]
#   Either ```curl``` or ```wget```.
#
# [*logoutput*]
#   If the output should be logged. Defaults to FALSE.
#
# [*tmp_path*]
#   Where the composer.phar file should be temporarily put.
#
# [*php_package*]
#   The Package name of tht PHP CLI package.
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
class composer(
  $target_dir      = $composer::params::target_dir,
  $composer_file   = $composer::params::composer_file,
  $download_method = $composer::params::download_method,
  $logoutput       = $composer::params::logoutput,
  $tmp_path        = $composer::params::tmp_path,
  $php_package     = $composer::params::php_package
) inherits composer::params {

  if defined(Package[$php_package]) == false {
    package { $php_package: ensure => present, }
  }

  # download composer
  if $download_method == 'curl' {

    if defined(Package['curl']) == false {
      package { 'curl': ensure => present, }
    }

    exec { 'download_composer':
      command     => 'curl -s http://getcomposer.org/installer | php',
      cwd         => $tmp_path,
      require     => [
        Package['curl', $php_package],
        Augeas['allow_url_fopen', 'whitelist_phar'],
      ],
      creates     => "$tmp_path/composer.phar",
      logoutput   => $logoutput,
      path        => [ $target_dir ],
    }
  }
  elsif $download_method == 'wget' {

    if defined(Package['wget']) == false {
      package {'wget': ensure => present, }
    }

    exec { 'download_composer':
      command     => 'wget http://getcomposer.org/composer.phar -O composer.phar',
      cwd         => $tmp_path,
      require     => [
        Package['wget'],
        Augeas['allow_url_fopen', 'whitelist_phar'],
      ],
      creates     => "$tmp_path/composer.phar",
      logoutput   => $logoutput,
      path        => [ $target_dir ],
    }
  }
  else {
    fail("The param download_method $download_method is not valid. Please set download_method to curl or wget.")
  }

  # check if directory exists
  file { $target_dir:
    ensure      => directory,
  }

  # move file to target_dir
  file { "$target_dir/$composer_file":
    ensure      => present,
    source      => "$tmp_path/composer.phar",
    require     => [ Exec['download_composer'], File[$target_dir], ],
    group       => 'staff',
    mode        => '0755',
  }

  # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
  augeas { 'whitelist_phar':
    context     => '/files/etc/php5/conf.d/suhosin.ini/suhosin',
    changes     => 'set suhosin.executor.include.whitelist phar',
    require     => Package[$php_package],
  }

  # set /etc/php5/cli/php.ini/PHP/allow_url_fopen = On
  augeas{ 'allow_url_fopen':
    context     => '/files/etc/php5/cli/php.ini/PHP',
    changes     => 'set allow_url_fopen On',
    require     => Package[$php_package],
  }
}
