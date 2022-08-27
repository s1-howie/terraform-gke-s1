# terraform-gke-s1
A terraform template to create a basic GKE cluster and auto-install the SentinelOne Agent for K8s.

## Detailed Description

This terraform template is based on [Provision a GKE Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster) and is designed to facilitate the creation of a 'vanilla' GKE cluster for usage with testing/demos/etc.
It will create:
- A new VPC and subnet which will contain all associated resources
- A GKE cluster and a separately managed node pool
- A new namespace within the cluster to house the SentinelOne K8s resources
- A new K8s secret within the above-mentioned namespace that contains the credentials needed to pull the S1 images
- A helm deployment of the SentinelOne Agent for K8s

The template has a local-exec provisioner that will take care of setting the Kubernetes context for the local Linux/Macbook system.

# GCP/GKE Pre-Requisites
- A [GCP account](https://console.cloud.google.com/) 
- A configured gcloud SDK (gcloud CLI utility)
- kubectl


# Local MBP/Linux workstation Pre-Requisites
- git v2.32+ (https://git-scm.com/downloads)
- terraform v0.14+ (https://www.terraform.io/downloads.html)
- gcloud SDK (https://cloud.google.com/sdk/docs/quickstarts)
- kubectl v1.21+ (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- helm 3.0+ (https://helm.sh/docs/intro/install/)

On a MBP, you can easily install all of these pre-requisites with [homebrew](https://formulae.brew.sh/):
```
brew update && brew install --cask google-cloud-sdk
brew update && brew install git terraform kubernetes-cli helm 
```

# Setting up terraform to communicate with GCP
After you've installed the gcloud SDK, initialize it by running "gcloud init".

This will authorize the SDK to access GCP using your user account credentials and add the SDK to your PATH. This steps requires you to login and select the project you want to work in.

Finally, add your account to the Application Default Credentials (ADC). This will allow Terraform to access these credentials to provision resources on GCloud.
```
gcloud auth application-default login
```

# Usage
1. Clone this repository
```
git clone https://github.com/s1-howie/terraform-gke-s1.git
```
2. Edit the variables in the sample 'terraform.tfvars.removeme' file to suit your environment

3. Remove the '.removeme' extension from terraform.tfvars.removeme so that the filename reads as: terraform.tfvars

4. Initialize terraform
```
terraform init
```
5. Run 'terraform apply' to execute the template
```
terraform apply
```
   This process typically takes 5-10 minutes.

6. Review the resources that will be created by the template and type "yes" to proceed.
   Once the template completes creating all resources, you should be able to use kubectl to manage your new cluster.
```
kubectl cluster-info
```
```
kubectl get nodes
```
```
kubectl get pods -A
```

# Cleaning up
After you've finished with your cluster, you can destroy/delete it (to keep your GCP bill as low as possible)
```
terraform destroy -auto-approve
```
   This process typically takes 5-10 minutes.
