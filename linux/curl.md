# Curl

```bash
# Send traffic to a host (like a Ingress LB) with a specific URL to serve
# Useful when there is no DNS entry available still
curl -v IP_HERE:PORT_HERE --header 'Host: my-host.domain.net' -k

# Get exit code
curl --connect-timeout 2 --max-time 2 -o /dev/null -s -w "%{http_code}\n" https://IP_HERE

# Get exit code and edit Host header
curl --connect-timeout 2 --max-time 2 -o /dev/null -s -w "%{http_code}\n" https://IP_HERE -k --header 'Host: my-host.domain.net'
```
