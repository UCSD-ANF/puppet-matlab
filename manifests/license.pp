# Install a license file for Matlab
# We support multiple versions of Matlab on a system simultaenously, so this is
# a defined type rather than a class
# == Parameters
# [*install_dir*] - top level directory where Matlab is installed
# [*file*] - source file containing the license keys
# [*type*] - Usually 'network' for network license files.
define matlab::license (
  $install_dir, # top level directory where matlab is installed
  $file,
  $type = 'network'
) {

  $manage_file_name = "${install_dir}/licenses/${type}.lic"

  file { "Matlab License ${title}" :
    path => $manage_file_name,
  }

}