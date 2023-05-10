- Querying a virsh command requires to set a shell first
```
for i in `seq 8 12`; do ssh virt-xx${i} 'bash -l -c "virsh net-info network-name"'; done
```