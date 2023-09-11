# Creating a Docker image

## Reference

- A Dockerfile must begin with a FROM instruction
- A .dockerignore file allows to ignore files when there is a build
- A Docker image consists of read-only layers each of which represents a Dockerfile instruction. 
	+ The layers are stacked and each one is a delta of the changes from the previous layer.
- When you run an image and generate a container, you add a new writable layer, also called the container layer, on top of the underlying layers.
	+ All changes made to the running container, such as writing new files, modifying existing files, and deleting files, are written to this **writable container layer**.
- 

### ARG

- Can be declared before FROM
- Can be used within FROM.
	```Dockerfile
	ARG  CODE_VERSION=latest
	FROM base:${CODE_VERSION}
	CMD  /code/run-app
	
	FROM extras:${CODE_VERSION}
	CMD  /code/run-extras
	```
- An ARG declared before a FROM is outside of build stage. It can be used declaring it again without a value
	```
	ARG VERSION=latest
	FROM busybox:$VERSION
	ARG VERSION
	RUN echo $VERSION > image_version
	```

### FROM

- FROM instruction sets the base image.
- FROM syntax is `FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]`. 
	+ `<image>[:<tag>]` can be just `<image>`
	+ `<image>[:<tag>]` can be `<image>[@<digest>]`
	
### RUN

- Can be used in two ways
	+ `RUN <command>`: shell form, the command is run in a shell, which by default is `/bin/sh -c` on Linux
		* The default shell for the shell form can be changed using the SHELL command.
	+ `RUN ["executable", "param1", "param2"]`: exec form
		* The exec form makes it possible to avoid shell string munging, and to RUN commands using a base image that does not contain the specified shell executable.
		* The exec form is parsed as a JSON array, which means that you must use double-quotes (") around words not single-quotes (').
		* Unlike the shell form, the exec form does **not** invoke a command shell. This means that normal shell processing does not happen.
- The instruction is executed on top of the previous layer and commits result. Resulting image can be used on the next step.
- RUN can be executed with two lines, as follows
	```
	RUN /bin/bash -c 'source $HOME/.bashrc && \
	echo $HOME'
	```
- The cache for RUN instructions can be invalidated by using the `--no-cache` flag, for example `docker build --no-cache`.

#### apt-get

Always combine RUN apt-get update with apt-get install in the same RUN statement. For example:

```
RUN apt-get update && apt-get install -y \
    package-bar \
    package-baz \
    package-foo  \
    && rm -rf /var/lib/apt/lists/*
```

Otherwise, if they are on different commands, it could reuse layer from cache and be unable to install a new package when required.

The last command is to remove cache locally on the image.

#### pipes

If you want the command to fail due to an error at any stage in the pipe, prepend set -o pipefail && to ensure that an unexpected error prevents the build from inadvertently succeeding. For example:

```
RUN set -o pipefail && wget -O - https://some.site | wc -l > /number
```

### CMD

- The CMD instruction has three forms:
	+ `CMD ["executable","param1","param2"]`: exec form, this is the preferred form
	+ `CMD ["param1","param2"]`: as default parameters to ENTRYPOINT
	+ `CMD command param1 param2`: shell form (defaults to `/bin/sh -c`)
- There can **only be one CMD instruction** in a Dockerfile. If you list more than one CMD then **only the last CMD will take effect**.
- The main purpose of a CMD is to provide defaults for an executing container.
- If `CMD` is used to provide default arguments for the `ENTRYPOINT` instruction, both the `CMD` and `ENTRYPOINT` instructions should be specified with the JSON array format.
- Do not confuse RUN with CMD. RUN actually runs a command and **commits the result**; **CMD does not execute anything at build time**, but specifies the intended command for the image.

### LABEL

- Adds metadata to an image
- It's a key-value pair
- Common labels: version, description
- `LABEL org.opencontainers.image.authors="SvenDowideit@home.org.au"` simulates previous MAINTAINER instruction which is now deprecated

### ENV

- The ENV instruction sets the environment variable <key> to the value <value>. This value will be in the environment for **all** subsequent instructions in the build stage and can be replaced inline in many as well. 
- Example:
	```
	ENV MY_NAME="John Doe"
	```
- If an environment variable is only needed during build, and not in the final image, consider setting a value for a single command instead:
	```
	RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ...
	```
- Or using ARG, which is not persisted in the final image
	```
	ARG DEBIAN_FRONTEND=noninteractive
	RUN apt-get update && apt-get install -y ...
	```

### ADD

- ADD has two forms:
	- `ADD [--chown=<user>:<group>] [--chmod=<perms>] [--checksum=<checksum>] <src>... <dest>`
	- `ADD [--chown=<user>:<group>] [--chmod=<perms>] ["<src>",... "<dest>"]`: When paths contain whitespaces
- The ADD instruction copies new files, directories or remote file URLs from <src> and adds them to the filesystem of the image at the path <dest>.
- To add all files starting with "hom":
	```
	ADD hom* /mydir/
	```
- The <dest> is an absolute path, or a path relative to WORKDIR, into which the source will be copied inside the destination container.
	+ The example below uses a relative path, and adds "test.txt" to <WORKDIR>/relativeDir/: `ADD test.txt relativeDir/`
	+ Whereas this example uses an absolute path, and adds "test.txt" to /absoluteDir/: `ADD test.txt /absoluteDir/`
- All new files and directories are created with a **UID and GID of 0**, unless the optional --chown flag specifies a given username, groupname, or UID/GID combination to request specific ownership of the content added.
	- If the container root filesystem does **not** contain either /etc/passwd or /etc/group files and either user or group names are used in the --chown flag, the **build will fail** on the ADD operation.
* If <src> is a local tar archive in a recognized compression format (identity, gzip, bzip2 or xz) then it is unpacked as a directory.
	- Resources from remote URLs are **not** decompressed.

#### link

- Use --link to reuse already built layers in subsequent builds with --cache-from even if the previous layers have changed. 
	+ This is especially important for multi-stage builds where a COPY --from statement would previously get invalidated if any previous commands in the same stage changed, causing the need to rebuild the intermediate stages again.
	+ With `--link` the layer the previous build generated is reused and merged on top of the new layers.

### COPY

- COPY has two forms:
	+ `COPY [--chown=<user>:<group>] [--chmod=<perms>] <src>... <dest>`
	+ `COPY [--chown=<user>:<group>] [--chmod=<perms>] ["<src>",... "<dest>"]`: When paths contain whitespaces
- The COPY instruction copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.

### ENTRYPOINT

- ENTRYPOINT has two forms:
	+ The exec form, which is the preferred form: `ENTRYPOINT ["executable", "param1", "param2"]`
	+ The shell form: `ENTRYPOINT command param1 param2`
- An ENTRYPOINT allows you to configure a container that will run as an executable.
- You can use the exec form of ENTRYPOINT to set fairly stable default commands and arguments and then use either form of CMD to set additional defaults that are more likely to be changed.
	```
	FROM ubuntu
	ENTRYPOINT ["top", "-b"]
	CMD ["-c"]
	```

### USER

- `USER <user>[:<group>]` or `USER <UID>[:<GID>]`
	- The USER instruction sets the user name (or UID) and optionally the user group (or GID) to use as the default user and group for the remainder of the current stage. The specified user is used for RUN instructions and at runtime, runs the relevant ENTRYPOINT and CMD commands.

### WORKDIR

- `WORKDIR /path/to/workdir`
	+ The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile. 
		* If the WORKDIR doesn't exist, it will be created even if it's not used in any subsequent Dockerfile instruction.
- The WORKDIR instruction can be used multiple times in a Dockerfile. If a relative path is provided, it will be relative to the path of the previous WORKDIR instruction. For example:
	```
	WORKDIR /a
	WORKDIR b
	WORKDIR c
	RUN pwd
	```
	+ The output of the final pwd command in this Dockerfile would be `/a/b/c`.

### SHELL

- `SHELL ["executable", "parameters"]`
	- The SHELL instruction allows the default shell used for the shell form of commands to be overridden. 
	- The default shell on Linux is ["/bin/sh", "-c"]

## Build from a remote build context, using a Dockerfile from stdin

Link: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#build-from-a-remote-build-context-using-a-dockerfile-from-stdin

```bash
docker build -t myimage:latest -f- https://github.com/docker-library/hello-world.git <<EOF
FROM busybox
COPY hello.c ./
EOF
```

> When building an image using a remote Git repository as the build context, Docker performs a git clone of the repository on the local machine, and sends those files as the build context to the daemon. This feature requires you to install Git on the host where you run the docker build command.

## Multi stage builds

Link: https://docs.docker.com/build/building/multi-stage/

If your build contains several layers and you want to ensure the build cache is reusable, you can order them from the less frequently changed to the more frequently changed. The following list is an example of the order of instructions:
1. Install tools you need to build your application
2. Install or update library dependencies
3. Generate your application

A Dockerfile for a Go application could look like:

	```Dockerfile
	# syntax=docker/dockerfile:1
	FROM golang:1.20-alpine AS build
	
	# Install tools required for project
	# Run `docker build --no-cache .` to update dependencies
	RUN apk add --no-cache git
	
	# List project dependencies with go.mod and go.sum
	# These layers are only re-built when Gopkg files are updated
	WORKDIR /go/src/project/
	COPY go.mod go.sum /go/src/project/
	# Install library dependencies
	RUN go mod download
	
	# Copy the entire project and build it
	# This layer is rebuilt when a file changes in the project directory
	COPY . /go/src/project/
	RUN go build -o /bin/project
	
	# This results in a single layer image
	FROM scratch
	COPY --from=build /bin/project /bin/project
	ENTRYPOINT ["/bin/project"]
	CMD ["--help"]
	```

