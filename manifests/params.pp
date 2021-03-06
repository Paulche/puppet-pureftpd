class pureftpd::params {
    case $operatingsystem {
        /(Ubuntu|Debian)/: {
          case $pureftpd::auth_type {
                'mysql': { $real_auth_type = '-mysql' }
                'ldap': { $real_auth_type = '-ldap' }
                'postgresql': { $real_auth_type = '-postgresql' }
                default: { $real_auth_type = '' }
            }
            $package_name = "pure-ftpd${real_auth_type}"
            $config_dir = '/etc/pure-ftpd/'
            $service_name = "pure-ftpd${real_auth_type}"
            $config_default_file = '/etc/default/pure-ftpd-common'
            $config_source = 'debian'
        }
        /(RedHat|CentOS|Fedora)/: {
          case $pureftpd::auth_type {
                'mysql': { $real_auth_type = '-mysql' }
                'ldap': { $real_auth_type = '-ldap' }
                'postgresql': { $real_auth_type = '-postgresql' }
                default: { $real_auth_type = '' }
            }
            $package_name = "pure-ftpd${real_auth_type}"
            $config_dir = '/etc/pure-ftpd/'
            $service_name = "pure-ftpd${real_auth_type}"
            $config_default_file = '/etc/default/pure-ftpd-common'
            $config_source = 'debian'
        }
    }

    case $pureftpd::virtualchroot {
        true: { $real_virtualchroot = true }
        default: { $real_virtualchroot = false }
    }
}
