//::///////////////////////////////////////////////
//:: Creeping Cold
//:: NX_s0_creepcold.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/* 	
	Creeping Cold
	Transmutation [Cold]
	Level: Druid 2
	Components: V, S
	Range: Close
	Target: One creature
	Duration: 3 rounds
	Saving throw: Fortitude half
	Spell Resistance: Yes
	 
	The subject takes 1d6 cumulative points of cold damage per 
	round (that is, 1d6 on the 1st round, 2d6 on the 
	second, and 3d6 on the third).  Only one save is 
	allowed against the spell; if successful it halves 
	the damage each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.13.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
// MDiekmann 4/16/07 - Modified code so value passed to effect equaled number of dice in a given round
// MDiekmann 7/24/07 - EventSpellCastAt now uses GetSpellID instead of a constant... which was wrong

#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ginc_nx1spells"



void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare major variables
	object	oCaster		=	OBJECT_SELF;
	object	oTarget		=	GetSpellTargetObject();
	effect	eDam;
	effect	eDur 		=	EffectVisualEffect(VFX_DUR_SPELL_CREEPING_COLD);

	int		nDam;
	int		nStage		=	1;
	int		nNumStage	=	3;
	int		nSave		=	0;
	int 	nCounter 	= 	0;
	int nMetaMagic = GetMetaMagicFeat();

//discriminate targets

    if (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			//spell resistance
			if	(!ResistSpell(oCaster, oTarget))
			{
				//saving throw
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD, oCaster))
				{
					nSave	=	1;
				}
				
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nNumStage));
				
				//determine how many rounds of damage need to be applied. while loop
				while (nCounter < nNumStage)
				{
					DelayCommand(RoundsToSeconds(nCounter), EffectCreepingCold(nCounter+1, nSave, oTarget, nMetaMagic));
					nCounter++;
				}
			}
			
		}
	}
}