# Troubleshooting pending-install

## Associated errors

- HelmRelease error message: "Helm upgrade failed: another operation (install/upgrade/rollback) is in progress"
- Helm message:

  ```bash
  aws-efs-csi-driver   kube-system   1   2022-11-10 21:05:55.214773448 +0000 UTC   pending-install   aws-efs-csi-driver-2.2.7   1.4.0
  ```

## Troubleshooting

If the issue is **pending-upgrade**, then fix is as simple as:

```bash
helm history -n (ns) #
helm rollback -n (ns) # (num)
```

But, our issue is **pending-install**, which means that Helm did not complete the installation process, but it *might* have deployed something!

For example:

```bash
pod/efs-csi-controller-7f48649467-gbp67             3/3     Running   2 (29d ago)   69d
pod/efs-csi-controller-7f48649467-wslz2             3/3     Running   0             69d
pod/efs-csi-node-7xsn7                              3/3     Running   0             61d
pod/efs-csi-node-b4n92                              3/3     Running   0             61d
pod/efs-csi-node-bd95n                              3/3     Running   0             69m
pod/efs-csi-node-t8nrw                              3/3     Running   0             61d
```

So, Helm did install something, but for some reason, never ended.

Current status prevents you from taking any action on the Helm Release, as in doing upgrades or fixing the issue. The first solution that comes to mind is uninstalling it... but the pods are running, and people using it, hence we cannot just do that.

Following an [issue on github](https://github.com/helm/helm/issues/8987#issuecomment-913898986), noticed that Helm stores info on releases using secrets. You can even [decode them](https://github.com/helm/helm/issues/8987#issuecomment-1064587116) and read what they have!

*Note: Take a backup of the secret first: `kubectl get secret sh.helm.release.v1.aws-efs-csi-driver.v1 -o yaml > /var/tmp/aws-efs-csi-driver.v1.yaml` for example, and also on the values from this release with `helm get values aws-ebs-csi-driver > /var/tmp/aws-ebs-csi-driver_values.yaml`*

The fix is simple, just remove that secret and Helm will forget about your release issues... and YOUR RELEASE as well (check prior note! take a backup of it, just in case).

In my case, I was playing with Flux, hence just doing a resume on the helmRelease was enough to get it going, otherwise if you are just using Helm, run a `helm upgrade --install ...` with the same values you had before destroying everything.

## Summary

- A **pending-install** issue happens when Helm is unable to complete the installation process of a Chart. This may have deployed parts of the chart (like pods) but was unable to finish and hence declared your release with that blocking status
- If this is a fresh install, with no users, just do a `helm uninstall` on the release and install again
- If this is an installation which has users actively using whatever is served by this chart, then find the associated secret on the same namespace of the chart, do a backup of it, take a backup of helm values for the release, and then proceed to remove the secret, something like `sh.helm.release.v1.RELEASE_NAME.v1`
- If your issue is just **pending-upgrade**, then make sure to run a `helm history` on your release and go back to prior working version

## Lessons learned

After deploying with Flux and HelmRelease, make sure that `helm ls -a -A` report all releases as **deployed**, otherwise troubleshoot as needed.
