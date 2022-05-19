param name string
param location string

resource loadTesting 'Microsoft.LoadTestService/loadTests@2021-12-01-preview' = {
  name: name
  location: location
  tags: {
    DemoPerformance: 'Azure Load Testing'
  }
  identity: {
    type: 'SystemAssigned'
  }
}
