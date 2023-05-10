# Containerd cheatsheet

## Useful links

- https://github.com/projectatomic/containerd/blob/master/docs/cli.md

## Commands

- List running containers: `sudo ctr containers list` or `sudo ctr c list`
- Delete one: `sudo ctr containers delete NAME`
- List images: `sudo ctr image list`
- Pull an image: `sudo ctr image pull k8s.gcr.io/etcd:3.4.13-0`
- Pull an image in China `ctr image pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2`
- Run an image: `sudo ctr run --rm k8s.gcr.io/etcd:3.4.13-0 etcd-copy /bin/sh`

## Docker to containerd

`--network host` --> `--net-host`
`-v /source/vol:/container/vol` --> `--mount type=bind,src=/source/vol,dst=/container/vol`

## Complex example

```
# Prepare environment
mkdir $(pwd)/backup
sudo cp -r /etc/kubernetes/pki $(pwd)/backup
ETCD_IMAGE=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[].spec.containers[].image}')
sudo ctr image pull ${ETCD_IMAGE}
# Run the image and perform a backup
sudo ctr run --rm \
  --mount type=bind,src=$(pwd)/backup,dst=/backup,options=rbind:rw \
  --net-host \
  --mount type=bind,src=/etc/kubernetes/pki/etcd,dst=/etc/kubernetes/pki/etcd,options=rbind:ro \
  --env ETCDCTL_API=3 \
  ${ETCD_IMAGE} \
  etcd-backup \
  etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt \
  --key=/etc/kubernetes/pki/etcd/healthcheck-client.key \
  snapshot save /backup/etcd-snapshot-latest.db
```