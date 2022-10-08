"""Main module."""

import os

# import sys
import os.path

# import glob
# import boto3
import logging

# from collections import namedtuple
# from pathlib import Path

import kubify.src.aws.s3_utils as kubify_utils

import kubify.up as kubify_up

# TODO
# import kubify.down as kubify_down
import kubify.start as kubify_start

import kubify.src.aws_constants as aws_constants

import kubify.src.core.app_constants as app_constants
import kubify.src.core.log as my_logging

# do this before logging for log file to be in work dir
def create_work_dirs():
    if not os.path.exists(app_constants.kubify_work):
        os.makedirs(app_constants.kubify_work)
    if not os.path.exists(app_constants.certs_path):
        os.makedirs(app_constants.certs_path)


create_work_dirs()

# kubify_utils = k8s_utils.K8SUtils()
# os.environ["K8S_OVERRIDE_CONTEXT"] = "kind-kind"

# KUBIFY_DEBUG = True
# KUBIFY_OUT = "/dev/null"
# ANSIBLE_VERBOSITY = 1


# def read_flag_verbose():
#     if KUBIFY_DEBUG:
#         # set -o xtrace
#         ANSIBLE_VERBOSITY = 4
#         KUBIFY_OUT = "/dev/stdout"
#     else:
#         ANSIBLE_VERBOSITY = 1
#         KUBIFY_OUT = "/dev/null"
#     os.environ["ANSIBLE_VERBOSITY"] = ANSIBLE_VERBOSITY

my_logging.setup_logger()
_logger = logging.getLogger()


def test_logger():
    _logger.info("test logger")
    _logger.debug("test logger")
    _logger.warning("test logger")
    _logger.error("test logger")
    _logger.critical("test logger")


def kubify_version():
    return git_utils.git_version()


def up():
    kubify_up_class = kubify_up.Up()
    kubify_up_class.up()


# TODO
# def down():
#     kubify_down_class = kubify_down.Down()
#     kubify_down_class.down()


def start():  # start service in rapid testing coding mode
    kubify_start_class = kubify_start.Start()
    kubify_start_class.start()


# def generate_certs():
#     path = Path(f"{app_constants.kubify_work}/certs/ca.key")
#     if not path.is_file():
#         logging.info("generating ca.key")
#         # TODO fix this
#         certs.create_signed_cert(cn="www.kubify.com")


# def build_image(image_name, src_path):
#     client = docker.from_env()
#     client.images.build(
#         path=src_path,
#         tag=f"{image_name}:latest",
#     )


# def get_service_pod(APP_NAME):
#     # timeout 10 ${KUBECTL_NS} rollout status -w deployment/${APP_NAME} &> /dev/null
#     # echo $(${KUBECTL_NS} get pods -o wide --field-selector=status.phase=Running -l app=${APP_NAME} --no-headers | cut -d ' ' -f1 | head -n 1)
#     pass


# # def update_registry_secret():
# # def update_npm_secret():
# # def get_npm_secret_direct
# # def get_npm_secret

# # def generate_local_cluster_cert():
# #     docker run -e COMMON_NAME="*.${KUBIFY_LOCAL_DOMAIN}" -v "${WORK_DIR}/certs:/certs" -w /certs -it alpine:latest sh -c ./gen-certs.sh


# def debug():
#     logging.info("!!ALL THE kube-system NAMESPACE OBJECTS:")
#     kind.get_api_resources()
#     # $KUBECTL api-resources --verbs=list --namespaced -o name | xargs -n 1 $KUBECTL get --show-kind --ignore-not-found -n kube-system
#     logging.info("!!ALL THE kubify NAMESPACE OBJECTS:")
#     # $KUBECTL api-resources --verbs=list --namespaced -o name | xargs -n 1 $KUBECTL get --show-kind --ignore-not-found -n demo


# def configure_cluster():
#     MANIFESTS = f"{app_constants.k8s_path}"
#     TILLERLESS = os.environ.get("TILLERLESS", False)
#     UPSTREAM = os.environ.get("UPSTREAM", False)
#     if TILLERLESS:
#         TILLER = "tiller run helm"
#     else:
#         TILLER = ""
#     logging.info("Configuring cluster")
#     logging.info("Printing Kind K8s Cluster ID..")
#     logging.info("Kubernetes Cluster ID ->")

#     k8s_cluster_id = (
#         kind.get_cluster_id()
#     )  # `kubectl get ns kube-system -o=jsonpath='{.metadata.uid}'`
#     logging.info(f"{k8s_cluster_id}")
#     logging.info("<-")
#     logging.info(
#         f"""
#       Go to https://license-issuer.appscode.com
#       Register for a license for KubeDB Product
#       Choose 'KubeDB Community Edition'
#       Put in the kubernetes cluster ID: {k8s_cluster_id}
#       After receiving license in email from registering
#       Copy the license file to ~/kubify/kubedb.txt
#       IMPORTANT NOTE: DO NOT SKIP THIS STEP (unless you are in-place re-installing on existing kind cluster)
#         BUT WHY: The liscense file ~/kubify/kubedb.txt is unique to each kind (kubernetes) cluster..........
#       Click enter to continue (after placing fle) 😎"
#       """
#     )
#     # TODO
#     # app_code = get_user_input():#read
#     logging.info(
#         "Thank you! 😎 Continuing Kubify installer, if you recently reset your Docker then this would be a good time to get some coffee (entrypoint container takes a few minutes to build if not already built)....."
#     )
#     # if [ -z "$PROFILE" ]; then
#     # KUBECTL="kubectl"
#     # HELM="helm"
#     # else
#     # KUBECTL="kubectl --context ${PROFILE}"
#     # HELM="helm --kube-context ${PROFILE}"
#     # fi
#     # $HELM repo add stakater https://stakater.github.io/stakater-charts
#     # $HELM repo add stable   https://charts.helm.sh/stable
#     # $HELM repo add appscode https://charts.appscode.com/stable/
#     # $HELM repo add jetstack https://charts.jetstack.io
#     # # https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
#     # $HELM repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#     # $HELM repo update
#     # kubectl create namespace demo || true
#     # Testing New Version:
#     # helm repo add appscode https://charts.appscode.com/stable/
#     # helm repo update
#     # KUBEDB_VERSION=v2021.12.21
#     # # KUBEDB_VERSION=v0.20.0
#     # KUBEDB_CATALOG_VERSION=v2021.12.21
#     # # must use "demo" namespace in free edition
#     # helm install kubedb appscode/kubedb \
#     #   --version ${KUBEDB_VERSION} \
#     #   --namespace demo --create-namespace \
#     #   --set-file global.license="${HOME}/kubify/kubedb.txt" || true
#     # if `$KUBECTL --namespace demo get pods | grep kubedb` ; then
#     #     echo "KubeDB is already installed, so running upgrade command instead.."
#     #     echo "TODO: remove the '|| true' workaround once they release a stable KubeDB version release (since they already fixed in master looks like)"
#     #     $HELM ${TILLER} upgrade kubedb appscode/kubedb --install --version $KUBEDB_VERSION --namespace demo || true
#     # else
#     #     echo "Installing KubeDB.."
#     #     # #TODO: look into why the uninstaller for the recent release of kubedb is borked, but for now another workaround
#     #     # $KUBECTL delete psp elasticsearch-db || true
#     #     # $KUBECTL delete psp maria-db || true
#     #     # memcached-db
#     #     # mongodb-db
#     #     # mysql-db
#     #     # percona-xtradb-db
#     #     # postgres-db
#     #     # proxysql-db
#     #     # redis-db
#     #     echo "TODO: remove the '|| true' workaround once they release a stable KubeDB version release (since they already fixed in master looks like)"
#     #     $HELM ${TILLER} install kubedb appscode/kubedb --version $KUBEDB_VERSION --namespace demo || true
#     # fi


# # TODO: also needs uninstall ("undeploy") for reset
# def run_ansible(
#     playbooks=["../ops/ansible/install_kubify_on_mac.yaml"],
#     uninstall="no",
#     tags=["aws"],
# ):
#     Options = namedtuple("Options", [])
#     options = Options(verbosity=None, check=False, tags=tags)
#     PlaybookExecutor(
#         playbooks=playbooks,
#         inventory=None,
#         variable_manager=None,
#         loader=None,
#         options=options,
#         passwords=None,
#     ).run()


# def clean_secrets(env, app_name):
#     # TODO add safety check
#     file_list = glob.glob(f"{app_constants.cloud_formation_path}/*")
#     file_utils.delete_file_list(file_list)
#     file_list = glob.glob(f"{app_constants.secrets_path}/secr*")
#     file_utils.delete_file_list(file_list)
#     file_list = glob.glob(f"{app_constants.secrets_path}/gen-*")
#     file_utils.delete_file_list(file_list)
#     file_list = glob.glob(f"{app_constants.secrets_path}/*.log")
#     file_utils.delete_file_list(file_list)


# def service_setup_secrets(env):
#     # TODO double check these paths
#     secrets_file = f"{app_constants.secrets_path}/secrets.{env}.enc.yaml"
#     config_path = os.path.join(app_constants.app_path, "config")
#     config_file = f"{config_path}/config.{env}.enc.yaml"
#     if not os.path.isfile(secrets_file):
#         pass


# def service_start_dependencies():
#     pass  # start_dependencies "${APP_DIR}" read yaml find depency run if not running (might have started with start for code listening) if running skip, follow dependency change start them all


# def cloud_deploy_services():
#     pass


# def print_local_debug_info():
#     pass


# def init():
#     # set context to kind-kind
#     pass


# def service_init():
#     # ansible-playbook \
#     #     --connection=local \
#     #     --inventory=127.0.0.1, "${K8S_DIR}/ansible/service.yaml" \
#     #     --extra-vars="${EXPOSE_SERVICE_FLAG} env_domain=${ENV_DOMAIN} profile=${SERVICE_PROFILE} ${IS_LOCAL} cert_issuer=${CERT_ISSUER} ${KUBIFY_DOMAIN_ENV} kubify_domain_suffix=${KUBIFY_DOMAIN_SUFFIX} build_profile=${BUILD_PROFILE} skaffold_namespace=${NAMESPACE} env=${ENV} kubify_dir=${WORK_DIR} app_dir=${APP_DIR} app_name=${APP_NAME} app_image=${IMAGE} app_cicd_build_image=${CI_BUILD_IMAGE} kubify_version=${KUBIFY_CURRENT_VERSION} ${VARS}" \
#     #     --tags=$TAGS
#     pass
#     # this is the heart of the program
#     # takes all the input from kubify yaml and extracts number of config mainfest db cloudformation files
#     # lambda etc
#     # just call the ansible


# def service(command="start"):
#     pass
#     # if command == "start":  # default
#     #     service_init
#     # read yaml if aws_only or false then go to skaffold


# #   cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || ${SKAFFOLD} dev \
# #         --cache-artifacts \
# #         --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml \
# #         --profile $SKAFFOLD_PROFILE \
# #         --no-prune \
# #         --no-prune-children \
# #         --trigger='polling' \
# #         --port-forward=false


# def service_stop():
#     pass


def test_or_create_s3_artifacts_bucket(
    bucket_name=aws_constants.BUCKET_NAME,
    region=aws_constants.AWS_REGION,
    dr_replication=True,
):
    print(
        "checking access to artifacts s3 bucket to exist, creating it (with encryption at rest enabled) if it does not exist.."
    )
    s3 = kubify_utils.s3_utils.S3Utils()
    bucket = s3.get_bucket(bucket_name)
    if bucket:
        print("success: s3 bucket access working")
    else:
        print("could not find s3 bucket, so creating it")
        s3.create_bucket(bucket_name, region)
        s3.put_bucket_encryption(bucket_name)
        # versioning = s3.BucketVersioning(bucket_name)
        # versioning.enable()
        # s3.put_public_access_block(
        #     Bucket=bucket_name,
        #     PublicAccessBlockConfiguration={
        #         "BlockPublicAcls": True,
        #         "IgnorePublicAcls": True,
        #         "BlockPublicPolicy": True,
        #         "RestrictPublicBuckets": True,
        #     },
        # )
        # s3.put_bucket_versioning(
        #     Bucket=bucket_name,
        #     VersioningConfiguration={"Status": "Enabled"},
        # )
        # if dr_replication:
        #     primary_bucket_name = bucket_name
        #     dr_bucket_name = f"{bucket_name}-dr"
        #     dr_region = "us-east-1"  # region with latest features, so it's good for DR workloads
        #     test_or_create_s3_artifacts_bucket(
        #         bucket_name=dr_bucket_name, region=dr_region, dr_replication=False
        #     )
        #     client = boto3.client("sts")
        #     account_id = client.get_caller_identity()["Account"]
        #     s3.put_bucket_replication(
        #         Bucket=primary_bucket_name,
        #         # Modify the entry below with your account and the replication role you created
        #         ReplicationConfiguration={
        #             "Role": f"arn:aws:iam::{account_id}:role/ReplicationRole",
        #             "Rules": [
        #                 {
        #                     "Priority": 1,
        #                     "Destination": {"Bucket": f"arn:aws:s3:::{dr_bucket_name}"},
        #                     "Status": "Enabled",
        #                 },
        #             ],
        #         },
        #     )
        # print("s3 bucket replication, versioning and security set")


# def set_context_kind_kind():
#     kubify_utils.set_context_kind_kind()


# def get_entrypoint():
#     kubify_utils.get_entrypoint()


# def build_entrypoint():
#     kubify_utils.build_entrypoint()


# def get_service_pod(pod_name):
#     kubify_utils.get_service_pod(pod_name)


# if __name__ == "__main__":
#     k8s_utils = k8s_utils.K8SUtils()
#     os.environ["K8S_OVERRIDE_CONTEXT"] = "kind-kind"
