Overview
--------

This NWNX4 plugin improves the performance of shared server vault scenarios
that operate on a shared network file system mount point.  With the plugin in
place, character loads and saves from a shared network-mounted server vault
will no longer block the server for the duration of the save or load operation.
In addition, support for retrying failed uploads ro the shared server vault is
included.

As a further improvements, safeguards to prevent corrupted .bics (as can happen
when the server is out of disk space) from being transferred to the central
vault are provided.

The plugin changes the way the server saves and loads characters to effect this
performance improvement.  A new policy for performing character loads and saves
is set into place by the plugin.  The server always performs loads and saves
from a "local" servervault cache, and then the plugin performs background
transfers to and from the "remote" shared servervault as needed.


With the plugin installed, the following happens when a player attempts to view
their character list or log in with a character:

- The message to request the character list or log in is hidden from the server
  and is not processed immediately.  Instead, it is held until the "local"
  servervault cache is up to date.

- Simultaneously, a background worker thread begins to verify the the "local"
  servervault cache is up to date by checking .bic timestamps against the
  "remote" servervault.  If any "local" files are out of date, the "remote"
  files corresponding to them are copied over in the background.

  - If there is a pending character file update in the local "spool"
    directory, the spooled update is used instead of a particular character
    file on the "remote" servervault.

- Because the character list or log in message is held for future processing,
  the server continues to run while the "local" servervault is being brought up
  to date.

- Once the "local" servervault is entirely up to date, the background worker
  thread allows the server to process the previously held character list or
  log in message.  The server then reads the character files from the local
  disk instead of going over the network.


When a player attempts to save their character, the following now happens:

- The character file is written to the "local" servervault cache immediately.
  Because the "local" servervault cache is on the server computer, this does
  not take an extended amount of time.

- Once the character file has been saved, it is placed in a "spool" directory
  that is a clearinghouse for character files that are waiting to be uploaded
  to the "remote" servervault.

- The server continues to run as normal.

- A background worker thread discovers that a new character file is available
  for upload in the "spool" directory.  It begins to copy the character file to
  the "remote" servervault after validating that the character file was a legal
  GFF.  (If the file was malformed, an error is instead logged to the log.)

- Once the character file has been confirmed to be successfully copied to the
  "remote" servervault, the "spool" version of the character file is deleted.


If either of these processes encounter an error, they are periodically retried
in the background.  If the server crashes before it has finished copying the
character file from the "spool" directory to the "remote" servervault, then the
server will resume attempts to copy the character file(s) present in the
"spool" directory on the next startup cycle.


No players are permitted to log in from scratch if the central servervault
mount point is not reachable.  If the central servervault mount point goes
offline while the server is active, already connected players may continue to
play, with their character saves being locally held in the server's "spool"
directory until the central servervault mount point comes back online.


In this design, every server has an up to date backup copy of its local player
base in the form of what nwn2server believes is its servervault directory.

If a character file is removed from the central servervault mount point, then
individual servers do NOT automatically remove their corresponding character
files.  It is recommended that PW admins handle deleting characters via a
script that runs at logon, or by periodically purging the "local" servervault
contents and allowing them to be re-synchronized on demand with the "remote"
central servervault mount point.

Installation
------------

To install the plugin, you will need to do the following:

1) Install the latest xp_bugfix plugin version.  xp_bugfix version 1.0.15 or
   higher is required.  The following link includes the location of the current
   xp_bugfix plugin download link, release notes, and documentation:

http://www.nwnx.org/phpBB2/viewtopic.php?t=1086

2) Ensure that xp_bugfix is configured in "ReplaceNetLayer = 1" mode.  This is
   required.  The above link in step 1) includes documentation to this effect.

3) Place xp_ServerVault.dll from the plugin package into the NWNX4
   installation directory.  This DLL must be placed in the NWNX4 directory.
   Place AuroraServerVault.ini in the NWNX4 directory as well.

4) Choose a path for the character spool directory, such as
   "<userprofile>\Documents\Neverwinter Nights 2\servervaultspool".  Create the
   directory manually.

5) Configure the server's servervault directory to point to the default, local
   location.  It should NOT point to the shared server vault path.

6) Configure the path to the server's servervault directory in
   AuroraServerVault.ini, as LocalServerVaultPath= under [Settings].

7) Configure the path to the shared server vault mount point (drive letter,
   network share, etc.) in AuroraServerVault.ini, as RemoteServerVaultPath=
   under [Settings].  This directory should be laid out in the standard form
   for a servervault directory, with one subdirectory for each player account
   and the associated character .bics inside that directory.

8) Configure the path to the character spool directory in AuroraServerVault.ini
   as SpoolPath= under [Settings].

9) Start the server under NWNX4 and inspect the AuroraServerVault.log log file
   for any errors that indicate a problem with the installation or plugin
   configuration settings.

Server Portal Integration
-------------------------

In order to allow for seamless server portals (ActivatePortal script function),
several steps should be followed:

1) Before calling ActivatePortal, when you are ready to transition a player to
   a remote server, define a DelayCommand continuation function and set up a
   DelayCommand on it.  Then, export (save) the player's character and return
   from the script.

2) The DelayCommand continuation function runs after all pending character
   exports are completed, because character exports run when the server returns
   to the main loop.  However, the continuation function must still check if
   the plugin has finished uploading the current version of the player's
   character to the central server vault.  To verify this, the continuation
   function should call GetBicFileName on the PC object of the player that is
   to be exported, strip the "SERVERVAULT:" prefix out, and then pass the
   resultant string to NWNXGetInt("VAULT", "CHECK SPOOL", <string>, 0 ).

   The function returns TRUE if the character is still present in the spool and
   the server should wait before allowing the portal.  Otherwise, FALSE is
   returned and it is safe to call ActivatePortal.

An example script illustrating these tasks is included in the next section.

Example Server Portal Activation Script
---------------------------------------


const string PORTAL_SERVER_ADDRESS  = "192.168.1.1:5121";
const string PORTAL_SERVER_PASSWORD = "password";
const string PORTAL_SERVER_WAYPOINT = "wp_portal_start_tag";

int
IsCharacterSavedToVault(
	object PC
	)
/*++

Routine Description:

	This routine checks whether a player's character file is awaiting transfer
	to the central vault.

	N.B.  Until the script returns completely, ExportCharacter does not take
	      effect.  Therefore, this function MUST be called as a DelayCommand
	      (or similar) continuation AFTER the server has been allowed to run
	      once the export request has been put in.

Arguments:

	PC - Supplies the object id of the player object to check.  This must be a
	     server vault PC and not a DM.

Return Value:

	The routine returns a Boolean value indicating TRUE if the PC is saved to
	the central vault, else FALSE if the PC's character file is still being
	transferred.

Environment:

	Any, but see note about ExportCharacter.

--*/
{
	string BicFileName = GetBicFileName( PC );

	//
	// Chop off the "SERVERVAULT:\" prefix (13 characters).
	//

	BicFileName = GetSubString(
		BicFileName,
		12,
		GetStringLength( BicFileName ) - 12);

	//
	// Ask the plugin if this character file is still in the spool directory,
	// waiting for remote upload.
	//

	return NWNXGetInt( "SERVERVAULT", "CHECK SPOOL", BicFileName + ".bic", 0 ) == FALSE;
}

void
PollCharacterSaveDone(
	object PC
	)
/*++

Routine Description:

	This DelayCommand continuation routine polls for whether the player's
	character file is transferred to the central vault.  If so, the player is
	portalled seamlessly to the remote server.

Arguments:

	PC - Supplies the object id of the player object to check.  This must be a
	     server vault PC and not a DM.

Return Value:

	None.

Environment:

	DelayCommand continuation only.

--*/
{
	//
	// Check if we are fully saved yet.  If not, schedule another delay
	// continuation and try again then.
	//

	if (IsCharacterSavedToVault( PC ) == FALSE)
	{
		DelayCommand( 1.0f, PollCharacterSaveDone( PC ) );
		SendMessageToPC( PC, "Waiting for character save to complete..." );
		return;
	}

	//
	// The save is finished.  Signal the player client to transition to the new
	// server.
	//

	SendMessageToPC( PC, "Initiating portal transfer..." );
	ActivatePortal(
		PC,
		PORTAL_SERVER_ADDRESS,
		PORTAL_SERVER_PASSWORD,
		PORTAL_SERVER_WAYPOINT,
		TRUE );
}

void
PortalCharacter(
	object PC
	)
/*++

Routine Description:

	This routine is invoked to start the process of portalling a character to a
	remote server.

Arguments:

	PC - Supplies the object id of the player object to portal.  This must be
	     the actual PC and not a possessed familiar or the like.  The
	     GetOwnedCharacter function can be used to find the actual PC object
	     given a possessed object.

Return Value:

	None.

Environment:

	Any.

--*/
{
	//
	// First, check if we have a DM.  DMs do not have server vault character
	// files but are instead always locally managed.  Therefore, they should not
	// attempt to wait for a character save but simply transfer immediately.
	//

	if (GetIsDM( PC ))
	{
		ActivatePortal(
			PC,
			PORTAL_SERVER_ADDRESS,
			PORTAL_SERVER_PASSWORD,
			PORTAL_SERVER_WAYPOINT,
			TRUE );
		return;
	}

	//
	// Otherwise, initiate a character save of the player and start waiting for
	// the save to finish.
	//
	// N.B.  It is critical that the polling for the character save only begins
	//       AFTER the script has completely returned and the server is allowed
	//       to run the main loop.  Otherwise, the export would not have yet
	//       been started.
	//

	SendMessageToPC(
		PC,
		"Saving character and preparing for server portal transfer." );
	ExportSingleCharacter( PC );
	DelayCommand( 1.0f, PollCharacterSaveDone( PC ) );
}



Troubleshooting
---------------

- Examine the AuroraServerVault.log log file to check whether there is a
  problem with the installation or configuration settings.  Common errors such
  as pointing any of the server vault or spool paths to non-existant
  locations result in an error in the log file.

- Detailed tracing of the plugin's runtime activities are written to the log as
  the plugin performs operations.

Source code
-----------

The latest source code is periodically published as a part of the NWN2 Datafile
Accessor Library, which is available here:

http://www.nynaeve.net/Skywing/nwn2/nwn2dev/public_nwn2dev.zip

Release updates for the library are posted here:

http://social.bioware.com/forum/Neverwinter-Nights-2/NwN-2-Tools-and-Plugin-Developers/NWN2-Datafile-Accessor-Library-3116521-1.html

