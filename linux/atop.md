# atop fails to install

## Error
`Job for atopacct.service failed because the service did not take the steps required by its unit configuration.`

## Fix
```
echo $$ >/run/atopacctd.pid
apt install -y atop
```

## Usage

```
# Just run
atop

# Summarize per samples per day
# If taken every 10 minutes, then 60*24/10 = 144
atopsar -R 144

# Get all known data for CPU usage, summarized per day
for atopfile in `ls /var/log/atop/atop_20210*`; do atopsar -c -r $atopfile -R 144; done

# Just yesterday
atopsar -c -r y
```