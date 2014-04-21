////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_it_persist_i
//    $Revision:: 451        $ current version of the file
//        $Date:: 2007-11-19#$ date the file was created or modified
//       Author : Ronan
//
//  Local Variable Prefix = ACR_PSO
//  Dependencies external of nwscript: None
//
//  Description
//  This script handles all persistent storage used by PCs to store items and
//  gold. All persistent storage should use these scripts, and none other. It
//  also logs and evaluates the contents of persistent storage, and links
//  to the last PCs which have used it.
//
//  Revision History
//  08/11/2006  Cipher  Renamed filename for consistency with existing convention
//  2006/11/15  Cipher  Fixed ACR function references
//  2006/11/20  Cipher  Added database naming interface to allow real time updates
//  2006/11/21  Cipher  Added persistent inventory value and size tracking
//  2006/12/11  Cipher  Added function to save persistent inventory on demand
//  2006/12/12  Cipher  Changed OnClick event handler to OnDisturbed event handler
//  2006/12/15  Cipher  Simplified persistent storage read/write procedure
//  2006/12/16  Cipher  Destroy databases before writing to them to avoid duping items
//  2007/07/01  Cipher  Replaced persistence calls with NWNx4 functions
//  2007/07/21  Cipher  Revised ACR_SQLGetData() calls and fixed initialization
//  2007/07/22  Cipher  Added ACR_GetDatabaseName() function and fixed object persistence
//  2007/07/30  Cipher  Removed "Item_" prefix from database read/writes
//  2007/06/26 AcadiusLost Added ACR_PreLoadStorageObject()
//  2007/10/20 AcadiusLost Commented out error reporting when a storage object is "closed"
//                 while empty- was being reported as a DB write failure erroneously.
//  2007/10/22 AcadiusLost Added value and informative logging on pchest access.
//  2007/11/18 AcadiusLost Commented out leftover DM channel debugging spam
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_IT_PERSIST_I
#define ACR_IT_PERSIST_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! The number of different PCs the system tracks as having accessed each
//! persistent storage object.
const int ACR_PSO_RECORD_USERS = 5;

//! Should the PCs who disturbed the storage object's inventory be saved to the
//! vault when the object is saved?
const int _ACR_PSO_EXPORT_PC_ONSAVE = 1;

//! Should the DMs who disturbed the storage object's inventory be saved to the
//! vault when the object is saved?
const int _ACR_PSO_EXPORT_DM_ONSAVE = 0;

//! Constants representing the desired behavior of the storage if it is
//! destroyed.
const int _ACR_PSO_ON_DEATH_HIDE_ITEMS = 0;
const int _ACR_PSO_ON_DEATH_DROP_ITEMS = 1;

// ADD ME!! Spawn another pStorage object on death, so what is not looted is
// still saved !!

//! The number of backups to maintain, in case of data loss.
const int  _ACR_PSO_NUMBER_OF_BACKUPS = 3;

//! The local variable which contains a string which uniquely identifies a
//! persistent storage object.
const string _ACR_PSO_DATABASE_NAME_LS = "ACR_PSO_NAME";

//! The local variable which contains the number of items in a storage object.
const string _ACR_PSO_NUMBER_OF_ITEMS_LI = "ACR_PSO_NUM_ITEMS";

//! The local variable which contains the total value of the items in a storage object.
const string _ACR_PSO_TOTAL_VALUE_LI = "ACR_PSO_TOTAL_VALUE";

//! The local integer defining the desired behavior when the pChest is destroyed
const string _ACR_PSO_ON_DEATH_BEHAVIOR_LI = "ACR_PSO_ONDEATH";

//! Local integer signifying the number of times object was disturbed since its
//! been opened.
const string _ACR_PSO_DISTURBED_LI = "ACR_PSO_DISTURBED";

//! Local integer which records the amount of gold in the storage object the
//! last time it was closed. We need this because changes to a object's gold
//! do not throw an OnDisturbed event.
const string _ACR_PSO_LASTGP_LI = "_ACR_PSO_GP";

//! The name of the array of items used in the database.
const string _ACR_PSO_ITEM_ARRAY_VARIABLE_NAME = "ACR_PSO_OARRAY";

//! Local array of exportable objects which have disturbed the chest.
const string _ACR_PSO_DISTURBERS_LOA = "ACR_PSO_DISTURBERS_LOA";

//! The local boolean for determining if persistent contents have already been loaded
const string _ACR_PSI_CONTENTS_LOADED = "ACR_PSI_CONTENTS_LOADED";

//! Debug System ID
const string ACR_PSO_DEBUG_ID = "acr_it_persist_i";

//
// Define to 1 to instrment persist item storage.
//

#define INSTRUMENT_STORAGE 1

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct strStorageTransactionInfo {
    int nNetGoldToPC;
    string sPCName;
    string sPlayerName;
    int nNumberOfTransactions;
};

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int _persistentStorageDebugId;

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Initialize the persistent stoage system.
void ACR_InitializePersistentStorage();

//! Initializes the persistent storage counters
void ACR_PersistentStorageOnSpawn(object oStorage);

//! Handles the OnOpen event of a persistent storage object.
void ACR_PersistentStorageOnOpen(object oStorage);

//! Handles the OnClose event of a persistent storage object by oPC.
//! This function saves the contents of the chest and all PCs who have disturbed
//! its inventory. It prints an error message and returns 0 if there is any error
//! during writing. Otherwise it returns 1.
int ACR_PersistentStorageOnClose(object oStorage, object oPC);

//! Handles the OnDisturb event of a persistent storage object.
void ACR_PersistentStorageOnDisturb(object oStorage, object oPC);

//! Handles the OnDeath event of a persistent storage object.
void ACR_PersistentStorageOnDeath(object oStorage);

//! Returns 1 if oObject is a persistent storage object, and 0 otherwise.
int ACR_GetIsPersistentStorageObject(object oObject);

//! Returns the cumulative value of all the items in this storage.
int ACR_GetPersistentStorageValue(object oStorage);

//! Returns the number of items in this storage object, or 0 if oObject is not
//! a persistent storage object.
int ACR_GetNumberOfItemsInStorage(object oStorage);

//! This function serves as an interface for saving the inventory of a persistent object
//!  - oStorage: The persistent storage object
//!  - Returns: TRUE on success, FALSE on failure
int ACR_SavePersistentInventory(object oStorage);

//! Set the database name for a persistent storage object
//!  - oObject: The persistent storage object
//!  - sName: The name of the database
//!  - Returns: Nothing
void ACR_SetDatabaseName(object oStorage, string sName);

//! Retrieves the database name for a persistent storage object
//!  - oObject: The persistent storage object
//!  - Returns: The database name
string ACR_GetDatabaseName(object oStorage);

//! Pre-loads inventory of a container (important when the inventory may be needed by scripts
//!  before it will be "opened", for example a raise dead spell on a corpse that hasn't been 
//!  "opened" since last time it was set down or last mod reset.
int ACR_PreLoadStorageObject(object oStorage);

//! Loads the inventory of persistent storage object oObject.
//! If oTarget is specified, it loads the contents into another object with an
//! inventory. Whatever the target, the inventory of it is DESTROYED, and
//! replaced with the objects stored in the database.
//! Returns the number of items loaded.
int _LoadStorageObjectContents(object oStorage, object oTarget = OBJECT_INVALID);

//! Writes the contents of oObject to the server's local persistent storage.
//! It checks for errors as it goes, and if an error is detected, the entire
//! write is aborted, and the storage object reverts to the old version.
//! Returns 1 on success, 0 on error.
int _WriteStorageObjectContents(object oStorage);

//! Return's 1 if oObject's storage contents have been loaded, or 0 if not.
//! Also returns 0 if oObject is not a persistent storage object.
int _GetAreContentsLoaded(object oStorage);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_array_i"
#include "acr_tools_i"
#include "acr_debug_i"
#include "acr_1984_i"
#include "acr_pps_i"
#include "acr_db_persist_i"
#include "acr_list_i"
#include "acr_server_misc_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_InitializePersistentStorage()
{
    _persistentStorageDebugId = ACR_CreateDebugSystem(ACR_PSO_DEBUG_ID, DEBUG_TARGET_NONE, DEBUG_TARGET_LOG, DEBUG_TARGET_LOG);
}

void ACR_SetDatabaseName(object oStorage, string sName)
{
    SetLocalString(oStorage, _ACR_PSO_DATABASE_NAME_LS, sName);
}

string ACR_GetDatabaseName(object oStorage)
{
    return GetLocalString(oStorage, _ACR_PSO_DATABASE_NAME_LS);
}

void ACR_PersistentStorageOnSpawn(object oStorage)
{
    // initialize the item and value counters on a storage object - until we can
    // determine an apropriate place to call this, the variables must be hardcoded on blueprints
    SetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI, -1);
    SetLocalInt(oStorage, _ACR_PSO_TOTAL_VALUE_LI, -1);
}

void ACR_PersistentStorageOnOpen(object oStorage)
{
    if (!_GetAreContentsLoaded(oStorage)) { 
	    _LoadStorageObjectContents(oStorage); 
		ACR_LogEvent(GetLastOpenedBy(), ACR_LOG_PCHEST_O, "Storage object "+GetName(oStorage)+" (" + GetResRef(oStorage) + ") in "+GetName(GetArea(oStorage))+" contains "+IntToString(GetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI))+" items worth "+IntToString(GetLocalInt(oStorage, _ACR_PSO_TOTAL_VALUE_LI))+" total gp");  
	}

	ACR_IncrementStatistic("PERSISTENT_STORAGE_OPEN");
}

int ACR_PersistentStorageOnClose(object oStorage, object oPC)
{
    // If the chest's contents haven't been altered, we do nothing.
    int nGold = GetGold(oStorage);
    if (!GetLocalInt(oStorage, _ACR_PSO_DISTURBED_LI) && nGold == GetLocalInt(oStorage, _ACR_PSO_LASTGP_LI)) { return 1; }

    // Find every exportable character who has disturbed this object, and export
    // them.
    int i, nDisturbers = GetLocalInt(oStorage, _ACR_PSO_DISTURBED_LI);

    for (i=0; i<nDisturbers; i++)
    {
        object oDisturber = GetLocalArrayObject(oStorage, _ACR_PSO_DISTURBERS_LOA, i);
        ACR_PCExportSingleCharacter(oDisturber);
		
        // Update oStorage's list of transactions?!?
        DeleteLocalArrayObject(oStorage, _ACR_PSO_DISTURBERS_LOA, i);
    }

    // Save the object's inventory
    if (! ACR_SavePersistentInventory(oStorage))
    {
        // Uh oh, there was an error during the write, and the contents were
        // not saved. Tell the PC and print out to the debugging system.
		
		// However, a return of 0 here just means there are no objects to store.
		// This is because it comes from an increment of the number of items stored.
		//  so, we don't need to run this as an error message.
		
        //string sErrorMessage = "Persistent storage object " + GetName(oStorage) + " encountered an error. Contents were NOT saved !!!";
        //SendMessageToPC(oPC, sErrorMessage);
        //ACR_PrintDebugMessage(sErrorMessage, ACR_PSO_DEBUG_ID, DEBUG_LEVEL_FATAL, oStorage);
        //SetLocalInt(oStorage, _ACR_PSO_LASTGP_LI, nGold);
        //return 0;
    }

	// log state and value of chest on closing.
	ACR_LogEvent(GetLastClosedBy(), ACR_LOG_PCHEST_C, GetName(oStorage)+" (" + GetResRef(oStorage) + ") contains "+IntToString(GetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI))+" items worth "+IntToString(GetLocalInt(oStorage, _ACR_PSO_TOTAL_VALUE_LI))+" total gp, accessed by "+IntToString(nDisturbers)+" PCs.");  
	
    SetLocalInt(oStorage, _ACR_PSO_LASTGP_LI, nGold);
    return 1;
}

int ACR_SavePersistentInventory(object oStorage)
{
    return (_WriteStorageObjectContents(oStorage));
}

void ACR_PersistentStorageOnDisturb(object oStorage, object oPC)
{
    if (GetIsPC(oPC))
    {
        int nDisturbers = GetLocalInt(oStorage, _ACR_PSO_DISTURBERS_LOA);
        SetLocalArrayObject(oStorage, _ACR_PSO_DISTURBERS_LOA, nDisturbers, oPC);

        int nDisturbed = GetLocalInt(oStorage, _ACR_PSO_DISTURBED_LI);
        SetLocalInt(oStorage, _ACR_PSO_DISTURBED_LI, nDisturbed + 1);
    }
}

void ACR_PersistentStorageOnDeath(object oStorage)
{
// ADD ME!! Spawn another pStorage object on death, so what is not looted is
// still saved at reset !!
    int nOnDeath = GetLocalInt(oStorage, _ACR_PSO_ON_DEATH_BEHAVIOR_LI);

    if (nOnDeath == _ACR_PSO_ON_DEATH_HIDE_ITEMS)
    {
	    //SendMessageToAllDMs("Should be hiding contents of "+GetName(oStorage));
        DestroyInventory(oStorage);
    }
    else if (nOnDeath == _ACR_PSO_ON_DEATH_DROP_ITEMS)
    {
        if (!_GetAreContentsLoaded(oStorage)) { _LoadStorageObjectContents(oStorage); }
    }
}

int ACR_GetIsPersistentStorageObject(object oObject)
{
    return (GetLocalString(oObject, _ACR_PSO_DATABASE_NAME_LS) != "");
}

int ACR_GetPersistentStorageValue(object oStorage)
{
    // load the contents if they haven't been loaded already
    if (!_GetAreContentsLoaded(oStorage)) { _LoadStorageObjectContents(oStorage); }

    return GetLocalInt(oStorage, _ACR_PSO_TOTAL_VALUE_LI);
}

int ACR_GetNumberOfItemsInStorage(object oStorage)
{
    // load the contents if they haven't been loaded already
    if (!_GetAreContentsLoaded(oStorage)) { _LoadStorageObjectContents(oStorage); }

    return GetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI);
}

int ACR_PreLoadStorageObject(object oStorage) {

    if (!_GetAreContentsLoaded(oStorage)) { 
	    return _LoadStorageObjectContents(oStorage); 
	} 
	return FALSE;
}


int _LoadStorageObjectContents(object oStorage, object oTarget = OBJECT_INVALID)
{
    string sDatabaseName = GetLocalString(oStorage, _ACR_PSO_DATABASE_NAME_LS);
    location locLocation = GetLocation(oStorage);

    object oItem; int nLoaded = 0, nValued = 0;

    if (ACR_GetHasDatabaseStore(sDatabaseName))
    {
        // loop through the objects, add up the item and value counts
        while (GetIsObjectValid(oItem = ACR_GetPersistentObject(oStorage, IntToString(nLoaded), sDatabaseName)))
        {
#if INSTRUMENT_STORAGE
            WriteTimestampedLogEntry("_LoadStorageObjectContents(" + sDatabaseName + "): Loaded object " + GetName(oItem) + " (" + GetTag(oItem) + ").");
#endif
            nLoaded++; nValued += GetGoldPieceValue(oItem);
        }

        WriteTimestampedLogEntry("_LoadStorageObjectContents(" + sDatabaseName + "): Loaded " + IntToString(nLoaded) + " (value " + IntToString(nValued) + ") objects from database store.");
    }
    else	
    {
        // loop through the objects, add up the item and value counts
        while (GetIsObjectValid(oItem = ACR_GetLegacyPersistentObject(oStorage, IntToString(nLoaded), sDatabaseName)))
        {
#if INSTRUMENT_STORAGE
            WriteTimestampedLogEntry("_LoadStorageObjectContents(" + sDatabaseName + "): Loaded object " + GetName(oItem) + " (" + GetTag(oItem) + ").");
#endif
            nLoaded++; nValued += GetGoldPieceValue(oItem);
        }
        WriteTimestampedLogEntry("_LoadStorageObjectContents(" + sDatabaseName + "): Loaded " + IntToString(nLoaded) + " (value " + IntToString(nValued) + ") objects from legacy CodeBase campaign database.");
    }

    // update the item and value counters
    SetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI, nLoaded);
    SetLocalInt(oStorage, _ACR_PSO_TOTAL_VALUE_LI, nValued);
    SetLocalInt(oStorage, _ACR_PSI_CONTENTS_LOADED, 1);

    return nLoaded;
}

int _WriteStorageObjectContents(object oStorage)
{
    string sDatabaseName = GetLocalString(oStorage, _ACR_PSO_DATABASE_NAME_LS);

    // purge the database to avoid duping items
    DestroyCampaignDatabase(sDatabaseName);

    int nStored = 0, nValued = 0, i;
    
    object oItem, oContained;
    
    // loop through inventory
    for (oItem = GetFirstItemInInventory(oStorage); GetIsObjectValid(oItem); oItem = GetNextItemInInventory(oStorage))
    {
        // Create a list of all objects presently held within a container (pack, box, scroll case, etc) to exclude later
        for (oContained = GetFirstItemInInventory(oItem); GetIsObjectValid(oContained); oContained = GetNextItemInInventory(oItem)) {
            i = ACR_ListInsertAfterIndex("pchest", ACR_ListGetFirstIndex("pchest", oStorage), oStorage);
            ACR_ListSetElementObject("pchest", i, oContained, oStorage);
        }
    }

    // loop through inventory second time
    for (oItem = GetFirstItemInInventory(oStorage); GetIsObjectValid(oItem); oItem = GetNextItemInInventory(oStorage))
    {
        // confirm this item shall not be duplicated
        i = ACR_ListGetFirstIndex("pchest", oStorage); 

        do {
            if (oItem == ACR_ListGetElementObject("pchest", i, oStorage)) {
                i = -1;
                break;
            }
            i = ACR_ListGetNextIndex("pchest", i, oStorage);
        }
        while (i != ACR_ListGetFirstIndex("pchest", oStorage));

        // leave and continue with next item
        if (i == -1) {
            // destroy the list, element by element
            ACR_ListRemoveAtElementObject("pchest", oItem, oStorage);
            continue;
        }

        // store the persistent objects
        ACR_SetPersistentObject(oStorage, IntToString(nStored), oItem, sDatabaseName);
        
#if INSTRUMENT_STORAGE
	WriteTimestampedLogEntry("_WriteStorageObjectContents(" + sDatabaseName + "): Saved object " + GetName(oItem) + " (" + GetTag(oItem) + ").");
#endif

        // tally up the total item count and gold piece value
        nStored++; nValued += GetGoldPieceValue(oItem);

        //SendMessageToAllDMs("Valuing "+GetName(oItem)+" from "+GetName(oStorage));
    }

    WriteTimestampedLogEntry("_WriteStorageObjectContents(" + sDatabaseName + "): Saved " + IntToString(nStored) + " (value " + IntToString(nValued) + ") objects to database store.");
    //SendMessageToAllDMs("Total value: "+IntToString(nValued)+" gp, from "+IntToString(nStored)+" objects.");
	
    // update the item and value counters
    SetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI, nStored);
    SetLocalInt(oStorage, _ACR_PSO_TOTAL_VALUE_LI, nValued);
    SetLocalInt(oStorage, _ACR_PSI_CONTENTS_LOADED, 1);

    // purge all remaining items - do this when/if database persistence is functioning
    //int i=nStored; while (GetIsObjectValid(ACR_GetPersistentObject(oStorage, IntToString(i)))) { i++; }
    
    ACR_DeleteDatabaseStoreAtIndex(sDatabaseName, nStored);

    return nStored;
}

int _GetAreContentsLoaded(object oStorage)
{
    //return (GetLocalInt(oStorage, _ACR_PSO_NUMBER_OF_ITEMS_LI) >= 0) ? TRUE : FALSE;
	return GetLocalInt(oStorage, _ACR_PSI_CONTENTS_LOADED);
}

#endif
