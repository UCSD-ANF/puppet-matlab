require 'spec_helper'

describe 'matlab::links', :type=>'class' do
  it { should contain_file('/usr/local/bin/matlab').with_ensure('link')\
    .with_target('/opt/shared/matlab/bin/matlab') }

  it { should contain_file('/usr/local/bin/mcc').with_ensure('link')\
    .with_target('/opt/shared/matlab/bin/matlab') }

  it { should contain_file('/usr/local/bin/mex').with_ensure('link')\
    .with_target('/opt/shared/matlab/bin/matlab') }

  it { should contain_file('/usr/local/bin/mbuild').with_ensure('link')\
    .with_target('/opt/shared/matlab/bin/matlab') }

  context 'with basic params' do
    let(:params) { {
      :install_basedir => "/opt/test/matlab",
      :link_basedir => "/opt/local",
    } }

    it { should contain_file('/opt/local/bin/matlab').with_ensure('link')\
      .with_target('/opt/test/matlab/bin/matlab') }
  end

  context 'with ensure == absent' do
    let(:params) { {
      :ensure => 'absent',
    } }

    it { should contain_file('/usr/local/bin/matlab').with_ensure('absent') }
  end
end
