# Prometheus - Introduction

## References

- [Prometheus Course](https://training.promlabs.com/training/introduction-to-prometheus/prometheus-an-overview/system-architecture)

## Architecture

An organization will typically run one or more Prometheus servers, which form the heart of a Prometheus monitoring setup. 
A Prometheus server is configured to discover a set of metrics sources (so-called "**targets**") using service-discovery mechanisms such as **DNS**, Consul, **Kubernetes**, or others.
Prometheus then periodically pulls (or "**scrapes**") **metrics** in a text-based format from these targets over HTTP and stores the **collected data in a local time series database**. 
A target can either be an application that directly tracks and exposes Prometheus metrics about itself or an intermediary piece of software (a so-called "**exporter**") that **translates metrics from an existing system (like a MySQL server) into the Prometheus metrics exposition format.** 
The Prometheus server then makes the collected data available for queries, either via its built-in web UI, using dashboarding tools such as Grafana, or by direct use of its HTTP API.

> Note: Each scrape only transfers the **current value of every time series of a target to Prometheus**, so the scrape interval determines the final sampling frequency of the stored data. **The target processes do not retain any historical metrics data themselves**.

You can also configure the Prometheus server to generate alerts based on the collected data. However, **Prometheus does not send alert notifications directly to humans. Instead, it forwards the raw alerts to the Prometheus Alertmanager, which runs as a separate service**. The Alertmanager may receive alerts from multiple (or all) Prometheus servers in the organization, and provides a central place to group, aggregate, and route those alerts. Finally, it sends out notifications via email, Slack, PagerDuty, or other notification services.

## Data Model

Prometheus stores time series: streams of timestamped values. These streams have an identifier and a set of sample values.

<                 Time series identifier               >    <       samples          >
`http_requests_total{job="nginx",instance="1.2.3.4:80"}` -> `[(t1,v1), (t2, v2), ...]`
 ^metric name         ^label name          ^label value        ^timestamp    ^value


### Series identifiers

Every series is uniquely identified by a metric name and a set of key/value pairs called **labels**.

- The **metric name** identifies the overall aspect of a system that is being measured (like `http_requests_total`, the total number of HTTP requests handled by a given server process).
- **Labels** help to differentiate subdimensions (like `method="GET"` vs. `method="POST"` telling you how many requests for each HTTP method type were handled).

The metric name and labels that form the series identifiers are indexed in Prometheus's TSDB and used for looking up series when querying data.

### Series samples

Samples form the bulk data of a series and are appended to an indexed series over time:

- Timestamps are 64-bit integers in millisecond precision.
- Sample values are 64-bit floating point numbers.

### Metrics Transfer Format

Services that want to expose Prometheus metrics simply need to expose an HTTP endpoint providing metrics in Prometheus's text-based exposition format. The output of such an endpoint is human-readable and can look like this in its simplest form:

```prometheus
# HELP http_requests_total The total number of processed HTTP requests.
# TYPE http_requests_total counter
http_requests_total{status="200"} 8556
http_requests_total{status="404"} 20
http_requests_total{status="500"} 68
```

### Efficient Implementation

Prometheus needs to be able to collect detailed dimensional data from many systems and services at once. To this end, especially the following components have been highly optimized:

- Scraping and parsing of incoming metrics
- Writing to and reading from the time series database
- Evaluating PromQL expressions based on TSDB data.

As a rule of thumb, a single large Prometheus server **can ingest up to 1 million time series samples per second and uses 1-2 bytes for the storage of each sample on disk**. It can handle several million concurrently active (present in one scrape iteration of all targets) time series at once.

### Sample configuration

Save the following Prometheus configuration as a file named prometheus.yml in the current directory (overwrite the existing example prometheus.yml file):

```
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

This configures Prometheus to scrape metrics from itself every 5 seconds.

The `global` section configures certain global settings and default values, whereas the `scrape_configs` section tells Prometheus which targets to scrape. In our case, we are enumerating targets manually (in a `<host>:<port>` format) using the `static_configs` directive, but most production setups would use one or more service discovery integrations to discover targets.

> Note: A 5-second scrape interval is quite aggressive, but useful for demo purposes where you want data to be available quickly. In real-world scenarios, intervals between 10 and 60 seconds are more common.

By default, Prometheus stores its database in the `./data` directory (this can be configured using the flag `--storage.tsdb.path`) and reads its configuration from the file `prometheus.yml` (flag `--config.file`).

NOTE: Any settings provided via the configuration file are reloadable during runtime (by sending a `HUP` signal), while any changes to flag-based settings require a full server restart to take effect.

Prometheus should start up and show a status page about itself at `http://<machine-ip>:9090/`. Give it a couple of seconds to collect data about itself from its own HTTP metrics endpoint.

You can also verify that Prometheus is serving metrics about itself by navigating to its metrics endpoint: `http://<machine-ip>:9090/metrics`

### Health check

When setting up a new Prometheus server, it's good practice to check whether it is scraping all of its targets correctly.

Navigate to `http://<machine-ip>:9090/targets` to view a list of all targets, grouped by their scrape configuration in the Prometheus server configuration file.

In case anything goes wrong during a scrape (whether this is due to a DNS resolution failure, a connection timeout, a bad metrics payload format, or something else), the target would be shown as **DOWN**, along with an error message providing more detail about the scrape failure. This is helpful for quickly spotting misconfigurations or finding unhealthy targets.

