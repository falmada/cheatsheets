# Helm

```bash
# Simulate a chat deployment and get the YAML that would be created on Kubernetes 
helm upgrade --install -f values.yaml nombre-release helm-repo/nombre-chart -n nombre-namespace --dry-run

# Search for "metrics-server" chart on all repositories to find which one to add
helm search hub metrics-server -o yaml 

# Add a repository named "artifact-hub" from URL "https://artifacthub.github.io/helm-charts"
helm repo add artifact-hub https://artifacthub.github.io/helm-charts

# Sync repo "artifact-hub" which was just added
helm repo update artifact-hub
```

## Other links

- [Troubleshooting pending-install on a helm release](pending-install.md)
