import os
from pathlib import Path

import kubify.src.kubify
import kubify.src.core.app_constants as app_constants
from pytest_kind import KindCluster


class Down:
    def __init__(self):
        pass

    def down(self):
        os.environ["KUBECONFIG"] = f"{app_constants.cwd}/.pytest-kind/kubify/kubeconfig"
        kind_cluster = KindCluster(name="kubify")
        kind_cluster.delete()

    def main(self):
        self.down()


if __name__ == "__main__":
    down = Down()
    down.main()
