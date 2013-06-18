require 'spec_helper'

describe 'matlab', :type=>'class' do
  context 'with defaults' do
    it { should contain_class('matlab::links') }
    it { should_not contain_matlab__license('matlab license') }
  end

  context 'with a license file' do
    let(:params) { {
      :license_source => 'puppet:///matlab/network.lic',
    } }

    it { should contain_matlab__license('default').with_source(
      'puppet:///matlab/network.lic') }
  end
end
