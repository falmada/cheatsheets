References:
- https://libvirt.org/sources/virshcmdref/html-single/

Commands

- Help
virsh help
virsh help <command>
virsh help list

- Check resources
virt-top

- Display hypervisor info
virsh nodeinfo

- List all VMs
virsh list −−all

- Start VM
virsh start <vmname>
virsh start testvm1

- Shutdown VM
virsh shutdown <vmname|id>
virsh shutdown testvm1

- Power off VM
virsh destroy <vmname>
virsh destroy testvm1

- Suspend/pause VM
virsh suspend <vmname|id>
virsh suspend testvm1

- Resume VM
virsh resume <vmname|id>
virsh resume testvm1

- Save VM to a file
virsh save <vmname>
virsh save testvm1

- Restore VM from file
virsh restore <vmname>
virsh restore testvm1

- Get VM info
virsh dominfo <vmname>
virsh dominfo testvm1

- Change the maximum memory allocation limit in the guest VM
virsh setmaxmem <vmname> <newmemsize> −−config
virsh setmaxmem testvm1 4096M −−config
virsh setmaxmem testvm1 4G −−config

- Change the current memory allocation in the guest VM
virsh setmem <vmname> <newmemsize> −−config
virsh setmem testvm1 4096M −−config
virsh setmem testvm1 4G −−config

- Edit the XML configuration for a guest VM 
virsh edit <vmname>
virsh edit testvm1

- Clone a VM
virt-clone -o <sourcevm> -n <destinationvm> -f <destination_disk_file>
virt-clone -o testvm1 -n testvm1-clone -f testvm1-clone.qcow2

- Detach interface
virsh detach-interface --domain eks-master-1 --type bridge --mac 52:54:00:11:62:2e

- Get disks attached to vm
virsh domblklist testvm1