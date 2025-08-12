# puppet-matlab Technologies

## Core Technologies

### Puppet DSL
- **Primary Language**: Puppet Domain Specific Language
- **Version**: Puppet >= 7.0.0
- **Purpose**: Infrastructure automation and configuration management

### Ruby
- **Version**: Ruby 2.7+ (for testing framework and PDK)
- **Purpose**: Test suite implementation and Puppet tooling
- **Testing Framework**: RSpec with puppetlabs_spec_helper
- **Development Kit**: Puppet Development Kit (PDK) for modern workflow

## Dependencies

### External Dependencies
- **puppetlabs-stdlib**: Core Puppet functions and types
  - Version: >= 8.0.0
  - Purpose: Provides modern data types (`Stdlib::Absolutepath`, `Boolean`, `Enum`)

### Development Dependencies
- **puppetlabs_spec_helper**: Testing framework for Puppet modules
- **rake**: Task automation and test execution
- **rspec**: Behavior-driven testing framework

## Development Setup

### Project Structure
```
puppet-matlab/
├── manifests/           - Puppet DSL code
├── data/               - Hiera data files
│   └── common.yaml     - Default parameter values
├── spec/               - RSpec tests
├── .fixtures.yml       - Test dependencies configuration
├── .pdkignore         - PDK ignore patterns
├── pdk.yaml           - PDK configuration
├── hiera.yaml         - Hiera configuration
├── Rakefile           - Task automation
└── README.md          - Documentation
```

### Testing Strategy
- **Unit Tests**: RSpec tests for all classes and defined types
- **Fixtures**: Configured via `.fixtures.yml` for dependency management
- **Test Coverage**: Complete coverage of all manifests

### Build System
- **PDK Integration**: Uses Puppet Development Kit for modern workflow
- **Rake Tasks**: Provided by `puppetlabs_spec_helper` and PDK
- **Test Execution**: `pdk test unit` or `rake spec` for running test suite
- **Lint Checking**: `pdk validate` for comprehensive code validation
- **Bundle Management**: `pdk bundle` for dependency management

## Technical Constraints

### Puppet Version Compatibility
- **Minimum Version**: Puppet >= 7.0.0
- **Modern Data Types**: Uses Puppet 4.x+ native data types
- **Hiera Integration**: Built-in Hiera data binding for parameter defaults
- **Forward Compatible**: Designed for modern Puppet Enterprise and open source

### Platform Support
- **Target OS**: Unix/Linux systems
- **File System**: Requires POSIX-compliant file system for symlinks
- **NFS Support**: Designed to work with NFS-shared MATLAB installations

### MATLAB Version Support
- **Legacy**: R2006b (license.dat format)
- **Modern**: Network licensing (network.lic format)
- **Multi-Version**: Supports concurrent installations

## Tool Usage Patterns

### Modern Data Types
Uses Puppet native and stdlib data types:
- `Boolean` for true/false parameters
- `Stdlib::Absolutepath` for file path validation
- `Enum['network', 'standalone']` for license type validation
- `Optional[String]` for optional string parameters

### Hiera Integration
- **Data Binding**: Automatic parameter lookup from `data/common.yaml`
- **Hierarchy**: Module-level data files for default values
- **Override Support**: Site-specific overrides via external Hiera

### Resource Management
- File resources for license deployment
- Symlink management via file resources with `ensure => 'link'`
- Conditional resource creation based on parameters