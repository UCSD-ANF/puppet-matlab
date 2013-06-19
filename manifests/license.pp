# Install a license file for Matlab
# We support multiple versions of Matlab on a system simultaenously, so this is
# a defined type rather than a class
# == Parameters
# [*install_basedir*] - top level directory where Matlab is installed
# [*source*] - source file containing the license keys
# [*type*] - The type of license file. Usually 'network' for network license
# files. For older versions of Matlab (2006b for example), use "license.dat"
define matlab::license (
  $source,
  $install_basedir='UNSET',
  $version=$title,
  $type = 'UNSET'
) {
  include matlab::params

  $real_install_basedir = $install_basedir ? {
    'UNSET' => $matlab::params::install_basedir,
    default => $install_basedir,
  }

  $real_license_type = $type ? {
    'UNSET' => $matlab::params::license_type,
    default => $type,
  }

  validate_re($real_license_type, ['^network', '^license.dat'])

  validate_absolute_path($real_install_basedir)

  $manage_file_name = $real_license_type ? {
    'network'     => "${real_install_basedir}/licenses/network.lic",
    'license.dat' => "${real_install_basedir}/etc/license.dat",
  }

  file { "Matlab License ${title}" :
    path => $manage_file_name,
  }

}
