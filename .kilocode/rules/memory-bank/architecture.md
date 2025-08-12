# puppet-matlab Architecture

## System Architecture

The puppet-matlab module follows standard Puppet module conventions with a clean, modular design that separates concerns across multiple components.

## Source Code Structure

```
manifests/
├── init.pp      - Main matlab class (entry point)
├── params.pp    - Default parameter values
├── license.pp   - License file management (defined type)
└── links.pp     - Executable symlink creation (class)

spec/
├── classes/     - Tests for classes
└── defines/     - Tests for defined types
```

## Component Relationships

### Core Dependencies
- [`manifests/init.pp`](manifests/init.pp) → includes [`manifests/params.pp`](manifests/params.pp) for defaults
- [`manifests/init.pp`](manifests/init.pp) → conditionally includes [`manifests/links.pp`](manifests/links.pp)
- [`manifests/init.pp`](manifests/init.pp) → conditionally creates [`matlab::license`](manifests/license.pp) resources
- All components reference [`manifests/params.pp`](manifests/params.pp) for default values

### Data Flow
1. User declares `matlab` class with optional parameters
2. Parameters are resolved using "UNSET" pattern with defaults from [`params.pp`](manifests/params.pp:3-5)
3. If `$links` is true, [`matlab::links`](manifests/links.pp) class is included
4. If `$license_source` provided, [`matlab::license`](manifests/license.pp) defined type is instantiated

## Key Design Patterns

### Parameter Defaulting Pattern
Uses "UNSET" string values with conditional assignment to allow parameter inheritance:
```puppet
$real_install_basedir = $install_basedir ? {
  'UNSET' => $matlab::params::install_basedir,
  default  => $install_basedir,
}
```

### Defined Type for Versioning
[`matlab::license`](manifests/license.pp) is a defined type rather than class to support multiple MATLAB versions simultaneously.

### Conditional Resource Management
- Links creation controlled by `$links` boolean parameter
- License deployment controlled by presence of `$license_source`

## Critical Implementation Paths

### License File Placement Logic
- Network licenses: `${install_basedir}/licenses/network.lic`
- Standalone licenses: `${install_basedir}/etc/license.dat`
- Validation ensures only supported license types are used

### Symlink Management
Creates symlinks for four MATLAB executables:
- `matlab` - Main application
- `mex` - MEX-file compiler
- `mcc` - MATLAB Compiler
- `mbuild` - Build script for MEX-files

### Validation Strategy
- [`validate_re()`](manifests/license.pp:27) for license type validation
- [`validate_absolute_path()`](manifests/license.pp:29) for path validation
- Ensures data integrity and prevents configuration errors

## Configuration Defaults

Default values in [`manifests/params.pp`](manifests/params.pp):
- Install base: `/opt/shared/matlab` (NFS-friendly)
- Link base: `/usr/local` (standard system location)
- License type: `network` (enterprise default)