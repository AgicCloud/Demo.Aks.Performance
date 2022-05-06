// optional params
param name string //= 'DemoPerformanceAKSCluster'
//param applicationGateway string //= 'DemoPerformanceAKSCluster'
param location string = resourceGroup().location

// mandatory params
param dnsPrefix string = name
param linuxAdminUsername string = 'AdminUser'
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgCdn9pQhSwPGk1jX4oM/Ur/OiF7b1qYBfnBF6ff9epxXcEQSM9msqe1mpy8Yt4iB7sMcmeSG1Lgqal/jJmNW70sS/67fKEQH1gIvFLcL4PU5ZqaJEyMT3MiaPGDZOvuF5szC1FR3VpaonLwdMpYLTjYoYkp4dJ4+xQPpFAc3Vcp76fo1qgE/jvWtSdCcVp9zzNbF3Aw0hfU0fr3qDEGLJOoz7M1bHr4MectMfd4LnxcdPxogw4DPY9gGqQNsWaUsCS+aOibuKGbaOcYS/s0rsZGcyFIi/aHCVB6zIyPRWCOFfFHDcd68gPW9rhrH7Pmm5A2sUQxFR+N+/oXnIwfcxymukHA7lE6aDPJmg2H59VnksQvNPNXmjtyn86BquwP/sBRSd/2oFixk/iT3u1+NzLLVbMxXKFxTioD1KTgQ9eSNU4tjSoSvqdMGAAvjbOyVbDFq1f7jAbEHWJbTi8m7V/hXNHAQCu0rhVTSyJKAqh/lhlpyhn1KFyVBLD8dmWMM='
// param servicePrincipalClientId string 

// @secure()
// param servicePrincipalClientSecret string


@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@minValue(1)
@maxValue(50)
param agentCount int = 3

param agentVMSize string //= 'Standard_DS2_v2'
// osType was a defaultValue with only one allowedValue, which seems strange?, could be a good TTK test

resource aks 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: name
  location: location
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
    // addonProfiles: {
    //     ingressApplicationGateway: {
    //       enabled: true
    //       config: {
    //         applicationGatewayId: applicationGateway
    //       }
    //     }
    // }
    // servicePrincipalProfile: {
    //   clientId: servicePrincipalClientId
    //   secret: servicePrincipalClientSecret
    // }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
output name string = aks.name
output id string = aks.id
