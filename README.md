# SQL with AD

### Prerequisite

__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-ad-sql
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/azuredeploy.json --parameters templates/params.json --resource-group automate-ad-sql
```
