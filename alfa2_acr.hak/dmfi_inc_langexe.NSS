////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_langexe - DM Friendly Initiative - Code for /Languages
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/20/7
//                     AcadiusLost 			11/3/2007 (languages for FR Amn area)
//											11/13/2007 (lore roll to include constant)
//											01/25/2008 - bonus languages to TSM, skills
//											09/21/2008 - Language translation loop to include poss. NPCs.
//												also, drow/elven translation and improved bonus/default langs.
//											10/13/2008 - Fix for unpossessed DM Avatars.
//											7/12/2009 - Special handling for Loross/Netherese
//											7/18/2009 - Regions handling, languages on LevelUp
//											7/31/2009 - Added Languages by Faith
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

/*	READ ME::   THE TOP TWO FUNCTIONS DEFINE THE PHB RULES FOR GRANTING DEFAULT
				LANGUAGES AND THEN DEFINING LANGUAGE CHOICES.  THESE ARE AS BY
				THE BOOK AS I COULD GET THEM.
				
				YOU CAN CUSTOMIZE THE LANGUAGE RULES BY ALTERING THE TOP TWO
				FUNCTIONS ONLY.  ONLY TOUCH THE TOP TWO FUNCTIONS.
				
				FOR CHANGES, YOU MUST RECOMPILE ALL SCRIPTS IN THE MODULE!!!!
*/


#include "dmfi_inc_tool"
#include "dmfi_inc_english"

#include "acr_i"
#include "acr_language_i"

// ***************************** DECLARATIONS **********************************

void DMFI_GrantOutsider(object oPC);
void DMFI_GrantChoosenLang(object oPC, string sLang);

// FILE: dmfi_inc_langexe
//Purpose: Sets sLang as a valid language for oPC.  List starts at a value of 0.
//Includes a check for DMFI_IsLanguageKnown within this function.
void DMFI_GrantLanguage(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Returns TRUE / FALSE whether sLang is known by oPC
int DMFI_IsLanguageKnown(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Reports oTarget's languages to oDM for review
void DMFI_ListLanguages(object oDM, object oTarget);

//FILE: dmfi_inc_langexe
//Purpose: Returns a default language that has been linked to a new name via
//a plugin.  sLang is the name of the NEW Language - a default DMFI Language
//is returned.  If there is no link it returns ""
string DMFI_NewLanguage(string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Removes sLang as a valid Language for oPC and decrements the max number
// of known languages.  The player is informed of the action.
int DMFI_RemoveLanguage(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Sends sTranslate to any nearby speakers of sLang.  NOTE: sTranslate
//is the original text before it is translated so we just send it as is.
void DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI);


// Function duplicates DMFI_IsLanguageKnown(), but accounting for dialect cross-comprehesibility.
int DMFI_IsLanguageUnderstood(object oPC, string sLang);

// ****************************** FUNCTIONS ************************************

void DMFI_BuildChoosenList(object oPC)
{
	// use ACR tables
	_AddBonusLanguagesByClass(oPC);
	_AddBonusLanguagesByRace(oPC);
	_AddBonusLanguagesByFaith(oPC);
	_AddBonusLanguagesByRegion(ACR_GetCharacterRegion(oPC), oPC);

}

void DMFI_GiveDefaultLanguages(object oPC)
{	// PURPOSE:  Grants languages as close as possible to 
	// PHB rules  1/19/7
	_AddAutomaticLanguagesByRace(oPC);
	_AddAutomaticLanguagesByRegion(oPC);
	_AddAutomaticLanguagesByClass(oPC);	

}	 
	 


///////////////////// DO NOT EDIT BELOW THIS!! ///////////////////////////////


void DMFI_GrantChoosenLang(object oPC, string sLang)
{
	// AcadiusLost 2008/09/17 - added check to keep a possible language from adding twice.
	object oTool = DMFI_GetTool(oPC);
	
	if (!DMFI_IsLanguageKnown(oPC, sLang))
		if (FindSubString(GetLocalString(oTool, PG_LIST_POSSLANGUAGE), DMFI_CapitalizeWord(sLang)) == -1)
		    AddStringElement(DMFI_CapitalizeWord(sLang), PG_LIST_POSSLANGUAGE, oTool);
}		


void DMFI_GrantOutsider(object oPC)
{
	string sLang;
	if (GetAlignmentGoodEvil(oPC)==ALIGNMENT_GOOD)
		sLang=LNG_CELESTIAL;
	else
	{
		if (GetAlignmentLawChaos(oPC)==ALIGNMENT_CHAOTIC)
			sLang=LNG_ABYSSAL;
		else
			sLang=LNG_INFERNAL;
	}				
}			


void DMFI_GrantChoosenLanguages(object oPC)
{
	// edit by AcadiusLost 1/25/2007, for speak languages skill use
	object oTool;
	int nMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
	int nLangs = GetSkillRank(SKILL_SPEAK_LANGUAGE, oPC, TRUE);
	// add int bonus to number of Speak Language ranks, only if positive
	if (nMod > 0) { nLangs = nLangs + nMod; }
	// record the number of bonus langugages for later comparison
	SetLocalInt(DMFI_GetTool(oPC), "ACR_LANG_BONUSLANGUAGES", nLangs);
	SetLocalInt(DMFI_GetTool(oPC), "ACR_LANG_INT_BONUS", nMod);
	if (nLangs>0)
	{
		// clear old data
		oTool=DMFI_GetTool(oPC);
		DeleteList(PG_LIST_POSSLANGUAGE, oTool);
	
		// build a current list
		DMFI_BuildChoosenList(oPC);
		
		SetLocalInt(oPC, DMFI_CHOOSE, nLangs);
		DMFI_ClearUIData(oPC);
		SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_GRANT + PRM_);
		SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_POSSLANGUAGE);
		SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_CHOOSE + IntToString(nLangs));
		DMFI_ShowDMListUI(oPC, SCREEN_DMFI_CHOOSE);
	}
}

void DMFI_GrantLanguage(object oPC, string sLang)
{  //Purpose: Sets sLang as a valid Language for oPC.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 1/1/7
   	object oTool = DMFI_GetTool(oPC);
   	if (!DMFI_IsLanguageKnown(oPC, sLang))
   	{   
   		int n = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
   		SendText(oPC, TXT_LANGUAGE + DMFI_CapitalizeWord(sLang), FALSE, COLOR_GREY);
   		sLang = GetStringLowerCase(sLang);
   		SetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n), sLang);
   		n++;
   		SetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX, n);
	}
	else
	    SendText(oPC, TXT_LANGUAGE_KNOWN + DMFI_CapitalizeWord(sLang), FALSE, COLOR_GREY);
}

int DMFI_IsLanguageKnown(object oPC, string sLang)
{ //Purpose: Returns TRUE / FALSE whether sLang is known
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 6/28/6
  object oTool = DMFI_GetTool(oPC);
  int n;
  int nMax = GetLocalInt(oTool, "LanguageMAX");
  string sTest;
  // All languages stored in lower case strings.
  sLang = GetStringLowerCase(sLang);
  for (n=0; n<nMax; n++)
  {
    sTest = GetLocalString(oTool, "Language" + IntToString(n));
    if (sTest==sLang) return TRUE;
  }
  return FALSE;
}

void DMFI_ListLanguages(object oDM, object oTarget)
{ //Purpose:  Reports oTarget's known languages to oPC
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 10/16/6
    object oTool = DMFI_GetTool(oTarget);
  	string sMess;
    string sLang;
    int n;
	int nMax;
    
	sMess = TXT_LANGUAGE_LIST + GetName(oTarget) + "\n";
	
	if (DMFI_GetIsDM(oTarget))
	{
		SendText(oDM, sMess + TXT_ALL_LANGUAGES, FALSE, COLOR_GREY);
		return;
	}	

	nMax = GetLocalInt(oTool, DMFI_STRING_LANGUAGE + DMFI_STRING_MAX);
    for (n=0; n<nMax; n++)
    {
        sLang = DMFI_CapitalizeWord(GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n)));
        sMess = sMess + TXT_LANGUAGE + sLang + "\n";
    }
    if (nMax==0) sMess = TXT_NO_LANGUAGE;

    SendText(oDM, sMess, FALSE, COLOR_GREY);
	
	//SendMessageToPC(oDM, "Possible languages: "+GetLocalString(oTool, PG_LIST_POSSLANGUAGE));
}

string DMFI_NewLanguage(string sLang)
{ //Purpose: Returns a default language that has been linked to a new name via
  //a plugin.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 6/28/6
    string sDefault = GetLocalString(GetModule(), sLang);
	if (sDefault!="") return sDefault;
	
    return sLang;
}

int DMFI_RemoveLanguage(object oPC, string sLang)
{  //Purpose: Removes sLang as a valid Language for oPC.  The player is informed
   //of the action.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 1/26/7
   object oTool = DMFI_GetTool(oPC);
   string sTemp;
   int nReturn = FALSE;
   int n=0;
   int nMax = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
   sLang = GetStringLowerCase(sLang);
  
   while (n<nMax)
   {
   		SendMessageToAllDMs("Testing "+GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n))+" against "+sLang);
        if (GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n))==sLang)
        { // Match - remove language
            CloseGUIScreen(oPC, SCREEN_DMFI_TEXT);
		
			nReturn=TRUE;
   			SetLocalInt(oTool, DMFI_STRING_LANGUAGE + DMFI_STRING_MAX, nMax-1);
			SendText(oPC, TXT_LANGUAGE_REMOVED + sLang, TRUE, COLOR_GREY);
			SendMessageToAllDMs("Match on n = "+IntToString(n));
            while (n<nMax)
            {
                sTemp = GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n+1));
                SetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n), sTemp);
                n++;
            }
        }
        n++;
   }

   return nReturn;
}

void DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI)
{ //Purpose: Sends sTranslate to any nearby speakers of sLang
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 1/10/7
  //                  AcadiusLost 11/18/07 - graded lore checks defined in dmfi_inc_const
  //				  AcadiusLost 1/25/2008 - switched to a Speak Languages check
  //                  AcadiusLost 8/12/2008 - reinstated Speak Languages check
  //				  AcadiusLost 9/20/2008 - Reworked loop as GetFirst/NextObject in shape
  //				  AcadiusLost 8/2/2009 - altered translation to use GetIsLanguageUnderstood() to handle dialects
    int nTest;
	int n=1;
    if ((sLang==LNG_COMMON) || (sLang=="")) return;
	float fRange = 0.0;
	SendText(oUI, GetName(oSpeaker) + " : " + sTranslate, FALSE, COLOR_BROWN);
		
	object oListener = GetFirstPC();
	// Loop through all the PCs to find any DM avatars to translate for.  	
    while (GetIsObjectValid(oListener))
    {
        if (GetIsDM(oListener)) {
			if (GetArea(oSpeaker)==GetArea(oListener)) { 
				fRange = GetDistanceBetween(oSpeaker, oListener);
				if ((oListener!=oSpeaker) && (fRange < 30.0) && (fRange > 0.0)) {
          		    SendText(oListener, PRM_ + GetName(oSpeaker) + PRM_ + TXT_TRANSLATED + DMFI_CapitalizeWord(sLang) + PRM_ + sTranslate, FALSE, COLOR_GREY);
 				}
			}
		}
		oListener = GetNextPC();
	}
	// Now, loop through the vicinity of the speaker for possesed NPCs and other PCs.
	location lSpeaker = GetLocation(oSpeaker);
	oListener = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, lSpeaker, FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oListener)) {
		if (GetIsDMPossessed(oListener) || GetIsDM(oListener)) {
			SendText(oListener, PRM_ + GetName(oSpeaker) + PRM_ + TXT_TRANSLATED + DMFI_CapitalizeWord(sLang) + PRM_ + sTranslate, FALSE, COLOR_GREY);
		} else if (GetIsPC(oListener)) {
			fRange = GetDistanceBetween(oSpeaker, oListener);
			if ((oListener!=oSpeaker) && (fRange < 20.0) && (fRange > 0.0))
            {
                if (DMFI_IsLanguageUnderstood(oListener, sLang) || DMFI_GetIsDM(oListener))
                { // Speaks language
          		    SendText(oListener, PRM_ + GetName(oSpeaker) + PRM_ + TXT_TRANSLATED + DMFI_CapitalizeWord(sLang) + PRM_ + sTranslate, FALSE, COLOR_GREY);
 				}  // Speaks language
				else 
				{
					nTest = (d20() + GetSkillRank(SKILL_SPEAK_LANGUAGE, oListener));
					if (nTest>=DMFI_LANGUAGETRANSLATE_DC) {
					    SendText(oListener, TXT_TRANSLATED_LORE, FALSE, COLOR_GREY);
						SendText(oListener, GetName(oSpeaker) + PRM_ + TXT_TRANSLATED + sLang + PRM_ + sTranslate, FALSE, COLOR_GREY);
					} else if (nTest>=DMFI_LANGUAGELORE_DC) {
						    SendText(oListener, "Language Check Passed: Language Identified.", FALSE, COLOR_GREY);
						    SendText(oListener, GetName(oSpeaker) + PRM_ + TXT_SPEAKING + sLang + PRM_, FALSE, COLOR_GREY);
					}
				}		
            }
		}
		oListener = GetNextObjectInShape(SHAPE_SPHERE, 30.0, lSpeaker, FALSE, OBJECT_TYPE_CREATURE);
	}
	
}


int DMFI_IsLanguageUnderstood(object oPC, string sLang)

{ //Purpose: Returns TRUE / FALSE whether sLang is known
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 6/28/6
  //  AcadiusLost - Drow/Elven exception case 2008/9/18
  //			  - Split to new funtion, added Loross
  object oTool = DMFI_GetTool(oPC);
  int n;
  int nMax = GetLocalInt(oTool, "LanguageMAX");
  string sTest;
  // All languages stored in lower case strings.
  sLang = GetStringLowerCase(sLang);
  for (n=0; n<nMax; n++)
  {
    sTest = GetLocalString(oTool, "Language" + IntToString(n));
	  // ACR edit for drow/elven situation
	  //  further edit for netherese/loross
	if ((sTest=="drow") && (sLang=="elven")) { return TRUE; }
	if ((sTest=="elven") && (sLang=="drow")) { return TRUE; }
	if ((sTest=="loross") && (sLang=="netherese")) { return TRUE; }
	if ((sTest=="netherese") && (sLang=="loross")) { return TRUE; }
    if (sTest==sLang) return TRUE;
  }
  return FALSE;
}
//void main()  {}