#!/usr/bin/env pwsh
#Requires -Version 7

using namespace System;
using namespace System.Collections.Generic;
using namespace System.Management.Automation;

Set-StrictMode -Version 'Latest';

[ApplicationInfo[]] $exes = Get-Command -CommandType Application;

if ($exes.Name -notcontains 'dotnet') {
    exit 0;
}

$tools = &dotnet tool list --global --format=json | ConvertFrom-Json;

[List[string]] $commonTools = @(
    'dotnet-ef',
    'dotnet-sos',
    'dotnet-repl',
    'dotnet-dump',
    'dotnet-debug',
    'dotnet-trace',
    'dotnet-stack',
    'dotnet-gcdump',
    'dotnet-format',
    'dotnet-symbol',
    'dotnet-monitor',
    'dotnet-counters',
    'dotnet-outdated',
    'dotnet-coverage',
    'dotnet-dsrouter',
    'dotnet-debugger-extensions',

    # Extras
    'ilspycmd',
    'aspire.cli'
);

if ($IsMacOS) {
    # Only supported on Windows and Linux.
    [void] $commonTools.Remove('dotnet-debug');
}

$commonTools | ForEach-Object {
    if ($_ -notin $tools.data.packageId) {
        &dotnet tool install --global $_;
    }
};

&dotnet tool list --global | Select-Object -Skip 2 | ForEach-Object {
    &dotnet tool update --global ($_ -split " ", 2)[0]
};
