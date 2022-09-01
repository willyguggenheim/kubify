"""_summary_

Raises:
    Exception: _description_

Returns:
    _type_: _description_
"""
from pprint import pprint
from pick import pick  # install pick using `pip install pick`

# from functools import partial
import logging
from kubernetes import client, config, watch

# from kubernetes.client import configuration
from kubeconfig import KubeConfig

# import time
# import kubernetes.client
from kubernetes.client.rest import ApiException

# import docker
# import kubify.src.core.app_constants as app_constants

_logger = logging.getLogger()


class K8SUtils:
    """_summary_

    Raises:
        Exception: _description_

    Returns:
        _type_: _description_
    """

    configuration = client.Configuration()
    # Configure API key authorization: BearerToken
    configuration.api_key["authorization"] = "YOUR_API_KEY"
    # Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
    # configuration.api_key_prefix['authorization'] = 'Bearer'

    # Defining host is optional and default to http://localhost
    configuration.host = "http://localhost"

    def __init__(self):
        self.conf = KubeConfig()
        conf_view = self.conf.view()
        if conf_view["contexts"]:
            self.namespace = conf_view["contexts"][0]["context"]["namespace"]
        else:
            self.namespace = "default"
        # config.load_kube_config()
        self.api_client = client.AppsV1Api()
        self.api_instance = client.CoreV1Api()

    def get_service_pod(self, pod_name):
        try:
            watching = watch.Watch()
            count = 10
            for event in watching.stream(
                self.api_client.read_namespaced_deployment_status(
                    pod_name, self.namespace
                ),
                timeout_seconds=10,
            ):
                print(
                    f"Event - Message: {event['object']['message']} \
                    at {event['object']['metadata']['creationTimestamp']}"
                )
                count -= 1
                if not count:
                    watching.stop()
            print("Finished namespace stream.")
            api_response = self.api_instance.read_namespaced_pod_log(
                name=pod_name, namespace=self.namespace
            )
            print(api_response)
        except ApiException as error:
            print(
                "Exception when calling AppsV1Api->read_namespaced_deployment_status: %s\n"
                % error
            )

    def get_entrypoint(self):
        # check if cluster
        # $ kubectl config view -o jsonpath='{.contexts[*].name}'
        # $ echo $?
        # 0
        # "kubectl --namespace default rollout status -w deployment/entrypoint
        #   $KUBECTL_NS rollout status -w deployment/entrypoint &> /dev/null
        #   echo $(${KUBECTL_NS} get pods -o wide --field-selector=status.phase=Running -l role=entrypoint --no-headers | cut -d ' ' -f1 | head -n 1)
        deployment_name = "deployment/entrypoint"
        try:
            api_response = self.api_client.read_namespaced_deployment_status(
                deployment_name, self.namespace
            )
            pprint(api_response)
            return api_response
        except ApiException as error:
            print(
                f"ApiException when calling AppsV1Api->read_namespaced_deployment_status: {error}"
            )
            return None
        except Exception as error:
            print(
                f"Exception when calling AppsV1Api->read_namespaced_deployment_status: {error}"
            )
            return None

    def set_context_get_client(self, context_name="default"):
        contexts, active_context = config.list_kube_config_contexts()
        if not contexts:
            print("Cannot find any context in kube-config file.")
            return None
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

    def set_context_kind_kind(self):
        # check if exists if not create
        _logger.debug("set_context_kind_kind")
        contexts, active_context = config.list_kube_config_contexts()
        _logger.debug(f"set_context_kind_kind {contexts} {active_context}")
        if not contexts:
            _logger.warning("Cannot find any context in kube-config file.")
            raise Exception("Cannot find any context in kube-config file.")
        _logger.debug("set_context_kind_kind reduce contexts to names")
        contexts = [context["name"] for context in contexts]
        if "kind-kind" not in contexts:
            raise (
                Exception(
                    "kind-kind context not found, \
                    you need to install kind-kind, \
                    this should already be installed!?!"
                )
            )
        _logger.debug("set_context_kind_kind check if active_context is kind-kind")
        if active_context["name"] != "kind-kind":
            _logger.info("set_context_kind_kind setting active_context to kind-kind")
            config.load_kube_config(context="kind-kind")
            # check again self.set_context_kind_kind() ?
        _logger.info(f"set_context_kind_kind active_context is kind-kind")
        # active_index = contexts.index(active_context["name"])
        # for context in contexts:
        #     print(context)
