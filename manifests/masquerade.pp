##
## Masquerade a source through UFW.
##
define ufw::masquerade($src, $out) {
	include ufw
	include ufw::masquerading

	ufw::before {
		"masquerade-${name}":
			priority => 11,
			ip4      => "*nat\n-A POSTROUTING -s ${src} -o ${out} -j MASQUERADE\nCOMMIT\n",
		;
	}
}
