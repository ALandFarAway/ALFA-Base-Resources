#.SYNOPSIS
#	Checks for GFFs with bad movement rates.
#.DESCRIPTION
#	Checks for GFFs with bad movement rates.  Bad movements rates are those that
#	are not zero (PC movement).
#
#.PARAMETER Path
#	Supplies the path to search (recursively) for *.bic.
Param(
	[Parameter(Mandatory=$True)] [string] $Path
)

$ScriptsLibDir = "C:\Scripts\";
$ScriptsModules = @("GFF.psm1")

foreach ($ModuleName in $ScriptsModules)
{
	$ModuleFullName = $ScriptsLibDir + $ModuleName
	Import-Module $ModuleFullName
}

foreach ($File in Get-ChildItem -Path $Path -Filter *.bic -Recurse:$True)
{
	try
	{
		$Gff = Get-GFF -Path $File.FullName

		$MovementRate = $Gff.TopLevelStruct.Fields["MovementRate"]

		if ($MovementRate -eq $Null)
		{
			throw "GFF has no MovementRate field."
		}

		if ($MovementRate.ValueByte -eq 0)
		{
			continue
		}

		Write-Host ([System.String]::Format("File {0} has wrong movement rate {1}", $File.FullName, $MovementRate.ValueByte))
	}
	catch
	{
		Write-Host ([System.String]::Format("Failed to process {0}: Exception: ${1}", $File.FullName, $_))
	}
}

