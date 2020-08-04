#!/bin/bash

# Text color variables
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgre=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
txtrst=$(tput sgr0)             # Reset
ERR=${bldred}ERROR${txtrst}
INFO=${bldgre}INFO${txtrst}
WARN=${bldylw}WARNING${txtrst}

RETRIES=10
ATTEMPT=0
SLEEP=5

usage()
{
    cat << EOF
Sync secrets to a running k3d cluster

Usage : ./$(basename $0) [-n <cluster-name>] [-k kubeconfig]
      -h | --help              : Show this message
      -n | --name              : Kubernetes Cluster name

               ex :
               ./$(basename $0)

EOF
}

# Options parsing
while (($#)); do
  case "$1" in
    -h | --help) usage; exit 0;;
    -n | --name) CLUSTER_NAME=${2}; shift 2;;
    -k | --kubeconfig) KUBECONFIG=${2}; shift 2;;
    *)
        echo "${err} : Unknown option"
        exit 3
    ;;
  esac
done

if [[ -z ${CLUSTER_NAME} ]]; then
    CLUSTER_NAME="default"
fi
if [[ -z ${KUBECONFIG} ]]; then
    KUBECONFIG=$(pwd)/.kubeconfig
fi

echo -e "\n${INFO}: Syncing Vault secrets ..."

k3d kubeconfig get ${CLUSTER_NAME} > ${KUBECONFIG}
kubectl config use-context k3d-${CLUSTER_NAME}
until [ ${ATTEMPT} -eq ${RETRIES} ]; do
  if ! [ "$(kubectl get po -n secrets vault-0 -o jsonpath='{.status.phase}')" == "Running" ]; then
    echo -e "${WARN}: Waiting for local Vault instance to be available"
    sleep ${SLEEP}
    ((ATTEMPT++))
  else
    break
  fi
done

EXEC="kubectl exec -ti --namespace secrets vault-0 --"

# Write demo secrets
if ! ${EXEC} vault kv list /kv/demo &>/dev/null; then
  sleep 10
  ${EXEC} vault kv put kv/demo/env FOO=BAR

${EXEC} vault policy write demo - <<EOF
  path "kv/demo/env" {
    capabilities = ["read"]
  }
EOF

  ${EXEC} vault write auth/kubernetes/role/helloworld \
    bound_service_account_names=helloworld \
    bound_service_account_namespaces=demo \
    policies=demo \
    ttl=24h
fi
