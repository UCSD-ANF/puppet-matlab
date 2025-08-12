# Install a license file for Matlab
# We support multiple versions of Matlab on a system simultaenously, so this is
# a defined type rather than a class
#
# @param source
#   Source file path containing the license keys
# @param install_basedir
#   Top level directory where Matlab is installed
# @param version
#   MATLAB version identifier (defaults to the resource title)
# @param type
#   The type of license file ('network' for network.lic, 'license.dat' for older versions)
define matlab::license (
  String $source,
  Stdlib::Absolutepath $install_basedir = '/opt/shared/matlab',
  String $version = $title,
  Enum['network', 'license.dat'] $type = 'network',
) {
  $manage_file_name = $type ? {
    'network'     => "${install_basedir}/licenses/network.lic",
    'license.dat' => "${install_basedir}/etc/license.dat",
  }

  file { "Matlab License ${title}":
    path   => $manage_file_name,
    source => $source,
  }
}
