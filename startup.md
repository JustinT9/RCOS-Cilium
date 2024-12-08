*Recommended to use Linux or Ubuntu/WSL*  
*Powershell or any windows related distro is not recommended for onboarding*
*Please read onboarding.md before using this document*  

Follow general recommended steps (in this strict order) to properly install Cilium:
#### INSTALLATION 
1. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
    a. Make sure to be apart of the Cilium organization on https://app.terraform.io/app/organizations in order to have access to the subscription and its resources 
2. [Install Docker](https://minikube.sigs.k8s.io/docs/drivers/docker/) (to run minikube to start up cluster) 
3. [Install Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)  
4. [Install Kubectl](https://kubernetes.io/docs/tasks/tools/)
5. [Install Cilium CLI](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-the-cilium-cli)  
6. [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) 

*REMINDER: When running the terraform commands adding the `-var-file="vars.tfvars"` flag  which consists of credentials needed to perform the terraform commands with the proper access*

#### Starting Up Cilium Environment
7. Running Terraform (recommended)
    a. Navigate to the azure-migration branch on the RCOS-Cilium repo and run `bash testing.sh cilium-base` which both performs terraform init, plan and apply  
8. Running Terraform (old)
    a. In command line: `terraform init` - sets up Terraform to run your configuration by initializing the backend and installing the plugins for the providers defined in your configuration.  
    b. In command line: `terraform plan` - displays what actions Terraform will perform when you apply your configuration. It doesn't make any changes to real resources but shows you a preview of what will happen.  
    c. In command line: `terraform apply` - Terraform will ask you to confirm that you want to perform the actions detailed in the plan. Type `yes` to proceed. This process can take several minutes as Terraform works to set up your EKS cluster and all associated resources  
9. Register a Microsoft Azure Account with your school email to be apart of the RCOS-Cilium group
10. In command line: `az login` and for the first time, it will prompt you to create a new access token that you must save. Afterwards, select the correct subscription corresponding to the cilium group or do `az account set --subscription <token>`
11. Once the `terraform apply` and `az login` are successful, you'll need to configure kubectl to interact with your new EKS cluster. You can use the AKS CLI to update your kubeconfig file with the context of your new cluster: `az aks get-credentials --resource-group RCOS-Cilium_group --name test-aks`  
12. Verify that you can connect to your Kubernetes cluster by running: `kubectl get nodes`  
13. Additional Details about the cluster: `kubectl cluster-info`

### IMPORTANT: Cleaning Up Resources
*REMINDER: When running the terraform commands adding the `-var-file="vars.tfvars"` flag  which consists of credentials needed to perform the terraform commands with the proper access*

Destroy Terraform: Run this when you are finished with the cluster to avoid errant costs 
`terraform destroy` or 
`terraform state list` to list the resources terraform created and applied 
`terraform state rm statefile1 statefile2 ... statefileN` to delete the state files 





