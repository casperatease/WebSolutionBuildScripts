#requires -RunAsAdministrator
param (
    [Parameter(Mandatory = $true)]
    [SecureString]$PersonalAccessToken
)

$ErrorActionPreference = "Stop"
Import-Module "PowerShellGet" -Force
Import-Module "PackageManagement" -Force

# The username is irrelevant for VSTS authorization - only the PAT is used.
$credentials = New-Object System.Management.Automation.PSCredential ("<irrelevant>", $PersonalAccessToken)

# Register Pentia's PowerShell module feed
$powerShellFeed = "https://pentia.pkgs.visualstudio.com/_packaging/powershell-pentia/nuget/v2"
$repository = Get-PSRepository | Where-Object { $_.SourceLocation -eq $powerShellFeed }
if ($repository) {
    Write-Host "Pentia VSTS PowerShell feed already registered as '$($repository.Name)'."
    $repositoryName = $repository.Name
}
else {
    $repositoryName = "Pentia VSTS PowerShell"
    Register-PSRepository -Name $repositoryName -PublishLocation $powerShellFeed -SourceLocation $powerShellFeed -InstallationPolicy "Trusted" -Credential $credentials -PackageManagementProvider NuGet -Verbose
}

# Install the latest version of the build scripts
Install-Module -Name "Pentia.Publish-WebSolution" -Repository $repositoryName -Credential $credentials -Scope CurrentUser -Force
Write-Host "Done."
