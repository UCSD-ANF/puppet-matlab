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
# [*real_link_basedir*] - the base location where the links will be installed.
# This path will have "/bin" appended to it. Defaults to "/usr/local"
#
# [*ensure*] - If set to "absent" the links will be removed. Defaults to
# "present"
class matlab::links (
  $install_basedir = 'UNSET',
  $link_basedir = 'UNSET',
  $ensure  = 'present'
) {
  include matlab::params

  $real_install_basedir = $install_basedir ? {
    'UNSET' => $matlab::params::install_basedir,
    default => $install_basedir,
  }

  $real_link_basedir = $link_basedir ? {
    'UNSET' => $matlab::params::link_basedir,
    default => $link_basedir,
  }

  validate_re($ensure, [ '^present', '^absent' ],
    'The ensure property must be "present" or "absent"')
  validate_absolute_path($real_link_basedir)
  validate_absolute_path($real_install_basedir)

  $manage_link_ensure = $ensure ? {
    'present' => 'link',
    'absent'  => 'absent',
  }

  file { "${real_link_basedir}/bin/matlab" :
    ensure => $manage_link_ensure,
    target => "${real_install_basedir}/bin/matlab",
  }

  file { "${real_link_basedir}/bin/mcc" :
    ensure => $manage_link_ensure,
    target => "${real_install_basedir}/bin/mcc",
  }

  file { "${real_link_basedir}/bin/mex" :
    ensure => $manage_link_ensure,
    target => "${real_install_basedir}/bin/mex",
  }

  file { "${real_link_basedir}/bin/mbuild" :
    ensure => $manage_link_ensure,
    target => "${real_install_basedir}/bin/mbuild",
  }
}
