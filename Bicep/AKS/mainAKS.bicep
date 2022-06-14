// optional params
param name string
param location string = resourceGroup().location

// mandatory params
param dnsPrefix string = name
param linuxAdminUsername string = 'AdminUser'
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgCdn9pQhSwPGk1jX4oM/Ur/OiF7b1qYBfnBF6ff9epxXcEQSM9msqe1mpy8Yt4iB7sMcmeSG1Lgqal/jJmNW70sS/67fKEQH1gIvFLcL4PU5ZqaJEyMT3MiaPGDZOvuF5szC1FR3VpaonLwdMpYLTjYoYkp4dJ4+xQPpFAc3Vcp76fo1qgE/jvWtSdCcVp9zzNbF3Aw0hfU0fr3qDEGLJOoz7M1bHr4MectMfd4LnxcdPxogw4DPY9gGqQNsWaUsCS+aOibuKGbaOcYS/s0rsZGcyFIi/aHCVB6zIyPRWCOFfFHDcd68gPW9rhrH7Pmm5A2sUQxFR+N+/oXnIwfcxymukHA7lE6aDPJmg2H59VnksQvNPNXmjtyn86BquwP/sBRSd/2oFixk/iT3u1+NzLLVbMxXKFxTioD1KTgQ9eSNU4tjSoSvqdMGAAvjbOyVbDFq1f7jAbEHWJbTi8m7V/hXNHAQCu0rhVTSyJKAqh/lhlpyhn1KFyVBLD8dmWMM='

@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@minValue(1)
@maxValue(50)
param agentCount int

param agentVMSize string

resource aks 'Microsoft.ContainerService/managedClusters@2022-04-01' = {
  name: name
  location: location
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        enableAutoScaling: true
        minCount: 1
        maxCount: agentCount
        count: 1
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
      }
      {
        name: 'apppool'
        osDiskSizeGB: osDiskSizeGB
        enableAutoScaling: true
        minCount: 1
        maxCount: agentCount
        count: 1
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'User'
        type: 'VirtualMachineScaleSets'
        maxPods: 30
        nodeLabels: {
          type: 'user-node'
        }
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
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
output name string = aks.name
output id string = aks.id
output aksPrincipalId string = aks.identity.principalId
