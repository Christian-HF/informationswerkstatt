param location string = resourceGroup().location
param env string = 'dev'

@description('Storage Account')
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'sthfinfo${env}'
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

@description('App Service Plan')
resource plan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-hf-info-${env}'
  location: location
  sku: { name: 'B1', tier: 'Basic' }
}

@description('Backend App Service')
resource api 'Microsoft.Web/sites@2023-01-01' = {
  name: 'api-hf-info-${env}'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        { name: 'WEBSITE_RUN_FROM_PACKAGE'; value: '1' }
      ]
    }
  }
}

@description('Static Web App (Frontend)')
resource frontend 'Microsoft.Web/staticSites@2022-09-01' = {
  name: 'app-hf-info-frontend-${env}'
  location: location
  sku: { name: 'Standard' }
}

@description('Function App (Crawler)')
resource func 'Microsoft.Web/sites@2023-01-01' = {
  name: 'func-hf-info-crawl-${env}'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        { name: 'FUNCTIONS_EXTENSION_VERSION'; value: '~4' }
        { name: 'FUNCTIONS_WORKER_RUNTIME'; value: 'python' }
      ]
    }
  }
}

@description('Azure SQL Server & DB')
param sqlAdminLogin string = 'hfadmin'
@secure()
param sqlAdminPassword string

resource sql 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'sql-hf-info-${env}'
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
  }
}

resource sqldb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: 'sql-hf-info-db-${env}'
  parent: sql
  properties: {
    sku: { name: 'Basic' }
  }
}

@description('AI Search Service')
resource search 'Microsoft.Search/searchServices@2023-11-01' = {
  name: 'srch-hf-info-${env}'
  location: location
  sku: { name: 'basic' }
  properties: {
    hostingMode: 'default'
    partitionCount: 1
    replicaCount: 1
  }
}

@description('Key Vault')
resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-hf-info-${env}'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { name: 'standard' }
    enabledForDeployment: true
    enabledForTemplateDeployment: true
  }
}

@description('App Insights')
resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-hf-info-${env}'
  location: location
  properties: {
    Application_Type: 'web'
  }
}

output sqlFqdn string = sql.properties.fullyQualifiedDomainName
