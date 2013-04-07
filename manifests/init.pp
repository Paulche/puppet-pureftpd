# Class: pureftpd
#
# This module manages pureftpd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class pureftpd (
      $auth_type = undef,
      $config_source = undef,
      $virtualchroot = false,
      $config_template = undef,
      $repository = undef
    )
    {
	    include pureftpd::params, pureftpd::config, pureftpd::service

      class { 'pureftpd::install':
        repository => $repository,
      }
    }
