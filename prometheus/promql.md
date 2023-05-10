# PromQL

The following selects the total count of all handled HTTP requests that resulted in a 500 status code:

```promql
http_requests_total{status="500"}
```

The following gives you the **per-second rate** of increase for each series, as **averaged over a window of 5 minutes**:

```promql
rate(http_requests_total{status="500"}[5m])
```

And you can calculate the ratio of status="500" errors to the total rate of requests grouped by HTTP path like this:

```promql
sum by(path) (rate(http_requests_total{status="500"}[5m]))
/
sum by(path) (rate(http_requests_total[5m]))
```

This expression shows you the number of samples ingested per second as averaged over a 1-minute window:

```promql
rate(prometheus_tsdb_head_samples_appended_total[1m])
```

This shows the value of the synthetic up metric that Prometheus records for every target scrape, in this case, scoped to just the `prometheus` job:

```promql
up{job="prometheus"}
```