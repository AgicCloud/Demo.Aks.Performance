param location string = resourceGroup().location

param experimentName string
param aksName string

param experimentConfiguration object

param actionName string

var targetId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ContainerService/managedClusters/${aksName}/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh'

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
                duration: 'PT30S'
                parameters: [
                  {
                    key: 'jsonSpec'
                    value: '{"action":"pod-failure","mode":"one","duration":"${experimentConfiguration.duration}","selector":{"namespaces":["${experimentConfiguration.namespace}"]}}'
                  }
                ]
                name: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:${actionName}/2.1'
              }
              {
                type: 'delay'
                duration: 'PT1M'
                name: 'urn:csci:microsoft:chaosStudio:TimedDelay/1.0'
              }
              {
                type: 'continuous'
                selectorId: 'Selector1'
                duration: 'PT30S'
                parameters: [
                  {
                    key: 'jsonSpec'
                    value: '{"action":"pod-failure","mode":"one","duration":"${experimentConfiguration.duration}","selector":{"namespaces":["${experimentConfiguration.namespace}"]}}'
                  }
                ]
                name: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:${actionName}/2.1'
              }
              {
                type: 'delay'
                duration: 'PT1M'
                name: 'urn:csci:microsoft:chaosStudio:TimedDelay/1.0'
              }
              {
                type: 'continuous'
                selectorId: 'Selector1'
                duration: 'PT30S'
                parameters: [
                  {
                    key: 'jsonSpec'
                    value: '{"action":"pod-failure","mode":"one","duration":"${experimentConfiguration.duration}","selector":{"namespaces":["${experimentConfiguration.namespace}"]}}'
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
