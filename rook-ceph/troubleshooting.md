# Ceph OSD node removal fails

1. Identify node to be removed
2. Find mon and osd pods related to it `kubectl get pods -o wide -n rook-ceph | grep <affectedMachineUID> | grep -E "mon|osd"`
3. Delete mon and res deployment, example
```
kubectl delete deployment rook-ceph-mon-A -n rook-ceph
kubectl delete deployment rook-ceph-osd-# -n rook-ceph
```
4. Login to ceph tools `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`
5. Rebalance the Ceph OSDs: `ceph osd out osd(s).ID`
6. Wait for the rebalance to complete.
7. Rebalance Ceph data: `ceph osd purge osd(s).ID`
8. Remove the old node from the Ceph OSD tree: `ceph osd crush rm <NodeName>`
9. If the removed node contained mon services, remove them: `ceph mon rm <monID>`

# During a managed cluster update, Ceph rebalance leading to data loss may occur.

## Workaround:

Before updating a managed cluster:
1. Log in to the ceph-tools pod: `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`
2. Set the noout flag: `ceph osd set noout`

Update a managed cluster.

After updating a managed cluster:

1. Log in to the ceph-tools pod: `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`
2. Unset the noout flag: `ceph osd unset noout`

# Ceph OSD pod is in the CrashLoopBackOff state after disk replacement

1. Login to ceph-tools pod: `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`
2. Delete the authorization key for the failed Ceph OSD: `ceph auth del osd.<ID>`
3. SSH to the node on which the Ceph OSD cannot be created.
4. Clean up the disk that will be a base for the failed Ceph OSD.
5. Restart rook operator `kubectl -n rook-ceph delete pod -l app=rook-ceph-operator`

# Replace a failed Ceph OSD

1. Identify the failed Ceph OSD ID: `ceph osd tree`
2. Remove the Ceph OSD deployment from the cluster `kubectl delete deployment -n rook-ceph rook-ceph-osd-<ID>`
3. Connect to ceph-tools pod `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`
4. Remove failed Ceph OSD from Ceph cluster `ceph osd purge osd.<ID>`
5. Replace the failed disk.
6. Restart the Rook operator: `kubectl delete pod $(kubectl -n rook-ceph get pod -l "app=rook-ceph-operator" -o jsonpath='{.items[0].metadata.name}') -n rook-ceph`