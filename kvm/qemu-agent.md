Requires qemu-agent to be installed on the host

# Examples

## Get guest info
`sudo virsh qemu-agent-command DOMAIN_NAME '{"execute":"guest-info"}' --pretty`

## Run command and get output

Run this to get a command (path) executed with specific args
`DOM=DOMAIN_NAME; sudo virsh qemu-agent-command $DOM '{"execute": "guest-exec", "arguments": {"path": "ip", "arg": [ "addr", "list" ],"capture-output": true } }'`

Get output
`DOM=DOMAIN_NAME; sudo virsh qemu-agent-command $DOM '{"execute": "guest-exec-status", "arguments": { "pid": 2245 } }'`
Then decode with base64 -d


# Get IP

It will only select ones on 172.x

`DOM=DOMAIN_NAME; sudo virsh qemu-agent-command $DOM '{"execute":"guest-network-get-interfaces"}' | python -mjson.tool | grep \"ip-address\": | grep 172\. | cut -d'"' -f4`
