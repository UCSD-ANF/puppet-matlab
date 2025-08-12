# puppet-matlab Architecture

## System Architecture

The puppet-matlab module follows standard Puppet module conventions with a clean, modular design that separates concerns across multiple components.

## Source Code Structure

```
manifests/
├── init.pp      - Main matlab class (entry point)
├── license.pp   - License file management (defined type)
└── links.pp     - Executable symlink creation (class)

data/
└── common.yaml  - Default parameter values (Hiera)

spec/
├── classes/     - Tests for classes
└── defines/     - Tests for defined types
```

## Component Relationships

### Core Dependencies
- [`manifests/init.pp`](manifests/init.pp) → uses Hiera data binding from [`data/common.yaml`](data/common.yaml) for defaults
- [`manifests/init.pp`](manifests/init.pp) → conditionally includes [`manifests/links.pp`](manifests/links.pp)
- [`manifests/init.pp`](manifests/init.pp) → conditionally creates [`matlab::license`](manifests/license.pp) resources
- All components use automatic parameter lookup from [`data/common.yaml`](data/common.yaml)

### Data Flow
1. User declares `matlab` class with optional parameters
2. Parameters are automatically resolved via Hiera data binding from [`data/common.yaml`](data/common.yaml)
3. If `$links` is true, [`matlab::links`](manifests/links.pp) class is included
4. If `$license_source` provided, [`matlab::license`](manifests/license.pp) defined type is instantiated

## Key Design Patterns

### Hiera Data Binding
Uses automatic parameter lookup with modern data types:
```puppet
class matlab (
  Stdlib::Absolutepath $install_basedir,
  Stdlib::Absolutepath $link_basedir,
  Enum['network', 'standalone'] $license_type,
  Boolean $links = true,
) {
  # Parameters automatically resolved from data/common.yaml
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
- Modern data types (`Stdlib::Absolutepath`, `Enum`, `Boolean`) for compile-time validation
- Type safety built into parameter declarations
- Automatic validation of parameter values before catalog compilation

## Configuration Defaults

Default values in [`data/common.yaml`](data/common.yaml):
- Install base: `/opt/shared/matlab` (NFS-friendly)
- Link base: `/usr/local` (standard system location)
- License type: `network` (enterprise default)