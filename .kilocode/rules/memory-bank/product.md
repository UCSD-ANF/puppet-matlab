# puppet-matlab Product Description

## Why This Project Exists

MATLAB is a critical scientific computing tool widely used in academic, research, and enterprise environments. However, managing MATLAB installations across multiple systems presents several challenges:

- MATLAB installations are typically large and expensive
- Multiple versions often need to coexist on systems
- License management is complex (network vs standalone)
- Executables need to be accessible system-wide
- Manual installation/configuration is time-consuming and error-prone

## Problems It Solves

1. **Centralized MATLAB Management**: Enables IT administrators to deploy and configure MATLAB consistently across fleets of systems using Puppet automation
2. **NFS-Shared Installations**: Optimizes disk usage by supporting NFS-shared MATLAB installations while creating proper local symlinks
3. **License File Deployment**: Automates the deployment of both network license files and standalone license.dat files
4. **Multi-Version Support**: Allows multiple MATLAB versions to coexist on the same system
5. **PATH Management**: Automatically creates symlinks in system PATH for easy command-line access

## How It Should Work

### For System Administrators:
- Include the matlab class in node manifests
- Specify license file sources and types
- Configure installation and link directories as needed
- Puppet handles all file placement and symlink creation

### For End Users:
- MATLAB commands (matlab, mex, mcc, mbuild) work from any directory
- License files are properly configured and functional
- Multiple MATLAB versions can be accessed if installed
- No manual configuration required

## User Experience Goals

- **Zero-Touch Deployment**: Users receive fully configured MATLAB without manual setup
- **Consistent Access**: MATLAB works the same way across all managed systems
- **Transparent License Management**: License files work seamlessly without user intervention
- **Clean Integration**: MATLAB executables available in standard system PATH locations