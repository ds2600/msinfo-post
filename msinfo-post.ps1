$REQUESTOR = Read-Host -Prompt 'Enter your name:'
$PC_NAME = Read-Host -Prompt 'Enter PC Name:'
Get-Content "C:\msinfo-post\settings.ini" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } } 
$COMP_INFO = Get-ComputerInfo
$UUID = (wmic csproduct get uuid)[2]

$ADDITIONAL_PAR = @{
    uuid = $UUID
    requestor = $REQUESTOR
    pc = $PC_NAME
}

$COMP_INFO | Add-Member $ADDITIONAL_PAR
$BODY = $COMP_INFO | ConvertTo-Json

#Write-Output $BODY
$RESP = Invoke-WebRequest -Method Post -Uri $h.Get_Item("API_URI") -Body $BODY -UseBasicParsing