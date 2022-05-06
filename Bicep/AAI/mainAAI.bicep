param name string //= 'DemoPerformaceApplicationInsights'
param location string //= 'westeurope'

resource symbolicname 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: name
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  kind: 'string'
  properties: {
    Application_Type: 'web'
    DisableIpMasking: true
    Flow_Type: 'Bluefield'
    HockeyAppId: 'string'
    ImmediatePurgeDataOn30Days: true
    IngestionMode: 'ApplicationInsightsWithDiagnosticSettings'
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    Request_Source: 'rest'
    RetentionInDays: 30
    SamplingPercentage: 50
  }
}
