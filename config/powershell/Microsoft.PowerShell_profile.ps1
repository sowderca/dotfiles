#!/usr/bin/env pwsh
#Requires -Version 5.0
#Requires -Modules PSReadline, posh-git

using namespace System;
using namespace System.Management.Automation;

Set-StrictMode -Version 'Latest';

Import-Module 'PSReadline';
Import-Module 'posh-git';

Set-PSReadlineOption -BellStyle 'None';
Set-PSReadlineOption -EditMode 'Vi';
Set-PSReadlineOption -ExtraPromptLineCount 1;
Set-PSReadlineOption -ViModeIndicator 'Prompt';
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete;

if ($null -eq (Get-Variable -Name 'Is*')) {
    [bool] $script:IsLinux   = (Get-Variable -Name IsLinux -ErrorAction Ignore) -and $IsLinux;
    [bool] $script:IsMacOS   = (Get-Variable -Name IsMacOS -ErrorAction Ignore) -and $IsMacOS;
    [bool] $script:IsWindows = (-not (Get-Variable -Name IsWindows -ErrorAction Ignore)) -or $IsWindows;
    [bool] $script:IsCoreCLR = $PSVersionTable.ContainsKey('PSEdition') -and $PSVersionTable.PSEdition -eq 'Core';
}

[char] $promptIndicator = 0x276F;
[string] $corpAccount = "cameron.sowder@blackbaud.me";
$GitPromptSettings.AfterStatus.Text = $null;
$GitPromptSettings.BeforeStatus.Text = $null;
$GitPromptSettings.BranchColor.ForegroundColor = 0x585858;
$GitPromptSettings.BranchIdenticalStatusSymbol.Text = $null;
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "$([Environment]::NewLine)";
$GitPromptSettings.DefaultPromptPath.Text = $null;
$GitPromptSettings.DefaultPromptPrefix.Text = ' ';
$GitPromptSettings.DefaultPromptSuffix = "$($promptIndicator) ";
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = 0xD3869B;
$GitPromptSettings.DefaultPromptWriteStatusFirst = $true

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$($wordToComplete)" | ForEach-Object {
            [CompletionResult]::new($_, $_, 'ParameterValue', $_);
        }
};

function Invoke-VimOnNT {
    $rep = $args -replace "\\","/";
    bash -c "vim $rep";
};

if ($IsLinux -or $IsMacOS) {
    Set-Alias -Name "vim" -Value "nvim" -Description "Use Neovim instead of vim on non-Windows platforms";
    if ($IsMacOS) {
        [SecureString] $script:pat = ConvertTo-SecureString "$(security find-generic-password -l 'ps-pat' -w)" -AsPlainText -Force;
        [PSCredential] $global:blkb = [PSCredential]::new($corpAccount, $script:pat);
    }
} else {
    if ($IsWindows -and $IsCoreCLR) {
        Add-WindowsPSModulePath;
    } else {
        [void] [Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
        [Windows.Security.Credentials.PasswordVault] $vault = New-Object Windows.Security.Credentials.PasswordVault;
        $account = $vault.Retrieve('ps-pat', $corpAccount);
        [SecureString] $script:pat = ConvertTo-SecureString $account.Password -AsPlainText -Force;
        [PSCredential] $global:blkb = [PSCredential]::new($account.UserName, $script:pat);
    }
    Remove-Item -Path "Alias:/curl" -Force | Out-Null;
    Set-Alias -Name "vim" -Value Invoke-VimOnNT -Description "Use WSL for vim on Windows";
}

function prompt {
    & $GitPromptScriptBlock;
}

