# Install a license file for Matlab
# We support multiple versions of Matlab on a system simultaenously, so this is
# a defined type rather than a class
# == Parameters
# [*install_basedir*] - top level directory where Matlab is installed
# [*source*] - source file containing the license keys
# [*type*] - Usually 'network' for network license files.
define matlab::license (
  $source,
  $install_basedir='UNSET',
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

  validate_absolute_path($real_install_basedir)

  $manage_file_name =
    "${real_install_basedir}/licenses/${real_license_type}.lic"

  file { "Matlab License ${title}" :
    path => $manage_file_name,
  }

}
