## Release DHCP lease prior to removing host - DOES NOT WORK
dhclient -r ens3
## Scan with arp scan sudo apt install arp-scan
arp-scan --interface=ens3 172.17.24.0/24