# Relabeling

Often it is useful to be able to manipulate or filter these objects based on their label values. For example, we might want to:

- Only **monitor certain targets** that have a specific service discovery annotation that indicates that they should be scraped.
- **Add an HTTP query parameter** to the scrape request for a target.
- Only store a filtered **subset of the samples** scraped from a given target.
- **Remove a replica label** from alerts sent to the Alertmanager (so that identical alerts sent from a high availability Prometheus can be deduplicated in the Alertmanager).
- **Combine two label values** of a scraped series into a single label (or vice versa).

**Relabeling** is a concept that allows the Prometheus administrator to configure these kinds of transformation and filtering rules.

Relabeling is implemented as a series of transformation steps that you can apply in different sections of the Prometheus configuration file to filter or modify a list of labeled objects. You can apply relabeling to the following types of labeled objects:

- Discovered **scrape targets** (relabel_configs section in a [scrape_config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) section).
- Individual **samples from scrapes** (metric_relabel_configs section in a [scrape_config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) section).
- **Alerts** sent to the Alertmanager (alert_relabel_configs section in the [alertmanager_config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alertmanager_config) section).
- **Samples written to remote storage systems** (write_relabel_configs section in the [remote_write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) section).

## Hidden Labels

Labels starting with a double underscore (`__`) are treated specially in that they are removed after relabeling. A source of labeled objects (such as a service discovery mechanism producing labeled targets) may initially attach these "hidden" labels to provide extra metadata about a labeled object. These special labels can be used during the relabeling phase to make decisions or changes to the object's labels.

## Scrape Control Labels

For targets, some of these hidden labels have a special meaning and control how a target should be scraped:

- `__address__`: Contains the TCP address that should be scraped for the target. It initially defaults to the `<host>:<port>` pair provided by the service discovery mechanism. Prometheus sets the instance label to the value of `__address__` after relabeling if you do not set the `instance` label explicitly to another value before that.
- `__scheme__`: Contains the HTTP scheme (http or https) with which the target should be scraped. Defaults to `http`.
- `__metrics_path__`: Contains the HTTP path to scrape metrics from. Defaults to `/metrics`.
- `__param_<name>`: Contains HTTP query parameter names and their values.

Each of these labels can be set or overwritten using relabeling rules to produce custom scrape behaviors for individual targets.

## Service Discovery Metadata Labels

Additionally, service discovery mechanisms can provide a set of labels starting with `__meta_` that contain discovery-specific metadata about a target. For example, when discovering pods in a Kubernetes cluster, the Kubernetes service discovery engine will provide a `__meta_kubernetes_pod_name` label for each pod target, containing the name of the discovered pod, and a `__meta_kubernetes_pod_ready` label indicating whether the pod is in the ready state or not. You can find all the labels that the Kubernetes service discovery provides in the [configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config).

## Temporary Labels

If a relabeling step needs to save a value to a temporary label (to be processed in a subsequent relabeling step), you can use the `__tmp` label name prefix. Labels starting with `__tmp` are guaranteed to **never** be used by Prometheus itself.

## Relabeling Rule Fields

Relabeling rules generally have the following configuration fields, but for each type of `action` (relabeling rule type), only a subset of these fields are used:

- `action`: The desired relabeling action to execute (`replace`, `keep`, `drop`, `hashmod`, `labelmap`, `labeldrop`, or `labelkeep`). Defaults to `replace`.
- `source_labels`: A list of label names that are concatenated using the configured separator string and matched against the provided regular expression.
- `separator`: A string with which to separate source labels when concatenating them. Defaults to `";"`.
- `target_label`: The name of the label that should be overwritten when using the `replace` or `hashmod` relabel actions.
- `regex`: The regular expression to match against the concatenated source labels. Defaults to `"(.*)"` to match any source labels.
- `modulus`: The modulus to take of the hash of the concatenated source labels. Useful for horizontal sharding of Prometheus setups.
- `replacement`: A replacement string that is written to the `target_label` label for `replace` relabel actions. It can refer to regular expression capture groups that were captured by `regex`.

## Use Case Examples

Let's look at some example use cases for the `replace` action.

### Setting a Fixed Label Value

The simplest replace example is just setting a label to a fixed value. For example, you could set the env label to the value production like this:

```yaml
action: replace
replacement: production
target_label: env
```

Note that we don't even have to set most of the rule's fields, since the defaults already work well for this case (matching the entire source label and using that as the replacement string).

### Replacing the Scrape Port

A more involved example is overriding the port that an instance is scraped on. You can replace the `__address__` label's port with the fixed port `80` like this:

```yaml
action: replace
source_labels: [__address__]
regex: ([^:]+)(?::\d+)?   # The first group matches the host, the second matches the port.
replacement: '$1:80'
target_label: __address__
```

## Mapping Labelsets

Sometimes you may want to take a whole set of source labels and map their values into a new set of differently prefixed new label names. The labelmap action allows this. The most common use case for labelmap is taking a group of hidden/temporary metadata labels from service discovery and mapping them into permanent target labels.

**Rule Structure:**

A `labelmap` relabeling rule has the following structure:

```yaml
action: labelmap
regex: <regular expression>               # Defaults to '(.*)' (matching any value)
replacement: <replacement string>         # Defaults to '$1' (using the first capturing group as a replacement)
```

In contrast to the previous relabeling actions we learned about, the `labelmap` action regex-matches and acts on label names, not label values.

The `labelmap` action performs the following steps, in sequence:

1. It matches the regular expression in `regex` against all label names.
2. It then copies any matching values of matching label names to new label names that are determined by the replacement string, after substituting any reference ($1, $2, ...) to capturing groups in replacement.

### Example: Mapping Kubernetes Service Labels

When using Kubernetes-based service discovery to discover pod endpoints, you may want the final target labels for each endpoint to also contain the Kubernetes service labels. The Kubernetes service discovery provides these in a set of labels with the naming pattern `__meta_kubernetes_service_label_<labelname>`. We can extract the `<labelname>` part of those metadata labels and map the corresponding label values over to a new set of label names that start with a k8s_ prefix, like this:

```yaml
action: labelmap
regex: __meta_kubernetes_service_label_(.+)
replacement: 'k8s_$1'
```

## Keeping and Dropping Labels

Less frequently, you may want to keep or drop individual labels from an object. For example, some targets supply a lot of unnecessary extra (non-identifying) labels on time series that are not interesting later on and just pollute both the TSDB and querying use cases. The labelkeep and labeldrop actions allow us to selectively keep or drop some labels.

**Rule Structure:**

A `labelkeep` relabeling rule has the following structure:

```yaml
action: labelkeep
regex: <regular expression>  # Defaults to '(.*)' (matching any value)
```

The `labelkeep` action performs the following steps, in sequence:

1. It matches the regular expression in regex against all label names.
2. It keeps only those labels that match.

The labeldrop action works like labelkeep, but drops a label rather than keeping it.

### Example - Removing HA Replica Labels from Alerts

When running two identical Prometheus servers as a highly available (HA) pair, often both servers are configured to have an external label (via the global configuration option external_labels) that indicates which replica they represent, e.g. replica: A and replica: B. Before sending alerts to the same Alertmanager instance from both replicas, Prometheus needs to remove this replica label so that Alertmanager does not interpret the incoming alerts as different (otherwise, you will get two notifications for the same alert!).

You can achieve that with the following labeldrop rule:

```yaml
action: labeldrop
regex: replica
```

### Example - Removing Unneeded Labels from Metrics

Some targets (like cAdvisor in the past) attach extra labels to each time series that are not necessary to uniquely identify each series, but just provide extra information about the target or series that you may not want to store.

To remove any labels starting with info_, you could write a rule like this:

```yaml
action: labeldrop
regex: info_.*
```
