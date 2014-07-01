function Ping-NWNServer
{
#.SYNOPSIS
#	Pings a NWN server and returns the elapsed time before a response was
#	received.
#.DESCRIPTION
#	Sends a ping message to a NWN server, recording the start time and end time
#	of the ping response.  The response time is returned to the user.
#
#	Raises an exception if the server does not respond within the given timeout
#	interval.
#.PARAMETER Hostname
#	Supplies the hostname of the server to ping.
#.PARAMETER Port
#	Supplies the data port of the server to ping.
#.PARAMETER Timeout
#	Supplies the maximum interval, in milliseconds, to wait for a response from
#	the server before aborting.
	Param(
		[Parameter(
			Mandatory = $True)]
			[string]$Hostname,
		[Parameter(
			Mandatory = $True)]
			[int]$Port,
		[Parameter(
			Mandatory = $False)]
			[int]$Timeout = 1000
	)

	$StartTime = Get-Date
	$Msg = New-Object byte[] 11

	$Msg[0]  = [char]'B' # Message type (ping)
	$Msg[1]  = [char]'N'
	$Msg[2]  = [char]'L'
	$Msg[3]  = [char]'M'
	$Msg[4]  = 0   # Port
	$Msg[5]  = 0
	$Msg[6]  = 0   # Cookie
	$Msg[7]  = 0   # PingNumber
	$Msg[8]  = 0
	$Msg[9]  = 0
	$Msg[10] = 0

	$ResponseMsg = SendReceiveUDPMessage -Hostname $Hostname -Port $Port -Data $Msg -Timeout $Timeout

	if ($ResponseMsg.Length -lt 4)
	{
		throw "Invalid response message (length too short)."
	}

	if ($ResponseMsg[0] -ne [char]'B' -or $ResponseMsg[1] -ne [char]'N' -or $ResponseMsg[2] -ne [char]'L' -or $ResponseMsg[3] -ne [char]'R')
	{
		throw "Invalid response message (bad header)."
	}

	return (Get-Date) - $StartTime
}

function Get-NWNServerInfo
{
#.SYNOPSIS
#	Queries a NWN server and returns information (such as user count) for the
#	server.
#.DESCRIPTION
#	Sends a query server info message to a NWN server and returns general
#	operating parameters of the server, such as the active player count.
#
#	Raises an exception if the server does not respond within the given timeout
#	interval.
#.PARAMETER Hostname
#	Supplies the hostname of the server to ping.
#.PARAMETER Port
#	Supplies the data port of the server to ping.
#.PARAMETER Timeout
#	Supplies the maximum interval, in milliseconds, to wait for a response from
#	the server before aborting.
	Param(
		[Parameter(
			Mandatory = $True)]
			[string]$Hostname,
		[Parameter(
			Mandatory = $True)]
			[int]$Port,
		[Parameter(
			Mandatory = $False)]
			[int]$Timeout = 1000
	)

	$StartTime = Get-Date
	$Msg = New-Object byte[] 6

	$Msg[0]  = [char]'B' # Message type (server info request)
	$Msg[1]  = [char]'N'
	$Msg[2]  = [char]'X'
	$Msg[3]  = [char]'I'
	$Msg[4]  = 0   # Port
	$Msg[5]  = 0

	$ResponseMsg = SendReceiveUDPMessage -Hostname $Hostname -Port $Port -Data $Msg -Timeout $Timeout

	if ($ResponseMsg.Length -lt 21)
	{
		throw "Invalid response message (length too short)."
	}

	if ($ResponseMsg[0] -ne [char]'B' -or $ResponseMsg[1] -ne [char]'N' -or $ResponseMsg[2] -ne [char]'X' -or $ResponseMsg[3] -ne [char]'R')
	{
		throw "Invalid response message (bad header)."
	}

	$ActivePlayers = [int]$ResponseMsg[0x0A]
	$MaxPlayers = [int]$ResponseMsg[0x0B]
	$ServerInfo = New-Tuple Latency, ((Get-Date) - $StartTime), ActivePlayers, $ActivePlayers, MaxPlayers, $MaxPlayers

	return $ServerInfo
}

function New-Tuple()
{
	param ( [object[]]$list= $(throw "Please specify the list of names and values") )

	$tuple = new-object psobject
	for ( $i= 0 ; $i -lt $list.Length; $i = $i+2)
	{
		$name = [string]($list[$i])
		$value = $list[$i+1]
		$tuple | add-member NoteProperty $name $value
	} 

	return $tuple
} 

Export-ModuleMember -Function Ping-NWNServer, Get-NWNServerInfo

