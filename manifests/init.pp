class ufw {
  package { 'ufw':
    ensure => present,
  }

	$etc = "/etc/ufw"
	$before = "${etc}/before.rules.d"
	$before_out = "${etc}/before.rules"
	$before6 = "${etc}/before6.rules.d"
	$before6_out = "${etc}/before6.rules"

	file {
		$before:
			ensure  => directory,
			owner   => root,
			group   => 0,
			mode    => 0555,
			require => Package["ufw"],
		;
		"${before}/40-default":
			ensure  => file,
			owner   => root,
			group   => 0,
			mode    => 0440,
			require => File[$before],
		;
		$before6:
			ensure  => directory,
			owner   => root,
			group   => 0,
			mode    => 0555,
			require => Package["ufw"],
		;
		"${before6}/40-default":
			ensure  => file,
			owner   => root,
			group   => 0,
			mode    => 0440,
			require => File[$before6],
		;
		$before_out:
			ensure  => file,
			owner   => root,
			group   => 0,
			mode    => 0440,
			require => Package["ufw"],
		;
		$before6_out:
			ensure  => file,
			owner   => root,
			group   => 0,
			mode    => 0440,
			require => Package["ufw"],
		;
	}

	exec {
		"${before}/40-default":
			command => "mv ${before_out} ${before}/40-default",
			unless  => "test -s ${before}/40-default",
			require => File["${before}/40-default"],
			notify  => Exec["ufw::before"],
		;
		"${before6}/40-default":
			command => "mv ${before6_out} ${before6}/40-default",
			unless  => "test -s ${before6}/40-default",
			require => File["${before6}/40-default"],
			notify  => Exec["ufw::before"],
		;
		"ufw::before":
			command     => "cat ${before}/*-* > ${before_out} && cat ${before6}/*-* > ${before6_out}",
			refreshonly => true,
			require     => [
				Exec["${before}/40-default"],
				Exec["${before6}/40-default"],
			],
		;
	}

  Package['ufw'] -> Exec['ufw-default-deny'] -> Exec['ufw-enable']

  exec { 'ufw-default-deny':
    command => 'ufw default deny',
    unless  => 'ufw status verbose | grep "Default: deny (incoming), allow (outgoing)"',
  }

  exec { 'ufw-enable':
    command => 'yes | ufw enable',
    unless  => 'ufw status | grep "Status: active"',
  }

  service { 'ufw':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Package['ufw'],
  }
}
