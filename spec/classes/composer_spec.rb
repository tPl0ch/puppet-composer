require 'spec_helper'

describe 'composer' do
  context 'on RedHat operating system family' do
    let(:facts) { {
        :osfamily => 'RedHat',
    } }

    it { should include_class('composer::params') }

    it {
      should contain_exec('download_composer').with({
        :command     => 'curl -s http://getcomposer.org/installer | php',
        :cwd         => '/tmp',
        :creates     => '/tmp/composer.phar',
        :logoutput   => false,
      })
    }

    it {
      should contain_augeas('whitelist_phar').with({
        :context     => '/files/etc/suhosin.ini/suhosin',
        :changes     => 'set suhosin.executor.include.whitelist phar',
      })
    }

    it {
      should contain_augeas('allow_url_fopen').with({
        :context    => '/files/etc/php.ini/PHP',
        :changes    => 'set allow_url_fopen On',
      })
    }

    context 'with default parameters' do
      it 'should compile' do
        catalogue
      end

      it { should contain_package('php-cli').with_ensure('present') }
      it { should contain_package('curl').with_ensure('present') }
      it { should contain_file('/usr/local/bin').with_ensure('directory') }

      it {
        should contain_file('/usr/local/bin/composer').with({
          :source => 'present',
          :source => '/tmp/composer.phar',
          :mode   => '0755',
        })
      }
    end

    context 'with custom parameters' do
      let(:params) { {
        :target_dir    => '/you_sir/lowcal/been',
        :php_package   => 'php8-cli',
        :composer_file => 'compozah',
        :curl_package  => 'kerl',
      } }

      it 'should compile' do
        catalogue
      end

      it { should contain_package('php8-cli').with_ensure('present') }
      it { should contain_package('kerl').with_ensure('present') }
      it { should contain_file('/you_sir/lowcal/been').with_ensure('directory') }

      it {
        should contain_file('/you_sir/lowcal/been/compozah').with({
          :source => 'present',
          :source => '/tmp/composer.phar',
          :mode   => '0755',
        })
      }
    end
  end
end
