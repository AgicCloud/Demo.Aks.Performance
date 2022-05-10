@description('Name of the log analytics workspace')
param name string //= 'DemoPerformanceLogAnalyticsWorkspace'
param location string //= 'westeurope' //resourceGroup().location

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}
