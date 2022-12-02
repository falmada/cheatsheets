# Kustomize

```bash
# Get differences of applying a specific overlays vs what's on the cluster
kubectl diff -k overlays/cluster/k8s-xx
# Apply an overlay
kubectl apply -k overlays/cluster/k8s-xx
```