# lxd/lxc

## Initialize

`lxd init` and accept all prompts by default unless needing otherwise

## Check existing containers

`lxc list`

## Connect to container

`lxc exec CONTAINER_NAME -- sudo --login --user root`

## Launch a container

`lxc launch IMAGE_NAME CONTAINER_NAME`
- IMAGE_NAME could be for example ubuntu:16.04

## Start/stop container

```sh
lxc start CONTAINER_NAME
lxc stop CONTAINER_NAME
```

## Set container not to boot automatically

`lxc config set CONTAINER_NAME boot.autostart false`

## Get config from container

`lxc config show CONTAINER_NAME`

## Push file to container

`lxc file push FILE_NAME CONTAINER_NAME/PATH/TO/REMOTE/DIRECTORY`

## Create a clean environment for development

```sh
CONTAINER_NAME="my-container"
# Launch something like Ubuntu
lxc launch ubuntu:20.04/amd64 $CONTAINER_NAME
# Add a local path as disk
lxc config device add $CONTAINER_NAME development disk source="/home/federico/Development" path="/mnt/Development"
# Connect to host
lxc exec $CONTAINER_NAME -- sudo --login --user root
# Install dependencies
# apt-get update && apt install python3-pip && pip install dataclasses && pip install WHATEVER
```