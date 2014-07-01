Write-Host "Running server instances:`n"
$FoundOne = $false
$Now = (Get-Date)

foreach ($Process in (Get-Process -Name nwn2server))
{
	$Uptime = ($Now - $Process.StartTime)
	$FoundOne = $true
	$Line = [System.String]::Format("Process {0} ({1}): up for {2} hour(s), memory usage {3} MB", $Process.Id, $Process.Name, $Uptime.Hours, $Process.PrivateMemorySize64 / (1024 * 1024))
	Write-Host $Line
}

if ($FoundOne -eq $false)
{
	Write-Host "WARNING:  No server instances were running!`n"
}

Write-Host "<Press any key to exit.>"
[void](Get-Host).UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Exit-PSSession

