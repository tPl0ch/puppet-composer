require 'spec_helper'

describe 'composer::exec' do
  ['RedHat', 'Debian'].each do |osfamily|
    context "on #{osfamily} operating system family" do
      let(:facts) { {
          :osfamily => osfamily,
      } }

      context 'using install command' do
        it { should include_class('git') }
        it { should include_class('composer') }

        let(:title) { 'myproject' }
        let(:params) { {
          :cmd => 'install',
          :cwd => '/my/awesome/project',
        } }

        it {
          should contain_exec('composer_update_myproject').with({
            :command       => %r{php /usr/local/bin/composer install --no-plugins --no-scripts --no-interaction},
            :cwd       => '/my/awesome/project',
            :logoutput => false,
          })
        }
      end

      context 'using update command' do
        it { should include_class('git') }
        it { should include_class('composer') }

        let(:title) { 'yourpr0ject' }
        let(:params) { {
          :cmd       => 'update',
          :cwd       => '/just/in/time',
          :packages  => ['package1', 'packageinf'],
          :logoutput => true,
        } }

        it {
          should contain_exec('composer_update_yourpr0ject').with({
            :command   => %r{php /usr/local/bin/composer update --no-plugins --no-scripts --no-interaction             package1             packageinf},
            :cwd       => '/just/in/time',
            :logoutput => true,
          })
        }
      end
    end
  end

  context 'on unsupported operating system family' do
    let(:facts) { {
      :osfamily => 'Darwin',
    } }

    let(:title) { 'someproject' }

    it do
      expect { catalogue }.to raise_error(Puppet::Error, /Unsupported platform: Darwin/)
    end
  end
end
