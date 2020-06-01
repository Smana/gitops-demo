# GitOps workflow demo

This is a simple web applications to demonstrate a gitops workflow using Github actions and ArgoCD.
At the end of the pipeline the Helm values are commited for a given pull-request.
When this pull-request is merged, ArgoCD automatically deploys the change in the target Kubernetes cluster.
