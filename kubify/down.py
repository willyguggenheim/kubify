from kubify.src.core.cluster.local.modules.pytest_kind import KindCluster


class Down:
    def __init__(self):
        pass

    def down(self):
        kind_cluster = KindCluster(name="kubify")
        kind_cluster.delete()

    def main(self):
        self.down()


if __name__ == "__main__":
    down = Down()
    down.main()
