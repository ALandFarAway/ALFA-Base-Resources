////////////////////////////////////////////////////////////////////////////////
// dmfi_conv_def - DM Friendly Initiative -  Defines DM Conversation Tokens
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/12/7  Qk 10/08/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "dmfi_inc_tool"

void main()
{
object oTool = OBJECT_SELF;
int n;
SetLocalObject(oTool, "DLG_HOLDER", oTool);  // Required for new CTDS functions
///////////////////////////// INTRODUCTION PAGE ////////////////////////////////

//////////////////////////////////// TARGET_MUSIC PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_MUSIC_NWN2);
DMFI_AddPage(oTool, PG_LIST_MUSIC_NWN1);
DMFI_AddPage(oTool, PG_LIST_MUSIC_XP);
DMFI_AddPage(oTool, PG_LIST_MUSIC_BATTLE);
DMFI_AddPage(oTool, PG_LIST_MUSIC_MOTB);

DMFI_Build2DAAMusicList();

////////////////////////////////// TARGET_AMBIENT PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_AMBIENT_CAVE);
DMFI_AddPage(oTool, PG_LIST_AMBIENT_MAGIC);
DMFI_AddPage(oTool, PG_LIST_AMBIENT_PEOPLE);
DMFI_AddPage(oTool, PG_LIST_AMBIENT_MISC);

DelayCommand(2.0,DMFI_Build2DAASoundsList());

////////////////////////////////////// TARGET ABILITY //////////////////////////
DMFI_AddPage(oTool, PG_LIST_ABILITY);

DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_STRENGTH) , DMFI_CHAR_CMD + PRM_ROLL +" "+ PRM_ABILITY_STRENGTH);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_DEXTERITY) , DMFI_CHAR_CMD + PRM_ROLL  +" "+  PRM_ABILITY_DEXTERITY);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_CONSTITUTION) , DMFI_CHAR_CMD + PRM_ROLL  +" "+  PRM_ABILITY_CONSTITUTION);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_INTELLIGENCE) , DMFI_CHAR_CMD + PRM_ROLL  +" "+  PRM_ABILITY_INTELLIGENCE);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_WISDOM) , DMFI_CHAR_CMD + PRM_ROLL  +" "+ PRM_ABILITY_WISDOM);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_CHARISMA) , DMFI_CHAR_CMD + PRM_ROLL +" "+ PRM_ABILITY_CHARISMA);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_SAVE_FORTITUDE) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_SAVE_FORTITUDE, COLOR_ORANGE);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_SAVE_REFLEX) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_SAVE_REFLEX, COLOR_ORANGE);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_SAVE_WILL) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_SAVE_WILL, COLOR_ORANGE);

//////////////////////////////////// TARGET SKILL PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_SKILL);
DMFI_Build2DAList(oTool, PG_LIST_SKILL, DMFI_2DA_SKILLS);


////////////////////////////////////// TARGET_VFX PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_VFX_SPELL);
DMFI_AddPage(oTool, PG_LIST_VFX_IMP);
DMFI_AddPage(oTool, PG_LIST_VFX_DUR);
DMFI_AddPage(oTool, PG_LIST_VFX_MISC);

DelayCommand(4.0, DMFI_BuildVFXList(oTool));

DMFI_AddPage(oTool, PG_LIST_VFX_RECENT);

//////////////////////////////////// TAREGET DISEASE PAGE //////////////////////
DMFI_AddPage(oTool, PG_LIST_DISEASE);
DMFI_Build2DAList(oTool, PG_LIST_DISEASE, DMFI_2DA_DISEASE);

//////////////////////////////////// TAREGET DISEASE PAGE //////////////////////
DMFI_AddPage(oTool, PG_LIST_POISON);
DMFI_Build2DAList(oTool, PG_LIST_POISON, DMFI_2DA_POISON);

//////////////////////////////////// SIMPLE NUMBER PAGES ///////////////////////

DMFI_AddPage(oTool, PG_LIST_50);
for (n=0; n<51; n++)
{
    DMFI_AddConversationElement(oTool, PG_LIST_50, IntToString(n));
}

DMFI_AddPage(oTool, PG_LIST_300);										
for (n=10; n<301; n=n+10)
{
    DMFI_AddConversationElement(oTool, PG_LIST_300, IntToString(n));
}

DMFI_AddPage(oTool, PG_LIST_100);
for (n=10; n<101; n=n+10)
{
    DMFI_AddConversationElement(oTool, PG_LIST_100, IntToString(n));
}
	
DMFI_AddPage(oTool, PG_LIST_10);
for (n=1; n<10; n=n+1)
{
    DMFI_AddConversationElement(oTool, PG_LIST_10, IntToString(n));
}

DMFI_AddPage(oTool, PG_LIST_24);											
for (n=1; n<25; n++)
{
    DMFI_AddConversationElement(oTool, PG_LIST_24, IntToString(n));
}

//////////////////////////////////// DM LANGUAGE LIST - COMPLETE LISTING //////////
DMFI_AddPage(oTool, PG_LIST_DMLANGUAGE);
DMFI_BuildLanguageDMList(oTool);

///////////////////////////////////// DURATION VALUE PAGE //////////////////////////

DMFI_AddPage(oTool, PG_LIST_DURATIONS);
SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", PG_LIST_DURATIONS);
AddReplyLinkInt("5", "", -1, 5);
AddReplyLinkInt("10", "", -1, 10);
AddReplyLinkInt("20", "", -1, 20);
AddReplyLinkInt("40", "", -1, 40);
AddReplyLinkInt("60", "", -1, 60);
AddReplyLinkInt("90", "", -1, 90);
AddReplyLinkInt("120", "", -1, 120);
AddReplyLinkInt("180", "", -1, 180);
AddReplyLinkInt("300", "", -1, 300);
AddReplyLinkInt("99999", "", -1, 99999);

//////////////////////////////////// LIST DICE OPTIONS /////////////////////////
DMFI_AddPage(oTool, PG_LIST_DICE);

DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D2);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D3);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D4);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D6);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D8);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D10);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D12);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D20);
DMFI_AddConversationElement(oTool, PG_LIST_DICE, CV_LD_D100);

///////////////////////////////////// TARGET_EFFECT PAGE /////////////////////////
DMFI_AddPage(oTool, PG_TARGET_EFFECT);

///////////////////////////////////// LIST_EFFECT PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_EFFECT);

/////////////////////////////////////// TARGET_SOUND PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_SOUND_CITY);
DMFI_AddPage(oTool, PG_LIST_SOUND_MAGICAL);
DMFI_AddPage(oTool, PG_LIST_SOUND_NATURE);
DMFI_AddPage(oTool, PG_LIST_SOUND_PEOPLE);

DelayCommand(6.0, DMFI_BuildPlaceableSoundList(oTool));

//////////////////////////////////////APPEARANCE TYPE DATA///////////////////////

DMFI_AddPage(oTool, PG_LIST_APPEARANCE);
DelayCommand(8.0, DMFI_BuildAppearanceList(oTool));

}