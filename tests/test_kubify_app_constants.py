import kubify.src.core.app_constants as app_constants
import os.path
from pathlib import Path


def test_dir_paths():
    env = "dev"
    app_name = "kubify"
    path = Path(f"{app_constants.root_dir}/__version__")
    assert path.is_file()
    # os.path.isfile(fname)
    path = Path(f"{app_constants.root_dir_full_path}/__version__")
    assert path.is_file()
    path = Path(f"{app_constants.git_dir}/HEAD")
    assert path.is_file()
    path = Path(f"{app_constants.k8s_path}/kubify.yaml")
    assert path.is_file()
    path = Path(f"{app_constants.ops_dir}/ansible")
    assert path.exists()
    path = Path(f"{app_constants.ops_dir}/terraform")
    assert path.exists()
    path = Path(f"{app_constants.ansible_dir}")
    assert path.exists()
