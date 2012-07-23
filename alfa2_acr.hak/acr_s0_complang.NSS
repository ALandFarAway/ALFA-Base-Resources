////////////////////////////////////////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "acr_spells_i" 
#include "x0_I0_SPELLS" 
#include "acr_tools_i"


void _EndComprehendLanguagesSpell(object oPC);

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	// End of Spell Cast Hook
	int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    float fDuration = 10 * 60 * IntToFloat(nCasterLevel);
	//Make Metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2;
    } else if (nMetaMagic == METAMAGIC_PERSISTENT) {
		fDuration = HoursToSeconds(24);
	}
	if (!MyResistSpell(OBJECT_SELF, oTarget)) {
		// check if this supercedes an existing Comprehend Languages spell
		if (GetLocalInt(oPC, "ACR_SPELL_COMPREHEND_LANGUAGES") == TRUE) {
			SendMessageToPC(oPC, "Your prior Comprehend Languages spell is cancelled by the new effect, which allows you to understand "+ACR_CleanCreatureNameTextForPlayers(GetName(oTarget))+".");
			SetLocalInt(oPC, "ACR_COMPREHEND_LANGUAGES_RECAST", TRUE);
		} else {	
			SendMessageToPC(oPC, "You can now understand languages spoken by "+ACR_CleanCreatureNameTextForPlayers(GetName(oTarget))+".");
		}
		SetLocalInt(oPC, "ACR_SPELL_COMPREHEND_LANGUAGES", TRUE);
		SetLocalObject(oPC, "ACR_COMPREHEND_LANGUAGES_TARGET", oTarget);
		// queue up the spell expiration
		DelayCommand(fDuration, _EndComprehendLanguagesSpell(oPC));
	}
}



void _EndComprehendLanguagesSpell(object oPC)
{
	// if the spell has been re-cast since the initial casting, wait for the more advacned 
	//   delaycommand to clear the effects.
	if (GetLocalInt(oPC, "ACR_COMPREHEND_LANGUAGES_RECAST") == FALSE) {
		SendMessageToPC(oPC, "Comprehend Language spell on "+GetName(GetLocalObject(oPC, "ACR_COMPREHEND_LANGUAGES_TARGET"))+" has expired.");
		DeleteLocalInt(oPC, "ACR_SPELL_COMPREHEND_LANGUAGES");
		DeleteLocalObject(oPC, "ACR_COMPREHEND_LANGUAGES_TARGET");

	} else {
		// The spell has been recast since the casting which drew this function call.
		//   clear the boolean flag for recasting, wait for the next call to clear effects.
		DeleteLocalInt(oPC, "ACR_COMPREHEND_LANGUAGES_RECAST");
		SendMessageToPC(oPC, "Comprehend Language spell continues, target: "+GetName(GetLocalObject(oPC, "ACR_COMPREHEND_LANGUAGES_TARGET")));
	}
}