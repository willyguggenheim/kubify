import os
import yaml

import pathlib
import shutil

import ansible_runner
import kubify.src.core.app_constants as app_constants


class Start:
    def __init__(self):
        pass

    def start(self):
        service_cwd = os.getcwd()
        services_list = []
        for filepath in pathlib.Path(f"{os.getcwd()}/../").glob("*"):
            services_list.append(filepath)
        for filepath in pathlib.Path(f"{os.getcwd()}/../../").glob("*"):
            services_list.append(filepath)
        self._start_dependant_services(services_list)
        self.start_service(
            folder_path=service_cwd,
            start_or_run="start",
            playbook_file="service_start.yaml",
        )

    def start_service(
        self,
        folder_path,
        start_or_run,
        kubify_env="dev",
        namespace="demo",
        playbook_file="service_start.yaml",
        skaffold_action="dev",
    ):
        os.chdir(folder_path)
        with open(f"{os.getcwd()}/kubify.yml", "r") as file:
            kubify_yml = yaml.safe_load(file)
        skaffold_profile = f"local-{start_or_run}"
        os.environ["SKAFFOLD_PROFILE"] = f"local-{start_or_run}"
        if bool(kubify_yml.get("dev_sync_auto_rebuild")) is False:
            os.environ["SKAFFOLD_AUTO_BUILD"] = "false"
        os.environ["SKAFFOLD_AUTO_SYNC"] = "true"
        app_name = folder_path.split("/")[-1]
        app_env = os.environ.get("KUBIFY_ENV", kubify_env)
        env_domain = "kubify.local"
        print(f"Starting {app_name} Svc w/ Hot Reloading (kubify.yml sync folders)")
        self._run_ansible_playbook(
            folder_path, app_env, app_name, env_domain, playbook_file
        )
        self._copy_service_file_kubify_work(
            folder_path=folder_path,
            file_name="Dockerfile.dev",
            kubify_env=kubify_env,
            app_name=app_name,
        )
        self._copy_service_file_kubify_work(
            folder_path=folder_path,
            file_name="Dockerfile.release",
            kubify_env=kubify_env,
            app_name=app_name,
        )
        ansible_runner.interface.run_command(
            host_cwd=folder_path,
            executable_cmd="skaffold",
            cmdline_args=[
                skaffold_action,
                "--cache-artifacts",
                "--filename",
                f"{app_constants.kubify_work}/{kubify_env}/{app_name}/skaffold.yaml",
                "--profile",
                skaffold_profile,
                "--no-prune",
                "--no-prune-children",
                "--trigger=polling",
                "--port-forward=false",
            ],
        )

    def deploy_service(self, kubify_env, namespace="demo"):
        self.start_service(
            folder_path=os.getcwd(),
            start_or_run="run",
            kubify_env=kubify_env,
            namespace=namespace,
            playbook_file="deploy_service.yaml",
            skaffold_action="deploy",
        )

    def _start_dependant_services(self, services_list):
        print("Starting Dependant Svcs (kubify.yml depends_on chain)")
        with open(f"{os.getcwd()}/kubify.yml", "r") as file:
            kubify_yml = yaml.safe_load(file)
        if kubify_yml.get("depends_on"):
            for service in kubify_yml["depends_on"]:
                for service_path in services_list:
                    if service in str(service_path):
                        os.chdir(service_path)
                        self._start_dependant_services(services_list)
                        self.start_service(
                            folder_path=service_path,
                            start_or_run="run",
                            skaffold_action="run",
                        )

    def _run_ansible_playbook(
        self,
        folder_path,
        app_env,
        app_name,
        env_domain,
        playbook_file="service.yaml",
    ):
        ansible_runner.interface.run(
            inventory=f"{app_constants.ops_dir}/ansible/inventory.ini",
            playbook=f"{app_constants.ops_dir}/ansible/{playbook_file}",
            roles_path=f"{app_constants.ops_dir}/ansible/roles",
            extravars={
                "app_dir": str(folder_path),
                "app_name": app_name,
                "app_image": f"local_kubify_{app_name}_build",
                "app_cicd_build_image": f"{app_constants.docker_registry}/kubify/service/{app_name}",
                "env": app_env,
                "profile": app_env,
                "expose_service": "false",
                "env_domain": f"service.{env_domain}",
                "kubify_domain_env": app_env,
                "kubify_domain_suffix": env_domain,
                "is_local": "1",
                "cert_issuer": "ca-issuer",
                "build_profile": "ci-build",
                "skaffold_namespace": "kubify",
                "kubify_dir": app_constants.kubify_work,
                "kubify_version": app_constants.kubify_version,
            },
        )

    def _copy_service_file_kubify_work(
        self, folder_path, file_name, kubify_env, app_name
    ):
        file_path = f"{folder_path}/{file_name}"
        if os.path.isfile(file_path):
            shutil.copyfile(
                file_path,
                f"{app_constants.kubify_work}/{kubify_env}/{app_name}/{file_name}",
            )

    def main(self):
        self.start()


if __name__ == "__main__":
    start = Start()
    start.main()
