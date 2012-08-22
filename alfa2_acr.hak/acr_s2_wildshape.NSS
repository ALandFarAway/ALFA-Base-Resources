//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 06/08/2006:
//::	Remove panther
//:: AFW-OEI 07/29/2006:
//:: 	Default to brown bear

#include "x2_inc_itemprop"
#include "acr_pchide_i"

// VFX Constants
const int ACR_VFX_BACKAXE = 1999;
const int ACR_VFX_BACKPACK = 1992;
const int ACR_VFX_BACKSWORD = 1996;
const int ACR_VFX_BELTSWORD = 1993;
const int ACR_VFX_BOW = 1994;
const int ACR_VFX_QUIVER = 1998;
const int ACR_VFX_LUTE = 1997;
const int ACR_VFX_SHIELD = 1995;

void main()
{
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
	eVis = SupernaturalEffect(eVis);	// AFW-OEI 12/07/2006: Make it so you can't dispel the visual effect, which was dispelling wildshape.
    effect ePoly;
    int nPoly = POLYMORPH_TYPE_COW;	// AFW-OEI 06/08/2006: Default -- something's gone wrong if you actually become a cow.
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetLevelByClass(CLASS_TYPE_DRUID);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type

    if (nSpell == 402)
    {
        nPoly = POLYMORPH_TYPE_PANTHER;
    }
	
    else if (nSpell == 403)
    {
        nPoly = POLYMORPH_TYPE_WOLF;

        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
        }
    }
    else if (nSpell == 404)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
        }
    }
    else if (nSpell == 405)
    {
        nPoly = POLYMORPH_TYPE_BADGER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BADGER;
        }
    }
    else
    {
        nPoly = POLYMORPH_TYPE_BROWN_BEAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
        }
    }
	
	// Remove PC Tool VFXs on polymorph.
	effect eCheckP = GetFirstEffect( OBJECT_SELF ); 
	while ( GetIsEffectValid( eCheckP ) ) {
		if ( GetEffectSpellId( eCheckP ) == ACR_VFX_BACKAXE ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_BACKPACK ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_BACKSWORD ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_BELTSWORD ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_BOW ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_QUIVER ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_LUTE ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		} else if ( GetEffectSpellId( eCheckP ) == ACR_VFX_SHIELD ) {
			RemoveEffect( OBJECT_SELF, eCheckP );
		}
		eCheckP = GetNextEffect( OBJECT_SELF );	  
	}

    ePoly = EffectPolymorph(nPoly, FALSE, TRUE);	// AFW-OEI 11/27/2006: Use 3rd boolean to say this is a wildshape polymorph.
    ePoly = SupernaturalEffect(ePoly);
	ePoly = EffectLinkEffects( ePoly, eVis );
	ePoly = SupernaturalEffect(ePoly);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }




    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

	// Copy PC hide properties.
	ACR_CopyPropertiesToHide( OBJECT_SELF );
}