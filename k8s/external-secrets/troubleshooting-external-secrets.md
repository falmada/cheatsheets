Reference:
- https://external-secrets.io/latest/introduction/faq/

Force secret sync
```
kubectl annotate es test-secret force-sync=$(date +%s) --overwrite
```

Check cluster-secret-store status
```
kubectl get css
kubectl describe css
```

Check for errors on the external-secrets controller pod
```
stern -n external-secrets -l app.kubernetes.io/name=external-secrets --tail 100
```
