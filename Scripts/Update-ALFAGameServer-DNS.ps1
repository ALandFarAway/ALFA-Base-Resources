#.SYNOPSIS
#	Updates ALFA game server dynamic DNS records on the local DNS server.
#.DESCRIPTION
#	Updates ALFA game server dynamic DNS records on the local DNS server.
#	are not zero (PC movement).
#

$ScriptsLibDir = "C:\Scripts\";
$ScriptsModules = @("MySQL-Routines.psm1", "MySQL-ALFA.psm1")

foreach ($ModuleName in $ScriptsModules)
{
	$ModuleFullName = $ScriptsLibDir + $ModuleName
	Import-Module $ModuleFullName
}

$ZoneName = "dynamic.alandfaraway.org"
$RecordSuffix = "nwn2gs"

$Query = @"
SELECT
	servers.``ID`` AS server_id,
	servers.``IPAddress`` as server_ipaddress
FROM
	servers
"@

# Fetch list of servers from the database.
$Results = ExecuteALFAQueryRO -Query $Query

foreach ($Row in $Results)
{
	$ServerID = $Row.server_id
	$ServerIP = $Row.server_ipaddress

	# Chop off the port number.
	$Index = $ServerIP.IndexOf(':')
	if ($Index -ne -1)
	{
		$ServerIP = $ServerIP.Substring(0, $Index)
	}

	# Check if the DNS record for this server already exists.
	$Record = Get-DnsServerResourceRecord -ZoneName $ZoneName -RRType "A" -Name "$ServerID.$RecordSuffix"

	if ($Record -eq $Null -or $Record.State -eq "Failed")
	{
		# New server - create the first record.
		$Record = Add-DnsServerResourceRecord -ZoneName $ZoneName -A -Name "$ServerID.$RecordSuffix" -IPv4Address "$ServerIP"
	}
	else
	{
		# Existing server - update the existing record content.
		$NewRecord = $Record.Clone()
		$NewRecord.RecordData.IPv4Address = $ServerIP
		Set-DnsServerResourceRecord -ZoneName $ZoneName -OldInputObject $Record -NewInputObject $NewRecord
	}
}
