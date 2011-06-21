////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_initial - DM Friendly Initiative -  Initialization Functions
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious          1/2/7    Qk 10/01/07
//						AcadiusLost	8/9/2009 - DMFI UI default to off
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// ************************** DECLARATIONS *************************************

#include "dmfi_inc_tool"
#include "dmfi_inc_langexe"

// FILE: dmfi_inc_initial
// OnClient Enter function to give a Tool to the entering PC / DM.  It 
// calls DMFI_InitializeModule() to list/acquire plugins and calls
// DMFI_InitializeLanguage() to define languages for player.
void DMFI_ClientEnter(object oPC);

// FILE: dmfi_inc_initial
//Purpose: Gives version number and initialization text and if needed, will
//call DMFI_InitializePlugins.
void DMFI_InitializeModule(object oPC = OBJECT_INVALID);

// FILE: dmfi_inc_initial
//Purpose: Initializes any Language Plugins for the module
void DMFI_InitializeLanguagePlugins(object oPC, object oWPLocker);

// FILE: dmfi_inc_initial
//Purpose: Initializes any Command Plugins for the module
void DMFI_InitializeCommandPlugins(object oPC, object oWPLocker);

// FILE: dmfi_inc_initial
//Purpose: Initializes any Emote Plugins for the module
void DMFI_InitializeEmotePlugins(object oPC, object oWPLocker);

// FILE: dmfi_inc_initial
//Purpose: Creates a list of known languages on oTool based	upon base rules,
// previously DM granted languages, and plugins.  Note:  As of 1.02, languages
// are persistent and DM granted languages should remain until deleted.
// oPC is the player, oTool is oPCs tool, and oDM is an optional requesting DM.
void DMFI_InitializeLanguage(object oPC, object oTool, object oDM=OBJECT_INVALID);

// FILE: dmfi_inc_initial
//Purpose: Creates a Waypoint Locker and calls the subroutines for loading the
//individual plugin
void DMFI_InitializePlugins(object oPC);

// FILE: dmfi_inc_initial
// oTool is the OLD tool.  It will be destroyed.  A new tool will be created
// for oPC to reset any and all variables / preferences.
void DMFI_InitializeTool(object oPC, object oTool);

// FILE: dmfi_inc_initial
// An insertion sort routine to order any found plugins into order.  It is NOT
// a generic sort routine.  It is designed to work with plugins only due to how
// variables are refernced.  sPrefix is DMFI_DM or DMFI_PC + the type of plugin.
// nMax is the nDMSlot or nPCSlot which is the number of items in the array +1
void DMFI_InsertionSort(object oWPLocker, string sPrefix, int nMax);

// FILE: dmfi_inc_initial
// Lists current plugins that are loaded for the module.
void DMFI_ListPlugins(object oPC);

// FILE: dmfi_inc_initial
//Purpose: Runs Emote Plugins
int DMFI_RunEmotePlugins(object oPC);

// FILE: dmfi_inc_initial
//Purpose: Runs Command Plugins
int DMFI_RunCommandPlugins(object oPC);

// FILE: dmfi_inc_initial
//Purpose: Runs Language Plugins
int DMFI_RunLanguagePlugins(object oPC);

// FILE: dmfi_inc_initial
// Runs any plugins found on initialization of the module.  sType is the type
// like emote, language, command, or prefix.
void DMFI_RunPlugins(object oPC, string sType);

// FILE: dmfi_inc_initial
// Small function to write the tool to the database after loading with data.
void DMFI_StoreTool(object oPC, string sResRef, object oTool);

// FILE: dmfi_inc_initial
// This function transfers langauge listing between to objects.
void DMFI_TransferTempLangData(object oStart, object oFinish);

// FILE: dmfi_inc_initial
// Adds data (variables) to the tool if none is present.
// This is called from the OnAcquire Module event. 
void DMFI_VerifyToolData(object oPC, object oTool);

// ************************** FUNCTIONS ****************************************

void DMFI_ClientEnter(object oPC)
{ // PURPOSE: Called from the module event OnClientEnter ONLY.  Gives the
  // entering player a DMFI Tool and lists plugins and languages granted.
  // Original Scripter: Demetrious
  // Last Modified By: Demetrious  1/10/7
	object oTool;
	string sTest, sResRef;
	string sVersion;
	int nAppear;
  
	// Delete this just in case
	DeleteLocalString(oPC, DMFI_LANGUAGE_TOGGLE);

  	if (!GetIsPC(oPC))
  		return;
  	
	if (DMFI_GetIsDM(oPC))
	{
		// default DMFI UI to off, since we use the inventory merged UI
		//DisplayGuiScreen(oPC, SCREEN_DMFI_DM, FALSE, "dmfidmui.xml");
		//DisplayGuiScreen(oPC, SCREEN_DMFI_BATTLE, FALSE, "dmfibattle.xml");
		//added Qk for targetscreen
		DisplayGuiScreen(oPC,SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
		//end added
		SetLocalInt(oPC, DMFI_PC_UI_STATE, TRUE);
	}	
	else
	{
		DisplayGuiScreen(oPC, SCREEN_DMFI_PLAYER, FALSE, "dmfiplayerui.xml");
		SetLocalInt(oPC, DMFI_PC_UI_STATE, TRUE);
	}		
	
	oTool = GetItemPossessedBy(oPC, DMFI_ITEM_TAG);
	sVersion = GetLocalString(oTool, DMFI_TOOL_VERSION);
	sResRef = GetResRef(oTool);
	
	// This block ensures PCs and DMs don't have each others tools.
	if (DMFI_GetIsDM(oPC))
	{
		if (sResRef!=DMFI_TOOL_RESREF)
		{
			SetPlotFlag(oTool, FALSE);
			DestroyObject(oTool);
			oTool=OBJECT_INVALID;
		}
	}
	else 
	{
		if (sResRef!=DMFI_PCTOOL_RESREF)
			{
				SetPlotFlag(oTool, FALSE);
				DestroyObject(oTool);
				oTool=OBJECT_INVALID;
			}
	}			
	
	// Verifies the version of the possessed tool	
	if ((sVersion!=MOD_VERSION) && (GetIsObjectValid(oTool)))
	{
		SendText(oPC, TXT_TOOL_VERSION_ERROR);
		DMFI_TransferTempLangData(oTool, oPC);  // write a list to the PC as a temp listing
		SetPlotFlag(oTool, FALSE);
		DestroyObject(oTool);
		oTool=OBJECT_INVALID;
	}	
		
	if (oTool==OBJECT_INVALID)
  	{// Invalid Tool
    	location lLoc = GetLocation(oPC);
  	  	if (DMFI_GetIsDM(oPC))
      	{ // DM invalid tool code
			sVersion = GetCampaignString(DMFI_DATABASE, DMFI_TOOL_VERSION);
			if (sVersion!=MOD_VERSION)
			{
				DestroyCampaignDatabase(DMFI_DATABASE);
				SendText(oPC, TXT_DB_VERSION_ERROR);
				oTool = CreateItemOnObject(DMFI_TOOL_RESREF,oPC);
			}		
			else
			{
				oTool = RetrieveCampaignObject(DMFI_DATABASE, DMFI_TOOL_RESREF, lLoc, oPC);
				SendText(oPC, TXT_DB_VERSION + sVersion);
				if (!GetIsObjectValid(oTool)) 
			  		oTool = CreateItemOnObject(DMFI_TOOL_RESREF,oPC);
		        else
				{
					SendText(oPC, TXT_ITEM_RETRIEVED);
					AssignCommand(oPC, ActionPickUpItem(oTool));
				}
			}
			// clear any invalid dynamic data just in case   
			DeleteLocalInt(oTool, DMFI_VFX_RECENT);				
			SetLocalObject(oTool, DMFI_TOOL_PC, oPC);
	        SetLocalObject(oPC, DMFI_TOOL, oTool);
			SetDroppableFlag(oTool, FALSE);
      }
      else
      { // PC invalid code
	        sVersion = GetCampaignString(DMFI_DATABASE, DMFI_TOOL_VERSION);
			if (sVersion!=MOD_VERSION)
			{
				DestroyCampaignDatabase(DMFI_DATABASE);
				SendText(oPC, TXT_DB_VERSION_ERROR);
				oTool = CreateItemOnObject(DMFI_PCTOOL_RESREF,oPC);
			}		
			else
			{
				oTool = RetrieveCampaignObject(DMFI_DATABASE, DMFI_PCTOOL_RESREF, lLoc, oPC);
				SendText(oPC, TXT_DB_VERSION + sVersion);
				if (!GetIsObjectValid(oTool)) 
			  		oTool = CreateItemOnObject(DMFI_PCTOOL_RESREF,oPC);
		        else
				{
					SendText(oPC, TXT_ITEM_RETRIEVED);
					AssignCommand(oPC, ActionPickUpItem(oTool));
				}
			}	
			
			SetLocalObject(oTool, DMFI_TOOL_PC, oPC);
	        SetLocalObject(oPC, DMFI_TOOL, oTool);
			SetDroppableFlag(oTool, FALSE);
      }
  	} // Invalid Tool
  
	else 
  	{ // Valid Tool - simply link.
  	    SetLocalObject(oTool, DMFI_TOOL_PC, oPC);
        SetLocalObject(oPC, DMFI_TOOL, oTool);
		SetDroppableFlag(oTool, FALSE);
  	}
	 
 	DMFI_InitializeModule(oPC);
  	DelayCommand(2.0, DMFI_VerifyToolData(oPC, oTool));
}

void DMFI_InitializeLanguage(object oPC,  object oTool, object oDM=OBJECT_INVALID)
{  //Purpose:  Creates a list of known languages on oTool based
   //	upon base rules, DM granted languages, and plugins
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 2/8/7
   int nKnown;  
   int n=0;
   string sName;
   string sExecute;
   string sLang;
   object oWPLocker;
   
   // Is the tool initialized?
   nKnown = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
   if (nKnown==0)
   {	// Not initialized:  Need to check for temp list and initialize
   		DMFI_TransferTempLangData(oPC, oTool);
   		nKnown = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
		
		if (nKnown==0)
		{	
			// Grant languages and report that list to Player
			if (DMFI_GetIsDM(oPC))
	        	SendText(oPC, TXT_ALL_LANGUAGES, FALSE, COLOR_GREY);
		    else
		    {
		        if (DMFI_GIVE_COMMON)
					DMFI_GrantLanguage(oPC, LNG_COMMON);
				if (DMFI_GIVE_DEFAULT_LANGUAGES)
					DMFI_GiveDefaultLanguages(oPC);
				if (DMFI_CHOOSE_LANGUAGES)
					DMFI_GrantChoosenLanguages(oPC);
			}
		}
		else
			DMFI_ListLanguages(oPC, oPC);	
	}
	else 
	{
		DMFI_ListLanguages(oPC, oPC);
	}		
		 
	// Run plugin rules every time regardless so new plugins will
	// have an effect - otherwise you would have to require re-initialization
	// of every player on the server. 
    
	n=0;
    oWPLocker = GetObjectByTag(DMFI_FILE_LOCKER);
    sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_LANGUAGE + DMFI_STRING_NAME + IntToString(n));
    while (sName!="")
    { // Run through Plugins for rules
    	if (sName==DMFI_STRING_RULE)
        {
        	sExecute = GetLocalString(oWPLocker, DMFI_PC + DMFI_LANGUAGE + DMFI_STRING_EXECUTE + sName);
            ExecuteScript(sExecute, oPC);
        }
        n++;
        sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_LANGUAGE + DMFI_STRING_NAME + IntToString(n));
    } // Run through Plugins for rules
   
	// Check for valid server configuration.
	nKnown = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
	if ((nKnown==0) && DMFI_PCLANGUAGES_ENABLED && (!DMFI_CHOOSE_LANGUAGES) && (!DMFI_GetIsDM(oPC)))
		SendText(oPC, TXT_LANGUAGES_SERVER_ERROR, TRUE, COLOR_RED);
}

void DMFI_InitializeModule(object oPC)
{ //Purpose: Gives version number and initialization text and if needed, will
  //call DMFI_InitializePlugins.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/7/6
    SendText(oPC, TXT_VERSION + MOD_NAME, FALSE, COLOR_CYAN);

    if (GetObjectByTag(DMFI_FILE_LOCKER)==OBJECT_INVALID)
        DMFI_InitializePlugins(oPC);

    DMFI_ListPlugins(oPC);
}

void DMFI_InitializeEmotePlugins(object oPC, object oWPLocker)
{ //Purpose: Initialize Emote Plugins
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/5/6
    int n;
    object oWP;
    string sExecute;
    string sName;
    float fPriority;

    int nDMSlot = 0;
    int nPCSlot = 0;
    oWP = GetObjectByTag(DMFI_PLUGIN_TAG + DMFI_STRING_EMOTE, n);

    while (oWP!=OBJECT_INVALID)
    {
        sExecute =  GetLocalString(oWP, DMFI_STRING_EXECUTE);
        fPriority = GetLocalFloat(oWP, DMFI_STRING_PRIORITY);
        sName =     GetLocalString(oWP, DMFI_STRING_NAME);

        // All are loaded onto the DM List
        SetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_EMOTE + DMFI_STRING_NAME       + IntToString(nDMSlot), sName);
        SetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_EMOTE + DMFI_STRING_EXECUTE    + sName, sExecute);
        SetLocalFloat(oWPLocker,  DMFI_DM + DMFI_STRING_EMOTE + DMFI_STRING_PRIORITY   + sName, fPriority);
        nDMSlot++;

        if (GetLocalInt(oWP, DMFI_STRING_DMONLY)!=1)
        { // Non-DM only ones are loaded for PCs
            SetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_EMOTE + DMFI_STRING_NAME       + IntToString(nPCSlot), sName);
            SetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_EMOTE + DMFI_STRING_EXECUTE    + sName, sExecute);
            SetLocalFloat(oWPLocker,  DMFI_PC + DMFI_STRING_EMOTE + DMFI_STRING_PRIORITY   + sName, fPriority);
            nPCSlot++;
        }
        n++;
        oWP = GetObjectByTag(DMFI_PLUGIN_TAG + DMFI_STRING_EMOTE, n);
    }
    if (nDMSlot>1) DMFI_InsertionSort(oWPLocker, DMFI_DM + DMFI_STRING_EMOTE, nDMSlot);
    if (nPCSlot>1) DMFI_InsertionSort(oWPLocker, DMFI_PC + DMFI_STRING_EMOTE, nPCSlot);
}

void DMFI_InitializeCommandPlugins(object oPC, object oWPLocker)
{ //Purpose: Initialize Command Plugins
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/5/6
    int n;
    object oWP;
    string sExecute;
    string sName;
    float fPriority;

    int nDMSlot = 0;
    int nPCSlot = 0;
    oWP = GetObjectByTag(DMFI_PLUGIN_TAG + DMFI_STRING_COMMAND, n);

    while (oWP!=OBJECT_INVALID)
    {
        sExecute =  GetLocalString(oWP, DMFI_STRING_EXECUTE);
        fPriority = GetLocalFloat(oWP, DMFI_STRING_PRIORITY);
        sName =     GetLocalString(oWP, DMFI_STRING_NAME);

        SetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_COMMAND + DMFI_STRING_NAME       + IntToString(nDMSlot), sName);
        SetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_COMMAND + DMFI_STRING_EXECUTE    + sName, sExecute);
        SetLocalFloat(oWPLocker,  DMFI_DM + DMFI_STRING_COMMAND + DMFI_STRING_PRIORITY   + sName, fPriority);
        nDMSlot++;

        if (GetLocalInt(oWP, DMFI_STRING_DMONLY)!=1)
        { // Non-DM only ones are loaded for PCs
            SetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_COMMAND + DMFI_STRING_NAME       + IntToString(nPCSlot), sName);
            SetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_COMMAND + DMFI_STRING_EXECUTE    + sName, sExecute);
            SetLocalFloat(oWPLocker,  DMFI_PC + DMFI_STRING_COMMAND + DMFI_STRING_PRIORITY   + sName, fPriority);
            nPCSlot++;
        }
        n++;
        oWP = GetObjectByTag(DMFI_PLUGIN_TAG + DMFI_STRING_COMMAND, n);
    }
    if (nDMSlot>1) DMFI_InsertionSort(oWPLocker, DMFI_DM + DMFI_STRING_COMMAND, nDMSlot);
    if (nPCSlot>1) DMFI_InsertionSort(oWPLocker, DMFI_PC + DMFI_STRING_COMMAND, nPCSlot);
}

void DMFI_InitializeLanguagePlugins(object oPC, object oWPLocker)
{ //Purpose: Initialize Language Plugins
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/5/6
    int n;
    object oWP;
    string sExecute;
    string sName;
    string sPrefix;
    string sTest;
    float fPriority;

    oWP = GetObjectByTag(DMFI_PLUGIN_TAG + DMFI_STRING_LANGUAGE, n);

    while (oWP!=OBJECT_INVALID)
    {
        sExecute =  GetLocalString(oWP, DMFI_STRING_EXECUTE);
        fPriority = GetLocalFloat(oWP, DMFI_STRING_PRIORITY);
        sName =     GetLocalString(oWP, DMFI_STRING_NAME);

        sPrefix = DMFI_Parse(sExecute, PRM_);
        if (sPrefix == DMFI_STRING_LANGUAGE)
        { // Special code to allow for renaming languages via plugins
            sTest = DMFI_RemoveParsed(sExecute, sPrefix, PRM_);
            SetLocalString(GetModule(), GetStringLowerCase(sName), GetStringLowerCase(sTest));
        }

        SetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_NAME + IntToString(n), sName);
        SetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_EXECUTE + sName, sExecute);
        SetLocalFloat(oWPLocker,  DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_PRIORITY + sName, fPriority);

        n++;
        oWP = GetObjectByTag(DMFI_PLUGIN_TAG + DMFI_STRING_LANGUAGE, n);
    }
    if (n>1) DMFI_InsertionSort(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE, n);
}

void DMFI_InitializePlugins(object oPC)
{ //Purpose: Find any and all plugins and load them into a string listing on a waypoint
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/7/6
  object oWPLocker;

  DestroyObject(GetWaypointByTag(DMFI_FILE_LOCKER));

  // Start with a fresh WPLocker to store the plugins.
  oWPLocker = CreateObject(OBJECT_TYPE_WAYPOINT, DMFI_WAYPOINT_RESREF, GetLocation(oPC), FALSE, DMFI_FILE_LOCKER);

  DMFI_InitializeEmotePlugins(oPC, oWPLocker);
  DMFI_InitializeCommandPlugins(oPC, oWPLocker);
  DMFI_InitializeLanguagePlugins(oPC, oWPLocker);
  SendText(oPC, TXT_PLUGINS_INITIALIZED);
}

void DMFI_InsertionSort(object oWPLocker, string sPrefix, int nMax)
{ //Purpose: Insertion Sort to properly order any DMFI Plugins according to Priority
  //Original Scripter: EPOlson from DMFI Guild
  //Last Modified By: EPOlson 6/24/6
  int i, j;             // iterators
  float fSortPriority;  //value we will sort by
  float fListPriority;
  string sPluginName;   // item we are inserting
  string sReplace;

  for (i=1; i < nMax; i++)
  {
    sPluginName = GetLocalString(oWPLocker, sPrefix + DMFI_STRING_NAME + IntToString(i));
    fSortPriority = GetLocalFloat(oWPLocker, sPrefix + DMFI_STRING_PRIORITY + sPluginName);

    j = i;
    while ((j > 0) && ( fSortPriority > GetLocalFloat(
           oWPLocker, sPrefix + DMFI_STRING_PRIORITY +
           GetLocalString(oWPLocker, sPrefix + DMFI_STRING_NAME + IntToString(j-1)))))
    {
        SetLocalString(oWPLocker, sPrefix + DMFI_STRING_NAME + IntToString(j),
           GetLocalString(oWPLocker, sPrefix + DMFI_STRING_NAME + IntToString(j-1)));
        j=j-1;
    }
    SetLocalString(oWPLocker, sPrefix + DMFI_STRING_NAME + IntToString(j), sPluginName);
  }
}

void DMFI_InitializeTool(object oPC, object oTool)
{ //Purpose: Destroys the current Tool and creates a new one - this will reset
  // any preferences or variables on the tool
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 11/26/6
	string sResRef;	
  	
	DMFI_TransferTempLangData(oTool, oPC);  // write a list to the PC as a temp listing
	DestroyCampaignDatabase(DMFI_DATABASE);
	
	SetPlotFlag(oTool, FALSE);
	DestroyObject(oTool);
	object oListener = GetLocalObject(oPC, DMFI_LISTENER);
	DestroyObject(oListener);
	SendText(oPC, TXT_INITIALIZE_TOOL, TRUE, COLOR_GREEN);
	DelayCommand(3.0, DMFI_ClientEnter(oPC));
}

void DMFI_ListPlugins(object oPC)
{ //Purpose: Called from DMFI_InitializeModule.  It will list all current plugins
  //on the server to oPC.  This information is part of the server information
  //given to new players and on the command .initialize module
    string sReturn;
    string sType;
    string sList;
    string sName;
    string sExecute;

    object oWPLocker = GetObjectByTag(DMFI_FILE_LOCKER);
    int n=0;

    // Sets correct list for command and emote plugins.
    if (DMFI_GetIsDM(oPC))  sList = DMFI_DM;
    else                    sList = DMFI_PC;

    n=0;
    sName = GetLocalString(oWPLocker, sList + DMFI_STRING_COMMAND + DMFI_STRING_NAME + IntToString(n));

    while (sName!="")
    {
        sReturn = sReturn + TXT_PLUGIN_COMMAND + sName + "\n";
        n++;
        sName = GetLocalString(oWPLocker, sList + DMFI_STRING_COMMAND + DMFI_STRING_NAME + IntToString(n));
    }

    n=0;
    sName = GetLocalString(oWPLocker, sList + DMFI_STRING_EMOTE + DMFI_STRING_NAME + IntToString(n));
    while (sName!="")
    {
        sReturn = sReturn + TXT_PLUGIN_EMOTE + sName + "\n";
        n++;
        sName = GetLocalString(oWPLocker, sList + DMFI_STRING_EMOTE + DMFI_STRING_NAME + IntToString(n));
    }

    sList = DMFI_PC; // ALL Language Plugins are PC oriented so there is no DM List.
    sName = GetLocalString(oWPLocker, sList + DMFI_STRING_LANGUAGE + DMFI_STRING_NAME + IntToString(n));
    while (sName!="")
    {
        sExecute = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_EXECUTE + sName);
        if ((DMFI_Parse(sExecute, PRM_)!=DMFI_STRING_LANGUAGE))
            sReturn = sReturn + TXT_PLUGIN_LANGUAGE + sName + "\n";
        else if (sName!=DMFI_STRING_RULE)
            sReturn = sReturn + TXT_PLUGIN_LANG_ADDED + sName + "\n";

        n++;
        sName = GetLocalString(oWPLocker, sList + DMFI_STRING_LANGUAGE + DMFI_STRING_NAME + IntToString(n));
    }
    SendText(oPC, sReturn, FALSE, COLOR_CYAN);
}

int DMFI_RunCommandPlugins(object oPC)
{ //Purpose: Executes Command Plugins found on the module
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/6/6
    int n=0;
    string sName;
    string sExecute;

    object oWPLocker = GetObjectByTag(DMFI_FILE_LOCKER);
    sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_COMMAND + DMFI_STRING_NAME + IntToString(n));

    if (DMFI_GetIsDM(oPC))
    {
        n=0;
        sName = GetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_COMMAND + DMFI_STRING_NAME + IntToString(n));
        while (sName!="")
        {
            sExecute = GetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_COMMAND + DMFI_STRING_EXECUTE + sName);
            ExecuteScript(sExecute, oPC);

            if (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE)) break;

            n++;
            sName = GetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_COMMAND + DMFI_STRING_NAME + IntToString(n));
        }
    }
    else
    {
        while (sName!="")
        {
            sExecute = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_COMMAND + DMFI_STRING_EXECUTE + sName);
            ExecuteScript(sExecute, oPC);

            if (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE)) break;

            n++;
            sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_COMMAND + DMFI_STRING_NAME + IntToString(n));
        }
    }
    return (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE));
}

int DMFI_RunEmotePlugins(object oPC)
{ //Purpose: Executes Emote Plugins found on the module
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/6/6
    int n=0;
    string sName;
    string sExecute;

    object oWPLocker = GetObjectByTag(DMFI_FILE_LOCKER);
    sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_EMOTE + DMFI_STRING_NAME + IntToString(n));

    if (DMFI_GetIsDM(oPC))
    {
        n=0;
        sName = GetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_EMOTE + DMFI_STRING_NAME + IntToString(n));
        while (sName!="")
        {
            sExecute = GetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_EMOTE + DMFI_STRING_EXECUTE + sName);
            ExecuteScript(sExecute, oPC);

            if (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE)) break;

            n++;
            sName = GetLocalString(oWPLocker, DMFI_DM + DMFI_STRING_EMOTE + DMFI_STRING_NAME + IntToString(n));
        }
    }
    else
    {
        while (sName!="")
        {
            sExecute = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_EMOTE + DMFI_STRING_EXECUTE + sName);
            ExecuteScript(sExecute, oPC);

            if (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE)) break;

            n++;
            sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_EMOTE + DMFI_STRING_NAME + IntToString(n));
        }
    }
    return (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE));
}

int DMFI_RunLanguagePlugins(object oPC)
{ //Purpose: Executes Language Plugins found on the module
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/6/6
    int n=0;
    string sName;
    string sExecute;

    object oWPLocker = GetObjectByTag(DMFI_FILE_LOCKER);
    sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_NAME + IntToString(n));

    while (sName!="")
    {
        sExecute = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_EXECUTE + sName);
        if ((DMFI_Parse(sExecute, PRM_)!=DMFI_STRING_LANGUAGE) && (sName!=DMFI_STRING_RULE))
            ExecuteScript(sExecute, oPC);

        if (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE)) break;

        n++;
        sName = GetLocalString(oWPLocker, DMFI_PC + DMFI_STRING_LANGUAGE + DMFI_STRING_NAME + IntToString(n));
    }
    return (GetLocalInt(GetModule(), DMFI_STRING_OVERRIDE));
}

void DMFI_StoreTool(object oPC, string sResRef, object oTool)
{	//Purpose: Function to simply delay storing of item to database.
  	//Original Scripter: Demetrious
  	//Last Modified By: Demetrious 11/26/6
		SendText(oPC, TXT_DATABASE_INITIALIZED);
		SetCampaignString(DMFI_DATABASE, DMFI_TOOL_VERSION, MOD_VERSION);
		StoreCampaignObject(DMFI_DATABASE, sResRef, oTool);
}		
	
void DMFI_TransferTempLangData(object oStart, object oFinish)
{	// Purpose: Transfers a listing of languages between two objects
	//Original Scripter: Demetrious
   	//Last Modified By: Demetrious 1/2/7
	int n, nKnown;
	string sLang;
	
	nKnown = GetLocalInt(oStart, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
	for (n=0; n<nKnown; n++)
	{
		sLang = GetLocalString(oStart, DMFI_STRING_LANGUAGE + IntToString(n));	
		SetLocalString(oFinish, DMFI_STRING_LANGUAGE + IntToString(n), sLang);
	}
	SetLocalInt(oFinish, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX, nKnown);
}	

void DMFI_VerifyToolData(object oPC, object oTool)
{ //Purpose: It will add data to tool IF required.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 11/26/6
	if (DMFI_GetIsDM(oPC))
	{
		if (GetElementCount(PG_LIST_MUSIC_NWN2, oTool)==0)
		{
			SendText(oPC, TXT_CREATE_DMTOOL, TRUE, COLOR_GREEN);
			ExecuteScript(DMFI_CONV_DEF, oTool);
			DelayCommand(20.0, DMFI_StoreTool(oPC, DMFI_TOOL_RESREF, oTool));
			DelayCommand(22.0, SendDMText(oPC, TXT_DMTOOL_STORED, TRUE, COLOR_RED));
		}
		else 
			DMFI_InitializeLanguage(oPC, oTool);		
	}
	else
	{
		if (GetElementCount(PG_LIST_10, oTool)==0)
		{
			SendText(oPC, TXT_CREATE_PCTOOL, TRUE, COLOR_GREEN);
			ExecuteScript(DMFI_CONV_DEF_PC, oTool);
			DelayCommand(20.0, DMFI_StoreTool(oPC, DMFI_PCTOOL_RESREF, oTool));
			DelayCommand(22.0, SendTalkText(oPC, PRM_ + TXT_PCTOOL_STORED, COLOR_RED, TALKVOLUME_SHOUT));
		}
		else 
			DMFI_InitializeLanguage(oPC, oTool);			
	}		
}  

//void main() {}