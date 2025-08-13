# Changelog

All notable changes to this project will be documented in this file.

## Release 1.0.0 - 2025-08-12

This is a **major milestone release** that completely modernizes the puppet-matlab module from legacy Puppet 3.x patterns to Puppet 7+ standards. This release represents a complete architectural overhaul while maintaining functional compatibility.

**⚠️ BREAKING CHANGES**
- **Puppet Version Requirement**: Now requires Puppet >= 7.0.0 (previously supported older versions)
- **Stdlib Requirement**: Now requires puppetlabs-stdlib >= 8.0.0 for modern data types
- **Legacy Parameter Validation**: Removed all deprecated validation functions (`validate_re`, `validate_absolute_path`)
- **Parameter File Migration**: Replaced `manifests/params.pp` with Hiera data binding via `data/common.yaml`

**✨ Major Features & Modernization**
- **Modern Data Types**: Complete adoption of Puppet native and stdlib data types:
  - `Boolean` for true/false parameters with compile-time validation
  - `Stdlib::Absolutepath` for robust path validation
  - `Enum['network', 'standalone']` for license type safety
  - `Optional[String]` for optional parameters
- **Hiera Integration**: Full integration with modern Hiera data binding for automatic parameter lookup
- **PDK Conversion**: Module now uses Puppet Development Kit for modern development workflow
- **Type Safety**: Compile-time parameter validation through modern Puppet data types

**🧪 Testing & Quality Improvements**
- **Comprehensive Test Suite**: Complete RSpec test modernization with 1,917+ tests
- **Multi-Platform Coverage**: Tests across 15+ operating system versions
- **PDK Integration**: Modern testing workflow with `pdk test unit` and `pdk validate`
- **CI/CD Ready**: Full compatibility with modern Puppet testing pipelines

**🏗️ Technical Architecture**
- **Clean Separation**: Eliminated legacy `manifests/params.pp` pattern
- **Data-Driven Configuration**: Centralized defaults in `data/common.yaml` with automatic lookup
- **Modern Resource Management**: Updated resource patterns for Puppet 7+ compatibility
- **Future-Proof Design**: Built for long-term compatibility with Puppet Enterprise

**📋 Migration Guide**
For users upgrading from 0.x versions:

1. **Puppet Version**: Ensure your Puppet infrastructure is >= 7.0.0
2. **Stdlib Dependency**: Update puppetlabs-stdlib to >= 8.0.0
3. **Functional Compatibility**: No changes required to existing class declarations
4. **Hiera Integration**: Existing parameter overrides continue to work seamlessly
5. **Testing**: Run comprehensive testing in staging environments due to underlying architectural changes

**🔧 Development Workflow**
- **PDK Standard**: Full PDK integration for modern Puppet development
- **Lint & Validation**: Enhanced code quality checks via `pdk validate`
- **Dependency Management**: Modern bundle management with PDK
- **Documentation**: Updated for modern Puppet patterns and best practices

This release maintains 100% functional compatibility while providing a solid foundation for future enhancements. The module is now ready for modern Puppet Enterprise environments and follows current Puppet best practices.

## Release 0.2.2

**Features**

**Bugfixes**

**Known Issues**
