require 'spec_helper'

describe 'composer::params' do
  ['RedHat', 'Debian'].each do |osfamily|
    context "on #{osfamily} operating system family" do
      let(:facts) { {
        :osfamily => osfamily,
      } }

      it { should compile }
    end
  end
end
