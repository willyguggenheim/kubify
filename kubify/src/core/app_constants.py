import os
from pathlib import Path

env = "dev"
app_name = "kubify"
# cwd = os.path.dirname(__file__)
cwd = Path(".")
# what is this for?
root_dir = os.path.join(*[cwd, "..", ".."])
home = str(Path.home())
kubify_work = os.path.join(*[home, "kubify_work"])
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
ops_dir = os.path.join(*[cwd, "..", "..", "ops"])
ansible_dir = os.path.join(*[ops_dir, "ansible"])


def get_project_root_dir():
    return os.path.abspath(cwd)
