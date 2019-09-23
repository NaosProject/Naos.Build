param($installPath, $toolsPath, $package, $project)

$projectFilePath = Split-Path $project.FileName -Parent
$analyzersFilesBasePath = Join-Path (Split-Path -Path $toolsPath -Parent) "analyzers"

$styleCopDotJsonBasePath = Join-Path $analyzersFilesBasePath "stylecop.json"
$caDictionaryBasePath = Join-Path $analyzersFilesBasePath "dictionary.xml"
$releaseRulesetBasePath = Join-Path $analyzersFilesBasePath "release.ruleset"
$testRulesetBasePath = Join-Path $analyzersFilesBasePath "test.ruleset"
$justificationsBasePath = Join-Path $analyzersFilesBasePath "Justifications.cs"

$justificationsFileContents = Get-Content $justificationsBasePath
$justificationsFileContents = $justificationsFileContents.Replace('NAMESPACETOKEN', $project.Name)
$justificationsFileContents | Out-File $justificationsBasePath

$project.ProjectItems.AddFolder(".analyzers") | Out-Null
$folder = $project.ProjectItems.Item(".analyzers")

$folder.ProjectItems.AddFromFileCopy($styleCopDotJsonBasePath) | Out-Null
$folder.ProjectItems.AddFromFileCopy($caDictionaryBasePath) | Out-Null
$folder.ProjectItems.AddFromFileCopy($justificationsFileContents) | Out-Null

# Fix up stylecop.json file (voodoo magic courtesy of StingyJack - https://github.com/dotnet/roslyn/issues/4655)
$item = $folder.ProjectItems.Item("$(Split-Path $styleCopDotJsonBasePath -Leaf)")
$item.Properties.Item("BuildAction").Value = 4  

if ($project.Name.EndsWith('.Test') -or $project.Name.EndsWith('.Tests'))
{
	# add the test version
	$folder.ProjectItems.AddFromFileCopy($testRulesetBasePath) | Out-Null
}
else
{
	# add the release version
	$folder.ProjectItems.AddFromFileCopy($releaseRulesetBasePath) | Out-Null
}