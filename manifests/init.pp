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

  Exec { path => "/bin:/usr/bin/:/sbin:/usr/sbin:$target_dir" }

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
      ],
      creates     => "$tmp_path/composer.phar",
      logoutput   => $logoutput,
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
    group       => 'root',
    mode        => '0755',
  }
}
