
#
# General configuration
#

$ReportPeriod   = "INTERVAL 1 DAY"
$ReportMailTo   = "reports@alandfaraway.info"
$ReportMailFrom = "reports@alandfaraway.info"
$ReportSubject  = "ALFA Daily Report"
$ReportSMTPSrv  = "mail.alandfaraway.info"
$InactiveDays   = 21

$Divider        = "--------------------------------------------------------------------------------`n"
$ConnString     = "Server=alfavault;Uid=;Password=;Database="


$Body  = "ALFA Daily Report for " + (Get-Date) + "`n"
$Body += $Divider

$Query      = "SELECT COUNT(*) AS num FROM characters;"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "Total characters: " + $Results.Rows[0].num + ".`n"
}

$Query      = "SELECT COUNT(*) AS num FROM players;"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "Total players: " + $Results.Rows[0].num + ".`n"
}

$Query      = "SELECT COUNT(*) AS num FROM players WHERE players.``LastLogin`` >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL $InactiveDays DAY);"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "Active players: " + $Results.Rows[0].num + ".`n"
}

$Query      = "SELECT COUNT(*) AS num FROM logs WHERE logs.`Date` >= DATE_SUB(CURRENT_TIMESTAMP, " + $ReportPeriod + ");"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "New log entries created: " + $Results.Rows[0].num + ".`n"
}

$Body += "`n"

$Query      = "SELECT DISTINCT "
$Query     +=    "servers.`ID` AS server_id, "
$Query     +=    "servers.`Name` AS server_name, "
$Query     +=    "players.`ID` AS player_id, "
$Query     +=    "players.`Name` AS player_name, "
$Query     +=    "characters.`Name` AS character_name, "
$Query     +=    "characters.`ID` as character_id, "
$Query     +=    "characters.`Level` as character_level, "
$Query     +=    "characters.`XP` as character_exp, "
$Query     +=    "logs.`Description` as transfer_log_message "
$Query     += "FROM logs "
$Query     += "INNER JOIN characters ON characters.`ID` = logs.`CharacterID` "
$Query     += "INNER JOIN players ON players.`ID` = characters.`PlayerID` "
$Query     += "INNER JOIN servers ON servers.`ID` = logs.`ServerID` "
$Query     += "AND logs.`Event` = 'Transition' "
$Query     += "AND logs.`Date` >= DATE_SUB(CURRENT_TIMESTAMP, " + $ReportPeriod + ") "
$Query     += "GROUP BY server_id, player_id, character_id "
$Query     += "ORDER BY server_id, player_id, character_id ASC;"
$Transfers  = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

#
# Carefully query the login event description so that we can isolate whether it
# was a DM (starts with "Dungeon Master") or a player (starts with "Character")
# but not a failed login due to character load failure (starts with "Could").
#

$Query      = "SELECT DISTINCT "
$Query     +=    "servers.`ID` AS server_id, "
$Query     +=    "servers.`Name` AS server_name, "
$Query     +=    "players.`ID` AS player_id, "
$Query     +=    "players.`Name` AS player_name, "
$Query     +=    "characters.`Name` AS character_name, "
$Query     +=    "characters.`ID` as character_id, "
$Query     +=    "characters.`Level` as character_level, "
$Query     +=    "characters.`XP` as character_exp, "
$Query     +=    "characters.`GP` as character_gp, "
$Query     +=    "substring(logs.`Description` FROM 1 FOR 1) as login_message "
$Query     += "FROM logs "
$Query     += "INNER JOIN characters ON characters.`ID` = logs.`CharacterID` "
$Query     += "INNER JOIN players ON players.`ID` = characters.`PlayerID` "
$Query     += "INNER JOIN servers ON servers.`ID` = logs.`ServerID` "
$Query     += "AND logs.`Event` = 'Login' "
$Query     += "AND logs.`Date` >= DATE_SUB(CURRENT_TIMESTAMP, " + $ReportPeriod + ") "
$Query     += "AND NOT substring(logs.`Description` FROM 1 FOR 5) = 'Could' "
$Query     += "GROUP BY server_id, login_message, player_id, character_id "
$Query     += "ORDER BY server_id, login_message, player_id, character_id ASC;"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

$LastServerId = -1

if ($Results.Rows.Count -gt 0)
{
	$Body += "`nUnique character activity:`n"
	$Results | foreach {
		if ($_.server_id -ne $LastServerId)
		{
			$LastServerId = $_.server_id
			$Body += "`nServer " + $_.server_name + " (" + $LastServerId + "):`n"
			$Body += $Divider
		}

		$Body += $_.character_name
		$Body += " ("
		$Body += $_.player_name
		$Body += ")"

#		if ($_.login_message.StartsWith("Dungeon Master: "))
		if ($_.login_message.StartsWith("D"))
		{
			$Body += " [DM]"
		}

		$Body += ", level "
		$Body += $_.character_level
		$Body += " with "
		$Body += $_.character_exp
		$Body += " XP, ";
		$Body += $_.character_gp
		$Body += " GP";

		foreach ($Transfer in $Transfers)
		{
			if ($Transfer.server_id -ne $_.server_id -or $Transfer.character_id -ne $_.character_id) { continue; }

			$Body += " (transfer: ";
			$Body += $Transfer.transfer_log_message;
			$Body += ")";
			break;
		}

		$Body += ".`n";
	}
}
else
{
	$Body += "`nNo character activity this report period.`n"
}

$Body += "`n"

$Query      = "SELECT "
$Query     +=    "players.`ID` AS player_id, "
$Query     +=    "players.`Name` AS player_name "
$Query     += "FROM players "
$Query     += "WHERE players.`FirstLogin` >= DATE_SUB(CURRENT_TIMESTAMP, " + $ReportPeriod + ") "
$Query     += "GROUP BY player_id "
$Query     += "ORDER BY player_id ASC;"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "`nNew players:`n"
	$Body += $Divider

	$Results | foreach {
		$Body += $_.player_name + " (" + $_.player_id + ").`n"
	}
}
else
{
	$Body += "`nNo new players this report period.`n"
}

$Body += "`n"

$Query      = "SELECT "
$Query     +=    "players.`ID` AS player_id, "
$Query     +=    "players.`Name` AS player_name "
$Query     += "FROM players "
$Query     += "WHERE players.`LastLogin` >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL " + $InactiveDays + " DAY) "
$Query     += "AND players.`LastLogin` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL " + ($InactiveDays - 1) + " DAY) "
$Query     += "GROUP BY player_id "
$Query     += "ORDER BY player_id ASC;"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "`nNewly inactive players (last logon = " + $InactiveDays + " days ago):`n"
	$Body += $Divider

	$Results | foreach {
		$Body += $_.player_name + " (" + $_.player_id + ").`n"
	}
}
else
{
	$Body += "`nNo newly inactive players (last logon = " + $InactiveDays + " days ago) this report period.`n"
}

$Body += "`n"

$Query      = "SELECT "
$Query     +=    "logs.`ServerID` AS server_id, "
$Query     +=    "logs.`Description` AS log_description, "
$Query     +=    "logs.`Date` AS log_date, "
$Query     +=    "servers.`Name` AS server_name "
$Query     += "FROM logs "
$Query     += "INNER JOIN servers ON servers.`ID` = logs.`ServerID` "
$Query     += "WHERE logs.`Date` >= DATE_SUB(CURRENT_TIMESTAMP, " + $ReportPeriod + ") "
$Query     += "AND logs.`Event` = 'Server Loaded' "
$Query     += "GROUP BY server_id "
$Query     += "ORDER BY server_id, log_date;"
$Results    = Execute-MySQL-Query -ConnectionString $ConnString -Query $Query

if ($Results.Rows.Count -gt 0)
{
	$Body += "`nServer startup events:`n"
	$Body += $Divider

	$Results | foreach {
		$Body += $_.server_name + " (" + $_.log_date + "): " + $_.log_description + "`n"
	}
}
else
{
	$Body += "`nNo server startup events this report period.`n"
}

Write-Host $Body

Send-MailMessage -To $ReportMailTo -From $ReportMailFrom -Subject $ReportSubject -SmtpServer $ReportSMTPSrv -Body $Body




