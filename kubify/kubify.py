"""Main module."""
from kubernetes import client, config
from kubernetes.client import configuration
from pick import pick  # install pick using `pip install pick`

import os




def list_contexts():
    contexts, active_context = config.list_kube_config_contexts()
    if not contexts:
        print("Cannot find any context in kube-config file.")
        return
    contexts = [context['name'] for context in contexts]
    return contexts

def set_context_get_client(context_name='default'):
    contexts=list_contexts()
    
    if context_name == 'default':
        contexts, active_context = config.list_kube_config_contexts()
        active_index = contexts.index(active_context['name'])
        cluster, first_index = pick(contexts, title="Pick the first context",
                                    default_index=active_index)
    else:
        active_index = contexts.index(context_name)
        cluster, first_index = pick(contexts, title="Pick the first context",
                                    default_index=active_index)
        
    
    client = client.CoreV1Api(
        api_client=config.new_client_from_config(context=cluster))
    

    print("\nList of pods on %s:" % cluster)
    for i in client.list_pod_for_all_namespaces().items:
        print("%s\t%s\t%s" %
              (i.status.pod_ip, i.metadata.namespace, i.metadata.name))

    return client


if __name__ == '__main__':
    set_context_get_client(os.environ.get('K8S_OVERRIDE_CONTEXT', 'default'))
    # main()