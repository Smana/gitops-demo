# GitOps workflow demo

This is a simple web applications to demonstrate a GitOps workflow using **Github Actions** and [**ArgoCD**](https://argoproj.github.io/argo-cd/).

At the end of the pipeline the Helm values are commited for a given pull-request.

When this pull-request is merged, ArgoCD automatically deploys the change in the target Kubernetes cluster.
