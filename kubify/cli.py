"""Console Script for Kubify."""
import argparse
import sys
import kubify.src.kubify as kubify


def main():
    parser = argparse.ArgumentParser(description="Python CLI for Kubify")
    parser.add_argument(
        "--up",
        action="store_true",
        default=False,
        help="start kubify kind local rapid testing kubernetes cluster",
    )
    parser.add_argument(
        "--down",
        action="store_true",
        default=False,
        help="pause all running services and local cluster",
    )
    parser.add_argument(
        "--start",
        action="store_true",
        default=False,
        help="start service and it's kubify.yaml depends_on services, listen for code changes on all services",
    )
    parser.add_argument(
        "--start-all",
        action="store_true",
        default=False,
        help="listen for code changes on all services, and infra, locally in your kind cluster and ready for code changes live",
    )
    parser.add_argument(
        "--test_logger",
        action="store_true",
        default=False,
        help="test logger functionality",
    )
    parser.add_argument(
        "--test_or_create_s3_artifacts_bucket",
        action="store_true",
        default=False,
        help="sets the s3 bucket for state file for terraform",
    )
    # parser.add_argument(
    #     "--create_work_dirs", action="store_true", help="in users home kubify directory"
    # )
    # parser.add_argument(
    #     "--set_context_kind_kind",
    #     action="store_true",
    #     help="sets the kuberenetes context to kind",
    # )
    # parser.add_argument(
    #     "--get_entrypoint", action="store_true", help="gets the entrypoint pod"
    # )
    # parser.add_argument(
    #     "--get_service_pod", action="store_true", help="gets the get_service_pod"
    # )

    if len(sys.argv) <= 1:
        sys.argv.append("--help")

    args = parser.parse_args()

    if args.up:
        kubify.up()
    if args.down:
        kubify.down()
    if args.start:
        kubify.start()
    if args.start_all:
        kubify.start_all()
    if args.test_logger:
        kubify.test_logger()
    if args.test_or_create_s3_artifacts_bucket:
        kubify.test_or_create_s3_artifacts_bucket()
    # if args.create_work_dirs:
    #     kubify.create_work_dirs()
    # if args.set_context_kind_kind:
    #     kubify.set_context_kind_kind()
    # if args.get_entrypoint:
    #     kubify.get_entrypoint()
    # if args.get_service_pod:
    #     kubify.get_service_pod()
    # if args.build_entrypoint:
    #     kubify.build_entrypoint()
