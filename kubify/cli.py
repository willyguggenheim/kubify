"""Console script for kubify."""
import argparse

# from ast import arg
import sys
import kubify.src.kubify as kubify


parser = argparse.ArgumentParser(description="CLI for Kubify")

parser.add_argument(
    "up",
    help="start kubify kind local rapid testing kubernetes cluster",
)
parser.add_argument(
    "down",
    action="store_true",
    help="pause all running services and local cluster",
)
parser.add_argument(
    "start",
    action="store_true",
    help="start service and it's kubify.yaml depends_on services, listen for changes on all services",
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
#     "--test_or_create_s3_artifacts_bucket",
#     action="store_true",
#     help="sets the s3 bucket for state file for terraform",
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

if args.start:
    kubify.start()

if args.test_logger:
    kubify.test_logger()
# if args.create_work_dirs:
#     kubify.create_work_dirs()
# if args.set_context_kind_kind:
#     kubify.set_context_kind_kind()
if args.test_or_create_s3_artifacts_bucket:
    # this is currently done via the make file
    kubify.test_or_create_s3_artifacts_bucket()
# if args.get_entrypoint:
#     kubify.get_entrypoint()
# if args.get_service_pod:
#     kubify.get_service_pod()
# if args.build_entrypoint:
#     kubify.build_entrypoint()

# aws/eks))
# create/update & attach
# delete
# clone
# status/list

# Usage:
#   kubify [command]

# Quickstart:
#   kubify up
#   cd <your-app>
#   kubify start

# Available Commands:
#   dir       List the full path of the kubify directory or any of the services
#       cd \$(kubify dir be-svc)     # Change to the be-svc directory
#       cd \$(kubify dir)        # Change to the kubify directory

#   check     Perform some sanity checks

#   up        Start the local cluster

#   down      Stop the local cluster

#   delete    Delete the local cluster

#   status    Show the status of the local cluster

#   services  List all the services

#   images    List the Docker images

#   clean     Purges/clears any caches
#       kubify clean

#       - Removes cached docker images (Minikube)
#       - Removes unused application images

#   ps        List the running services

#   logs      Tail the logs of all applications
#       kubify logs

#   new       Create a new application from a template
#       kubify new {{ app_type }} {{ app_name }}

#   secrets   Import, create, edit or view secrets per app per environment
#       kubify secrets <export/import/create/view/edit> {{ env }}

#       export: Write the encrypted secrets to AWS secrets manager
#       import: Read the secrets from AWS secrets manager and write to secrets locally
#       create: Create an empty version-controlled secrets file
#       view:   View the entries in cleartext for version-controlled secrets
#       edit:   Edit the entries for version-controlled secrets

#   start     Start the app locally for local development (Watch changes)
#       kubify start

#   start-all Start all services in debug mode

#   run       Run the app locally
#       kubify run [<app_version>]

#   run-all   Run a list of services in one-shot locally
#       kubify run-all [[service1]:[tag]] [[service2]:[tag]] ...
#       OR
#       kubify run-all

#     Example:
#       kubify run-all kubify be-svc

#   stop      Stop the app locally
#       kubify stop

#   stop-all  Stop a list of services in one-shot locally
#       kubify stop-all [service1] [service2] ... [service_N]
#       OR
#       kubify stop-all

#     Example:
#       kubify stop-all kubify be-svc

#   cmd       Run a command/shell in the current application
#       kubify cmd [<cmd_name> [<options>]]

#   url       Get the URL for the current service
#       kubify url

#   exec      Run a command/shell in the entrypoint container
#       kubify exec [<cmd_name> [<options>]]

#   environments      Get information/logs about environments
#       list: List all the environments
#       logs: Tail logs for an application in an environment
#       Example: kubify environments logs dev kubify
#       view: View the details for a given environment
#       Example: kubify environments view dev
#       status:       View the deployment status for a given environment
#       Example: kubify environments status dev
#       diff: Compare two environments to see differences in deployed images and configs
#       Examples:
#         kubify environments diff stage prod       # Compare entire environment
#         kubify environments diff stage prod "kubify,be-svc"    # Compare kubify and be-svc
#       get-context:  Switch the kubectl context to the environment
#       Example: kubify environments get-context dev


# Flags (Enable: 1; Disable: 0):
#   KUBIFY_VERBOSE      Toggle verbose logging
#   KUBIFY_DEBUG        Toggle verbose plus show every command (extra verbose)
#   KUBIFY_ENGINE       The kubernetes engine to use (Supported: local (default), minikube)
#   KUBIFY_PROFILE      The kubernetes profile to use (Advanced)

# HELPER FUNCTION NEEDED) ansible/run))
# cache kubify docker local
# install kubify direct local

# and thencode the new helm charts example service
