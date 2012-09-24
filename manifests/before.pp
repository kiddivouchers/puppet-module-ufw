define ufw::before($priority = 50, $ip4 = undef, $ip6 = undef) {
	include ufw

	file {
		"${ufw::before}/${priority}-${name}":
			owner   => root,
			group   => 0,
			mode    => 0440,
			require => File[$ufw::before],
			notify  => Exec["ufw::before"],
		;
		"${ufw::before6}/${priority}-${name}":
			owner   => root,
			group   => 0,
			mode    => 0440,
			require => File[$ufw::before6],
			notify  => Exec["ufw::before"],
		;
	}

	if $ip4 {
		File["${ufw::before}/${priority}-${name}"] {
			ensure  +> file,
			content +> $ip4,
		}
	} else {
		File["${ufw::before}/${priority}-${name}"] {
			ensure +> absent,
		}
	}

	if $ip6 {
		File["${ufw::before6}/${priority}-${name}"] {
			ensure  +> file,
			content +> $ip6,
		}
	} else {
		File["${ufw::before6}/${priority}-${name}"] {
			ensure +> absent,
		}
	}
}
