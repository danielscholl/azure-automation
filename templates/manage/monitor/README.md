__Manual Deployment Instructions__

1. __Apply OMS Monitor to ActiveDirectory

```bash
az group create --location southcentralus --name ccit-manage
```

2. __Apply OMS Monitor to JumpServer__

```bash
az group deployment create --template-file azuredeploy.json --parameters params.json --resource-group ccit-manage
```
