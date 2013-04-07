class pureftpd::install($repository = undef) {
    package { $pureftpd::params::package_name:
        ensure => present,
        require => $repository,
    }
}
