param($installPath, $toolsPath, $package, $project)

$analyzersFilesBasePath = Join-Path (Split-Path -Path $toolsPath -Parent) "analyzers"

$styleCopDotJsonBasePath = Join-Path $analyzersFilesBasePath "stylecop.json"
$caDictionaryBasePath = Join-Path $analyzersFilesBasePath "dictionary.xml"
$releaseRulesetBasePath = Join-Path $analyzersFilesBasePath "release.ruleset"
$testRulesetBasePath = Join-Path $analyzersFilesBasePath "test.ruleset"

$analyzersFolder = $project.ProjectItems | ?{$_.Name.Contains('.analyzers')}
if ($analyzersFolder -ne $null) {
	$analyzersFolder.Delete() | Out-Null
}

$diskFolder = Join-Path (Split-Path -Path $project.FileName -Parent) '.analyzers'
if (Test-Path $diskFolder) {
	$resolved = Resolve-Path $diskFolder
	Remove-Item $resolved -Recurse
}
