# Docker Cheatsheet

- Run image and remove once completed: `docker run --rm IMAGE_NAME`
- Build and tag image: `docker build --tag TAG_NAME .`
- Invalidate RUN cache: `docker build --no-cache ...`
- Inspect labels: `docker image inspect --format='{{json .Config.Labels}}' myimage`
- Change ENV value: `docker run --env <key>=<value>`

## Links

- <https://docs.docker.com/engine/reference/builder/>