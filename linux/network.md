# Getting "ERR_NETWORK_CHANGED" constantly on Chrome

This [could be due to ipv6](https://superuser.com/questions/747735/regularly-getting-err-network-changed-errors-in-chrome)

```
# validate with
sudo sysctl -A | grep disable_ipv6
# If =0, then disable default and all
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1    
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

