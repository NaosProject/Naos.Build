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
$sourceFile = 'Release'
if ($slnFileName.EndsWith('.Test') -or $slnFileName.EndsWith('.Tests'))
{
    $sourceFile = 'Test'
}

$slnDotSettingsSourceFilePath = Join-Path $scriptRootPath "$sourceFile.DotSettings"
$slnDotSettingsTargetFilePath = $slnFileName + '.DotSettings'

Write-Output "    > Updating Solution DotSettings"
$existingFilePresent = Test-Path $slnDotSettingsTargetFilePath
if ($existingFilePresent)
{
    [xml] $oldContentsXml = Get-Content $slnDotSettingsTargetFilePath
    [xml] $newContentsXml = Get-Content $slnDotSettingsSourceFilePath

    $nodesThatDoNotNeedToBePreserved = $newContentsXml.ChildNodes[1].ChildNodes | ?{($_.Key -ne $null) -and ($_.Key.StartsWith('/Default/UserDictionary/Words/'))}    
    if ($nodesThatDoNotNeedToBePreserved -eq $null)
    {
        $nodesThatDoNotNeedToBePreserved = New-Object 'System.Collections.Generic.List[String]'
    }
    
    $nodesToEvaluateForPreservation = $oldContentsXml.ChildNodes[1].ChildNodes | ?{($_.Key -ne $null) -and ($_.Key.StartsWith('/Default/UserDictionary/Words/'))}

    if ($nodesToEvaluateForPreservation -eq $null)
    {
        $nodesForPreservation = New-Object 'System.Collections.Generic.List[String]'
    }
    
    $separatorComment = $newContentsXml.CreateComment(" Preserved customizations are after this comment (do not edit above as it will make diffs more difficult. ")
    $newContentsXml.DocumentElement.AppendChild($separatorComment)
    
    $nodesForPreservation = $nodesToEvaluateForPreservation | ?{($_ -ne $null) -and (-not $nodesThatDoNotNeedToBePreserved.Contains($_))}
    $nodesForPreservation | %{
        $newNode = $newContentsXml.ImportNode($_, $true)
        $newContentsXml.DocumentElement.AppendChild($newNode)
    }
    
    # $settings = New-Object System.Xml.XmlWriterSettings
    # $settings.Indent = $true
    # $writer = [System.Xml.XmlWriter]::Create($slnDotSettingsTargetFilePath, $settings);
    # $newContentsXml.Save($writer);
    $newContentsXml.Save($slnDotSettingsTargetFilePath)
    
    # Cannot figure out how to do this correctly so hacking for newline's and spacing after appending the imported nodes for preservation...
    $newContentsXmlSavedRaw = Get-Content $slnDotSettingsTargetFilePath
    $newContentsXmlSavedTreated = $newContentsXmlSavedRaw.Replace('><', ">`n<")
    $newContentsXmlSavedTreated = $newContentsXmlSavedTreated.Replace("`n<s", "`n	<s")
    $newContentsXmlSavedTreated = $newContentsXmlSavedTreated.Replace("<!-- Pres", "`n	<!-- Pres")
    $newContentsXmlSavedTreated | Out-File $slnDotSettingsTargetFilePath -Force
    
    Write-Output "    - Found Existing File (merged source into target)"
    Write-Output "    - Source: $slnDotSettingsSourceFilePath"
    Write-Output "    - Target: $slnDotSettingsTargetFilePath"
}
else
{
    cp $slnDotSettingsSourceFilePath $slnDotSettingsTargetFilePath -Force

    Write-Output "    - Copied File (cp)"
    Write-Output "    - Source: $slnDotSettingsSourceFilePath"
    Write-Output "    - Target: $slnDotSettingsTargetFilePath"
}

Write-Output "    < Updating Solution DotSettings"
