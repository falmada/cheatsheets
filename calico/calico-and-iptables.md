# Calico and IPTables

```
# Check rules with prerouting
sudo iptables -t nat -L PREROUTING | column -t

# Focus on calico ones
sudo iptables -t nat -L cali-PREROUTING -n  | column -t

# Check on the ones related to services in Kubernetes
sudo iptables -t nat -L KUBE-SERVICES -n  | column -t

# Get all nodeports
sudo iptables -t nat -L KUBE-NODEPORTS -n  | column -t

# Dig into a specific nodeport
sudo iptables -t nat -L KUBE-EXT-Z7MGHFOGRJJG6ABC -n | column -t
```