exec { "apt-get update":
  path => "/usr/bin",
}

exec { "uk-mirror":
  command   => 'sed -i "s|us\.archive\.ubuntu|www.mirrorservice.org/sites/archive.ubuntu|g" /etc/apt/sources.list',
  path       => '/bin',
}


#exec { 'add-webupd8-key':
# command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886',
#  path => '/usr/bin/',
#}

apt::key { 'webupd8':
  key        => 'EEA14886',
  key_server => 'keyserver.ubuntu.com',
}

# exec { 'add-datastax-key':
#   command => 'curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -',
#   path => '/usr/bin/',
# }

# apt::source { 'datastax':
#   location          =>  'http://debian.datastax.com/community',
#   repos             =>  'main',
#   release           =>  'stable',
#   include_src       =>  false,
# }

apt::source { 'webupd8team':
  location          =>  'http://ppa.launchpad.net/webupd8team/java/ubuntu',
  repos             =>  'main',
  release           =>  'precise',
  include_src       =>  false,
}

# apt::ppa { 'ppa:webupd8team/java': }

#package { "python-software-properties":
#  ensure  => present,
#  require => Exec["apt-get update"],
#}


exec { 'accept-java-license':
  command => '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections;/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections;',
}


package {
  "curl":
    ensure  => present,
    before  => Package["vim","oracle-java6-installer"],
    require => Exec["uk-mirror","apt-get update"];
  "vim":
    ensure  => present;
 "oracle-java6-installer":
    ensure  => present,
    require => [Package["curl"],Exec["uk-mirror","apt-get update","accept-java-license"],Apt::Source["webupd8team"]],
    before => Package["oracle-java6-set-default"];
  "oracle-java6-set-default":
    ensure  => present;
    # "add-datastax-key",
}

#service { "apache2":
#  ensure  => "running",
#  require => Package["apache2"],
#}
