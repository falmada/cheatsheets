# systemd-resolved

## Notes

- `/etc/resolv.conf` will show `nameserver 127.0.0.53`

## Commands

```bash
# Get list of dns servers
resolvectl status --no-pager | tail -10
```