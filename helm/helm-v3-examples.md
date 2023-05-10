# Helm v3

## Add default repo

> Previously known as https://kubernetes-charts.storage.googleapis.com
helm repo add stable https://charts.helm.sh/stable --force-update

## Install/upgrade

Install one component: `helm install hello-world`
Upgrade one component: `helm upgrade --install tom-release --set appName=mytomcatcon hello-world`

## Debugging

`helm lint` verify chart follows best practices
`helm install --dry-run --debug` or `helm template --debug` render template and see the resulting manifest
`helm get manifest` see what templates are installed on server

# Helm v2

Remove helm v2 from namespace: `helm reset --tiller-namespace NAMESPACE_HERE`