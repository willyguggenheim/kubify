## KindCluster object

The `kind_cluster` fixture is an instance of the KindCluster class with the following methods:

* `load_docker_image(docker_image)`: load the specified Docker image into the kind cluster
* `kubectl(*args)`: run the `kubectl` binary against the cluster with the specified arguments. Returns the process output as string.
* `port_forward(service_or_pod_name, remote_port, *args)`: run "kubectl port-forward" for the given service/pod and return the (random) local port. To be used as context manager ("with" statement). Pass the namespace as additional args to kubectl via "-n", "mynamespace".

KindCluster has the following attributes:

* `name`: the kind cluster name
* `kubeconfig_path`: the path to the Kubeconfig file to access the cluster
* `kind_path`: path to the `kind` binary
* `kubectl_path`: path to the `kubectl` binary
* `api`: [pykube](https://pykube.readthedocs.io/) HTTPClient instance to access the cluster from Python

You can also use KindCluster directly without pytest:

```python
from pytest_kind import KindCluster

cluster = KindCluster("myclustername")
cluster.create()
cluster.kubectl("apply", "-f", "..")
# ...
cluster.delete()
```


## Pytest Options

The kind cluster name can be set via the `--cluster-name` CLI option.

The kind cluster is deleted after each pytest session, you can keep the cluster by passing `--keep-cluster` to pytest.

Note that you can use the `PYTEST_ADDOPTS` environment variable to pass these options to pytest. This also works if you call pytest from a Makefile:

```bash
# for test debugging: don't delete the kind cluster
PYTEST_ADDOPTS=--keep-cluster make test
```


## Notes

* The `kind_cluster` fixture is session-scoped, i.e. the same cluster will be used across all test modules/functions.
* The `kind` and `kubectl` binaries will be downloaded once to the local directory `./.pytest-kind/{cluster-name}/`. You can use them to interact with the cluster (e.g. when `--keep-cluster` is used).
* Some cluster pods might not be ready immediately (e.g. kind's CoreDNS take a moment), add wait/poll functionality as required to make your tests predictable.
