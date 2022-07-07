"""Main module."""

import os
import kubify.aws_constants as aws_constants
import boto3

# from aws_utils.s3_utils import s3_utils
import kubify.aws_utils as s3_utils

# from k8s_utils.k8s import k8s_utils
import kubify.k8s_utils as k8s_utils


def create_work_dirs():
    pass
    # mkdir -p ${WORK_DIR}/repo_local
    # home/.kubify/work


def clean_secrets():
    pass


#   rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/cloudformation/*
#   rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/secr*
#   rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/gen-*
#   rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/*.log


def service_setup_secrets():
    #     SECRETS_FILE="${APP_DIR}/secrets/secrets.${ENV}.enc.yaml"
    #   CONFIG_FILE="${APP_DIR}/config/config.${ENV}.yaml"

    #   # if SECRETS_FILE not exist, let's create the intial secret
    #   if [ ! -f "${SECRETS_FILE}" ]; then
    #       kubify secrets create ${ENV}
    #   fi
    # if [ ! -f "${CONFIG_FILE}" ]; then
    #       echo "${CONFIG_FILE} file not found, creating blank one"
    #       mkdir -p "${APP_DIR}/config" | true
    #       cp "${GIT_DIR}/src/kubify/templates/config/config.${ENV}.yaml" "${CONFIG_FILE}"
    #       sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${CONFIG_FILE}"
    #   fi
    pass


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
    if command == "start":  # default
        service_init
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
    s3 = s3_utils()
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


if __name__ == "__main__":
    k8s = k8s_utils()
    os.environ["K8S_OVERRIDE_CONTEXT"] = "kind-kind"
    # k8s.set_context_get_client(os.environ.get('K8S_OVERRIDE_CONTEXT', 'default'))
    test_or_create_s3_artifacts_bucket()
    k8s.get_entrypoint()
    k8s.get_service_pod("abc")
