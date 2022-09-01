

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

DOCKER_TAG_VERSION_DEVELOPER_TOOLS := 1.0
DOCKER_IMAGE_DEVELOPER_TOOLS := cft/developer-tools
REGISTRY_URL := gcr.io/cloud-foundation-cicd
DOCKER_BIN ?= docker

# Enter docker container for local development
.PHONY: docker_run
docker_run:
	$(DOCKER_BIN) run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-v "$(CURDIR)":/src/kubify \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/bin/bash

# Execute prepare tests within the docker container
.PHONY: docker_test_prepare
docker_test_prepare:
	$(DOCKER_BIN) run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-e TF_VAR_org_id \
		-e TF_VAR_folder_id \
		-e TF_VAR_billing_account \
		-v "$(CURDIR)":/src/kubify \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/execute_with_credentials.sh prepare_environment

# Clean up test environment within the docker container
.PHONY: docker_test_cleanup
docker_test_cleanup:
	$(DOCKER_BIN) run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-e TF_VAR_org_id \
		-e TF_VAR_folder_id \
		-e TF_VAR_billing_account \
		-v "$(CURDIR)":/src/kubify \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/execute_with_credentials.sh cleanup_environment

# Execute integration tests within the docker container
.PHONY: docker_test_integration
docker_test_integration:
	$(DOCKER_BIN) run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-v "$(CURDIR)":/src/kubify \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/test_integration.sh

# Execute lint tests within the docker container
.PHONY: docker_test_lint
docker_test_lint:
	$(DOCKER_BIN) run --rm -it \
		-e ENABLE_PARALLEL=1 \
		-v "$(CURDIR)":/src/kubify \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/test_lint.sh

# Generate documentation
.PHONY: docker_generate_docs
docker_generate_docs:
	$(DOCKER_BIN) run --rm -it \
		-v "$(CURDIR)":/src/kubify \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/bin/bash -c 'source /usr/local/bin/task_helper_functions.sh && generate_docs'

# Generate files from autogen
.PHONY: docker_generate_modules
docker_generate_modules:
	$(DOCKER_BIN) run --rm -it \
                -v "$(CURDIR)":/src/kubify \
                $(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
                /bin/bash -c 'source /usr/local/bin/task_helper_functions.sh && generate_modules'

# Alias for backwards compatibility
.PHONY: generate_docs
generate_docs: docker_generate_docs

.PHONY: generate
generate: docker_generate_modules

.PHONY: build
build: docker_generate_modules docker_generate_docs
