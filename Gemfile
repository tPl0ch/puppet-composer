#ruby=1.9.3@puppet-composer

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

source 'https://rubygems.org'

gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper'
gem 'rspec-puppet', :github => 'doc75/rspec-puppet', :branch => 'update-to-rspec3'
gem 'rspec', '~> 3.0'
gem 'mocha'
gem 'puppet-lint'
gem 'hiera'
gem 'hiera-puppet'
