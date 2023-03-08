@description('Name of the Log Analytics workspace used by Microsoft Sentinel.')
param logAnalyticsWorkspaceName string = 'aw-sentineltest'

// Reference the existing Log Analytics workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

// Deploy the codeless data connector to the Log Analytics workspace
resource codelessConnector 'Microsoft.SecurityInsights/dataConnectors@2021-09-01-preview' = {
    scope: workspace
    name: guid(resourceGroup().id, 'Sentinel Codeless Connector Demonstration')
    kind: 'APIPolling'
    properties: {
        connectorUiConfig: {
    title: 'Sentinel Codeless Connector Demonstration'
    publisher: 'Plain Concepts'
    descriptionMarkdown: 'This Codeless Connector demonstrates a Way to move Log-Data into Microsoft Sentinel.'
    availability: {
        isPreview: true
        status: '1'
    }
    graphQueriesTableName: 'LogDataForSentinelByPolling_CL'
    graphQueries: [
        {
            baseQuery: '{{graphQueriesTableName}}'
            legend: 'All Log Data'
            metricName: 'Total data recieved'
        }
    ]
    dataTypes: [
        {
            lastDataReceivedQuery: '{{graphQueriesTableName}}\n| where Name_s contains "Peter"'
            name: '{{graphQueriesTableName}}'
        }
    ]
    connectivityCriteria: [
        {
            type: 'SentinelKindsV2'
        }
    ]
    permissions: {
        resourceProvider: [
            {
                permissionsDisplayText: 'Read and Write permissions on the Log Analytics workspace are required to enable the data connector'
                provider: 'Microsoft.OperationalInsights/workspaces'
                providerDisplayName: 'Workspace'
                requiredPermissions: {
                    delete: true
                    read: true
                    write: true
                }
                scope: 'Workspace'
            }
        ]
    }
    instructionSteps: [
        {
            title: 'Setup Instructions'
            description: 'Here additional Parameters can be entered, e.g. an Endpoint to target.'
            instructions: [
                {
                    type: 'BasicAuth'
                    parameters: {
                        enable: true
                        userRequestPlaceHoldersInput: [
                            {
                                displayText: 'Domain name'
                                requestObjectKey: 'apiEndpoint'
                                placeHolderName: '{{domain}}'
                                placeHolderValue: ''
                            }
                        ]
                    }
                }
            ]
        }
    ]
    sampleQueries: [
        {
            description: 'List all Logs and sort them by Activity'
            query: '{{graphQueriesTableName}}\n| sort by Activity_s'
        }
    ]
}
        pollingConfig: {
    auth: {
        authType: 'Basic'
    }
    request: {
        apiEndpoint: 'https://{{domain}}/WeatherForecast/Log'
        headers: {
            accept: 'application/json'
        }
        httpMethod: 'Get'
        startTimeAttributeName: 'from'
        endTimeAttributeName: 'to'
        queryTimeFormat: 'yyyy-MM-ddTHH:mm:ssZ'
        queryWindowInMin: 60
        rateLimitQps: 5
    }
    response: {
        eventsJsonPaths: [
            '$'
        ]
    }
}
    }
}
