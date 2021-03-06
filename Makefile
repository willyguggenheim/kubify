.PHONY: clean clean-build clean-pyc clean-test coverage dist docs help install lint lint/flake8 lint/black pip
.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python3 -c "$$BROWSER_PYSCRIPT"

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

lint/flake8: ## check style with flake8
	flake8 ./kubify ./tests --ignore="E266,E502,E501,W292,W293,F401,E115,E402,E712,F841,F811,W291,E111,E302,E225,F821,E117,E261,E303,E231,E265,W391,C416,B007,W504,C408"

lint/black: ## check style with black
	black --check ./kubify ./tests

lint: lint/flake8 lint/black ## check style

format: ## format code with black
	black ./kubify ./tests

test: ## run tests quickly with the default Python
	pytest

test-all: ## run tests on every Python version with tox
	tox

coverage: ## check code coverage quickly with the default Python
	coverage run --source ./kubify -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

docs: ## generate Sphinx HTML documentation, including API docs
	rm -f docs/kubify.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ kubify
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	$(BROWSER) docs/_build/html/index.html

servedocs: docs ## compile the docs watching for changes
	watchmedo shell-command -p '*.rst' -c '$(MAKE) -C docs html' -R -D .

release: dist ## package and upload a release
	twine upload dist/*

dist: clean ## builds source and wheel package
	python3 setup.py sdist
	python3 setup.py bdist_wheel
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	python3 setup.py install

pip:
	pip install -U tox virtualenv flake8 setuptools
	pip install -e .[develop]

fix:
	find . -type f -print0 | xargs -0 dos2unix
	black ./kubify
	terraform fmt --recursive


aws_account_id_for_state := $(shell aws sts get-caller-identity --query "Account" --output text 2>/dev/null)

clouds: # install AWS, GCP and Azure clouds in parallel (fastest)
	make cloud-create env=dev

clouds-delete:
	make cloud-delete env=dev

clouds-auth: # make cloud-auth env=dev
	aws eks-update-kubeconfig --name "kubify-$$env" --region us-west-2
	kubectl cluster-info
	aws eks-update-kubeconfig --name "kubify-$$env" --region us-east-1
	kubectl cluster-info
	gcloud container clusters get-credentials "kubify-$$env" --region us-west2 --project "kubify-os"
	kubectl cluster-info
	gcloud container clusters get-credentials "kubify-$$env" --region us-east1 --project "kubify-os"
	kubectl cluster-info
	az aks get-credentials --resource-group "kubify-$$env" --name "kubify-$$env" --admin --region "westus"
	kubectl cluster-info
	az aks get-credentials --resource-group "kubify-$$env" --name "kubify-$$env" --admin --region "eastus"
	kubectl cluster-info

cloud-delete: #clouds reset nonprod envs
	echo "deleting cloud env $$env"
	gcloud config set project kubify-os || gcloud auth application-default login
	gcloud config set project kubify-os
	aws sts get-caller-identity >/dev/null || aws configure
	az ad signed-in-user list-owned-objects >/dev/null || az login
	az ad signed-in-user list-owned-objects >/dev/null || az login
	tfenv install v1.2.4 >/dev/null
	tfenv use v1.2.4
	export state_name="kubify-$$env-tf-state-$(aws_account_id_for_state)" && \
		cd ./kubify/ops/terraform && \
		terraform init --reconfigure --backend-config="bucket=$$state_name" --backend-config="dynamodb_table=$$state_name" --backend-config="region=us-west-1" && \
		terraform destroy --var="cluster_name=kubify-$$env"

cloud-create: #aws azure or gcp (make cloud cloud=[aws|azure|gcp] env=[dev|test|prod])
	echo "creating cloud env $$env"
	tfsec
	terraform fmt --recursive
	gcloud config set project kubify-os || gcloud auth application-default login
	gcloud config set project kubify-os
	aws sts get-caller-identity >/dev/null || aws configure
	az ad signed-in-user list-owned-objects >/dev/null || az login
	az ad signed-in-user list-owned-objects >/dev/null || az login
	tfenv install v1.2.4 >/dev/null
	tfenv use v1.2.4
	export state_name="kubify-$$env-tf-state-$(aws_account_id_for_state)" && \
		aws s3 ls s3://$$state_name || aws s3api create-bucket --bucket $$state_name --region us-west-1  --create-bucket-configuration LocationConstraint=us-west-1 && \
		aws s3api put-bucket-encryption --bucket $$state_name --server-side-encryption-configuration "{\"Rules\": [{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\": \"AES256\"}}]}" && \
		aws dynamodb describe-table --table-name $$state_name   >/dev/null ||  aws dynamodb create-table --table-name $$state_name --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region us-west-1 && \
		cd ./kubify/ops/terraform && \
		terraform init --reconfigure --backend-config="bucket=$$state_name" --backend-config="dynamodb_table=$$state_name" --backend-config="region=us-west-1" && \
		terraform apply --var="cluster_name=kubify-$$env" || terraform state rm module.aws.module.eks-dr-us-east-1.module.eks.kubernetes_config_map_v1_data.aws_auth

# clouds-select-cloud: # create 1 cloud at a time (or comment out cloud types that you don't use)
# 	make cloud-create cloud=aws env=dev
# 	make cloud-create cloud=gcp env=dev
# 	make cloud-create cloud=azure env=dev

# cloud-delete-select-cloud: #clouds reset nonprod envs
# 	echo "deleting cloud env $$env"
# 	gcloud config set project kubify-os || gcloud auth application-default login
# 	gcloud config set project kubify-os
# 	aws sts get-caller-identity >/dev/null || aws configure
# 	az ad signed-in-user list-owned-objects >/dev/null || az login
# 	az ad signed-in-user list-owned-objects >/dev/null || az login
# 	tfenv install v1.2.4 >/dev/null
# 	tfenv use v1.2.4
# 	export state_name="kubify-$$env-tf-state-$(aws_account_id_for_state)" && \
# 		cd ./kubify/ops/terraform && \
# 		terraform init --reconfigure --backend-config="bucket=$$state_name" --backend-config="dynamodb_table=$$state_name" --backend-config="region=us-west-1" && \
# 		terraform destroy --target=module.$$cloud --var="cluster_name=kubify-$$env"

# cloud-create-select-cloud: #aws azure or gcp (make cloud cloud=[aws|azure|gcp] env=[dev|test|prod])
# 	echo "creating cloud env $$env"
# 	tfsec
# 	terraform fmt --recursive
# 	gcloud config set project kubify-os || gcloud auth application-default login
# 	gcloud config set project kubify-os
# 	aws sts get-caller-identity >/dev/null || aws configure
# 	az ad signed-in-user list-owned-objects >/dev/null || az login
# 	az ad signed-in-user list-owned-objects >/dev/null || az login
# 	tfenv install v1.2.4 >/dev/null
# 	tfenv use v1.2.4
# 	export state_name="kubify-$$env-tf-state-$(aws_account_id_for_state)" && \
# 		aws s3 ls s3://$$state_name || aws s3api create-bucket --bucket $$state_name --region us-west-1  --create-bucket-configuration LocationConstraint=us-west-1 && \
# 		aws s3api put-bucket-encryption --bucket $$state_name --server-side-encryption-configuration "{\"Rules\": [{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\": \"AES256\"}}]}" && \
# 		aws dynamodb describe-table --table-name $$state_name   >/dev/null ||  aws dynamodb create-table --table-name $$state_name --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region us-west-1 && \
# 		cd ./kubify/ops/terraform && \
# 		terraform init --reconfigure --backend-config="bucket=$$state_name" --backend-config="dynamodb_table=$$state_name" --backend-config="region=us-west-1" && \
# 		terraform apply --target=module.$$cloud --var="cluster_name=kubify-$$env"

docker:
	docker build . -t kubify:latest
	docker tag kubify:latest docker.io/willy0912/kubify-local:latest

docker-test-all-pythons:
	docker build . -t kubify:latest -f Dockerfile.pythons
	docker tag kubify:latest docker.io/willy0912/kubify-local:latest

security:
	bandit -r ./kubify -c .bandit.yml
	bandit -r ./kubify/ops/services -c .bandit.yml

package:
	python3 setup.py sdist bdist_wheel

clean:
	rm -rf ./.kub* ./._* ./.aws ./build ./venv ./kubify/ops/terraform/.terra* docs/*build docs/build *.pyc *.pyo
	stat ./.git && git clean -xdf || cat .gitignore | sed '/^#.*/ d' | sed '/^\s*$$/ d' | sed 's/^/git rm -r /' | bash 2>/dev/null || true

# test every version of python enabled
pythons-cache:
	tox -e py37,py38,py39,py310 -p all --notest
pythons:
	tox -e py37,py38,py39,py310 -p all

# mac intel, m1, m2 and other darwin-based ..
mac:
	ansible-playbook --connection=local "ansible/install_kubify_on_mac.yaml" --ask-become-pass -e ansible_python_interpreter=`which python3`

# ubuntu, debian and other debian-based ..
deb:
	ansible-playbook --connection=local "ansible/install_kubify_on_debian_ubuntu_and_wsl2.yaml" --ask-become-pass -e ansible_python_interpreter=`which python3`

# rhel, centos and other epel-based ..
epel:
	ansible-playbook --connection=local "ansible/install_kubify_on_amzn2_centos_fedora_oracle_and_rhel.yaml" --ask-become-pass -e ansible_python_interpreter=`which python3`

aws-list:
	aws eks list-clusters --output json

# cloud deploys

# todo: also (similarly) ansible kubedb changes for multi-cloud database (and that backs up in both clouds)
# todo: route53 helm automations to failover active-active between clouds
argo-create-services:
	# connect to argocd and deploy to all clusters
	# todo: eval "https://api.argoproj.io"
	# todo: eval "$(cat ~/.argocd/token)"
	argocd cluster add --name kubify-aws-west2-eks	  --server https://api.argoproj.io --token $(cat ~/.argocd/token)
	argocd app patch app-of-apps --patch '{"spec": { "source": { "repoURL": "https://github.com/willyguggenheim/kubify.git" } }}' --type merge
	argocd cluster add --name kubify-aws-east1-eks-dr --server https://api.argoproj.io --token $(cat ~/.argocd/token)
	argocd app patch app-of-apps --patch '{"spec": { "source": { "repoURL": "https://github.com/willyguggenheim/kubify.git" } }}' --type merge


argo-delete-services:
	# connect to argocd and deploy to all clusters
	# todo: eval "https://api.argoproj.io"
	# todo: eval "$(cat ~/.argocd/token)"
	argocd cluster add --name kubify-aws-west2-eks	  --server https://api.argoproj.io --token $(cat ~/.argocd/token)
	argocd app delete app-of-apps --patch '{"spec": { "source": { "repoURL": "https://github.com/willyguggenheim/kubify.git" } }}' --type merge
	argocd cluster add --name kubify-aws-east1-eks-dr --server https://api.argoproj.io --token $(cat ~/.argocd/token)
	argocd app delete app-of-apps --patch '{"spec": { "source": { "repoURL": "https://github.com/willyguggenheim/kubify.git" } }}' --type merge
