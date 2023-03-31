# Kustomize

```bash
# Get differences of applying a specific overlays vs what's on the cluster
kubectl diff -k overlays/cluster/k8s-xx
# Apply an overlay
kubectl apply -k overlays/cluster/k8s-xx
```

## Build and split code

> Requires yq to be installed

```bash
# Normal build of an overlay, drop content into a YAML
kustomize build overlays/clusters/CLUSTER_NAME > /tmp/kustomize_build.yaml
# Move to path, else with following command you will spam your current directory, not good :)
cd /tmp
# Use yq to split the files based on .kind and .metadata.name
yq -s '"tmp_" + .kind + "-" +.metadata.name' /tmp/kustomize_build.yaml
```

The result is a list of files as shown below:

```bash
╰─ ls *.yaml *yml
kustomize_build.yaml
tmp_HelmRelease-namespace-my-namespace.yml
tmp_ClusterRole-super-user.yml
tmp_ClusterRoleBinding-super-user-binding.yml
```
