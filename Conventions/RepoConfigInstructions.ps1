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

Write-Output ""
Write-Output ""

$slnFileName = (ls $RepositoryPath -Filter *.sln).FullName
$slnDotSettingsSourceFilePath = Join-Path $scriptRootPath 'Solution.DotSettings'
$slnDotSettingsTargetFilePath = $slnFileName + '.DotSettings'

Write-Output "    > Updating Solution DotSettings"
cp $slnDotSettingsSourceFilePath $slnDotSettingsTargetFilePath -Force
Write-Output "    - Copied File (cp)"
Write-Output "    - Source: $slnDotSettingsSourceFilePath"
Write-Output "    - Target: $slnDotSettingsTargetFilePath"
Write-Output "    < Updating Solution DotSettings"
