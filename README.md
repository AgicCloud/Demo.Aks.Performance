# Demo Performance

## About The Project
The goal of this project is to create, in a few simple steps, a kubernetes work environment, where you can test the performance and resilience of your own web application, through load tests and chaos engineering experimentation.

The following resources will be installed:
 - Azure Kubernetes Service
 - Azure Load Testing
 - Chaos Experiment

This project contains a pipeline that deploys all the previous components to an Azure Subscription. The execution of this pipeline creates the resources, then deploys to the AKS cluster the following resources:
- the Nginx Ingress Controller
- the web app to be tested
- Prometheus and Grafana to monitor the web app metrics
- the Chaos Mesh to simulate random faults

Finally creates and run the JMeter load test and the Chaos Experiment during the load test, to simulate random faults. 

## Getting Started
Follow the instructions to prepare the environment before start the pipeline.

The first thing to do before installation is to fork your repository.

![fork](https://user-images.githubusercontent.com/60384226/166690858-8a6bb4d6-198c-4e6e-931b-6dc0148c181c.png)

## Prerequisites
- Access your azure subscription with "administrative credentials".
- A Container Registry with an image. If you don't have a container registry with an image check the file **README-createImageForTest.md** (in the repository).

# Installation

## 1. Resource group creation
Create a resource group that will contain all the resources generated 

Sample: 
```console
az group create -l "switzerlandnorth" -n "DEMO"
```
In the sample there's the creation of a resource group named *DEMO* in the region *switzerlandnorth*

The command output is a JSON response like this one
```json
{
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxxxxxxxxxxxxxxx",
  "location": "xxxxxxxxxxxx",
  "managedBy": null,
  "name": "xxxxxxxxxxxxxxxxxxxxxxx",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```
The ID value should be used in the next phase

Reference: https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest

## 2. Service Principal creation
Create a service principal identity, and assign the owner role to the group created in the previous step. 

**Save the statement output in Notepad for use in the next step.**

Sample (use the previuos ID value in the *scopes* parameter)
```console
az ad sp create-for-rbac --name "DEMO" --role owner --scopes /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxxxxxxxxxxxxxxx
```
Reference: https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux

## 3. Azure credentials secret creation
Copy the full output from the previous step inside the GitHub secret key AZURE_CREDENTIALS. You can find AZURE_CREDENTIALS in GitHub `Setting-->Secret-->Actions`

Sample
```json
{
  "clientId": "651ca1e0-XXXX-XXXX-XXXX-aa7c11e10a57",
  "clientSecret": "QOFEWIJFQewfEWFewqFewFewfEWf34_h.pj",
  "subscriptionId": "74LVd6eb-XXXX-XXXX-XXXX-ecec2fm3c22e",
  "tenantId": "72f988bf-XXXX-XXXX-XXXX-2d7cd011db47",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

## 4. Remaining GitHub secrets creation
Create the following GitHub secrets 
- **AZURE_RG** containing the Resource Group Name to be created. This Resource Group will contain all the Azure resources created by this project. To remove all those resources, you can delete this Resource Group
- **AZURE_SUBSCRIPTION** containing the Azure Subscription ID, where the Resource Group will be created
- **GRAFANA_ADMIN_PASSWORD** containing the password to access Grafana .

After that, you will have the following secrets
![image](https://user-images.githubusercontent.com/60384226/166691309-e492dd8c-8bb0-462b-a28d-44e9c5a0df4f.png)

## 5. Customize resources names file
Customize the resources names file `.github\workflows\main.yml`
```
Customize ONLY the value of the following keys: 
  AZUREAPPLICATIONINSIGHTSNAME:   "DEMOApplicationInsights"
  APPNAME:                        "demo"
  KUBERNETESSERVICENAME:          "DEMOKubernetesService"
  AZURELOADTESTINGNAME:           "DEMOAzureLoadTesting"
```
## 6. Subscription resource providers check
**Microsoft.Chaos** and **Microsoft.LoadTestService** resource providers must be registered in the Resource Providers section of the subscription.
Those are the steps to perform the check:
- To be able to register the services you need to go to the Azure portal
- Select the "Subscription" and in the left menu select "Resource Providers"

![image](https://user-images.githubusercontent.com/60384226/165717039-5deec0af-0d8f-42b4-a023-9e6a48232ffd.png)

- Search for "**Microsoft.Chaos**" and check the Status. If it's not *Registered*, proceed with the registration and wait until it's registered.

![image](https://user-images.githubusercontent.com/60384226/165717493-982fdbb9-d3ff-4496-be17-2c6d1052d850.png)

- Search for "**Microsoft.LoadTestService**" and check the Status. If it's not *Registered*, proceed with the registration and wait until it's registered.

![image](https://user-images.githubusercontent.com/60384226/165717225-4396d967-fb16-4c23-b474-d89b5d071f16.png)

## 7. Start the Pipeline

If you have followed all the previous steps you can now start the pipeline, which will create the environment in your Azure resource group.

- First go to the actions section in the GitHub project page.

![Actions](https://user-images.githubusercontent.com/60384226/166692831-25fe6373-d2c6-488d-b532-7f6dc964cef3.png)

- Select CI section.

![image](https://user-images.githubusercontent.com/60384226/166693051-bee41a57-8afe-4582-9605-72c866e9ff5b.png)

- Click on "Run Workflow".

![Cattura](https://user-images.githubusercontent.com/33416347/167612354-072c4295-529d-4cfe-bf04-5bf6e2ef6ca6.PNG)

- Enter the required inputs:
  1. **Set the name of the Container Registry Resource Group** = Set the name of the resource group where the container registry is deployed
  2. **Set Container Registry Name** = Name of container registry that contains the image of the web app to be tested. In the next paragraph it's explained how to get this value
  3. **Set Image Name** = Name of the Image present in the container registry to be tested. In the next paragraph it's explained how to get this value
  4. **Set Image Tag** = The Tag of Image to be tested. In the next paragraph it's explained how to get this value
  5. **Set App Replicas** = Number of instances of the web app to be tested.
  6. **Choice Agent Virtual Machine Size** = Size of the virtual machine that kubernetes will create.

**IMPORTANT** 
- The values **1**, **2** must match the Container Registry values used before, and cannot be changed 
- The value **6** cannot be changed after the first pipeline run. 
- The values **3**, **4** can be changed to test different web apps present in the same Container Registry. 
- The value **5** can be changed to test different load

### **How to set correct values for Container Registry Name, Image Name and Image Tag**
You can find those values in the Container Registry --> Repositories page
![info](https://user-images.githubusercontent.com/33416347/167634453-c8a5740d-a57b-4701-b5e6-0e240d56f44a.png)
- The string labeled 1 is the Container Registry Name
- The string labeled 2 is the Image name
- The string labeled 3 Image tag

- When you have entered all the inputs, click the green button "Run workflow"
- The workflow creates the Azure resources, then deploy 

## 8. Retrieve IP for testing

When the pipeline has reached completed status, you can retrieve the IP address of wour web app to test it.
If you do not know how to retrieve it you need to go to the file: **README-getExternalIP.md** (in the repository) and follow one of two ways.

## 9. Test the Service

Now that you have retrieved the public IP address of the web app, you can load your web app home page at `http://<PUBLIC_IP_ADDRESS>`, and go to `http://<PUBLIC_IP_ADDRESS>/grafana` you can login in Grafana. 

![Grafana](https://user-images.githubusercontent.com/60384226/166918755-9eaaabe9-802e-40cb-b96c-83dd1947ac5b.gif)

The credentials to login are: 
 - **username**: admin 
 - **password**: the one you entered as a secret in step number 4.

----------
# Optional Project Customizations
This project allows several customizations. Keep in mind that some values cannot be changed after the first pipeline run.

## Add more VM families before the first pipeline run
If you want more choice in VM families selection, you can modify the GitHub Workflow YAML file, adding more VM Families to the choice.

Here's how to do it
1. Get all available size for specified location

    Every region has a different list of available VM families. To list all the available families, perform the following command, then copy the name of a vm size with no restrictions
    ```console
    az vm list-skus --location <replace with location> -r virtualMachines --output table
    ```
    ![vmsize family](https://user-images.githubusercontent.com/33416347/167675602-285e3440-c96b-480f-83f0-ab036124273e.PNG)

2. Edit the github workflow
    
    Modify the `.github/workflows/main.yaml` file by adding the new vm after line 57. Write the name in lower case.
    You can modify the file directly in the GitHub web page, or you can clone the repo locally, perform the editing, then push the modified files to the repo as [you can read here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

## Configure your web app
You can change yor web app configuration in the Helm Chart. You have to edit the `src\helloworld-service\user-service-chart\templates\infrastructure.yaml` file, starting from line 114, for example changing resources requests and limits, or adding environment variables to configure your app, or adding some persistent volume claim. You can modify the file directly in the GitHub web page, or you can clone the repo locally, perform the editing, then push the modified files to the repo as [you can read here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

After the editing, yo shoud re-run the pipeline.

## Azure Load Test
Before the first pipeline run, you can change the default load test file, that you can find in `Bicep\ALT\Test1.jmx`. This load test file can be edited with [Apache JMeter](https://jmeter.apache.org/). You can modify the file directly in the GitHub web page, or you can clone the repo locally, perform the editing, then push the modified files to the repo as [you can read here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

After the pipeline first launch, you can perform load testing using the Azure Load Testing resource created, you can find the documentation [at this link](https://docs.microsoft.com/en-us/azure/load-testing/)

## Default Chaos Experiment configuration

The experiment used in the pipeline disables the application pods for some minutes.

Before the first pipeline run, you can change this behavior configuring the json file located in "./Bicep/ACS/parameters.json". 
The configurable value is:
  - duration = Duration in seconds of the experiment
You can modify the file directly in the GitHub web page, or you can clone the repo locally, perform the editing, then push the modified files to the repo as [you can read here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

After the pipeline first launch, you can perform Chaos Engineering running Chaos Experiments as you can see in [this link](https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-run-experiment)


## Create new Chaos experiments

For other experiments you will need to enable some capabilities:

1. Open the Azure portal.
2. Search for Chaos Studio in the search bar.
3. Click on Targets and navigate to your AKS cluster.
4. Click on Manage Actions.

    ![select_target](https://user-images.githubusercontent.com/33416347/167161518-a147d25d-331e-4bd0-b6fe-86f044ef3e64.PNG)
5. Select the desired capabilities and click Save.

    ![enable_capabilities](https://user-images.githubusercontent.com/33416347/167161436-8ade4f7a-1ea6-4196-a3ec-41e5cb2b4491.PNG)

### Create new experiment

1. Search for Chaos Experiments in the search bar.
2. Click "Create" 
3. Select the subscription and resource group
4. In the "Experiment designer" click "Add action"
5. Chose the experiment type

Reference:

https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal

https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-fault-library#aks-chaos-mesh-network-faults

----------

# Other references

https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal#set-up-chaos-mesh-on-your-aks-cluster

https://github.com/Azure/bicep/blob/main/docs/examples/101/aks/main.bicep

https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=bicep

https://github.com/Azure/bicep/blob/main/docs/examples/101/container-registry/main.bicep

https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/2018-05-01-preview/components?tabs=bicep

https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli

https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI#create-workflow

https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/2021-03-01/managedclusters?tabs=bicep#managedclusteridentity

https://docs.microsoft.com/en-us/azure/templates/microsoft.loadtestservice/loadtests?tabs=bicep

https://github.com/marketplace/actions/azure-container-registry-build

https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli#authentication-options

https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests

https://docs.microsoft.com/en-us/cli/azure/acr/credential?view=azure-cli-latest#az-acr-credential-show

https://docs.microsoft.com/en-us/azure/aks/internal-lb#create-an-internal-load-balancer

https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli

https://docs.microsoft.com/en-us/azure/load-testing/tutorial-cicd-github-actions#define-test-passfail-criteria

https://stackoverflow.com/questions/57877200/how-can-i-pass-a-variable-group-in-jmeter-using-azure-pipeline

https://docs.microsoft.com/en-us/azure/load-testing/how-to-parameterize-load-tests
