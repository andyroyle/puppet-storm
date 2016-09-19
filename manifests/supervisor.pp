# Class: storm::supervisor
#
# This module manages storm supervisoration
#
# Parameters: None
#
# Actions: None
##
# Sample Usage:
#
# class{'storm::supervisor': }
#
class storm::supervisor(
  $manage_service            = false,
  $force_provider            = undef,
  $enable                    = true,
  $ensure_service            = 'running',
  $mem                       = '1024m',
  $start_port                = 6700,
  $workers                   = 4,
  $cpu_capacity              = 400,
  $childopts                 = '-Xmx1024m',
  $worker_start_timeout_secs = 120,
  $worker_timeout_secs       = 30,
  $monitor_frequency_secs    = 3,
  $heartbeat_frequency_secs  = 5,
  $jvm                       = [
    '-Dlog4j.configuration=file:/etc/storm/storm.log.properties',
    '-Dlogfile.name=supervisor.log'
  ],
  $config_file               = $storm::config_file,
  $use_systemd_templates     = false,
) inherits storm {

  validate_bool($enable)
  validate_array($jvm)

  concat::fragment { 'supervisor':
    ensure  => present,
    target  => $config_file,
    content => template("${module_name}/storm_supervisor.erb"),
    order   => 5,
  }

  # Install supervisor /etc/default
  storm::service { 'supervisor':
    manage_service        => $manage_service,
    enable                => $enable,
    ensure_service        => $ensure_service,
    force_provider        => $force_provider,
    config_file           => $config_file,
    jvm_memory            => $mem,
    opts                  => $jvm,
    use_systemd_templates => $install_from_tarball,
  }

  storm::service { 'logviewer':
    manage_service        => $manage_service,
    enable                => $enable,
    force_provider        => $force_provider,
    config_file           => $config_file,
    jvm_memory            => '128m',
    use_systemd_templates => $install_from_tarball,
  }



}
