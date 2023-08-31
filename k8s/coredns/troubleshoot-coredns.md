# CoreDNS Troubleshooting

## Add logging for a specific domain

```
. {
    log example.org {
        class denial error success
    }
}
```

## Useful links

- <https://coredns.io/plugins/log/>
- <https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/>