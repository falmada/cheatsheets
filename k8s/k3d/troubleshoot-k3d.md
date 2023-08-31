# Troubleshoot K3d

## Pods evicted due to NodeHasDiskPressure

```bash
k3d create ... \
	--agent-arg '--eviction-hard=imagefs.available<1%,nodefs.available<1%' 
	--agent-arg '--eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%'
```