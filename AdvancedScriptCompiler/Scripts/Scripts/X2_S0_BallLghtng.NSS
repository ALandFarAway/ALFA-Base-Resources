//::///////////////////////////////////////////////
//:: Ball Lightning
//:: x2_s0_balllghtng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:
// ChazM 1/29/07 - updated call to DoMissileStorm() w/ new interface

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
void main()
{

  /*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  */

    if (!X2PreSpellCastCode())
    {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

   // End of Spell Cast Hook

   //SpawnScriptDebugger();                         503
   // old prototype and instance
	//void DoMissileStorm(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nMaxHits = 10 );
    //DoMissileStorm(1, 15, GetSpellId(), 503,VFX_IMP_LIGHTNING_S ,DAMAGE_TYPE_ELECTRICAL, FALSE, TRUE );

   // new prototype and instance
	//void DoMissileStorm(int nD6Dice, int nCap, int nSpell, int nVIS = VFX_IMP_MAGBLUE, int nDamageType = DAMAGE_TYPE_MAGICAL, int iReflexSaveType = -1, int nMaxHits = 10 )
    DoMissileStorm(1, 15, GetSpellId(), VFX_IMP_LIGHTNING_S, DAMAGE_TYPE_ELECTRICAL, SAVING_THROW_TYPE_ELECTRICITY);
}