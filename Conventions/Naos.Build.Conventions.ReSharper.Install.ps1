param($installPath, $toolsPath, $package, $project)

$projectFilePath = Split-Path $project.FileName -Parent
$projectFileName = Split-Path $project.FileName -Leaf

$targetFilePath = Join-Path $projectFilePath "$projectFileName.DotSettings"
$sourceFilePath = ''

if ($project.Name.EndsWith('.Test') -or $project.Name.EndsWith('.Tests'))
{
	$sourceFilePath = Join-Path $installPath 'Test.DotSettings'
}
else
{
	$sourceFilePath = Join-Path $installPath 'Release.DotSettings'
}

Write-Output "cp $sourceFilePath $targetFilePath"
cp $sourceFilePath $targetFilePath