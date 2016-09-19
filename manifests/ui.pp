# Class: storm::ui
#
# This module manages storm uiation
#
# Parameters: None
#
# Actions: None
#
# Requires: storm::install
#
# Sample Usage:
#
#  class {'storm::ui': }
#
class storm::ui(
  $manage_service        = false,
  $enable                = true,
  $force_provider        = undef,
  $mem                   = '1024m',
  $port                  = '8080',
  $host                  = '0.0.0.0',
  $childopts             = '-Xmx768m',
  $jvm                   = [
    '-Dlog4j.configuration=file:/etc/storm/storm.log.properties',
    '-Dlogfile.name=ui.log'
  ],
  $config_file           = $storm::config_file,
  $use_systemd_templates = false,
  ) inherits storm {
  validate_bool($manage_service)
  validate_array($jvm)

  concat::fragment { 'ui':
    ensure  => present,
    target  => $config_file,
    content => template("${module_name}/storm_ui.erb"),
    order   => 3,
  }

  # Install ui /etc/default
  storm::service { 'ui':
    manage_service        => $manage_service,
    force_provider        => $force_provider,
    enable                => $enable,
    config_file           => $config_file,
    jvm_memory            => $mem,
    opts                  => $jvm,
    use_systemd_templates => $install_from_tarball,
  }

}
