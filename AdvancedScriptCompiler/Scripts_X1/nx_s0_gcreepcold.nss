//::///////////////////////////////////////////////
//:: Creeping Cold
//:: NX_s0_creepcold.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/* 	
	 	
	Creeping Cold, Greater
	Transmutation [Cold]
	Level: Druid 4
	Components: V, S
	Range: Close
	Target: One Creature
	Duration: See text
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	 
	This spell is the same as creeping cold, but the 
	duration increases by 1 round, during which the 
	subject takes 4d6 points of cold damage.  If you
	 are at least 15th level the spell lasts for 5 
	 rounds and deals 5d6 points of cold damage.  If 
	 you are at least 20th level, the spell lasts for 
	 6 rounds and deals 6d6 points of cold damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.13.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: MDiekmann 4/16/07 - Modified code so value passed to effect equaled number of dice in a given round
//:: AFW-OEI 07/10/2007: NX1 VFX

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
	int		nCasterLvl	=	GetCasterLevel(oCaster);
	int		nDam;
	int		nNumStage;
	int		nSave		=	0;
	int 	nCounter 	= 	0;
	int nMetaMagic = GetMetaMagicFeat();
	
//determine duration
	if (nCasterLvl > 19)
	{
		nNumStage	=	6;
	}
	else if (nCasterLvl > 14)
	{
		nNumStage	=	5;
	}
	else
	{
		nNumStage	=	4;
	}
	
//discriminate targets

    if (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1043, TRUE));
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