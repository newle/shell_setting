for i in `find /proc/sys/net/ipv4/* -type f`; do echo $i; cat $i; done
