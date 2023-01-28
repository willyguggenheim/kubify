import subprocess  # nosec - B404: placeholder until ported to python fully


class Start:
    def __init__(self):
        pass

    def start(self):
        subprocess.run(["kubify_port.sh", "start"])  # nosec: B603 B607 - placeholder
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
        self.start()


if __name__ == "__main__":
    start = Start()
    start.main()
