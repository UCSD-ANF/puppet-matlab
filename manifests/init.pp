# Manage matlab on supported platforms
class matlab (
  $links=true,
  $install_basedir='UNSET',
  $link_basedir='UNSET',
  $license_source=undef,
  $license_type='UNSET'
){
  include matlab::params

  $real_install_basedir = $install_basedir ? {
    'UNSET' => $matlab::params::install_basedir,
    default  => $install_basedir,
  }

  $real_link_basedir = $link_basedir ? {
    'UNSET' => $matlab::params::link_basedir,
    default  => $link_basedir,
  }

  $real_license_type = $license_type ? {
    'UNSET' => $matlab::params::license_type,
    default => $license_type,
  }

  if $links {
    class { 'matlab::links' :
      install_basedir => $real_install_basedir,
      link_basedir    => $real_link_basedir,
    }
  }

  if $license_source {
    matlab::license{ 'default':
      source          => $license_source,
      install_basedir => $real_install_basedir,
      type            => $real_license_type,
    }
  }
}
