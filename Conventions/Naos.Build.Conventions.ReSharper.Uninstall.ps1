param($installPath, $toolsPath, $package, $project)

$projectFilePath = Split-Path $project.FileName -Parent
$projectFileName = Split-Path $project.FileName -Leaf

$targetFilePath = Join-Path $projectFilePath "$projectFileName.DotSettings"
if (Test-Path $targetFilePath) {
	Write-Output "rm $targetFilePath"
	rm $targetFilePath
}