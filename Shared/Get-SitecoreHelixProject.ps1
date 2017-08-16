<#
.SYNOPSIS
Gets the paths to project files and allows filtering based on Helix solution layer.

.PARAMETER SolutionRootPath
The absolute or relative solution root path.

.PARAMETER HelixLayer
The Helix layer in which to search for projects. Defaults to $Null, which includes all layers.

.PARAMETER IncludeFilter
Specifies which files do include in the search. Defaults to "*.csproj".

.PARAMETER ExcludeFilter
Specifies which files do exclude in the search. Defaults to "*test*", to exclude test projects.

.EXAMPLE
Get-SitecoreHelixProject -SolutionRootPath "C:\Path\To\MySolution" -HelixLayer Foundation
Get all projects in the "Foundation" layer.

#>
Function Get-SitecoreHelixProject {
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $False)]
        [string]$SolutionRootPath,
		
        [Parameter(Position = 1, Mandatory = $False)]
        [ValidateSet('Project', 'Feature', 'Foundation')]
        [string]$HelixLayer = $Null,
		
        [Parameter(Position = 2, Mandatory = $False)]
        [string]$IncludeFilter = "*.csproj",
		
        [Parameter(Position = 3, Mandatory = $False)]
        [string]$ExcludeFilter = "*test*"
    )
	
    if ([string]::IsNullOrEmpty($SolutionRootPath)) {
        Write-Verbose "`$SolutionRootPath is null or empty. Using current working directory '$PWD'."
        $SolutionRootPath = $PWD;
    }
	
    if ([string]::IsNullOrEmpty($HelixLayer)) {
        Write-Verbose "Searching for projects matching '$IncludeFilter' in all layers ('$SolutionRootPath'), excluding '$ExcludeFilter'."
    }
    else {
        $SolutionRootPath = [System.IO.Path]::Combine($SolutionRootPath, "src", $HelixLayer)
        Write-Verbose "Searching for projects matching '$IncludeFilter' in layer '$HelixLayer' ('$SolutionRootPath'), excluding '$ExcludeFilter'."
    }

    Get-ChildItem -Path "$SolutionRootPath" -Recurse -File -Include $IncludeFilter -Exclude $ExcludeFilter | Select-Object -ExpandProperty "FullName"
}