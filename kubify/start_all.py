import subprocess  # nosec - B404: placeholder until ported to python fully


class StartAll:
    def __init__(self):
        pass

    def start_all(self):
        subprocess.run(  # nosec: B603 B607 - placeholder
            ["kubify_port.sh", "start-all"]
        )
        # tags = ([f"common,{app_constants.dir_path}"],)
        # Options = namedtuple("Options", [])
        # options = Options(verbosity=1, check=False, tags=tags)
        # print(os.environ["KUBECONFIG"])
        # ansible_runner.interface.run(
        #     playbook=f"{app_constants.ops_dir}/ansible/service.yaml",
        #     verbosity=1,
        #     options=options,
        #     tags=tags,
        # )

    def main(self):
        self.start_all()


if __name__ == "__main__":
    start = StartAll()
    start.main()
