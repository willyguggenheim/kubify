#!/usr/bin/python3

import traceback
import argparse
import os
import json
from os.path import isdir, isfile, join
import git
import platform
from pathlib import Path
import boto3
import sys
import distutils
import time
import subprocess
from subprocess import PIPE
from git import Repo

repo = Repo.init(os.getcwd())

APP_VERSION = ""
AWS_REGION="us-west-2"
AWS_PROFILE="default"
AWS_REGION
AWS_PROFILE = ""
HOME = ""
ADDR = ""
NPM_TOKEN = ""
K8_NPM_TOKEN = ""
TF_BACKEND_CREDENTIALS = ""
DIR = ""
SRC_DIR = ""
KUBIFY_CURRENT_VERSION = ""
WORK_DIR = ""
K8S_DIR = ""
SKAFFOLD_UPDATE_CHECK = ""
ENV = ""
USER = ""
DIR = ""
KUBIFY_ENGINE = "local"
KUBIFY_CI = ""
KUBIFY_VERBOSE = ""
KUBIFY_DEBUG = ""
KUBIFY_ENTRYPOINT_IMAGE = ""
KUBIFY_CONTAINER_REGISTRY = ""
KUBIFY_LOCAL_DOMAIN_SUFFIX = ""
KUBIFY_LOCAL_DOMAIN = ""
KUBIFY_UPSTREAM_DOMAIN_SUFFIX = ""
KUBIFY_UPSTREAM_ENV_ACCOUNT = ""
KUBIFY_NPM_CREDENTIALS_SECRET = ""
PUBLISH_IMAGE_REPO_PREFIX = ""
BASE64_DECODE = ""
MINIKUBE     = ""
PROFILE = ""
MINIKUBE_DISK_SIZE = ""
MINIKUBE_MEMORY = ""
MINIKUBE_ADDONS = ""
MINIKUBE_VM_DRIVER = ""
SRC_MOUNT = ""
HOME_MOUNT = ""
BUILD_PROFILE = ""
LOCAL_START_PROFILE = ""
LOCAL_RUN_PROFILE = ""
NAMESPACE = ""
KUBECTL = ""
HELM = ""
KUBECTL_NS = ""
MANIFESTS = ""
TILLERLESS = ""
UPSTREAM = ""
SKAFFOLD = ""
DOCKER = ""
USER_NAME = ""
ALL_ENV = ""
AWS_ADMIN_PROFILE = ""
AWS_ACCOUNT_NUMBER = ""
DEV_KMS = ""
TEST_KMS = ""
STAGE_KMS = ""
PROD_KMS = ""
BGPID1 = ""
BGPID2 = ""

parser = argparse.ArgumentParser(prog='kubify', formatter_class=argparse.RawDescriptionHelpFormatter, description=fr"""
Kubify is a CLI tool to manage the development and deployment lifecycle of microservices.

Usage:
    kubify [command]

Quickstart:
    kubify up
    cd <your-app>
    kubify start

Available Commands:
    dir               List the full path of the kubifyk8 directory or any of the services
                      cd $(kubify dir foundation)     # Change to the foundation directory
                      cd $(kubify dir)                # Change to the kubifyk8 directory

    check             Perform some sanity checks

    up                Start the local cluster

    down              Stop the local cluster

    delete            Delete the local cluster

    status            Show the status of the local cluster

    services          List all the services

    images            List the Docker images

    clean             Purges/clears any caches
                      kubify clean

                      - Removes cached docker images (Minikube)
                      - Removes unused application images

    ps                List the running services

    logs              Tail the logs of all applications
                      kubify logs

    new               Create a new application from a template
                      kubify new {{ app_type }} {{ app_name }}

    secrets           Import, create, edit or view secrets per app per environment
                      kubify secrets <export/import/create/view/edit> {{ env }}

                      export: Write the encrypted secrets to AWS secrets manager
                      import: Read the secrets from AWS secrets manager and write to secrets locally
                      create: Create an empty version-controlled secrets le
                      view:   View the entries in cleartext for version-controlled secrets
                      edit:   Edit the entries for version-controlled secrets

    start             Start the app locally for local development (Watch changes)
                      kubify start

    run               Run the app locally
                      kubify run [<app_version>]

    run-all           Run a list of services in one-shot locally
                      kubify run-all [[service1]:[tag]] [[service2]:[tag]] ...
                      OR
                      kubify run-all

                    Example:
                      kubify run-all kubify foundation

    stop              Stop the app locally
                      kubify stop

    stop-all          Stop a list of services in one-shot locally
                      kubify stop-all [service1] [service2] ... [service_N]
                      OR
                      kubify stop-all

                    Example:
                      kubify stop-all kubify foundation

    cmd               Run a command/shell in the current application
                      kubify cmd [<cmd_name> [<options>]]

    url               Get the URL for the current service
                      kubify url

    exec              Run a command/shell in the entrypoint container
                      kubify exec [<cmd_name> [<options>]]

    environments      Get information/logs about environments
                      list:         List all the environments
                      logs:         Tail logs for an application in an environment
                                      Example: kubify environments logs dev kubify
                      view:         View the details for a given environment
                                      Example: kubify environments view dev
                      status:       View the deployment status for a given environment
                                      Example: kubify environments status dev
                      diff:         Compare two environments to see differences in deployed images and configs
                                      Examples:
                                        kubify environments diff stage prod                       # Compare entire environment
                                        kubify environments diff stage prod "kubify,foundation"    # Compare kubify and foundation
                      get-context:  Switch the kubectl context to the environment
                                      Example: kubify environments get-context dev

Flags (Enable: 1; Disable: 0):
    KUBIFY_VERBOSE      Toggle verbose logging
    KUBIFY_DEBUG        Toggle verbose plus show every command (extra verbose)
    KUBIFY_ENGINE       The kubernetes engine to use (Supported: local (default), minikube)
    KUBIFY_PROFILE      The kubernetes profile to use (Advanced)

Troubleshooting:
    ** If you are experiencing issues, please post the output of kubify
     in the 'devops' channel with verbose mode enabled.""")
sp = parser.add_subparsers()
sp_dir = sp.add_parser("dir", help="List the full path of the kubifyk8 directory or any of the services")
sp_check = sp.add_parser("check", help="Perform some sanity checks")
sp_up = sp.add_parser("up", help="Start the local cluster")
sp_down = sp.add_parser("down", help="Stop the local cluster")
sp_delete = sp.add_parser("delete", help="Delete the local cluster")
sp_status = sp.add_parser("status", help="Show the status of the local cluster")
sp_services = sp.add_parser("services", help="List all the services")
sp_images = sp.add_parser("images", help="List the Docker images")
sp_clean = sp.add_parser("clean", help="Purges/clears any caches")
sp_ps = sp.add_parser("ps", help="List the running services")
sp_logs = sp.add_parser("logs", help="Tail the logs of all applications")
sp_new = sp.add_parser("new", help="Create a new application from a template")
sp_secrets=sp.add_parser("secrets", help="Import, create, edit or view secrets per app per environment")
list_sp_secrets = sp_secrets.add_subparsers()
sp_secrets_export = list_sp_secrets.add_parser("export", help="Write the encrypted secrets to AWS secrets manager")
sp_secrets_import = list_sp_secrets.add_parser("import", help="Read the secrets from AWS secrets manager and write to secrets locally")
sp_secrets_create = list_sp_secrets.add_parser("create", help="Create an empty version-controlled secrets le")
sp_secrets_view = list_sp_secrets.add_parser("view", help="View the entries in cleartext for version-controlled secrets")
sp_secrets_edit = list_sp_secrets.add_parser("edit", help="Edit the entries for version-controlled secrets")
sp_start = sp.add_parser("start", help="Start the app locally for local development (Watch changes)")
sp_run = sp.add_parser("run", help="Run the app locally")
sp_run_all = sp.add_parser("run-all", help="Run a list of services in one-shot locally")
sp_stop = sp.add_parser("stop", help="Stop the app locally")
sp_stop_all = sp.add_parser("stop-all", help="Stop a list of services in one-shot locally")
sp_cmd = sp.add_parser("cmd", help="Run a command/shell in the current application")
sp_url = sp.add_parser("url", help="Get the URL for the current service")
so_exec = sp.add_parser("exec", help="Run a command/shell in the entrypoint container")
sp_environments = sp.add_parser("environments", help="Get information/logs about environments")
list_sp_environments = sp_environments.add_subparsers()                                      
sp_environments_list = list_sp_environments.add_parser("list", help="List all the environments")
sp_environments_logs = list_sp_environments.add_parser("logs", help="Tail logs for an application in an environment")
sp_environments_view = list_sp_environments.add_parser("view", help="View the details for a given environment")
sp_environments_status = list_sp_environments.add_parser("status", help="View the deployment status for a given environment")
sp_environments_diff = list_sp_environments.add_parser("diff", help="Compare two environments to see differences in deployed images and configs")
sp_environments_get_context = list_sp_environments.add_parser("get-context", help="Switch the kubectl context to the environment")

DEBUG = None

def out(command):
    print(command)
    result = subprocess.run(command, stdout=PIPE, stderr=PIPE, universal_newlines=True, shell=True)
    print("WE MADE IT")
    print(result, result.stdout)
    data = result.stdout
    return result.stdout.rstrip()

if os.environ.get("DEBUG") == "1":
    DEBUG = 1


if len(sys.argv) == 1:
    parser.print_help()


def sh(cmd, rsrtrip = False):
    if rsrtrip:
        return subprocess.check_output(cmd, shell=True).rstrip().decode('utf-8') 
    return subprocess.check_output(cmd, shell=True).decode('utf-8') 

class switch(object):
    def __init__(self, value):
        self.value = value
        self.fall = False

    def __iter__(self):
        yield self.match
        raise StopIteration

    def match(self, *args):
        if self.fall or not args:
            return True
        elif self.value in args:
            self.fall = True
            return True
        return False


def env_var_or_default(env_var, default):
    os.environ[env_var] = os.environ.get(env_var, default)
    # print(os.environ)
    return os.environ[env_var]
    

def check_flag(_KUBIFY_VAR):
    if not _KUBIFY_VAR == "0":
        return 1 # Yes
    else:
        return 0 # No

def ensure_flag(check_flag, flag):
    if not check_flag:
        print(flag)
        sys.exit(1)

KUBIFY_OUT = "/dev/null"
ANSIBLE_VERBOSITY = 4
def read_flag_verbose(KUBIFY_DEBUG):
    if not KUBIFY_DEBUG == "0":
        #TODO set -v
        #set -v
        ANSIBLE_VERBOSITY=4
    if not KUBIFY_VERBOSE:
        KUBIFY_OUT = "/dev/stdout"

# This is a general-purpose function to ask Yes/No questions
# It keeps repeating the question until it
# gets a valid answer.
def ask(question, default='no'):
    if default is None:
        prompt = " [y/n] "
    elif default == 'yes':
        prompt = " [Y/n] "
    elif default == 'no':
        prompt = " [y/N] "
    else:
        raise ValueError(f"Unknown setting '{default}' for default.")

    while True:
        try:
            resp = input(question + prompt).strip().lower()
            if default is not None and resp == '':
                return default == 'yes'
            else:
                return distutils.util.strtobool(resp)
        except ValueError:
            print("Please respond with 'yes' or 'no' (or 'y' or 'n').\n")
            

def switch_version(version):
    if not version:
        print("No version specified!")

     # Denote current version from Git HEAD commit hash
    KUBIFY_VERSION = version
    # Compare versions
    if KUBIFY_VERSION != KUBIFY_CURRENT_VERSION:
        print(f"Switching kubify version from {KUBIFY_CURRENT_VERSION} to {KUBIFY_VERSION}")
        print(repo.git.checkout(KUBIFY_VERSION))#commit_id
    else:
        print(f"Kubify is already on version {KUBIFY_CURRENT_VERSION}")


def version(*argv):
    print(KUBIFY_CURRENT_VERSION)

def check(*argv):
    print("Docker:")
    out("which docker")
    out("docker --version")
    print("Kubernetes CLI:")
    out("which kubectl")
    out("kubectl version --client --short")
    if KUBIFY_ENGINE == "minikube":
        print("Minikube:")
        out("which minikube")
        out("minikube version")
    print("Helm:")
    out("which helm")
    out("helm version --client")
    local_env_running()

    out(f"{HELM} list")
    out(f"{KUBECTL} get crds")
    out(f"{KUBECTL} get all --all-namespaces")

    if KUBIFY_ENGINE == "minikube":
        print("DNS Info:")
        print("  Minikube IP:")
        out(f"{MINIKUBE} ip")
        print("  DNSmasq IP:")
        out(f"dig +short {KUBIFY_LOCAL_DOMAIN}")

def _not_implemented(feature):
    print("kubify {feature} not implemented yet.")
    sys.exit(1)

def _is_removed(feature):
    print(f"'kubify {feature} has been removed since it isn't necessary.")
    sys.exit(1)


def set_minikube(*argv):
    out(MINIKUBE +" profile "+ PROFILE)


def set_context(*argv):
    local_env_running()
    if KUBIFY_ENGINE == "minikube":
        set_minikube()
    elif KUBIFY_ENGINE == "local":
        print("Context already set")
    out(f"kubectx {PROFILE}")


def mount_dir(src, dest):
    set_minikube()
    out(f"{MINIKUBE} mount {src}:{dest} &")

def mount_source(*argv):
    mount_dir(SRC_DIR, SRC_MOUNT)

def mount_home(*argv):
    mount_dir(HOME, HOME_MOUNT)

def mount_aws(*argv):
    mount_dir(f"{HOME}/.aws", "/config/aws")


def start_mount(*argv):
    mount_source()
    mount_home()
    mount_aws()

def stop_mount(*argv):
    command = f"/bin/ps aux | grep \"minikube mount\" | tr -s \" \" | cut -d \" \" -f 2 | xargs kill &> {KUBIFY_OUT}"
    print(command)
    out(command)


def _build_image(IMAGE, SRC_PATH):
    set_context()
    out(f"docker build -t {IMAGE}:latest {SRC_PATH}")

def _build_entrypoint(*argv):
    _build_image(KUBIFY_ENTRYPOINT_IMAGE, f"{K8S_DIR}/entrypoint/")

def _get_entrypoint(*argv):
    out(f"{KUBECTL_NS} rollout status -w deployment/entrypoint &> /dev/null")
    out(f"{KUBECTL_NS} get pods -o wide --field-selector=status.phase=Running -l role=entrypoint --no-headers | cut -d ' ' -f1 | head -n 1")

def _get_service_pod(APP_NAME):
    out(f"{KUBECTL_NS} rollout status -w deployment/{APP_NAME} &> /dev/null")
    out(f"{KUBECTL_NS} get pods -o wide --field-selector=status.phase=Running -l app={APP_NAME} --no-headers | cut -d ' ' -f1 | head -n 1")

def update_registry_secret(*argv):
    REG_SECRET="dockerhub"
    secret = out(f"{KUBECTL_NS} get secret {REG_SECRET}")
    if not secret:
        test= out(f"test -f {HOME}/.netrc") 
        if test:
            print(f"$HOME/.netrc file exists, using it")
            result = out(fr"grep hub\.docker\.com {HOME}/.netrc")
            if result:
#TODO
                pass
    #             while IFS=, read -r username email password:
    #         export docker_email=$(echo $email | sed "s/^'//; s/'$//")
    #       export docker_username=$(echo $username | sed "s/^'//; s/'$//")
    #       export docker_password=$(echo $password | sed "s/^'//; s/'$//")
    #     done < <(python2.7 -c "import netrc; print netrc.netrc('$HOME/.netrc').authenticators('hub.docker.com')" | sed 's/^(//; s/)$//')
    #   
    else:  
        print("Enter DockerHub credentials or using environment variables:")
        if os.environ.get("DOCKER_EMAIL",""):
            docker_email=os.environ["DOCKER_EMAIL"]
        else:
            print("Email: ")
            docker_email = raw_input("")
        if os.environ.get("DOCKER_USERNAME",""):
            docker_username=os.environ["DOCKER_USERNAME"]
        else:
            print("Username: ")
            docker_username =  raw_input("")
        if os.environ.get("DOCKER_PASS"):
            docker_password=os.environ["DOCKER_PASS"]
        else:
            print("Password: ")
            docker_password = raw_input("")

    SECRET=out(f"kubectl create secret docker-registry {REG_SECRET} \
    --docker-email=$docker_email \
    --docker-username=$docker_username \
    --docker-password=$docker_password \
    -o yaml \
    --dry-run=client")

    out(f"{SECRET} | {KUBECTL_NS} apply -f -")
    json = {"imagePullSecrets": [{"name": f"{REG_SECRET}"}]}
    json_str = json.dumps(json)
    out(f"{KUBECTL_NS} patch serviceaccount default -p {json_str}")


def raw_input(text):
    return input(text)


def update_npm_secret(*argv):
    if NPM_TOKEN:
        print("NPM_TOKEN is already set. Re-using it...")
    else:
        print("NPM_TOKEN is not set, reading from npmrc..")
    test = out(f"test -f {HOME}/.npmrc")
    if test:
        print(f"{HOME}/.npmrc exists, using it's token..")
        regex = fr"^\/"
        IN= out(f"tail -1 {HOME}/.npmrc | grep {regex}")
        regex = '='
        IFS=out(f"{regex} read -r -a ADDR <<< {IN}")
        os.env["NPM_TOKEN"]=ADDR[1]
        NPM_TOKEN = os.env('NPM_TOKEN') 
    else:
        print(f"{HOME}/.npmrc does not exist, please login to NPMJS, so that you can pull private packages:")
        out("npm login")
        print(f"{HOME}/.npmrc now exists, thank you, using it's token..")
        regex = fr"^\/"
        IN= out(f"tail -1 {HOME}/.npmrc | grep {regex}")
        regex = '='
        IFS=out(f"{regex} read -r -a ADDR <<< {IN}")
        os.env["NPM_TOKEN"]=ADDR[1]
        NPM_TOKEN = os.env('NPM_TOKEN', '') 
        if not NPM_TOKEN:
            out("npm token create --readonly")
            is_good = out("$? -eq 0")
            if is_good:
                print("Copy the NPM token above and paste it into the prompt below.")
                print("NPM Token: ")
                NPM_TOKEN = raw_input("")
            else:
                print("npm token creation failed, please delete a token from https://www.npmjs.com/settings/(USERNAME)/tokens ")
                print(" and try the command directly: kubify update_npm_secret")
                sys.exit()

def get_npm_secret_direct(*argv):
    if not NPM_TOKEN:
        test = out(f"test -f {HOME}/.npmrc")
        if test:
            regex = fr"^\/"
            IN= out(f"tail -1 {HOME}/.npmrc | grep {regex}")
            regex = '='
            IFS=out(f"{regex} read -r -a ADDR <<< {IN}")
            os.env["NPM_TOKEN"]=ADDR[1]
            NPM_TOKEN = os.env('NPM_TOKEN', '') 
        else:
            print(f"{HOME}/.npmrc does not exist, please login to NPMJS, so that you can pull private packages.. Try using kubify up")
            sys.exit()
    print(f"{NPM_TOKEN}")

def get_npm_secret(*argv):
    if not NPM_TOKEN:
        K8_NPM_TOKEN = out(f"{KUBECTL_NS} get secrets --field-selector=metadata.name=npm-credentials -o json | jq -r .items[0].data.NPM_TOKEN | $BASE64_DECODE")
        test = out(f"{K8_NPM_TOKEN} | grep -q '[0-9]'")
        if test == 1:
            print("Problem accessing k8 npm secret. Try running 'kubify up', test the 'kubify update_npm_secret' and the 'kubify get_npm_secret' commands.")
            sys.exit()
    else:
        print(f"{K8_NPM_TOKEN}")

def _generate_local_cluster_cert(*argv):
    out(f"docker run -e COMMON_NAME=*.{KUBIFY_LOCAL_DOMAIN} -v {K8S_DIR}/k8s/certs:/certs -w /certs -it alpine:latest sh -c ./gen-certs.sh")

def configure_cluster(*argv):
    global MANIFESTS
    global TILLERLESS
    global UPSTREAM

    MANIFESTS = out(f"{K8S_DIR}/k8s")
    TILLERLESS = os.environ.get("TILLERLESS", "0") if not TILLERLESS else "0"
    UPSTREAM = os.environ.get("UPSTREAM", "0") if not UPSTREAM else "0"

    if "linux" in platform.system().lower():
        # check if add-on-cluster-admin is enabled
        CLUSTER_ADMIN_ENABLED = out(f"{KUBECTL} get clusterrolebinding -o json | jq -r '.items[] | select(.metadata.name == \"add-on-cluster-admin\")' --exit-status > /dev/null ||:")
        if CLUSTER_ADMIN_ENABLED:
            out(f"{KUBECTL} create clusterrolebinding add-on-cluster-admin \
            --clusterrole=cluster-admin \
            --serviceaccount=kube-system:default")

    if TILLERLESS == "1":
        TILLER="tiller run helm"
    else:
        TILLER=""
  
    print("Configuring cluster")
    out(f"{HELM} init --force-upgrade --upgrade")
    out(f"{KUBECTL} rollout status -w deployment/tiller-deploy -n kube-system")

    out(f"{HELM} repo add stakater https://stakater.github.io/stakater-charts")
    out(f"{HELM} repo add stable   https://kubernetes-charts.storage.googleapis.com/")
    out(f"{HELM} repo add appscode https://charts.appscode.com/stable/")
    out(f"{HELM} repo add jetstack https://charts.jetstack.io")
    out(f"{HELM} repo update")

    # Install kubedb for managing databases
    KUBEDB_VERSION="0.13.0-rc.0"

    out(f"{HELM} {TILLER} upgrade kubedb-operator appscode/kubedb --install --version {KUBEDB_VERSION} --namespace kube-system")
    out(f"{KUBECTL} rollout status -w deployment/kubedb-operator -n kube-system")
    out(f"{HELM} {TILLER} upgrade kubedb-catalog appscode/kubedb-catalog --install --version {KUBEDB_VERSION} --namespace kube-system")

    # Install nginx-ingress (except on minikube)
    if KUBIFY_ENGINE != "minikube":
        out(f"{HELM} {TILLER} upgrade nginx-ingress stable/nginx-ingress \
        --install \
        --namespace kube-system \
        --set rbac.create=true \
        --set controller.publishService.enabled=true \
        --wait")

    # Install cert-manager for TLS
    CA_SECRET=out(f"{KUBECTL_NS} create secret tls ca-key-pair \
    --cert={K8S_DIR}/k8s/certs/ca.crt \
    --key={K8S_DIR}/k8s/certs/ca.key \
    --dry-run=client \
    -o yaml")
    out("{CA_SECRET} | {KUBECTL_NS} apply -f -")

    CERT_MANAGER_VERSION = "0.5.2"
    CERT_MANAGER_CRD_VERSION = "0.8" # Both these need to have the same minor version !!! IMPORTANT !!!
    #$KUBECTL apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-${CERT_MANAGER_CRD_VERSION}/deploy/manifests/00-crds.yaml
    out(f"{HELM} {TILLER} upgrade cert-manager jetstack/cert-manager \
    --install \
    --version v{CERT_MANAGER_VERSION} \
    --namespace cert-manager \
    --wait")

    # Install reloader which watches configmaps and secrets and determines when to reload pods etc.
    out(f"{HELM} {TILLER} upgrade reloader stakater/reloader \
    --install \
    --wait \
    --set reloader.watchGlobally=true \
    --namespace kube-system")

    # Install External-DNS
    if UPSTREAM == "1":
        data = f"""aws:
                region: "{AWS_REGION}"
                domainFilters:
                    - "{KUBIFY_UPSTREAM_DOMAIN_SUFFIX}"
                dryRun: false
                policy: upsert-only
                rbac:
                    create: true
            """
        with open(f"{WORK_DIR}/external-dns-values.yaml", "a") as myfile:
            myfile.write(data)
        
        out(f"{HELM} {TILLER} upgrade external-dns stable/external-dns \
        --install \
        --wait \
        --values ${WORK_DIR}/external-dns-values.yaml \
        --namespace kube-system")
  
    print("Create CRDs")
    out(f"{KUBECTL_NS} apply -f {MANIFESTS}/kubify.yaml")

    print("Applying manifests")
    if UPSTREAM or UPSTREAM == "0":
        data = """apiVersion: cert-manager.io/v1
                kind: Issuer
                metadata:
                name: ca-issuer
                spec:
                ca:
                    secretName: ca-key-pair"""
    else:
        data ="""apiVersion: cert-manager.io/v1
                kind: ClusterIssuer
                metadata:
                name: letsencrypt-prod
                spec:
                acme:
                    server: https://acme-v02.api.letsencrypt.org/directory
                    email: test@kubify.local
                    privateKeySecretRef:
                    name: letsencrypt-prod
                    http01: {}
                """
    out(f"{KUBECTL_NS} apply -f - {data}")

def configure(*argv):
    global MANIFESTS

    set_context()
    MANIFESTS = f"{K8S_DIR}/k8s"
    print("Creating namespace")
    out(f"{KUBECTL} apply -f {MANIFESTS}/bootstrap.yaml")
    while True:
        time.sleep(1)
        print("Waiting for namespace $NAMESPACE")
        data = out(f"{KUBECTL} get ns/{NAMESPACE}")
        if data:
            break

    update_registry_secret()

    # Set DNS
    print("Configuring DNS and Trusted Certificates. SUDO password might be needed...")
    if KUBIFY_ENGINE == "minikube":
        CLUSTER_IP=out(f"$MINIKUBE ip")
    elif KUBIFY_ENGINE == "local":
        CLUSTER_IP="127.0.0.1"

    out(f"ansible-playbook --connection=local --inventory=127.0.0.1, {K8S_DIR}/k8s/ansible/configure.yaml \
    --ask-become-pass --extra-vars \"cluster_ip={CLUSTER_IP} local_domain={KUBIFY_LOCAL_DOMAIN} ca_cert_path=${K8S_DIR}/k8s/certs/ca.crt\" \
    --tags=\"dnsmasq,trust_ca_cert\"")

    update_npm_secret()
    configure_cluster()

    print("Creating secrets")
    encrypt = out(f"{KUBECTL_NS} apply -f -")
    _get_secret( "dev", "kubify", encrypt) 

    print("Building containers (Please be patient)")
    _build_entrypoint()

    print("Starting containers (Please be patient)")
    SRC_MOUNT_PATTERN=out(fr"echo {SRC_MOUNT} | sed 's/\\//\\\\\//g'");
    HOME_MOUNT_PATTERN=out(fr"echo {HOME_MOUNT} | sed 's/\\//\\\\\//g'");
    ENTRYPOINT_TEMPLATE=out(fr"cat \"{MANIFESTS}/entrypoint.yaml\" | sed \"s/{SRC_MOUNT}/{SRC_MOUNT_PATTERN}/g\" | sed \"s/{HOME_MOUNT}/{HOME_MOUNT_PATTERN}/g");
    print(f"{ENTRYPOINT_TEMPLATE}")
    out(f"{ENTRYPOINT_TEMPLATE} | {KUBECTL_NS} apply -f -");
    if "darwin" in platform.system().lower():
        configure_containers()
        
    while True:
        data = out("kubectl get pods --all-namespaces -l app=kubedb | grep Running") 
        print("Waiting for kubedb to download dependencies....")
        time.sleep(5)
        if not data:
            break

def install(*argv):
    print("Ensuring system dependencies")
    if "darwin" in platform.system().lower():
        data = out("command -v ansible")
        if not data:
            out("brew install ansible")
        out(f"ansible-playbook --connection=local --inventory=127.0.0.1, {K8S_DIR}/k8s/ansible/install_osx.yaml")
    if KUBIFY_ENGINE == "minikube":
        if MINIKUBE_VM_DRIVER == "hyperkit":
            if ask("Root privileges will be necessary to configure the hyperkit driver for Minikube"):
                print("Configuring minikube driver...")
                out("sudo chown root:wheel /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit")
                out("sudo chmod u+s /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit")
            else:
                print("Aborting.")
                sys.exit()
    elif "linux" in platform.system().lower():
        data = out("command -v ansible")
        if not data:
            data_pip = out("command -v pip")
            if not data_pip:
                out(f"sudo apt update")
                out(f"sudo apt install -y python3-pip")
            out("pip3 install ansible")
        out(f"ansible-playbook --connection=local \
                {K8S_DIR}/k8s/ansible/install_linux.yaml \
                --ask-become-pass -e ansible_python_interpreter=/usr/bin/python")
    else:
        print("'kubify install' not supported on "+platform.system()+" ... yet")
        sys.exit()
    print(f"Remember to add {SRC_DIR}/kubify/tools/bin2 to your $PATH in your .bashrc, .zshrc, etc")
    print(f"Alternatively create a symlink to {SRC_DIR}/kubify/tools/bin2/kubify to your existing $PATH")

def db(*argv):
    set_context()
    out(f"{KUBECTL_NS} get svc -l app.kubernetes.io/managed-by=kubedb.com")

def ps(*argv):
    set_context()
    out(f"{KUBECTL_NS} get pods \"$@\"")

def up(skip):
    if skip:
        print("Skipping installation")
    else:
        install()

    RUNNING=check_local_env()
    if KUBIFY_ENGINE == "minikube":
        if RUNNING != "Running":
            print("Starting local cluster (Please be patient)")
            out(f"{MINIKUBE} config set WantUpdateNotification false")
            out(f"{MINIKUBE} start \
            --profile             {PROFILE} \
            --vm-driver           \"none\"")
            out(f"{MINIKUBE} addons enable {MINIKUBE_ADDONS}")
            out(f"sudo chown -R {USER}:{USER} {HOME}/.minikube")
            out(f"sudo chown -R {USER}:{USER} {HOME}/.kube")
    elif KUBIFY_ENGINE == "local":
        if RUNNING != "Running":
            print("Error: Make sure Kubernetes is running locally.")
            sys.exit()
    configure()

def down(*argv):
    RUNNING=check_local_env()
    if RUNNING:
        print("Local cluster is not running")
    else:
        if ask("Do you really want to stop the local cluster?"):
            if KUBIFY_ENGINE == "minikube":
                out(f"{MINIKUBE} stop --profile {PROFILE}")


def check_local_env(*argv):
    try:
        print("def check_local_env()")
        if KUBIFY_ENGINE == "minikube":
            print("def check_local_env() minikube")
            data = out("command -v minikube")
            if not data:
                print("Error: minikube is not installed. Run \"kubify install\" rst.")
                sys.exit()
            else:
                print(f"def check_local_env() data {data}")
            MK_STATUS=out(f"{MINIKUBE} status --profile {PROFILE} | grep host | cut -d ':' -f2 | xargs")
            if MK_STATUS == "Stopped" or MK_STATUS:
                print(f"def check_local_env() MK_STATUS Stopped")
            elif MK_STATUS == "Running":
                print(f"def check_local_env() MK_STATUS Running")
        elif KUBIFY_ENGINE == "local":
            print("def check_local_env() local")
            #print(f"{KUBECTL} cluster-info")
            data = out(f"{KUBECTL} cluster-info")
            print(f"def check_local_env() data {data}")
            if data:
                print(f"def check_local_env() Running {data}")
            else:
                print(f"def check_local_env() Not Running!")
    except Exception as e:
        print("def check_local_env() type error: ", str(e))
        print("def check_local_env()", traceback.format_exc())                

def local_env_running(*argv):
    RUNNING=check_local_env()
    if RUNNING:
        print("Local cluster is not running. (Hint: try 'kubify up')")
        sys.exit()

def display_running(is_running):
    if not is_running:
        print("Local cluster is not running. (Hint: try 'kubify up')")
    else:
        print("Local cluster is running")

def delete(*argv):
    if ask("Do you really want to delete your local cluster? Only ephemeral data/files will be gone."):
        if KUBIFY_ENGINE == "minikube":
            out(f"MINIKUBE delete --profile {PROFILE}")
        elif KUBIFY_ENGINE == "local":
            print(f"Deleting kubify namespace {NAMESPACE}")
            out(f"{KUBECTL} delete ns {NAMESPACE}")

def status(*argv):
    print("def status()")
    RUNNING=check_local_env()
    print(f"Kubify Engine: {KUBIFY_ENGINE}")
    display_running(RUNNING)
    if RUNNING:
        if KUBIFY_ENGINE == "minikube":
            out(f"{MINIKUBE} Status --profile {PROFILE}")
        out(f"{KUBECTL} cluster-info")

def check_kubify(*argv):
    dir_name = out("dirname {PWD}")
    BASE=out(f"basename {dir_name}")
    # sanity check, this command should be run in the app dir
    if BASE != "backend" and BASE != "frontend":
        print("This command should be run in a service directory located under: backend,frontend")
        sys.exit()

def check_arg(*argv):
    if len(argv) == 2 and not argv[0]:
        print(argv[1])
        sys.exit(1)
    

# eg. usage: post_to_slack "\`$USER_NAME\` is deploying \`$APP_NAME\` to \`$CLUSTER\`"
def post_to_slack(*argv):
    if KUBIFY_CI == '1':
        data = out("which slack")
        if data:
            pass
    #Example Chat Post
    #
    # $1 is the channel you want to post to
    # $2 is the title you are setting for the message
    # $3 is the text you want to send
    # !OPTIONAL!
    # $4 is actions, such as posting a button or link
    # $5 is the color of the message
    #
    #slack chat send \
    #  --actions ${actions} \
    #  --author ${author} \
    #  --author-icon ${author_icon} \
    #  --author-link ${author-link} \
    #  --channel ${channel} \
    #  --color ${color} \
    #  --fields ${fields} \
    #  --footer ${footer} \
    #  --footer-icon ${footer-icon} \
    #  --image '${image}' \
    #  --pretext '${pretext}' \
    #  --text '${slack-text}' \
    #  --time ${time} \
    #  --title ${title} \
    #  --title-link ${title-link}
    #
#TODO
#       if [ "$#" == 5 ]:
#         slack chat send \
#           --channel $1 \
#           --title "$2" \
#           --text "$3" \
#           --color $4 \
#           --actions "$5"
#       elif [ "$#" == 4 ]:
#         slack chat send \
#           --channel $1 \
#           --title "$2" \
#           --text "$3" \
#           --color $4
#       
#     
#   
# }

def image_name(image_name):
    ci_image_name(image_name)

def ci_image_name(*argv):
    return "{PUBLISH_IMAGE_REPO_PREFIX}/{argv[0]}"


def services(user_choice):
    if user_choice =="list":
        LIST=1

    # Ignore the minikube stuff
    SERVICES=out(fr"find {SRC_DIR} -type f -name 'kubify.yml' -exec dirname {{}} \; | grep -v 'kubify/kubify2' | xargs basename")

    MAX_WIDTH=20

    if LIST != '1':
        print("{MAX_WIDTH}")
        out("SERVICE HOSTNAME")
        for SERVICE in SERVICES:
            INGRESS=out(f"{KUBECTL_NS} get ingress {SERVICE} -o jsonpath='{{.spec.rules[*].host}}'")
            if not INGRESS:
                INGRESS='<N/A>'
            SRV=out(fr"{SERVICE} | sed 's/[\w]+//g'")
            print(f"{MAX_WIDTH}")
            out(f"{SRV} {INGRESS}")
    else:
        for SERVICE in SERVICES:
            print(f"SERVICE")


def images(*argv):
    set_context()
    out(f"docker images | grep {PUBLISH_IMAGE_REPO_PREFIX}")

def clean(*argv):
    set_context()
    if KUBIFY_ENGINE == "minikube":
        print("Clearing cached images in Minikube...")
        out(f"{MINIKUBE} Cache delete $(minikube cache list)")

    print("Clearing unused docker images for services...")
    SERVICES_LIST = services(list)
    for APP_NAME in SERVICES_LIST:
        IMAGE= image_name(APP_NAME)
        print(f"Removing old images for {APP_NAME}...")
        out(f"docker images | grep {IMAGE} | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {{}} docker rmi {IMAGE}:"+"{}")

    print("Pruning unused images")
    out("docker system prune --force")



def check_skaffold(*argv):
    check_kubify()
    APP_DIR=out(f"pwd")
    KUBIFY_FILE=out(f"{APP_DIR}/kubify.yml")
    if not KUBIFY_FILE:
        print("Have you run 'kubify init' yet?")
        sys.exit()
    if KUBIFY_CI != '1':
        set_context()
        out("skaffold config set --global local-cluster true")


def publish(extra_version):
    check_ci_mode(publish)
    EXTRA_VERSIONS=extra_version
    check_skaffold()
    APP_DIR=out(f"pwd")
    APP_NAME=sh(f"basename {APP_DIR}")
    print(f"Publishing application {APP_NAME}")
    _init(f"{APP_DIR}", f"common,generate_k8s,build_image", f"app_ci_image_extra_versions=latest,{EXTRA_VERSIONS}")

def dir(service):
    RELATIVE = os.environ.get("RELATIVE","0")
    if RELATIVE == "1":
        S_DIR=""
    else:
        S_DIR=f"{SRC_DIR}/"
    if service:
        print(f"{S_DIR}")
    elif os.path.isfile(f"{SRC_DIR}/backend/{service}"):
        print(f"{SRC_DIR}/backend/{service}")
    elif os.path.isfile(f"{SRC_DIR}/frontend/{service}"):
        print(f"{SRC_DIR}/frontend/{service}")
    else:
        print("")

def run_all(*argv):
    '''
    entry = "service-image"

    entry = entry.split(":")
    service=entry[0]
    version="latest" if len(entry) < 2 else entry[1]

    print(f"{service}:{version}")
    '''
    if len(argv) == 0:
        print("there was no services passed in to \"run-all\" command, so running all services..")
        SERVICES=["list"]
    else:
        SERVICES=argv

    for entry in SERVICES:
        entry = entry.split(":")
        service=entry[0]
        version="latest" if len(entry) < 2 else entry[1]

        if os.path.isfile(f"{SRC_DIR}/backend/{service}"):
            subprocess.Popen(f"kubify run {version}", cwd=f"{SRC_DIR}/backend/{service}")
        elif os.path.isfile(f"{SRC_DIR}/frontend/{service}"):
            subprocess.Popen(f"kubify run {version}", cwd=f"{SRC_DIR}/frontend/{service}")
        else:
            print(f"Error: Service '{service}' doesn't exist")

def build_run_all(*argv):
    if len(argv) == 0:
        print("there was no services passed in to \"run-all\" command, so running all services..")
        SERVICES=["list"]
    else:
        SERVICES=argv

    for entry in SERVICES:
        entry = entry.split(":")
        service=entry[0]
        version="latest" if len(entry) < 2 else entry[1]

        if os.path.isfile(f"{SRC_DIR}/backend/{service}"):
            subprocess.Popen(f"kubify run", cwd=f"{SRC_DIR}/backend/{service}")
        elif os.path.isfile(f"{SRC_DIR}/frontend/{service}"):
            subprocess.Popen(f"kubify run", cwd=f"{SRC_DIR}/frontend/{service}")
        else:
            print(f"Error: Service '{service}' doesn't exist")

def stop_all(service):
    if service:
        SERVICES=out(f"{KUBECTL_NS} get deployment -l context=kubifyk8 -o=jsonpath='"+"{.items[*].metadata.name}'")
    else:
        SERVICES=service

    for entry in SERVICES:
        entry = entry.split(":")
        service=entry[0]
        # version="latest" if len(entry) < 2 else entry[1]

        if os.path.isfile(f"{SRC_DIR}/backend/{service}"):
            subprocess.Popen(f"kubify stop", cwd=f"{SRC_DIR}/backend/{service}")
        elif os.path.isfile(f"{SRC_DIR}/frontend/{service}"):
            subprocess.Popen(f"kubify stop", cwd=f"{SRC_DIR}/frontend/{service}")
        else:
            print(f"Error: Service '{service}' doesn't exist")

def run(APP_VERSION):
    check_skaffold()
    APP_NAME=out(f"basename pwd")
    print("Starting application '{APP_NAME}'")
    print("Once the application is running, get its URL by running 'kubify url'")
    init()
    _stop(APP_NAME)
    NPM_TOKEN=get_npm_secret()
    os.environ['NPM_TOKEN'] = NPM_TOKEN
    IMAGE_NAME=image_name(APP_NAME)
    out(f"{DOCKER} pull {IMAGE_NAME}:latest")
    if APP_VERSION:
        CI_IMAGE=ci_image_name(APP_NAME)
        out(f"skaffold config set --global local-cluster true")
        out(f"""{SKAFFOLD} deploy \
        --images {CI_IMAGE}:{APP_VERSION} \
        --filename {WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml \
        --profile BUILD_PROFILE""")
    else:
        out(f"skaffold config set --global local-cluster true")
        out(f"""{SKAFFOLD} run \
        --cache-artifacts \
        --filename {WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml \
        --profile {LOCAL_RUN_PROFILE}""")

#TODO
def run_kubify(*argv):
    pass
#   kubify run-all \
#     be-svc \
#     fe-svc
#   kubify logs *

def build_run_kubify(*argv):
    out(f"mkdir -p {WORK_DIR}/{ENV}/logs")

    print("Building & running Kubify core stack services ..")
    print(f"To tail logs: tail -f {WORK_DIR}/{ENV}/logs/build-run-kubify-CORE*.log")
    print("To stop builder: control-c (or if you must: pkill -f kubify)")

    out(f"trap 'kill {BGPID1};kill {BGPID2}; exit' INT")

    print("The date before build is: `date`")
    #TODO
    # kubify build-run-all \
    #   be-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE1.log &
    # BGPID1=$!
    # kubify build-run-all \
    #   fe-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE2.log &
    # BGPID2=$!

    # wait
    # echo "The date after build is: `date`"
    # kubify logs *

def build_start_kubify(*argv):
    out(f"mkdir -p {WORK_DIR}/{ENV}/logs")

    print("Building & running Kubify core stack services ..")
    print(f"To tail logs: tail -f {WORK_DIR}/{ENV}/logs/build-run-kubify-CORE*.log")
    print("To stop builder: control-c (or if you must: pkill -f kubify)")

    out(f"trap 'kill {BGPID1};kill {BGPID2}; exit' INT")

    print("The date before build is: `date`")
    #TODO
#     cd ${WORK_DIR}/../backend/be-svc
#     kubify start be-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE_be-svc.log &
#     BGPID1=$!
#     cd ${WORK_DIR}/../frontend/fe-svc
#     kubify start fe-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE_fe-svc.log &
#     BGPID2=$!

#     wait
#     echo "The date after build is: `date`"
#     kubify logs *
# }

def start(*argv):
    check_skaffold()
    APP_NAME=out(f"basename pwd")
    APP_DIR=out("pwd")

    print(f"Starting application '{APP_NAME}' for local development. Changes will be watched.")
    print("Once the application is running, get its URL by running 'kubify url'")

    init()

    FALLBACK=0
    if not os.path.isfile(f"{WORK_DIR}/{ENV}/{APP_NAME}/Dockerfile.dev"):
        print(f"WARNING: No 'Dockerfile.dev' defined for '{APP_NAME}', using 'Dockerfile' instead. Run 'kubify help' for more details")
    if not os.path.isfile(f"{APP_DIR}/Dockerfile"):
        print(f"ERROR: No 'Dockerfile' defined for '{APP_NAME}'. ")
        sys.exit()
    else:
        FALLBACK='1'
    if FALLBACK == '1':
        SKAFFOLD_PROFILE=LOCAL_RUN_PROFILE
    else:
        SKAFFOLD_PROFILE=LOCAL_START_PROFILE

    _stop(APP_NAME)

    out(f"skaffold config set --global local-cluster true")
    os.environ['NPM_TOKEN'] = get_npm_secret_direct()
    out(f"""{SKAFFOLD} dev \
    --cache-artifacts \
    --filename {WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml \
    --profile $SKAFFOLD_PROFILE \
    --no-prune \
    --no-prune-children \
    --port-forward=false
    """)
    _stop(APP_NAME)

def stop(*argv):
    check_skaffold()
    PWD = out(f"pwd")
    APP_NAME=out(f"basename {PWD}")
    init()
    print(f"Stopping application '{APP_NAME}'")
    _stop(APP_NAME)

def _stop(APP_NAME):
    out(f"skaffold config set --global local-cluster true")
    os.environ['NPM_TOKEN'] = get_npm_secret_direct()
    out(f"{SKAFFOLD} delete --filename {WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml --profile LOCAL_RUN_PROFILE")
    out(f"{SKAFFOLD} delete --filename {WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml --profile LOCAL_START_PROFILE")
    out(f"{KUBECTL_NS} delete all -l app={APP_NAME} --force --grace-period=0")

def url(*argv):
    check_skaffold()
    PWD = out(f"pwd")
    APP_NAME=out(f"basename {PWD}")
    print(f"https://{APP_NAME}.{KUBIFY_LOCAL_DOMAIN}")


def logs(*argv):
    set_context()
    out(f"kubetail --context {PROFILE} -n {NAMESPACE} -l context=kubifyk8")


def exec(*argv):
    set_context()
    if len(argv) == 0:
        out(f"{KUBECTL_NS} exec -it {_get_entrypoint()} -- bash -l -i")
    else:
        out(f"{KUBECTL_NS} exec -it {_get_entrypoint()} -- bash -l -i -c {input}")


def cmd(input):
    check_kubify()
    set_context()
    PWD = out(f"pwd")
    APP_NAME=out(f"basename {PWD}")
    POD=_get_service_pod(APP_NAME)
    if not POD:
        print(f"The application '{APP_NAME}' is not running.")
        sys.exit()

    if not input:
        out(f"{KUBECTL_NS} exec -it {POD} -- sh -l -i")
    else:
        out(f"{KUBECTL_NS} exec -it {POD} -- sh -l -i -c {input}")


def run_in_entrypoint(*argv):
    if not os.environ.get("KUBERNETES_PORT",""):
        exec(argv)


def __setup_symlinks(*argv):
    os.system(f"ln -sf /data/home/.aws {HOME}")
    os.system(f"ln -sf /data/home/.ssh {HOME}")
    os.system(f"ln -sf /data/home/.gitconfig {HOME}")


def setup_symlinks(*argv):
    os.system(f"echo \"Setting up symlinks in entrypoint container\" &> {KUBIFY_OUT}")
    run_in_entrypoint(f"kubify", f"__setup_symlinks")



def wait_for_deployment(*argv):
    check_arg(argv[0], fr"No deployment name specified!")
    check_arg(argv[1], fr"No namespace name specified!")

    set_context()
    # TODO: Find a better way
    print(f"Waiting for deployment {argv[0]} in namespace {argv[1]}")
    os.system(f"{KUBECTL} rollout status -w deployment/{argv[0]} -n {argv[1]} &> {KUBIFY_OUT}")

   
def check_containers(*argv):
    while True:
        result = os.system(f"exec kubify > /dev/null")
        if result != "0":
            if KUBIFY_ENGINE == "minikube":
                stop_mount()
                start_mount()

            time.sleep("2")
            wait_for_deployment(f"entrypoint",f"{NAMESPACE}")
        else:
            break

  
def configure_containers(*argv):
    check_containers()
    setup_symlinks()


def run_in_app_entrypoint(*argv):
    '''
    def exec(*argv):
    print(*argv)

    def run(*argv):
    exec("kubify",*argv)

    run("A","B","C","D") -> kubify A B C D
    '''
    if not os.environ.get("KUBERNETES_PORT",""):
        os.chdir(os.path.basename(os.getcwd()))
        exec("kubify", *argv)


def init(*argv):
    check_kubify()
    set_context()
    all_args = " ".join([*argv])
    if all_args.endswith("--re-run"):
        RERUN=1


    APP_NAME=sh(f"basename {os.getcwd()}")
    APP_DIR=os.getcwd()
    KUBIFY_CONFIG=f"{APP_DIR}/kubify.yml"
    DOCKERFILE=f"{APP_DIR}/Dockerfile"
    TAGS='common'

    if not os.path.isdir(f"{APP_DIR}/secrets"):
        print(f"It looks like you haven't imported secrets from AWS. Checking...")
        os.system(f"kubify secrets import all")


    # Check for config.yml or Dockerfile and migrate only if kubify.yml doesn't exist
    if RERUN == "1" or (not os.path.isfile(f"{KUBIFY_CONFIG}")) or (os.path.isfile(f"{DOCKERFILE}") and (not os.path.isfile(f"{KUBIFY_CONFIG}"))):
        TAGS=f"{TAGS}"


    print(f"Initializing {APP_NAME}")

    # Always generate k8s-related resources from kubify.yml
    TAGS="{TAGS},generate_k8s"

    _init(f"{APP_DIR}", f"{TAGS}")



def _init(*argv):
    APP_DIR=argv[0]
    APP_NAME=sh(f"basename {APP_DIR}")
    TAGS=argv[1]
    VARS=argv[2]
    IMAGE=sh(f"image_name {APP_NAME}")
    CI_IMAGE=sh(f"ci_image_name $APP_NAME")

    if APP_NAME != "common":
        # Create the configuration for the application
        
        print(f"Running service playbook for {APP_NAME} with tags: {TAGS}")

        # Only expose the service as a LoadBalancer in Minikube.
        # Otherwise, it's only available through Ingress
        if KUBIFY_ENGINE == "minikube":
            EXPOSE_SERVICE_FLAG="expose_service=true"
        else:
            EXPOSE_SERVICE_FLAG="expose_service=false"

        if UPSTREAM == "":
            ENV="local"
            SERVICE_PROFILE=os.environ.get("SERVICE_PROFILE", "dev")
            KUBIFY_DOMAIN_ENV="kubify_domain_env=${ENV}"
            KUBIFY_DOMAIN_SUFFIX=KUBIFY_LOCAL_DOMAIN_SUFFIX
            CERT_ISSUER="ca-issuer"
            IS_LOCAL="is_local=1"
        else:
            KUBIFY_DOMAIN_SUFFIX=KUBIFY_UPSTREAM_DOMAIN_SUFFIX
            CERT_ISSUER="letsencrypt-prod"

        ENV_DOMAIN=f"{ENV}.{KUBIFY_DOMAIN_SUFFIX}"

        sh(f"""ansible-playbook \
            --connection=local \
            --inventory=127.0.0.1, {K8S_DIR}/k8s/ansible/service.yaml \
            --extra-vars="{EXPOSE_SERVICE_FLAG} env_domain={ENV_DOMAIN} profile={SERVICE_PROFILE} {IS_LOCAL} cert_issuer={CERT_ISSUER} {KUBIFY_DOMAIN_ENV} kubify_domain_suffix={KUBIFY_DOMAIN_SUFFIX} build_profile={BUILD_PROFILE} skaffold_namespace={NAMESPACE} env={ENV} kubify_dir={WORK_DIR} app_dir={APP_DIR} app_name={APP_NAME} app_image={IMAGE} app_ci_image={CI_IMAGE} kubify_version={KUBIFY_CURRENT_VERSION} {VARS}" \
            --tags={TAGS} &> {KUBIFY_OUT}""")
    
def _generate_manifests(*argv):
    APP_DIR=argv[0]
    TAGS=argv[1] if argv[1] else "generate_k8s"
    _init(f"{APP_DIR}", f"common,{TAGS}")


def secrets(*argv):
    check_kubify()

    check_arg(argv[0], fr"No action (export/import/create/edit/view) specified!")
    check_arg(argv[1], fr"No Environment (all/dev/test/stage/prod) specified!")

    ENV=argv[1]

    check_kubify()
    APP_DIR=os.getcwd()
    APP_NAME=sh(f"basename {APP_DIR}")

    SECRETS_FILE=f"{APP_DIR}/secrets/secrets.{ENV}.enc.yaml"

    set_context
    ENV_UPPER=sh(f"echo {ENV} | awk '{{ print toupper($0) }}'")
    KEY_VAR="${ENV_UPPER}_KMS"

    if ENV == 'all' and argv[0] != 'import':
        print("'all' is only valid for 'kubify secrets import'")
        sys.exit(1)

    for case in switch(argv[0]):
        if case("export"):
            export_secret(ENV, APP_DIR)
            break
        if case("import"):
            if ENV == 'all':
                for env in "{ALL_ENV[@]}":
                    print(f"Importing secrets for {APP_NAME} for {env} environment")
                    import_secret(f"{env}", f"{APP_DIR}")
            else:
                print(f"Importing secrets for {APP_NAME} for {ENV} environment")
                import_secret(f"{ENV}", f"{APP_DIR}")
            break
        if case("create"):
            print(f"Creating secrets for {APP_NAME} for {ENV} environment")
            sh(f"kubesec edit -if {SECRETS_FILE} --key=\"{KEY_VAR}\"")
            print("Reloading secrets in-cluster")
            _generate_manifests(f"{APP_DIR}")
            break
        if case("edit"):
            print("Editing secrets for ${APP_NAME} for ${ENV} environment")
            os.system(f"kubesec edit -if {SECRETS_FILE} --key=\"${KEY_VAR}\"")
            print("Reloading secrets in-cluster")
            _generate_manifests(f"{APP_DIR}")
            break
        if case("view"):
            sh(f"kubesec decrypt {SECRETS_FILE} --cleartext \
                --template=$'{{ range $k, $v := .data }}{{ $k }}={{ $v }}\n{{ end }}'")
            break
        if case():
            print("Invalid option - $1")


def export_secret(*argv):
    ENV=argv[0]
    APP_DIR=argv[1]
    APP_NAME=sh(f"basename {APP_DIR}")
    SECRET_NAME=f"{ENV}_{APP_NAME}"
    SECRETS_FILE=f"{APP_DIR}/secrets/secrets.{ENV}.enc.yaml"

    SECRETS=sh(f"kubesec decrypt {SECRETS_FILE} --cleartext")
    SECRETS=sh(f"\"{SECRETS}\" | yq -r .data | jq -r \"with_entries(.key |= .)\"")

    sh(f"aws secretsmanager create-secret --name {SECRET_NAME}")
    sh(f"aws secretsmanager put-secret-value --secret-id $SECRET_NAME --secret-string \"{SECRETS}\"")


def import_secret(*argv):
    ENV=argv[0]
    APP_DIR=argv[1]
    APP_NAME=sh(f"basename {APP_DIR}")

    DEST=f"{APP_DIR}/secrets"
    SECRET_FILE_PATH=f"{DEST}/secrets.{ENV}.enc.yaml"
    os.system(f"mkdir -p {DEST}")

    SECRETS=_get_secret(f"{ENV}",f"{APP_NAME}",f"1")

    print(f"{SECRETS} > {SECRET_FILE_PATH}")
    


def _get_secret(*argv):
    ENV=argv[0]
    APP_NAME=argv[1]
    ENCRYPT=argv[2]

    SECRET_NAME=f"{ENV}_{APP_NAME}"
    SECRET_DATA=sh(f"aws secretsmanager get-secret-value --secret-id {SECRET_NAME} | jq -r .SecretString | jq -r 'map_values(. | @base64)'")
    ENV_UPPER=sh(f"echo {ENV} | awk '{{ print toupper($0) }}'")
    KEY_VAR="${ENV_UPPER}_KMS"

    if not ENCRYPT:
        result = sh(f"""cat <<EOF | kubesec encrypt --key=aws:"{KEY_VAR}" -  
{{ 
    "apiVersion": "v1", 
    "kind": "Secret", 
    "metadata": {{
        "name": "{APP_NAME}" 
    }}, 
    "data": "{SECRET_DATA}" 
}}
EOF""")
    else:
        result = sh(f"""cat <<EOF
{{
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {{
        "name": "{APP_NAME}"
    }},
    "data": "{SECRET_DATA}"
}}
EOF""")
    os.system(f"echo {result} &> {KUBIFY_OUT}")


def undeploy_env(*argv):
    check_ci_mode("undeploy env")
    os.environ.set("UNDEPLOY", "yes")
    os.system(f"UNDEPLOY=yes deploy_env \"{[*argv]}\"")


def deploy_env(*argv):
    check_ci_mode("deploy_env")

    check_arg(argv[0], "Error! Usage: kubify deploy_env <env>")

    ENV=argv[0]
    TAGS=deploy_env
    UNDEPLOY=os.environ.get("UNDEPLOY", "no")

    # Run the env playbook
    print(f"Running env playbook for {ENV} with tags: {TAGS}")

    sh(f"""ansible-playbook \
        --connection=local \
        --inventory=127.0.0.1, {K8S_DIR}/k8s/ansible/env.yaml \
        --extra-vars="aws_profile={AWS_ADMIN_PROFILE} src_dir={SRC_DIR} env={ENV} kubify_dir={WORK_DIR} undeploy_env={UNDEPLOY}" \
        --tags={TAGS} &> {KUBIFY_OUT}""")

def deploy(*argv):
    check_ci_mode("deploy")

    check_arg(argv[0], fr"Error! Usage: kubify deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>")
    check_arg(argv[1], fr"Error! Usage: kubify deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>")
    check_arg(argv[2], fr"Error! Usage: kubify deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>")
    check_arg(argv[3], fr"Error! Usage: kubify deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>")
    check_arg(argv[4], fr"Error! Usage: kubify deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>")
    check_arg(argv[5], fr"Error! Usage: kubify deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>")

    APP_NAME=argv[0]
    CLUSTER=argv[1]
    NAMESPACE=argv[2]
    ENV=f"{NAMESPACE}" # Same as namespace
    SERVICE_PROFILE=argv[3]
    APP_VERSION=argv[4]
    CONFIG_VERSION=argv[5]

    if os.path.isdir(f"{SRC_DIR}/backend/{APP_NAME}"):
        os.chdir(f"{SRC_DIR}/backend/{APP_NAME}")
    elif os.path.isdir(f"{SRC_DIR}/frontend/{APP_NAME}"):
        os.os.chdir(f"{SRC_DIR}/frontend/{APP_NAME}")
    else:
        print(f"Error: Service {APP_NAME} does not exist.")
        sys.exit(1)
    

    check_skaffold()

    APP_DIR=os.os.getcwd()
    CI_IMAGE=ci_image_name(APP_NAME)
    print(f"Deploying application {APP_NAME} (version: $APP_VERSION) to cluster {CLUSTER} using environment profile {PROFILE} in namespace {NAMESPACE}")
    SERVICE_PROFILE={SERVICE_PROFILE}
    UPSTREAM=1
    _init(f"{APP_DIR}", f"common,generate_k8s,deploy_service", f"kubify_domain_env={NAMESPACE} app_config_sha={CONFIG_VERSION} deploy_namespace={NAMESPACE} aws_profile={AWS_ADMIN_PROFILE} app_dir={APP_DIR} deploy_cluster_name={CLUSTER} deploy_image={CI_IMAGE}:{APP_VERSION} skaffold_config={WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml skaffold_profile={BUILD_PROFILE} undeploy=no")


def environments(*argv):
    check_arg(argv[0], fr"No action (list/view/status/logs/diff/get-context) specified!")

    ENV=argv[1]
    ENV_FILE=f"{SRC_DIR}/environments/{ENV}.yaml"
    
    for case in switch(argv[0]):
        if case("list"):
            print(sh(fr"find {SRC_DIR}/environments -type f -name '*.yaml' | sed 's:.*/::' | sed 's/\.[^.]*$//'"))
            break

        if case("logs"):
            check_arg(ENV, fr"No Environment (dev/test/stage/prod) specified!")
            if not os.path.isfile(f"{ENV_FILE}"):
                print("Error: Environment ${ENV} does not exist!")
                sys.exit()
            

            print(f"Showing logs for {ENV} environment)")
            CLUSTER=sh(f"$(cat {ENV_FILE}| yq -r .target.cluster)")
            CONTEXT=f"{KUBIFY_UPSTREAM_ENV_ACCOUNT}:cluster/{CLUSTER}"
            os.system(f"kubens {ENV}")
            APP=argv[2]

            if APP == "" or APP == "*":
                os.system(f"kubetail \
                    --context {CONTEXT} \
                    --namespace {ENV}")
            else:
                os.system(f"kubetail \
                    --context {CONTEXT} \
                    --namespace {ENV} \
                    --selector \"app={APP}\"")
                break
            
        if case("view"):
            check_arg(ENV, fr"No Environment (dev/test/stage/prod) specified!")
            if not os.path.isfile(f"{ENV_FILE}"):
                print(f"Error: Environment {ENV} does not exist!")
                sys.exit(1)
            
            os.system(f"kubectl --context kubifyk8-{ENV} get environments {ENV} -o yaml | yq .")
            break
        if case("status"):
            check_arg(ENV, fr"No Environment (dev/test/stage/prod) specified!")
            if not os.path.isfile(f"{ENV_FILE}"):
                print(f"Error: Environment ${ENV} does not exist!")
                sys.exit(1)
            
            print("Error: 'kubify environments status' not implemented yet!")
            sys.exit(1)
            break
        if case("get-context"):
            check_arg(ENV, fr"No Environment (dev/test/stage/prod) specified!")
            if not os.path.isfile(f"{ENV_FILE}"):
                print("Error: Environment ${ENV} does not exist!")
                sys.exit(1)
            
            CLUSTER=sh(f"$(cat {ENV_FILE}| yq -r .target.cluster)")
            CONTEXT=f"{KUBIFY_UPSTREAM_ENV_ACCOUNT}:cluster/{CLUSTER}"
            AWS_PROFILE=f"{AWS_ADMIN_PROFILE} aws eks update-kubeconfig --name {CLUSTER} --alias kubifyk8-{ENV}"
            os.system(f"kubens {ENV}")
            break
        if case("diff"):
            check_arg(ENV, fr"No Environment (dev/test/stage/prod) specified!")
            if not os.path.isfile(f"{ENV_FILE}"):
                print("Error: Environment {ENV} does not exist!")
                sys.exit(1)
            
            TO_ENV=argv[2]
            check_arg(TO_ENV, fr"No 2nd environment to diff (dev/test/stage/prod) specified!")

            if ENV == TO_ENV:
                print("Error: Can't diff an environment with itself!")
                sys.exit(1)
        

            CLUSTER=sh(f"$(cat {ENV_FILE} | yq -r .target.cluster)")
            CONTEXT="{KUBIFY_UPSTREAM_ENV_ACCOUNT}:cluster/{CLUSTER}"
            ENV_JSON=sh(f"kubectl --context kubifyk8-{ENV} get environments {ENV} -o yaml | yq -r .")
            TO_ENV_JSON=sh(f"kubectl --context kubifyk8-{TO_ENV} get environments {TO_ENV} -o yaml | yq -r .")

            SERVICES=sh(f"echo {argv[3]} | sed 's/,/ /g'")

            if not SERVICES:
                SERVICES=sh(f"echo $ENV_JSON | yq -r \".services | keys[]\"")
            

            print(sh(f"printf '%*s\n' \"${{COLUMNS:-$(tput cols)}}\" '' | tr ' ' -"))
            print("Environment Diff")
            os.system(f"rm -f {WORK_DIR}/compare_env_1.json {WORK_DIR}/compare_env_2.json")
            print(f"\"{ENV_JSON}\" | jq -r \"{{kubify_version,services}}\" > {WORK_DIR}/compare_env_1.json")
            print(f"\"{TO_ENV_JSON}\" | jq -r \"{{kubify_version,services}}\" > ${WORK_DIR}/compare_env_2.json")
            os.system(f"json-diff {WORK_DIR}/compare_env_1.json {WORK_DIR}/compare_env_2.json")

            # Diff the kubify tool
            KUBIFY_VERSION_1=sh(f"echo {ENV_JSON} | jq -r \".kubify_version\"")
            KUBIFY_VERSION_2=sh(f"echo {TO_ENV_JSON} | jq -r \".kubify_version\"")
            print(sh(f"printf '%*s\n' \"${{COLUMNS:-$(tput cols)}}\" '' | tr ' ' -"))
            print("Kubify Diff")
            os.system(f"git --no-pager diff {KUBIFY_VERSION_1}..{KUBIFY_VERSION_2} {SRC_DIR}/tools/kubify")

            # Diff the configs
            print("Services Diff")

            for service in {SERVICES}:
                SERVICE_DIR=sh(f"kubify dir {service}")
                CONFIG_VERSION_1=sh(f"$(echo $ENV_JSON | jq -r \".services[\"$service\"].config\")")
                CONFIG_VERSION_2=sh(f"$(echo $TO_ENV_JSON | jq -r \".services[\"$service\"].config\")")
                CODE_VERSION_1=sh(f"$(echo $ENV_JSON | jq -r \".services[\"$service\"].image\")")
                CODE_VERSION_2=sh(f"$(echo $TO_ENV_JSON | jq -r \".services[\"$service\"].image\")")
                print(sh(f"%*s\n' \"${{COLUMNS:-$(tput cols)}}\" '' | tr ' ' -"))

                SHOW_CODE_DIFF=1
                SHOW_CONFIG_DIFF=1

                print("Diff for $service between $ENV and $TO_ENV")

                if CODE_VERSION_1 == "null":
                    print(f"{service} doesn't exist in environment \"$ENV\"")
                    SHOW_CODE_DIFF=""
                

                if CODE_VERSION_2 == "null":
                    print("$service doesn't exist in environment \"$TO_ENV\"")
                    SHOW_CODE_DIFF=""
                

                if CODE_VERSION_1 == CODE_VERSION_2:
                    print(f"Info: Code for {service} has no differences between {ENV} and {TO_ENV}")
                    SHOW_CODE_DIFF=""
                

                if CONFIG_VERSION_1 == "null":
                    SHOW_CONFIG_DIFF=""
                

                if CONFIG_VERSION_2 == "null":
                    SHOW_CONFIG_DIFF=""
                

                if not SHOW_CODE_DIFF:
                    print("Code Diff")
                    os.system(f"git --no-pager diff \"@kubify/{service}@{CODE_VERSION_1}\"..\"@kubify/{service}@{CODE_VERSION_2}\" {SERVICE_DIR} \":(exclude){SERVICE_DIR}/config\" \":(exclude){SERVICE_DIR}/secrets\"")
                

                if not SHOW_CONFIG_DIFF:
                    print("Config Diff")

                    REL_SERVICE_DIR=sh(f"RELATIVE=1 kubify dir {service}")

                    os.system(f"rm -f {WORK_DIR}/compare_config_1.json {WORK_DIR}/compare_config_2.json")
                    os.system(f"git show {CONFIG_VERSION_1}:{REL_SERVICE_DIR}/config/config.{ENV}.yaml    | yq -r \"{{data}}\" > {WORK_DIR}/compare_config_1.json")
                    os.system(f"git show {CONFIG_VERSION_2}:{REL_SERVICE_DIR}/config/config.{TO_ENV}.yaml | yq -r \"{{data}}\" > {WORK_DIR}/compare_config_2.json")
                    os.system(f"json-diff {WORK_DIR}/compare_config_1.json {WORK_DIR}/compare_config_2.json")
                
            break
            
        if case():
            print(f"Invalid option - {argv[0]}")
            break
    


def undeploy(*argv):
    check_ci_mode("undeploy")

    check_arg(argv[0], fr"Error! Usage: kubify undeploy <service> <cluster> <namespace> <profile>")
    check_arg(argv[1], fr"Error! Usage: kubify undeploy <service> <cluster> <namespace> <profile>")
    check_arg(argv[2], fr"Error! Usage: kubify undeploy <service> <cluster> <namespace> <profile>")
    check_arg(argv[3], fr"Error! Usage: kubify undeploy <service> <cluster> <namespace> <profile>")

    APP_NAME=argv[0]
    CLUSTER=argv[1]
    NAMESPACE=argv[2]
    ENV=argv[3]

    if os.path.isdir(f"{SRC_DIR}/backend/{APP_NAME}"):
        os.chdir(f"{SRC_DIR}/backend/{APP_NAME}")
    elif os.path.isdir(f"{SRC_DIR}/frontend/{APP_NAME}"):
        os.chdir(f"{SRC_DIR}/frontend/${APP_NAME}")
    else:
        print(f"Error: Service $APP_NAME does not exist.")
        sys.exit(1)

    check_skaffold()

    APP_DIR=os.getcwd()  #$PWD
    CI_IMAGE=ci_image_name(f"{APP_NAME}")
    print(f"Undeploying application $APP_NAME from cluster $CLUSTER using environment profile $ENV in namespace $NAMESPACE")
    _init(f"{APP_DIR}", f"common,generate_k8s,deploy_service", f"deploy_namespace={NAMESPACE} aws_profile={AWS_ADMIN_PROFILE} app_dir={APP_DIR} deploy_cluster_name={CLUSTER} deploy_image={CI_IMAGE}:{APP_VERSION} skaffold_config={WORK_DIR}/{ENV}/{APP_NAME}/skaffold.yaml skaffold_profile={BUILD_PROFILE} undeploy=yes")


def new(*argv):
    check_arg(argv[0], fr"Error! Usage: kubify new <app_type> <app_name>")
    check_arg(argv[1], fr"Error! Usage: kubify new <app_type> <app_name>")
    run_in_entrypoint(f"kubify", *argv)


def _new(*argv):

    APP_TYPE=argv[0]
    APP_NAME=argv[1]
    APP_DIR=f"{SRC_DIR}/{APP_TYPE}/{APP_NAME}"

    if os.path.isdir(f"{APP_DIR}"):
        print(f"Error: The app '{APP_NAME}' already exists!")
        sys.exit()

    app_name_chars = len(f"{APP_NAME}")
    if app_name_chars > 17:
        print(f"Error: Name of app ({APP_NAME}) is too long ({app_name_chars} chars), please keep it under 18 characters!")
        sys.exit()

    while True:
        print(
"""
    Do you want to base this app on an existing template?
    1. backend
    2. frontend
""")
        choice = input("Your choice [1-2] (Ctrl-c to Quit): ")
        if choice != "1" or choice !="2":
            break

    TEMPLATES_DIR=f"{SRC_DIR}/tools/kubify/templates"

    for case in switch(choice):
        if case("1"): 
            print("Using backend template...")
            out(f"mkdir -p ${APP_DIR}")
            out(f"cp -R {TEMPLATES_DIR}/backend/* {APP_DIR}")
            out(f"envsubst '{APP_NAME}' < {TEMPLATES_DIR}/backend/run.sh > {APP_DIR}/run.sh")
            out(f"cp {TEMPLATES_DIR}/dot_dockerignore {APP_DIR}/.dockerignore")
            pass
        if case("2"): 
            print("Using frontend template...")
            out(f"mkdir -p {APP_DIR}")
            out(f"cp -R {TEMPLATES_DIR}/frontend/* {APP_DIR}")
            out(f"envsubst '{APP_NAME}' < {TEMPLATES_DIR}/frontend/package.json > {APP_DIR}/package.json")
            out(f"envsubst '{APP_NAME}' < {TEMPLATES_DIR}/frontend/run.sh > ${APP_DIR}/run.sh")
            out(f"cp {TEMPLATES_DIR}/dot_dockerignore {APP_DIR}/.dockerignore")
        if case(): 
            print("Unknown template name, exiting...")
            sys.exit()


def tf_atlantis(*argv):
    check_ci_mode("tf_atlantis")
    
    if not TF_BACKEND_CREDENTIALS:
        print(f"Error: TF_BACKEND_CREDENTIALS is not set. Aborting")
        sys.exit(1)

    SCRIPT=f"{SRC_DIR}/tools/kubify/atlantis/bootstrap/terraform"
    out("""env $(echo "${TF_BACKEND_CREDENTIALS}" | xargs) ${SCRIPT} init && env $(echo "${TF_BACKEND_CREDENTIALS}" | xargs) ${SCRIPT} apply -auto-approve""")


def publish_atlantis_image(*argv):
    check_ci_mode("publish_atlantis_image")

    SCRIPT=f"{SRC_DIR}/tools/kubify/atlantis/atlantis-terragrunt-image/build.sh"
    out(f"chmod +x {SCRIPT}")
    out(f"{SCRIPT}")


def check_ci_mode(*argv):
    if KUBIFY_CI != "1":
        print(f"'kubify {argv[0]}' can be only run in CI mode.")
        sys.exit(1)


def publish_ci_image(*argv):
    check_ci_mode(argv[0])

    check_arg(argv[0], fr"No tag specified!")
    TAGS=argv[0]
    IMAGE_NAME=ci_image_name("kubify")
    
    # set -e
    
    os.environ['NPM_TOKEN']="get_npm_secret_direct"
    out(f"  docker build -t {IMAGE_NAME}:latest -f {K8S_DIR}/ci_image/Dockerfile {SRC_DIR}")

    for TAG in TAGS.replace(","," "):
        out(f"docker tag {IMAGE_NAME}:latest {IMAGE_NAME}:{TAG}")

    out(f"docker push {IMAGE_NAME}")


def help(*argv):
    parser.print_help()


def command(name):

    def func_not_implemented(name):
        def not_implemented(*argv, **kwargs):
            print(f"{name} is not implemented yet")
        return not_implemented

    def func(name):
        try:
            for case in switch(name):
                if case("dir"):
                    return dir
                if case("check"):
                    return check_arg
                if case("up"):
                    return up
                if case("down"):
                    return down
                if case("delete"):
                    return delete
                if case("status"):
                    return status
                if case("services"):
                    return services
                if case("images"):
                    return images
                if case("clean"):
                    return clean
                if case("ps"):
                    return ps
                if case("logs"):
                    return logs
                if case("new"):
                    return new
                if case("secrets"):
                    return secrets
                if case("start"):
                    return start
                if case("run"):
                    return run
                if case("run-all"):
                    return run_all
                if case("stop"):
                    return stop
                if case("stop-all"):
                    return stop_all
                if case("cmd"):
                    return cmd
                if case("url"):
                    return url
                if case("exec"):
                    return exec
                if case("environments"):
                    return environments
                if case():
                    return func_not_implemented(name)
        except StopIteration:
            print("{name} not implemented yet...")
    return func(name)


def main(*argv):
    global APP_VERSION
    global AWS_REGION
    global AWS_PROFILE
    global HOME
    global ADDR
    global NPM_TOKEN
    global K8_NPM_TOKEN
    global TF_BACKEND_CREDENTIALS
    global DIR
    global SRC_DIR
    global KUBIFY_CURRENT_VERSION
    global WORK_DIR
    global K8S_DIR
    global SKAFFOLD_UPDATE_CHECK
    global ENV
    global USER
    global KUBIFY_ENGINE
    global KUBIFY_CI
    global KUBIFY_VERBOSE
    global KUBIFY_DEBUG
    global KUBIFY_ENTRYPOINT_IMAGE
    global KUBIFY_CONTAINER_REGISTRY
    global KUBIFY_LOCAL_DOMAIN_SUFFIX
    global KUBIFY_LOCAL_DOMAIN
    global KUBIFY_UPSTREAM_DOMAIN_SUFFIX
    global KUBIFY_UPSTREAM_ENV_ACCOUNT
    global KUBIFY_NPM_CREDENTIALS_SECRET
    global PUBLISH_IMAGE_REPO_PREFIX
    global BASE64_DECODE
    global MINIKUBE    
    global PROFILE
    global MINIKUBE_DISK_SIZE
    global MINIKUBE_MEMORY
    global MINIKUBE_ADDONS
    global MINIKUBE_VM_DRIVER
    global SRC_MOUNT
    global HOME_MOUNT
    global BUILD_PROFILE
    global LOCAL_START_PROFILE
    global LOCAL_RUN_PROFILE
    global NAMESPACE
    global KUBECTL
    global HELM
    global KUBECTL_NS
    global SKAFFOLD
    global DOCKER
    global USER_NAME
    global ALL_ENV
    global AWS_ADMIN_PROFILE
    global AWS_ACCOUNT_NUMBER
    global DEV_KMS
    global TEST_KMS
    global STAGE_KMS
    global PROD_KMS

    if not DEBUG:
        APP_VERSION = os.environ.get("APP_VERSION","0.1")
        USER = os.environ["USER"]
        AWS_REGION = "us-west-2"
        AWS_PROFILE = "default"

        HOME = str(Path.home())
        ADDR= ["",""]
        NPM_TOKEN = os.environ.get("NPM_TOKEN", "")
        K8_NPM_TOKEN = os.environ.get("K8_NPM_TOKEN", "")
        TF_BACKEND_CREDENTIALS=os.environ.get("TF_BACKEND_CREDENTIALS", "")
        my_session = boto3.session.Session()
        my_region = my_session.region_name
        client = boto3.client("sts")
        my_aws_account_number = client.get_caller_identity()["Account"]

        if not os.environ.get('AWS_PROFILE'):
            os.environ['AWS_PROFILE'] = 'default'
        if not os.environ.get('AWS_REGION'):
            os.environ['AWS_REGION'] = my_region

        AWS_REGION = os.environ.get("AWS_REGION")
        if not os.environ.get('AWS_ACCOUNT_NUMBER'):
            os.environ['AWS_ACCOUNT_NUMBER'] = my_aws_account_number
        AWS_ACCOUNT_NUMBER =  os.environ['AWS_ACCOUNT_NUMBER']

        DIR=os.path.dirname(os.path.realpath(__file__))
        print("DIR", DIR)
        SRC_DIR=os.path.abspath(os.path.join(DIR, "../../"))
        print("SRC_DIR", DIR)
        repo = git.Repo(search_parent_directories=True)
        sha = repo.head.commit.hexsha
        short_sha = repo.git.rev_parse(sha, short=4)
        KUBIFY_CURRENT_VERSION=short_sha
        print("KUBIFY_CURRENT_VERSION", KUBIFY_CURRENT_VERSION)
        WORK_DIR=os.path.join(SRC_DIR, "_kubify_work")
        if not os.path.isdir(WORK_DIR): 
            os.mkdir(WORK_DIR)
        print("WORK_DIR", WORK_DIR)
        K8S_DIR=os.path.join(SRC_DIR, "tools/kubify/k8s")
        print("K8S_DIR", K8S_DIR)
        #TODO
        #alias kubify=${DIR}/kubify

        # Options
        SKAFFOLD_UPDATE_CHECK = env_var_or_default('SKAFFOLD_UPDATE_CHECK', '0')
        ENV = env_var_or_default('ENV', 'dev')

        # Flags
        KUBIFY_ENGINE= env_var_or_default('KUBIFY_ENGINE', 'local')   # Options: local or minikube
        KUBIFY_CI= env_var_or_default('KUBIFY_CI', '0')           # This is set to 1 in a Continuous Integration environment
        KUBIFY_VERBOSE= env_var_or_default('KUBIFY_VERBOSE', '1')      # Sets the verbose logging to true (if set to 1)
        KUBIFY_DEBUG = env_var_or_default('KUBIFY_DEBUG', '0')        # Sets the debug logging to true (if set to 1)
        KUBIFY_ENTRYPOINT_IMAGE = 'kubify/entrypoint'         # The entrypoint image for ad-hoc commands
        KUBIFY_CONTAINER_REGISTRY = ''        # Leave blank for DockerHub
        KUBIFY_LOCAL_DOMAIN_SUFFIX = 'kubify.local' # Local domain suffix 
        KUBIFY_LOCAL_DOMAIN = 'local.' + KUBIFY_LOCAL_DOMAIN_SUFFIX  # The local domain (for development)
        KUBIFY_UPSTREAM_DOMAIN_SUFFIX = 'kubify.com'  # The domain suffix for upstream environments (Example: <env>.kubify.local)
        KUBIFY_UPSTREAM_ENV_ACCOUNT = 'arn:aws:eks:' + os.environ["AWS_REGION"] + ':' + os.environ["AWS_ACCOUNT_NUMBER"]
        KUBIFY_NPM_CREDENTIALS_SECRET = 'npm-credentials'

        # CI Parameters
        PUBLISH_IMAGE_REPO_PREFIX = 'kubifyinc'

        # GLOBAL OS OPTIONS
        if "darwin" in platform.system().lower():
            BASE64_DECODE = "base64 -D"
            MINIKUBE = "minikube"
        elif "linux" in platform.system().lower():
            BASE64_DECODE = "base64 -d"
            MINIKUBE = "sudo minikube"
        else:
            #TODO windows actual compatibility, for now test with WSL2
            print("Unsupported system ", platform.system())
            sys.exit(1)

        if os.environ["KUBIFY_ENGINE"] == "minikube":
            PROFILE='kubify-kubifyk8'
            # Minikube parameters
            MINIKUBE_DISK_SIZE = '40g'
            MINIKUBE_MEMORY = 8192 # 8GB
            MINIKUBE_ADDONS = "ingress" # Separate multiple addons with spaces
            MINIKUBE_VM_DRIVER = "none" # Faster than virtualbox and allows dynamic memory management
            SRC_MOUNT = '/src/kubifyk8'
            HOME_MOUNT= '/config/home'
        elif os.environ["KUBIFY_ENGINE"] == "local":
            SRC_MOUNT= SRC_DIR
            HOME_MOUNT= HOME
            if "darwin" in platform.system().lower():
                PROFILE = os.environ.get('KUBIFY_PROFILE', 'docker-for-desktop')
            elif "linux" in platform.system().lower():
                PROFILE = os.environ.get('KUBIFY_PROFILE', 'default')

        BUILD_PROFILE='ci-build'          # Skaffold profile for building images in CI
        LOCAL_START_PROFILE='local-start' # Skaffold profile for watching changes
        LOCAL_RUN_PROFILE='local-run'     # Skaffold profile for running locally
        NAMESPACE = env_var_or_default('NAMESPACE','kubifyk8')    # Kubernetes namespace where apps are deployed

        if not os.environ.get("PROFILE", ""):
            KUBECTL = "kubectl"
            HELM = "helm"
        else:
            KUBECTL = "kubectl --context " + os.environ('PROFILE')
            HELM = "helm --kube-context " + os.environ('PROFILE')

        KUBECTL_NS = f"{KUBECTL} --namespace {NAMESPACE}"
        SKAFFOLD = f"skaffold --namespace {NAMESPACE}"
        DOCKER = "docker"

        USER_NAME = sh("git config --get user.name", rsrtrip=True) 

        ALL_ENV = ['dev', 'test', 'stage', 'prod' ]

        AWS_ADMIN_PROFILE = env_var_or_default('AWS_ADMIN_PROFILE', 'kubify-admin')
        AWS_ACCOUNT_NUMBER = boto3.client('sts').get_caller_identity().get('Account')

        # The key used to encrypt the secrets
        # TODO: Move this somewhere outside this le
        # TODO: Store this in AWS SSM ?
        DEV_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_NUMBER}:alias/secrets"
        TEST_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_NUMBER}:alias/secrets"
        STAGE_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_NUMBER}:alias/secrets"
        PROD_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_NUMBER}:alias/secrets"


    #TODO uncomment and nish this
    # def join_by(*argv):
    #     local IFS="$1"; 
    #     shift; 
    #     print("$*"; 

    try:
        sp_dir.set_defaults(func=command("dir"))
        sp_check.set_defaults(func=command("check"))
        sp_up.set_defaults(func=command("up"))
        sp_down.set_defaults(func=command("down"))
        sp_delete.set_defaults(func=command("delete"))
        sp_status.set_defaults(func=command("status"))
        sp_services.set_defaults(func=command("services"))
        sp_images.set_defaults(func=command("images"))
        sp_clean.set_defaults(func=command("clean"))
        sp_logs.set_defaults(func=command("logs"))
        sp_new.set_defaults(func=command("new"))
        sp_secrets_export.set_defaults(func=command("secrets export"))
        sp_secrets_import.set_defaults(func=command("secrets import"))
        sp_secrets_create.set_defaults(func=command("secrets create"))
        sp_secrets_view.set_defaults(func=command("secrets view"))
        sp_secrets_edit.set_defaults(func=command("secrets edit"))
        sp_start.set_defaults(func=command("start"))
        sp_run.set_defaults(func=command("run"))
        sp_run_all.set_defaults(func=command("run-all"))
        sp_stop.set_defaults(func=command("stop"))
        sp_stop_all.set_defaults(func=command("stop-all"))
        sp_cmd.set_defaults(func=command("cmd"))
        sp_url.set_defaults(func=command("url"))
        so_exec.set_defaults(func=command("exec"))
        sp_environments_list.set_defaults(func=command("environments list"))
        sp_environments_logs.set_defaults(func=command("environments logs"))
        sp_environments_view.set_defaults(func=command("environments view"))
        sp_environments_status.set_defaults(func=command("environments status"))
        sp_environments_diff.set_defaults(func=command("environments diff"))
        sp_environments_get_context.set_defaults(func=command("environments get-context"))
        sp_status.set_defaults(func=command("status"))

        args, cmd = parser.parse_known_args()
        args.func(cmd)
        parser.exit()
        
    except Exception as ex:
        print(ex.__str__())
        sys.exit(-1)

if __name__ == '__main__':
    main()

