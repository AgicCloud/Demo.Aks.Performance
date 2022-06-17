# Advanced Scenario
## Customize the advanced-scenario.yml file

Customize the resources names file `.github\workflows\advanced-scenario.yml`.

In your GitHub repo, go to Code, then browse to `.github\workflows\advanced-scenario.yml`

![scenario-yml](https://user-images.githubusercontent.com/68650212/174091933-de581c35-f765-410c-b11d-746fd2508c34.PNG)

To edit the file, click the `Edit this file` icon.

Then Customize ONLY the value of the following keys, using unique names

```
Customize ONLY the value of the following keys:
  APPNAME:                        "demo"
  KUBERNETESSERVICENAME:          "DEMOKubernetesService"
  AZURELOADTESTINGNAME:           "DEMOAzureLoadTesting"
  CAHOSMESHEXPERIMENTNAME:        "ChaosMeshPodFaultsExperiment"
```

Then commit the changes, using the `Commit Changes` green button, using the ` Commit directly to the main branch` option.

| :warning: WARNING                                                                                            |
| :----------------------------------------------------------------------------------------------------------- |
|  The APPNAME value cannot be changed after the first pipeline run.                                           |

| :warning: WARNING                                                                                            |
| :----------------------------------------------------------------------------------------------------------- |
| Please check that your line endings are correctly set, to be sure, try the command "git add --renormalize ." |

## Subscription resource providers check

**Microsoft.Chaos** and **Microsoft.LoadTestService** resource providers must be registered in the Resource Providers section of the subscription.
Those are the steps to perform the check:

- To be able to register the services you need to go to the Azure portal
- Select the "Subscription" and in the left menu select "Resource Providers"

![image](https://user-images.githubusercontent.com/60384226/165717039-5deec0af-0d8f-42b4-a023-9e6a48232ffd.png)

- Search for "**Microsoft.Chaos**" and check the Status. If it's not _Registered_, proceed with the registration and wait until it's registered.

![image](https://user-images.githubusercontent.com/60384226/165717493-982fdbb9-d3ff-4496-be17-2c6d1052d850.png)

- Search for "**Microsoft.LoadTestService**" and check the Status. If it's not _Registered_, proceed with the registration and wait until it's registered.

![image](https://user-images.githubusercontent.com/60384226/165717225-4396d967-fb16-4c23-b474-d89b5d071f16.png)

## Start the Pipeline

If you have followed all the previous steps you can now start the pipeline, which will create the environment in your Azure resource group.

- First go to the actions section in the GitHub project page.

![Actions](https://user-images.githubusercontent.com/60384226/166692831-25fe6373-d2c6-488d-b532-7f6dc964cef3.png)

- Select Advanced-Scenario-Manual-Deploy section.

![workflow](https://user-images.githubusercontent.com/68650212/174091766-0dad557b-3ae9-41ed-9a9d-360cc714950b.PNG)

- Click on "Run Workflow".

![runworkflow](https://user-images.githubusercontent.com/68650212/174092406-fca597e9-6bb6-40b2-827a-32f0923565cb.PNG)

- Enter the required inputs:
  1. **Set the number of nodes** = The desired number of nodes where the application will be deployed
  2. **Choose the kubernetes node VM size** = Size of the virtual machine that kubernetes will create

**IMPORTANT**

- The value **1** can be changed to test different load.
- The value **2** cannot be changed after the first pipeline run.

> **Important**: When you deploy an Azure Kubernetes Service cluster in Azure, a second resource group gets created for the worker nodes. By default, AKS will name the node resource group `MC_resourcegroupname_clustername_location`, as you can see [in the AKS documentation](https://docs.microsoft.com/en-us/azure/aks/cluster-configuration#custom-resource-group-name). This resource group is managed entirely by Kubernetes, and it will be deleted automatically on cluster deletion.

---

# Optional Project Customizations

This project allows several customizations. Keep in mind that some values cannot be changed after the first pipeline run.

## Configure your web app

You can change yor web app configuration in the Helm Chart. You have to edit files in the path: `.src/advanced-scenario/helm`, or if you do not have a helm chart but one or more k8s files, insert them in the folder `.src/advanced-scenario/helm/templates`. You can modify or add the files directly in the GitHub web page, or you can clone the repo locally, perform the editing, then push the modified files to the repo as [you can read here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

After the editing, yo shoud re-run the pipeline.

## Azure Load Testing

Before the first pipeline run, you can change the default load test file, that you can find in `Bicep\ALT\advanced-scenario\Test1.jmx`. This load test file can be edited with [Apache JMeter](https://jmeter.apache.org/). You can modify the file directly in the GitHub web page, or you can clone the repo locally, perform the editing, then push the modified files to the repo as [you can read here](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

After the pipeline first launch, you can perform load testing using the Azure Load Testing resource created, you can find the documentation [at this link](https://docs.microsoft.com/en-us/azure/load-testing/)

| :warning: WARNING                                                                                            |
| :----------------------------------------------------------------------------------------------------------- |
|  Changing the namespace or by not specifying the nodeselector of the type of the deployment node, you could end up deploying on the master node or you might not be able to successfully apply your chaos experiment to your application pods. https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-chaos-experiments                                  
 |

| :warning: WARNING                                                                                            |
| :----------------------------------------------------------------------------------------------------------- |
| Please check that you have sufficient permissions to see the load test results |
If you see an error like this one:
![image](https://user-images.githubusercontent.com/85103736/170235711-8c13b1f9-f31b-4787-8950-739261b525b5.png)
You can solve it by going in the Access Control blade of your Azure Load Testing detail and assigning yourself one of these roles:
![image](https://user-images.githubusercontent.com/8000532/170243532-97bc1dba-aec8-40b0-8cf3-6472124cc51e.png)


## Default Chaos Experiment configuration

The experiment used in the pipeline causes a very high CPU usage in your app pods for some minutes.

Before the first pipeline run, you can change this behaviour configuring the json file located in "./Bicep/ACS/parameters.json".
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

---