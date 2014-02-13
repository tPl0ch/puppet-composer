v1.1.1
======
17b2309 (tag: 1.1.1) Update Modulefile
5725de6 Merge pull request #23 from ghola/master
d848038 Used puppetlabs/git >= 0.0.2
6eade18 Merge pull request #19 from tPl0ch/build_version_1.1.0
0d75cff doc updates for 1.1.0 release

v1.1.0
======
3b46e4d (tag: 1.1.0) bumping version to 1.1.0 for refreshonly and user features
ac8aab9 Merge pull request #4 from tPl0ch/exec_user
5290e8e support setting exec user for project and exec
6af1e25 ignore puppet module package folder
b240e04 Merge pull request #18 from jjtorroglosa/master
c2106ec Add refreshonly parameter to exec

v1.0.1
======
fb1fd04 (tag: 1.0.1) Bumped version to 1.0.1
bd8e9af Merge pull request #17 from tPl0ch/deprecated_erb_variables
bf43913 (origin/deprecated_erb_variables) fix deprecated variables in the exec erb template
7778c4c Merge pull request #16 from tPl0ch/documentation_refactor
342b898 (origin/documentation_refactor) document refactor, add spec test information
3677acc adding tests for new suhosin_enable param and Debian family
af1e87b Merge pull request #15 from puphpet/master
de86c0d Only run augeas commands if suhosin is enabled

v1.0.0
======
f5d214a (tag: 1.0.0) Bumping version to 1.0.0
0b62ea2 Merge pull request #13 from andyshinn/rspec_tests
8ee1b08 Merge pull request #12 from andyshinn/set_composer_home
12589bf fixes for travis-ci building
5279b92 spec testing using rspec-puppet
3069608 documentation updates for composer_home and previous PRs
b5faa45 add a composer_home fact and use it to set up environment

v0.1.1
======
a3c173e (tag: 0.1.1) Merge branch 'master' of github.com:tPl0ch/puppet-composer
dbc0c74 Bumping version to 0.1.1
0d2123a Merge pull request #11 from andyshinn/refactor_download_method
fa751fe Merge pull request #10 from andyshinn/no_custom_installers
b4833d6 no-custom-installers is deprecated in favor of no-plugins
acdc73c dry up the composer binary download code
879909d Merge pull request #9 from andyshinn/update_rhel_php_package
41f3a7b CentOS isn't actually an $::osfamily value
d54c0db PHP binary is provided by php-cli on RHEL systems

v0.1.0
======
1e8f9f1 (tag: 0.1.0) Adding License file.
37d269e Fixing merge conflicts after CentOS support merge.
5d20d57 Resolving merge conflict after adding CentOS support.
82b7c8a Merge pull request #3 from ajohnstone/support-redhat-centos
523c28f (igalic/option-names, igalic-option-names) update readme with the new options
3d2ddda double-negating option names is confusing
be518cf (igalic/style, igalic-style) Fix puppet lint complaints
4050077 There's no need for these files to be executable
e14900d (igalic/master) Merge pull request #5 from Nyholm/master
522e93c Updated temp path.
bf0f9e7 Support centos/redhat
f45e9de Support redhat/centos
920d1ca Support redhat/centos

v0.0.6
======
78643ef (tag: 0.0.6) Bumping version to 0.0.6
0fbfb53 Fixing bug where global path is overwritten by local scope.

v0.0.5
======
ee4e49b (tag: 0.0.5) Bumping version to 0.0.5
17ca5ee Added varaible composer path to exec calls.

v0.0.4
======
e94be5e (tag: 0.0.4) Bumping version to 0.0.4
a27e45f Fixed dry_run parameter
28cfee8 Adding version parameter to project task README
4787b24 Bumping version to 0.0.3

v0.0.3
======
4ee9547 (tag: 0.0.3) Fixing type in exec manifest.

v0.0.2
======
974d2ad (tag: 0.0.2) Bumping version to 0.0.2
667eb18 Fixed README
925aa97 Fixed Modulefile.

v0.0.1
======
9f10cea (tag: 0.0.1) Fixing minor installation instructions in README
6618579 Removed parametrized suhosin handling. Fixed README.
826d3c4 Initial commit.
