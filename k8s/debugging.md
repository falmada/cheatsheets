# Debugging

## External references

- https://nubenetes.com/kubernetes-troubleshooting/
- https://learnk8s.io/troubleshooting-deployments

## General debugging

- Check all common objects on a specific namespace: `kubectl get all -n NAMESPACE`
- Check recent events on your namespace: `kubectl get events --sort-by='.lastTimestamp'`
- Check pods on a specific namespace: `kubectl get pods -n NAMESPACE`
	+ Get further info from a specific pod: `kubectl describe pod -n NAMESPACE POD_NAME`
- Get logs for a pod that is running and ready: `kubectl logs -n NAMESPACE POD_NAME`
	+ Get previous log from a pod that recently died and has been restarted: `kubectl logs -p -n NAMESPACE POD_NAME`

## My pod is on CrashLoopBackOff

A first take on this is to check the events from the namespace. Then, get further info from the specific pod that is respawning.

## My pod is running but crashes

Most common cause is that either main container or one of the sidecars is getting OOMKilled. This is, they are requesting memory over their assigned limite on their `resources` specification.

