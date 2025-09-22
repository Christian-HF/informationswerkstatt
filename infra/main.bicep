param location string = resourceGroup().location
@allowed([
  'dev'
  'stg'
  'prd'
])
param env string = 'dev'

//
// HINWEIS
// - Storage wurde hier NICHT neu angelegt (du hast bereits rginformationswerksa411).
// - Function App im App Service Plan ist tricky (Linux/Settings). Wir aktivieren sie später separat.
//   Jetzt erstmal: Static Web App (Frontend), App Service Plan (Linux) + leere API-WebApp, SQL, Search, Key Vault, App Insights.
//

@description('Linux App Service Plan (B1)')
resource plan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-hf-info-${env}'
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    capacity: 1
  }
  properties: {
    reserved: true // Linux
  }
}

@description('Backend App Service (leer, Linux)')
resource api 'Microsoft.Web/sites@2023-01-01' = {
  name: 'api-hf-info-${env}'
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts' // kann später auf .NET/Java geändert werden
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
    httpsOnly: true
  }
}

@description('Static Web App (Frontend)')
resource frontend 'Microsoft.Web/staticSites@2022-09-01' = {
  name: 'app-hf-info-frontend-${env}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    repositoryUrl: '' // Deployment via GitHub Action/Token
  }
}

@description('Azure SQL Server')
param sqlAdminLogin string = 'hfadmin'
@secure()
param sqlAdminPassword string

resource sql 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'sql-hf-info-${env}'
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

@description('Azure SQL Database (Basic)')
resource sqldb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: 'sql-hf-info-db-${env}'
  parent: sql
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  properties: {
    readScale: 'Disabled'
    autoPauseDelay: 0
    zoneRedundant: false
  }
}

@description('Azure AI Search (Basic)')
resource search 'Microsoft.Search/searchServices@2023-11-01' = {
  name: 'srch-hf-info-${env}'
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    hostingMode: 'default'
    partitionCount: 1
    replicaCount: 1
    publicNetworkAccess: 'enabled'
  }
}

@description('Key Vault')
resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-hf-info-${env}'
  location: location
  properties: {
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
    sku: {
      name: 'standard'
      family: 'A'
    }
    publicNetworkAccess: 'Enabled'
    softDeleteRetentionInDays: 7
  }
}

@description('Application Insights')
resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-hf-info-${env}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'rest'
  }
}

output sqlFqdn string = sql.properties.fullyQualifiedDomainName
output apiAppUrl string = 'https://${api.properties.defaultHostName}'
output swaResourceName string = frontend.name
