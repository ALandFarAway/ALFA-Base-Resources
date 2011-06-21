////////////////////////////////////////////////////////////////////////////////
// dmfi_conv_def_pc - DM Friendly Initiative -  Defines Player Conversation Tokens
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/14/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "dmfi_inc_tool"

void main()
{
object oTool = OBJECT_SELF;
int n;

////////////////////////////////////// TARGET ABILITY //////////////////////////
DMFI_AddPage(oTool, PG_LIST_ABILITY);

DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_STRENGTH) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_ABILITY_STRENGTH);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_DEXTERITY) , DMFI_CHAR_CMD + PRM_ROLL  +PRM_+  PRM_ABILITY_DEXTERITY);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_CONSTITUTION) , DMFI_CHAR_CMD + PRM_ROLL  +PRM_+  PRM_ABILITY_CONSTITUTION);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_INTELLIGENCE) , DMFI_CHAR_CMD + PRM_ROLL  +PRM_+  PRM_ABILITY_INTELLIGENCE);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_WISDOM) , DMFI_CHAR_CMD + PRM_ROLL  +PRM_+ PRM_ABILITY_WISDOM);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_ABL_CHARISMA) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_ABILITY_CHARISMA);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_SAVE_FORTITUDE) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_SAVE_FORTITUDE, COLOR_ORANGE);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_SAVE_REFLEX) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_SAVE_REFLEX, COLOR_ORANGE);
DMFI_AddConversationElement(oTool,  PG_LIST_ABILITY,        DMFI_CapitalizeWord(EMT_SAVE_WILL) , DMFI_CHAR_CMD + PRM_ROLL +PRM_+ PRM_SAVE_WILL, COLOR_ORANGE);

//////////////////////////////////// TARGET SKILL PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_SKILL);
DMFI_Build2DAList(oTool, PG_LIST_SKILL, DMFI_2DA_SKILLS);


//////////////////////////////////// SMALL NUMBER PAGE /////////////////////////
DMFI_AddPage(oTool, PG_LIST_10);
for (n=1; n<9; n=n+1)
{
    DMFI_AddConversationElement(oTool, PG_LIST_10, IntToString(n));
}

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

//////////////////////////////////// LIST LANGUAGE PAGE ////////////////////////
DMFI_AddPage(oTool, PG_LIST_LANGUAGE);

DMFI_AddPage(oTool, PG_LIST_DMLANGUAGE);
DelayCommand(2.0, DMFI_BuildLanguageDMList(oTool));
}