# How to retrieve IP for testing - Azure CLI

## 1. Login to Azure
Sample: 
```console
az login
```
Reference: https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli

## 2. Verify the subscription
Sample: 
```console
az account show -o table
```

## 3. Set correct subscription
Sample: 
```console
az account set -s <replace_with_subscriptionId>
```
Reference: https://docs.microsoft.com/en-us/cli/azure/account?view=azure-cli-latest#az-account-set

## 4. Get credentials from AKS
Sample: 
```console
az aks get-credentials --name <replace_with_aks_name> --resource-group <replace_with_resource_group_name>
```
Reference: https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-get-credentials

## 4. Get ip
Sample: 
```console
kubectl get services --namespace default nginx-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```


# How to retrieve IP for testing - Azure portal

## 1. Login to Azure

## 2. Go to AKS resource

## 3. In the left pane, click to 'Services and ingress'
![services_and_ingresses](https://user-images.githubusercontent.com/33416347/167161720-96936faf-00cf-49aa-8de7-4995c8890aba.png)

## 4. Serch the service named 'nginx-ingress-nginx-controller'
Copy or click to External IP
![get_external_ip](https://user-images.githubusercontent.com/33416347/167161746-049fbacd-bf04-4f8e-9348-1142a2468d88.png)
