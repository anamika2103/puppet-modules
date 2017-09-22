# Class: iis_vhost
# ===========================
#
# Full description of class iis_vhost here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'iis_vhost':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class iis_vhost {


}

class iis_vhost::windows::windowsfeatureinstall {

include chocolatey

$iis_features = ['Web-Server','Web-WebServer','Web-Http-Redirect','Web-Mgmt-Console','Web-Mgmt-Tools']

windowsfeature { $iis_features:
  ensure => present,
}

windowsfeature { 'NET-Framework-Core':
  ensure => present,
}

}

class iis_vhost::windows::filedircreation {

file { 'C:\inetpub\happyclub':
  ensure => 'directory',
}

file { 'C:\inetpub\happyclub\default.htm':
  ensure   => 'file',
  content  => '<html><h1>I have changed my new file content.</h1></html>'
}

}

class iis_vhost::windows::aclpermission {

acl { 'C:\inetpub\happyclub':
  permissions => [
    {'identity' => 'IIS_IUSRS', 'rights' => ['read', 'execute'] },
  ],
}

}

class iis_vhost::windows::iisconfiguration {

iis_site {'Default Web Site':
  ensure   => 'started',
  applicationpool => 'DefaultAppPool',
  bindings => [ {
           'bindinginformation' => '*:2000:',
           'protocol' => 'https',
           'sslflags'             => 1,
           'certificatehash'      => '3598FAE5ADDB8BA32A061C5579829B359409856F',
           'certificatestorename' => 'qwerty',
  },
],
} 

class iis_vhost::windows::newsitehosting {

iis_application_pool { 'happyclub_site_app_pool':
  ensure                  => 'present',
  state                   => 'started'
} ->

iis_site { 'happyclub':
  ensure          => 'started',
  physicalpath    => 'C:\inetpub\happyclub',
  applicationpool => 'happyclub_site_app_pool',
  require         => File['C:\inetpub\happyclub'],
}

}        
