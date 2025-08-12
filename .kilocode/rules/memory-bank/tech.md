# puppet-matlab Technologies

## Core Technologies

### Puppet DSL
- **Primary Language**: Puppet Domain Specific Language
- **Version**: Compatible with Puppet 3.x and later
- **Purpose**: Infrastructure automation and configuration management

### Ruby
- **Version**: Ruby 1.9+ (for testing framework)
- **Purpose**: Test suite implementation and Puppet tooling
- **Testing Framework**: RSpec with puppetlabs_spec_helper

## Dependencies

### External Dependencies
- **puppetlabs-stdlib**: Core Puppet functions and types
  - Source: `git://github.com/puppetlabs/puppetlabs-stdlib.git`
  - Purpose: Provides validation functions (`validate_re`, `validate_absolute_path`)

### Development Dependencies
- **puppetlabs_spec_helper**: Testing framework for Puppet modules
- **rake**: Task automation and test execution
- **rspec**: Behavior-driven testing framework

## Development Setup

### Project Structure
```
puppet-matlab/
├── manifests/           - Puppet DSL code
├── spec/               - RSpec tests
├── .fixtures.yml       - Test dependencies configuration
├── Rakefile           - Task automation
└── README.md          - Documentation
```

### Testing Strategy
- **Unit Tests**: RSpec tests for all classes and defined types
- **Fixtures**: Configured via `.fixtures.yml` for dependency management
- **Test Coverage**: Complete coverage of all manifests

### Build System
- **Rake Tasks**: Provided by `puppetlabs_spec_helper`
- **Test Execution**: `rake spec` for running test suite
- **Lint Checking**: Standard Puppet linting available

## Technical Constraints

### Puppet Version Compatibility
- Designed for Puppet 3.x+ environments
- Uses legacy validation functions (pre-Puppet 4.x data types)
- Compatible with older enterprise Puppet installations

### Platform Support
- **Target OS**: Unix/Linux systems
- **File System**: Requires POSIX-compliant file system for symlinks
- **NFS Support**: Designed to work with NFS-shared MATLAB installations

### MATLAB Version Support
- **Legacy**: R2006b (license.dat format)
- **Modern**: Network licensing (network.lic format)
- **Multi-Version**: Supports concurrent installations

## Tool Usage Patterns

### Parameter Validation
Uses stdlib validation functions:
- `validate_re()` for string pattern matching
- `validate_absolute_path()` for path validation

### Resource Management
- File resources for license deployment
- Symlink management via file resources with `ensure => 'link'`
- Conditional resource creation based on parameters