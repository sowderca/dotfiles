#!/usr/bin/env pwsh
#Requires -Version 7

using namespace System;

Set-StrictMode -Version 'Latest';

&dotnet tool list --global | Select-Object -Skip 2 | ForEach-Object {
    &dotnet tool update --global ($_ -split " ", 2)[0]
};
