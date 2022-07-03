from kubernetes import client, config, watch
from kubernetes.client import configuration
from kubeconfig import KubeConfig
import time
import kubernetes.client
from kubernetes.client.rest import ApiException
from pprint import pprint
from pick import pick  # install pick using `pip install pick`
from functools import partial


class k8s_utils:
    configuration = kubernetes.client.Configuration()
    # Configure API key authorization: BearerToken
    configuration.api_key["authorization"] = "YOUR_API_KEY"
    # Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
    # configuration.api_key_prefix['authorization'] = 'Bearer'

    # Defining host is optional and default to http://localhost
    configuration.host = "http://localhost"

    def __init__(self):
        self.conf = KubeConfig()
        conf_view = self.conf.view()
        if "namespace" in conf_view["contexts"][0]["context"]:
            self.namespace = conf_view["contexts"][0]["context"]["namespace"]
        else:
            self.namespace = "default"
        config.load_kube_config()
        self.api_client = client.AppsV1Api()
        self.api_instance = client.CoreV1Api()

    def get_service_pod(self, pod_name):
        try:
            w = watch.Watch()
            count = 10
            for event in w.stream(
                self.api_client.read_namespaced_deployment_status(
                    pod_name, self.namespace
                ),
                timeout_seconds=10,
            ):
                print(
                    f"Event - Message: {event['object']['message']} at {event['object']['metadata']['creationTimestamp']}"
                )
                count -= 1
                if not count:
                    w.stop()
            print("Finished namespace stream.")
            api_response = self.api_instance.read_namespaced_pod_log(
                name=pod_name, namespace=self.namespace
            )
            print(api_response)
        except ApiException as e:
            print(
                "Exception when calling AppsV1Api->read_namespaced_deployment_status: %s\n"
                % e
            )

    def get_entrypoint(self):
        deployment_name = "deployment/entrypoint"
        try:
            api_response = self.api_client.read_namespaced_deployment_status(
                deployment_name, self.namespace
            )
            pprint(api_response)
            return api_response
        except ApiException as e:
            print(
                "Exception when calling AppsV1Api->read_namespaced_deployment_status: %s\n"
                % e
            )
            return None

    def set_context_get_client(self, context_name="default"):
        contexts, active_context = config.list_kube_config_contexts()
        if not contexts:
            print("Cannot find any context in kube-config file.")
            return
        contexts = [context["name"] for context in contexts]
        active_index = contexts.index(active_context["name"])

        cluster, first_index = pick(
            contexts, title="Pick the first context", default_index=active_index
        )

        api_client2 = client.CoreV1Api(
            api_client=config.new_client_from_config(context=cluster)
        )

        print("\nList of pods on %s:" % cluster)
        for i in api_client2.list_pod_for_all_namespaces().items:
            print(
                "%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name)
            )

        return api_client2
