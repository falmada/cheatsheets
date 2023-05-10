# Ansible

## References

## Paths

- Localhost inventory: `/etc/ansible/hosts`
    - Example: 
```
[local]
localhost

[remote]
remote_test

[remote:vars]
ansible_host=IP_ADDRESS_OF_VIRTUAL_MACHINE
ansible_user=USERNAME
```
- 

## Cheatsheet

- Run module ping to all systems in inventory `localhost` using local console instead of ssh: `ansible all -i localhost, --connection=local -m ping`
- Run module ping to all systems, using local connection: `ansible all --connection=local -m ping`
- Test connection to remote systems: `ansible remote -m ping`
- Linting: `ansible-lint verify-apache.yml`