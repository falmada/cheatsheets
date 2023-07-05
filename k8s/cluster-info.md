# Get cluster info

```bash
# Pod CIDR
kubectl cluster-info dump | grep -m 1 cluster-cidr
                            "--cluster-cidr=10.244.0.0/16",

# Service CIDR
kubectl cluster-info dump | grep -m 1 service-cluster-ip-range
                            "--service-cluster-ip-range=10.96.0.0/12",
```