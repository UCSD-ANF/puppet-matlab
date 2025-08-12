# puppet-matlab

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with matlab](#setup)
    * [What matlab affects](#what-matlab-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with matlab](#beginning-with-matlab)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Parameters](#parameters)
5. [Examples](#examples)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Description

This Puppet module provides comprehensive management of MATLAB installations in enterprise and academic environments. It handles license file deployment (both network and standalone), creates system-wide executable symlinks, and supports NFS-shared installations with multiple MATLAB versions.

The module simplifies MATLAB deployment across fleets of systems by automating:
- License file placement and configuration
- Symbolic link creation for system-wide access
- Multi-version MATLAB support
- NFS-shared installation management

## Setup

### What matlab affects

* Creates symbolic links for MATLAB executables (`matlab`, `mex`, `mcc`, `mbuild`) in system PATH
* Deploys license files to appropriate MATLAB directories
* Manages license file permissions and placement
* Supports both network license files and standalone license.dat files

### Setup Requirements

**IMPORTANT**: This module requires Puppet 7.0.0 or later and uses modern Puppet data types.

* Puppet >= 7.0.0
* puppetlabs-stdlib >= 8.0.0

### Beginning with matlab

The simplest use of this module is to include the main class with default parameters:

```puppet
include matlab
```

This will create symbolic links for MATLAB executables using default installation paths, but will not deploy any license files.

## Usage

### Basic usage with license deployment

```puppet
class { 'matlab':
  license_source => 'puppet:///modules/mymodule/matlab_license.lic',
  license_type   => 'network',
}
```

### Custom installation paths

```puppet
class { 'matlab':
  install_basedir => '/opt/matlab/R2023b',
  link_basedir    => '/usr/local',
  license_source  => 'puppet:///modules/mymodule/license.dat',
  license_type    => 'license.dat',
}
```

### Multiple MATLAB versions

```puppet
# Install licenses for multiple MATLAB versions
matlab::license { 'R2023b':
  source          => 'puppet:///modules/mymodule/R2023b_license.lic',
  install_basedir => '/opt/matlab/R2023b',
  type            => 'network',
}

matlab::license { 'R2022a':
  source          => 'puppet:///modules/mymodule/R2022a_license.dat',
  install_basedir => '/opt/matlab/R2022a',
  type            => 'license.dat',
}
```

### Disable symbolic link creation

```puppet
class { 'matlab':
  links => false,
}
```

## Parameters

### Class: matlab

#### `links`
Data type: `Boolean`

Controls whether symbolic links are created for MATLAB executables.

Default value: `true`

#### `install_basedir`
Data type: `Optional[Stdlib::Absolutepath]`

The top-level directory where MATLAB is installed. This is used to locate MATLAB executables and determine license file placement.

Default value: `/opt/shared/matlab`

#### `link_basedir`
Data type: `Optional[Stdlib::Absolutepath]`

The base directory where symbolic links will be created. Links will be placed in `${link_basedir}/bin/`.

Default value: `/usr/local`

#### `license_source`
Data type: `Optional[String]`

The source location for the license file (e.g., `puppet:///modules/mymodule/license.lic`). If not specified, no license file will be deployed.

Default value: `undef`

#### `license_type`
Data type: `Optional[Enum['network', 'license.dat']]`

The type of license file being deployed:
- `network`: Modern network license files (placed in `licenses/network.lic`)
- `license.dat`: Legacy standalone license files (placed in `etc/license.dat`)

Default value: `network`

### Defined Type: matlab::license

#### `source`
Data type: `String`

**Required.** The source location for the license file.

#### `install_basedir`
Data type: `Optional[Stdlib::Absolutepath]`

The MATLAB installation directory for this specific version.

Default value: `/opt/shared/matlab`

#### `version`
Data type: `String`

The MATLAB version identifier (defaults to the resource title).

Default value: `$title`

#### `type`
Data type: `Optional[Enum['network', 'license.dat']]`

The license file type for this specific installation.

Default value: `network`

## Examples

### Enterprise deployment with NFS-shared MATLAB

```puppet
class { 'matlab':
  install_basedir => '/nfs/shared/matlab/R2023b',
  link_basedir    => '/usr/local',
  license_source  => 'puppet:///modules/site/matlab/network.lic',
  license_type    => 'network',
  links           => true,
}
```

### Academic environment with multiple versions

```puppet
# Main class for default version
class { 'matlab':
  install_basedir => '/opt/matlab/current',
  license_source  => 'puppet:///modules/site/matlab/current.lic',
}

# Additional versions
matlab::license { 'R2022a':
  source          => 'puppet:///modules/site/matlab/R2022a.lic',
  install_basedir => '/opt/matlab/R2022a',
}

matlab::license { 'R2021b':
  source          => 'puppet:///modules/site/matlab/R2021b.lic',
  install_basedir => '/opt/matlab/R2021b',
}
```

### Legacy MATLAB installation

```puppet
class { 'matlab':
  install_basedir => '/usr/local/matlab',
  license_source  => 'puppet:///modules/site/matlab/license.dat',
  license_type    => 'license.dat',
}
```

## Limitations

### Operating System Support

This module is compatible with the following operating systems:

- **Red Hat Enterprise Linux**: 7, 8, 9
- **CentOS**: 7, 8
- **Scientific Linux**: 7
- **Oracle Linux**: 7, 8, 9
- **SUSE Linux Enterprise Server**: 12, 15
- **Ubuntu**: 18.04, 20.04, 22.04
- **Debian**: 9, 10, 11

### MATLAB Version Support

- **Modern MATLAB**: R2007a and later (network licensing)
- **Legacy MATLAB**: R2006b and earlier (license.dat format)
- **Multi-version**: Supports concurrent installations

### Technical Requirements

- Requires POSIX-compliant file system for symbolic link support
- NFS-shared installations supported
- Puppet 7.0.0 or later required for modern data type support

## Development

This module is developed using the Puppet Development Kit (PDK) and follows modern Puppet best practices.

### Development Setup

```bash
# Install PDK
gem install pdk

# Generate new module structure
pdk new module

# Validate code
pdk validate

# Run unit tests
pdk test unit

# Run acceptance tests
pdk test acceptance
```

### Testing

The module includes comprehensive RSpec tests covering all classes and defined types:

```bash
# Run all tests
pdk test unit

# Run specific test files
pdk test unit --tests=spec/classes/matlab_spec.rb
```

### Contributing

1. Fork the project
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass with `pdk test unit`
5. Validate code with `pdk validate`
6. Submit a pull request

### Code Quality

This module follows Puppet best practices:
- Modern data types (Puppet 7+)
- Comprehensive parameter validation
- Full test coverage
- PDK-compliant structure
- Rubocop and puppet-lint compliance

## License

This module is licensed under the Apache License, Version 2.0.

## Support

For issues and questions, please use the project's issue tracker.

## Changelog

### Version 0.2.2

- Modernized for Puppet 7+ compatibility
- Updated to use modern data types (Boolean, Optional, Enum)
- Replaced legacy validation functions with native data types
- Updated stdlib dependency to >= 8.0.0
- Migrated to PDK for development workflow
- Enhanced operating system support
- Improved parameter validation and error handling

### Previous Versions

See [CHANGELOG.md](CHANGELOG.md) for complete version history.
