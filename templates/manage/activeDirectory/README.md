__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name ccit-manage
```

2. __Deploy Active Directory IaaS Template to Resource Group__

```bash
az group deployment create --template-file iaas.json --parameters iaas.params.json --resource-group ccit-manage
```

3. __Activate OMS Monitoring for Active Directory__

```bash
az group deployment create --template-file monitor.json --parameters monitor.params.json --resource-group ccit-manage
```

4. __Activate OMS Monitoring for Active Directory__

```bash
az group deployment create --template-file dsc.json --parameters dsc.params.json --resource-group ccit-manage
```
