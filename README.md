# Puppet module to install composer

[![Build Status](https://travis-ci.org/tPl0ch/puppet-composer.png?branch=master)](https://travis-ci.org/tPl0ch/puppet-composer)

## Description

install php composer - from http://getcomposer.org/ with puppet-composer module

## Installation

#### Installation via puppet forge (RECOMMENDED, automatically installs all dependencies)

    puppet module install --target-dir=/your/path/to/modules tPl0ch-composer

#### Installation via git submodule

    git submodule add git://github.com/tPl0ch/puppet-composer.git modules/composer

## Dependencies

This module requires the module ```puppetlabs/git```

## Usage

#### Simple include just installs with defaults

In your manifest.pp:

    include composer

#### Configuring the composer install

This example includes all available class parameters. In your manifest.pp:

```puppet
    # configure composer install - not nessecary, comes with sane defaults
    class { 'composer':
        target_dir      => '/usr/local/bin',
        composer_file   => 'composer', # could also be 'composer.phar'
        download_method => 'curl',     # or 'wget'
        logoutput       => false,
        tmp_path        => '/tmp',
        php_package     => 'php5-cli',
        curl_package    => 'curl',
        wget_package    => 'wget',
        composer_home   => '/root',
    }
```

#### Creating a project

In your manifest.pp:

```puppet
    # create a project
    composer::project { 'silex':
        project_name   => 'fabpot/silex-skeleton',  # REQUIRED
        target_dir     => '/vagrant/silex', # REQUIRED
        version        => '2.1.x-dev', # Some valid version string
        prefer_source  => true,
        stability      => 'dev', # Minimum stability setting
        keep_vcs       => false, # Keep the VCS information
        dev            => true, # Install dev dependencies
        repository_url => 'http://repo.example.com' # Custom repository URL
    }
```

#### Updating a project / Updating package(s)

In your manifest.pp:

```puppet
    # update a project
    composer::exec { 'silex-update':
        cmd                  => 'update',  # REQUIRED
        cwd                  => '/vagrant/silex', # REQUIRED
        packages             => ['silex/silex', 'symfony/browser-kit'], # leave empty or omit to update whole project
        prefer_source        => false, # Only one of prefer_source or prefer_dist can be true
        prefer_dist          => false, # Only one of prefer_source or prefer_dist can be true
        dry_run              => false, # Just simulate actions
        custom_installers    => false, # No custom installers
        scripts              => false, # No script execution
        interaction          => false, # No interactive questions
        optimize             => false, # Optimize autoloader
        dev                  => false, # Install dev dependencies
    }
```

#### Installing a project

In your manifest.pp:

```puppet
    # install a project - packages variable is ignored with 'install' cmd
    composer::exec { 'silex-install':
        cmd                  => 'install',  # REQUIRED
        cwd                  => '/vagrant/silex', # REQUIRED
        prefer_source        => false,
        prefer_dist          => false,
        dry_run              => false, # Just simulate actions
        custom_installers    => false, # No custom installers
        scripts              => false, # No script execution
        interaction          => false, # No interactive questions
        optimize             => false, # Optimize autoloader
        dev                  => false, # Install dev dependencies
    }
```

## TODO

- Add type 'composer::require'
- Add rspec test cases
