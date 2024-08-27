targetScope = 'subscription'

// If an environment is set up (dev, test, prod...), it is used in the application name
param environment string = 'dev'
param applicationName string = 'jhipster-sample-bicep'
param location string = 'centralus'
var instanceNumber = '001'

var defaultTags = {
  environment: environment
  application: applicationName
  'nubesgen-version': '0.17.0'
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${applicationName}-${instanceNumber}'
  location: location
  tags: defaultTags
}

module database 'modules/postgresql/postgresql.bicep' = {
  name: 'sqlDb'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    tags: defaultTags
    instanceNumber: instanceNumber
  }
}

var applicationEnvironmentVariables = [
// You can add your custom environment variables here
      {
        name: 'SPRING_DATASOURCE_URL'
        value: 'jdbc:postgresql://${database.outputs.db_url}'
      }
    {
        name: 'SPRING_DATASOURCE_USERNAME'
        value: database.outputs.db_username
    }
    {
        name: 'SPRING_DATASOURCE_PASSWORD'
        value: database.outputs.db_password
    }
]
