# systemd - quota to service

```bash
sudo vi /etc/systemd/system/multi-user.target.wants/SERVICE_NAME
```

Add something like

```bash
CPUWeight=20
CPUQuota=50%
IOWeight=20
MemorySwapMax=0
```

Then, after this you need to reload the daemon and restart the service

```bash
sudo systemctl daemon-reload
sudo systemctl restart SERVICE_NAME
```
