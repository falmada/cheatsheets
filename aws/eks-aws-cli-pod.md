```yaml
---
# Creates a pod with an AWS CLI using latest image
# Uses kube-system to prevent NetPols and Policies
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: tmp-aws-cli
  name: tmp-aws-cli
  namespace: kube-system
spec:
  containers:
    - command: ["/bin/bash", "-c", "--"]
      args: ["while true; do sleep 30; done;"]
      image: public.ecr.aws/aws-cli/aws-cli
      name: aws-cli
      resources:
        requests:
          memory: "64Mi"
          cpu: "250m"
        limits:
          memory: "128Mi"
          cpu: "500m"
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  tolerations:
    - effect: NoSchedule
      key: nodeTarget
      value: targetName
# Connect with: kubectl exec -ti tmp-aws-cli -n kube-system -- /bin/bash
```