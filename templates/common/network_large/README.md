__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name ccit-common
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file azuredeploy.json --parameters params.json --resource-group ccit-common
```
