require 'spec_helper'

describe 'matlab', type: 'class' do
  context 'with defaults' do
    it { is_expected.to contain_class('matlab::links') }
    it { is_expected.not_to contain_matlab__license('matlab license') }
  end

  context 'with a license file' do
    let(:params) do
      {
        license_source: 'puppet:///matlab/network.lic',
      }
    end

    it {
      is_expected.to contain_matlab__license('default').with_source(
      'puppet:///matlab/network.lic',
    )
    }
  end
end
