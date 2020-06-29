#!/bin/bash

set -e

# Text color variables
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgre=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
txtrst=$(tput sgr0)             # Reset
ERR=${bldred}ERROR${txtrst}
INFO=${bldgre}INFO${txtrst}
WARN=${bldylw}WARNING${txtrst}

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


if ! k3d get clusters | awk '{print $1}' | grep -q ^${CLUSTER_NAME}; then
    echo -e "${INFO}: The cluster ${CLUSTER_NAME} doesn't exist, creating it ...\n"
    k3d create cluster ${CLUSTER_NAME} --api-port 6550 -p 8081:80@loadbalancer --wait
    k3d get kubeconfig ${CLUSTER_NAME} --switch
    exit 0
fi

k3d get kubeconfig ${CLUSTER_NAME} --switch


if nc -z localhost 6550; then
    echo -e "${INFO}: Cluster ${CLUSTER_NAME} is already running \n"
else
    k3d start cluster ${CLUSTER_NAME}
fi
