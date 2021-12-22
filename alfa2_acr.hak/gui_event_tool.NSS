/* gui_event_tool
	Some commands to aid in setting up, saving, and loading events
*/

const string EVENT_TOOL_GUIFILE = "eventtool.xml";
const string EVENT_TOOL_SCREEN = "EVENT_TOOL_SCREEN";
const string EVENT_TOOL_MARK_INT = "EVENT_TOOL_SAVE"; // local int on objects marked to be saved
const string EVENT_TOOL_OBJECT_COUNT = "ObjCt"; // int in DB that specifies number of saved objects
const string EVENT_TOOL_OBJECT_VAR = "EvtObj"; // objects stored as EventObject#, for placeables it will be the Resref
const string EVENT_TOOL_OBJECT_LOCATION = "EvtObjLoc";
const string EVENT_TOOL_LOCATION_TAG = "EvtLocTag"; // when saving a location save area tag too
const string EVENT_TOOL_OBJECT_TYPE = "EvtObjTyp"; // database int of object type
const string EVENT_TOOL_INVENTORY_PREFIX = "Inv";
const string EVENT_TOOL_INVENTORY_COUNT = "ItmCt";
const string EVENT_TOOL_INVENTORY_ITEM = "Itm";	
const string EVENT_TOOL_VARIABLE_COUNT_VAR = "nVar";
const string EVENT_TOOL_VARIABLE_TYPE_SUFFIX = "v"; // local variables are saved as OBJECT_PREFIX_object#_VARIABLE_SUFFIX+var#
const string EVENT_TOOL_VARIABLE_DATA_SUFFIX = "d";
const string EVENT_TOOL_VARIABLE_NAME_SUFFIX = "s";
const string EVENT_TOOL_OBJECT_SCALE_PREFIX = "Scale";
const int EVENT_TOOL_SCALE_SAVE_TYPES = 72; // OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE
/*
const string EVENT_TOOL_EFFECT_COUNT_VAR = "nEff";
const string EVENT_TOOL_EFFECT_TYPE_SUFFIX = "t"; // effects are saved as OBJECT_PREFIX_object#_EFFECT_SUFFIX+var#
const string EVENT_TOOL_EFFECT_SUBTYPE_SUFFIX = "u";
const string EVENT_TOOL_EFFECT_INTEGER_SUFFIX = "i";
const string EVENT_TOOL_EFFECT_SPELL_SUFFIX = "s";
const string EVENT_TOOL_EFFECT_DURATION_SUFFIX = "d";
*/

// object types to save as campaign object
const int EVENT_TOOL_OBJECT_MASK = 0x3; // OBJECT_TYPE_CREATURE | OBJECT_TYPE_ITEM

// object types to save as resref
const int EVENT_TOOL_RESREF_MASK = 0x2FC; // everything else

const int EVENT_TOOL_OBJECTS_PER_LOOP = 16; // will process this many objects then initiate a new action

const float EVENT_TOOL_DESTROY_DELAY = 1.0f; // destroyig of objects will be delayed by this amount to avoid problems with recursive actions for the event loop


// save local int, float, and string type variables on oTarget to sDatabase 
void SaveVariables(object oTarget, string sDatabase, string sPrefix)
{
//	DebugMsg("Storing variables for "+GetName(oTarget),"INSTANCE");
	int ctVar = GetVariableCount(oTarget);
	SetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_COUNT_VAR,ctVar);
	while (ctVar>0)
	{
		--ctVar;
		string sVar = IntToString(ctVar);
		string sRef = sPrefix+IntToString(ctVar);
		int nVarType = GetVariableType(oTarget,ctVar);
		string sVarName = GetVariableName(oTarget,ctVar);
		SetCampaignString(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_NAME_SUFFIX+sVar,sVarName);
//		DebugMsg("Storing "+sVarName+" as "+sRef,"INSTANCE");
		SetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_TYPE_SUFFIX+sVar,nVarType);
		switch (nVarType)
		{
			case VARIABLE_TYPE_FLOAT:
				SetCampaignFloat(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_DATA_SUFFIX+sVar,GetVariableValueFloat(oTarget,ctVar));
			break;
			case VARIABLE_TYPE_INT:
				SetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_DATA_SUFFIX+sVar,GetVariableValueInt(oTarget,ctVar));
			break;
			case VARIABLE_TYPE_STRING:
				SetCampaignString(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_DATA_SUFFIX+sVar,GetVariableValueString(oTarget,ctVar));
			break;
			
		}
	}
}

// load variables saved in sDatabase to oTarget
void LoadVariables(object oTarget, string sDatabase, string sPrefix)
{
//	DebugMsg("Loading variables for "+GetName(oTarget),"INSTANCE");
	int ctVar = GetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_COUNT_VAR);
	while (ctVar>0)
	{
		--ctVar;
		string sVar = IntToString(ctVar);
		string sRef = sPrefix+IntToString(ctVar);
		int nVarType = GetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_TYPE_SUFFIX+sVar);
		string sVarName = GetCampaignString(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_NAME_SUFFIX+sVar);
//		DebugMsg("Loading "+sVarName+" from "+sRef,"INSTANCE");
		switch (nVarType)
		{
			case VARIABLE_TYPE_FLOAT:
				SetLocalFloat(oTarget,sVarName,GetCampaignFloat(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_DATA_SUFFIX+sVar));
			break;
			case VARIABLE_TYPE_INT:
				SetLocalInt(oTarget,sVarName,GetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_DATA_SUFFIX+sVar));
			break;
			case VARIABLE_TYPE_STRING:
				SetLocalString(oTarget,sVarName,GetCampaignString(sDatabase,sPrefix+EVENT_TOOL_VARIABLE_DATA_SUFFIX+sVar));
			break;
			
		}
	}
}

// save inventory of oContainer to sDatabase with prefix of sPrefix
void SaveInventory(object oContainer, string sDatabase, string sPrefix)
{
	int ctItem = 0;
	object oTarget = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oTarget))
	{
		string sItemNum = IntToString(ctItem);
		StoreCampaignObject(sDatabase,sPrefix+EVENT_TOOL_INVENTORY_ITEM+sItemNum,oTarget);
		oTarget = GetNextItemInInventory(oContainer);
		++ctItem;
	}
	// store how many objects were saved
	SetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_INVENTORY_COUNT,ctItem);
}

// load a saved save inventory of oContainer from sDatabase with prefix of sPrefix
void LoadInventory(object oContainer, string sDatabase, string sPrefix)
{
	// read how many objects are to be loaded
	int nItemCount = GetCampaignInt(sDatabase,sPrefix+EVENT_TOOL_INVENTORY_COUNT);
	int ctItem;
	location lContainer = GetLocation(oContainer);
	for(ctItem = 0; ctItem < nItemCount; ++ctItem)
	{
		string sItemNum = IntToString(ctItem);
		object oLoaded = RetrieveCampaignObject(sDatabase,sPrefix+EVENT_TOOL_INVENTORY_ITEM+sItemNum,lContainer,oContainer);
	}
}

// destroy inventory of oContainer then destroy oContainer
void DestroyObjectAndInventory(object oContainer)
{
	object oTarget = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oTarget))
	{
		DestroyObject(oTarget);
		oTarget = GetNextItemInInventory(oContainer);
	}
	DestroyObject(oContainer);
}

void LoadScale(object oSpawn, string sDatabase, string sScaleRef)
{
	float x = GetCampaignFloat(sDatabase,sScaleRef+"x");
	float y = GetCampaignFloat(sDatabase,sScaleRef+"y");
	float z = GetCampaignFloat(sDatabase,sScaleRef+"z");
	if (x<0.0001) x = 1.0; // 
	if (y<0.0001) y = 1.0;
	if (z<0.0001) z = 1.0;
	SetScale(oSpawn,x,y,z);
}

void SaveScale(object oTarget, string sDatabase, string sScaleRef)
{
	float x = GetScale(oTarget,0);
	float y = GetScale(oTarget,1);
	float z = GetScale(oTarget,2);				
	if (x<0.999 || x>1.001)
		SetCampaignFloat(sDatabase,sScaleRef+"x",x);
	else
		DeleteCampaignVariable(sDatabase,sScaleRef+"x");
	if (y<0.999 || y>1.001)
		SetCampaignFloat(sDatabase,sScaleRef+"y",x);
	else
		DeleteCampaignVariable(sDatabase,sScaleRef+"y");
	if (z<0.999 || z>1.001)
		SetCampaignFloat(sDatabase,sScaleRef+"z",x);
	else
		DeleteCampaignVariable(sDatabase,sScaleRef+"z");
}

object RecreateObject(string sDatabase, string sObjectNum, int nObjectType, location lObjectLoc)
{
	string sResref = GetCampaignString(sDatabase,EVENT_TOOL_OBJECT_VAR+sObjectNum);
	object oLoaded = CreateObject(nObjectType,sResref,lObjectLoc);
	// placeables have to have their inventory saved separately
	if (GetHasInventory(oLoaded))
		AssignCommand(oLoaded,LoadInventory(oLoaded,sDatabase,EVENT_TOOL_INVENTORY_PREFIX+sObjectNum));
	if (nObjectType & EVENT_TOOL_SCALE_SAVE_TYPES)
		LoadScale(oLoaded,sDatabase,EVENT_TOOL_OBJECT_SCALE_PREFIX+sObjectNum);	
	return oLoaded;
}

void SaveObjectInfo(object oTarget, string sDatabase, string sObjectNum, int nType)
{
		SetCampaignString(sDatabase,EVENT_TOOL_OBJECT_VAR+sObjectNum,GetResRef(oTarget));
		// if a placeable has an inventory it must be saved separately
		if (GetHasInventory(oTarget))
			AssignCommand(oTarget,SaveInventory(oTarget,sDatabase,EVENT_TOOL_INVENTORY_PREFIX+sObjectNum));
		if (nType & EVENT_TOOL_SCALE_SAVE_TYPES)
			SaveScale(oTarget,sDatabase,sObjectNum);			
}				

// command to assign to oPC to load saved objects from sDatabase
// ctObject, nObjects, and bCommandable are used for recursive calls and should be left as default
void LoadArea(object oPC, string sDatabase, int ctObject = 0, int nObjects = -1, int bCommandable = TRUE)
{
	if (nObjects < 0) // must be first call, freeze PC 
	{
		bCommandable = GetCommandable(oPC); // determine if PC was commandable before start
		if (bCommandable) // if PC was commandable, then clear queue and set uncommandable
		{
			AssignCommand(oPC,ClearAllActions(TRUE));
			AssignCommand(oPC,SetCommandable(FALSE,oPC));
		}
		nObjects = GetCampaignInt(sDatabase,EVENT_TOOL_OBJECT_COUNT);
	}
	
	int nToLoad = EVENT_TOOL_OBJECTS_PER_LOOP; // will process this many then assign a new action
	while (nToLoad && ctObject < nObjects)
	{
		string sObjectNum = IntToString(ctObject);		
		int nObjectType = GetCampaignInt(sDatabase,EVENT_TOOL_OBJECT_TYPE+sObjectNum);
		location lObjectLoc = GetCampaignLocation(sDatabase,EVENT_TOOL_OBJECT_LOCATION+sObjectNum);		
		if (!GetIsLocationValid(lObjectLoc))
		{
			string sAreaTag = GetCampaignString(sDatabase,EVENT_TOOL_LOCATION_TAG+sObjectNum);
			float fFacing = GetFacingFromLocation(lObjectLoc);
			vector vPosition = GetPositionFromLocation(lObjectLoc);
			object oArea;
			if (sAreaTag != "") 
			{
				oArea = GetObjectByTag(sAreaTag);
				lObjectLoc = Location(oArea,vPosition,fFacing);
			}
			if (!GetIsLocationValid(lObjectLoc)) 
			{
				oArea = GetArea(oPC);
				lObjectLoc = Location(oArea,vPosition,fFacing);				
			}
		}
		if (GetIsLocationValid(lObjectLoc)) // valid location found, load it
		{
			object oLoaded;
			if (nObjectType & EVENT_TOOL_OBJECT_MASK) // creatures and items are stored as objects
			{
				oLoaded = RetrieveCampaignObject(sDatabase,EVENT_TOOL_OBJECT_VAR+sObjectNum,lObjectLoc);
				SetCommandable(TRUE,oLoaded); // since we freeze objects when saving them, we need to unfreeze them here
			}
			else if (nObjectType & EVENT_TOOL_RESREF_MASK) // other objects are stored by resref
				oLoaded = RecreateObject(sDatabase,sObjectNum,nObjectType,lObjectLoc);
			// mark the object as an event object, should already be set for creatures and items
			SetLocalInt(oLoaded,EVENT_TOOL_MARK_INT,TRUE);
			SendMessageToPC(oPC,"Loaded "+GetName(oLoaded));
		}
		else // no valid location, so skip
			SendMessageToPC(oPC,"Failed to find valid area to create object number "+IntToString(ctObject));
		++ctObject; // increment number loaded
		--nToLoad; // decrement number to load this in this action
	}
	if (ctObject < nObjects) // still saving, so continue
		AssignCommand(oPC,LoadArea(oPC,sDatabase,ctObject,nObjects,bCommandable));
	else if (bCommandable) // we're done saving, unfreeze oPC if necessary
		AssignCommand(oPC,SetCommandable(TRUE,oPC));
}

// objects are saved using assigned commands to split the database action into many actions
// if bCommandable is TRUE, oTarget will be set to commandable after
void SaveObject(object oTarget, string sDatabase, int nObjectNum)//, int bCommandable)
{
	int nObjectType = GetObjectType(oTarget);
	string sObjectNum = IntToString(nObjectNum);
	location lObjectLoc = GetLocation(oTarget);
	// always store location
	SetCampaignLocation(sDatabase,EVENT_TOOL_OBJECT_LOCATION+sObjectNum,lObjectLoc);
	SetCampaignString(sDatabase,EVENT_TOOL_LOCATION_TAG+sObjectNum,GetTag(GetAreaFromLocation(lObjectLoc)));
	// always store type
	SetCampaignInt(sDatabase,EVENT_TOOL_OBJECT_TYPE+sObjectNum,nObjectType);
	if (nObjectType & EVENT_TOOL_OBJECT_MASK) // creatures and items are stored as objects
		StoreCampaignObject(sDatabase,EVENT_TOOL_OBJECT_VAR+sObjectNum,oTarget);
	else if (nObjectType & EVENT_TOOL_RESREF_MASK) // other objects are recreated from resref
		SaveObjectInfo(oTarget,sDatabase,sObjectNum,nObjectType);

}

// command to assign to oPC to save marked objects in their area
// oTarget and bCommandable are used for recursive calls and should be left as default
void SaveArea(object oPC, string sDatabase, int ctObject, object oArea, object oTarget = OBJECT_INVALID, int bCommandable = TRUE)
{
	if (!GetIsObjectValid(oTarget)) // must be first call, freeze PC and get first object
	{
		bCommandable = GetCommandable(oPC); // determine if PC was commandable before start
		if (bCommandable) // if PC was commandable, then clear queue and set uncommandable
		{
			AssignCommand(oPC,ClearAllActions(TRUE));
			AssignCommand(oPC,SetCommandable(FALSE,oPC));
		}
		oTarget = GetFirstObjectInArea(oArea);
	}
	int nToSave = EVENT_TOOL_OBJECTS_PER_LOOP; // will process this many then assign a new action
	while (nToSave && GetIsObjectValid(oTarget))
	{
		if (GetLocalInt(oTarget,EVENT_TOOL_MARK_INT)) // marked for saving
		{
			// if it was a commandable creature, then freeze it. it will be restored after it has does it's save
/*			int bTargetCommandable = GetCommandable(oTarget); 
			if (bTargetCommandable) 
			{
				SendMessageToPC(oPC,"Freezing "+GetName(oTarget));
				AssignCommand(oTarget,ClearAllActions(TRUE));
				AssignCommand(oTarget,SetCommandable(FALSE,oTarget));
			}*/
			AssignCommand(oTarget,SaveObject(oTarget,sDatabase,ctObject));//,bTargetCommandable));
			SendMessageToPC(oPC,"Saving "+GetName(oTarget));			
			++ctObject; // increment number saved
		}
		--nToSave;
		oTarget = GetNextObjectInArea(oArea);
	}
	if (GetIsObjectValid(oTarget)) // still saving, so continue
		AssignCommand(oPC,SaveArea(oPC,sDatabase,ctObject,oArea,oTarget,bCommandable));
	else // we're done saving, unfreeze oPC and store object count
	{
		if (bCommandable) // if the PC was previosuly commandable then restore their commandable state
			AssignCommand(oPC,SetCommandable(TRUE,oPC));
		if (ctObject) // this should result in deleting the file when there is nothing to save
			SetCampaignInt(sDatabase,EVENT_TOOL_OBJECT_COUNT,ctObject);
	}
}

// command to assign to oPC to clear marked objects in oArea
// oTarget and bCommandable are used for recursive calls and should be left as default
void ClearArea(object oPC, object oArea, object oTarget = OBJECT_INVALID, int bCommandable = TRUE)
{
	if (!GetIsObjectValid(oTarget)) // must be first call, freeze PC and get first object
	{
		bCommandable = GetCommandable(oPC); // determine if PC was commandable before start
		if (bCommandable) // if PC was commandable, then clear queue and set uncommandable
		{
			AssignCommand(oPC,ClearAllActions(TRUE));
			AssignCommand(oPC,SetCommandable(FALSE,oPC));
		}
		oTarget = GetFirstObjectInArea(oArea);
	}
	int nToClear = EVENT_TOOL_OBJECTS_PER_LOOP; // will process this many then assign a new action
	while (nToClear && GetIsObjectValid(oTarget))
	{
		if (GetLocalInt(oTarget,EVENT_TOOL_MARK_INT)) // marked as event object
		{
			if (GetHasInventory(oTarget))
				DelayCommand(EVENT_TOOL_DESTROY_DELAY,DestroyObjectAndInventory(oTarget));
			else
				DelayCommand(EVENT_TOOL_DESTROY_DELAY,DestroyObject(oTarget));
			SendMessageToPC(oPC,"Destroying "+GetName(oTarget));
		}
		--nToClear;
		oTarget = GetNextObjectInArea(oArea);
	}
	if (GetIsObjectValid(oTarget)) // still saving, so continue
		AssignCommand(oPC,ClearArea(oPC,oArea,oTarget,bCommandable));
	else if (bCommandable)// we're done clearing, unfreeze oPC if it was previously commandable
		AssignCommand(oPC,SetCommandable(TRUE,oPC));
}

void main (string sCommand, string sDatabase, string sAppend) 
{
	object oPC = OBJECT_SELF;
	
	// make sure the calling player is a DM
	if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC) && !GetIsSinglePlayer())
	{
		SendMessageToPC(oPC,"This feature is DM only.");
		CloseGUIScreen(oPC,EVENT_TOOL_SCREEN);
		return;
	}
	
	// display help
	if (sCommand == "help")
	{
		SendMessageToPC(oPC,"Usage:");
		SendMessageToPC(oPC,"Set up an event.");
		SendMessageToPC(oPC,"Mark objects to be saved for event.");
		SendMessageToPC(oPC,"Save event to database, overwrite mode is recommended to start a clear database.");
		SendMessageToPC(oPC,"Clear area to remove marked objects.");
		SendMessageToPC(oPC,"To run event, load event from database to restore saved objects.");
		SendMessageToPC(oPC,"Run event.");
		SendMessageToPC(oPC,"After event, clear area to aid in cleanup by removing marked objects.");
		SendMessageToPC(oPC,"Tip:");
		SendMessageToPC(oPC,"Saving the event saves marked object, then clearing the area will remove objects that were marked.");
		SendMessageToPC(oPC,"Any objects that were desired to be saved but weren't marked will remain, and can then be marked and the saved in append mode to add the missed objects to the databse.");
	}
	
	// mark target for saving
	else if (sCommand == "mark") 
	{ 
		object oTarget = GetPlayerCurrentTarget(oPC);
		if (GetObjectType(oTarget) & ( EVENT_TOOL_OBJECT_MASK |  EVENT_TOOL_RESREF_MASK))
		{
			SendMessageToPC(oPC,GetName(oTarget)+" marked for saving.");
			SetLocalInt(oTarget,EVENT_TOOL_MARK_INT,TRUE);
		}
		else
			SendMessageToPC(oPC,GetName(oTarget)+" is not a valid object for saving.");
	}
	
	// unmark target for saving
	else if (sCommand == "unmark") 
	{ 
		object oTarget = GetPlayerCurrentTarget(oPC);
		SendMessageToPC(oPC,GetName(oTarget)+" unmarked for saving.");
		DeleteLocalInt(oTarget,EVENT_TOOL_MARK_INT);
	}
	
	// save all market targets in area
	else if (sCommand == "savearea")
	{
		SendMessageToPC(oPC,"append is "+sAppend);
		if (sDatabase=="")
		{
			SendMessageToPC(oPC,"Specify a database."+sAppend);
			return;
		}
		int ctObject = 0;
		if (sAppend == "true")
			ctObject = GetCampaignInt(sDatabase,EVENT_TOOL_OBJECT_COUNT);
		else
			DestroyCampaignDatabase(sDatabase);
		SaveArea(oPC,sDatabase,ctObject,GetArea(oPC));
	}
	
	// load objects from database to area
	else if (sCommand == "loadarea")
	{
		if (sDatabase=="")
		{
			SendMessageToPC(oPC,"Specify a database."+sAppend);
			return;
		}
		LoadArea(oPC,sDatabase);
	}
	
	// clear area of marked objects
	else if (sCommand == "cleararea")
		ClearArea(oPC,GetArea(oPC));
		
	// toggle if database is appended or overwritten
	else if (sCommand == "append")
	{
		int bAppend = sAppend != "true";
		SetLocalGUIVariable(oPC,EVENT_TOOL_SCREEN,1,bAppend?"true":"false");
		SendMessageToPC(oPC,"Save mode set to "+(bAppend?"append":"overwrite"));
		if (bAppend)
			SetGUITexture(oPC,EVENT_TOOL_SCREEN,"append","ia_assigncommand2.tga");
		else
			SetGUITexture(oPC,EVENT_TOOL_SCREEN,"append","ia_exit.tga");
	}
	
	// closes the gui window
	else if (sCommand == "closegui")
		CloseGUIScreen(oPC,EVENT_TOOL_SCREEN);
} 