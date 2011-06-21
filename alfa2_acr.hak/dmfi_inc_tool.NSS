////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_tool - DM Friendly Initiative -  Tool oriented subroutines
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/6/6
//                     AcadiusLost   		7/7/2009 edits for ALFA languages
//					   AcadiusLost			7/18/2009 added Yuanti for Oillusk
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

const string MOD_NAME = "dmfi_110";
const string MOD_VERSION = "V110";
const int bTEXTDEBUG = FALSE;

#include "dmfi_inc_conv"
#include "dmfi_inc_const"
#include "dmfi_inc_sendtex"

// ******* FOR TRANSLATIONS - CHANGE THIS TO MATCH YOUR TRANSLATION FILE *******
#include "dmfi_inc_english"


// ************************** DECLARATIONS *************************************

// FILE: dmfi_inc_tool
// Function to add a DMFI conversation element.  oHolder is the holder of the conversation
// data.  sPage is the list or page.  sResponse is the conversation response that
// will be displayed in nColor.  sCommand is the command for that response -
// typically a different page, a stated command, or blank for lists.
int DMFI_AddConversationElement(object oHolder, string sPage, string sResponse, string sCommand="", int nColor=-1);

// FILE: dmfi_inc_tool
// Add a page header to the DMFI Conversation.  You still need to add responses
// via DMFI_AddConversationElement to build the conversation page.
int DMFI_AddPage(object oHolder, string sPage);

// FILE: dmfi_inc_tool    Builds a list of the names / labels from a 2da file onto
// the users DMFI Tool.  Just use the DMFI_2DA constant - you don't have to worry
// about which column or converting to / from StrRef - this function handles all
// that automatically.
void DMFI_Build2DAList(object oTool, string sPage, string sFileName);

// FILE: dmfi_inc_tool    Builds a listing of effects on a particular target onto the
// users DMFI tool
void DMFI_BuildEffectList(object oTool, object oTarget);

// FILE: dmfi_inc_tool
// Builds a complete listing of all possible effects onto oTool.
void DMFI_BuildEffectsPossList(object oTool);

// FILE: dmfi_inc_tool    Builds a listing of ItemProps on a particular target onto
// the users DMFI tool
void DMFI_BuildItemPropList(object oTool, object oTarget);

// FILE: dmfi_inc_tool
// Builds a list of oPCs known languages onto oTool.
void DMFI_BuildLanguageList(object oTool, object oPC);

// FILE: dmfi_inc_tool
// Returns sWord with the first letter as an upper case
string DMFI_CapitalizeWord(string sWord);

// FILE: dmfi_inc_tool
// Checks for DM status EITHER as DM or by Possession
int DMFI_GetIsDM(object oPC);

// FILE: dmfi_inc_tool
// Returns the appropriate tool for oPC regardless of possession issues.
object DMFI_GetTool(object oPC);

// FILE: dmfi_inc_tool
// Returns TRUE if sWord is a number string.  Used to tell if a parsed string is
// a number value or a string.  It is required because 0 is a valid number in  the
// dynamic conversation.
int DMFI_IsNumber(string sWord);

// FILE: dmfi_inc_tool      FUNCTION: DMFI_Parse()
// This function when passed a string will return the first
// part of the string that occurs before the sDelimiter is found.
// EXAMPLE: If "This is a test. See what I mean?" were passed to
// this function it would return "This is a test" because, that is
// the portion of the string that occurs before the delimiter which
// by default is "."  NOTE:  Only works when a SINGLE CHARACTER Delimiter
// is used - DMFI_Parse(sIn, "**") is not valid.
string DMFI_Parse(string sIn,string sDelimiter=".");

// FILE: dmfi_inc_tool      FUNCTION: DMFI_RemoveParsed()
// This function will remove the sParsed string from sIn.
// This is generally used as a follow-up to the DMFI_Parse()
// function so as to clean off the portion of the string that
// has already been parsed.
string DMFI_RemoveParsed(string sIn,string sParsed,string sDelimiter=".");

// FILE: dmfi_inc_tool
// Removes sPrefix from sIn and returns the result
string DMFI_RemovePrefix(string sIn, string sPrefix);

// FILE: dmfi_inc_tool
// Sorts the large VFX data into 4 different subsets
void DMFI_SortVFXList(string sResult, int n, object oTool);

// FILE: dmfi_inc_tool
// This function will toggle a DMFI Prefernce.  sCommand is the type of command
// you wish to toggle (ie "detail").  It is called from the dmfi_exe_conv to
// refresh conversation tokens and also called from dmfi_exe_main.
// NUMBER preference values are set via a page call to a number listing so they
// are not included in this technique - ie they are not toggles.
// Returns the new value set to the appropriate variable.
string DMFI_TogglePreferences(object oTool, string sCommand);

// FILE: dmfi_inc_tool
// Function handles setting the speaker and target.  It is required for possession
// states on the player side and DM client side.  It returns the current controlled 
// character of the PC client that hit the UI button or typed the text.
object DMFI_UITarget(object oPC, object oTool);

// FILE: dmfi_inc_tool
// Returns sInput with spaces for underscores.  Needed for UI support.
string DMFI_UnderscoreToSpace(string sInput);

// FILE: dmfi_inc_tool
// Updates a number value CUSTOM TOKEN.  Similiar to DMFI_TogglePreferences which
// updates a string value.
void DMFI_UpdateNumberToken(object oTool, string sCommand, string sNewValue);

string DMFI_GetSoundString(int nValue, string sParam);

string DMFI_GetEffectString(string sValue);

// ************************** FUNCTIONS ****************************************

int DMFI_AddConversationElement(object oHolder, string sPage, string sResponse, string sCommand="", int nColor=-1)
{  //Purpose: Function used to set up the DMFI conversation
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 9/20/6
    if (nColor!=-1)
        sResponse = ColorText(sResponse, nColor);
		// CODE currently removed because of bug with color coding in conversations.

    int nCount = GetElementCount( sPage, oHolder );
    SetLocalString(oHolder, IndexToString(nCount, sPage ), sResponse);
    if (sCommand!="")
    {
        SetLocalString(oHolder, IndexToString(nCount, sPage + PRM_COM), sCommand);
        SetLocalInt(oHolder, LIST_PREFIX + sPage + PRM_COM, nCount+1);
    }
    nCount++;
    SetLocalInt( oHolder, LIST_PREFIX + sPage, nCount);
    return (nCount);
}

int DMFI_AddPage(object oHolder, string sPage)
{  //Purpose: Adds a new page to the DMFI Conversation
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 6/21/6
   int n = GetLocalInt(oHolder, DMFI_PAGES);
   SetLocalString(oHolder, DMFI_PAGE + IntToString(n), sPage);
   SetLocalInt(oHolder, DMFI_PAGES, n+1);
   return n+1;
}

void DMFI_BuildAppearanceList(object oTool)
{  //Purpose: Builds a list of appearance options.
   //Original Scripter:  Demetrious via Excel - sorry it is ugly
   // Further manual cleaning for missing values despite 2da 
   //Last Modified: 1/27/7
	int	n=0;
	AddStringElement(DMFI_Default , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, -1, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Assimar , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 563, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Badger , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 8, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Badger_Dire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 9, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Bat , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 10, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Bear_Brown , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 13, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Bear_Dire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 15, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Bear_Polar , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 14, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Beetle , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 484, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Beetle_Bombadier , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 538, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Beetle_Fire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 18, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Beetle_Stag , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 19, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Beholder , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 401, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Bird , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 485, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Bladeling , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 486, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Bladeling_Warrior_A , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 548, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Boar , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 21, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Boar_Dire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 22, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Bodak , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 23, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Bugbear , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 543, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_CargoShip , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 572, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Cat , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 487, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Cat_Panther , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 202, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Chicken , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 31, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Cow , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 34, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Deer , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 35, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Deer_Stag , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 37, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Demon_Balor , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 522, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Demon_Hezrou , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 488, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Demon_Marilith , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 519, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Devil_Deva , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 515, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Devil_Erinyes , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 514, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Devil_Horned , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 481, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Devil_PitFiend , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 489, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dog_Dire_Wolf , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 175, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dog_Hell_Hound , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 179, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Dog_Shadow_Mastif , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 180, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dog_Winter_Wolf , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 184, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dog_Wolf , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 181, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Doppleganger , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 511, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dragon_Black , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 41, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Dragon_Pseudo , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 375, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dragon_Red , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 49, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dryad , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 51, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Dwarf , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 0, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Elemental_Air , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 52, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Elemental_Earth , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 56, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Elemental_Fire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 60, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Elemental_Water , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 69, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Elf , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Eyeball , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 490, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Faerie_Dragon , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 374, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Gargoyle , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 73, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Ghast , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 74, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Ghost , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 523, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Ghoul , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 76, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Giant_Fire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 80, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Giant_Frost , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 81, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Githyanki , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 483, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Githyanki_Female , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 545, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Githzerai , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 491, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Gnoll , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 533, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Gnome , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 2, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Goblin , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 534, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Golem_Blade , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 493, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Golem_Iron , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 89, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Half_Orc , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 5, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_HalfDragon , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 526, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_Black_Stallion , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 539, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_Brown , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 495, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_Palomino , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 541, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_Pinto , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 542, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_White_Stallion , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 540, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_Nightmare , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 496, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Horse_Skeletal , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 532, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_HoundArchon , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 525, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Imp , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 105, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Kobold , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 535, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Lantern_Archon , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 103, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Lich , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 39, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Lizardfolk , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 536, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Mephit_Fire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 109, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Mephit_Ice , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 110, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Mindflayer , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 413, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Mummy_Common , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 58, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Nightshade_Nightwalker , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 497, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Ahja , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 590, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Aldanon , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 595, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_NPC_AmmonJerro , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 552, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_ChildHHF , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 553, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_ChildHHM , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 551, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Ctann , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 582, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Duncan , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 549, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Durler , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 591, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Garius , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 544, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_GithCaptain , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 579, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Hezebel , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 592, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_HostTower , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 593, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_HunterStaute , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 607, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Jacoby , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 596, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Jalboun , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 597, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Kharlever , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 598, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_KingofShadows , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 586, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Kralwok , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 599, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_LordNasher , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 550, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Lorne , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 580, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Mephasm , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 600, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Morkai , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 601, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Nolaloth , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 587, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Sarya , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 602, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Shandra , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 583, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Sydney , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 603, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Tenavrok , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 581, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_TorioClaven , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 604, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Uthanck , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 605, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Zaxis , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 589, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Zeeaire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 584, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Zees_Lt , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 585, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Zhjaeve , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 588, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_NPC_Zokan , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 594, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Nymph , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 126, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Ogre , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 127, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Ogre_Mage , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 129, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Orc_A , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 140, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Pig , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 498, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Pixie , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 521, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_PushBlock , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 609, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Rabbit , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 499, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Rakshasas , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 524, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Rat , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 386, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Rat_Dire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 387, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Salamander , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 520, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Shadow , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 146, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Shadow_Reaver , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 500, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Siegetower , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 562, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_SiegetowerB , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 608, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Sirene , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 513, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Skeleton , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 537, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Skeleton_Common , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 63, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_SmugglerWagon , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 610, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Spectre , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 156, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Blade , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 161, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Dire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 158, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Giant , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 159, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Glow , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 546, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Kristal , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 547, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Phase , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 160, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Spider_Wraith , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 162, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Succubus , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 163, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Sylph , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 512, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Tiger , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 501, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Tiger_Dire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 502, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Troll , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 167, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Troll_Forest , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 516, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Troll_War , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 517, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Umberhulk , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 168, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Vampire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 529, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Vampire_Hd_Female , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 527, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Vampire_Hd_Male , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 528, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Vampire_Female , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 288, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Vampire_Male , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 289, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Weasel , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 503, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Werewolf , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 171, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Will_O_Wisp , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 116, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Wraith , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 187, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Wyvern_Blade , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 504, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Wyvern_Crown , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 505, PG_LIST_APPEARANCE, oTool); n++;
//	AddStringElement(DMFI_Wyvern_Horn , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 506, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Zombie , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 198, PG_LIST_APPEARANCE, oTool); n++;
    //Qk: Added for Motb appearances
	//AddStringElement(DMFI_Akachi , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1000, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Okku , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1001, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Panther , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1002, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Wolverine , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1003, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_InvisibleStalker , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1004, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Homunculus , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1005, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_GolemImaskari , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1006, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_RedWizCompanion , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1007, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_DeathKnight , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1008, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_BarrowGuardian , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1009, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_SeaMonster , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1010, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_OneOfMany , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1011, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_ShamblingMoud , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1012, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_Solar , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1013, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_WolverineDire , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1014, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_DragonBlue , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1015, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Djinn , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1016, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_GnollThayan , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1017, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_GolemClay , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1018, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_GolemFaithless , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1019, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Demilich , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1020, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_HagAnnis , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1021, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_HagGreen , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1022, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_HagNight , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1023, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_HorseWhite , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1024, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_DemilichSmall, PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1025, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_LeopardSnow , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1026, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Treant , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1027, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_TrollFell , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1028, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Uthraki , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1029, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_Wyvern , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1030, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_RavenousIncarnation , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1031, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_ElfWild , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1032, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_HalfDrow , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1033, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_Magda , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1034, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_Nefris , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1035, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_ElfWild2 , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1036, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_EarthGenasi , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1037, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_FireGenasi , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1038, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_AirGenasi , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1039, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_WaterGenasi , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1040, PG_LIST_APPEARANCE, oTool); n++;
	//AddStringElement(DMFI_HalfDrow2 , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1041, PG_LIST_APPEARANCE, oTool); n++;
	AddStringElement(DMFI_DogWolfTheltor , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1042, PG_LIST_APPEARANCE, oTool); n++;
    //AddStringElement(DMFI_HagSpawn , PG_LIST_APPEARANCE, oTool); ReplaceIntElement(n, 1043, PG_LIST_APPEARANCE, oTool); n++;	
}


void DMFI_Build2DAASoundsList()
{	//Purpose: Build a list of the ambeintsounds onto oTool
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 11/22/6
	string sResult, sResource;
    int n=1;		// File starts with 1
		
	while (n<148)
	{
		sResult = Get2DAString("ambientsound", "Description", n);
		sResource = Get2DAString("ambientsound", "Resource", n);
		sResult=GetStringByStrRef(StringToInt(sResult));
		if (FindSubString(sResource, "_pl_")!=-1)
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_AMBIENT_PEOPLE);	
			AddReplyLinkInt(sResult, "", -1, n);
		}
		else if (FindSubString(sResource, "_cv_")!=-1)
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_AMBIENT_CAVE);	
			AddReplyLinkInt(sResult, "", -1, n);
		}
		else if ((FindSubString(sResource, "_na_")!=-1) || (FindSubString(sResource, "_mg_")!=-1))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_AMBIENT_MAGIC);	
			AddReplyLinkInt(sResult, "", -1, n);
		}
		else
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_AMBIENT_MISC);	
			AddReplyLinkInt(sResult, "", -1, n);
		}
		
		n++;
		if (n==95) n++;  //deal with padding
	}
}	
void DMFI_Build2DAAMusicList()
{	//Purpose: Build a list of the ambientmusic onto oTool
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 11/22/6
	string sResult;
    int n=1;		// File starts with 1
	
	while (n<168)
	{
		sResult = Get2DAString("ambientmusic", "Description", n);
		sResult=GetStringByStrRef(StringToInt(sResult));
		if (n<34)
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_MUSIC_NWN1);
			AddReplyLinkInt(sResult, "", -1, n);
		}
		else if (((n>33) &&  (n<49))  || (n==60) || (n==57) || ((n>69) &&  (n<76)))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_MUSIC_BATTLE);
			AddReplyLinkInt(sResult, "", -1, n);
		}
		else if ((n>94)&&(n<117))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_MUSIC_NWN2);
			AddReplyLinkInt(sResult, "", -1, n);
		}
		//modified qk 10/07/07
		else if ((n>125))
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_MUSIC_MOTB);
			AddReplyLinkInt(sResult, "", -1, n);
		}
		else 
		{
			SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_MUSIC_XP);
			AddReplyLinkInt(sResult, "", -1, n);
		}
	
		n++;
		if (n==76) n=95;	//deal with padding
		if (n==100) n++;	//deal with padding
	}
}			

void DMFI_Build2DAList(object oTool, string sPage, string sFileName)
{   //Purpose: Build a list of the 2da file sFile onto oTool
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 11/22/6
        string sColumn;
        string sResult;
        int n=0;
        // Handle special exceptions to the Label rule
        if (sFileName == "polymorph")
            sColumn = "Name";
        else
            sColumn = "Label";
        sResult = Get2DAString(sFileName, sColumn, n);
        while (sResult!="")
        {
            // Process the StrRef numbers for the exceptions of ambientmusic/ambientsound
            if ((sFileName=="ambientmusic") || (sFileName=="ambientsound"))
                sResult=GetStringByStrRef(StringToInt(sResult));
            
			//NWN2 edit - ignore any deleted data.
			if (GetStringLeft(sResult, 4)!="DEL_")
			{
				//SendMessageToPC(GetFirstPC(), "DEBUG: 2da data: "+ IntToString(n) + " : " + sResult);
				AddStringElement (sResult, sPage , oTool);
            }
			n++;
            sResult = Get2DAString(sFileName, sColumn, n);
        }
        // Assume right here that the 2da file is stagnant while the server is up.
        // May need to add a command to reset a 2da data file - ie delete this int.
        SetLocalInt(oTool, DMFI_2DA_ON_TOOL + sPage, 1);
}

void DMFI_BuildEffectList(object oTool, object oTarget)
{   //Purpose: Build a list of effects on oTarget onto oTool
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 6/23/6
    effect eEffect = GetFirstEffect(oTarget);
    int n=0;
    int nEffect;
    while (GetIsEffectValid(eEffect))
    {
        nEffect = GetEffectType(eEffect);
        AddStringElement(DMFI_GetEffectString(IntToString(nEffect)), PG_TARGET_EFFECT, oTool);
        ReplaceIntElement(n, nEffect, PG_TARGET_EFFECT, oTool);
        n++;
        eEffect = GetNextEffect(oTarget);
    }
    if (n==0)
        AddStringElement(TXT_NO_EFFECT, PG_TARGET_EFFECT, oTool);
} // DMFI_BuildEffectList()

void DMFI_BuildEffectsPossList(object oTool)
{   //Purpose: Build a complete list of possible effects that can be applied.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 6/25/6
    string sEffect;
    int n=1;

    sEffect = DMFI_GetEffectString(IntToString(n));

    while (sEffect!="")
    {
        AddStringElement(sEffect, PG_LIST_EFFECT, oTool);
        n++;
        sEffect = DMFI_GetEffectString(IntToString(n));
    }
}

void DMFI_BuildLanguageDMList(object oTool)
{  // Complete listing of languages AND grouping data

	SetLocalInt(oTool, LNG_COMMON, 0);
	SetLocalInt(oTool, LNG_ABYSSAL, 1);	
	SetLocalInt(oTool, LNG_ALGARONDAN, 1);	
	SetLocalInt(oTool, LNG_ALZHEDO, 1);	
	SetLocalInt(oTool, LNG_ANIMAL, 1);
	SetLocalInt(oTool, LNG_AQUAN, 1);
	SetLocalInt(oTool, LNG_ASSASSIN, 1);	
	SetLocalInt(oTool, LNG_AURAN, 1);	
	SetLocalInt(oTool, LNG_CANT, 2);	
	SetLocalInt(oTool, LNG_CELESTIAL, 2);	
	SetLocalInt(oTool, LNG_CHESSENTAN, 2);
	SetLocalInt(oTool, LNG_CHONDATHAN, 2);	
	SetLocalInt(oTool, LNG_CHULTAN, 2);	
	SetLocalInt(oTool, LNG_DAMARAN, 3);	
	SetLocalInt(oTool, LNG_DAMBRATHAN, 3);	
	SetLocalInt(oTool, LNG_DRACONIC, 3);
	SetLocalInt(oTool, LNG_DROW, 3);	
	SetLocalInt(oTool, LNG_DROWSIGN, 3);	
	SetLocalInt(oTool, LNG_DRUIDIC, 3);	
	SetLocalInt(oTool, LNG_DURPARI, 3);	
	SetLocalInt(oTool, LNG_DWARF, 3);
	SetLocalInt(oTool, LNG_ELVEN, 4);	
	SetLocalInt(oTool, LNG_GIANT, 4);	
	SetLocalInt(oTool, LNG_GNOLL, 4);	
	SetLocalInt(oTool, LNG_GNOME, 4);	
	SetLocalInt(oTool, LNG_GOBLIN, 4);
	SetLocalInt(oTool, LNG_HALARDRIM, 5);	
	SetLocalInt(oTool, LNG_HALFLING, 5);	
	SetLocalInt(oTool, LNG_HALRUAAN, 5);	
	SetLocalInt(oTool, LNG_IGNAN, 5);
	SetLocalInt(oTool, LNG_ILLUSKAN, 5);
	SetLocalInt(oTool, LNG_IMASKAR, 5);	
	SetLocalInt(oTool, LNG_INFERNAL, 5);	
	SetLocalInt(oTool, LNG_LANTANESE, 6);	
	SetLocalInt(oTool, LNG_LEETSPEAK, 6);
	SetLocalInt(oTool, LNG_LOROSS, 6); // ALFA addition	
	SetLocalInt(oTool, LNG_MIDANI, 6);
	SetLocalInt(oTool, LNG_MULHORANDI, 6);
	SetLocalInt(oTool, LNG_NETHERESE, 6); // ALFA addition	
	SetLocalInt(oTool, LNG_NEXALAN, 9);	
//	SetLocalInt(oTool, LNG_OILLUSK, 9);	ALFA edit
	SetLocalInt(oTool, LNG_ORC, 9);	
	SetLocalInt(oTool, LNG_RASHEMI, 7);
//	SetLocalInt(oTool, LNG_RAUMVIRA, 7); // ALFA edit	
	SetLocalInt(oTool, LNG_SERUSAN, 7);	
	SetLocalInt(oTool, LNG_SHAARAN, 7);	
	SetLocalInt(oTool, LNG_SHOU, 7);	
	SetLocalInt(oTool, LNG_SYLVAN, 7);
//	SetLocalInt(oTool, LNG_TALFIRIC, 8); // ALFA edit
	SetLocalInt(oTool, LNG_TASHALAN, 8);	
	SetLocalInt(oTool, LNG_TERRAN, 8);	
	SetLocalInt(oTool, LNG_TREANT, 8);	
	SetLocalInt(oTool, LNG_TUIGAN, 8);	
	SetLocalInt(oTool, LNG_TURMIC, 8);
	SetLocalInt(oTool, LNG_ULUIK, 9);	
	SetLocalInt(oTool, LNG_UNDERCOMMON, 9);	
	SetLocalInt(oTool, LNG_UNTHERIC, 9);	
	SetLocalInt(oTool, LNG_VAASAN, 9);
	SetLocalInt(oTool, LNG_YUANTI, 9);	// ALFA addition
	
	AddStringElement(DMFI_CapitalizeWord(LNG_COMMON), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_ABYSSAL), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_ALGARONDAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_ALZHEDO), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_ANIMAL), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_AQUAN), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_ASSASSIN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_AURAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_CANT), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_CELESTIAL), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_CHESSENTAN), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_CHONDATHAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_CHULTAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DAMARAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DAMBRATHAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DRACONIC), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_DROW), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DROWSIGN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DRUIDIC), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DURPARI), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_DWARF), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_ELVEN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_GIANT), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_GNOLL), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_GNOME), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_GOBLIN), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_HALARDRIM), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_HALFLING), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_HALRUAAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_IGNAN), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_ILLUSKAN), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_IMASKAR), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_INFERNAL), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_LANTANESE), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_LEETSPEAK), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_LOROSS), PG_LIST_DMLANGUAGE, oTool);	// ALFA addition
	AddStringElement(DMFI_CapitalizeWord(LNG_MIDANI), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_MULHORANDI), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_NETHERESE), PG_LIST_DMLANGUAGE, oTool);	// ALFA addition	
	AddStringElement(DMFI_CapitalizeWord(LNG_NEXALAN), PG_LIST_DMLANGUAGE, oTool);	
//	AddStringElement(DMFI_CapitalizeWord(LNG_OILLUSK), PG_LIST_DMLANGUAGE, oTool);	 ALFA edit
	AddStringElement(DMFI_CapitalizeWord(LNG_ORC), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_RASHEMI), PG_LIST_DMLANGUAGE, oTool);
//	AddStringElement(DMFI_CapitalizeWord(LNG_RAUMVIRA), PG_LIST_DMLANGUAGE, oTool);	 ALFA edit
	AddStringElement(DMFI_CapitalizeWord(LNG_SERUSAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_SHAARAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_SHOU), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_SYLVAN), PG_LIST_DMLANGUAGE, oTool);
//	AddStringElement(DMFI_CapitalizeWord(LNG_TALFIRIC), PG_LIST_DMLANGUAGE, oTool);  ALFA edit	
	AddStringElement(DMFI_CapitalizeWord(LNG_TASHALAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_TERRAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_TREANT), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_TUIGAN), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_TURMIC), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_ULUIK), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_UNDERCOMMON), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_UNTHERIC), PG_LIST_DMLANGUAGE, oTool);	
	AddStringElement(DMFI_CapitalizeWord(LNG_VAASAN), PG_LIST_DMLANGUAGE, oTool);
	AddStringElement(DMFI_CapitalizeWord(LNG_YUANTI), PG_LIST_DMLANGUAGE, oTool); // ALFA addition
}

void DMFI_BuildLanguageList(object oTool, object oPC)
{   //Purpose: Build a complete list of oPCs known languages
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 7/10/6
    int n;
    string sLang;
    int nMax = GetLocalInt(oTool, DMFI_STRING_LANGUAGE + DMFI_STRING_MAX);
    for (n=0; n<nMax; n=n+1)
    {
        sLang = DMFI_CapitalizeWord(GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n)));
        AddStringElement(sLang, PG_LIST_LANGUAGE, oTool);
    }
    if (nMax<1)
        AddStringElement(TXT_NO_LANGUAGE, PG_LIST_LANGUAGE, oTool);
}

void DMFI_BuildPlaceableSoundList(object oTool)
{	//Purpose: Build a list of sounds that we can play
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 10/15/6
    
	int n = 1;
	string sSound;
		
	for (n=0; n<21; n++)
	{
		sSound = DMFI_GetSoundString(n, PRM_CITY);
		AddStringElement(sSound, PG_LIST_SOUND_CITY, oTool);
		AddStringElement(GetLocalString(GetModule(), DMFI_TEMP), "DISPLAY" + PG_LIST_SOUND_CITY, oTool);
	}
	n=0;
	for (n=0; n<38; n++)
	{
		sSound = DMFI_GetSoundString(n, PRM_NATURE);
		AddStringElement(sSound, PG_LIST_SOUND_NATURE, oTool);
		AddStringElement(GetLocalString(GetModule(), DMFI_TEMP), "DISPLAY" + PG_LIST_SOUND_NATURE, oTool);
	}
	n=0;
	for (n=0; n<30; n++)
	{
		sSound = DMFI_GetSoundString(n, PRM_PEOPLE);
		AddStringElement(sSound, PG_LIST_SOUND_PEOPLE, oTool);
		AddStringElement(GetLocalString(GetModule(), DMFI_TEMP), "DISPLAY" + PG_LIST_SOUND_PEOPLE, oTool);
		
	}	
	n=0;
	for (n=0; n<20; n++)
	{
		sSound = DMFI_GetSoundString(n, PRM_MAGICAL);
		AddStringElement(sSound, PG_LIST_SOUND_MAGICAL, oTool);
		AddStringElement(GetLocalString(GetModule(), DMFI_TEMP), "DISPLAY" + PG_LIST_SOUND_MAGICAL, oTool);
	}	
}

void DMFI_BuildRecentVFXList(object oTool)
{	//Purpose: Build a list of recent VFX data
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/18/6
	int n=0;
	int nTest, nCurrent, nLength;
	string sVFXLabel;
	while (n<30)
	{
		nTest = GetLocalInt(oTool, DMFI_VFX_RECENT + IntToString(n));
	    if (nTest==0) break;
		
		sVFXLabel = Get2DAString(DMFI_2DA_VFX, DMFI_2DA_COLUMN, nTest);
		nCurrent = AddStringElement(sVFXLabel, PG_LIST_VFX_RECENT, oTool);
		ReplaceIntElement(nCurrent-1, nTest, PG_LIST_VFX_RECENT, oTool);
		
		n++;
	}
			
	if (n==0)
       AddStringElement(TXT_NO_VALID_OBJECT, PG_LIST_VFX_RECENT, oTool);
}			

void DMFI_BuildVFXList(object oTool)
{	//Purpose: Build a list of VFX data - cleaning up Obsidians work as we go.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 11/11/6
	string sResult;
	int n = 0;

	while (n<18)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
		if ((n==4) || (n==16))	n++;
	}	
	n=22;
	sResult = Get2DAString("visualeffects", "Label", n);
	DMFI_SortVFXList(sResult, n, oTool);	
	n=24;
	sResult = Get2DAString("visualeffects", "Label", n);
	DMFI_SortVFXList(sResult, n, oTool);	
	n=32;
	sResult = Get2DAString("visualeffects", "Label", n);
	DMFI_SortVFXList(sResult, n, oTool);
	n=33;
	sResult = Get2DAString("visualeffects", "Label", n);
	DMFI_SortVFXList(sResult, n, oTool);		
	n=40;
	sResult = Get2DAString("visualeffects", "Label", n);
	DMFI_SortVFXList(sResult, n, oTool);
	n=408;	
	while (n<424)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=153;	
	while (n<193)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
		if (n==181) n++;
	}	
	n=512;
	while (n<550)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=551;
	while (n<600)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=601;
	while (n<650)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=651;
	while (n<701)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=701;
	while (n<751)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
		if (n==741) n=750;
	}
	n=751;
	while (n<800)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=801;
	while (n<851)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
	n=851;
	while (n<916)
	{
		sResult = Get2DAString("visualeffects", "Label", n);
		DMFI_SortVFXList(sResult, n, oTool);
		n++;
	}
}		

string DMFI_CapitalizeWord(string sWord)
{  //Purpose: Will return a capitalized version of sWord.  Will cap any word
   // following a space and includes special cases like PC.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 6/18/6

// Special Cases
   if (sWord=="pc") return "PC";
   else if (sWord=="dm") return "DM";
   else if (sWord=="dc") return "DC";

// Routine Phrases
 	int nLength = GetStringLength(sWord);
    string sReturn = GetStringUpperCase(GetStringLeft(sWord, 1)) + GetStringRight(sWord, nLength-1);
	
	return sReturn;
}

void DMFI_ClearUIData(object oPC)
{
	DeleteLocalInt(oPC, DMFI_REQ_INT);
	DeleteLocalString(oPC, DMFI_LAST_UI_COM);
	DeleteLocalString(oPC, DMFI_UI_PAGE);
}	


int DMFI_GetIsDM(object oPC)
{   //Purpose: Returns true if oPC is a DM or possessing a creature
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 11/6/6
    int nTemp = GetLocalInt(oPC, DMFI_DM_STATE);
	
	int nReturn = nTemp || (GetIsDM(oPC) || (GetIsDMPossessed(oPC)));
    return nReturn;
}

object DMFI_GetTool(object oPC)
{ //Purpose: Returns the appropriate tool for oPC regardless of possession issues.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/23/6
  object oTool, oAssociate;
  if (DMFI_GetIsDM(oPC))
  {
	  
  	  if (GetIsDMPossessed(oPC))
	        oTool = GetLocalObject(GetMaster(oPC), DMFI_TOOL);
	  else
	        oTool = GetLocalObject(oPC, DMFI_TOOL);
	  //SendText(oPC, "DEBUG: DM GetTool: " + GetName(oTool));		
  }	
  else
  {
  	if (GetIsPossessedFamiliar(oPC))
		oTool = GetLocalObject(GetMaster(oPC), DMFI_TOOL);
	else
		oTool = GetLocalObject(oPC, DMFI_TOOL);
	//SendText(oPC, "DEBUG: PC GetTool: " + GetName(oTool));		
  }			
 		
  return oTool;
}

int DMFI_IsNumber(string sWord)
{   //Purpose: Returns whether sWord is a number or not
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 6/20/6
    int n;
    string sTest;

    n = StringToInt(sWord);
    sTest = IntToString(n);

    if (sWord!=sTest)
        return FALSE;

    return TRUE;
}

string DMFI_Parse(string sIn,string sDelimiter=".")
{ // PURPOSE: To find portion of string that occurs before sDelimiter
  // Original Scripter: Deva B. Winblood
  // Last Modified By: Deva B. Winblood  04/24/2006
  string sRet="";
  int nPos=0;
  string sRead=GetStringLeft(sIn,1);
  while(nPos<GetStringLength(sIn)&&sRead!=sDelimiter)
  { // read
    sRet=sRet+sRead;
    nPos++;
    sRead=GetSubString(sIn,nPos,1);
  } // read
  return sRet;
} // DMFI_Parse()

string DMFI_RemovePrefix(string sIn, string sPrefix)
{ // PURPOSE: Removes sPrefix from sIn and returns the result
  // Original Scripter: Demetrious
  // Last Modified By: Demetrious  6/26/6
  string sReturn;
  int nLength = GetStringLength(sIn);
  int nPrefixLength = GetStringLength(sPrefix);
  sReturn = GetStringRight(sIn, nLength - nPrefixLength);

  return sReturn;
}

string DMFI_RemoveParsed(string sIn,string sParsed,string sDelimiter=".")
{ // PURPOSE: To remove the parsed portion of the string
  // Original Scripter: Deva B. Winblood
  // Last Modified By: Deva B. Winblood   04/24/2006
  string sRet="";
  if (GetStringLength(sParsed)<=GetStringLength(sIn))
  { // okay lengths
    sRet=GetStringRight(sIn,GetStringLength(sIn)-GetStringLength(sParsed));
    while(GetStringLeft(sRet,1)==sDelimiter&&GetStringLength(sDelimiter)>0)
    { // strip prefix delimiter
      sRet=GetStringRight(sRet,GetStringLength(sRet)-1);
    } // strip prefix delimiter
  } // okay lengths
  return sRet;
} // DMFI_RemoveParsed()

void DMFI_SetItemPrompt(object oTool, object oItem)
{  //Purpose: Sets Item Data for Prompt
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 11/26/6
	string sItemProps;
	
	if (GetItemCursedFlag(oItem))
		sItemProps = sItemProps + TXT_CURSED + PRM_;
	if (GetPlotFlag(oItem))
		sItemProps = sItemProps + TXT_PLOT + PRM_;
	if (GetStolenFlag(oItem))
		sItemProps = sItemProps + TXT_STOLEN;
				
	SetLocalString(oTool, DMFI_ITEM_PROPS, sItemProps);
}	

void DMFI_ShowDMListUI(object oPC, string sScreen=SCREEN_DMFI_DMLIST)
{ //Purpose: Shows the DM list - builds the 30 entries and handles page updates.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/27/6
	
    string sDMListTitle;
	string sPage, sTest, sTitle;
	int nPage, n, nCurrent, nModal;
	object oTool = DMFI_GetTool(oPC);

	if (sScreen==SCREEN_DMFI_CHOOSE)
		nModal=TRUE;
	else
		nModal=FALSE;
			
	DisplayGuiScreen(oPC, sScreen, nModal, "dmfidmlist.xml");
	sPage = GetLocalString(oPC, DMFI_UI_PAGE);
	sTitle = GetLocalString(oPC, DMFI_UI_LIST_TITLE);
	SetGUIObjectText(oPC, sScreen, "DMListTitle", -1, sTitle);
	
	nPage = GetLocalInt(oPC, sPage + DMFI_CURRENT);
		
	n = 0;
	while (n<31)
	{
		nCurrent = (nPage*30) + n;
		sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
		
		if (sTest!="")
		{
			SetGUIObjectText(oPC, sScreen, DMFI_UI_DMLIST+IntToString(n+1), -1, sTest);
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), FALSE);
		}	
		else
		{
			SetGUIObjectText(oPC, sScreen, DMFI_UI_DMLIST+IntToString(n+1), -1, "");
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), TRUE);
		}	
		n++;
	}
		
	//next and previous buttons
	sTest = GetLocalString(oTool, LIST_PREFIX + sPage + "." + IntToString(nCurrent));
	
	if ((sTest=="")	|| (sScreen!=SCREEN_DMFI_DMLIST))
		SetGUIObjectHidden(oPC, sScreen, "btn-next", TRUE);
	else
		SetGUIObjectHidden(oPC, sScreen, "btn-next", FALSE);	
			
	if ((nPage==0) || (sScreen!=SCREEN_DMFI_DMLIST)) 
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", TRUE);
	else 
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", FALSE);	
}

void DMFI_SortVFXList(string sResult, int n, object oTool)
{	//Purpose: Sorts VFX data into 4 separate pages.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 11/11/6
	int nCurrent;
	int nLength;
		
	if (FindSubString(sResult, "_SPELL_")!=-1)
	{
		nLength = GetStringLength(sResult);
		sResult = GetStringRight(sResult, nLength-14);
		nCurrent = AddStringElement(sResult, PG_LIST_VFX_SPELL, oTool);
		ReplaceIntElement(nCurrent-1, n, PG_LIST_VFX_SPELL, oTool);
	}
	else if (FindSubString(sResult, "_DUR_")!=-1) 
	{
		nLength = GetStringLength(sResult);
		sResult = GetStringRight(sResult, nLength-8);
		nCurrent = AddStringElement(sResult, PG_LIST_VFX_DUR, oTool);
		ReplaceIntElement(nCurrent-1, n, PG_LIST_VFX_DUR, oTool);
	}
	else if ((FindSubString(sResult, "_IMP_")!=-1) || (FindSubString(sResult, "_INVOCATION_")!=-1))
	{
		if (FindSubString(sResult, "VFX_INVOCATION")!=-1) 
			sResult = GetStringRight(sResult, GetStringLength(sResult)-17);
		else
		{
			nLength = GetStringLength(sResult);
			sResult = GetStringRight(sResult, nLength-8);
		}		
		nCurrent = AddStringElement(sResult, PG_LIST_VFX_IMP, oTool);
		ReplaceIntElement(nCurrent-1, n, PG_LIST_VFX_IMP, oTool);
	}	
	else
	{
		nLength = GetStringLength(sResult);
		sResult = GetStringRight(sResult, nLength-8);
		nCurrent = AddStringElement(sResult, PG_LIST_VFX_MISC, oTool);
		ReplaceIntElement(nCurrent-1, n, PG_LIST_VFX_MISC, oTool);
	}
}

void DMFI_ToggleItemPrefs(string sCommand, object oPC, object oTarget)
{  //Purpose: Toggles the custom token for the item target page
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 11/26/6
    int nTest;
   	string sItemProps, sText;
	object oRef = GetLocalObject(oTarget, DMFI_INVENTORY_TARGET);
		
	if (FindSubString(sCommand, PRM_CURSED)!=-1) 
	{
		nTest = GetItemCursedFlag(oTarget);		
		SetItemCursedFlag(oTarget, !nTest);
		SetItemCursedFlag(oRef, !nTest);
	}	
	else if (FindSubString(sCommand, PRM_PLOT)!=-1) 
	{
		nTest = GetPlotFlag(oTarget);		
		SetPlotFlag(oTarget, !nTest);
		SetPlotFlag(oRef, !nTest);
	}
	else if (FindSubString(sCommand, PRM_STOLEN)!=-1)
	{
		nTest = GetStolenFlag(oTarget);		
		SetStolenFlag(oTarget, !nTest);
		SetStolenFlag(oRef, !nTest);
	}
	
	if (GetItemCursedFlag(oTarget)==TRUE)
		sText="Cursed";
	else 
		sText="Not Cursed";
	
	SendText(oPC, TXT_TOGGLE_CURSED + sText, TRUE, COLOR_GREEN);
	
	if (GetPlotFlag(oTarget)==TRUE)
		sText="Plot";
	else 
		sText="Not Plot";
	
	SendText(oPC, TXT_TOGGLE_PLOT + sText, TRUE, COLOR_GREEN);	
	
	if (GetStolenFlag(oTarget)==TRUE)
		sText="Stolen";
	else 
		sText="Not Stolen";
	SendText(oPC, TXT_TOGGLE_STOLEN + sText, TRUE, COLOR_GREEN);
}

string DMFI_TogglePreferences(object oTool, string sCommand)
{ //Purpose: Toggles a custom token string for the DMFI conversation
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/28/6
    string sTest;
    string sMessage;
    object oPC = GetItemPossessor(oTool);

    if (sCommand == PRM_DETAIL)
    {
        sTest = GetLocalString(oTool, DMFI_DICEBAG_DETAIL);
        if (sTest==PRM_HIGH)
        {
            sTest = PRM_LOW;
            sMessage = TXT_SET_DETAILLOW;
        }
        else if (sTest==PRM_MED)
        {
            sTest = PRM_HIGH;
            sMessage = TXT_SET_DETAILHIGH;
        }
        else if (sTest==PRM_LOW)
        {
            sTest = PRM_MED;
            sMessage = TXT_SET_DETAILMED;
        }
        SetLocalString(oTool, DMFI_DICEBAG_DETAIL, sTest);
        //SendText(oPC, sMessage, TRUE, COLOR_GREEN);
    }

    else if (sCommand == PRM_REPORT)
    {
        sTest = GetLocalString(oTool, DMFI_DICEBAG_REPORT);
        if (sTest==PRM_PC)
        {
            sTest = PRM_PARTY;
            sMessage = TXT_SET_REPORTPARTY;
        }
        else if (sTest==PRM_PARTY)
        {
            sTest = PRM_DM;
            sMessage = TXT_SET_REPORTDM;
        }
        else if (sTest==PRM_DM)
        {
            sTest = PRM_PC;
            sMessage = TXT_SET_REPORTPC;
        }
        SetLocalString(oTool, DMFI_DICEBAG_REPORT, sTest);
        //SendText(oPC, sMessage, TRUE, COLOR_GREEN);
    }
    else if (sCommand == PRM_ROLL)
    {
        sTest = GetLocalString(oTool, DMFI_DICEBAG_ROLL);
        if (sTest==PRM_PC)
        {
            sTest = PRM_PARTY;
            sMessage = TXT_SET_ROLLPARTY;
        }
        else if (sTest==PRM_PARTY)
        {
            sTest = PRM_BEST;
            sMessage = TXT_SET_ROLLBEST;
        }
        else if (sTest==PRM_BEST)
        {
            sTest = PRM_PC;
            sMessage = TXT_SET_ROLLPC;
        }
        SetLocalString(oTool, DMFI_DICEBAG_ROLL, sTest);
        //SendText(oPC, sMessage, TRUE, COLOR_GREEN);
    }
    else if (sCommand=="musictime")
	{
		sTest = GetLocalString(oTool, DMFI_MUSIC_TIME);
		if (sTest==PRM_DAY)
			sTest=PRM_NIGHT;
		else if (sTest==PRM_NIGHT)
			sTest=PRM_BOTH;
		else if (sTest==PRM_BOTH)
			sTest=PRM_BATTLE;
		else if (sTest==PRM_BATTLE)
			sTest=PRM_DAY;
		SetLocalString(oTool, DMFI_MUSIC_TIME, sTest);
	}
	else if (sCommand=="ambdaynight")
	{
		sTest = GetLocalString(oTool, DMFI_AMB_NIGHT);
		if (sTest==PRM_DAY)
			sTest=PRM_NIGHT;
		else
			sTest=PRM_DAY;
		SetLocalString(oTool, DMFI_AMB_NIGHT, sTest);
	}	

	return sTest;
}

object DMFI_UITarget(object oPC, object oTool)
{	//Purpose: Handles setting up target and speaker.  It returns the possessed creature.
  	//Original Scripter: Demetrious
  	//Last Modified By: Demetrious 12/27/6
	
	object oSpeaker, oRightClick;
	object oPossess = GetControlledCharacter(oPC);
		
	if (oPossess==OBJECT_INVALID)
		oSpeaker = oPC;
	else
		oSpeaker = oPossess;
	
	oRightClick = GetPlayerCurrentTarget(oSpeaker);
	
	if (DMFI_GetIsDM(oPC))
	{
		if (oRightClick==OBJECT_INVALID)
			oRightClick=oSpeaker;
	}		
	
	SetLocalObject(oTool, DMFI_TARGET, oRightClick);
  	SetLocalObject(oTool, DMFI_SPEAKER, oSpeaker);	
	/*	
	//SendText(oPossess, "DEBUG UI PC: " + GetName(oPC));
	//SendText(oPossess, "DEBUG UI Controlled: " + GetName(oPossess));
	//SendText(oPossess, "DEBUG UI Tool: " + GetName(oTool)); 
	//SendText(oSpeaker, "DEBUG: UI Target: " + GetName(oRightClick));
	*/
	return oPossess;
}
	
string DMFI_UnderscoreToSpace(string sInput)
{ //Purpose: Turns Underscores to spaces in sInput.  Needed for UI support
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/4/6
	int n=0;
	string sLetter, sFinal;
	
	sLetter = GetSubString(sInput, n, 1);
	while (sLetter!="")
	{
		if (sLetter=="_")	sLetter = " ";
		sFinal = sFinal + sLetter;
		n++;
		sLetter = GetSubString(sInput, n, 1);
	}
	return sFinal;
}

void DMFI_UpdateNumberToken(object oTool, string sCommand, string sNewValue)
{ //Purpose: Updates a custom token holding a number value for the DMFI conversation
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 11/10/6
    object oPC = GetItemPossessor(oTool);

    if (sCommand == "dc")
    {
        SetLocalString(oTool, DMFI_DICEBAG_DC, sNewValue);
        //SendText(oPC, TXT_SET_DICEBAG_DC + sNewValue, TRUE, COLOR_GREEN);
    }
	else if (sCommand == "vol")
	{
		SetLocalString(oTool, DMFI_AMBIENT_VOLUME, sNewValue);
		//SendText(oPC, TXT_SET_AMBIENT_VOLUME + sNewValue, TRUE, COLOR_GREEN);
		
	}		
	else if (sCommand == "delay")
	{
		SetLocalString(oTool, DMFI_SOUND_DELAY, sNewValue);
		//SendText(oPC, TXT_SET_SOUND_DELAY + sNewValue, TRUE, COLOR_GREEN);
	}	
	else if (sCommand == "dur")
	{
		SetLocalString(oTool, DMFI_VFX_DURATION, sNewValue);
		//SendText(oPC, TXT_SET_VFX_DURATION + sNewValue, TRUE, COLOR_GREEN);
	}	
}

// TO BE MOVED TO CONSTANTS FOR TRANSLATIONS

string DMFI_GetEffectString(string sValue)
{ //Purpose: Returns an Effect name from the constant value
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 4/30/6
  string sReturn = "";;
  int nValue = StringToInt(sValue);
  // divide the values into groups of 20 rather than if / else of 80 items where
  // all are equally possible.
  switch (nValue/20)
    {
        case 0:
        {
            switch (nValue)
            {
              case 1: {   sReturn =EFT_DAMAGE_RESISTANCE; break;
              case 3: {   sReturn = EFT_REGENERATE; break; }
              case 7: {   sReturn = EFT_DAMAGE_REDUCTION; break; }
              case 9: {   sReturn = EFT_TEMPORARY_HITPOINTS; break; }
              case 11: {   sReturn = EFT_ENTANGLE; break; }
              case 12: {   sReturn = EFT_INVULNERABLE; break; }
              case 13: {   sReturn = EFT_DEAF; break; }
              case 14: {   sReturn = EFT_RESURRECTION; break; }
              case 15: {   sReturn = EFT_IMMUNITY; break; }
              case 17: {   sReturn = EFT_ENEMY_ATTACK_BONUS; break; }
              case 18: {   sReturn = EFT_ARCANE_SPELL_FAILURE; break; }
            }
        }
        case 1:
            switch (nValue)
            {
              case 20: {   sReturn = EFT_AREA_OF_EFFEC; break; }
              case 21: {   sReturn = EFT_BEAM; break; }
              case 23: {   sReturn = EFT_CHARMED; break; }
              case 24: {   sReturn = EFT_CONFUSED; break; }
              case 25: {   sReturn = EFT_FRIGHTENED; break; }
              case 26: {   sReturn = EFT_DOMINATED; break; }
              case 27: {   sReturn = EFT_PARALYZE; break; }
              case 28: {   sReturn = EFT_DAZED; break; }
              case 29: {   sReturn = EFT_STUNNED; break; }
              case EFFECT_TYPE_SLEEP: { sReturn = EFT_SLEEP; break; }
              case EFFECT_TYPE_POISON : { sReturn = EFT_POISON; break; }
              case EFFECT_TYPE_DISEASE : { sReturn = EFT_DISEASE; break; }
              case EFFECT_TYPE_CURSE   : { sReturn = EFT_CURSE; break; }
              case EFFECT_TYPE_SILENCE: { sReturn = EFT_SILENCE; break; }
              case EFFECT_TYPE_TURNED  : { sReturn = EFT_TURNED; break; }
              case EFFECT_TYPE_HASTE : { sReturn = EFT_HASTE; break; }
              case EFFECT_TYPE_SLOW  : { sReturn = EFT_SLOW; break; }
              case EFFECT_TYPE_ABILITY_INCREASE  : { sReturn = EFT_ABILITY_INCREASE; break; }
              case EFFECT_TYPE_ABILITY_DECREASE  : { sReturn =EFT_ABILITY_DECREASE; break; }
            }
        }
        case 2:
        {
            switch (nValue)
            {
                case EFFECT_TYPE_ATTACK_INCREASE            : { sReturn =EFT_ATTACK_INCREASE; break; }
                case EFFECT_TYPE_ATTACK_DECREASE            : { sReturn =EFT_ATTACK_DECREASE; break; }
                case EFFECT_TYPE_DAMAGE_INCREASE            : { sReturn =EFT_DAMAGE_INCREASE; break; }
                case EFFECT_TYPE_DAMAGE_DECREASE            : { sReturn =EFT_DAMAGE_DECREASE; break; }
                case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE   : { sReturn =EFT_IMMUNITY; break; }
                case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE   : { sReturn =EFT_IMMUNITY; break; }
                case EFFECT_TYPE_AC_INCREASE                : { sReturn =EFT_AC_INCREASE; break; }
                case EFFECT_TYPE_AC_DECREASE                : { sReturn =EFT_AC_DECREASE; break; }
                case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE    : { sReturn =EFT_MOVEMENT_SPEED_INCREASE; break; }
                case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE    : { sReturn =EFT_MOVEMENT_SPEED_DECREASE; break; }
                case EFFECT_TYPE_SAVING_THROW_INCREASE      : { sReturn =EFT_SAVING_THROW_INCREASE; break; }
                case EFFECT_TYPE_SAVING_THROW_DECREASE      : { sReturn =EFT_SAVING_THROW_DECREASE; break; }
                case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE  : { sReturn =EFT_SPELL_RESISTANCE_INCREASE; break; }
                case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE  : { sReturn =EFT_SPELL_RESISTANCE_DECREASE; break; }
                case EFFECT_TYPE_SKILL_INCREASE             : { sReturn =EFT_SKILL_INCREASE; break; }
                case EFFECT_TYPE_SKILL_DECREASE             : { sReturn =EFT_SKILL_DECREASE; break; }
                case EFFECT_TYPE_INVISIBILITY               : { sReturn =EFT_INVISIBILITY; break; }
                case EFFECT_TYPE_DARKNESS                   : { sReturn =EFT_DARKNESS; break; }
                case EFFECT_TYPE_DISPELMAGICALL             : { sReturn =EFT_DISPELMAGICALL; break; }
            }
        }
        case 3:
        {
            switch (nValue)
            {
                case EFFECT_TYPE_ELEMENTALSHIELD            : { sReturn =EFT_ELEMENTALSHIELD; break; }
                case EFFECT_TYPE_NEGATIVELEVEL              : { sReturn =EFT_NEGATIVELEVEL; break; }
                case EFFECT_TYPE_POLYMORPH                  : { sReturn =EFT_POLYMORPH; break; }
                case EFFECT_TYPE_SANCTUARY                  : { sReturn =EFT_SANCTUARY; break; }
                case EFFECT_TYPE_TRUESEEING                 : { sReturn =EFT_TRUESEEING; break; }
                case EFFECT_TYPE_SEEINVISIBLE               : { sReturn =EFT_SEEINVISIBLE; break; }
                case EFFECT_TYPE_BLINDNESS                  : { sReturn =EFT_BLINDNESS; break; }
                case EFFECT_TYPE_SPELLLEVELABSORPTION       : { sReturn =EFT_SPELLLEVELABSORPTION; break; }
                case EFFECT_TYPE_DISPELMAGICBEST            : { sReturn =EFT_SLEEP; break; }
                case EFFECT_TYPE_ULTRAVISION                : { sReturn =EFT_DISPELMAGICBEST; break; }
                case EFFECT_TYPE_MISS_CHANCE                : { sReturn =EFT_MISS_CHANCE; break; }
                case EFFECT_TYPE_CONCEALMENT                : { sReturn =EFT_CONCEALMENT; break; }
                case EFFECT_TYPE_SPELL_IMMUNITY             : { sReturn =EFT_SPELL_IMMUNITY; break; }
                case EFFECT_TYPE_VISUALEFFECT               : { sReturn =EFT_VISUALEFFECT; break; }
                case EFFECT_TYPE_DISAPPEARAPPEAR            : { sReturn =EFT_DISAPPEARAPPEAR; break; }
                case EFFECT_TYPE_SWARM   					: { sReturn =EFT_SWARM; break; }
                case EFFECT_TYPE_TURN_RESISTANCE_DECREASE   : { sReturn =EFT_TURN_RESISTANCE_DECREASE; break; }
                case EFFECT_TYPE_TURN_RESISTANCE_INCREASE   : { sReturn =EFT_TURN_RESISTANCE_INCREASE; break; }
                case EFFECT_TYPE_PETRIFY 					: { sReturn =EFT_PETRIFY; break; }
            }
        }
        case 4:
        {
            switch (nValue)
            {
                case EFFECT_TYPE_CUTSCENE_PARALYZE          : { sReturn =EFT_CUTSCENE_PARALYZE; break; }
                case EFFECT_TYPE_ETHEREAL					: { sReturn =EFT_ETHEREAL; break; }
                case EFFECT_TYPE_SPELL_FAILURE              : { sReturn =EFT_SPELL_FAILURE; break; }
                case EFFECT_TYPE_CUTSCENEGHOST              : { sReturn =EFT_CUTSCENEGHOST; break; }
                case EFFECT_TYPE_CUTSCENEIMMOBILIZE         : { sReturn =EFT_CUTSCENEIMMOBILIZE; break; }
            	case EFFECT_TYPE_BARDSONG_SINGING			: { sReturn =EFT_BARDSONG_SINGING; break; }
				case EFFECT_TYPE_HIDEOUS_BLOW				: { sReturn =EFT_HIDEOUS_BLOW; break; }
				case EFFECT_TYPE_NWN2_DEX_ACMOD_DISABLE		: { sReturn =EFT_NWN2_DEX_ACMOD_DISABLE; break; }
				case EFFECT_TYPE_DETECTUNDEAD				: { sReturn =EFT_DETECTUNDEAD; break; }
				case EFFECT_TYPE_SHAREDDAMAGE				: { sReturn =EFT_SHAREDDAMAGE; break; }
				case EFFECT_TYPE_ASSAYRESISTANCE			: { sReturn =EFT_ASSAYRESISTANCE; break; }	
				case EFFECT_TYPE_DAMAGEOVERTIME				: { sReturn =EFT_DAMAGEOVERTIME; break; }
				case EFFECT_TYPE_ABSORBDAMAGE				: { sReturn =EFT_ABSORBDAMAGE; break; }
				case EFFECT_TYPE_AMORPENALTYINC				: { sReturn =EFT_AMORPENALTYINC; break; }
				case EFFECT_TYPE_DISINTEGRATE				: { sReturn =EFT_DISINTEGRATE; break; }
				case EFFECT_TYPE_HEAL_ON_ZERO_HP			: { sReturn =EFT_HEAL_ON_ZERO_HP; break; }
				case EFFECT_TYPE_BREAK_ENCHANTMENT			: { sReturn =EFT_BREAK_ENCHANTMENT; break; }
				case EFFECT_TYPE_MESMERIZE					: { sReturn =EFT_MESMERIZE; break; }
				case EFFECT_TYPE_ON_DISPEL					: { sReturn =EFT_DISPELMAGICALL; break; }
				case EFFECT_TYPE_BONUS_HITPOINTS			: { sReturn =EFT_BONUS_HITPOINTS; break; }
			}
        }
		case 5:
		{
			switch (nValue)
			{
				case EFFECT_TYPE_JARRING					: { sReturn =EFT_JARRING; break; }
				case EFFECT_TYPE_MAX_DAMAGE					: { sReturn =EFT_MAX_DAMAGE; break; }
				case EFFECT_TYPE_WOUNDING					: { sReturn =EFT_WOUNDING; break; }
			}	
		}
		default: break;
    }
  sReturn = sReturn + PRM_EFFECT;
  return sReturn;
}

string DMFI_GetSoundString(int nValue, string sParam)
{
 if (sParam==PRM_CITY)
 {
    switch(nValue)
	{
    case 0: { SetLocalString(GetModule(), DMFI_TEMP, as_bell_church01); return  "as_bell_church01"; break; }
    case 1: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_belltower1); return  "as_cv_belltower1"; break; }
   	case 2: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_boilergrn1); return  "as_cv_boilergrn1"; break; }
	case 3: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_boomdist1); return  "as_cv_boomdist1"; break; }
    case 4: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_claybreak1); return  "as_cv_claybreak1"; break; }
    case 5: { SetLocalString(GetModule(), DMFI_TEMP, as_hr_x2chnratl1); return  "as_hr_x2chnratl1"; break; }
    case 6: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_crank1); return  "as_cv_crank1"; break; }
    case 7: { SetLocalString(GetModule(), DMFI_TEMP, al_cv_firecamp1); return  "al_cv_firecamp1"; break; }
    case 8: { SetLocalString(GetModule(), DMFI_TEMP, al_na_firelarge2); return  "al_na_firelarge2"; break; }
    case 9: { SetLocalString(GetModule(), DMFI_TEMP, al_cv_firesmldr1); return  "al_cv_firesmldr1"; break; }
    case 10: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_glasbreak1); return  "as_cv_glasbreak1"; break; }
    case 11: { SetLocalString(GetModule(), DMFI_TEMP, as_na_x2lowrum2); return  "as_na_x2lowrum2"; break; }
    case 12: { SetLocalString(GetModule(), DMFI_TEMP, amb_metal_creaking_1); return  "amb_metal_creaking_1"; break; }
    case 13: { SetLocalString(GetModule(), DMFI_TEMP, al_cv_millwheel1); return  "al_cv_millwheel1"; break; }
    case 14: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_minepick1); return  "as_cv_minepick1"; break; }
    case 15: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_mineshovl1); return  "as_cv_mineshovl1"; break; }
    case 16: { SetLocalString(GetModule(), DMFI_TEMP, as_hr_x2drnoise4); return  "as_hr_x2drnoise4"; break; }
    case 17: { SetLocalString(GetModule(), DMFI_TEMP, as_hr_x2drnoise); return  "as_hr_x2drnoise"; break; }
    case 18: { SetLocalString(GetModule(), DMFI_TEMP, cs_shipsink_long); return  "cs_shipsink_long"; break; }
    case 19: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_smithhamr1); return  "as_cv_smithhamr1"; break; }
    case 20: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_woodbreak1); return  "as_cv_woodbreak1"; break; }

    return "";
	}
 }

 else if (sParam==PRM_NATURE)
 {
    switch(nValue)
	{
    case 0: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_bldgcrumb1); return  "as_cv_bldgcrumb1"; break; }
    case 1: { SetLocalString(GetModule(), DMFI_TEMP, amb_caverumb_01); return  "amb_caverumb_01"; break; }
    case 2: { SetLocalString(GetModule(), DMFI_TEMP, amb_caverumb_02); return  "amb_caverumb_02"; break; }
    case 3: { SetLocalString(GetModule(), DMFI_TEMP, amb_cavewind_03); return  "amb_cavewind_03"; break; }
    case 4: { SetLocalString(GetModule(), DMFI_TEMP, amb_cavewind_04); return  "amb_cavewind_04"; break; }
    case 5: { SetLocalString(GetModule(), DMFI_TEMP, al_wt_gustcavrn1); return  "al_wt_gustcavrn1"; break; }
    case 6: { SetLocalString(GetModule(), DMFI_TEMP, al_wt_gustchasm1); return  "al_wt_gustchasm1"; break; }
    case 7: { SetLocalString(GetModule(), DMFI_TEMP, al_wt_gustgrass1); return  "al_wt_gustgrass1"; break; }
    case 8: { SetLocalString(GetModule(), DMFI_TEMP, as_wt_gustdraft1); return  "as_wt_gustdraft1"; break; }
    case 9: { SetLocalString(GetModule(), DMFI_TEMP, as_wt_gusforst1); return  "as_wt_gusforst1"; break; }
    case 10: { SetLocalString(GetModule(), DMFI_TEMP, as_wt_gustsoft1); return  "as_wt_gustsoft1"; break; }
    case 11: { SetLocalString(GetModule(), DMFI_TEMP, as_wt_guststrng1); return  "as_wt_guststrng1"; break; }
    case 12: { SetLocalString(GetModule(), DMFI_TEMP, as_na_lavaburst1); return  "as_na_lavaburst1"; break; }
    case 13: { SetLocalString(GetModule(), DMFI_TEMP, al_na_lavafire1); return  "al_na_lavafire1"; break; }
    case 14: { SetLocalString(GetModule(), DMFI_TEMP, al_na_lavagyser1); return  "al_na_lavagyser1"; break; }
    case 15: { SetLocalString(GetModule(), DMFI_TEMP, al_na_lavalake1); return  "al_na_lavalake1"; break; }
    case 16: { SetLocalString(GetModule(), DMFI_TEMP, amb_ocean_lp1); return  "amb_ocean_lp1"; break; }
    case 17: { SetLocalString(GetModule(), DMFI_TEMP, al_wt_rainlight1); return  "al_wt_rainlight1"; break; }
    case 18: { SetLocalString(GetModule(), DMFI_TEMP, al_wt_rainhard1); return  "al_wt_rainhard1"; break; }
    case 19: { SetLocalString(GetModule(), DMFI_TEMP, as_na_rockfallg1); return  "as_na_rockfallg1"; break; }
    case 20: { SetLocalString(GetModule(), DMFI_TEMP, as_na_rockcavsm1); return  "as_na_rockcavsm1"; break; }
    case 21: { SetLocalString(GetModule(), DMFI_TEMP, al_na_sludglake1); return  "al_na_sludglake1"; break; }
    case 22: { SetLocalString(GetModule(), DMFI_TEMP, al_na_steamsm1); return  "al_na_steamsm1"; break; }
    case 23: { SetLocalString(GetModule(), DMFI_TEMP, as_na_steamlong1); return  "as_na_steamlong1"; break; }
    case 24: { SetLocalString(GetModule(), DMFI_TEMP, al_na_steamlg1); return  "al_na_steamlg1"; break; }
    case 25: { SetLocalString(GetModule(), DMFI_TEMP, al_na_stream4); return  "al_na_stream4"; break; }
    case 26: { SetLocalString(GetModule(), DMFI_TEMP, al_na_cvstream2); return  "al_na_cvstream2"; break; }
    case 27: { SetLocalString(GetModule(), DMFI_TEMP, al_na_cvstream1); return  "al_na_cvstream1"; break; }
    case 28: { SetLocalString(GetModule(), DMFI_TEMP, as_na_surf1); return  "as_na_surf1"; break; }
    case 29: { SetLocalString(GetModule(), DMFI_TEMP, as_na_surf2); return  "as_na_surf2"; break; }
    case 30: { SetLocalString(GetModule(), DMFI_TEMP, as_wt_thundercl1); return  "as_wt_thunderds1"; break; }
    case 31: { SetLocalString(GetModule(), DMFI_TEMP, as_wt_thunderds1); return  "as_wt_thundercl1"; break; }
    case 32: { SetLocalString(GetModule(), DMFI_TEMP, al_na_waterfall2); return  "al_na_waterfall2"; break; }
    case 33: { SetLocalString(GetModule(), DMFI_TEMP, as_na_waterlap3); return  "as_na_waterlap3"; break; }
    case 34: { SetLocalString(GetModule(), DMFI_TEMP, al_na_wtrflvoid1); return  "al_na_wtrflvoid1"; break; }
    case 35: { SetLocalString(GetModule(), DMFI_TEMP, al_na_waterpipe1); return  "al_na_waterpipe1"; break; }
    case 36: { SetLocalString(GetModule(), DMFI_TEMP, al_na_watertunl1); return  "al_na_watertunl1"; break; }
    case 37: { SetLocalString(GetModule(), DMFI_TEMP, al_wind_leaves); return  "al_wind_leaves"; break; }

    return "";
	}
 }

 else if (sParam==PRM_PEOPLE)
 {
    switch(nValue)
	{
    case 0: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_ailingm1); return  "as_pl_ailingm1"; break; }
    case 1: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_ailingf1); return  "as_pl_ailingf1"; break; }
    case 2: { SetLocalString(GetModule(), DMFI_TEMP, c_orc_atk1); return  "c_orc_atk1"; break; }
    case 3: { SetLocalString(GetModule(), DMFI_TEMP, c_orc_bat1); return  "c_orc_bat1"; break; }
    case 4: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_battlegrp1); return  "as_pl_battlegrp1"; break; }
    case 5: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_chantingm1); return  "as_pl_chantingm1"; break; }
    case 6: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_comyaygrp1); return  "as_pl_comyaygrp1"; break; }
    case 7: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_crptvoice1); return  "as_pl_crptvoice1"; break; }
    case 8: { SetLocalString(GetModule(), DMFI_TEMP, cs_kos_death); return  "cs_kos_death"; break; }
    case 9: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_despairm1); return  "as_pl_despairm1"; break; }
    case 10: { SetLocalString(GetModule(), DMFI_TEMP, as_an_dragonror1); return  "as_an_dragonror1"; break; }
    case 11: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_evilchantm); return  "as_pl_evilchantm"; break; }
    case 12: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_flute1); return  "as_cv_flute1"; break; }
    case 13: { SetLocalString(GetModule(), DMFI_TEMP, as_hr_x2ghost4); return  "as_hr_x2ghost4"; break; }
    case 14: { SetLocalString(GetModule(), DMFI_TEMP, as_hr_x2ghost2); return  "as_hr_x2ghost2"; break; }
    case 15: { SetLocalString(GetModule(), DMFI_TEMP, as_an_lizrdhiss1); return  "as_an_lizrdhiss1"; break; }
    case 16: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_lute1); return  "as_cv_lute1"; break; }
    case 17: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_marketgrp1); return  "as_pl_marketgrp1"; break; }
    case 18: { SetLocalString(GetModule(), DMFI_TEMP, as_an_mephgrunt1); return  "as_an_mephgrunt1"; break; }
    case 19: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_officerm1); return  "as_pl_officerm1"; break; }
    case 20: { SetLocalString(GetModule(), DMFI_TEMP, as_an_ogregrunt1); return  "as_an_ogregrunt1"; break; }
    case 21: { SetLocalString(GetModule(), DMFI_TEMP, as_an_orcgrunt1); return  "as_an_orcgrunt1"; break; }
    case 22: { SetLocalString(GetModule(), DMFI_TEMP, as_cv_shopfruit1); return  "as_cv_shopfruit1"; break; }
    case 23: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_taverngrp1); return  "as_pl_taverngrp1"; break; }
    case 24: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_towncrym1); return  "as_pl_towncrym1"; break; }
    case 25: { SetLocalString(GetModule(), DMFI_TEMP, wilhelm_scream); return  "wilhelm_scream"; break; }
    case 26: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_yelcitycf1); return  "as_pl_yelcitycf1"; break; }
    case 27: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_yellcitym1); return  "as_pl_yellcitym1"; break; }
    case 28: { SetLocalString(GetModule(), DMFI_TEMP, as_pl_zombief1); return  "as_pl_zombief1"; break; }

    return "";
	}
 }

 else if (sParam==PRM_MAGICAL)
 {
    switch(nValue)
	{
	case 0: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_ballmagic1); return  "al_mg_ballmagic1"; break; }
    case 1: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_cauldron1); return  "al_mg_cauldron1"; break; }
    case 2: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_crystalev1); return  "al_mg_crystalev1"; break; }
    case 3: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_crystalgd1); return  "al_mg_crystalgd1"; break; }
    case 4: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_crystalic1); return  "al_mg_crystalic1"; break; }
    case 5: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_crystallv1); return  "al_mg_crystallv1"; break; }
    case 6: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_crystalnt1); return  "al_mg_crystalnt1"; break; }
    case 7: { SetLocalString(GetModule(), DMFI_TEMP, al_eerie_caveloop1); return  "al_eerie_caveloop1"; break; }
    case 8: { SetLocalString(GetModule(), DMFI_TEMP, al_eerie_caveloop2); return  "al_eerie_caveloop2"; break; }
    case 9: { SetLocalString(GetModule(), DMFI_TEMP, al_eerie_caveloop4); return  "al_eerie_caveloop4"; break; }
    case 10: { SetLocalString(GetModule(), DMFI_TEMP, al_eerie_droneloop1); return  "al_eerie_droneloop1"; break; }
    case 11: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_entrevil1); return  "al_mg_entrevil1"; break; }
    case 12: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_entrmyst1); return  "al_mg_entrmyst1"; break; }
    case 13: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_entrscry1); return  "al_mg_entrscry1"; break; }
    case 14: { SetLocalString(GetModule(), DMFI_TEMP, as_mg_frstmagic1); return  "as_mg_frstmagic1"; break; }
    case 15: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_pillrlght1); return  "al_mg_pillrlght1"; break; }
    case 16: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_portal3); return  "al_mg_portal3"; break; }
    case 17: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_portal4); return  "al_mg_portal4"; break; }
    case 18: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_portal2); return  "al_mg_portal2"; break; }
    case 19: { SetLocalString(GetModule(), DMFI_TEMP, as_mg_telepin1); return  "as_mg_telepin1"; break; }
    case 20: { SetLocalString(GetModule(), DMFI_TEMP, al_mg_spirtbarrow_01); return  "al_mg_spirtbarrow_01"; break; }
	case 21: { SetLocalString(GetModule(), DMFI_TEMP, al_en_deathgodamb); return  "al_en_deathgodamb"; break; }
	case 22: { SetLocalString(GetModule(), DMFI_TEMP, al_en_roomtone); return  "al_en_roomtone"; break; }
    return "";
	}
 }
 return "";
}

//void main(){}