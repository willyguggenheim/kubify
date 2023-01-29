from pathlib import Path

import pytest

from .cluster import KindCluster


@pytest.fixture(scope="session")
def kind_cluster(request):
    """Provide a Kubernetes kind cluster as test fixture."""
    name = request.config.getoption("cluster_name")
    keep = request.config.getoption("keep_cluster")
    kubeconfig = request.config.getoption("kubeconfig")
    image = request.config.getoption("kind_image")
    kind_path = request.config.getoption("kind_bin")
    kubectl_path = request.config.getoption("kind_kubectl_bin")
    cluster = KindCluster(
        name,
        Path(kubeconfig) if kubeconfig else None,
        image=image,
        kind_path=Path(kind_path) if kind_path else None,
        kubectl_path=Path(kubectl_path) if kubectl_path else None,
    )
    cluster.create()
    yield cluster
    if not keep:
        cluster.delete()


def pytest_addoption(parser):
    group = parser.getgroup("kind")
    group.addoption(
        "--cluster-name",
        default="pytest-kind",
        help="Name of the Kubernetes kind cluster",
    )
    group.addoption(
        "--keep-cluster",
        action="store_true",
        help="Keep the Kubernetes kind cluster (do not delete after test run)",
    )
    group.addoption(
        "--kubeconfig",
        default=None,
        help=(
            "If provided, use the specified kubeconfig "
            "instead of the one generated by the cluster"
        ),
    )
    group.addoption(
        "--kind-image",
        default=None,
        action="store",
        type=str,
        help=(
            "If provided, use the specified docker image "
            "instead of the default one. (e.g. kindest/node:v1.20.2)"
        ),
    )
    group.addoption(
        "--kind-bin",
        default=None,
        action="store",
        type=str,
        help=(
            "If provided, use the specified kind binary instead of "
            "downloading one. Takes a filesystem path string."
        ),
    )
    group.addoption(
        "--kind-kubectl-bin",
        default=None,
        action="store",
        type=str,
        help=(
            "If provided, use the specified kubectl binary instead of "
            "downloading one. Takes a filesystem path string."
        ),
    )