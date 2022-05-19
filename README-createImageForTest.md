# How to create an Azure container registry and push the image in there - Azure CLI

**Reference** https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli

## 1. Login to Azure

Sample:

```console
az login
```

## 2. Create Azure container registry

Sample:

```console
az acr create --resource-group <resource-group-name> --name <acr-name> --sku Basic
```
**Reference** https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli

Reference: https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli

## 2. Login to Azure Container Registry

Change "acr-name" with your container registry name.

Sample:

```console
az acr login --name <acr-name>
```

## 3. Pull a public image

This image is an example image.

Sample:

```console
docker pull mcr.microsoft.com/azuredocs/aks-helloworld:v1
```

## 4. Create an alias of the image

Sample:

```console
docker tag mcr.microsoft.com/azuredocs/aks-helloworld:v1 myregistry.azurecr.io/samples/test
```

## 5. Push the image to your registry

Sample:

```console
docker push <acr-name>.azurecr.io/samples/test
```
