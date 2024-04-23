
## Check permissions on a EKS cluster for a specific role and group name

```bash
kubectl auth can-i --list --as=arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME --as-group=AWS-AUTH-GROUP_NAME -n TARGET_NAMESPACE
```

## Check permissions on a Kubernetes cluster for a service account

```bash
kubectl auth can-i --list --as=system:serviceaccount:NAMESPACE:SERVICE_ACCOUNT_NAME -n NAMESPACE
```
