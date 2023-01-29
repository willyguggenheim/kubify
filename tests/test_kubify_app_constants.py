import kubify.src.core.app_constants as app_constants
import os.path
from pathlib import Path


def test_dir_paths():
    env = "dev"
    app_name = "kubify"
    path = Path(f"{app_constants.root_dir}/cli.py")
    assert path.is_file()  # nosec - ✅ B101: assert used
    # os.path.isfile(fname)
    path = Path(f"{app_constants.root_dir_full_path}/cli.py")
    assert path.is_file()  # nosec - ✅ B101: assert used
    path = Path(f"{app_constants.k8s_path}/kubify.yaml")
    assert path.is_file()  # nosec - ✅ B101: assert used
    path = Path(f"{app_constants.ops_dir}/ansible")
    assert path.exists()  # nosec - ✅ B101: assert used
    path = Path(f"{app_constants.ops_dir}/terraform")
    assert path.exists()  # nosec - ✅ B101: assert used
    path = Path(f"{app_constants.ansible_dir}")
    assert path.exists()  # nosec - ✅ B101: assert used
