#!/bin/python3

import os
from pathlib import Path

import kubify.src.kubify
import kubify.src.core.app_constants as app_constants
from pytest_kind import KindCluster


class Down:
    def __init__(self):
        pass

    def down(self):
        print("💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻")
        print(
            "..........😎 Pausing All Services and Kubify Kind K8s Cluster 😎.........."
        )
        print("💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻")
        cluster = KindCluster(name="kind")
        cluster.delete()

    def main(self):
        self.down()


if __name__ == "__main__":
    down = Down()
    down.main()
