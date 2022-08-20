"""Main module."""

import os
import os.path
import glob
import boto3
import logging
from collections import namedtuple
import kubify

import kubify.src.aws_constants as aws_constants
import kubify.src.aws.s3_utils as s3_utils
import kubify.src.core.k8s_utils as k8s_utils

import kubify.src.core.app_constants as app_constants
import kubify.src.core.logging as my_logging
import kubify.src.core.file_utils as file_utils

from ansible.executor.playbook_executor import PlaybookExecutor, Options


# do this before logging for log file to be in work dir
def create_work_dirs():
    if not os.path.exists(app_constants.kubify_work):
        os.makedirs(app_constants.kubify_work)
    if not os.path.exists(app_constants.certs_path):
        os.makedirs(app_constants.certs_path)


create_work_dirs()


my_logging.setup_logger()
_logger = logging.getLogger()


def test_logger():
    _logger.info("test logger")
    _logger.debug("test logger")
    _logger.warning("test logger")
    _logger.error("test logger")
    _logger.critical("test logger")


kubify_utils = k8s_utils.K8SUtils()
os.environ["K8S_OVERRIDE_CONTEXT"] = "kind-kind"

# TODO: also needs uninstall ("undeploy") for reset
def run_ansible(
    playbooks=["../ops/ansible/install_kubify_on_mac.yaml"],
    uninstall="no",
    tags=["aws"],
):
    Options = namedtuple("Options", [])
    options = Options(verbosity=None, check=False, tags=tags)
    PlaybookExecutor(
        playbooks=playbooks,
        inventory=None,
        variable_manager=None,
        loader=None,
        options=options,
        passwords=None,
    ).run()


def clean_secrets(env, app_name):
    # TODO add safety check
    file_list = glob.glob(f"{app_constants.cloud_formation_path}/*")
    file_utils.delete_file_list(file_list)
    file_list = glob.glob(f"{app_constants.secrets_path}/secr*")
    file_utils.delete_file_list(file_list)
    file_list = glob.glob(f"{app_constants.secrets_path}/gen-*")
    file_utils.delete_file_list(file_list)
    file_list = glob.glob(f"{app_constants.secrets_path}/*.log")
    file_utils.delete_file_list(file_list)


def service_setup_secrets(env):
    # TODO double check these paths
    secrets_file = f"{app_constants.secrets_path}/secrets.{env}.enc.yaml"
    config_path = os.path.join(app_constants.app_path, "config")
    config_file = f"{config_path}/config.{env}.enc.yaml"
    if not os.path.isfile(secrets_file):
        #   # if SECRETS_FILE not exist, let's create the intial secret
        #       kubify secrets create ${ENV}
        #       create)
        #           echo "Creating secrets for ${APP_NAME} for ${ENV} environment"
        #           echo "Note: You can change the secrets text editor by setting the EDITOR env var"
        #           if [ ! -f "${SECRETS_FILE}" ]; then
        #               echo "${SECRETS_FILE} file not found, creating blank encrypted secret file and opening it with your EDITOR"
        #               mkdir -p $APP_DIR/secrets | true
        #               cp "${GIT_DIR}/src/kubify/templates/secrets/secrets.${ENV}.enc.yaml" "${SECRETS_FILE}"
        #               # cat "${SECRETS_FILE}" | sed "s/name: common/name: ${APP_NAME}/g"
        #               sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${SECRETS_FILE}"
        #               # awk '{gsub("common", "${APP_NAME}", $0); print}' "${SECRETS_FILE}"
        #               # rm -f "${SECRETS_FILE}"
        #               # mv "${SECRETS_FILE}"_SED "${SECRETS_FILE}"
        #           fi

        #           aws kms list-aliases | grep kubify | grep ${ENV} || echo " please create your KMS key with it's alias, ARN should be like \"${!KEY_VAR}\" "

        #           kubesec encrypt -i --key="${!KEY_VAR}" "${SECRETS_FILE}" || kubesec encrypt -i --key="${!KEY_VAR}" "${SECRETS_FILE}" --cleartext
        #           echo "Reloading secrets in-cluster"
        #           _generate_manifests "$APP_DIR"
        #           ;;
        #           echo "
        # # Please make sure you set the values in data like so (so kubesec can encrypt the key/values properly):
        # apiVersion: v1
        # data:
        #   example_key: 'example_value'
        # kind: Secret
        # metadata:
        #   name: common
        # type: Opaque
        #           "
        #           read -p "Press enter to continue (your EDITOR will open for secrets editing, default EDITOR is vi)........."

        #           kubesec edit -if "${SECRETS_FILE}" --key="${!KEY_VAR}"
        #           echo "Reloading secrets in-cluster"
        #           _generate_manifests "$APP_DIR"
        #           ;;
        #       view)
        #           kubesec decrypt "${SECRETS_FILE}" --cleartext \
        #             --template=$'{{ range $k, $v := .data }}{{ $k }}={{ $v }}\n{{ end }}'
        #           ;;
        #       *)
        #           echo "Invalid option - $1"
        #   esac

        pass
    # if not os.path.isfile(config_file):
    #     src_config = f"{cwd}../templates/config.{env}.yaml"
    #     copy_file(src_config, config_file)


#       sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${CONFIG_FILE}"


def service_start_dependencies():
    pass  # start_dependencies "${APP_DIR}" read yaml find depency run if not running (might have started with start for code listening) if running skip, follow dependency change start them all


def cloud_deploy_services():
    pass


def print_local_debug_info():
    pass


#   echo "Listening for code changes (on sync folders).."
#   # echo "Starting application '$APP_NAME' for local development. Changes (kubify.yml sync folder mapping list) will be watched for rapid testing (will rebuild fast with each code save)."
#   # echo "
#   # "
#   # echo "NOTE: Once the application is running, you can find it's ingress SSL Proxy URL (for host access and testing real world URL) by running 'kubify url' from this same folder."
#   # echo "
#   # "
#   echo "NOTE: From Workstation (Outside Kind Cluster Network) to Access URL: kubify url: https://${APP_NAME}.local.kubify.local"
#   echo "NOTE: From services: ${APP_NAME}.demo.svc"
#   echo "NOTE: From services to KubeDB Databases: ${APP_NAME}-[database_name].demo.svc"
#   # echo "NOTE: ^^ This is not to be confused with the dns name that you use to connect a service to another service: [service_name].demo.svc"
#   echo "NOTE: Access DB or to/from additional Ports: kubectl -n demo port-forward [pod] [port]:[port]"
#   # TODO: automate this in kubify command and document it (super useful):
#   # echo "NOTE: If you need to access more ports (such as a debugger port) or a database (such as postgres 5432 port), use kubectl port-forward command (to a local or a to a deployed remote k8s/eks/kubernetes cluster)."


def init():
    # set context to kind-kind
    pass


def service_init():
    # ansible-playbook \
    #     --connection=local \
    #     --inventory=127.0.0.1, "${K8S_DIR}/ansible/service.yaml" \
    #     --extra-vars="${EXPOSE_SERVICE_FLAG} env_domain=${ENV_DOMAIN} profile=${SERVICE_PROFILE} ${IS_LOCAL} cert_issuer=${CERT_ISSUER} ${KUBIFY_DOMAIN_ENV} kubify_domain_suffix=${KUBIFY_DOMAIN_SUFFIX} build_profile=${BUILD_PROFILE} skaffold_namespace=${NAMESPACE} env=${ENV} kubify_dir=${WORK_DIR} app_dir=${APP_DIR} app_name=${APP_NAME} app_image=${IMAGE} app_cicd_build_image=${CI_BUILD_IMAGE} kubify_version=${KUBIFY_CURRENT_VERSION} ${VARS}" \
    #     --tags=$TAGS
    pass
    # this is the heart of the program
    # takes all the input from kubify yaml and extracts number of config mainfest db cloudformation files
    # lambda etc
    # just call the ansible


def service(command="start"):
    pass
    # if command == "start":  # default
    #     service_init
    # read yaml if aws_only or false then go to skaffold


#   cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || ${SKAFFOLD} dev \
#         --cache-artifacts \
#         --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml \
#         --profile $SKAFFOLD_PROFILE \
#         --no-prune \
#         --no-prune-children \
#         --trigger='polling' \
#         --port-forward=false


def service_stop():
    pass


def test_or_create_s3_artifacts_bucket(
    bucket_name=aws_constants.BUCKET_NAME,
    region=aws_constants.AWS_REGION,
    dr_replication=True,
):
    print(
        "checking access to artifacts s3 bucket to exist, creating it (with encryption at rest enabled) if it does not exist.."
    )
    s3 = s3_utils.S3Utils()
    bucket = s3.get_bucket(bucket_name)
    if bucket:
        print("success: s3 bucket access working")
    else:
        print("could not find s3 bucket, so creating it")
        s3.create_bucket(bucket_name, region)
        s3.put_bucket_encryption(bucket_name)
        versioning = s3.BucketVersioning(bucket_name)
        versioning.enable()
        s3.put_public_access_block(
            Bucket=bucket_name,
            PublicAccessBlockConfiguration={
                "BlockPublicAcls": True,
                "IgnorePublicAcls": True,
                "BlockPublicPolicy": True,
                "RestrictPublicBuckets": True,
            },
        )
        s3.put_bucket_versioning(
            Bucket=bucket_name,
            VersioningConfiguration={"Status": "Enabled"},
        )
        if dr_replication:
            primary_bucket_name = bucket_name
            dr_bucket_name = f"{bucket_name}-dr"
            dr_region = "us-east-1"  # region with latest features, so it's good for DR workloads
            test_or_create_s3_artifacts_bucket(
                bucket_name=dr_bucket_name, region=dr_region, dr_replication=False
            )
            client = boto3.client("sts")
            account_id = client.get_caller_identity()["Account"]
            s3.put_bucket_replication(
                Bucket=primary_bucket_name,
                # Modify the entry below with your account and the replication role you created
                ReplicationConfiguration={
                    "Role": f"arn:aws:iam::{account_id}:role/ReplicationRole",
                    "Rules": [
                        {
                            "Priority": 1,
                            "Destination": {"Bucket": f"arn:aws:s3:::{dr_bucket_name}"},
                            "Status": "Enabled",
                        },
                    ],
                },
            )
        print("s3 bucket replication, versioning and security set")


def set_context_kind_kind():
    kubify_utils.set_context_kind_kind()


def get_entrypoint():
    kubify_utils.get_entrypoint()


def build_entrypoint():
    kubify_utils.build_entrypoint()


def get_service_pod(pod_name):
    kubify_utils.get_service_pod(pod_name)


# if __name__ == "__main__":
#     k8s_utils = k8s_utils.K8SUtils()
#     os.environ["K8S_OVERRIDE_CONTEXT"] = "kind-kind"
