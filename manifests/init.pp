# Manage matlab on supported platforms
#
# @param links
#   Whether to create symlinks to MATLAB executables in the system PATH
# @param install_basedir
#   The base directory where MATLAB is installed or NFS shared
# @param link_basedir
#   The base directory where symlinks will be created (bin/ will be appended)
# @param license_source
#   Source file path containing the license keys (optional)
# @param license_type
#   The type of license file ('network' for network.lic, 'license.dat' for older versions)
class matlab (
  Boolean $links = true,
  Stdlib::Absolutepath $install_basedir = '/opt/shared/matlab',
  Stdlib::Absolutepath $link_basedir = '/usr/local',
  Optional[String] $license_source = undef,
  Enum['network', 'license.dat'] $license_type = 'network',
) {
  if $links {
    class { 'matlab::links' :
      install_basedir => $install_basedir,
      link_basedir    => $link_basedir,
    }
  }

  if $license_source {
    matlab::license { 'default':
      source          => $license_source,
      install_basedir => $install_basedir,
      type            => $license_type,
    }
  }
}
