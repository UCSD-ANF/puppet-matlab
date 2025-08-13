require 'spec_helper'

describe 'matlab', type: 'class' do
  let(:pre_condition) { '' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('matlab') }
        it { is_expected.to contain_class('matlab::links').with_install_basedir('/opt/shared/matlab').with_link_basedir('/usr/local') }
        it { is_expected.not_to contain_matlab__license('default') }

        it 'uses Hiera defaults correctly' do
          # Verify that Hiera data binding works for default values
          is_expected.to contain_class('matlab::links').with(
            'install_basedir' => '/opt/shared/matlab',
            'link_basedir'    => '/usr/local'
          )
        end
      end

      context 'with links parameter' do
        context 'when links is true' do
          let(:params) { { links: true } }

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links') }
        end

        context 'when links is false' do
          let(:params) { { links: false } }

          it { is_expected.to compile }
          it { is_expected.not_to contain_class('matlab::links') }
        end

        context 'with invalid boolean value' do
          let(:params) { { links: 'invalid' } }

          it { is_expected.to compile.and_raise_error(/expects a Boolean value, got String/) }
        end
      end

      context 'with install_basedir parameter' do
        context 'with valid absolute path' do
          let(:params) { { install_basedir: '/custom/matlab/path' } }

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links').with_install_basedir('/custom/matlab/path') }
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
      end

      context 'with link_basedir parameter' do
        context 'with valid absolute path' do
          let(:params) { { link_basedir: '/usr/bin' } }

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links').with_link_basedir('/usr/bin') }
        end

        context 'with relative path' do
          let(:params) { { link_basedir: 'usr/bin' } }

          it { is_expected.to compile.and_raise_error(/expects a Stdlib::Absolutepath/) }
        end

        context 'with invalid path format' do
          let(:params) { { link_basedir: '/invalid path with spaces' } }

          it { is_expected.to compile }
        end
      end

      context 'with license_source parameter' do
        context 'with valid puppet:// URI' do
          let(:params) { { license_source: 'puppet:///matlab/network.lic' } }

          it { is_expected.to compile }
          it { is_expected.to contain_matlab__license('default').with_source('puppet:///matlab/network.lic') }
          it { is_expected.to contain_matlab__license('default').with_type('network') }
          it { is_expected.to contain_matlab__license('default').with_install_basedir('/opt/shared/matlab') }
        end

        context 'with valid file:// URI' do
          let(:params) { { license_source: 'file:///tmp/matlab.lic' } }

          it { is_expected.to compile }
          it { is_expected.to contain_matlab__license('default').with_source('file:///tmp/matlab.lic') }
        end

        context 'with local file path' do
          let(:params) { { license_source: '/etc/matlab/license.dat' } }

          it { is_expected.to compile }
          it { is_expected.to contain_matlab__license('default').with_source('/etc/matlab/license.dat') }
        end

        context 'when undef (default)' do
          let(:params) { {} }  # Don't specify license_source, let it default to undef

          it { is_expected.to compile }
          it { is_expected.not_to contain_matlab__license('default') }
        end

        context 'with empty string' do
          let(:params) { { license_source: '' } }

          it { is_expected.to compile }
          it { is_expected.not_to contain_matlab__license('default') }
        end

        context 'with non-string value' do
          let(:params) { { license_source: 123 } }

          it { is_expected.to compile.and_raise_error(/expects a value of type Undef or String/) }
        end
      end

      context 'with license_type parameter' do
        context 'with network type' do
          let(:params) do
            {
              license_source: 'puppet:///matlab/network.lic',
              license_type: 'network'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_matlab__license('default').with_type('network') }
        end

        context 'with license.dat type' do
          let(:params) do
            {
              license_source: 'puppet:///matlab/license.dat',
              license_type: 'license.dat'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_matlab__license('default').with_type('license.dat') }
        end

        context 'with invalid license type' do
          let(:params) do
            {
              license_source: 'puppet:///matlab/license.lic',
              license_type: 'invalid'
            }
          end

          it { is_expected.to compile.and_raise_error(/expects a match for Enum\['license\.dat', 'network'\]/) }
        end

        context 'with non-string value' do
          let(:params) do
            {
              license_source: 'puppet:///matlab/license.lic',
              license_type: 123
            }
          end

          it { is_expected.to compile.and_raise_error(/expects a match for Enum\['license\.dat', 'network'\]/) }
        end
      end

      context 'with combined parameters' do
        context 'with all parameters specified' do
          let(:params) do
            {
              links: true,
              install_basedir: '/custom/matlab',
              link_basedir: '/usr/bin',
              license_source: 'puppet:///matlab/network.lic',
              license_type: 'network'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links').with_install_basedir('/custom/matlab').with_link_basedir('/usr/bin') }
          it { is_expected.to contain_matlab__license('default').with_source('puppet:///matlab/network.lic').with_type('network').with_install_basedir('/custom/matlab') }
        end

        context 'with links disabled and license provided' do
          let(:params) do
            {
              links: false,
              license_source: 'puppet:///matlab/license.dat',
              license_type: 'license.dat'
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_class('matlab::links') }
          it { is_expected.to contain_matlab__license('default').with_source('puppet:///matlab/license.dat').with_type('license.dat') }
        end

        context 'with links enabled but no license' do
          let(:params) do
            {
              links: true,
              install_basedir: '/opt/matlab/R2023b',
              link_basedir: '/usr/local'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links').with_install_basedir('/opt/matlab/R2023b') }
          it { is_expected.not_to contain_matlab__license('default') }
        end

        context 'with minimal configuration' do
          let(:params) do
            {
              links: false
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_class('matlab::links') }
          it { is_expected.not_to contain_matlab__license('default') }
        end
      end

      context 'edge cases and validation' do
        context 'with Windows-style paths on Unix' do
          let(:params) { { install_basedir: 'C:\\Program Files\\MATLAB' } }

          it { is_expected.to compile }
          # Note: Stdlib::Absolutepath may accept Windows paths on Unix systems
        end

        context 'with path containing special characters' do
          let(:params) { { install_basedir: '/opt/matlab-r2023b_update1' } }

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links').with_install_basedir('/opt/matlab-r2023b_update1') }
        end

        context 'with very long paths' do
          let(:long_path) { '/very/long/path/that/exceeds/normal/length/limits/for/testing/purposes/matlab/installation' }
          let(:params) { { install_basedir: long_path } }

          it { is_expected.to compile }
          it { is_expected.to contain_class('matlab::links').with_install_basedir(long_path) }
        end
      end

      context 'resource relationships and dependencies' do
        let(:params) do
          {
            links: true,
            license_source: 'puppet:///matlab/network.lic',
            license_type: 'network',
            install_basedir: '/opt/matlab',
            link_basedir: '/usr/local'
          }
        end

        it 'passes correct parameters to matlab::links' do
          is_expected.to contain_class('matlab::links').with(
            'install_basedir' => '/opt/matlab',
            'link_basedir'    => '/usr/local'
          )
        end

        it 'passes correct parameters to matlab::license' do
          is_expected.to contain_matlab__license('default').with(
            'source'          => 'puppet:///matlab/network.lic',
            'install_basedir' => '/opt/matlab',
            'type'            => 'network'
          )
        end

        it 'creates both resources when both are needed' do
          is_expected.to contain_class('matlab::links')
          is_expected.to contain_matlab__license('default')
        end
      end

      context 'Hiera data binding verification' do
        context 'when no parameters are overridden' do
          let(:params) { {} }

          it 'uses default values from Hiera' do
            # These values should come from data/common.yaml
            is_expected.to contain_class('matlab::links').with(
              'install_basedir' => '/opt/shared/matlab',
              'link_basedir'    => '/usr/local'
            )
          end
        end

        context 'when some parameters are overridden' do
          let(:params) { { install_basedir: '/custom/path' } }

          it 'uses overridden values and Hiera defaults for others' do
            is_expected.to contain_class('matlab::links').with(
              'install_basedir' => '/custom/path',
              'link_basedir'    => '/usr/local'  # Should still use Hiera default
            )
          end
        end
      end
    end
  end
end
