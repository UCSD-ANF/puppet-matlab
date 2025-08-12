require 'spec_helper'

describe 'matlab::links', type: 'class' do
  it {
    is_expected.to contain_file('/usr/local/bin/matlab').with_ensure('link')\
                                                        .with_target('/opt/shared/matlab/bin/matlab')
  }

  it {
    is_expected.to contain_file('/usr/local/bin/mcc').with_ensure('link')\
                                                     .with_target('/opt/shared/matlab/bin/mcc')
  }

  it {
    is_expected.to contain_file('/usr/local/bin/mex').with_ensure('link')\
                                                     .with_target('/opt/shared/matlab/bin/mex')
  }

  it {
    is_expected.to contain_file('/usr/local/bin/mbuild').with_ensure('link')\
                                                        .with_target('/opt/shared/matlab/bin/mbuild')
  }

  context 'with basic params' do
    let(:params) do
      {
        install_basedir: '/opt/test/matlab',
      link_basedir: '/opt/local',
      }
    end

    it {
      is_expected.to contain_file('/opt/local/bin/matlab').with_ensure('link')\
                                                          .with_target('/opt/test/matlab/bin/matlab')
    }
  end

  context 'with ensure == absent' do
    let(:params) do
      {
        ensure: 'absent',
      }
    end

    it { is_expected.to contain_file('/usr/local/bin/matlab').with_ensure('absent') }
  end
end
