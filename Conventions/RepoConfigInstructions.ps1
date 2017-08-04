param([string] $RepositoryPath)

$scriptFilePath = ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
$scriptRootPath = Split-Path -Parent $scriptFilePath
$targetFilePath = Join-Path $scriptRootPath '..\..\'
$gitIgnoreSourceFilePath = Join-Path $scriptRootPath 'Default.gitignore'
$gitIgnoreTargetFilePath = Join-Path $RepositoryPath '.gitignore'

Write-Output "    > Updating .gitignore"
cp $gitIgnoreSourceFilePath $gitIgnoreTargetFilePath -Force
Write-Output "    - Copied File (cp)"
Write-Output "    - Source: $gitIgnoreSourceFilePath"
Write-Output "    - Target: $gitIgnoreTargetFilePath"
Write-Output "    < Updating .gitignore"
