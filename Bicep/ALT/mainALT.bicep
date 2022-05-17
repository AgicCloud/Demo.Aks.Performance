param name string //= 'DemoPerformanceLoadTesting'
param location string //= 'northeurope'

resource symbolicname 'Microsoft.LoadTestService/loadTests@2021-12-01-preview' = {
  name: name
  location: location
  tags: {
    DemoPerformance: 'Azure Load Testing'
  }
  identity: {
    type: 'SystemAssigned'
  }
  // properties: {
  //   description: 'string'
  // }
}
