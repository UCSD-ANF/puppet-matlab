require 'spec_helper'

describe 'matlab::license', :type=>'define' do
  let(:title) { 'R2012b' }
  let(:params) { {
    :install_dir => "/opt/shared/matlab",
    :file => "puppet:///matlab/license/network.lic",
  } }

  it { should contain_file("Matlab License R2012b").with_path(
    "/opt/shared/matlab/licenses/network.lic") }
end
