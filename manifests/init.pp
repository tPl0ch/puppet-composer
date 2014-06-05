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
# [*method_package*]
#   Specific ```curl``` or ```wget``` Package.
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
# [*composer_home*]
#   Folder to use as the COMPOSER_HOME environment variable. Default comes
#   from our composer::params class which derives from our own $composer_home
#   fact. The fact returns the current users $HOME environment variable.
#
# [*php_bin*]
#   The name or path of the php binary to override the default set in the
#   composer::params class.
#
# [*suhosin_enabled*]
#   If true augeas dependencies are added.
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
class composer(
  $target_dir      = $composer::params::target_dir,
  $composer_file   = $composer::params::composer_file,
  $download_method = $composer::params::download_method,
  $method_package  = $composer::params::method_package,
  $curl_package    = $composer::params::method_package,
  $wget_package    = $composer::params::method_package,
  $logoutput       = $composer::params::logoutput,
  $tmp_path        = $composer::params::tmp_path,
  $php_package     = $composer::params::php_package,
  $composer_home   = $composer::params::composer_home,
  $php_bin         = $composer::params::php_bin,
  $suhosin_enabled = $composer::params::suhosin_enabled,
  $projects        = hiera_hash('composer::projects', {}),
) inherits composer::params {

	if $curl_package {
	  $method_package = $curl_package
	  warning('The $curl_package parameter is deprecated. Please update to $method_package')
	}

  if $wget_package {
	  $method_package = $wget_package
	  warning('The $wget_package parameter is deprecated. Please update to $method_package')
	}

  case $download_method {
    'curl': {
      $download_command = "curl -s http://getcomposer.org/installer | ${composer::php_bin}"
    }
    'wget': {
      $download_command = 'wget http://getcomposer.org/composer.phar -O composer.phar'
    }
    default: {
      fail("The param download_method ${download_method} is not valid. Please set download_method to curl or wget.")
    }
  }

  # download composer once we have all requirements for
  # it working properly.
  class { 'composer::dependencies': 
      download_method => $composer::download_method,
      method_package  => $composer::method_package,
		  php_package     => $composer::php_package,
		  suhosin_enabled => $composer::suhosin_enabled,
  }
  ->
  exec { 'download_composer':
    command   => $download_command,
    cwd       => $tmp_path,
    creates   => "${tmp_path}/composer.phar",
    logoutput => $logoutput,
    path      => "/bin:/usr/bin/:/sbin:/usr/sbin:${target_dir}",
  }

  # check if directory exists
  file { $target_dir:
    ensure => directory,
  }

  # move file to target_dir
  file { "${target_dir}/${composer_file}":
    ensure  => present,
    source  => "${tmp_path}/composer.phar",
    require => [ Exec['download_composer'], File[$target_dir] ],
    mode    => 0755,
  }

  if $projects {
    class {'composer::project_factory' :
      projects => $projects,
    }
  }
}
