<#
.SYNOPSIS 
Will update the repository config.

.DESCRIPTION
Will update the repository config, pulls latest version of update script and runs it.

.PARAMETER RepositoryPath
The path to act on.

.PARAMETER Update
The action switch to update to the latest).

.PARAMETER ThrowOnPendingUpdate
The switch to enable throwing an error if there is a pending update (used for Continuous Integration situations like a build server).

.PARAMETER PreRelease
The switch to enable throwing an error if there is a pending update (used for Continuous Integration situations like a build server).

.EXAMPLE
.\RepoConfig.ps1

.EXAMPLE
.\RepoConfig.ps1 -Update

.EXAMPLE
.\RepoConfig.ps1 -ThrowOnPendingUpdate

#>
param([string] $RepositoryPath, [switch] $Update, [switch] $ThrowOnPendingUpdate, [switch] $PreRelease)

#############################################################################################
#     Setup work                                                                            #
#############################################################################################

# this package id can be updated to use in any project...
$repoConfigPackageId = 'Naos.Build.Conventions.RepoConfig'

if ([string]::IsNullOrWhitespace($RepositoryPath) -or (-not (Test-Path $RepositoryPath))) {
	throw "Must specify a valid RepositoryPath."
}

if ($Update -and $ThrowOnPendingUpdate) {
	throw "Cannot set both Update and ThrowOnPendingUpdate switches, must choose one or the other"
}

$scriptFilePath = ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
$scriptRootPath = Split-Path -Parent $scriptFilePath
$scriptStartTimeUtc = [System.DateTime]::UtcNow
$scriptStartTime = $scriptStartTimeUtc.ToLocalTime()

Write-Output "################################################################################################"
Write-Output "------------------------------------------------------------------------------------------------"
Write-Output "> Starting Script ($(Split-Path $scriptFilePath -Leaf)) at $($scriptStartTime.ToString())"

$alreadyUpToDate = $false
$repoConfigPackageVersion = '1.0.0.0'
$instructionsFilePath = Join-Path $scriptRootPath 'RepoConfigInstructions.ps1'
$tempFilePath = Join-Path $scriptRootPath "WorkingDir-$($scriptStartTime.ToString('yyyyMMdd-HHmmss'))"
$nugetLog = Join-Path $tempFilePath 'NuGet.log'
if (Test-Path $tempFilePath) {
	throw "Test path '$tempFilePath' already exists, this is NOT expected."
}

Write-Output "------------------------------------------------------------------------------------------------"
Write-Output " > Making working directory"
md $tempFilePath | Out-Null
Write-Output " - Created $tempFilePath"
Write-Output " < Making working directory"

$stateFilePath = Join-Path $RepositoryPath 'RepoConfig.state'
if (-not (Test-Path $stateFilePath)) {
	Write-Output "------------------------------------------------------------------------------------------------"
	Write-Output " > No state file found"
	$defaultStateFileContent = ''
	$defaultStateFileContent += "<?xml version=`"1.0`"?>" + [Environment]::NewLine
	$defaultStateFileContent += "<repoConfigState>" + [Environment]::NewLine
	$defaultStateFileContent += "    <version></version>" + [Environment]::NewLine
	$defaultStateFileContent += "    <lastCheckedDateTimeUtc></lastCheckedDateTimeUtc>" + [Environment]::NewLine
	$defaultStateFileContent += "</repoConfigState>"
	$defaultStateFileContent | Out-File $stateFilePath
	Write-Output " - Created $stateFilePath"
	Write-Output " < No state file found"
}
else
{
	Write-Output "------------------------------------------------------------------------------------------------"
	Write-Output " - Target Repository Path: $RepositoryPath"
	Write-Output " - State File Path: $stateFilePath"
}

$stateFilePath = Resolve-Path $stateFilePath
[xml] $stateFileXml = Get-Content $stateFilePath

[scriptblock] $updateState = {
	Write-Output "------------------------------------------------------------------------------------------------"
	Write-Output " > Updating State File"
	$stateFileXml.repoConfigState.lastCheckedDateTimeUtc = $scriptStartTimeUtc.ToString('yyyyMMdd-HHmmssZ')
	$stateFileXml.repoConfigState.version = $repoConfigPackageVersion
	$stateFileXml.Save($stateFilePath)
	Write-Output " - Changed $stateFilePath"
	Write-Output " < Updating State File"
}

[scriptblock] $cleanUp = {
	if (Test-Path $tempFilePath) {
		Write-Output "------------------------------------------------------------------------------------------------"
		Write-Output " > Removing working directory"
		rm $tempFilePath -Recurse
		Write-Output " - Deleted $tempFilePath"
		Write-Output " < Removing working directory"
	}
}

#############################################################################################
#     Download latest package                                                               #
#############################################################################################
Write-Output "------------------------------------------------------------------------------------------------"
Write-Output " > Installing NuGet package"
if ($PreRelease) {
	nuget install $repoConfigPackageId -OutputDirectory $tempFilePath -PreRelease | Out-File $nugetLog 2>&1
}
else{
	nuget install $repoConfigPackageId -OutputDirectory $tempFilePath | Out-File $nugetLog 2>&1
}
Write-Output " - Package: $repoConfigPackageId"
Write-Output " - Location: $tempFilePath"
Write-Output " - Log: $nugetLog"
Write-Output " < Installing NuGet package"

#############################################################################################
#     Check against state version and throw if $ThrowOnPendingUpdate is set and dont match  #
#############################################################################################
$packageFolder = ls $tempFilePath -Filter "$repoConfigPackageId*"
if ($packageFolder -eq $null) {
	throw "Could not retrieve package $repoConfigPackageId or could not find $(Split-Path $instructionsFilePath -Leaf) in package"
}
else {
	$repoConfigPackageVersion = (Split-Path $packageFolder.FullName -Leaf).Replace("$repoConfigPackageId.", '')
	
	$instructionsFilePath = ls $packageFolder.FullName -Filter $(Split-Path $instructionsFilePath -Leaf) -Recurse
	if ($instructionsFilePath -eq $null) {
		throw "Could not find $(Split-Path $instructionsFilePath -Leaf) in $packageFolder"
	}
	
	$instructionsFilePath = $instructionsFilePath.FullName
}

$alreadyUpToDate = $stateFileXml.repoConfigState.version -eq $repoConfigPackageVersion

if ((-not $alreadyUpToDate) -and $ThrowOnPendingUpdate) {
	&$cleanUp
	throw "Installed version of $repoConfigPackageId ($($stateFileXml.repoConfigState.version)) is not the latest ($repoConfigPackageVersion) and the ThrowOnPendingUpdate switch is set"
}

#############################################################################################
#     Run instructions and clean up                                                         #
#############################################################################################

if ($alreadyUpToDate) {
	Write-Output "------------------------------------------------------------------------------------------------"
	Write-Output " - Installed version of $repoConfigPackageId ($repoConfigPackageVersion) is the latest version."
}
elseif ($Update) {
	Write-Output "------------------------------------------------------------------------------------------------"
	Write-Output " > Running specific update instructions from version $repoConfigPackageVersion"
	Write-Output ''
	&$instructionsFilePath -RepositoryPath $RepositoryPath
	Write-Output ''
	Write-Output " - Executed $instructionsFilePath"
	Write-Output " < Running specific update instructions"

	&$updateState
}
else {
	Write-Output "------------------------------------------------------------------------------------------------"
	Write-Output " - Update switch not set so not running instructions"
}

&$cleanUp

Write-Output "------------------------------------------------------------------------------------------------"
Write-Output "< Finishing Script ($(Split-Path $scriptFilePath -Leaf)) at $([System.DateTime]::Now.ToString())"
Write-Output "################################################################################################"
