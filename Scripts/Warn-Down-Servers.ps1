#
# List the server IDs that correspond to live (productioN) servers here.
# Only these will be alerted upon.
#

#$ServerIdsToCheck = "(3, 9, 10)"
$HeartbeatGracePeriod = "INTERVAL 16 MINUTE"

$ReportMailTo   = "server_down@alandfaraway.info"
$ReportMailFrom = "reports@alandfaraway.info"
$ReportSubject  = "ALFA server down alert"
$ReportSMTPSrv  = "mail.alandfaraway.info"

$ScriptsLibDir = "C:\Scripts\";
$ScriptsModules = @("MySQL-Routines.psm1", "MySQL-ALFA.psm1", "ALFA-Production-Servers.psm1")

foreach ($ModuleName in $ScriptsModules)
{
	$ModuleFullName = $ScriptsLibDir + $ModuleName
	Import-Module $ModuleFullName
}

$ServerIdsToCheck = Get-ALFAServersString

$Query = @"
SELECT
	servers.``Name`` AS server_name,
	pwdata.``Last`` AS last_heartbeat,
	CURRENT_TIMESTAMP AS database_timestamp
FROM
	servers
INNER JOIN pwdata ON pwdata.``Name`` = servers.``Name``
WHERE servers.``Id`` IN $ServerIdsToCheck
AND pwdata.``Key`` = 'ACR_TIME_SERVERTIME'
AND pwdata.``Last`` < DATE_SUB(CURRENT_TIMESTAMP, $HeartbeatGracePeriod)
"@

$Results = ExecuteALFAQueryRO -Query $Query

$ServersDown = 0
$DBTime = ""
$ServersText = ""

foreach ($Row in $Results)
{
	$ServersText += $Row.server_name
	$ServersText += " (last heartbeat: "
	$ServersText += $Row.last_heartbeat
	$ServersText += ").`n"

	$ServersDown += 1
	$DBTime = $Row.database_timestamp
}

if ($ServersDown -ne 0)
{
	$Body  = "Production servers that have not checked in within $HeartbeatGracePeriod as of " + $DBTime + ":`n"
	$Body += "----------------`n"
	$Body += $ServersText
	$ReportSubject += ": $ServersDown servers down"

	Write-Host $ReportSubject
	Write-Host $Body

	Send-MailMessage -To $ReportMailTo -From $ReportMailFrom -Subject $ReportSubject -SmtpServer $ReportSMTPSrv -Body $Body
}

$Message = [String]::Format("Checked server uptime at {0}", (Get-Date))

echo $Message > C:\Status\WarnDownServers.txt

