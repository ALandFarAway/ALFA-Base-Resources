//::///////////////////////////////////////////////////////////////////////////
//::
//::	ginc_henchman
//::
//::	Common functions and definitions used in:
//::			ga_henchman_add
//::			ga_henchman_remove
//::			ga_henchman_replace
//::			ga_henchman_setmax
//::			gc_henchman_getmax
//::
//::	As well as some functions that may be helpful elsewhere
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/28/06
// ChazM 1/30/06 - added ginc_event_handlers, modified HenchmanAdd(), HenchmanRemove()
// ChazM 3/8/06 - added DestroyHenchman(),DestroyAllHenchmen(), DestroyAllHenchmenInParty()
// ChazM 2/14/07 - HenchmanAdd() on override will update onRested event script
// ChazM 2/21/07 - Modified HenchmanAdd()

//void main() {}

#include "ginc_event_handlers"

//===============================================================================General Purpose Section:

//Prototypes:
int GetNumHenchmen(object oMaster);	//returns the number of henchman oMaster currently has
int GetIsHenchman(object oMaster, object oHench); //checks to see if oHench is a henchman of oMaster

//Function definitions

//Returns the number of henchmen that oMaster has.
int GetNumHenchmen(object oMaster)
{
	int nLoop, nCount=0;
	for (nLoop=1; nLoop<=GetMaxHenchmen()+3; nLoop++)
   	{
   		if (GetIsObjectValid(GetHenchman(oMaster, nLoop)))
      	nCount+=1;
   	}
	return nCount;
}

/*
int GetNumHenchmen(object oMaster=OBJECT_SELF)
{
	int i = 1;
	object oHenchman = GetHenchman(oMaster, i);

	while (GetIsObjectValid(oHenchman))
	{
		i++;
		//PrettyDebug ("GetNumHenchmen() - found: " + GetName(oHenchman));
		oHenchman = GetHenchman(oMaster, i);
	}
	i = i-1;

	//PrettyDebug ("GetNumHenchmen() - Total found = " + IntToString(i));
	return (i);
}
*/

//Checks to see if a creature is a henchman of another.
// parameters:  checks to see if oHench is a henchman of oMaster
// returns 1 if oHench is a henchman, 0 if not.
int GetIsHenchman(object oMaster, object oHench)
{
    int nMaxHench = GetMaxHenchmen()+6; //just in case a few have been forced
	int i;
	for (i=1;i<nMaxHench;i+=1)				//look for henchman in master's army
		if (oHench==GetHenchman(oMaster,i))
			return 1;
    return 0;
}





//===============================================================================ga_henchman_* related section

const string sStoreScript_Prefix = "STORE_SCRIPT_";
const string sScriptsStored      = "STORE_SCRIPT_TRUE";
const string sMasterRef          = "MY_MASTER_IS";


int HenchmanAdd(object oMaster, object oHench, int bForce=0, int bOverrideBehavior=0);//Wrapper function for AddHenchman that adds some functionality
int HenchmanRemove(object oMaster, object oHench);//Wrapper function for RemoveHenchman that supports added funcitonality of HenchmanAdd()


//Function definitions


//Wrapper function for AddHenchman that adds some extra functionality.
//oHench is added as a henchman of oMaster.
//  - bForce - if set, this will temporarily up the max henchman to allow the henchman in the party (is immediately set back to what it was).
//  - bOverrideBehavior - if set, oHench's event handling scripts will be replaced with some stock henchman ones to get some easy default henchman behavior
//Return Value: 1 on success, 0 on error
// notes - returns 0 if there is no room in party to add henchman, though this is not technically an error
int HenchmanAdd(object oMaster, object oHench, int bForce=0, int bOverrideBehavior=0)
{
	int nMax=GetMaxHenchmen();
	int nCur=GetNumHenchmen(oMaster);

	if (bForce) //if we're forcing the henchman in..
	{
		if (nCur>=nMax)
		{
			SetMaxHenchmen(nCur+1);		
			AddHenchman(oMaster,oHench);
			SetMaxHenchmen(nMax);
		}
		else
			AddHenchman(oMaster,oHench);
	}
	else if (nCur<nMax)
			AddHenchman(oMaster,oHench);
		else
			return 0;			//don't do anything further if there is no more room for henchmen.

	SetLocalObject(oHench,sMasterRef,oMaster);	//store for ease of later removal

	if (bOverrideBehavior)
	{
		SetLocalInt(oHench,sScriptsStored,1);//remember that we want to restore the event handlers on henchman leaving the party
		//I want to put this in a for loop so bad it aches.
		//Storing the creatures scripts so that they can be replaced when the henchman is removed.
/*
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_HEARTBEAT),GetEventHandler(oHench,CREATURE_SCRIPT_ON_HEARTBEAT));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_NOTICE),GetEventHandler(oHench,CREATURE_SCRIPT_ON_NOTICE));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_SPELLCASTAT),GetEventHandler(oHench,CREATURE_SCRIPT_ON_SPELLCASTAT));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_MELEE_ATTACKED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_MELEE_ATTACKED));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DAMAGED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DAMAGED));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DISTURBED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DISTURBED));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_END_COMBATROUND),GetEventHandler(oHench,CREATURE_SCRIPT_ON_END_COMBATROUND));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DIALOGUE),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DIALOGUE));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_SPAWN_IN),GetEventHandler(oHench,CREATURE_SCRIPT_ON_SPAWN_IN));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_RESTED),GetEventHandler(oHench,CREATURE_SCRIPT_ON_RESTED));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DEATH),GetEventHandler(oHench,CREATURE_SCRIPT_ON_DEATH));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_USER_DEFINED_EVENT),GetEventHandler(oHench,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT));
		SetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR),GetEventHandler(oHench,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR));
	*/
		SaveEventHandlers(oHench);
        SetAssociateEventHandlers(oHench);
    /*        
		//Putting in some henchman event handlers.	
		//could also try the x0_ch_hen scripts
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_HEARTBEAT,        "x0_hen_heartbeat");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_NOTICE,           "x0_hen_percep");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPELLCASTAT,      "x2_hen_spell");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_MELEE_ATTACKED,   "x0_hen_attack");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DAMAGED,          "x0_hen_damaged");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DISTURBED,        "x0_hen_disturbed");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_END_COMBATROUND,  "x0_hen_combat");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DIALOGUE,         "x0_hen_conv");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPAWN_IN,         "x0_hen_spawn");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_RESTED,           "nw_ch_aca");
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DEATH,            "x2_hen_death");
//		SetEventHandler(oHench,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT,"");
//		SetEventHandler(oHench,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,"");
    */
		//ExecuteScript("x0_hen_spawn",oHench);
		ExecuteScript(SCRIPT_ASSOC_SPAWN, oHench);
	}
	return 1;
}


//Wrapper function for RemoveHenchman(). Supports added functionality of HenchmanAdd()
// Parameters:
//		-oHench is no longer a Henchman of oMaster
// Return value:
//		1 on success, 0 on failure
int HenchmanRemove(object oMaster, object oHench)
{
	RemoveHenchman(oMaster,oHench);
	DeleteLocalObject(oHench,sMasterRef);

	int nScriptsReplaced=GetLocalInt(oHench,sScriptsStored); //see if we stored the creature's original script set

	if (nScriptsReplaced)
	{
		DeleteLocalInt(oHench,sScriptsStored);
		AssignCommand(oHench,ClearAllActions());//stop following me!
		//Restore the event handling scripts
		RestoreEventHandlers(oHench);
	/*
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_HEARTBEAT,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_HEARTBEAT)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_NOTICE,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_NOTICE)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPELLCASTAT,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_SPELLCASTAT)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_MELEE_ATTACKED,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_MELEE_ATTACKED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DAMAGED,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DAMAGED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DISTURBED,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DISTURBED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_END_COMBATROUND,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_END_COMBATROUND)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DIALOGUE,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DIALOGUE)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_SPAWN_IN,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_SPAWN_IN)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_RESTED,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_RESTED)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_DEATH,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DEATH)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_USER_DEFINED_EVENT,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_USER_DEFINED_EVENT)));
		SetEventHandler(oHench,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,GetLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR)));
	*/
		//I want to put this in a for loop so bad it aches.
		//cleanup
		DeleteSavedEventHandlers(oHench);
	/*
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_HEARTBEAT));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_NOTICE));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_SPELLCASTAT));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_MELEE_ATTACKED));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DAMAGED));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DISTURBED));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_END_COMBATROUND));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DIALOGUE));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_SPAWN_IN));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_RESTED));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_DEATH));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_USER_DEFINED_EVENT));
		DeleteLocalString(oHench,sStoreScript_Prefix+IntToString(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR));
	*/	
	}
	return 1;
}

	
// Destroy a henchman
// Note: won't be destroyed if has been set as undestroyable
void DestroyHenchman(object oHenchman)
{
		//PrettyDebug ("Removing " + GetName(oHenchman));
		RemoveHenchman(GetMaster(oHenchman), oHenchman);	
		SetPlotFlag(oHenchman, FALSE);
		DestroyObject(oHenchman);
}

// Destroy all the henchmen of this master	
void DestroyAllHenchmen(object oMaster=OBJECT_SELF)
{
	int i;
	object oHenchman;

	// destroy them backwards to avoid problems w/ removeing henchmen causing re-indexing
	int iNumHenchmen = GetNumHenchmen(oMaster);
	
	for (i = iNumHenchmen; i>=1; i--)
	{
		oHenchman = GetHenchman(oMaster, i);
		//PrettyDebug ("Removing " + GetName(oHenchman));
		//RemoveHenchman(oMaster, oHenchman);	
		//SetPlotFlag(oHenchman, FALSE);
		DelayCommand(0.5f, DestroyHenchman(oHenchman));	// delay destructions so we have time to iterate through party properly
	}
}		

// Destroy every henchman in the entire party	 
void DestroyAllHenchmenInParty(object oPartyMember)	
{
	object oFM = GetFirstFactionMember(oPartyMember, FALSE);
	while(GetIsObjectValid(oFM))
	{
		//PrettyDebug ("Examining " + GetName(oFM) + " for henchmen.");
		DestroyAllHenchmen(oFM);
		oFM = GetNextFactionMember(oPartyMember, FALSE);
	}
}		