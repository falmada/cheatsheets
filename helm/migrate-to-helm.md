# Migrating existing deploy to Helm

When you have already deployed some application and want to start using Helm to manage it, you will eventually find out that Helm requires a few labels and annotations to take over the existing deployment.

The most common error you get looks like:

```errormsg
Error: INSTALLATION FAILED: rendered manifests contain a resource that already exists. Unable to continue with install: SOME_OBJECT_TYPE "SOME_OBJECT_NAME" in namespace "SOME_NAMESPACE" exists and cannot be imported into the current release: invalid ownership metadata; label validation error: missing key "app.kubernetes.io/managed-by": must be set to "Helm"; annotation validation error: missing key "meta.helm.sh/release-name": must be set to "SOME_RELEASE_NAME"; annotation validation error: missing key "meta.helm.sh/release-namespace": must be set to "SOME_NAMESPACE"
```

So, a simple fix would be to create some script that runs as shown below:

```bash
#!/bin/bash

# Setup required values for Helm
releaseNamespace='{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "NAMESPACE_NAME_HERE"}}}'
releaseName='{"metadata": {"annotations": {"meta.helm.sh/release-name": "HELM_RELEASE_NAME_HERE"}}}'
managedBy='{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'

# Setup configuration
namespace=NAMESPACE_NAME_HERE

# Apply fix
object_type="OBJECT_TYPE_HERE"
object_names="OBJECT_NAME_01 OBJECT_NAME_02 OBJECT_NAME_03"
for object_name in $object_names
do
	kubectl patch -n $namespace $object_type/$object_name --type=merge -p "$releaseNamespace"
	kubectl patch -n $namespace $object_type/$object_name --type=merge -p "$releaseName"
	kubectl patch -n $namespace $object_type/$object_name --type=merge -p "$managedBy"
done
```

But, it has a gotcha! You will need to run this script to patch resources, then run helm install just to get ANOTHER object complaining, and this could lead to some frustration.

One way to quickly understand all the resources that would be impacted is to run the same `helm install ...` command, but using `template` instead of `install`. This way, you just render what Helm will actually deploy, and based on that, you can extract which objects (kind+name) is required to be patched.

```
# Replace just your helm install with helm template, and append the pipe with egrep
helm template ... | egrep -i "kind|name:"
```

Now that you know all resources to be patched, and assuming ALL resources are named the same, you can do something like:

```bash
#!/bin/bash

# Setup required values for Helm
releaseNamespace='{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "NAMESPACE_NAME_HERE"}}}'
releaseName='{"metadata": {"annotations": {"meta.helm.sh/release-name": "HELM_RELEASE_NAME_HERE"}}}'
managedBy='{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'

# Setup configuration
namespace=NAMESPACE_NAME_HERE

# Apply fix
object_types="OBJECT_TYPE_01 OBJECT_TYPE_02 OBJECT_TYPE_03"
object_names="OBJECT_NAME"
for object_type in $object_types
do
  for object_name in $object_names
  do
    kubectl patch -n $namespace $object_type/$object_name --type=merge -p "$releaseNamespace"
    kubectl patch -n $namespace $object_type/$object_name --type=merge -p "$releaseName"
    kubectl patch -n $namespace $object_type/$object_name --type=merge -p "$managedBy"
  done
done
```
