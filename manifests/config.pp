class pureftpd::config {
    file { "${pureftpd::params::config_dir}conf":
        ensure  => directory,
        recurse => true,
        purge   => true,
        force   => true,
        owner   => root,
        group   => root,
        source  => $source ? {
            undef      => "puppet:///modules/${module_name}/${pureftpd::params::config_source}",
            default => $pureftpd::config_source,
        },
        require => Class['pureftpd::install'],
        notify  => Class['pureftpd::service'],
    }

    file { $pureftpd::params::config_default_file:
        ensure  => present,
        owner   => root,
        group   => root,
        content => template($pureftpd::config_template),
        require => Class['pureftpd::install'],
        notify  => Class['pureftpd::service'],
    }
}
