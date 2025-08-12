# Create symlinks to various matlab executables
# Useful for NFS-shared versions of Matlab
# Creates links for the following files:
# * matlab
# * mex
# * mcc
# * mbuild
#
# === Parameters
# ==== Required
# [*install_basedir*] - the base location where Matlab is installed or NFS
# shared. This path will be searched for a bin directory containing the source
# executables for the links.
#
# ==== Optional
# [*link_basedir*] - the base location where the links will be installed.
# This path will have "/bin" appended to it. Defaults to "/usr/local"
#
# [*ensure*] - If set to "absent" the links will be removed. Defaults to
# "present"
class matlab::links (
  Stdlib::Absolutepath $install_basedir = '/opt/shared/matlab',
  Stdlib::Absolutepath $link_basedir = '/usr/local',
  Enum['present', 'absent'] $ensure = 'present',
) {
  $manage_link_ensure = $ensure ? {
    'present' => 'link',
    'absent'  => 'absent',
  }

  file { "${link_basedir}/bin/matlab" :
    ensure => $manage_link_ensure,
    target => "${install_basedir}/bin/matlab",
  }

  file { "${link_basedir}/bin/mcc" :
    ensure => $manage_link_ensure,
    target => "${install_basedir}/bin/mcc",
  }

  file { "${link_basedir}/bin/mex" :
    ensure => $manage_link_ensure,
    target => "${install_basedir}/bin/mex",
  }

  file { "${link_basedir}/bin/mbuild" :
    ensure => $manage_link_ensure,
    target => "${install_basedir}/bin/mbuild",
  }
}
