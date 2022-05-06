param location string = resourceGroup().location
//param targetId string //"/subscriptions/6a37c895-4239-4b1e-bc34-a48c4994cc8a/resourceGroups/rg-poc-demo-performance/providers/Microsoft.ContainerService/managedClusters/demo-performance-aks/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh"
param experimentName string // = 'TestFromBicepWithParamas'
param aksName string // = 'demo-performance-aks'

param experimentConfiguration object

param actionName string // = 'podChaos' //'urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1'

var targetId = '/subscriptions/${ subscription().subscriptionId }/resourceGroups/${ resourceGroup().name }/providers/Microsoft.ContainerService/managedClusters/${ aksName }/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh'

resource experiment 'Microsoft.Chaos/experiments@2021-09-15-preview' = {
  name: experimentName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    selectors: [
      {
        type: 'List'
        id: 'Selector1'
        targets: [
          {
            id: targetId
            type: 'ChaosTarget'
          }
        ]
      }
    ]
    steps: [
      {
        name: 'Step 1'
        branches: [
          {
            name: 'Branch 1'
            actions: [
              {
                type: 'continuous'
                selectorId: 'Selector1'
                duration: 'PT10M'
                parameters: [
                  {
                    key: 'jsonSpec'
                    value: '{"action":"pod-failure","mode":"all","duration":"${experimentConfiguration.duration}","selector":{"namespaces":["${experimentConfiguration.namespace}"]}}'
                  }
                ]
                name: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:${actionName}/2.1'
              }
            ]
          }
        ]
      }
    ]
  }
}

output servicePrincipalId string = experiment.identity.principalId
output experimentName string = experimentName
