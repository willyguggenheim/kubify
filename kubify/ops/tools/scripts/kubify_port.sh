#!/bin/bash

# debug = -o
set +o xtrace

# strict = -e
set -e

export ANSIBLE_PYTHON_INTERPRETER=`which python3`
export INTERPRETER_PYTHON=auto_silent
export ANSIBLE_PYTHON_INTERPRETER=auto_silent
export KUBIFY_EDITOR="code --wait "
export EDITOR="code --wait "

export KUBIFY_UNIQUE_COMPANY_ACRONYM=${KUBIFY_UNIQUE_COMPANY_ACRONYM:-changethis}
export KUBIFY_CONTAINER_REGISTRY=${KUBIFY_CONTAINER_REGISTRY:-ecr}

export KUBIFY_VERBOSE=${KUBIFY_VERBOSE:-0}
export KUBIFY_DEBUG=${KUBIFY_VERBOSE:-0}

export KUBIFY_CONTAINER="willy0912/kubify:main"
export KUBIFY_CONTAINER_NAME="kubify-engine"

alias kubify="kubify_port.sh"
kind export kubeconfig --name kubify 2>/dev/null || \
  echo "kubify local k8s kind cluster not yet found"
kubectl --context kind-kubify get nodes 2>/dev/null || \
  echo "kubify local k8s kind cluster not yet connected"

ACTUAL_OS_TYPE=mac
FILE=/proc/version

if test -f "$FILE"; then
    cat /proc/version | grep -i microsoft &> /dev/null && ACTUAL_OS_TYPE=wsl2
    cat /etc/os-release | grep -i ubuntu &> /dev/null && ACTUAL_OS_TYPE=debian
    cat /etc/os-release | grep -i debian &> /dev/null && ACTUAL_OS_TYPE=debian
    cat /etc/os-release | grep -i centos &> /dev/null && ACTUAL_OS_TYPE=centos
    cat /etc/os-release | grep -i rhel &> /dev/null && ACTUAL_OS_TYPE=centos
    cat /etc/os-release | grep -i amazon_linux &> /dev/null && ACTUAL_OS_TYPE=centos
else
  ACTUAL_OS_TYPE=mac
fi

hard_reset_docker_mac() {
  IMAGES=$@
  echo "This will remove all your current containers and images except for:"
  echo ${IMAGES}

  read -p "Are you sure? [yes/NO] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      exit 1
  fi

  TMP_DIR=$(mktemp -d)
  pushd $TMP_DIR >/dev/null
  open -a Docker
  echo "=> Saving the specified images"
  for image in ${IMAGES}; do
    echo "==> Saving ${image}"
    tar=$(echo -n ${image} | base64)
    docker save -o ${tar}.tar ${image}

    echo "==> Done."
  done
  echo "=> Cleaning up"
  echo -n "==> Quiting Docker"
  osascript -e 'quit app "Docker"'
  while docker info >/dev/null 2>&1; do
    echo -n "."
    sleep 1
  done;
  echo ""
  echo "==> Removing Docker.qcow2 file"
  rm ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2
  echo "==> Launching Docker"
  open -a Docker
  echo -n "==> Waiting for Docker to start"
  until docker info >/dev/null 2>&1; do
    echo -n "."
    sleep 1
  done;
  echo ""
  echo "=> Done."
  echo "=> Loading saved images"
  for image in ${IMAGES}; do
    echo "==> Loading ${image}"
    tar=$(echo -n ${image} | base64)
    docker load -q -i ${tar}.tar || exit 1
    echo "==> Done."
  done
  popd >/dev/null
  rm -r ${TMP_DIR}
}

read_flag_verbose() {
  if [ "$KUBIFY_DEBUG" == "1" ]; then
    set -o xtrace
    export ANSIBLE_VERBOSITY=4
  fi
  if [ "$KUBIFY_VERBOSE" == "1" ]; then
    KUBIFY_OUT=/dev/stdout
  else
    KUBIFY_OUT=/dev/null
  fi
}

read_flag_verbose
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
mkdir -p "$DIR/../../../._kubify_work"
mkdir -p ~/kubify

if ! [ -x "$(command -v git)" ]; then
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    xcode-select --install
  elif [[ "$OSTYPE" == *"linux"* ]]; then
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
            sudo apt-get update &> /dev/null
            sudo apt-get install -y git &> /dev/null
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
            sudo yum install -y git &> /dev/null
      fi
  fi
fi

if ! [ -x "$(command -v docker)" ]; then
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    brew install --cask docker
  elif [[ "$OSTYPE" == *"linux"* ]]; then
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
            sudo apt-get update &> /dev/null
            sudo apt-get install -y docker-ce &> /dev/null || sudo apt-get install -y docker &> /dev/null
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
            sudo yum install -y docker-ce &> /dev/null || sudo yum install -y docker &> /dev/null
      fi
  fi
fi
if ! [ -x "$(docker ps)" ]; then
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    open --background -a Docker 2>/dev/null
    echo "waiting until docker ps command works (please confirm it's running).."
    for i in 1 2 3 4 5; do docker ps && break || sleep 5; done
  elif [[ "$OSTYPE" == *"linux"* ]]; then
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
            systemctl start docker 2>/dev/null || service docker start 2>/dev/null || true
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
            systemctl start docker 2>/dev/null || service docker start 2>/dev/null || true
      fi
  fi
fi
docker ps >/dev/null
if [[ "$OSTYPE" == *"darwin"* ]]; then
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi
if ! [ -x "$(command -v sudo)" ]; then
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
            apt-get update &> /dev/null
            apt-get install -y sudo &> /dev/null
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
            yum install -y sudo &> /dev/null
      fi
fi
if ! [ -x "$(command -v wget)" ]; then
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    brew install wget &> /dev/null
  elif [[ "$OSTYPE" == *"linux"* ]]; then
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
            sudo apt-get update &> /dev/null
            sudo apt-get install -y wget &> /dev/null
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
            sudo yum install -y wget &> /dev/null
      fi
  fi
fi
if ! [ -x "$(command -v aws)" ]; then
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    brew install awscli &> /dev/null
    brew link awscli &> /dev/null
  elif [[ "$OSTYPE" == *"linux"* ]]; then
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
            sudo apt-get update &> /dev/null
            sudo apt-get install -y awscli &> /dev/null
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
            sudo yum install -y awscli &> /dev/null
      fi
  fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi
MUST_INSTALL_YQ=0
~/kubify/yq --version &> /dev/null || MUST_INSTALL_YQ=1
~/kubify/yq --version | grep 4.7.0 &> /dev/null || MUST_INSTALL_YQ=1
if [[ "$OSTYPE" == *"darwin"* && "$MUST_INSTALL_YQ" == 1 ]]; then
  wget https://github.com/mikefarah/yq/releases/download/v4.7.0/yq_darwin_amd64.tar.gz -O - |\
    tar xz && mv ./yq_darwin_amd64 ~/kubify/yq &> /dev/null | true
  rm -f ./yq_darwin_amd64*
  chmod +x ~/kubify/yq
  ~/kubify/yq --version | grep 4.7.0 &> /dev/null || exit 1
elif [[ "$OSTYPE" == *"linux"* && "$MUST_INSTALL_YQ" == 1 ]]; then
  wget https://github.com/mikefarah/yq/releases/download/v4.7.0/yq_linux_amd64.tar.gz -O - |\
    tar xz && mv ./yq_linux_amd64 ~/kubify/yq &> /dev/null
  rm -f ./yq_linux_amd64*
  chmod +x ~/kubify/yq
  ~/kubify/yq --version | grep 4.7.0 &> /dev/null || exit 1
fi

if [[ $KUBIFY_CI != '1' ]]; then
  PROFILE=${KUBIFY_PROFILE:-kind-kubify}

else
  PROFILE=${KUBIFY_PROFILE:-default}

fi
git config --get user.name | grep -E "[a-z]" || git config --global user.name "Set YourGitUsername"
git config --get user.email | grep -E "[a-z]" || git config --global user.email "Set@YourGitEmail.kubify.com"
if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
  if [ ! -f ${HOME}/.aws/credentials ]; then
      aws sts get-caller-identity || aws configure 
  fi
else
  echo "AWS_SECRET_ACCESS_KEY env var found, using that.."
fi
export SKAFFOLD_UPDATE_CHECK=${SKAFFOLD_UPDATE_CHECK:-0}

export ENV=${ENV:-dev}
if [[ "$OSTYPE" == *"darwin"* ]]; then
  BASE64_DECODE="base64 -D"
  MINIKUBE="minikube"
elif [[ "$OSTYPE" == *"linux"* ]]; then
  BASE64_DECODE="base64 -d"
  MINIKUBE="sudo minikube"
fi
export NAMING_PREFIX=$KUBIFY_UNIQUE_COMPANY_ACRONYM-$ENV-kubify
export AWS_REGION=${KUBIFY_AWS_REGION:-us-east-1}
export AWS_PROFILE=${KUBIFY_AWS_PROFILE:-default}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
GIT_DIR=`echo "$(cd "$(dirname "$DIR/../../../..")"; pwd)"`
KUBIFY_CURRENT_VERSION=`cat ${GIT_DIR}/../__version__`

WORK_DIR="${GIT_DIR}/._kubify_work"
mkdir -p "${WORK_DIR}/certs"
K8S_DIR="${GIT_DIR}/ops"
mkdir -p "${WORK_DIR}"
alias kubify="${DIR}/kubify"

cat ${WORK_DIR}/env_var__cache__AWS_ACCOUNT_ID 2> /dev/null | grep -Eo '[0-9]{1,12}' >/dev/null || aws sts get-caller-identity 
cat ${WORK_DIR}/env_var__cache__AWS_ACCOUNT_ID 2> /dev/null | grep -Eo '[0-9]{1,12}' >/dev/null || aws sts get-caller-identity --query Account --output text > ${WORK_DIR}/env_var__cache__AWS_ACCOUNT_ID
cat ${WORK_DIR}/env_var__cache__AWS_ACCOUNT_ID | grep -Eo '[0-9]{1,12}' || exit 1
AWS_ACCOUNT_ID=`cat ${WORK_DIR}/env_var__cache__AWS_ACCOUNT_ID`

KUBIFY_ENGINE=${KUBIFY_ENGINE:-local}         
KUBIFY_CI=${KUBIFY_CI:-0}                     
KUBIFY_VERBOSE=${KUBIFY_VERBOSE:-0}           
KUBIFY_DEBUG=${KUBIFY_DEBUG:-0}               
KUBIFY_ENTRYPOINT_IMAGE=kubify/entrypoint   

KUBIFY_LOCAL_DOMAIN_SUFFIX="kubify.local"                
KUBIFY_LOCAL_DOMAIN="local.${KUBIFY_LOCAL_DOMAIN_SUFFIX}"  
KUBIFY_UPSTREAM_DOMAIN_SUFFIX="${KUBIFY_UPSTREAM_DOMAIN_SUFFIX:-kubify.com}"   
KUBIFY_UPSTREAM_ENV_ACCOUNT="arn:aws:eks:${AWS_REGION}:${AWS_ACCOUNT_ID}"
KUBIFY_NPM_CREDENTIALS_SECRET="npm-credentials"

if [[ "$KUBIFY_CONTAINER_REGISTRY" == "dockerhub" ]]; then
  PUBLISH_IMAGE_REPO_PREFIX=$NAMING_PREFIX
elif [[ "$KUBIFY_CONTAINER_REGISTRY" == "ecr" ]]; then
  PUBLISH_IMAGE_REPO_PREFIX="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${NAMING_PREFIX}"
fi

if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
  PROFILE=kind-kubify
  
  MINIKUBE_DISK_SIZE=80g
  MINIKUBE_MEMORY=8192            
  MINIKUBE_ADDONS="ingress"       
  MINIKUBE_VM_DRIVER="none" 
  SRC_MOUNT=/var/folders/kubify
  HOME_MOUNT=/config/home
elif [[ "$KUBIFY_ENGINE" == "local" ]]; then
  SRC_MOUNT=$GIT_DIR
  HOME_MOUNT=$HOME
fi

BUILD_PROFILE=ci-build          
LOCAL_START_PROFILE=local-start 
LOCAL_RUN_PROFILE=local-run     
NAMESPACE=${NAMESPACE:-demo}    
if [ -z "$PROFILE" ]; then
  KUBECTL="kubectl"
  HELM="helm"
else
  KUBECTL="kubectl --context ${PROFILE}"
  HELM="helm --kube-context ${PROFILE}"
fi
KUBECTL_NS="$KUBECTL --namespace $NAMESPACE"
SKAFFOLD="skaffold --namespace $NAMESPACE"
DOCKER="docker"
USER_NAME=`git config --get user.name`
ALL_ENV=( dev test stage prod )

AWS_ADMIN_PROFILE=${AWS_ADMIN_PROFILE:-kubify-admin}

AWS_ACCOUNT_NUMBER=${AWS_ACCOUNT_ID}

KMS_KEY_NAME=kubify_secrets_${ENV}

DEV_KMS="arn:aws:kms:${AWS_REGION}:${AWS_ACCOUNT_ID}:alias/${KMS_KEY_NAME}"
TEST_KMS="arn:aws:kms:${AWS_REGION}:${AWS_ACCOUNT_ID}:alias/${KMS_KEY_NAME}"
STAGE_KMS="arn:aws:kms:${AWS_REGION}:${AWS_ACCOUNT_ID}:alias/${KMS_KEY_NAME}"
PROD_KMS="arn:aws:kms:u${AWS_REGION}:${AWS_ACCOUNT_ID}:alias/${KMS_KEY_NAME}"

if [ ! -f "${WORK_DIR}/certs/ca.key" ]; then
    echo "generating ca.key"
    openssl genrsa -out "${WORK_DIR}/certs/ca.key" 2048
    openssl rsa -in "${WORK_DIR}/certs/ca.key" -out "${WORK_DIR}/certs/ca.key.rsa"
    openssl req -new -key "${WORK_DIR}/certs/ca.key.rsa" -subj /CN=local.kubify.local -out "${WORK_DIR}/certs/ca.csr" -config "${K8S_DIR}/certs/kubify-cli-gen-certs.conf"
    openssl x509 -req -extensions v3_req -days 3650 -in "${WORK_DIR}/certs/ca.csr" -signkey "${WORK_DIR}/certs/ca.key.rsa" -out "${WORK_DIR}/certs/ca.crt" -extfile "${K8S_DIR}/certs/kubify-cli-gen-certs.conf"
    if [[ "$OSTYPE" == *"darwin"* ]]; then
       sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "${WORK_DIR}/certs/ca.crt" || true
    elif [[ "$OSTYPE" == *"linux"* ]]; then
      if [[ "$ACTUAL_OS_TYPE" == "ubuntu" ]] || [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
       apt-get install -y ca-certificates || sudo apt-get install -y ca-certificates
       mkdir -p /usr/share/ca-certificates
       rm -f /usr/share/ca-certificates/kubify_ca.crt
       sudo update-ca-certificates --fresh
       cp "${WORK_DIR}/certs/ca.crt" /usr/share/ca-certificates/kubify_ca.crt
       sudo update-ca-certificates || true
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
       yum install -y ca-certificates
       update-ca-trust force-enable
       mkdir -p /etc/pki/ca-trust/source/anchors
       rm -f /etc/pki/ca-trust/source/anchors/kubify_ca.crt
       cp "${WORK_DIR}/certs/ca.crt" /etc/pki/ca-trust/source/anchors/kubify_ca.crt
       update-ca-trust extract || sudo update-ca-trust extract || true
      fi
    fi    
fi
function join_by { local IFS="$1"; shift; echo "$*"; }

check_flag() {
  _KUBIFY_VAR=KUBIFY_${1}

  if [ "${!_KUBIFY_VAR}" == "0" ];
  then
    return 1 
  else
    return 0 
  fi
}

ensure_flag() {
  if ! check_flag "$1"; then
    echo "$2"
    exit 1
  fi
}

ask() {
  local prompt default reply
  if [ "${2:-}" = "Y" ]; then
    prompt="Y/n"
    default=Y
  elif [ "${2:-}" = "N" ]; then
    prompt="y/N"
    default=N
  else
    prompt="y/n"
    default=
  fi
  while true; do
    echo -n "$1 [$prompt] "
    read reply </dev/tty
    if [ -z "$reply" ]; then
      reply=$default
    fi
    case "$reply" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}
function test_or_create_s3_artifacts_bucket {
  
  if [[ "$AWS_REGION" == *"us-east-1"* ]]; then
    ARTIFACTS_S3_BUCKET_AWS_REGION="us-east-1";
  elif [[ "$AWS_REGION" == *"us-west-2"* ]]; then
    ARTIFACTS_S3_BUCKET_AWS_REGION="us-east-1";
  else
    ARTIFACTS_S3_BUCKET_AWS_REGION="us-west-2";
  fi
  
  echo "checking access to artifacts s3 bucket to exist, creating it (with encryption at rest enabled) if it does not exist.."
  if aws s3 ls "s3://$NAMING_PREFIX"
  then
    echo "success: s3 bucket access working"
  else
    echo "could not find s3 bucket, so creating it"
    aws s3 mb s3://$NAMING_PREFIX --region $ARTIFACTS_S3_BUCKET_AWS_REGION
    aws s3api put-bucket-encryption --region $ARTIFACTS_S3_BUCKET_AWS_REGION --bucket $NAMING_PREFIX --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
    echo "s3 bucket encryption set"
  fi
}

function switch_version {
  check_arg $1 "No version specified!"
  
  KUBIFY_VERSION=$1

  
  
}

function version {
  echo "${KUBIFY_CURRENT_VERSION}"
}

function check {
  echo "Docker: $(which docker): $(docker --version)"
  echo "Kubernetes CLI: $(which $KUBECTL): $($KUBECTL version --client --short)"
  if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
    echo "Minikube: $(which minikube): $(minikube version)"
  fi
  echo "Helm: $(which helm): $(helm version --client)"
  local_env_running
  $HELM list
  $KUBECTL get crds
  $KUBECTL get all --all-namespaces
  if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
    echo "DNS Info:"
    echo "  Minikube IP: $($MINIKUBE ip)"
    echo "  DNSmasq IP:  $(dig +short ${KUBIFY_LOCAL_DOMAIN})"
  fi
}

function _not_implemented {
  echo "'kubify $1' not implemented yet."
  exit 1
}

function _is_removed {
  echo "'kubify $1' has been removed since it isn't necessary."
  exit 1
}

function set_minikube {
  
  $MINIKUBE profile $PROFILE
}

function set_context {
  local_env_running
  {
    if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
      set_minikube
    elif [[ "$KUBIFY_ENGINE" == "local" ]]; then
      echo Context already set
    fi
    kind export kubeconfig --name kubify
  }
}

function mount_dir {
  SRC=$1
  DEST=$2
  set_minikube
  
  $MINIKUBE mount ${SRC}:${DEST} &
}

function mount_source {
  mount_dir "$GIT_DIR" "$SRC_MOUNT"
}

function mount_home {
  mount_dir "$HOME" "$HOME_MOUNT"
}

function mount_aws {
  mount_dir "$HOME/.aws" /config/aws
}

function start_mount {
  mount_source
  mount_home
  mount_aws
}

function stop_mount {
  /bin/ps aux | grep "minikube mount" | tr -s " " | cut -d " " -f 2 | xargs kill &> "$KUBIFY_OUT"
}

function _build_image {
  set_context
  IMAGE=$1
  SRC_PATH=$2
  set_context
  docker build -t ${IMAGE}:latest "$SRC_PATH"
  
  if [[ $KUBIFY_CI != '1' ]]; then
    kind load docker-image ${IMAGE}:latest
  fi
}

function _build_entrypoint {
  _build_image $KUBIFY_ENTRYPOINT_IMAGE "${K8S_DIR}/entrypoint/"
}

function _get_entrypoint {
  $KUBECTL_NS rollout status -w deployment/entrypoint &> /dev/null
  echo $(${KUBECTL_NS} get pods -o wide --field-selector=status.phase=Running -l role=entrypoint --no-headers | cut -d ' ' -f1 | head -n 1)
}

function _get_service_pod {
  APP_NAME=$1
  timeout 10 ${KUBECTL_NS} rollout status -w deployment/${APP_NAME} &> /dev/null
  echo $(${KUBECTL_NS} get pods -o wide --field-selector=status.phase=Running -l app=${APP_NAME} --no-headers | cut -d ' ' -f1 | head -n 1)
}

function update_registry_secret() {
  REG_SECRET=dockerhub
  if ! ${KUBECTL_NS} get secret $REG_SECRET; then
    if test -f "$HOME/.netrc"; then
      echo "$HOME/.netrc file exists, using it"
      grep "hub\.docker\.com" $HOME/.netrc
      if [ $? -eq 0 ]; then
        while IFS=, read -r username email password; do
          export docker_email=$(echo $email | sed "s/^'//; s/'$//")
          export docker_username=$(echo $username | sed "s/^'//; s/'$//")
          export docker_password=$(echo $password | sed "s/^'//; s/'$//")
        done < <(python2.7 -c "import netrc; print netrc.netrc('$HOME/.netrc').authenticators('hub.docker.com')" | sed 's/^(//; s/)$//')
      fi
    else
      echo "Enter DockerHub credentials or using environment variables:"
      if [ ! -z "$DOCKER_EMAIL" ]; then
        docker_email=$DOCKER_EMAIL
      else
        echo -n "Email: "
        read docker_email
      fi
      if [[ ! -z "$DOCKER_USERNAME" ]]; then
        docker_username=$DOCKER_USERNAME
      else
        echo -n "Username: "
        read docker_username
      fi
      if [[ ! -z "$DOCKER_PASS" ]]; then
        docker_password=$DOCKER_PASS
      else
        echo -n "Password: "
        read -s docker_password
      fi
      echo
    fi
    SECRET=$($KUBECTL create secret docker-registry $REG_SECRET \
    --docker-email=$docker_email \
    --docker-username=$docker_username \
    --docker-password=$docker_password \
    -o yaml \
    --dry-run=client)
    echo "$SECRET" | ${KUBECTL_NS} apply -f -
    ${KUBECTL_NS} patch serviceaccount default -p "{\"imagePullSecrets\": [{\"name\": \"${REG_SECRET}\"}]}"
  fi
}

function update_npm_secret() {
  if [ ! -z "${NPM_TOKEN}" ]; then
    echo "NPM_TOKEN is already set. Re-using it..."
  else
    echo "NPM_TOKEN is not set, reading from npmrc.."
    if test -f "$HOME/.npmrc"; then
      echo "$HOME/.npmrc exists, using it's token.."
      IN=$(tail -1 $HOME/.npmrc | grep "^\/")
      IFS='=' read -r -a ADDR <<< "$IN"
      export NPM_TOKEN=${ADDR[1]}

    else
      echo "$HOME/.npmrc does not exist, please login to NPMJS, so that you can pull private packages:"
      npm login
      echo "$HOME/.npmrc now exists, thank you, using it's token.."
      IN=$(tail -1 $HOME/.npmrc | grep "^\/")
      IFS='=' read -r -a ADDR <<< "$IN"
      export NPM_TOKEN=${ADDR[1]}

      if [ -z "$NPM_TOKEN" ]; then
        npm token create --readonly
        if [ $? -eq 0 ]; then
          echo "Copy the NPM token above and paste it into the prompt below."
          echo -n "NPM Token: "
          read -s NPM_TOKEN
        else
          echo "npm token creation failed, please delete a token from https://www.npmjs.com/settings/(USERNAME)/tokens "
          echo " and try the command directly: update_npm_secret"
          exit 1
        fi
      fi
    fi
  fi
  cat <<EOF | ${KUBECTL_NS} apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${KUBIFY_NPM_CREDENTIALS_SECRET}

type: Opaque
stringData:
  NPM_TOKEN: ${NPM_TOKEN}

EOF
}

function get_npm_secret_direct() {
  if [[ "$KUBIFY_CONTAINER_REGISTRY" == "dockerhub" ]]; then
    if [ -z "${NPM_TOKEN}" ]; then
      if test -f "$HOME/.npmrc"; then
        IN=$(tail -1 $HOME/.npmrc | grep "^\/")
        IFS='=' read -r -a ADDR <<< "$IN"
        export NPM_TOKEN=${ADDR[1]}

      else
        echo "$HOME/.npmrc does not exist, please login to NPMJS, so that you can pull private packages.. Try using up"
        exit 1
      fi
    fi
    echo ${NPM_TOKEN}

  fi
}

function get_npm_secret() {
  if [[ "$KUBIFY_CONTAINER_REGISTRY" == "dockerhub" ]]; then
    if [ -z "${NPM_TOKEN}" ]; then
      K8_NPM_TOKEN=$(${KUBECTL_NS} get secrets --field-selector=metadata.name=npm-credentials -o json | jq -r .items[0].data.NPM_TOKEN | $BASE64_DECODE)
      echo "${K8_NPM_TOKEN}" | grep -q '[0-9]'
      if [ $? = 1 ]; then
          echo "Problem accessing k8 npm secret. Try running 'up', test the 'update_npm_secret' and the 'get_npm_secret' commands."
          exit 1
      else
        echo ${K8_NPM_TOKEN}

      fi
    fi
  fi
}

function _generate_local_cluster_cert {
  docker run -e COMMON_NAME="*.${KUBIFY_LOCAL_DOMAIN}" -v "${WORK_DIR}/certs:/certs" -w /certs -it alpine:latest sh -c ./gen-certs.sh
}

function debug {
  echo "!!ALL THE kube-system NAMESPACE OBJECTS:"
  $KUBECTL api-resources --verbs=list --namespaced -o name | xargs -n 1 $KUBECTL get --show-kind --ignore-not-found -n kube-system
  echo "!!ALL THE kubify NAMESPACE OBJECTS:"
  $KUBECTL api-resources --verbs=list --namespaced -o name | xargs -n 1 $KUBECTL get --show-kind --ignore-not-found -n demo
}

function configure_cluster {
  MANIFESTS="${K8S_DIR}"
  TILLERLESS=${TILLERLESS:-0}

  UPSTREAM=${UPSTREAM:-0}

  if [[ "$OSTYPE" == *"linux"* ]]; then
    CLUSTER_ADMIN_ENABLED=$($KUBECTL get clusterrolebinding -o json | jq -r '.items[] | select(.metadata.name == "add-on-cluster-admin")' --exit-status > /dev/null ||:)
    if [ $CLUSTER_ADMIN_ENABLED ]; then
      $KUBECTL create clusterrolebinding add-on-cluster-admin \
        --clusterrole=cluster-admin \
        --serviceaccount=kube-system:default
    fi
  fi
  if [[ "$TILLERLESS" == "1" ]]; then
    TILLER="tiller run helm"
  else
    TILLER=""
  fi
  echo "Configuring cluster"

  echo "Printing Kind K8s Cluster ID.."
  echo "Kubernetes Cluster ID ->"
  k8s_cluster_id=`kubectl get ns kube-system -o=jsonpath='{.metadata.uid}'`
  echo ${k8s_cluster_id}

  echo "<-"
  echo "
      Go to https://license-issuer.appscode.com 
      Register for a license for KubeDB Product 
      Choose 'KubeDB Community Edition'
      Put in the kubernetes cluster ID: ${k8s_cluster_id}

      After receiving license in email from registering
      Copy the license file to ~/kubify/kubedb.txt
      IMPORTANT NOTE: DO NOT SKIP THIS STEP (unless you are in-place re-installing on existing kind cluster)
        BUT WHY: The liscense file ~/kubify/kubedb.txt is unique to each kind (kubernetes) cluster..........
      Click enter to continue (after placing fle) 😎"
  read
  
  echo "Thank you! 😎 Continuing Kubify installer, if you recently reset your Docker then this would be a good time to get some coffee (entrypoint container takes a few minutes to build if not already built)....."
  {
    $HELM repo add stakater https://stakater.github.io/stakater-charts
    $HELM repo add stable   https://charts.helm.sh/stable
    $HELM repo add appscode https://charts.appscode.com/stable/
    $HELM repo add jetstack https://charts.jetstack.io
    $HELM repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    $HELM repo update
    kubectl create namespace demo || true
    helm repo add appscode https://charts.appscode.com/stable/
    helm repo update
    KUBEDB_VERSION=v2021.12.21
    KUBEDB_CATALOG_VERSION=v2021.12.21
    helm install kubedb appscode/kubedb \
      --version ${KUBEDB_VERSION} \
      --namespace demo --create-namespace \
      --set-file global.license="${HOME}/kubify/kubedb.txt" || true
    
    if `$KUBECTL --namespace demo get pods | grep kubedb` ; then
        echo "KubeDB is already installed, so running upgrade command instead.."
        echo "TODO: remove the '|| true' workaround once they release a stable KubeDB version release (since they already fixed in master looks like)"
        $HELM ${TILLER} upgrade kubedb appscode/kubedb --install --version $KUBEDB_VERSION --namespace demo || true
    else
        echo "Installing KubeDB.."
                                                echo "TODO: remove the '|| true' workaround once they release a stable KubeDB version release (since they already fixed in master looks like)"
        $HELM ${TILLER} install kubedb appscode/kubedb --version $KUBEDB_VERSION --namespace demo || true
    fi
      $KUBECTL rollout status -w deployment/kubedb-kubedb-community -n demo
    

    if [[ "$KUBIFY_ENGINE" == "local" ]]; then
          [[ -d /usr/local/certificates ]] || sudo mkdir -p /usr/local/certificates || true
      ls /usr/local/certificates || sudo mkdir -p /usr/local/certificates || true
      cmp -s "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/cert" || cp "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/cert"
      cmp -s "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/ca" || cp "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/ca"
      cmp -s "${WORK_DIR}/certs/ca.key" "${WORK_DIR}/certs/key" || cp "${WORK_DIR}/certs/ca.key" "${WORK_DIR}/certs/key"
      cmp -s "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/cert || sudo cp "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/cert || true
      cmp -s "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/ca || sudo cp "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/ca || true
      cmp -s "${WORK_DIR}/certs/ca.key" /usr/local/certificates/key || sudo cp "${WORK_DIR}/certs/ca.key" /usr/local/certificates/key || true
        kubectl create ns ingress-nginx || echo 'cert-manager ns exists'
        $KUBECTL apply -f "${GIT_DIR}/../kubify/ops/templates/manifests/ingress-nginx-kind.yaml"
      kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=90s 2>/dev/null || sleep 10
      kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=90s 2>/dev/null || sleep 10
      kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=90s || sleep 10
      kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=90s
    else
        if [[ "$KUBIFY_ENGINE" != "minikube" ]]; then
        helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
          --install \
          --namespace ingress-nginx \
          --set rbac.create=true \
          --set controller.publishService.enabled=true \
          --wait && \
        $HELM ${TILLER} upgrade ingress-nginx ingress-nginx/ingress-nginx \
          --install \
          --namespace ingress-nginx \
          --set rbac.create=true \
          --set controller.publishService.enabled=true \
          --wait
      fi
    fi
    mkdir -p "${WORK_DIR}/certs"
    CA_SECRET=`${KUBECTL_NS} create secret tls ca-key-pair \
      --cert="${WORK_DIR}/certs/ca.crt" \
      --key="${WORK_DIR}/certs/ca.key" \
      --dry-run=client \
      -o yaml`
    echo "$CA_SECRET" | ${KUBECTL_NS} apply -f -
    kubectl create secret tls ca-key-pair \
          --cert="${WORK_DIR}/certs/ca.crt" \
          --key="${WORK_DIR}/certs/ca.key" \
          --namespace=default | true
    ${KUBECTL_NS} create secret tls ca-key-pair \
          --cert="${WORK_DIR}/certs/ca.crt" \
          --key="${WORK_DIR}/certs/ca.key" | true
    CERT_MANAGER_VERSION=v1.4.0
    $KUBECTL create ns cert-manager || echo 'cert-manager ns exists'
    $HELM ${TILLER} upgrade cert-manager jetstack/cert-manager \
      --install \
      --version ${CERT_MANAGER_VERSION} \
      --namespace cert-manager \
      --set installCRDs=true \
      --wait
    $HELM ${TILLER} upgrade reloader stakater/reloader \
      --install \
      --wait \
      --set reloader.watchGlobally=true \
      --namespace kube-system
    if [[ "$UPSTREAM" == "1" ]]; then
      cat <<EOF > ${WORK_DIR}/external-dns-values.yaml
aws:
  region: "${AWS_REGION}"
domainFilters:
  - "${KUBIFY_UPSTREAM_DOMAIN_SUFFIX}"
dryRun: false
policy: upsert-only
rbac:
  create: true
EOF
      kubectl create ns external-dns || echo 'external-dns ns exists'
      helm upgrade external-dns stable/external-dns \
        --install \
        --wait \
        --values ${WORK_DIR}/external-dns-values.yaml \
        --namespace external-dns || \
      ${HELM} ${TILLER} upgrade external-dns stable/external-dns \
        --install \
        --wait \
        --values ${WORK_DIR}/external-dns-values.yaml \
        --namespace external-dns
    fi
  } &> "$KUBIFY_OUT"

  {
    if [[ -z "$UPSTREAM" ]] || [[ "$UPSTREAM" == "0" ]]; then
      echo "Applying local cert-manager automation manifests"
      cat <<EOF | ${KUBECTL_NS} apply -f -
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: ca-issuer
  namespace: demo
spec:
  ca:
    secretName: ca-key-pair
EOF
    else
      echo "Applying cluster cert-manager automation manifests"
      cat <<EOF | ${KUBECTL} apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: demo
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: test@kubify.local
    privateKeySecretRef:
      name: letsencrypt-prod
    http01: {}

EOF
    fi
  } &> "$KUBIFY_OUT"
}

function run_aws_ecr_login {
    aws_ecr_login
}

function aws_ecr_login {
   find ~/.docker/config.json -mmin -60 | grep config || aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com || aws ecr get-login --region ${AWS_REGION} --no-include-email
}

function configure {
  echo "function configure {"
  set_context
  echo "function configure set_context"
  MANIFESTS="${K8S_DIR}"
  echo "function configure MANIFESTS $MANIFESTS"
  echo "Creating namespace"
  {
    $KUBECTL apply -f "$MANIFESTS/bootstrap.yaml"
    while true; do
      sleep 1
      echo "Waiting for namespace $NAMESPACE"
      if $KUBECTL get ns/$NAMESPACE; then
        break
      fi
    done
  } &> "$KUBIFY_OUT"
  if [[ "$KUBIFY_CONTAINER_REGISTRY" == "dockerhub" ]]; then
    update_registry_secret
    echo "function configure update_registry_secret"
  elif [[ "$KUBIFY_CONTAINER_REGISTRY" == "ecr" ]]; then
    run_aws_ecr_login
    echo "function configure run_aws_ecr_login"
  else
    echo "Unsupported KUBIFY_CONTAINER_REGISTRY $KUBIFY_CONTAINER_REGISTRY, currently supported values are dockerhub, ecr. To add an additional KUBIFY_CONTAINER_REGISTRY open an Issue or PR here: https://github.com/willyguggenheim/kubify"
    exit 1
  fi
  
  echo "Configuring DNS and Trusted Certificates. SUDO password might be needed..."
  {
    if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
      CLUSTER_IP=$($MINIKUBE ip)
    elif [[ "$KUBIFY_ENGINE" == "local" ]]; then
      CLUSTER_IP="127.0.0.1"
    fi
    echo "function configure CLUSTER_IP $CLUSTER_IP"
    echo "NOTE: This might ask for your computer password (as it needs sudo)."
    ansible-playbook --connection=local --inventory=127.0.0.1, "${K8S_DIR}/ansible/configure.yaml" \
      --ask-become-pass --extra-vars "cluster_ip=${CLUSTER_IP} local_domain=${KUBIFY_LOCAL_DOMAIN} ca_cert_path=\"${WORK_DIR}/certs/ca.crt\"" \
      --tags="dnsmasq,trust_ca_cert"
  } &> "$KUBIFY_OUT"
    echo "function configure ansible-playbook"
  if [[ "$KUBIFY_CONTAINER_REGISTRY" == "dockerhub" ]]; then
      update_npm_secret
      echo "function configure update_npm_secret"
  elif [[ "$KUBIFY_CONTAINER_REGISTRY" == "ecr" ]]; then
    echo "Using S3 as artifact store"
  else
    echo "Unsupported KUBIFY_CONTAINER_REGISTRY $KUBIFY_CONTAINER_REGISTRY, currently supported values are dockerhub, ecr. To add an additional KUBIFY_CONTAINER_REGISTRY open an Issue or PR here: https://github.com/willyguggenheim/kubify"
    exit 1
  fi
configure_cluster
  echo "function configure configure_cluster"

  echo "Creating secrets"
  {
    export_secret dev kubify "${GIT_DIR}/../kubify/ops/templates/empty"
    echo `_get_secret dev kubify 0` | $KUBECTL_NS apply -f  -
  } &> "$KUBIFY_OUT"
  echo "Building containers (Please be patient)"
  _build_entrypoint      &> "$KUBIFY_OUT"
  echo "Starting containers (Please be patient)"
  {
    SRC_MOUNT_PATTERN=`echo "$SRC_MOUNT" | sed 's/\\//\\\\\//g'`
    HOME_MOUNT_PATTERN=`echo "$HOME_MOUNT" | sed 's/\\//\\\\\//g'`

    if [[ "$KUBIFY_CONTAINER_REGISTRY" == *"dockerhub"* ]]; then
    if [[ $KUBIFY_CI == '1' ]]; then
            ENTRYPOINT_TEMPLATE=`cat "$MANIFESTS/entrypoint_eks.yaml" | sed "s/{{SRC_MOUNT}}/$SRC_MOUNT_PATTERN/g" | sed "s/{{HOME_MOUNT}}/$HOME_MOUNT_PATTERN/g" | sed "s/{{DOCKER_SOCKET_FILE_LOCATION}}/\/var\/run\/docker.sock/g"`
    else
            ENTRYPOINT_TEMPLATE=`cat "$MANIFESTS/entrypoint.yaml" | sed "s/{{SRC_MOUNT}}/$SRC_MOUNT_PATTERN/g" | sed "s/{{HOME_MOUNT}}/$HOME_MOUNT_PATTERN/g" | sed "s/{{DOCKER_SOCKET_FILE_LOCATION}}/\/var\/run\/docker.sock/g"`
    fi
        elif [[ "$KUBIFY_CONTAINER_REGISTRY" == *"ecr"* ]]; then
    if [[ $KUBIFY_CI == '1' ]]; then
            ENTRYPOINT_TEMPLATE=`cat "$MANIFESTS/entrypoint_s3_eks.yaml" | sed "s/{{SRC_MOUNT}}/$SRC_MOUNT_PATTERN/g" | sed "s/{{HOME_MOUNT}}/$HOME_MOUNT_PATTERN/g" | sed "s/{{DOCKER_SOCKET_FILE_LOCATION}}/\/var\/run\/docker.sock/g"`
    else
            ENTRYPOINT_TEMPLATE=`cat "$MANIFESTS/entrypoint_s3.yaml" | sed "s/{{SRC_MOUNT}}/$SRC_MOUNT_PATTERN/g" | sed "s/{{HOME_MOUNT}}/$HOME_MOUNT_PATTERN/g" | sed "s/{{DOCKER_SOCKET_FILE_LOCATION}}/\/var\/run\/docker.sock/g"`
    fi
        else
      echo "please set env KUBIFY_CONTAINER_REGISTRY"
      exit 1
    fi
    echo "$ENTRYPOINT_TEMPLATE"
    echo "$ENTRYPOINT_TEMPLATE" | $KUBECTL_NS apply -f -
    configure_containers
    echo "function configure configure_containers"
  } &> "$KUBIFY_OUT"
  {
    check
    echo "function configure check"
  } &> "$KUBIFY_OUT"
  
  until $KUBECTL get pods --all-namespaces -l app.kubernetes.io/name=kubedb-community | grep Running; do
    echo "Waiting for kubedb to download dependencies...."
    sleep 5
  done
  echo 'Function Configure SUCCESS'
}

function install {
  set -e
  echo "Installing/Updating/Patching/Re-Configuring Kubify (Ansible Playbooks Are Deploying) ..."
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    {
                if ! [ -x "$(command -v ansible)" ]; then
            brew install ansible || brew install ansible
      fi
      if [[ `uname -m` == "arm64" ]]; then
        echo "M1/M2 detected (Arm)"
        ansible-playbook --connection=local --inventory=127.0.0.1, "${K8S_DIR}/ansible/install_kubify_on_mac.yaml"
      else
            ansible-playbook --connection=local --inventory=127.0.0.1, "${K8S_DIR}/ansible/install_kubify_on_mac.yaml"
      fi
    } &> "$KUBIFY_OUT"
    if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
      if [[ $MINIKUBE_VM_DRIVER == "hyperkit" ]];
      then
        if ask "Root privileges will be necessary to configure the hyperkit driver for Minikube"; then
          echo "Configuring minikube driver..." &> "$KUBIFY_OUT"
          sudo chown root:wheel /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit || true
          sudo chmod u+s /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit || true
        else
          echo "Aborting."
          exit 1
        fi
      fi
    fi
  elif [[ "$OSTYPE" == *"linux"* ]]; then
                {
      if ! [ -x "$(command -v ansible)" ]; then
        if ! [ -x "$(command -v pip)" ]; then
          sudo apt update || true
          sudo apt install -y python3-pip || true
        fi
        pip3 install ansible
        if ! [ -x "$(command -v ansible)" ]; then
          sudo apt update || true
          sudo apt install -y ansible || true
        fi
      fi
      echo "NOTE: This might ask for your computer password (as it needs sudo)."
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
        ansible-playbook --connection=local \
          "${K8S_DIR}/ansible/install_kubify_on_debian_ubuntu_and_wsl2.yaml" \
          --ask-become-pass -e ansible_python_interpreter=`which python3`
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
        ansible-playbook --connection=local \
          "${K8S_DIR}/ansible/install_kubify_on_amzn2_centos_fedora_oracle_and_rhel.yaml" \
          --ask-become-pass -e ansible_python_interpreter=`which python3`
      fi

    } &> "$KUBIFY_OUT"
  else
    echo "'install' not supported on $OSTYPE ... yet"
    exit 1
  fi
  
  

  echo "Installing Kind"
[[ -d /usr/local/certificates ]] || sudo mkdir -p /usr/local/certificates || true
ls /usr/local/certificates || sudo mkdir -p /usr/local/certificates || true
cmp -s "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/cert" || cp "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/cert"
cmp -s "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/ca" || cp "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/ca"
cmp -s "${WORK_DIR}/certs/ca.key" "${WORK_DIR}/certs/key" || cp "${WORK_DIR}/certs/ca.key" "${WORK_DIR}/certs/key"
cmp -s "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/cert || sudo cp "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/cert || true
cmp -s "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/ca || sudo cp "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/ca || true
cmp -s "${WORK_DIR}/certs/ca.key" /usr/local/certificates/key || sudo cp "${WORK_DIR}/certs/ca.key" /usr/local/certificates/key || true
cat /proc/version | grep -i microsoft && sudo mount --make-shared / || true
docker ps | grep kind || cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
  - hostPath: "${GIT_DIR}"
    containerPath: /var/folders/kubify
    readOnly: false
  # - hostPath: "${HOME}/.aws"
  #   containerPath: /root/.aws
  # - hostPath: "${HOME}/.ssh"
  #   containerPath: /root/.ssh

- hostPath: /var/run/docker.sock
    containerPath: /var/run/docker.sock
    propagation: HostToContainer
    readOnly: false
  - hostPath: "${WORK_DIR}/certs"
    containerPath: /usr/local/certificates
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
sleep 5
cat /proc/version | grep -i microsoft && sudo mount --make-shared / || true
cat /proc/version | grep -i microsoft && docker pull k8s.gcr.io/ingress-nginx/controller:v0.47.0  && \
  kind load docker-image k8s.gcr.io/ingress-nginx/controller:v0.47.0  && \
  docker pull docker.io/jettech/kube-webhook-certgen:v1.5.1 && \
  kind load docker-image docker.io/jettech/kube-webhook-certgen:v1.5.1  && \
  docker pull docker:latest  && \
  kind load docker-image docker:latest
kubectl get serviceaccounts | grep default || kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
EOF

kubectl get pods probe-socket || kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: probe-socket
  labels:
    purpose: debug
spec:
  containers:
  - name: probe-docker
    image: docker:latest
    imagePullPolicy: IfNotPresent
    command: ['sleep', '600' ]
    securityContext:
      privileged: true
    volumeMounts: 
        - mountPath: /var/run 
          name: docker-sock 
  volumes: 
    - name: docker-sock 
      hostPath: 
        path: /var/run 
EOF
$KUBECTL apply -f "${GIT_DIR}/../kubify/ops/templates/manifests/ingress-nginx-kind.yaml"

$KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s 2>/dev/null || sleep 20
      $KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s 2>/dev/null || sleep 20
      $KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s || sleep 20
      $KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
}

function db {
  set_context
  ${KUBECTL_NS} get svc -l app.kubernetes.io/managed-by=kubedb.com
}

function ps {
  set_context
  ${KUBECTL_NS} get pods "$@"
}

function enable_firewall {
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep "Firewall is enabled" || \
      sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1 || true
    /usr/libexec/ApplicationFirewall/socketfilterfw --getblockall | grep "Firewall is set to block all non-essential incoming connections" || \
      sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on || true
  fi
}

function up {
  set -e
  
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  echo '...................😎 Installing or Re-Installing Kubify 😎...................'
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  echo "NOTE: Please be ready to enter your pw (for SUDO commands)..................."
  if [[ "$@" == "--skip-install" ]]; then
    echo "Skipping installation"
  else
    install
  fi
  test_or_create_s3_artifacts_bucket
  RUNNING=`check_local_env`
  if [[ "${KUBIFY_ENGINE}" == "minikube" ]]; then
    if [ "$RUNNING" != "Running" ]; then
      echo "Starting local cluster (Please be patient)"
      {
        $MINIKUBE config set WantUpdateNotification false
        $MINIKUBE start \
          --profile             ${PROFILE} \
          --vm-driver           "none"
        $MINIKUBE addons enable ${MINIKUBE_ADDONS}

        sudo chown -R $USER:$USER $HOME/.minikube || true
        sudo chown -R $USER:$USER $HOME/.kube || true
      } &> "$KUBIFY_OUT"
    fi
  elif [[ "${KUBIFY_ENGINE}" == "local" ]]; then
    if [ -z "${RUNNING}" ]; then
      echo "Error: Make sure Kubernetes is running locally."
      exit 1
    fi
  fi
  configure
  kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
  docker build -t lambda_layer_python:v1 -f ${GIT_DIR}/../kubify/ops/tools/docker/lambda/lambda/layer/python/Dockerfile ${GIT_DIR}/../kubify/ops/tools/docker/lambda/lambda/layer/python/ || echo "could not build lambda py dependencieslayer builder, but will build anyway on run lambda.."
  if [[ "$ACTUAL_OS_TYPE" == "mac" ]]; then
   open /Applications/Lens.app || echo ""
  fi
  enable_firewall
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  echo 'Function Up: SUCCESS: Installation/Re-Installation Complete!! Kubify for life!!'
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
}

function clear_cache {
  rm -rf "${WORK_DIR}"
}

function down {
  set -e
  enable_firewall
  RUNNING=`check_local_env`
  if [ -z "${RUNNING}" ]
  then
    echo "Local cluster is not running"
  else
    if ask "Do you really want to stop the local cluster?"; then
      if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
        {
          $MINIKUBE stop --profile $PROFILE
        } &> "$KUBIFY_OUT"
      else
           kind delete cluster --name docker-desktop
           kind delete cluster --name kind
           kind get clusters
           rm -rf "${WORK_DIR}"
      fi
    fi
  fi
}

function check_local_env {
  if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
    if ! [ -x "$(command -v minikube)" ]; then
      echo 'Error: minikube is not installed. Run "install" first.' >&2
      exit 1
    fi
    MK_STATUS=$($MINIKUBE status --profile ${PROFILE} | grep host | cut -d ':' -f2 | xargs)
    if [[ "$MK_STATUS" == "Stopped" ]] || [[ -z "$MK_STATUS" ]]; then
      echo "Stopped"
    elif [[ "$MK_STATUS" == "Running" ]]; then
      echo "Running"
    fi
  elif [[ "$KUBIFY_ENGINE" == "local" ]]; then
    if ! [ -x "$(${KUBECTL} cluster-info)" ]; then
      echo "Running"
    fi
  fi
}

function local_env_running {
  RUNNING=`check_local_env`
  
  if [ -f "~/.profile" ]; then
    source ~/.profile || true
  fi
  if [ -z "${RUNNING}" ]
  then
    echo "Local cluster is not running. (Hint: try 'up')"
    exit 1
  fi
}

function display_running {
  if [ -z "$1" ]
  then
    echo "Local cluster is not running. (Hint: try 'up')"
  else
    echo "Local cluster is running"
  fi
}

function delete {
  if ask "Do you really want to delete your local cluster?"; then
    if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
      $MINIKUBE delete --profile $PROFILE &> "$KUBIFY_OUT"
    elif [[ "$KUBIFY_ENGINE" == "local" ]]; then
      echo "Deleting namespace ${NAMESPACE}"
                                                    kind delete cluster --name docker-desktop || echo "run: docker system prune -a"
    fi
  fi
}

function status {
  RUNNING=`check_local_env`
  echo "Kubify Engine: $KUBIFY_ENGINE"
  display_running $RUNNING
  if [ ! -z "${RUNNING}" ]
  then
    if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
      $MINIKUBE Status --profile $PROFILE &> "$KUBIFY_OUT"
    fi
    ${KUBECTL} cluster-info
  fi
}

function check_kubify {
  pwd | grep services || echo "This command should be run in a service directory located under: src (backend) or pub (frontend)"
  pwd | grep services || exit 1
}

function check_arg {
  if [ -z "$2" ]; then
    echo "$1"
    exit 1
  fi
}

function image_name {
  cicd_build_image_name $1
}

function cicd_build_image_name {
  echo "${PUBLISH_IMAGE_REPO_PREFIX}/$1"
}

function services {
  if [[ $* == *--list ]]; then
    LIST=1
  fi
  
  SERVICES=$(find "${GIT_DIR}" -type f -name 'kubify.yml' -exec dirname {} \; | grep -v "k8s" | xargs basename)
  MAX_WIDTH=20
  if [[ $LIST != '1' ]]; then
    printf "%-${MAX_WIDTH}s %s\n" SERVICE HOSTNAME
    for SERVICE in $SERVICES
    do
      {
        INGRESS=$(${KUBECTL_NS} get ingress ${SERVICE} -o jsonpath='{.spec.rules[*].host}')
      } &> /dev/null
      if [[ $INGRESS == '' ]];
      then
        INGRESS='<N/A>'
      fi
      SRV=$(echo $SERVICE | sed 's/[\w]+//g')
      printf "%-${MAX_WIDTH}s %s\n" $SRV $INGRESS
    done
  else
    for SERVICE in $SERVICES
    do
      echo $SERVICE
    done
  fi
}

function images {
  set_context
  docker images | grep "${PUBLISH_IMAGE_REPO_PREFIX}/"
}

function clean {
  set_context
  if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
    echo "Clearing cached images in Minikube..."
    $MINIKUBE Cache delete $(minikube cache list) &> "$KUBIFY_OUT"
  fi
  echo "Clearing unused docker images for services..."
  for APP_NAME in `services --list`
  do
    IMAGE=`image_name $APP_NAME`
    echo "Removing old images for $APP_NAME..."
    docker images | grep $IMAGE | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $IMAGE:{} &> "$KUBIFY_OUT"
  done
  echo "Pruning unused images"
  docker system prune --force
}

function check_skaffold {
  check_kubify
  APP_DIR="$PWD"
  KUBIFY_FILE=${APP_DIR}/kubify.yml
  if [ ! -f $KUBIFY_FILE ]; then
    echo "Have you run 'init' yet?"
    exit 1
  fi
  if [[ $KUBIFY_CI != '1' ]]; then
    set_context
    skaffold config set --global local-cluster true &> "$KUBIFY_OUT"
  fi
}

function publish {
  check_ci_mode publish
  test_or_create_s3_artifacts_bucket
  EXTRA_VERSIONS=$1
  check_skaffold
  APP_DIR="$PWD"
  APP_NAME=`basename "$APP_DIR"`
  echo "Publishing application '$APP_NAME'"
  _init "$APP_DIR" "common,generate_k8s,build_image" "app_cicd_build_image_extra_versions=latest,${EXTRA_VERSIONS}"
}

function dir {
  service=$1
  RELATIVE=${RELATIVE:-0}

  if [ "${RELATIVE}" == "1" ]; then
    S_DIR=""
  else
    S_DIR="${GIT_DIR}/"
  fi
  if [ -z "$service" ]; then
    echo $S_DIR
  elif [ -d "${GIT_DIR}/dev/svc/$service" ]; then
    echo ${S_DIR}dev/svc/$service
  elif [ -d "${GIT_DIR}/dev/pub/$service" ]; then
    echo ${S_DIR}dev/pub/$service
  else
    echo ""
  fi
}

function run-all {
  if [ "$#" -eq 0 ]; then
    echo "there was no services passed in to \"run-all\" command, so running all services.."
    SERVICES=`services --list`
  else
    SERVICES="$@"
  fi

  for entry in $SERVICES
  do
    split=$(echo $entry | tr ":" "\n")
    service=${split[0]}

    version=${version[1]:-latest}

    if [ -d "${GIT_DIR}/dev/svc/$service" ]; then
      cd "${GIT_DIR}/dev/svc/$service"
      run $version
    elif [ -d "${GIT_DIR}/dev/pub/$service" ]; then
      cd "${GIT_DIR}/dev/pub/$service"
      run $version
    else
      echo "Error: Service '${service}' doesn't exist"
    fi
  done
}

function build-run-all {
  if [ "$#" -eq 0 ]; then
    echo "there was no services passed in to \"run-all\" command, so running all services.."
    SERVICES=`services --list`
  else
    SERVICES="$@"
  fi

  for entry in $SERVICES
  do
    split=$(echo $entry | tr ":" "\n")
    service=${split[0]}

    if [ -d "${GIT_DIR}/dev/svc/$service" ]; then
      cd "${GIT_DIR}/dev/svc/$service"
      run
    elif [ -d "${GIT_DIR}/dev/pub/$service" ]; then
      cd "${GIT_DIR}/dev/pub/$service"
      run
    else
      echo "Error: Service '${service}' doesn't exist"
    fi
  done
}

function stop-all {
  if [ "$#" -eq 0 ]; then
    SERVICES=`${KUBECTL_NS} get deployment -l context=kind-kubify -o=jsonpath='{.items[*].metadata.name}'`
  else
    SERVICES="$@"
  fi

  for entry in ${SERVICES}

  do
    split=$(echo $entry | tr ":" "\n")
    service=${split[0]}

    version=${version[1]:-latest}

    if [ -d "${GIT_DIR}/dev/svc/$service" ]; then
      cd "${GIT_DIR}/dev/svc/$service"
      stop
    elif [ -d "${GIT_DIR}/dev/pub/$service" ]; then
      cd "${GIT_DIR}/dev/pub/$service"
      stop
    else
      echo "Error: Service '${service}' doesn't exist"
    fi
  done
}

function run {
  echo "function run {"
  mkdir -p ${WORK_DIR}/repo_local
  APP_VERSION=$1
  check_skaffold
  APP_NAME=`basename $PWD`
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/cloudformation/*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/sec*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/gen*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/gen*
  APP_DIR="$PWD"
  cd "${APP_DIR}"

  SECRETS_FILE="${APP_DIR}/secrets/secrets.${ENV}.enc.yaml"
  CONFIG_FILE="${APP_DIR}/config/config.${ENV}.yaml"
  
  if [ ! -f "${SECRETS_FILE}" ]; then
      secrets create ${ENV}

  fi
  if [ ! -f "${CONFIG_FILE}" ]; then
      echo "${CONFIG_FILE} file not found, creating blank one"
      mkdir -p "${APP_DIR}/config" | true
      cp "${GIT_DIR}/../kubify/ops/templates/config/config.${ENV}.yaml" "${CONFIG_FILE}"
      sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${CONFIG_FILE}"
  fi
  start_dependencies "${APP_DIR}"
  cd "${APP_DIR}"

  echo "Starting application '$APP_NAME'"
  echo "Once the application is running, get its URL by running 'url'"
  init
  _stop $APP_NAME
  export NPM_TOKEN=`get_npm_secret`
  IMAGE_NAME=`image_name ${APP_NAME}`
  $DOCKER pull ${IMAGE_NAME}:latest

if [[ $APP_VERSION != '' ]]; then
    CI_BUILD_IMAGE=`cicd_build_image_name $APP_NAME`
    {
      skaffold config set --global local-cluster true
      ${SKAFFOLD} deploy \
        --images ${CI_BUILD_IMAGE}:${APP_VERSION} \
        --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml \
        --profile $BUILD_PROFILE
    } &> "$KUBIFY_OUT"
  else
    {
      skaffold config set --global local-cluster true
      ${SKAFFOLD} run \
        --cache-artifacts \
        --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml \
        --profile $LOCAL_RUN_PROFILE
    } &> "$KUBIFY_OUT"
  fi
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/cloudformation/lambda*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/sec*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/gen*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/gen*
}

function run-kubify {
  run-all \
    be-svc \
    fe-svc
  logs *
}

function build-run-kubify {
    mkdir -p ${WORK_DIR}/${ENV}/logs
    echo "Building & running Kubify core stack services .."
    echo "To tail logs: tail -f ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE*.log"
    echo "To stop builder: control-c (or if you must: pkill -f kubify)"
    trap 'kill $BGPID1;kill $BGPID2; exit' INT
    echo "The date before build is: `date`"
    build-run-all \
      be-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE1.log &
    BGPID1=$!
    build-run-all \
      fe-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE2.log &
    BGPID2=$!
    wait
    echo "The date after build is: `date`"
    logs *
}

function build-start-kubify {
    mkdir -p ${WORK_DIR}/${ENV}/logs
    echo "Building & running Kubify core stack services .."
    echo "To tail logs: tail -f ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE*.log"
    echo "To stop builder: control-c (or if you must: pkill -f kubify)"
    trap 'kill $BGPID1;kill $BGPID2; exit' INT
    echo "The date before build is: `date`"
    cd ${WORK_DIR}/../dev/svc/be-svc
    start be-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE_be-svc.log &
    BGPID1=$!
    cd ${WORK_DIR}/../dev/pub/fe-svc
    start fe-svc &> ${WORK_DIR}/${ENV}/logs/build-run-kubify-CORE_fe-svc.log &
    BGPID2=$!
    wait
    echo "The date after build is: `date`"
    logs *
}

function get_extention {
  
  dir=$1
  ls -l ${dir} | egrep "kubify.yml|kubify.yaml" | tail -1 | awk '{print $NF}' | awk -F "." '{print $NF}'
}

function start_dependencies {
  APP_DIR="${1}"
  ORIGIN_APP_DIR="${1}"
  extension=$(get_extention "${APP_DIR}")
  pods=$(${KUBECTL_NS} get pods)
  max_seconds=15
  
  pods_wc=$(_get_service_pod localstack-aws-svc | grep localstack-aws-svc 2> /dev/null | wc -l | tr -d " ")
  if [[ "${pods_wc}" != "1" ]]
  then
    cd "${APP_DIR}/../../../services/shared/localstack-aws-svc"
    pwd
    echo $APP_DIR | grep localstack || run
  fi
  
  kubify_depends_on=$(cat "${APP_DIR}/kubify.${extension}" | ~/kubify/yq e '.depends_on' -)
  if [[ "${kubify_depends_on}" != "null" ]]
  then
    echo "checking for service dependencies (looking in kubify.yml for depends_on list of services)"
    num_dependencies=$(cat "${APP_DIR}/kubify.${extension}" | ~/kubify/yq e '.depends_on|length' -)
    for dependancy_index in $(seq 0 $((${num_dependencies}-1)))
    do
      echo "kubify_depends_on: ${kubify_depends_on}"
      dependancy_name=$(cat "${APP_DIR}/kubify.${extension}" | ~/kubify/yq e ".depends_on[${dependancy_index}]" -)
          pods_wc=$(_get_service_pod ${dependancy_name} | grep ${dependancy_name} 2> /dev/null | wc -l | tr -d " ")
      if [[ "${pods_wc}" != "1" ]]
      then
        echo "Starting service: ${dependancy_name}"
        cd "${APP_DIR}/../${dependancy_name}"
        pwd
            run || exit 1
        count_seconds=0
        while [[ ${pods_wc} != "1" ]]
        do
          echo "Waiting for dependant service: ${dependancy_name} to start (see depends_on in kubify), since they were not started already.."
          pods_wc=$(_get_service_pod ${dependancy_name} | grep ${dependancy_name} 2> /dev/null | wc -l | tr -d " ")
          sleep 5
          count_seconds=$(expr $count_seconds + 5)
          if [ "$count_seconds" -gt "$max_seconds" ]; then
            ${KUBECTL_NS} delete deployment ${dependancy_name}

            run || exit 1
          fi
        done
        echo "Validated Required Service: ${dependancy_name} is Running"
        cd "${ORIGIN_APP_DIR}"
      fi
      done
    cd "${ORIGIN_APP_DIR}"
  fi
  cd "${ORIGIN_APP_DIR}"
}

function start {
  
  mkdir -p ${WORK_DIR}/repo_local
  
  APP_NAME=`basename $PWD`
  
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/cloudformation/*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/secr*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/gen-*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/*.log
  APP_DIR="$PWD"
  cd "${APP_DIR}"
  
  SECRETS_FILE="${APP_DIR}/secrets/secrets.${ENV}.enc.yaml"
  CONFIG_FILE="${APP_DIR}/config/config.${ENV}.yaml"
  
  if [ ! -f "${SECRETS_FILE}" ]; then
      secrets create ${ENV}

  fi
  aws_ecr_login
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || check_skaffold
  
  echo "function start APP_NAME $APP_NAME"
  APP_DIR="$PWD"
  
  if [ ! -f "${CONFIG_FILE}" ]; then
      echo "${CONFIG_FILE} file not found, creating blank one"
      mkdir -p "${APP_DIR}/config" | true
      cp "${GIT_DIR}/../kubify/ops/templates/config/config.${ENV}.yaml" "${CONFIG_FILE}"
      sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${CONFIG_FILE}"
  fi
  start_dependencies "${APP_DIR}"
  cd "${APP_DIR}"
  echo "Listening for code changes (on sync folders).."
  echo "NOTE: From Workstation (Outside Kind Cluster Network) to Access URL: url: https://${APP_NAME}.local.kubify.local"
  echo "NOTE: From services: ${APP_NAME}.demo.svc"
  echo "NOTE: From services to KubeDB Databases: ${APP_NAME}-[database_name].demo.svc"
  echo "NOTE: Access DB or to/from additional Ports: kubectl -n demo port-forward [pod] [port]:[port]"
  if [[ "$ACTUAL_OS_TYPE" != "mac" ]]; then
    echo "
    "
    echo "NOTE: I noticed that youo are not on a Mac (dnsmasq is already automoated on Mac). If you are on Windows or Linux and want to connect to the proxy URLs or Kubernetes: Examples below. TODO: Automate this."
       echo "   Example: sudo /bin/sh -c 'echo \"[ip_address_of_kind_container] [the_service_name].local.kubify.local\" >> /etc/hosts'"
       echo "   Example: powershell.exe -c 'echo \"[ip_address_of_kind_container] [the_service_name].local.kubify.local\" >> c:\windows\system32\drivers\etc\hosts'"
    echo "NOTE: I noticed that your are not on a Mac (fw is already automated on Mac). If you are on Windows or Linux, please ensure your fw is set to block incoming connections (TODO: automate the rest of this ASAP, security is most important)."
    echo "
    "
  fi
  init
  
  FALLBACK=0
  if [ ! -f "${WORK_DIR}/${ENV}/${APP_NAME}/Dockerfile.dev" ]; then
    echo "WARNING: No 'Dockerfile.dev' defined for '$APP_NAME', using 'Dockerfile' instead. Run 'kubify help' for more details"
    if [ ! -f "${APP_DIR}/Dockerfile.release" ]; then
      echo "WARNING: No 'Dockerfile.release' defined for '$APP_NAME'. "
      else
      FALLBACK='1'
    fi
  fi
  
  echo "function start FALLBACK $FALLBACK"
  if [[ $FALLBACK == '1' ]]; then
    SKAFFOLD_PROFILE=${LOCAL_RUN_PROFILE}

  else
    SKAFFOLD_PROFILE=${LOCAL_START_PROFILE}

  fi
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || _stop $APP_NAME
  
  echo "Deployed.."
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || echo "Starting Service.."
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || skaffold config set --global local-cluster true && export NPM_TOKEN=`get_npm_secret_direct` &> /dev/null
  cat "${APP_DIR}/kubify.yml" | grep dev_sync_auto_rebuild | grep false && export SKAFFOLD_AUTO_BUILD=false
  export SKAFFOLD_AUTO_SYNC=true
  
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || skaffold config set --global local-cluster true
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || ${SKAFFOLD} dev \
        --cache-artifacts \
        --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml \
        --profile $SKAFFOLD_PROFILE \
        --no-prune \
        --no-prune-children \
        --trigger='polling' \
        --port-forward=false

  cat "${APP_DIR}/kubify.yml" | grep "lambda:" && echo "aws resources localstack deployment results (lambda, s3, sqs, ..):" && aws cloudformation list-stacks --endpoint-url https://localstack-aws-svc.local.kubify.local --no-verify-ssl 2> /dev/null | grep UPDATE_IN_PROGRESS && sleep 10
  cat "${APP_DIR}/kubify.yml" | grep "lambda:" && echo "aws resources localstack deployment results (lambda, s3, sqs, ..):" && aws cloudformation list-stacks --endpoint-url https://localstack-aws-svc.local.kubify.local --no-verify-ssl 2> /dev/null
  
  echo "NOTE: too see lambda logs: logs | grep localstack-aws-svc"
  echo "
  "

echo "Stopping Service.."
  cat "${APP_DIR}/kubify.yml" | grep aws_only | grep true || _stop $APP_NAME
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/manifests/secr*
  rm -rf ${WORK_DIR}/${ENV}/${APP_NAME}/gen-*
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  echo "Service Stopped or Docker SIGHUP -- Happy Rapid Testing, you Rockstar Coder!!!"
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
}

function rapid_reinvoke_all {
  ../../._kubify_work/local/$(basename `pwd`)/deployCloudformation.sh
  ../../._kubify_work/local/$(basename `pwd`)/deployServerless.sh
}

function rapid_reinvoke_sls {
  run_in_entrypoint bash ./._kubify_work/local/$(basename `pwd`)/sls-reinvoke.sh
}

function rapid_reinvoke_kubify {
  
  echo "coming soon.."
}
function stop {
  check_skaffold
  APP_NAME=`basename $PWD`
  init
  echo "Stopping application '$APP_NAME'"
  _stop $APP_NAME
}

function _stop {
  APP_NAME=$1
  {
    skaffold config set --global local-cluster true
    export NPM_TOKEN=`get_npm_secret`
    ${SKAFFOLD} delete --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml --profile $LOCAL_RUN_PROFILE
    ${SKAFFOLD} delete --filename ${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml --profile $LOCAL_START_PROFILE
    ${KUBECTL_NS} delete all -l app=${APP_NAME} --force --grace-period=0
  } &> "$KUBIFY_OUT"
}

function url {
  check_skaffold
  APP_NAME=`basename $PWD`
  echo "https://${APP_NAME}.${KUBIFY_LOCAL_DOMAIN}"
}

function logs {
  set_context
  kubetail --context $PROFILE -n $NAMESPACE -l context=kind-kubify
}

function exec {
  set_context
  if [ "$*" == "" ]; then
    $KUBECTL_NS exec -it `_get_entrypoint` -- bash -l -i
  else
    $KUBECTL_NS exec -it `_get_entrypoint` -- bash -l -i -c "$@"
  fi
}

function cmd {
  check_kubify
  set_context
  {
    APP_NAME=`basename $PWD`
    POD=`_get_service_pod $APP_NAME`
  } &> "$KUBIFY_OUT"
  if [[ $POD == '' ]]; then
    echo "The application '$APP_NAME' is not running."
    exit 1
  fi
  if [ "$*" == "" ]; then
    $KUBECTL_NS exec -it $POD -- sh -l -i
  else
    $KUBECTL_NS exec -it $POD -- sh -l -i -c "$@"
  fi
}

function run_in_entrypoint {
  if [ -z "$KUBERNETES_PORT" ]; then
    CMD="$@"
    exec "$CMD"
  fi
}

function wait_for_deployment {
  check_arg $1 "No deployment name specified!"
  check_arg $2 "No namespace name specified!"
  set_context
  {
    echo "Waiting for deployment $1 in namespace $2"
    $KUBECTL rollout status -w deployment/$1 -n $2
  } &> "$KUBIFY_OUT"
}

function check_containers {
  while true; do
    exec kubify > /dev/null
    if [ "$?" -ne 0 ]; then
      if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
        stop_mount
        start_mount
      fi
      sleep 2
      wait_for_deployment entrypoint $NAMESPACE
    else
      break
    fi
  done
}

function configure_containers {
  check_containers
  
  
}

function run_in_app_entrypoint {
  if [ -z "$KUBERNETES_PORT" ]; then
    CMD="cd `basename $PWD`; kubify $@"
    exec "$CMD"
  fi
}

function init {
  check_kubify
  set_context
  if [[ $* == *--re-run ]]; then
    RERUN=1
  fi
  APP_NAME=`basename $PWD`
  APP_DIR="${PWD}"
  KUBIFY_CONFIG="${APP_DIR}/kubify.yml"
  DOCKERFILE="${APP_DIR}/Dockerfile"
  TAGS="common"
  if [ ! -d "$APP_DIR/secrets" ]; then
    echo "It looks like you haven't imported secrets from AWS. Checking..."
    secrets import all
  fi
  
  if [[ "$RERUN" == "1" ]] || ( [[ ! -f "$KUBIFY_CONFIG" ]] ) || ( [[ -f "$DOCKERFILE" ]] && [[ ! -f "$KUBIFY_CONFIG" ]] ); then
    TAGS="${TAGS}"
  fi
  echo "Initializing '$APP_NAME'"
  
  TAGS="${TAGS},generate_k8s"
  _init "$APP_DIR" "$TAGS"
}

function _init {
  APP_DIR=$1
  APP_NAME=`basename "$APP_DIR"`
  TAGS=$2
  VARS=$3
  IMAGE=`image_name $APP_NAME`
  CI_BUILD_IMAGE=`cicd_build_image_name $APP_NAME`
  if [[ $APP_NAME != "common" ]]; then
    {
      echo "Running service playbook for $APP_NAME with tags: $TAGS"
          if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
        EXPOSE_SERVICE_FLAG="expose_service=true"
      else
        EXPOSE_SERVICE_FLAG="expose_service=false"
      fi
      if [ -z "$UPSTREAM" ]; then
        ENV="local"
        SERVICE_PROFILE=${SERVICE_PROFILE:-dev}

        KUBIFY_DOMAIN_ENV="kubify_domain_env=${ENV}"
        KUBIFY_DOMAIN_SUFFIX=$KUBIFY_LOCAL_DOMAIN_SUFFIX
        CERT_ISSUER="ca-issuer"
        IS_LOCAL="is_local=1"
      else
        KUBIFY_DOMAIN_SUFFIX=$KUBIFY_UPSTREAM_DOMAIN_SUFFIX
        CERT_ISSUER="letsencrypt-prod"
      fi
      ENV_DOMAIN="${ENV}.${KUBIFY_DOMAIN_SUFFIX}"
      ansible-playbook \
        --connection=local \
        --inventory=127.0.0.1, "${K8S_DIR}/ansible/service.yaml" \
        --extra-vars="${EXPOSE_SERVICE_FLAG} env_domain=${ENV_DOMAIN} profile=${SERVICE_PROFILE} ${IS_LOCAL} cert_issuer=${CERT_ISSUER} ${KUBIFY_DOMAIN_ENV} kubify_domain_suffix=${KUBIFY_DOMAIN_SUFFIX} build_profile=${BUILD_PROFILE} skaffold_namespace=${NAMESPACE} env=${ENV} kubify_dir=${WORK_DIR} app_dir=${APP_DIR} app_name=${APP_NAME} app_image=${IMAGE} app_cicd_build_image=${CI_BUILD_IMAGE} kubify_version=${KUBIFY_CURRENT_VERSION} ${VARS}" \
        --tags=$TAGS
    } 2> /dev/stdout 1> "$KUBIFY_OUT"
      
  fi
}

function _generate_manifests {
  APP_DIR=$1
  TAGS=${2:-generate_k8s}

  _init "$APP_DIR" "common,$TAGS"
}

function secrets {
  check_kubify
  check_arg $1 "No action (export/import/create/edit/view) specified!"
  check_arg $2 "No Environment (all/dev/test/stage/prod) specified!"
  ENV=$2
  check_kubify
  APP_DIR="$PWD"
  APP_NAME=`basename "$APP_DIR"`
  SECRETS_FILE=${APP_DIR}/secrets/secrets.${ENV}.enc.yaml
  set_context
  ENV_UPPER=`echo ${ENV} | awk '{ print toupper($0) }'`
  KEY_VAR="${ENV_UPPER}_KMS"
  if [[ $ENV == 'all' ]] && [[ $1 != 'import' ]]; then
    echo "'all' is only valid for 'secrets import'"
    exit 1
  fi
  
  case "$1" in
      export)
        export_secret $ENV $APP_NAME "$APP_DIR" &> "$KUBIFY_OUT"
        ;;
      import)
          if [[ $ENV == 'all' ]]; then
            for env in "${ALL_ENV[@]}"
            do
              echo "Importing secrets for ${APP_NAME} for ${env} environment"
              import_secret $env "$APP_DIR" &> "$KUBIFY_OUT"
            done
          else
            echo "Importing secrets for ${APP_NAME} for ${ENV} environment"
            import_secret $ENV "$APP_DIR" &> "$KUBIFY_OUT"
          fi
          ;;
      create)
          echo "Creating secrets for ${APP_NAME} for ${ENV} environment"
          echo "Note: You can change the secrets text editor by setting the EDITOR env var"
          if [ ! -f "${SECRETS_FILE}" ]; then
              echo "Creating AWS KMS Encrypted Versioned Secret ${SECRETS_FILE}"
              mkdir -p $APP_DIR/secrets | true
              cp "${GIT_DIR}/../kubify/ops/templates/secrets/secrets.${ENV}.enc.yaml" "${SECRETS_FILE}"
              sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${SECRETS_FILE}" || sed -e 's|common|'"${APP_NAME}"'|g' "${SECRETS_FILE}"
          fi
          aws kms list-aliases | grep kubify | grep ${ENV} || echo " please create your KMS key with it's alias, ARN should be like \"${!KEY_VAR}\" "
          kubesec encrypt -i --key="${!KEY_VAR}" "${SECRETS_FILE}" || kubesec encrypt -i --key="${!KEY_VAR}" "${SECRETS_FILE}" --cleartext
          echo "Reloading secrets in-cluster"
          _generate_manifests "$APP_DIR"
          ;;
      edit)
          echo "Editing secrets for ${APP_NAME} for ${ENV} environment"
          echo "Note: You can change the secrets text editor by setting the EDITOR env var"
          if [ ! -f "${SECRETS_FILE}" ]; then
              echo "${SECRETS_FILE} file not found, creating blank encrypted secret file and opening it with your EDITOR"
              mkdir -p $APP_DIR/secrets | true
              cp "${GIT_DIR}/../kubify/ops/templates/secrets/secrets.${ENV}.enc.yaml" "${SECRETS_FILE}"
                        sed -i bak -e 's|common|'"${APP_NAME}"'|g' "${SECRETS_FILE}"
                                        fi
          echo "
apiVersion: v1
data:
  example_key: 'example_value'
kind: Secret
metadata:
  name: common
type: Opaque
          "
          read -p "Press enter to continue (your EDITOR will open for secrets editing, default EDITOR is vi)........."
          kubesec edit -if "${SECRETS_FILE}" --key="${!KEY_VAR}"
          echo "Reloading secrets in-cluster"
          _generate_manifests "$APP_DIR"
          ;;
      view)
          kubesec decrypt "${SECRETS_FILE}" --cleartext \
            --template=$'{{ range $k, $v := .data }}{{ $k }}={{ $v }}\n{{ end }}'
          ;;
      *)
          echo "Invalid option - $1"
  esac
}

function export_secret {
  ENV=${1}
  APP_NAME=${2}
  APP_DIR="${3}"
  SECRET_NAME=kubify_secrets_${APP_NAME}_${ENV}
  SECRETS_FILE=${APP_DIR}/secrets/secrets.${ENV}.enc.yaml
  
  if echo "$APP_DIR" | grep "common"
  then
    SECRETS='{}'
  else
    SECRETS=`kubesec decrypt "${SECRETS_FILE}" --cleartext`
    SECRETS=$(echo "$SECRETS" | ~/kubify/yq e '.data' - | jq -r "with_entries(.key |= .)")
  fi
  aws secretsmanager list-secrets --region $AWS_REGION | grep $SECRET_NAME || aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $SECRET_NAME &> /dev/null || \
    aws secretsmanager create-secret --name $SECRET_NAME --region $AWS_REGION
  aws secretsmanager put-secret-value --secret-id $SECRET_NAME --secret-string "${SECRETS}" --region $AWS_REGION
}

function import_secret {
  ENV=${1}

  APP_DIR="${2}"
  APP_NAME=`basename "$APP_DIR"`
  DEST=${APP_DIR}/secrets
  SECRET_FILE_PATH=${DEST}/secrets.${ENV}.enc.yaml
  mkdir -p $DEST
  SECRETS=`_get_secret $ENV $APP_NAME 1`
  echo "$SECRETS" > $SECRET_FILE_PATH
}

function _get_secret {
  ENV=${1}

  APP_NAME=${2}

  ENCRYPT=${3}

  ENV_UPPER=`echo ${ENV} | awk '{ print toupper($0) }'`
  KEY_VAR="${ENV_UPPER}_KMS"
  SECRET_NAME=kubify_secrets_${APP_NAME}_${ENV}

  
  aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $SECRET_NAME &> /dev/null || export
  SECRET_DATA=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $SECRET_NAME | jq -r .SecretString | jq -r 'map_values(. | @base64)')
  if [ -z "$SECRET_DATA" ]; then
      echo "SECRET_DATA came back empty, debug that?"
      SECRET_DATA='{}'
      SECRET_DATA=$(echo ${SECRET_DATA} | jq -r 'map_values(. | @base64)')
  fi
  if [[ ! -z $ENCRYPT ]]; then
    cat <<EOF | kubesec encrypt --key=aws:"${!KEY_VAR}" - | ~/kubify/yq e -j -
{
  "apiVersion": "v1",
  "kind": "Secret",
  "metadata": {
    "name": "${APP_NAME}"
  },
  "data": ${SECRET_DATA}
}

EOF
  else
    cat <<EOF
{
  "apiVersion": "v1",
  "kind": "Secret",
  "metadata": {
    "name": "${APP_NAME}"
  },
  "data": ${SECRET_DATA}
}

EOF
  fi
}

function undeploy_env {
  check_ci_mode undeploy_env
  UNDEPLOY=yes deploy_env "$@"
}

function deploy_env {
  check_ci_mode deploy_env
  check_arg $1 "Error! Usage: deploy_env <env>"
  ENV=$1
  TAGS=deploy_env
  UNDEPLOY=${UNDEPLOY:-no}

  
  {
    echo "Running env playbook for $ENV with tags: $TAGS"
    ansible-playbook \
      --connection=local \
      --inventory=127.0.0.1, "${K8S_DIR}/ansible/env.yaml" \
      --extra-vars="aws_profile=$AWS_ADMIN_PROFILE src_dir=${GIT_DIR} env=${ENV} kubify_dir=${WORK_DIR} undeploy_env=${UNDEPLOY}" \
      --tags=$TAGS
  } &> "$KUBIFY_OUT"
}

function deploy {
  check_ci_mode deploy
  check_arg $1 "Error! Usage: deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>"
  check_arg $2 "Error! Usage: deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>"
  check_arg $3 "Error! Usage: deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>"
  check_arg $4 "Error! Usage: deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>"
  check_arg $5 "Error! Usage: deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>"
  check_arg $6 "Error! Usage: deploy <service> <cluster> <namespace> <profile> <image_tag> <config_sha>"
  APP_NAME=$1
  CLUSTER=$2
  NAMESPACE=$3
  ENV=${NAMESPACE} 
  SERVICE_PROFILE=$4
  APP_VERSION=$5
  CONFIG_VERSION=$6
  if [ -d "${GIT_DIR}/dev/svc/${APP_NAME}" ]; then
    cd "${GIT_DIR}/dev/svc/${APP_NAME}"
  elif [ -d "${GIT_DIR}/dev/pub/${APP_NAME}" ]; then
    cd "${GIT_DIR}/dev/pub/${APP_NAME}"
  else
    echo "Error: Service $APP_NAME does not exist."
    exit 1
  fi
  check_skaffold
  APP_DIR="$PWD"
  CI_BUILD_IMAGE=`cicd_build_image_name $APP_NAME`
  echo "Deploying application $APP_NAME (version: $APP_VERSION) to cluster $CLUSTER using environment profile $PROFILE in namespace $NAMESPACE"
  SERVICE_PROFILE=${SERVICE_PROFILE} UPSTREAM=1 _init "$APP_DIR" "common,generate_k8s,deploy_service" "kubify_domain_env=${NAMESPACE} app_config_sha=${CONFIG_VERSION} deploy_namespace=$NAMESPACE aws_profile=$AWS_ADMIN_PROFILE app_dir=$APP_DIR deploy_cluster_name=$CLUSTER deploy_image=${CI_BUILD_IMAGE}:${APP_VERSION} skaffold_config=${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml skaffold_profile=$BUILD_PROFILE undeploy=no"
}

function environments {
  check_arg $1 "No action (list/view/status/logs/diff/get-context) specified!"
  ENV=$2
  ENV_FILE="${GIT_DIR}/environments/${ENV}.yaml"
  case "$1" in
      list)
        find "${GIT_DIR}/environments" -type f -name '*.yaml' | sed 's:.*/::' | sed 's/\.[^.]*$//'
        ;;
      logs)
        check_arg $ENV "No Environment (dev/test/stage/prod) specified!"
        if [ ! -f ${ENV_FILE} ]; then
          echo "Error: Environment ${ENV} does not exist!"
          exit
        fi
        echo Showing logs for ${ENV} environment
        CLUSTER=$(cat ${ENV_FILE}| ~/kubify/yq e '.target.cluster' -)
        CONTEXT="${KUBIFY_UPSTREAM_ENV_ACCOUNT}:cluster/${CLUSTER}"
        kubens ${ENV}

        APP=$3
        if [[ -z "${APP}" ]] || [[ "${APP}" == "*" ]]; then
          kubetail \
            --context ${CONTEXT} \
            --namespace ${ENV}

        else
          kubetail \
            --context ${CONTEXT} \
            --namespace ${ENV} \
            --selector "app=${APP}"
        fi
        ;;
      view)
        check_arg $ENV "No Environment (dev/test/stage/prod) specified!"
        if [ ! -f ${ENV_FILE} ]; then
          echo "Error: Environment ${ENV} does not exist!"
          exit 1
        fi
        $KUBECTL --context kubify-${ENV} get environments ${ENV} -o yaml | ~/kubify/yq .
        ;;
      status)
        check_arg $ENV "No Environment (dev/test/stage/prod) specified!"
        if [ ! -f ${ENV_FILE} ]; then
          echo "Error: Environment ${ENV} does not exist!"
          exit 1
        fi
        echo "Error: 'environments status' not implemented yet!"
        exit 1
        ;;
      get-context)
        check_arg $ENV "No Environment (dev/test/stage/prod) specified!"
        if [ ! -f ${ENV_FILE} ]; then
          echo "Error: Environment ${ENV} does not exist!"
          exit 1
        fi
        CLUSTER=$(cat ${ENV_FILE} | ~/kubify/yq e '.target.cluster' -)
        CONTEXT="${KUBIFY_UPSTREAM_ENV_ACCOUNT}:cluster/${CLUSTER}"
        AWS_PROFILE=${AWS_ADMIN_PROFILE} aws eks update-kubeconfig --name ${CLUSTER} --alias kubify-${ENV} --region $AWS_REGION
        kubens ${ENV}

        ;;
      diff)
        check_arg $ENV "No Environment (dev/test/stage/prod) specified!"
        if [ ! -f ${ENV_FILE} ]; then
          echo "Error: Environment ${ENV} does not exist!"
          exit 1
        fi
        TO_ENV=${3}

        check_arg $TO_ENV "No 2nd environment to diff (dev/test/stage/prod) specified!"
        if [ "${ENV}" == "${TO_ENV}" ]; then
          echo "Error: Can't diff an environment with itself!"
          exit 1
        fi
        CLUSTER=$(cat ${ENV_FILE} | ~/kubify/yq e '.target.cluster' -)
        CONTEXT="${KUBIFY_UPSTREAM_ENV_ACCOUNT}:cluster/${CLUSTER}"
        ENV_JSON=$($KUBECTL --context kind-kubify get environments ${ENV} -o yaml | ~/kubify/yq e -j -)
        TO_ENV_JSON=$($KUBECTL --context kind-kubify get environments ${TO_ENV} -o yaml | ~/kubify/yq e -j -)
        SERVICES=$(echo $4 | sed 's/,/ /g')
        if [ -z "${SERVICES}" ]; then
          SERVICES=$(echo $ENV_JSON | ~/kubify/yq e ".data | keys[]" -)
        fi
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "Environment Diff"
        rm -f ${WORK_DIR}/compare_env_1.json ${WORK_DIR}/compare_env_2.json
        echo "${ENV_JSON}" | jq -r "{kubify_version,services}" > ${WORK_DIR}/compare_env_1.json
        echo "${TO_ENV_JSON}" | jq -r "{kubify_version,services}" > ${WORK_DIR}/compare_env_2.json
        json-diff ${WORK_DIR}/compare_env_1.json ${WORK_DIR}/compare_env_2.json
        KUBIFY_VERSION_1=$(echo $ENV_JSON | jq -r ".kubify_version")
        KUBIFY_VERSION_2=$(echo $TO_ENV_JSON | jq -r ".kubify_version")
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "Kubify Diff"
        git --no-pager diff ${KUBIFY_VERSION_1}..${KUBIFY_VERSION_2} "${GIT_DIR}/kubify"
        echo "Services Diff"
        for service in ${SERVICES}; do
          SERVICE_DIR=`dir $service`
          CONFIG_VERSION_1=$(echo $ENV_JSON | jq -r ".services[\"$service\"].config")
          CONFIG_VERSION_2=$(echo $TO_ENV_JSON | jq -r ".services[\"$service\"].config")
          CODE_VERSION_1=$(echo $ENV_JSON | jq -r ".services[\"$service\"].image")
          CODE_VERSION_2=$(echo $TO_ENV_JSON | jq -r ".services[\"$service\"].image")
          printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
          SHOW_CODE_DIFF=1
          SHOW_CONFIG_DIFF=1
          echo "Diff for $service between $ENV and $TO_ENV"
          if [ "${CODE_VERSION_1}" == "null" ]; then
            echo "$service doesn't exist in environment \"$ENV\""
            SHOW_CODE_DIFF=
          fi
          if [ "${CODE_VERSION_2}" == "null" ]; then
            echo "$service doesn't exist in environment \"$TO_ENV\""
            SHOW_CODE_DIFF=
          fi
          if [ "${CODE_VERSION_1}" == "${CODE_VERSION_2}" ]; then
            echo "Info: Code for $service has no differences between $ENV and $TO_ENV"
            SHOW_CODE_DIFF=
          fi
          if [ "${CONFIG_VERSION_1}" == "null" ]; then
            SHOW_CONFIG_DIFF=
          fi
          if [ "${CONFIG_VERSION_2}" == "null" ]; then
            SHOW_CONFIG_DIFF=
          fi
          if [ ! -z "${SHOW_CODE_DIFF}" ]; then
            echo "Code Diff"
            git --no-pager diff "@kubify/${service}@${CODE_VERSION_1}".."@kubify/${service}@${CODE_VERSION_2}" ${SERVICE_DIR} ":(exclude)${SERVICE_DIR}/config" ":(exclude)${SERVICE_DIR}/secrets"
          fi
          if [ ! -z "${SHOW_CONFIG_DIFF}" ]; then
            echo "Config Diff"
            REL_SERVICE_DIR=`RELATIVE=1 dir $service`
            rm -f ${WORK_DIR}/compare_config_1.json ${WORK_DIR}/compare_config_2.json
            git show ${CONFIG_VERSION_1}:${REL_SERVICE_DIR}/config/config.${ENV}.yaml    | ~/kubify/yq e -j - | ~/kubify/yq e '.data' - > ${WORK_DIR}/compare_config_1.json
            git show ${CONFIG_VERSION_2}:${REL_SERVICE_DIR}/config/config.${TO_ENV}.yaml | ~/kubify/yq e -j - | ~/kubify/yq e '.data' - > ${WORK_DIR}/compare_config_2.json
            json-diff ${WORK_DIR}/compare_config_1.json ${WORK_DIR}/compare_config_2.json
          fi
        done
        ;;
      *)
        echo "Invalid option - $1"
  esac
}

function undeploy {
  check_ci_mode undeploy
  check_arg $1 "Error! Usage: undeploy <service> <cluster> <namespace> <profile>"
  check_arg $2 "Error! Usage: undeploy <service> <cluster> <namespace> <profile>"
  check_arg $3 "Error! Usage: undeploy <service> <cluster> <namespace> <profile>"
  check_arg $4 "Error! Usage: undeploy <service> <cluster> <namespace> <profile>"
  APP_NAME=$1
  CLUSTER=$2
  NAMESPACE=$3
  ENV=$4
  if [ -d "${GIT_DIR}/dev/svc/${APP_NAME}" ]; then
    cd "${GIT_DIR}/dev/svc/${APP_NAME}"
  elif [ -d "${GIT_DIR}/dev/pub/${APP_NAME}" ]; then
    cd "${GIT_DIR}/dev/pub/${APP_NAME}"
  else
    echo "Error: Service $APP_NAME does not exist."
    exit 1
  fi
  check_skaffold
  APP_DIR="$PWD"
  CI_BUILD_IMAGE=`cicd_build_image_name $APP_NAME`
  echo "Undeploying application $APP_NAME from cluster $CLUSTER using environment profile $ENV in namespace $NAMESPACE"
  _init "$APP_DIR" "common,generate_k8s,deploy_service" "deploy_namespace=$NAMESPACE aws_profile=$AWS_ADMIN_PROFILE app_dir=$APP_DIR deploy_cluster_name=$CLUSTER deploy_image=${CI_BUILD_IMAGE}:${APP_VERSION} skaffold_config=${WORK_DIR}/${ENV}/${APP_NAME}/skaffold.yaml skaffold_profile=$BUILD_PROFILE undeploy=yes"
}

function new {
  check_arg $1 "Error! Usage: new <app_type> <app_name>"
  check_arg $2 "Error! Usage: new <app_type> <app_name>"
  run_in_entrypoint KUBIFY_DEBUG=${KUBIFY_DEBUG} KUBIFY_CONTAINER_REGISTRY=${KUBIFY_CONTAINER_REGISTRY} KUBIFY_UNIQUE_COMPANY_ACRONYM=${KUBIFY_UNIQUE_COMPANY_ACRONYM} _new "$@"
}

function _new {
  APP_TYPE=$1
  APP_NAME=$2
  APP_DIR="${GIT_DIR}/${APP_TYPE}/${APP_NAME}"

  if [ -d "${APP_DIR}" ]; then
    echo "Error: The app '$APP_NAME' already exists!"
    exit
  fi

  if [ "${#APP_NAME}" -gt 17 ]; then
    echo "Error: Name of app (${APP_NAME}) is too long (${#APP_NAME} chars), please keep it under 18 characters!"
    exit
  fi

  while true; do
    cat << EOF
Do you want to base this app on an existing template?
  1. backend (svc folder)
  2. frontend (pub folder)
EOF
    read -p "Your choice [1-2] (Ctrl-c to Quit): " choice
    if [ "$choice" -ge 1 -a "$choice" -le 2 ]; then
      break
    fi
  done
  TEMPLATES_DIR="${GIT_DIR}/../kubify/ops/templates"
  case "$choice" in
    1)
      echo "Using backend (svc) template..."
      mkdir -p ${APP_DIR}

      cp -R ${TEMPLATES_DIR}/dev/svc/* ${APP_DIR}

      envsubst '${APP_NAME}' < ${TEMPLATES_DIR}/dev/svc/run.sh > ${APP_DIR}/run.sh
      cp ${TEMPLATES_DIR}/dot_dockerignore ${APP_DIR}/.dockerignore
      ;;
    2)
      echo "Using frontend (pub) template..."
      mkdir -p ${APP_DIR}

      cp -R ${TEMPLATES_DIR}/dev/pub/* ${APP_DIR}

      envsubst '${APP_NAME}' < ${TEMPLATES_DIR}/dev/pub/package.json > ${APP_DIR}/package.json
      envsubst '${APP_NAME}' < ${TEMPLATES_DIR}/dev/pub/run.sh > ${APP_DIR}/run.sh
      cp ${TEMPLATES_DIR}/dot_dockerignore ${APP_DIR}/.dockerignore
      ;;
    *)
      echo "Unknown template name, exiting..."
      exit
    ;;
  esac
}

function check_ci_mode {
  if [[ $KUBIFY_CI != '1' ]]; then
    echo "'kubify $1' can be only run in CI mode."
    exit 1
  fi
}

function publish_cicd_build_image {
  check_ci_mode publish_cicd_build_image
  check_arg $1 "No tag specified!"
  TAGS=$1
  IMAGE_NAME=`cicd_build_image_name kubify`
  set -e
  export NPM_TOKEN=`get_npm_secret_direct`
  docker build -t ${IMAGE_NAME}:latest -f "${K8S_DIR}/cicd_build_image/Dockerfile" "$GIT_DIR"
  for TAG in $(echo $TAGS | sed "s/,/ /g")
  do
    docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${TAG}

  done
  docker push ${IMAGE_NAME}
}
function install_container {
  set -e
  echo "Installing/Updating/Patching/Re-Configuring Kubify (Ansible Playbooks Are Deploying) ..."
  if [[ "$OSTYPE" == *"darwin"* ]]; then
    {
                if ! [ -x "$(command -v ansible)" ]; then
            brew install ansible || brew install ansible
      fi
      if [[ `uname -m` == "arm64" ]]; then
        echo "M1/M2 detected (Arm)"
        ansible-playbook --connection=local --inventory=127.0.0.1, "${K8S_DIR}/ansible/install_kubify_on_mac_osx_m1_m1x.yaml"
      else
            ansible-playbook --connection=local --inventory=127.0.0.1, "${K8S_DIR}/ansible/install_kubify_on_mac_osx.yaml"
      fi
    } &> "$KUBIFY_OUT"
    if [[ "$KUBIFY_ENGINE" == "minikube" ]]; then
      if [[ $MINIKUBE_VM_DRIVER == "hyperkit" ]];
      then
        if ask "Root privileges will be necessary to configure the hyperkit driver for Minikube"; then
          echo "Configuring minikube driver..." &> "$KUBIFY_OUT"
          sudo chown root:wheel /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit || true
          sudo chmod u+s /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit || true
        else
          echo "Aborting."
          exit 1
        fi
      fi
    fi
  elif [[ "$OSTYPE" == *"linux"* ]]; then
                {
      if ! [ -x "$(command -v ansible)" ]; then
        if ! [ -x "$(command -v pip)" ]; then
          sudo apt update || true
          sudo apt install -y python3-pip || true
        fi
        pip3 install ansible
        if ! [ -x "$(command -v ansible)" ]; then
          sudo apt update || true
          sudo apt install -y ansible || true
        fi
      fi
      echo "NOTE: This might ask for your computer password (as it needs sudo)."
      if [[ "$ACTUAL_OS_TYPE" == "debian" ]]; then
        ansible-playbook --connection=local \
          "${K8S_DIR}/ansible/install_kubify_on_debian_ubuntu_and_wsl2.yaml" \
          --ask-become-pass -e ansible_python_interpreter=`which python3`
      fi
      if [[ "$ACTUAL_OS_TYPE" == "centos" ]]; then
        ansible-playbook --connection=local \
          "${K8S_DIR}/ansible/install_kubify_on_amzn2_centos_fedora_oracle_and_rhel.yaml" \
          --ask-become-pass -e ansible_python_interpreter=`which python3`
      fi

    } &> "$KUBIFY_OUT"
  else
    echo "'install' not supported on $OSTYPE ... yet"
    exit 1
  fi
  
  
}

function up_container {
  set -e
  mkdir -p ./._kubify_work;
  cp -R ~/.aws ./._kubify_work/;

kind version || brew install kind || apt-get install kind || choco install kind
docker ps | grep kind || cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
  - hostPath: "${GIT_DIR}"
    containerPath: /var/folders/kubify
    readOnly: false
  # - hostPath: "${HOME}/.aws"
  #   containerPath: /root/.aws
  # - hostPath: "${HOME}/.ssh"
  #   containerPath: /root/.ssh

- hostPath: /var/run/docker.sock
    containerPath: /var/run/docker.sock
    propagation: HostToContainer
    readOnly: false
  - hostPath: "${WORK_DIR}/certs"
    containerPath: /usr/local/certificates
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
  stat ~/kubify/kubedb.txt || touch ~/kubify/kubedb.txt
  docker-compose up -d
  docker ps | grep kubify-kubify-1
  docker exec -it --privileged -w "/var/folders/kubify" "kubify-kubify-1" ./_up_container
  docker exec -it --privileged -w "/var/folders/kubify/dev/svc/localstack-aws-svc" "kubify-kubify-1" ../../../run
  
}

function _up_container {
  set -e
  
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  echo '...................😎 Installing or Re-Installing Kubify 😎...................'
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  if [[ "$@" == "--skip-install" ]]; then
    echo "Skipping installation"
  else
  echo "Installing Kind"
[[ -d /usr/local/certificates ]] || sudo mkdir -p /usr/local/certificates || true
ls /usr/local/certificates || sudo mkdir -p /usr/local/certificates || true
cmp -s "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/cert" || cp "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/cert"
cmp -s "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/ca" || cp "${WORK_DIR}/certs/ca.crt" "${WORK_DIR}/certs/ca"
cmp -s "${WORK_DIR}/certs/ca.key" "${WORK_DIR}/certs/key" || cp "${WORK_DIR}/certs/ca.key" "${WORK_DIR}/certs/key"
cmp -s "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/cert || sudo cp "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/cert || true
cmp -s "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/ca || sudo cp "${WORK_DIR}/certs/ca.crt" /usr/local/certificates/ca || true
cmp -s "${WORK_DIR}/certs/ca.key" /usr/local/certificates/key || sudo cp "${WORK_DIR}/certs/ca.key" /usr/local/certificates/key || true
cat /proc/version | grep -i microsoft && sudo mount --make-shared / || true
docker ps | grep kind || exit 1
cat /proc/version | grep -i microsoft && sudo mount --make-shared / || true
cat /proc/version | grep -i microsoft && docker pull k8s.gcr.io/ingress-nginx/controller:v0.47.0  && \
  kind load docker-image k8s.gcr.io/ingress-nginx/controller:v0.47.0  && \
  docker pull docker.io/jettech/kube-webhook-certgen:v1.5.1 && \
  kind load docker-image docker.io/jettech/kube-webhook-certgen:v1.5.1  && \
  docker pull docker:latest  && \
  kind load docker-image docker:latest
kubectl get serviceaccounts | grep default || kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
EOF

kubectl get pods probe-socket || kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: probe-socket
  labels:
    purpose: debug
spec:
  containers:
  - name: probe-docker
    image: docker:latest
    imagePullPolicy: IfNotPresent
    command: ['sleep', '600' ]
    securityContext:
      privileged: true
    volumeMounts: 
        - mountPath: /var/run 
          name: docker-sock 
  volumes: 
    - name: docker-sock 
      hostPath: 
        path: /var/run 
EOF
$KUBECTL apply -f "${GIT_DIR}/../kubify/ops/templates/manifests/ingress-nginx-kind.yaml"

$KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s 2>/dev/null || sleep 20
      $KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s 2>/dev/null || sleep 20
      $KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s || sleep 20
      $KUBECTL wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

  fi
  test_or_create_s3_artifacts_bucket
  RUNNING=`check_local_env`
  if [[ "${KUBIFY_ENGINE}" == "minikube" ]]; then
    if [ "$RUNNING" != "Running" ]; then
      echo "Starting local cluster (Please be patient)"
      {
        $MINIKUBE config set WantUpdateNotification false
        $MINIKUBE start \
          --profile             ${PROFILE} \
          --vm-driver           "none"
        $MINIKUBE addons enable ${MINIKUBE_ADDONS}

        sudo chown -R $USER:$USER $HOME/.minikube || true
        sudo chown -R $USER:$USER $HOME/.kube || true
      } &> "$KUBIFY_OUT"
    fi
  elif [[ "${KUBIFY_ENGINE}" == "local" ]]; then
    if [ -z "${RUNNING}" ]; then
      echo "Error: Make sure Kubernetes is running locally."
      exit 1
    fi
  fi
  configure
  kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
  docker build -t lambda_layer_python:v1 -f ${GIT_DIR}/../kubify/ops/tools/docker/lambda/lambda/layer/python/Dockerfile ${GIT_DIR}/../kubify/ops/tools/docker/lambda/lambda/layer/python/ || echo "could not build lambda py dependencieslayer builder, but will build anyway on run lambda.."
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻👩‍💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
  echo 'Function Up: SUCCESS: Installation/Re-Installation Complete!! Kubify for life!!'
  echo '💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻💻'
}

function deploy_cloud {
  if [ "$1" ]; then
    echo "IN PROGRESS: Deploying Kubify Cloud to \"${1}\" Environment.."
    ${GIT_DIR}/dev/aws/deploy-west-east-eks-${1}.sh
  else
    echo "You did not specify an Env arg, default is dev Environment, so:"
    echo "IN PROGRESS: Deploying Kubify Cloud to \"dev\" Environment.."
    ${GIT_DIR}/dev/aws/deploy-west-east-eks-dev.sh
  fi
}

function delete_clouds_testing {
  eksctl delete cluster --name "kubify-cpu-dev-west" --region us-west-2 &
  eksctl delete cluster --name "kubify-gpu-dev-west" --region us-west-2 &
  eksctl delete cluster --name "kubify-cpu-dev-east" --region us-east-1 &
  eksctl delete cluster --name "kubify-gpu-dev-east" --region us-east-1 &
  wait
}

function help {
  cat << EOF
Kubify is a CLI tool to manage the development and deployment lifecycle of microservices.

Usage:
  kubify [command]

Quickstart:
  up
  cd <your-app>
  start

Available Commands:
  dir               List the full path of the directory or any of the services
                      cd \$(dir be-svc)     # Change to the be-svc directory
                      cd \$(dir)                # Change to the directory

  check             Perform some sanity checks

  up                Start the local cluster

  down              Stop the local cluster

  delete            Delete the local cluster

  status            Show the status of the local cluster

  services          List all the services

  images            List the Docker images

  clean             Purges/clears any caches
                      clean

                      - Removes cached docker images (Minikube)
                      - Removes unused application images

  ps                List the running services

  logs              Tail the logs of all applications
                      logs

  new               Create a new application from a template
                      new {{ app_type }} {{ app_name }}

  secrets           Import, create, edit or view secrets per app per environment
                      secrets <export/import/create/view/edit> {{ env }}

                      export: Write the encrypted secrets to AWS secrets manager
                      import: Read the secrets from AWS secrets manager and write to secrets locally
                      create: Create an empty version-controlled secrets file
                      view:   View the entries in cleartext for version-controlled secrets
                      edit:   Edit the entries for version-controlled secrets

  start             Start the app locally for local development (Watch changes)
                      start

  start-all         Start all services in debug mode

  run               Run the app locally
                      run [<app_version>]

  run-all           Run a list of services in one-shot locally
                      run-all [[service1]:[tag]] [[service2]:[tag]] ...
                      OR
                      run-all

                    Example:
                      run-all kubify be-svc

  stop              Stop the app locally
                      stop

  stop-all          Stop a list of services in one-shot locally
                      stop-all [service1] [service2] ... [service_N]
                      OR
                      stop-all

                    Example:
                      stop-all kubify be-svc

  cmd               Run a command/shell in the current application
                      cmd [<cmd_name> [<options>]]

  url               Get the URL for the current service
                      url

  exec              Run a command/shell in the entrypoint container
                      exec [<cmd_name> [<options>]]

  environments      Get information/logs about environments
                      list:         List all the environments
                      logs:         Tail logs for an application in an environment
                                      Example: environments logs dev kubify
                      view:         View the details for a given environment
                                      Example: environments view dev
                      status:       View the deployment status for a given environment
                                      Example: environments status dev
                      diff:         Compare two environments to see differences in deployed images and configs
                                      Examples:
                                        environments diff stage prod                       # Compare entire environment
                                        environments diff stage prod "kubify,be-svc"    # Compare kubify and be-svc
                      get-context:  Switch the kubectl context to the environment
                                      Example: environments get-context dev


Flags (Enable: 1; Disable: 0):
  KUBIFY_VERBOSE      Toggle verbose logging
  KUBIFY_DEBUG        Toggle verbose plus show every command (extra verbose)
  KUBIFY_ENGINE       The kubernetes engine to use (Supported: local (default), minikube)
  KUBIFY_PROFILE      The kubernetes profile to use (Advanced)

EOF
}

read_flag_verbose

if [ "$*" == "" ]; then
  help
else
  # TODO: ensure commenting this block does not break anything:
  # Update the kube context
  # if [ -x "$(command -v kubectx)" ]; then
  #   # | true fixes partial install edge case
  #   kubectx $PROFILE &> /dev/null | true
  # fi
  "$@"
fi