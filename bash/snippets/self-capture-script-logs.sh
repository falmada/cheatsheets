# Self-capture script logs


```bash
# Capture everything
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/var/tmp/build-info.$$/log.out 2>&1
```