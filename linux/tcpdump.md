- Check without FQDNs, just IPs: `tcpdump -n ...`
- Check against a specific destination IP: `tcpdump -n dst 1.2.3.4`
- Check on any interface, against a destination IP with a specific port: `tcpdump -i any dst 1.2.3.4 and tcp port 80
`