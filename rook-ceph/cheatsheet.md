# Commands

- check status `ceph status`
- check status continuously `ceph -w`
- osd status `ceph osd status`
	- *OSDs are the individual pieces of storage*
- check health warnings `ceph health detail`
- perform benchmark on osd `ceph tell osd.X bench` - Provides IOPS #
- get osds per node `ceph osd tree`
- get osd pools `ceph osd lspools`
- get usage `ceph df`
- get usage from each osd `ceph osd df`
- list of osd and status per node `ceph osd status`
- 

# Examples for consumption

Use the storageClassName rook-ceph-block in ReadWriteOnce mode for persistent storage for a single pod
```
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ceph-rbd-pvc
  labels:
spec:
  storageClassName: rook-ceph-block
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```
Or rook-cephfs in ReadWriteMany mode for persistent storage that can be shared between pods.
```
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cephfs-pvc
spec:
  storageClassName: rook-cephfs
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

# Remove disks under ceph control from OS side
This is good for reinstallation when data has already been migrated

```
lsblk -f
# Check that volumes are taken by ceph
fdisk -l /dev/vdXXX
# Zap its partition table
sgdisk -Z /dev/vdXXX
# Now check for the device mappers
dmsetup info | grep ceph
# Remove them with 
dmsetup remove ceph--...
```

Then kill one of the rook-discover pods to rescan server disks and map them to OSDs