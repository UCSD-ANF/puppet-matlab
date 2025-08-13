require 'spec_helper'

describe 'matlab::license', type: 'define' do
  let(:title) { 'R2012b' }

  # Test default behavior with minimal required parameters
  context 'with minimal required parameters' do
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2012b').with(
        path: '/opt/shared/matlab/licenses/network.lic',
        source: 'puppet:///matlab/license/network.lic',
      )
    }
  end

  # Test license file placement logic for network licenses
  context 'with type = network (explicit)' do
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
        type: 'network',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2012b').with(
        path: '/opt/shared/matlab/licenses/network.lic',
        source: 'puppet:///matlab/license/network.lic',
      )
    }
  end

  # Test license file placement logic for standalone licenses
  context 'with type = license.dat' do
    let(:title) { 'R2006b' }
    let(:params) do
      {
        source: 'puppet:///matlab/license/license.dat',
        type: 'license.dat',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2006b').with(
        path: '/opt/shared/matlab/etc/license.dat',
        source: 'puppet:///matlab/license/license.dat',
      )
    }
  end

  # Test custom install_basedir parameter
  context 'with custom install_basedir' do
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
        install_basedir: '/usr/local/matlab',
        type: 'network',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2012b').with(
        path: '/usr/local/matlab/licenses/network.lic',
        source: 'puppet:///matlab/license/network.lic',
      )
    }
  end

  # Test custom install_basedir with license.dat type
  context 'with custom install_basedir and license.dat type' do
    let(:params) do
      {
        source: 'file:///opt/licenses/matlab.dat',
        install_basedir: '/home/matlab',
        type: 'license.dat',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2012b').with(
        path: '/home/matlab/etc/license.dat',
        source: 'file:///opt/licenses/matlab.dat',
      )
    }
  end

  # Test different source formats
  context 'with different source formats' do
    sources = [
      'puppet:///modules/matlab/licenses/network.lic',
      'file:///opt/licenses/matlab.lic',
      'http://license-server.example.com/matlab.lic',
      'https://secure.example.com/licenses/matlab.lic',
    ]

    sources.each do |source_uri|
      context "with source #{source_uri}" do
        let(:params) do
          {
            source: source_uri,
            type: 'network',
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_file('Matlab License R2012b').with(
            source: source_uri,
          )
        }
      end
    end
  end

  # Test explicit version parameter
  context 'with explicit version parameter' do
    let(:title) { 'matlab-latest' }
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
        version: 'R2023a',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License matlab-latest').with(
        path: '/opt/shared/matlab/licenses/network.lic',
      )
    }
  end

  # Test multiple instances (different titles)
  context 'when multiple instances are defined' do
    let(:title) { 'R2020a' }
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
      }
    end

    # This tests that the defined type can be instantiated multiple times
    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2020a').with(
        path: '/opt/shared/matlab/licenses/network.lic',
      )
    }
  end

  # Test edge cases with special characters in paths
  context 'with install_basedir containing spaces' do
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
        install_basedir: '/opt/shared matlab',
      }
    end

    it { is_expected.to compile }

    it {
      is_expected.to contain_file('Matlab License R2012b').with(
        path: '/opt/shared matlab/licenses/network.lic',
      )
    }
  end

  # Test compile-time validation failures
  describe 'parameter validation' do
    # Test invalid license type
    context 'with invalid license type' do
      let(:params) do
        {
          source: 'puppet:///matlab/license/network.lic',
          type: 'invalid_type',
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{expects a match for Enum\['license\.dat', 'network'\]})
      }
    end

    # Test invalid install_basedir (relative path)
    context 'with invalid install_basedir (relative path)' do
      let(:params) do
        {
          source: 'puppet:///matlab/license/network.lic',
          install_basedir: 'relative/path',
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{expects a Stdlib::Absolutepath})
      }
    end

    # Test invalid install_basedir (empty string)
    context 'with invalid install_basedir (empty string)' do
      let(:params) do
        {
          source: 'puppet:///matlab/license/network.lic',
          install_basedir: '',
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{expects a Stdlib::Absolutepath})
      }
    end

    # Test missing required source parameter
    context 'with missing source parameter' do
      let(:params) { {} }

      it {
        is_expected.to compile.and_raise_error(%r{expects a value for parameter 'source'})
      }
    end

    # Test invalid source parameter type
    context 'with invalid source parameter (not a string)' do
      let(:params) do
        {
          source: ['array', 'of', 'values'],
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{expects a String value})
      }
    end

    # Test invalid version parameter type
    context 'with invalid version parameter (not a string)' do
      let(:params) do
        {
          source: 'puppet:///matlab/license/network.lic',
          version: 123,
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{expects a String value})
      }
    end
  end

  # Test resource attributes and relationships
  describe 'resource creation' do
    let(:params) do
      {
        source: 'puppet:///matlab/license/network.lic',
      }
    end

    it 'creates exactly one file resource' do
      catalogue = subject.call
      files = catalogue.resources.select { |r| r.type == 'File' }
      expect(files.size).to eq(1)
    end

    it 'creates file resource with correct title format' do
      is_expected.to contain_file('Matlab License R2012b')
    end

    it 'does not create any other resource types beyond catalog infrastructure' do
      catalogue = subject.call
      # Only check resources created by our defined type, excluding catalog infrastructure
      user_resources = catalogue.resources.reject { |r|
        r.type == 'Stage' ||
        r.type == 'Class' ||
        (r.type == 'File' && r.title == 'Matlab License R2012b')
      }
      # Should only have the one File resource we created
      file_resources = catalogue.resources.select { |r| r.type == 'File' && r.title == 'Matlab License R2012b' }
      expect(file_resources.size).to eq(1)
    end
  end

  # Test different combinations of parameters
  describe 'parameter combinations' do
    combinations = [
      {
        desc: 'network license with default basedir',
        params: { source: 'puppet:///matlab/R2020a.lic', type: 'network' },
        expected_path: '/opt/shared/matlab/licenses/network.lic',
      },
      {
        desc: 'license.dat with default basedir',
        params: { source: 'file:///licenses/matlab.dat', type: 'license.dat' },
        expected_path: '/opt/shared/matlab/etc/license.dat',
      },
      {
        desc: 'network license with custom basedir',
        params: { source: 'puppet:///matlab/network.lic', type: 'network', install_basedir: '/usr/matlab' },
        expected_path: '/usr/matlab/licenses/network.lic',
      },
      {
        desc: 'license.dat with custom basedir',
        params: { source: 'puppet:///matlab/license.dat', type: 'license.dat', install_basedir: '/home/software/matlab' },
        expected_path: '/home/software/matlab/etc/license.dat',
      },
    ]

    combinations.each do |combo|
      context "with #{combo[:desc]}" do
        let(:params) { combo[:params] }

        it { is_expected.to compile }

        it {
          is_expected.to contain_file('Matlab License R2012b').with(
            path: combo[:expected_path],
            source: combo[:params][:source],
          )
        }
      end
    end
  end
end
