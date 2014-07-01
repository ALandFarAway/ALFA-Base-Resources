
#
# General configuraiton
#

$ConnectionString_STAGE_RW = "Server=alfavault;Uid=;Password=;Database="
$ConnectionString_PROD_RW  = "Server=alfavault;Uid=;Password=;Database="
$ConnectionString_PROD_RO  = "Server=alfavault;Uid=;Password=;Database="

Function ExecuteALFAQueryRO
{
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = '',
			ValueFromPipeline = $true)]
			[string]$Query
	)
	Begin
	{
	}
	Process
	{
		$ConnectionString = $ConnectionString_PROD_RO
		Execute-MySQL-Query -Query $Query -ConnectionString $ConnectionString
	}
	End
	{
	}
}

Function ExecuteALFAQueryRW
{
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = '',
			ValueFromPipeline = $true)]
			[string]$Query
	)
	Begin
	{
	}
	Process
	{
		$ConnectionString = $ConnectionString_PROD_RW
		Execute-MySQL-Query -Query $Query -ConnectionString $ConnectionString
	}
	End
	{
	}
}

Function ExecuteALFAQueryStageRW
{
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = '',
			ValueFromPipeline = $true)]
			[string]$Query
	)
	Begin
	{
	}
	Process
	{
		$ConnectionString = $ConnectionString_STAGE_RW
		Execute-MySQL-Query -Query $Query -ConnectionString $ConnectionString
	}
	End
	{
	}
}

Export-ModuleMember -Function ExecuteALFAQueryRO
Export-ModuleMember -Function ExecuteALFAQueryRW
Export-ModuleMember -Function ExecuteALFAQueryStageRW




