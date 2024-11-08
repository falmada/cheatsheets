IRSA allows you to have a Service Account on a namespace, with a `eks.amazonaws.com/role-arn` annotation containing a role which has permissions within AWS. The way it works is that the EKS OIDC will provide necessary auth to the service account (mapping the namespace/service account name, to a specific role).

The benefit of it is that you do not handle any credential, as in AWS_SECRET_ACCESS_KEY or AWS_ACCESS_KEY_ID. The cons is that if you want to troubleshoot, you cannot "impersonate" the role to debug.

This can be overcome by creating a pod which has aws-cli and uses the serviceAccount that is allowed. You need to have permissions to deploy on the same namespace, and moreover, knowledge around which commands need to be executed. The output of the pod in the logs will be your guide.

It is necessary to mention that you will only have permissions associated to the policies attached to the Role you are assuming through IRSA, so handle with care.

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: aws-cli
  labels:
    app: aws-cli
spec:
  serviceAccountName: service-account-with-irsa-annotation
  containers:
  - image: amazon/aws-cli
    command:
      - "aws"
      - "help"
    name: aws-cli
  restartPolicy: Never
  terminationGracePeriodSeconds: 3
```