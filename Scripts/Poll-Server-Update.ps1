Import-Module .\Sockets.psm1
Import-Module .\NWNServerCommunicator.psm1

function UpdateInstanceMonitor
{
	Clear-Host
	Get-Date
	Write-Host "Running server instances monitor (press CTRL-C to exit):`n"
	$FoundOne = $false
	$Now = (Get-Date)

	foreach ($Process in (Get-Process -Name nwn2server))
	{
		#
		# Get start time from WMI if we didn't have access to do it directly.
		#

		if ($Process.StartTime -eq $null)
		{
			$WMIProcess = Get-WMIObject Win32_Process -Filter "ProcessId = $($Process.Id)"

			if ($WMIProcess -eq $null) { continue }

			$Uptime = ($Now - ([WMI]'').ConvertToDateTime($WMIProcess.CreationDate))
		}
		else
		{
			$Uptime = ($Now - $Process.StartTime)
		}

		$FoundOne = $true
		$Line = [System.String]::Format("Process {0} ({1}): up for {2}d {3}h {4}m {5}s, memory usage {6} MB", $Process.Id, $Process.Name, $Uptime.Days, $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds, ([int64]($Process.PrivateMemorySize64 / (1024 * 1024))).ToString("D"))

		if ($Process.Responding -eq $False)
		{
			$Line += " *** PROCESS IS NOT RESPONDING ***"
		}

		Write-Host $Line
	}

	if ($FoundOne -eq $false)
	{
		Write-Host "WARNING:  No server instances were running!`n"
	}

	try
	{
		$ServerInfo = Get-NWNServerInfo -Hostname "127.0.0.1" -Port 5121

		$Line = [System.String]::Format("Server response time: {0} milliseconds, {1}/{2} players", $ServerInfo.Latency.TotalMilliseconds, $ServerInfo.ActivePlayers, $ServerInfo.MaxPlayers)
		Write-Host $Line
	}
	catch
	{
		Write-Host "WARNING: Server did not respond to ping!"
	}
}

for (;;)
{
	UpdateInstanceMonitor
	Sleep -Milliseconds 1000
}



