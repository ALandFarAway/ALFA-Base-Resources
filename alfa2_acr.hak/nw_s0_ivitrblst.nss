//::///////////////////////////////////////////////
//:: Invocation: Vitriolic Blast (Warlock Invocation)
//:: NW_S0_IVitrBlst.nss
//:://////////////////////////////////////////////
/*
    Does 1d6 Acid Dmg per "ranking" of Eldritch Blast.
    Additionally, does Acid damage for several rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 22, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


#include "nw_i0_invocatns"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    if(GetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE) ||
       GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE))
    {
        ACR_LogEvent(OBJECT_SELF, ACR_LOG_COMBAT, "Character "+GetName(OBJECT_SELF)+" has activated Eldritch Blast while using Combat Expertise.");
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();

    // Additional Effects: (Combust Effect)
    DoEssenceVitriolicBlast(OBJECT_SELF, oTarget);
}