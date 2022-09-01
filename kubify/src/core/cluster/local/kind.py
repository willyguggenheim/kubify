# from curses import meta
import logging
import operator
import re
from kubernetes import client, config
import time
from kubernetes.client.rest import ApiException
import pykube

config = pykube.KubeConfig.from_file()
api = pykube.HTTPClient(pykube.KubeConfig.from_file())
api = pykube.HTTPClient(config)


def api_version():
    logging.info(api.version)


def list_deploy_objects(api):
    list(pykube.Deployment.objects(api))


# Query for all ready pods in a custom namespace:
def query_pods(namespace):
    pykube_api = pykube.HTTPClient(pykube.KubeConfig.from_file())
    pods = pykube.Pod.objects(pykube_api).filter(namespace=namespace)
    ready_pods = filter(operator.attrgetter("ready"), pods)
    return ready_pods


# Access any attribute of the Kubernetes object:
def get_pod_object(namespace, pod_name, pykube_api):
    pod = pykube.Pod.objects(pykube_api).filter(namespace=namespace).get(name=pod_name)
    pod.obj["spec"]["containers"][0]["image"]


def deploy_obj(pykube_api, obj):
    pykube.Deployment(pykube_api, obj).create()


def delete_obj(pykube_api, obj):
    pykube.Deployment(pykube_api, obj).delete()


def get_namespaces():
    # Load the connection config, default behaviour is to load ~/.kube/config
    # For development this is fine, when moving into production another way
    # of providing the config is required
    config.load_kube_config()

    v1 = client.CoreV1Api()
    nameSpaceList = v1.list_namespace()
    for nameSpace in nameSpaceList.items:
        logging.info(nameSpace.metadata.name)
    return nameSpaceList


def get_api_resources():
    config.load_kube_config()
    api_resource_names = []
    a = ""
    for api in client.ApisApi().get_api_versions().groups:

        versions = []
        for v in api.versions:
            name = ""
            if v.version == api.preferred_version.version and len(api.versions) > 1:
                name += "*"
            name += v.version
            versions.append(name)
        api_name_version = f"{api.name},".join(versions)
        logging.info(api_name_version)
        api_resource_names.append(api_name_version)
    return api_resource_names


def create_namespaced_deployment(
    deployment_name, deployment_manifest, namspace="default"
):
    api_client = client.ApiClient(config)
    v1 = client.AppsV1Api(api_client)
    response = v1.create_namespaced_deployment(
        body=deployment_manifest, namespace=namspace
    )
    while True:
        try:
            response = v1.read_namespaced_deployment_status(
                name=deployment_name, namespace=namspace
            )
            if response.status.available_replicas != 3:
                logging.info("Waiting for Deployment to become ready...")
                time.sleep(5)
            else:
                break
        except ApiException as e:
            logging.error(
                f"Exception when calling AppsV1Api -> read_namespaced_deployment_status: {e}\n"
            )


def get_cluster_id(name="kube-system"):
    metadata = client.V1ObjectMeta(name=name)
    return metadata.uid
    # cluster_context = config.kube_config.list_kube_config_contexts()
    # print (cluster_context)


def get_cluster_name():
    #  <class 'kubernetes.client.models.v1_config_map.V1ConfigMap'
    cm = K8sConfigMap.get_cm("kube-system")
    for item in cm.items:
        if "kubeadm-config" in item.metadata.name:
            if "clusterName" in item.data["ClusterConfiguration"]:
                cluster_name = re.search(
                    r"clusterName: ([\s\S]+)controlPlaneEndpoint",
                    item.data["ClusterConfiguration"],
                ).group(1)
                print("\nCluster name: {}".format(cluster_name))
