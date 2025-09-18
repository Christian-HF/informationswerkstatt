# Infrastruktur (Bicep)

- `main.bicep` stellt Storage, App Services, Static Web App, Function App, Azure SQL, Azure AI Search,
  Key Vault und Application Insights bereit.
- Parameter:
  - `env`: Umgebung (`dev`/`test`/`prod`)
  - `sqlAdminLogin`: Admin-Loginname (Default `hfadmin`)
  - `sqlAdminPassword`: **secure** (Secret, nicht commiten)

## Beispiel-Deployment (Azure CLI)
```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
az group create -n rg_informationswerkstatt -l westeurope

az deployment group create \
  --resource-group rg_informationswerkstatt \
  --template-file infra/main.bicep \
  --parameters env=dev sqlAdminPassword="<SICHERES_PASSWORT>"
```
