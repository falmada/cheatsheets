# CoreDNS Troubleshooting

## Add logging for a specific domain

This needs to be modified on configMap `coredns` within `kube-system` namespace.

```yaml
  Corefile: |
    .:53 {
        errors
        health {
            lameduck 5s
          }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        forward . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
        # Append this to the end of the configMap
        log amazonaws.com {
            class denial error success
        }
        # Remember to remove after troubleshooting #
    }
```

Remember to do a `kubectl rollout restart deploy -n kube-system coredns` once configuration is updated.

## Useful links

- <https://coredns.io/plugins/log/>
- <https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/>