# puppet-matlab Brief

## Project Overview
A Puppet module for managing MATLAB software installations and configurations across Unix/Linux systems.

## Core Requirements
- Manage MATLAB installations in shared environments (NFS)
- Create symbolic links to MATLAB executables in system PATH
- Handle license file deployment (network and standalone licenses)
- Support multiple MATLAB versions simultaneously
- Provide clean, testable Puppet code following best practices

## Primary Goals
- Simplify MATLAB deployment in enterprise/academic environments
- Enable centralized MATLAB management via Puppet
- Support both network-licensed and standalone MATLAB installations
- Maintain compatibility across different MATLAB versions (R2006b to modern)

## Success Criteria
- MATLAB executables accessible system-wide via symlinks
- License files properly deployed and configured
- Module passes all RSpec tests
- Clean, maintainable Puppet code structure