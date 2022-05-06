## 1. Get all capabilities
Sample: 
```console
az rest --method get --url "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.ContainerService/managedClusters/demo-performance-aks/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh/capabilities/PodChaos-2.1?api-version=2021-09-15-preview"
```

Replace on the experiment.json file, on line 38, the correct subscription and resourse group.