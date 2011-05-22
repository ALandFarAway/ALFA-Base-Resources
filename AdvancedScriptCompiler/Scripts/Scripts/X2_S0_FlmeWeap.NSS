//::///////////////////////////////////////////////
//:: Flame Weapon
//:: X2_S0_FlmeWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//  Gives a melee weapon 1d4 fire damage +1 per caster
//  level to a maximum of +10.
  3.5: Gives a melee weapon +1d6 fire damage (flat).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System


// (Update JLR - OEI 07/26/05) -- 3.5 Update
// (Update BDF - OEI 08/29/05) -- Corrected the spellID param value of ItemPropertyOnHitCastSpell
// AFW-OEI 07/23/2007: If it's going to be fixed fire damage, forget the fancy on-hit spell and just
//	go with our elemental damage item property.  Also, increase to 1d8.
// RPGplayer1 03/19/2008: Won't replace non-fire elemental damage
// RPGplayer1 01/11/2009: Corrected duration to 1 turn/level


#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"



void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nDuration = GetCasterLevel(OBJECT_SELF);
	
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
	
	object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();	
	
	if(GetIsObjectValid(oMyWeapon) )
	{
		SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		
		if (nDuration > 0)
		{
			itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oMyWeapon, ipFlame, TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		}
		return;
	 }
	 else
	 {
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	 }
}

/* AFW-OEI 07/23/2007: Keep around for posterity.
void AddFlamingEffectToWeapon(object oTarget, float fDuration, int nCasterLevel)
{
	//SpawnScriptDebugger();
	
   // If the spell is cast again, any previous itemproperties matching are removed.
   // JLR - OEI 07/26/05 -- Now it does a fixed 1d6 Fire dmg:
//   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(124,nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	itemproperty ipOnHitCastSpell = ItemPropertyOnHitCastSpell( 141, nCasterLevel );
	itemproperty ipVis = ItemPropertyVisualEffect( ITEM_VISUAL_FIRE );
	
   	IPSafeAddItemProperty(oTarget, ipOnHitCastSpell, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   	IPSafeAddItemProperty(oTarget, ipVis, fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
	
   	return;
}

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook


    //Declare major variables
    //effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);	// NWN1 VFX
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VX
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FLAME_WEAPON );	// NWN2 VFX
    int nDuration = 2 * GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);

    //Limit nCasterLvl to 10, so it max out at +10 to the damage.
    if(nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

   object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

   if(GetIsObjectValid(oMyWeapon) )
   {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            // haaaack: store caster level on item for the on hit spell to work properly
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));	// NWN1 VX
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration),nCasterLvl);

         }
            return;
    }
     else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
}
*/