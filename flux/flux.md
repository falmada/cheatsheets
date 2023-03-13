# Flux

## Links

- [Flux CLI](https://fluxcd.io/flux/cmd/)

## List resources

```bash
flux get all --all-namespaces
```

## Troubleshooting

```bash
# Get all flux related resources
flux get all -A --status-selector ready=false
```

## Troubleshoot helmReleases

```bash
# reconciliation failed: install retries exhausted
kubectl describe helmrelease HELM_RELEASE_NAME -n NAMESPACE
```

## Reconcile

```bash
# source = HelmRepository
flux reconcile source helm name_of_source -n namespace
# helmRelease
flux reconcile helmrelease -n namespace name_of_helmrelease
```
