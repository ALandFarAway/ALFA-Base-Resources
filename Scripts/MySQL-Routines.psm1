Function Execute-MySQL-Query
{
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = '',
			ValueFromPipeline = $true)]
			[string]$Query,
		[Parameter(
			Mandatory = $true,
			ParameterSetName = '',
			ValueFromPipeline = $true)]
			[string]$ConnectionString
		)
	Begin
	{
	}
	Process
	{
		try
		{
			[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
			$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
			$Connection.ConnectionString = $ConnectionString
			[void]$Connection.Open()

			$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
			$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
			$DataSet = New-Object System.Data.DataSet
			$RecordCount = $DataAdapter.Fill($DataSet, "data")

			return , $DataSet.Tables["data"]
		}
#		catch
#		{
#			Write-Host "Query failed: " + $_
#		}
		finally
		{
			[void]$Connection.Close()
		}
	}
	End
	{
	}
}


