require 'spec_helper'

describe 'matlab::links', type: 'class' do
  let(:pre_condition) { '' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('matlab::links') }

        # Test all four executables with defaults
        it { is_expected.to contain_file('/usr/local/bin/matlab').with_ensure('link').with_target('/opt/shared/matlab/bin/matlab') }
        it { is_expected.to contain_file('/usr/local/bin/mcc').with_ensure('link').with_target('/opt/shared/matlab/bin/mcc') }
        it { is_expected.to contain_file('/usr/local/bin/mex').with_ensure('link').with_target('/opt/shared/matlab/bin/mex') }
        it { is_expected.to contain_file('/usr/local/bin/mbuild').with_ensure('link').with_target('/opt/shared/matlab/bin/mbuild') }

        it 'creates exactly 4 file resources' do
          is_expected.to have_file_resource_count(4)
        end
      end

      context 'with install_basedir parameter' do
        context 'with valid absolute path' do
          let(:params) { { install_basedir: '/custom/matlab/path' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_target('/custom/matlab/path/bin/matlab') }
          it { is_expected.to contain_file('/usr/local/bin/mcc').with_target('/custom/matlab/path/bin/mcc') }
          it { is_expected.to contain_file('/usr/local/bin/mex').with_target('/custom/matlab/path/bin/mex') }
          it { is_expected.to contain_file('/usr/local/bin/mbuild').with_target('/custom/matlab/path/bin/mbuild') }
        end

        context 'with path containing special characters' do
          let(:params) { { install_basedir: '/opt/matlab-r2023b_update1' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_target('/opt/matlab-r2023b_update1/bin/matlab') }
        end

        context 'with very long path' do
          let(:long_path) { '/very/long/path/to/matlab/installation/directory/for/testing/purposes' }
          let(:params) { { install_basedir: long_path } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_target("#{long_path}/bin/matlab") }
        end

        context 'with relative path' do
          let(:params) { { install_basedir: 'relative/path' } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end

        context 'with empty string' do
          let(:params) { { install_basedir: '' } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end

        context 'with non-string value' do
          let(:params) { { install_basedir: 123 } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end

        context 'with Windows-style path on Unix' do
          let(:params) { { install_basedir: 'C:\\Program Files\\MATLAB' } }

          it { is_expected.to compile }
          # Note: Stdlib::Absolutepath may accept Windows paths on Unix systems
        end
      end

      context 'with link_basedir parameter' do
        context 'with valid absolute path' do
          let(:params) { { link_basedir: '/usr/bin' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/bin/bin/matlab').with_ensure('link').with_target('/opt/shared/matlab/bin/matlab') }
          it { is_expected.to contain_file('/usr/bin/bin/mcc').with_ensure('link').with_target('/opt/shared/matlab/bin/mcc') }
          it { is_expected.to contain_file('/usr/bin/bin/mex').with_ensure('link').with_target('/opt/shared/matlab/bin/mex') }
          it { is_expected.to contain_file('/usr/bin/bin/mbuild').with_ensure('link').with_target('/opt/shared/matlab/bin/mbuild') }
        end

        context 'with custom link base' do
          let(:params) { { link_basedir: '/opt/local' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/opt/local/bin/matlab').with_target('/opt/shared/matlab/bin/matlab') }
        end

        context 'with path containing spaces' do
          let(:params) { { link_basedir: '/usr/local with spaces' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local with spaces/bin/matlab').with_target('/opt/shared/matlab/bin/matlab') }
        end

        context 'with relative path' do
          let(:params) { { link_basedir: 'usr/local' } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end

        context 'with empty string' do
          let(:params) { { link_basedir: '' } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end

        context 'with non-string value' do
          let(:params) { { link_basedir: 456 } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end
      end

      context 'with ensure parameter' do
        context 'when ensure is present' do
          let(:params) { { ensure: 'present' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_ensure('link') }
          it { is_expected.to contain_file('/usr/local/bin/mcc').with_ensure('link') }
          it { is_expected.to contain_file('/usr/local/bin/mex').with_ensure('link') }
          it { is_expected.to contain_file('/usr/local/bin/mbuild').with_ensure('link') }

          it 'sets targets correctly for all executables' do
            is_expected.to contain_file('/usr/local/bin/matlab').with_target('/opt/shared/matlab/bin/matlab')
            is_expected.to contain_file('/usr/local/bin/mcc').with_target('/opt/shared/matlab/bin/mcc')
            is_expected.to contain_file('/usr/local/bin/mex').with_target('/opt/shared/matlab/bin/mex')
            is_expected.to contain_file('/usr/local/bin/mbuild').with_target('/opt/shared/matlab/bin/mbuild')
          end
        end

        context 'when ensure is absent' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_ensure('absent') }
          it { is_expected.to contain_file('/usr/local/bin/mcc').with_ensure('absent') }
          it { is_expected.to contain_file('/usr/local/bin/mex').with_ensure('absent') }
          it { is_expected.to contain_file('/usr/local/bin/mbuild').with_ensure('absent') }

          it 'still sets targets for all executables' do
            is_expected.to contain_file('/usr/local/bin/matlab').with_target('/opt/shared/matlab/bin/matlab')
            is_expected.to contain_file('/usr/local/bin/mcc').with_target('/opt/shared/matlab/bin/mcc')
            is_expected.to contain_file('/usr/local/bin/mex').with_target('/opt/shared/matlab/bin/mex')
            is_expected.to contain_file('/usr/local/bin/mbuild').with_target('/opt/shared/matlab/bin/mbuild')
          end
        end

        context 'with invalid ensure value' do
          let(:params) { { ensure: 'invalid' } }

          it { is_expected.to compile.and_raise_error(/expects a match for Enum\['absent', 'present'\]/) }
        end

        context 'with non-string ensure value' do
          let(:params) { { ensure: true } }

          it { is_expected.to compile.and_raise_error(/expects a match for Enum\['absent', 'present'\]/) }
        end

        context 'with numeric ensure value' do
          let(:params) { { ensure: 1 } }

          it { is_expected.to compile.and_raise_error(/expects a match for Enum\['absent', 'present'\]/) }
        end
      end

      context 'with combined parameters' do
        context 'with all parameters specified - present' do
          let(:params) do
            {
              install_basedir: '/opt/test/matlab',
              link_basedir: '/opt/local',
              ensure: 'present'
            }
          end

          it { is_expected.to compile }

          it 'creates all symlinks with correct paths' do
            is_expected.to contain_file('/opt/local/bin/matlab').with_ensure('link').with_target('/opt/test/matlab/bin/matlab')
            is_expected.to contain_file('/opt/local/bin/mcc').with_ensure('link').with_target('/opt/test/matlab/bin/mcc')
            is_expected.to contain_file('/opt/local/bin/mex').with_ensure('link').with_target('/opt/test/matlab/bin/mex')
            is_expected.to contain_file('/opt/local/bin/mbuild').with_ensure('link').with_target('/opt/test/matlab/bin/mbuild')
          end
        end

        context 'with all parameters specified - absent' do
          let(:params) do
            {
              install_basedir: '/opt/test/matlab',
              link_basedir: '/opt/local',
              ensure: 'absent'
            }
          end

          it { is_expected.to compile }

          it 'removes all symlinks with correct paths' do
            is_expected.to contain_file('/opt/local/bin/matlab').with_ensure('absent').with_target('/opt/test/matlab/bin/matlab')
            is_expected.to contain_file('/opt/local/bin/mcc').with_ensure('absent').with_target('/opt/test/matlab/bin/mcc')
            is_expected.to contain_file('/opt/local/bin/mex').with_ensure('absent').with_target('/opt/test/matlab/bin/mex')
            is_expected.to contain_file('/opt/local/bin/mbuild').with_ensure('absent').with_target('/opt/test/matlab/bin/mbuild')
          end
        end

        context 'with realistic MATLAB installation paths' do
          let(:params) do
            {
              install_basedir: '/opt/shared/matlab/R2023b',
              link_basedir: '/usr/local',
              ensure: 'present'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_target('/opt/shared/matlab/R2023b/bin/matlab') }
        end
      end

      context 'edge cases and validation' do
        context 'with path containing Unicode characters' do
          let(:params) { { install_basedir: '/opt/matlab/ñ-version' } }

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local/bin/matlab').with_target('/opt/matlab/ñ-version/bin/matlab') }
        end

        context 'with path containing dots and dashes' do
          let(:params) do
            {
              install_basedir: '/opt/matlab-v2023.2.1',
              link_basedir: '/usr/local.custom'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_file('/usr/local.custom/bin/matlab').with_target('/opt/matlab-v2023.2.1/bin/matlab') }
        end

        context 'with mixed case ensure value' do
          let(:params) { { ensure: 'Present' } }

          it { is_expected.to compile.and_raise_error(/expects a match for Enum\['absent', 'present'\]/) }
        end
      end

      context 'resource relationships and management' do
        let(:params) do
          {
            install_basedir: '/opt/matlab',
            link_basedir: '/usr/local',
            ensure: 'present'
          }
        end

        it 'creates exactly four file resources' do
          is_expected.to have_file_resource_count(4)
        end

        it 'creates resources with consistent properties' do
          %w[matlab mcc mex mbuild].each do |executable|
            is_expected.to contain_file("/usr/local/bin/#{executable}").with(
              'ensure' => 'link',
              'target' => "/opt/matlab/bin/#{executable}"
            )
          end
        end

        context 'when ensure is absent' do
          let(:params) do
            {
              install_basedir: '/opt/matlab',
              link_basedir: '/usr/local',
              ensure: 'absent'
            }
          end

          it 'removes all resources consistently' do
            %w[matlab mcc mex mbuild].each do |executable|
              is_expected.to contain_file("/usr/local/bin/#{executable}").with(
                'ensure' => 'absent',
                'target' => "/opt/matlab/bin/#{executable}"
              )
            end
          end
        end
      end

      context 'symlink target validation' do
        context 'with complex installation path' do
          let(:params) { { install_basedir: '/nfs/shared/apps/matlab/versions/R2023b_Update_5' } }

          it { is_expected.to compile }

          it 'constructs correct targets for all executables' do
            base_target = '/nfs/shared/apps/matlab/versions/R2023b_Update_5/bin'
            is_expected.to contain_file('/usr/local/bin/matlab').with_target("#{base_target}/matlab")
            is_expected.to contain_file('/usr/local/bin/mcc').with_target("#{base_target}/mcc")
            is_expected.to contain_file('/usr/local/bin/mex').with_target("#{base_target}/mex")
            is_expected.to contain_file('/usr/local/bin/mbuild').with_target("#{base_target}/mbuild")
          end
        end
      end

      context 'parameter defaults verification' do
        context 'when no parameters are provided' do
          let(:params) { {} }

          it 'uses correct default values' do
            # Defaults from manifests/links.pp
            is_expected.to contain_file('/usr/local/bin/matlab').with(
              'ensure' => 'link',
              'target' => '/opt/shared/matlab/bin/matlab'
            )
          end
        end

        context 'when only some parameters are overridden' do
          let(:params) { { ensure: 'absent' } }

          it 'uses defaults for unspecified parameters' do
            is_expected.to contain_file('/usr/local/bin/matlab').with(
              'ensure' => 'absent',
              'target' => '/opt/shared/matlab/bin/matlab'
            )
          end
        end
      end
    end
  end
end
