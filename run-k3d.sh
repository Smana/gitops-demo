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

REQUIRED_BINARIES=( kubectl helm skaffold k3d )

check_local_env()
{
    for BIN in ${REQUIRED_BINARIES[@]}; do
        if ! $(type ${BIN} >/dev/null 2>&1);
            then
            echo "$ERR: ${txtbld}${BIN}${txtrst} binary not found"
            exit 1
            fi
    done

    if ! docker info > /dev/null 2>&1; then
        echo -e "${ERR}: docker is not running"
        exit 1
    fi
}

usage()
{
    cat << EOF
Basic tests of a Kubernetes cluster

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


check_local_env

# Create cluster

if ! k3d cluster list | awk '{print $1}' | grep -q ^${CLUSTER_NAME}; then
    echo -e "${WARN}: Local kubernetes cluster ${CLUSTER_NAME} doesn't exist, creating it ...\n"
    k3d cluster create ${CLUSTER_NAME} --api-port 6550 -p 8081:80@loadbalancer --wait
    k3d kubeconfig get ${CLUSTER_NAME} > ${KUBECONFIG}
else
    k3d kubeconfig get ${CLUSTER_NAME}
    if nc -z localhost 6550; then
        echo -e "\n${INFO}: Cluster ${CLUSTER_NAME} is already running"
    else
        k3d kubeconfig get ${CLUSTER_NAME} > ${KUBECONFIG}
    fi
fi
kubectl config use-context k3d-${CLUSTER_NAME}
