// Read Magic
// Created for ALFA by Riotnrrd 4/5/2009

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	object oCaster = OBJECT_SELF;
	int nMetaMagic = GetMetaMagicFeat();
	float fDur = TurnsToSeconds(GetCasterLevel(oCaster));
    if (nMetaMagic == METAMAGIC_EXTEND) {
        fDur = fDur * 2;
    } else if (nMetaMagic == METAMAGIC_PERSISTENT) {
		fDur = HoursToSeconds(24);
	}		
	ActionSpeakString(GetName(oCaster) + " has cast Read Magic.", TALKVOLUME_SILENT_SHOUT);	
	DelayCommand(fDur, ActionSpeakString(GetName(oCaster) + " Read Magic has ended.", TALKVOLUME_SILENT_SHOUT));
}