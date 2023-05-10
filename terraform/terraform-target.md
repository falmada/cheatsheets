## Terraform Target and Lifecycle

Lifecycle does not support variables, only static... hence we cannot use it

- Target multiple resources 
```
terraform plan -target 'module.workers-zoneC.libvirt_cloudinit_disk.cloud_init["worker05-k8s-xx"]' \
  -target 'module.workers-zoneC.libvirt_domain.worker["worker05-k8s-xx"]' \
  -target 'module.workers-zoneC.libvirt_volume.docker_volume["worker05-k8s-xx"]' \
  -target 'module.workers-zoneC.libvirt_volume.storage_volume_01["worker05-k8s-xx"]' \
  -target 'module.workers-zoneC.libvirt_volume.volume["worker05-k8s-xx"]' \
  -target 'module.workers-zoneA.libvirt_cloudinit_disk.cloud_init["worker06-k8s-xx"]' \
  -target 'module.workers-zoneA.libvirt_domain.worker["worker06-k8s-xx"]' \
  -target 'module.workers-zoneA.libvirt_volume.docker_volume["worker06-k8s-xx"]' \
  -target 'module.workers-zoneA.libvirt_volume.storage_volume_01["worker06-k8s-xx"]' \
  -target 'module.workers-zoneA.libvirt_volume.volume["worker06-k8s-xx"]'
```

## Snippets

terraform plan | grep -E -i "updated in-place|destroyed|created|replaced|(Plan:)"

terraform plan \
	-target 'module.workers-zoneC.libvirt_cloudinit_disk.cloud_init["worker03-k8s-xx"]' \
	-target 'module.workers-zoneC.libvirt_domain.worker["worker03-k8s-xx"]'

## Otros

Modificar cosas del cloud init no provoca:
- reboots
- cambios en la vm
- rebuilds