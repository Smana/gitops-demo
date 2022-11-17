# Kubernetes Developer experience example

## Requirements

* docker
* k3d >v4.x.x
* skaffold >v1.2x.x

## Install k3d

Install k3d from the release page [here](https://github.com/rancher/k3d/releases)
required version > v4.x.x


```console
$ export KUBECONFIG=~/.kube/skaffold
$ k3d cluster create staging -p "8081:80@loadbalancer"
```

Check that the cluster is available

```console
kubectl get nodes
NAME                   STATUS   ROLES                  AGE   VERSION
k3d-staging-server-0   Ready    control-plane,master   71m   v1.21.1+k3s1
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

This is a simple web applications to demonstrate a GitOps workflow using **Github Actions** and [**Flux v2**](https://toolkit.fluxcd.io/).

## Deploy using Flux

This is a good practice to separate the code of our application and the config to define how it is deployed.
The GitOps workflow is defined if the repository [**flux-demo**](https://github.com/Smana/flux-demo)

## Release a new version

The git branch format is important for the release workflow.
Here are the **prefixes** to prepend to the branch names:

* Bug fixes: `fix/`
* Features: `feat/`
* Maintenance changes: `chore/`
* Documentation changes: `doc/`

By default it will create a **draft** release with a patch tag (eg. v0.1.**1**)
It is possible to add a label `minor` or `major` to control the version.