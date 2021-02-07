# Kubernetes Developer experience example

## Requirements

* docker
* k3d >v3.0.x
* skaffold >v1.19.x

## Install k3d

Install k3d from the release page [here](https://github.com/rancher/k3d/releases)
required version > v3.x.x


```console
$ export KUBECONFIG=~/.kube/skaffold
$ k3d create cluster default --api-port 6550 -p 8081:80@loadbalancer
$ k3d get kubeconfig default --switch
/home/smana/.kube/skaffold
```

Check that the cluster is available

```console
kubectl get nodes
NAME                 STATUS   ROLES    AGE   VERSION
k3d-default-master-0   Ready    master   62m   v1.18.4+k3s1
```

## Local dev

We use a combination of docker commands for formatting and linting, then skaffold is used to

* build the image
* test image built with structure-tests
* deploy on a local k3d cluster

### Code formatting

```console
make format
```

### Building the image

```console
make build
```

### Testing the application

```console
make dev
```

This action will use skaffold to build the image then tests are run and finally the application is exposed.

### Skaffold under the hood

Note that skaffold detects automatically that this is a local k3d cluster as the cluster name starts with `k3d-(.*)`
That means that, during the dev step, the image would be copied locally to the local k8s instance. The image won't be pushed in order to speed up the feedback loop

```console
skaffold dev
Listing files to watch...
 - smana/helloworld
Generating tags...
 - smana/helloworld -> smana/helloworld:0cbeeae-dirty
Checking cache...
 - smana/helloworld: Not found. Building
Found [k3d-default] context, using local docker daemon.
Building [smana/helloworld]...
...
Loading images into k3d cluster nodes...
 - smana/helloworld:d70199b9aa0a7e6a38...
```

Another trick helps speeding up the feedback: some files don't require to rebuild the whole image. We make use of the "File Sync" in order to copy the files to the running container.

excerpt of the skaffold.yaml

```yaml
build:
  artifacts:
    - image: smana/helloworld
      sync:
        infer: ["**/*.html"]
```

## GitOps workflow

This is a simple web applications to demonstrate a GitOps workflow using **Github Actions** and [**ArgoCD**](https://argoproj.github.io/argo-cd/).

At the end of the pipeline the Helm values are committed for a given pull-request.

When this pull-request is merged, ArgoCD automatically deploys the change in the target Kubernetes cluster.

## Secrets (optional)

It is possible to use the Vault dynamic secrets injection in order to add secrets to your applications.
It requires to set it up, and storing your secrets in the local (inside the k3d instance).