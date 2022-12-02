# Helm

```bash
# Simulate a chat deployment and get the YAML that would be created on Kubernetes 
helm upgrade --install -f values.yaml nombre-release helm-repo/nombre-chart -n nombre-namespace --dry-run
```
