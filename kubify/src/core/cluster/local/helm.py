from avionix import ChartBuilder, ChartDependency, ChartInfo, ObjectMeta
from avionix.kube.apps import Deployment, DeploymentSpec, PodTemplateSpec
from avionix.kube.core import Container, ContainerPort, EnvVar, LabelSelector, PodSpec
from src.core.cluster.local.kind import api_version


from pyhelm.chartbuilder import ChartBuilder
from pyhelm.tiller import Tiller


def install_chart(
    TILLER_HOST, name, type, location, dry_run=False, namespace="default"
):
    tiller = Tiller(TILLER_HOST)
    chart_json = {"name": name, "source": {"type": type, "location": location}}

    chart = ChartBuilder(chart_json)
    # chart = ChartBuilder({"name": "nginx-ingress", "source": {"type": "repo", "location": "https://kubernetes-charts.storage.googleapis.com"}})
    tiller.install_release(chart.get_helm_chart(), dry_run=dry_run, namespace=namespace)


def init():
    # helm init
    # helm init --output json
    pass


def deployment():
    container = Container(
        name="test-container",
        image="k8s.gcr.io/echoserver:1.4",
        env=[EnvVar("test", "test-value")],
        ports=[ContainerPort(8080)],
    )

    deployment = Deployment(
        metadata=ObjectMeta(name="test-deployment", labels={"app": "my_app"}),
        spec=DeploymentSpec(
            replicas=1,
            template=PodTemplateSpec(
                ObjectMeta(labels={"app": "my_app"}),
                spec=PodSpec(containers=[container]),
            ),
            selector=LabelSelector(match_labels={"app": "my_app"}),
        ),
    )

    # builder = install_chart (api_version="3.2.4", name="test", version="0.1.0", app_version="v1", deployment=[deployment])


# def install_chart(api_version="3.2.4", name="test", version="0.1.0", app_version="v1",[deployment]):
#     builder = ChartBuilder(
#         ChartInfo(
#             api_version=api_version,
#             name=name,
#             version=version,
#             app_version=app_version,
#             dependencies= dependencies, #[
#             #     ChartDependency(
#             #         "grafana",
#             #         "5.5.2",
#             #         "https://charts.helm.sh/stable",
#             #         "stable",
#             #         values={"resources": {"requests": {"memory": "100Mi"}}},
#             #     ),
#             #     ChartDependency(
#             #         "local-chart",
#             #         "0.1.0",
#             #         "file:///path/to/my/local-chart",
#             #         "local-repo",
#             #         is_local=True,
#             #     ),
#             # ],
#         ),
#         [],
#     )
#     builder.install_chart({"dependency-update": None})

# from pyhelm.chartbuilder import ChartBuilder
# from pyhelm.tiller import Tiller

# from pyhelm.chartbuilder import ChartBuilder
# from pyhelm.tiller import Tiller


# def install_chart(name="nginx-ingress", dry_run=False):
#     chart = ChartBuilder({'name': 'mongodb', 'source': {'type': 'directory', 'location': '/tmp/pyhelm-kibwtj8d/mongodb'}})
#     t.install_release(chart.get_helm_chart(), dry_run=False, namespace='default')
#     # tiller = Tiller(TILLER_HOST)
#     # chart = ChartBuilder({"name": name, "source": {"type": "repo", "location": "https://kubernetes-charts.storage.googleapis.com"}})
#     # tiller.install_release(chart.get_helm_chart(), dry_run=dry_run, namespace='default')
