# == Type: composer::project
#
# Installs a given project with composer create-project
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
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
define composer::project(
  $project_name,
  $target_dir,
  $version        = 'UNSET',
  $dev            = false,
  $prefer_source  = false,
  $stability      = 'dev',
  $repository_url = 'UNSET',
  $keep_vcs       = false,
  $tries          = 3,
  $timeout        = 1200
) {
  require git
  require composer

  Exec { path => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}" }

  $exec_name    = "composer_create_project_${title}"
  $base_command = "php ${composer::target_dir}/${composer::composer_file} --stability=${stability}"
  $end_command  = "${project_name} ${target_dir}"

  if $dev {
    $dev_arg = " --dev"
  } else {
    $dev_arg = ""
  }

  if $keep_vcs {
    $vcs = " --keep-vcs"
  } else {
    $vcs = ""
  }

  if $repository_url != 'UNSET' {
    $repo = " --repository-url=${repository_url}"
  } else {
    $repo = ""
  }

  if $prefer_source {
    $pref_src = " --prefer-source"
  } else {
    $pref_src = ""
  }

  if $version != 'UNSET' {
    $v = " ${version}"
  } else {
    $v = ""
  }

  exec { $exec_name:
    command => "${base_command}${dev_arg}${repo}${pref_src}${vcs} create-project ${end_command}${v}",
    tries   => $tries,
    timeout => $timeout,
    unless  => "test -d ${target_dir}",
  }
}
