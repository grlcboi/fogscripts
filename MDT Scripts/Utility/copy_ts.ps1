﻿#Script variables
$RootDir = 'M:'
$deployment_share = 'MDTFogDeploy'

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name "MDTShare" -PSProvider MDTProvider -Root "$RootDir\$deployment_share"

$ts_infos = @()

Get-ChildItem -Path "MDTShare:\Task Sequences" | % {
    $ts_info = New-Object PSObject -Property @{
        ID = $_.ID
        Name = $_.Name
        Template = $_.TaskSequenceTemplate
    }
    $ts_infos += $ts_info
}
$ts_infos | Format-Table ID, Name, Template

$source_id = Read-Host -Prompt 'Enter task sequence ID to copy'
$destination_id = Read-Host -Prompt 'Enter new task sequence ID'

#$source_id = 'VANILLA-O365BUSINESSRETAIL'
#$destination_id = 'VANILLA-HOMEBUSINESSRETAIL'

$source_ts_xml = [xml]$(Get-Content "$RootDir/$deployment_share/Control/$source_id/ts.xml")

$os_guid = ($source_ts_xml | Select-Xml -XPath "//sequence/globalVarList/variable[@name='OSGUID']").Node.'#text'[0]

$os_xml = [xml]$(Get-Content "$RootDir/$deployment_share/Control/OperatingSystems.xml")

$os_name = $($os_xml | Select-Xml -XPath "//oss/os[@guid='$os_guid']/Name").Node.'#text'

   "MDTShare:\Operating Systems\$os_dir\$os_name" -Path "MDTShare:\Task Sequences" -Version 1.0


Remove-PSDrive MDTShare