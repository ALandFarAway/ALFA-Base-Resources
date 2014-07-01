
function Get-NWN2InstallPath
{
	#.SYNOPSIS
	#	Gets the NWN2 install path.
	#.DESCRIPTION
	#	Gets the NWN2 install path from the registry.
	Param()

	try
	{
		$Key = Get-Item -Path "HKLM:\\SOFTWARE\Wow6432Node\Obsidian\NWN 2\Neverwinter"

		$Value = $Key.GetValue("Location")

		if ($Value -eq $Null)
		{
			$Value = $Key.GetValue("Path")
		}

		if ($Value -eq $Null)
		{
			throw "Couldn't find install location."
		}

		return $Value
	}
	catch
	{
		$Key = Get-Item -Path "HKLM:\\SOFTWARE\Obsidian\NWN 2\Neverwinter"

		if ($Value -eq $Null)
		{
			$Value = $Key.GetValue("Path")
		}

		if ($Value -eq $Null)
		{
			throw "Couldn't find install location."
		}

		return $Value
	}
}


function Get-GFF
{
	#.SYNOPSIS
	#	Opens a GFF file.
	#.DESCRIPTION
	#	Opens a GFF file and returns the GFF object.  The caller is responsible for
	#	saving the file again if desired.
	#
	#.PARAMETER Path
	#	Supplies the path to the file to open.
	Param(
		[Parameter(Mandatory=$True)] [string] $Path
	)

	$Gff = $Null

	try
	{
		$Gff = New-Object OEIShared.IO.GFF.GFFFile($Path)
	}
	catch
	{
		$InstallPath = Get-NWN2InstallPath
		[void][System.Reflection.Assembly]::LoadFrom($InstallPath + "\OEIShared.dll")

		$Gff = New-Object OEIShared.IO.GFF.GFFFile($Path)
	}

	return $Gff
}

Export-ModuleMember -Function Get-GFF


