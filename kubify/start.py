# TODO (UNCOMMENT)
# import os
# import kubify.src.core.app_constants as app_constants
# from collections import namedtuple
# import ansible_runner

# TODO (COMMENT)
from subprocess import run as sp_run


class Start:
    def __init__(self):
        pass

    def start(self):
        # TODO (COMMENT)
        sp_run.run(["kubify_port.sh", "start"])
        # TODO (UNCOMMENT)
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
