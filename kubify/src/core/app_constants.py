import os

from pathlib import Path

env = "dev"
app_name = "kubify"
dir_path = os.path.dirname(os.path.realpath(__file__))
# what is this for?
cwd = os.getcwd()
root_dir = os.path.join(*[dir_path, "..", "..", ".."])
root_dir_full_path = os.path.abspath(root_dir)
git_dir = os.path.join(root_dir_full_path, ".git")
home = str(Path.home())
# WORK_DIR
WORK_DIR = os.path.join(*[home, ".kubify"])
kubify_work = os.path.join(*[home, ".kubify"])
k8s_path = os.path.join(*[root_dir_full_path, "kubify", "ops", "templates", "k8s"])
log_path = os.path.join(kubify_work, "logs")
certs_path = os.path.join(kubify_work, "certs")
cloud_formation_path = os.path.join(*[kubify_work, env, app_name, "cloudformation"])
manifests_path = os.path.join(*[kubify_work, env, app_name, "manifests"])
app_path = os.path.join(*[kubify_work, env, app_name])
secrets_path = os.path.join(app_path, "secrets")
secrets_file = f"{secrets_path}/secrets.{env}.enc.yaml"
config_path = os.path.join(app_path, "config")
config_file = f"{config_path}/config.{env}.enc.yaml"
#
ops_dir = os.path.join(*[root_dir_full_path, "kubify", "ops"])
ansible_dir = os.path.join(*[ops_dir, "ansible"])


KUBIFY_LOCAL_DOMAIN_SUFFIX = "kubify.local"  # Local domain suffix
KUBIFY_LOCAL_DOMAIN = (
    f"local.{KUBIFY_LOCAL_DOMAIN_SUFFIX}"  # The local domain (for development)
)
KUBIFY_UPSTREAM_DOMAIN_SUFFIX = os.environ.get(
    "KUBIFY_UPSTREAM_DOMAIN_SUFFIX", "kubify.com"
)  # The domain suffix for upstream environments (Example: <env>.kubify.local)
AWS_REGION = os.environ.get("KUBIFY_AWS_REGION", "us-east-1")
AWS_PROFILE = os.environ.get("KUBIFY_AWS_PROFILE", "default")
AWS_ACCOUNT_ID = ""  # TODO

KUBIFY_UPSTREAM_ENV_ACCOUNT = f"arn:aws:eks:{AWS_REGION}:{AWS_ACCOUNT_ID}"
# KUBIFY_NPM_CREDENTIALS_SECRET = "npm-credentials"

USER_NAME = "git config --get user.name"
ALL_ENV = ["dev", "test", "stage", "prod"]
KMS_KEY_NAME = f"kubify_secrets_{env}"
DEV_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_ID}:alias/{KMS_KEY_NAME}"
TEST_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_ID}:alias/{KMS_KEY_NAME}"
STAGE_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_ID}:alias/{KMS_KEY_NAME}"
PROD_KMS = f"arn:aws:kms:{AWS_REGION}:{AWS_ACCOUNT_ID}:alias/{KMS_KEY_NAME}"
