#!/usr/bin/env pwsh
#Requires -Version 6
#Requires -Modules Microsoft.PowerShell.Utility

using namespace System;
using namespace System.Runtime.InteropServices;

Set-StrictMode -Version 'Latest';

Import-Module 'Microsoft.PowerShell.Utility';


Push-Location -Path '~/Developer/Blackbaud' | Out-Null;

[bool] $vstsCli = (Get-Command -CommandType Application -Name '*vsts*' -All) -as [bool];



if (!($vstsCli)) {
    try {
        if ([RuntimeInformation]::IsOSPlatform([OSPlatform]::OSX)) {
            brew install vsts-cli;
        } elseif ([RuntimeInformation]::IsOSPlatform([OSPlatform]::Linux)) {
            Invoke-WebRequest -Method Get -Uri 'https://aka.ms/install-vsts-cli' | bash;
        } elseif ([RuntimeInformation]::IsOSPlatform([OSPlatform]::Windows)) {
            choco install vsts-cli;
        }
    } catch {
        Write-Warning -Message 'Failed to automatically install vsts-cli. Please install manually.';
    }
}

[array] $repositories = (vsts code repo list --output json | ConvertFrom-Json) | Select-Object -Property @('name', 'remoteUrl') | Where-Object { ($_.name -like 'blackbaud-iaas*') -or ($_.name -like 'iom*') };

foreach ($repo in $repositories) {
    git clone $repo.remoteUrl;
}

Pop-Location;
<#
 2895  az devops configure --defaults organization=https://dev.azure.com/blackbaud --detect true
 2896  az devops configure --defaults organization=https://dev.azure.com/blackbaud
 2897  az repos list --output table
 2898  az devops configure --defaults project=Products
 2899  az repos list --output table
 2900  az repos list --output json
 #>
