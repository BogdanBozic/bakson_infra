
# bakson_infra
Infrastructure repo for bakson_app

## Overview

The infrastructure repository consists of two parts:

- Terraform resources definitions that include:
  - Network
  - EKS
  - Helm resources for EKS:
    - Cert-manager
    - ArgoCD
    - Nginx Ingress Controller
- Kubernetes Helm resources that include:
  - Application Helm definition
  - ArgoCD app for the application

## Terraform Resources

### Overview

In a real-world scenario, we would have separate modules for different things, like network, EKS control plane definition, worker nodes...
I didn't want to make things too complicated here as these resources will not be reused anywhere outside of this project.
Also, the state file is stored locally, whereas under any other different circumstances this should never be the case.

### Network

A new VPC is created for this project. This probably would have already existed in a real-world scenario where we would only use the existing module definition.

The VPC has two subnets created for higher availability, but both the EKS control plane and the worker nodes are placed in them. In a real world scenario, we would have those separated so both of the groups have their own subnets with security groups allowing them to communicate one with another.

A single Internet Gateway is attached to both of the subnets so the Control Plane is reachable from outside.

### EKS Control Plane

Not much to tell here, this is a managed service.

### Worker nodes

Not much to tell here, either. I am currently running two worker nodes of type "t2.medium" to save on the costs. In real life this wouldn't be sufficient to cover for required kubernetes resources *and* the apps.

### Helms

For the initial setup of the Kubernetes cluster I have used Helm charts for deploying Cert-manager, Nginx Ingress Controller and ArgoCD, while the helms from the `helms` directory are generated manually.
More on this in the Application CD part.

One thing to note here is that ArgoCD has been deployed with the default Helm chart, meaning that it generates its own Classic Load Balancer within AWS for its endpoint. I have manually created a record in Route 53 for it, but it only has a self-signed certificate. Had it been deployed with Ingress the certificate would have been handled by Cert-manager. I just didn't have the time to look into that setup.

### ECR

I have opted for storing the images on AWS ECR for the sake of simplicity. I personally see no difference in using DockerHub, AWS ECR or Harbor, except for the costs, which I have never researched, so I cannot have an opinion there.

App images are being uploaded automatically by GitHub Actions and tagged with the GitHub run id. Under different circumstances, I would have it use semantic-version for determining and following the, well, semantic version of the application(s).

### GitHub Actions Secrets

These are the resources that are uploaded automatically to the application repository. There are some inconsistencies here that should be fixed, but the whole idea with these secrets is to have the application workflows as templatisized (if this is even a word) as possible, so to reduce the manual input for new workflows.

## Kubernetes Helm resources

### Application charts

Application charts are, well, application Helm charts. Nothing exceptional there. Since there is only one app I haven't utilized Helm's templating possibility (other than what's by default there when generating a chart).

### ArgoCD app charts (Application CD)

For this scenario I didn't use the `app of apps` approach since there is only one app. I never set ArgoCD before so that would take some additional time, which I ran out of.

ArgoCD App is created manually through UI (will be demonstrated), but I know there is a way to do it through Terraform as well.

## Infra repo CI/CD

All the deployments have been done manually for this repo. Normally, there would be a CI/CD setup for this as well, provided that Terraform and Kubernetes resources are in the same repo, which I would separate as well. This way, I would separate the workflows by the directories changed to have one for Terraform changes and one for Kubernetes resources changes.
