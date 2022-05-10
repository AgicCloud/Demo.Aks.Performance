@minLength(5)
@maxLength(50)
@description('Name of the azure container registry (must be globally unique)')
param name string // ='DemoPerformanceContainerRegistry2'

@description('Enable an admin user that has push/pull permission to the registry.')
param acrAdminUserEnabled bool = true

@description('Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Tier of your Azure Container Registry.')
param acrSku string = 'Basic'

// azure container registry
resource acr 'Microsoft.ContainerRegistry/registries@2019-12-01-preview' = {
  name: name
  location: location
  tags: {
    displayName: 'Container Registry'
    'container.registry': name
  }
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

output acrLoginServer string = acr.properties.loginServer

