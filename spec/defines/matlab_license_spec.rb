require 'spec_helper'

describe 'matlab::license', :type=>'define' do
  let(:title) { 'R2012b' }
  let(:params) { {
    :source => 'puppet:///matlab/license/network.lic',
  } }

  it { should contain_file('Matlab License R2012b').with_path(
    '/opt/shared/matlab/licenses/network.lic')
  }

  context 'with type = network' do
    let(:params) { {
      :source => 'puppet:///matlab/license/network.lic',
      :type => 'network',
    } }

    it { should contain_file('Matlab License R2012b').with_path(
      '/opt/shared/matlab/licenses/network.lic')
    }
  end
  context 'with type = license.dat' do
    let(:title) { 'R2006b' }
    let(:params) { {
      :source => 'puppet:///matlab/license/network.lic',
      :type => 'license.dat',
    } }

    it { should contain_file('Matlab License R2006b').with_path(
      '/opt/shared/matlab/etc/license.dat')
    }
  end
end
