function SendReceiveUDPMessage
{
	Param(
		[Parameter(
			Mandatory = $True)]
			[string]$Hostname,
		[Parameter(
			Mandatory = $True)]
			[int]$Port,
		[Parameter(
			Mandatory = $True)]
			[byte[]]$Data,
		[Parameter(
			Mandatory = $False)]
			[int]$Timeout = 1000
	)

	$Sender = New-Object System.Net.IPEndPoint(0, 0)
	$Client = New-Object System.Net.Sockets.UdpClient($Hostname, $Port)
	[void]$Client.Client.SetSocketOption([System.Net.Sockets.SocketOptionLevel]::Socket, [System.Net.Sockets.SocketOptionName]::ReceiveTimeout, $Timeout)
	[void]$Client.Send($Data, $Data.Length)
	$Client.Receive([ref] $Sender)
}


