# Base Scenario with ACR

## 1. Customize the base-scenario.yml file

Customize the resources names file `.github\workflows\base-scenario.yml`.

In your GitHub repo, go to Code, then browse to `.github\workflows\base-scenario.yml`

![scenario-yml](https://user-images.githubusercontent.com/68650212/174095938-0ac1add3-6e01-4b2c-993b-e59f79a930aa.PNG)

To edit the file, click the `Edit this file` icon.

Then Customize ONLY the value of the following keys, using unique names

```
Customize ONLY the value of the following keys:
  APPNAME:                        "basetestapp"
  KUBERNETESSERVICENAME:          "demo-performance-aks"
  AZURELOADTESTINGNAME:           "demo-performance-alt"
  CAHOSMESHEXPERIMENTNAME:        "ChaosMeshStressFaultsExperiment"
```

Then commit the changes, using the `Commit Changes` green button, using the ` Commit directly to the main branch` option.

| :warning: WARNING                                                                                            |
| :----------------------------------------------------------------------------------------------------------- |
|  The APPNAME value cannot be changed after the first pipeline run.                                           |

| :warning: WARNING                                                                                            |
| :----------------------------------------------------------------------------------------------------------- |
| Please check that your line endings are correctly set, to be sure, try the command "git add --renormalize ." |

## 2. Subscription resource providers check

**Microsoft.Chaos** and **Microsoft.LoadTestService** resource providers must be registered in the Resource Providers section of the subscription.
Those are the steps to perform the check:

- To be able to register the services you need to go to the Azure portal
- Select the "Subscription" and in the left menu select "Resource Providers"

![image](https://user-images.githubusercontent.com/60384226/165717039-5deec0af-0d8f-42b4-a023-9e6a48232ffd.png)

- Search for "**Microsoft.Chaos**" and check the Status. If it's not _Registered_, proceed with the registration and wait until it's registered.

![image](https://user-images.githubusercontent.com/60384226/165717493-982fdbb9-d3ff-4496-be17-2c6d1052d850.png)

- Search for "**Microsoft.LoadTestService**" and check the Status. If it's not _Registered_, proceed with the registration and wait until it's registered.

![image](https://user-images.githubusercontent.com/60384226/165717225-4396d967-fb16-4c23-b474-d89b5d071f16.png)

## 3. Start the Pipeline

If you have followed all the previous steps you can now start the pipeline, which will create the environment in your Azure resource group.

- First go to the actions section in the GitHub project page.

![Actions](https://user-images.githubusercontent.com/60384226/166692831-25fe6373-d2c6-488d-b532-7f6dc964cef3.png)

- Select Base-Scenario-Manual-Deploy section.

![workflow](https://user-images.githubusercontent.com/68650212/174095577-6a6067be-e220-4d15-9426-b463ccac1161.PNG)

- Click on "Run Workflow".

![baserunworkflow](https://user-images.githubusercontent.com/68650212/174095535-327b6f51-a528-414b-af0e-dff146569af9.PNG)

- Enter the required inputs:
  1. **Set the name of the Container Registry Resource Group** = Set the name of the resource group where the container registry is deployed
  2. **Set Container Registry Name** = Name of container registry that contains the image of the web app to be tested. In the next paragraph it's explained how to get this value
  3. **Set Image Name** = Name of the image present in the container registry to be tested. In the next paragraph it's explained how to get this value
  4. **Set Image Tag** = The Tag of the image to be tested. In the next paragraph it's explained how to get this value
  5. **Set the number of app replicas** = The desired number of instances of the web app
  6. **Set the number of nodes** = The desired number of nodes where the application will be deployed
  7. **Choose the kubernetes node VM size** = Size of the virtual machine that kubernetes will create

**IMPORTANT**

- The values **1**, **2** must match an existent Container Registry and should not be changed after the first pipeline run.
- The value **7** cannot be changed after the first pipeline run.
- The values **3**, **4** can be changed to test different web apps present in the same Container Registry.
- The value **5**, **6** can be changed to test different load.

### **How to set correct values for Container Registry Name, Image Name and Image Tag**

You can find those values in the Container Registry --> Repositories page
![info](https://user-images.githubusercontent.com/33416347/167634453-c8a5740d-a57b-4701-b5e6-0e240d56f44a.png)

- The string labeled 1 is the Container Registry Name
- The string labeled 2 is the Image name
- The string labeled 3 Image tag

- When you have entered all the inputs, click the green button "Run workflow"
- The workflow creates the Azure resources, then deploys the apps in the AKS cluster.

> **Important**: When you deploy an Azure Kubernetes Service cluster in Azure, a second resource group gets created for the worker nodes. By default, AKS will name the node resource group `MC_resourcegroupname_clustername_location`, as you can see [in the AKS documentation](https://docs.microsoft.com/en-us/azure/aks/cluster-configuration#custom-resource-group-name). This resource group is managed entirely by Kubernetes, and it will be deleted automatically on cluster deletion.
