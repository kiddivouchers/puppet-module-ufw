##
## Enables IP masquerading through UFW.
##
class ufw::masquerading {
	include ufw

	file {
		"/etc/sysctl.d/90-ufw-masquerading":
			ensure  => file,
			owner   => root,
			group   => 0,
			mode    => 0444,
			content => "net/ipv4/ip_forward=1\nnet/ipv6/conf/default/forwarding=1\nnet/ipv6/conf/all/forwarding=1\n"
			require => Class["ufw"],
		;
	}

	ufw::before {
		# Enabled IP masquerading.
		"masquerading":
			priority => 10,
			ip4      => "*nat\n:POSTROUTING ACCEPT [0:0]\nCOMMIT\n",
		;
	}
}
