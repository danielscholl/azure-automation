__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name ccit-manage
```

3. __Ensure the Required Secrets exist in KeyStore__

- adminPassword
- adminUserName
- diagStorageKey
- dscPullServerKey
- omsId
- omsKey

2. __Deploy Complete Solution to Resource Group__

```bash
az group deployment create --template-file azuredeploy.json --parameters params.json --resource-group ccit-manage
```

