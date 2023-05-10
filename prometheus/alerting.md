# Alerting

## Important on HA

To create a highly available (HA) setup for alerting, you can still run two identically configured Prometheus servers computing the same alerts (the Alertmanager will **deduplicate** notifications)

## Example

For example, the following alerting rule (loaded into Prometheus as part of a rule configuration file) would alert you if the number of HTTP requests that resulted in a 500 status code exceeded 5% of the total traffic for a given path:

```yaml
alert: Many500Errors
# This is the PromQL expression that forms the "heart" of the alerting rule.
expr: |
  (
      sum by(path) (rate(http_requests_total{status="500"}[5m]))
    /
      sum by(path) (rate(http_requests_total[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: "critical"
annotations:
  summary: "Many 500 errors for path {{$labels.path}} ({{$value}}%)"
```
