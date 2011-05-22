/*

    Companion and Monster AI

    This file contains routines used to initialize creatures for combat - setting
    up inventory items, auto cast long duration buffs, etc.

*/

#include "hench_i0_target"


// cast a warlock buff spell on self (bCheat is instant cast)
int TryCastWarlockBuffSpell(int nSpellID, int bCheat);

// cast warlock buff spells on self (bCheat is instant cast)
int TryCastWarlockBuffSpells(int bCheat);

// cast bard inspirations
int TryCastBardBuffSpells();

// attempt instant casting given spellID on target
// returns TRUE if next lower spell should not be cast
int TryCastInstantBuffSpell(int nSpellID, object oTarget, int bSelfOnly);

// attempt instant casting given featID and spellID on self
int TryCastInstantBuffFeat(int nFeatID, int nSpellID);

// attempt instant casting persistent spell given spellID on target
int TryCastInstantPersistentBuffSpell(int nSpellID);

// attempt instant casting persistent spells
void TryCastInstantBuffPersistentSpells();

// attempt instant casting long duration spells on target
void TryCastInstantLongDurationBuffSpellOnTarget(object oTarget);

// identify all weapons and shields in inventory
void HenchIdentifyWeapons();

// quick cast all long duration buffs on self and allies
void HenchQuickCastBuffs(int bMediumDuration);

// create identified non droppable item on self
object HenchCreateNonDroppableItem(string sItemTemplate, int nStackSize=1, int checkIfExists=FALSE);

// creates wand items that can cast equipped item spells
void HenchAllowUseofEquippedItemSpells();

// creates some healing and other potions for the creature to use
void HenchCreateItemsToUse();


int gbFoundInfiniteBuffSpell;

int TryCastWarlockBuffSpell(int nSpellID, int bCheat)
{
    if (GetHasSpell(nSpellID))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        if (!GetHasSpellEffect(nSpellID))
        {
            if (!bCheat)
            {
                ClearAllActions();
            }
//            Jug_Debug(GetName(OBJECT_SELF) + " casting spell on self " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID));
            ActionCastSpellAtObject(nSpellID, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bCheat);
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
            return !bCheat;
        }
    }
    return FALSE;
}


int TryCastWarlockBuffSpells(int bCheat)
{
    // check able to cast - skip if any spell failure
    if (GetHasEffect(EFFECT_TYPE_SPELL_FAILURE) || GetHasEffect(EFFECT_TYPE_SILENCE))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_DARK_FORESIGHT, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_FLEE_THE_SCENE, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_DARK_ONES_OWN_LUCK, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_WALK_UNSEEN, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_LEAPS_AND_BOUNDS, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_ENTROPIC_WARDING, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_DEVILS_SIGHT, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(SPELL_I_SEE_THE_UNSEEN, bCheat))
    {
        return TRUE;
    }
    if (!bCheat && GetHasSpell(SPELL_I_FLEE_THE_SCENE))
    {
        // special code to check friends
        InitializeAllyList(FALSE);
        object oFriend = OBJECT_SELF;
        while (GetIsObjectValid(oFriend))
        {
            if (GetFactionEqual(oFriend) && !GetCreatureHasItemProperty(ITEM_PROPERTY_HASTE, oFriend) &&
                !GetHasEffect(EFFECT_TYPE_HASTE, oFriend))
            {
                ClearAllActions();
                ActionCastSpellAtObject(SPELL_I_FLEE_THE_SCENE, OBJECT_SELF, METAMAGIC_NONE);
                SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
                return TRUE;
            }
            oFriend = GetLocalObject(oFriend, henchAllyStr);
        }
    }
    if (TryCastWarlockBuffSpell(SPELL_I_BEGUILING_INFLUENCE, bCheat))
    {
        return TRUE;
    }
    if (TryCastWarlockBuffSpell(1059, bCheat))	// Otherworldly Whispers
    {
        return TRUE;
    }
	//SPELL_I_THE_DEAD_WALK ??
    return FALSE;
}


int TryCastBardBuffSpells()
{
    // check able to cast - skip if any spell failure
    if (GetHasEffect(EFFECT_TYPE_SILENCE))
    {
        return TRUE;
    }
    if (GetHasFeat(FEAT_BARDSONG_INSPIRE_REGENERATION))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        InitializeAllyList(FALSE);
        object oFriend = OBJECT_SELF;
        while (GetIsObjectValid(oFriend))
        {
            if (GetDistanceToObject(oFriend) <= RADIUS_SIZE_COLOSSAL &&
                (GetCurrentHitPoints(oFriend) < GetMaxHitPoints(oFriend)) &&
                !GetHasEffect(EFFECT_TYPE_DEAF, oFriend) && 
				(GetRacialType(oFriend) != RACIAL_TYPE_CONSTRUCT) &&
				(GetRacialType(oFriend) != RACIAL_TYPE_UNDEAD))
            {
                if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_REGENERATION, oFriend))
                {
                    // leave existing one alone
                    return FALSE;
                }
                ClearAllActions();
                ActionUseFeat(FEAT_BARDSONG_INSPIRE_REGENERATION, OBJECT_SELF);
                SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
                return TRUE;
            }
            oFriend = GetLocalObject(oFriend, henchAllyStr);
        }
    }
    if (GetHasFeat(FEAT_BARDSONG_INSPIRE_COMPETENCE))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_COMPETENCE, OBJECT_SELF))
        {
            // leave existing one alone
            return FALSE;
        }
        ClearAllActions();
        ActionUseFeat(FEAT_BARDSONG_INSPIRE_COMPETENCE, OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
        return TRUE;
    }
    return FALSE;
}


const int HENCH_METAMAGIC_ANY_NO_WARLOCK = 255;
int gbInstantBuffFound;

int TryCastInstantBuffSpell(int nSpellID, object oTarget, int bSelfOnly)
{
    if (oTarget == OBJECT_SELF)
    {
        if (GetHasSpell(nSpellID))
        {
            gbInstantBuffFound = TRUE;
            if (!GetHasSpellEffect(nSpellID))
            {
//                Jug_Debug(GetName(OBJECT_SELF) + " casting spell on self " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID));
                ActionCastSpellAtObject(nSpellID, OBJECT_SELF, HENCH_METAMAGIC_ANY_NO_WARLOCK, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }
            return TRUE;
        }
        return FALSE;
    }
    if (GetHasSpell(nSpellID, oTarget) || GetHasSpellEffect(nSpellID, oTarget))
    {
        return TRUE;
    }
    if (!bSelfOnly && GetHasSpell(nSpellID))
    {
//        Jug_Debug(GetName(OBJECT_SELF) + " casting spell on target " + GetName(oTarget) + " " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID));
        ActionCastSpellAtObject(nSpellID, oTarget, HENCH_METAMAGIC_ANY_NO_WARLOCK, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        return TRUE;
    }
    return FALSE;
}


int TryCastInstantBuffFeat(int nFeatID, int nSpellID)
{
    if (GetHasFeat(nFeatID) && !GetHasSpellEffect(nSpellID))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " casting instant buff feat " + IntToString(nFeatID));
        ActionCastSpellAtObject(nSpellID, OBJECT_SELF, METAMAGIC_ANY, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        return TRUE;
    }
    return FALSE;
}


int TryCastInstantPersistentBuffSpell(int nSpellID)
{
	if (GetHasSpell(nSpellID))
	{
		gbInstantBuffFound = TRUE;
		if (!GetHasSpellEffect(nSpellID))
		{
//			Jug_Debug(GetName(OBJECT_SELF) + " casting persistent spell on self " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID));
			ActionCastSpellAtObject(nSpellID, OBJECT_SELF, METAMAGIC_PERSISTENT, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
		}
		return TRUE;
	}
	return FALSE;
}


void TryCastInstantBuffPersistentSpells()
{
	if (GetHasFeat(1679 /*FEAT_PERSISTENT_SPELL */))
	{	
		TryCastInstantPersistentBuffSpell(SPELL_HASTE);	
		TryCastInstantPersistentBuffSpell(SPELL_DEATH_ARMOR);
		TryCastInstantPersistentBuffSpell(SPELL_PRAYER);
		TryCastInstantPersistentBuffSpell(SPELL_DIVINE_FAVOR);
	}	
}


void TryCastInstantLongDurationBuffSpellOnTarget(object oTarget)
{
    if (!TryCastInstantBuffSpell(SPELL_SHADES_TARGET_CASTER, oTarget, TRUE))
    {
        if (!TryCastInstantBuffSpell(SPELL_PREMONITION, oTarget, TRUE))
        {
            if (!TryCastInstantBuffSpell(SPELL_GREATER_STONESKIN, oTarget, TRUE))
            {
                if (!TryCastInstantBuffSpell(SPELL_STONESKIN, oTarget, FALSE))
                {
                    TryCastInstantBuffSpell(SPELL_SHADES_STONESKIN, oTarget, FALSE);
                }
            }
        }
    }

    if (!(GetIsImmune(oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE) && TryCastInstantBuffSpell(SPELL_TORTOISE_SHELL, oTarget, FALSE)))
    {
        TryCastInstantBuffSpell(SPELL_BARKSKIN, oTarget, FALSE);
    }

    if (!TryCastInstantBuffSpell(SPELL_IMPROVED_MAGE_ARMOR, oTarget, FALSE))
    {
        if (!TryCastInstantBuffSpell(SPELL_MAGE_ARMOR, oTarget, FALSE))
        {
            TryCastInstantBuffSpell(SPELL_SHADOW_CONJURATION_MAGE_ARMOR, oTarget, FALSE);
        }
    }
	
    if (!TryCastInstantBuffSpell(SPELL_SUPERIOR_RESISTANCE, oTarget, FALSE))
    {
        TryCastInstantBuffSpell(SPELL_GREATER_RESISTANCE, oTarget, FALSE);
    }

    TryCastInstantBuffSpell(SPELL_DEATH_WARD, oTarget, FALSE);
    TryCastInstantBuffSpell(SPELL_FALSE_LIFE, oTarget, FALSE);

    if (!TryCastInstantBuffSpell(SPELL_PROTECTION_FROM_ENERGY, oTarget, FALSE))
    {
        TryCastInstantBuffSpell(SPELL_ENDURE_ELEMENTS, oTarget, FALSE);
    }

    if ((GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD) || GetHasSpell(SPELL_GATE, oTarget))
    {
        if (!TryCastInstantBuffSpell(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget, FALSE))
        {
            TryCastInstantBuffSpell(SPELL_PROTECTION_FROM_EVIL, oTarget, FALSE);
        }
    }
    else
    {
        if (!TryCastInstantBuffSpell(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oTarget, FALSE))
        {
            TryCastInstantBuffSpell(SPELL_PROTECTION_FROM_GOOD, oTarget, FALSE);
        }
    }
    /*  SPELL_MAGIC_VESTMENT??

        SPELL_GREATER_MAGIC_WEAPON
        SPELL_MAGIC_WEAPON

        SPELL_AWAKEN*/
	TryCastInstantBuffPersistentSpells();	
}

void TryCastInstantMediumDurationBuffSpellOnTarget(object oTarget)
{
	TryCastInstantBuffSpell(SPELL_BLESS, oTarget, TRUE);
    if (!TryCastInstantBuffSpell(1052 /* Mass_Aid */, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_AID, oTarget, FALSE);
    }
    if (!TryCastInstantBuffSpell(SPELL_MASS_BULL_STRENGTH, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_BULLS_STRENGTH, oTarget, FALSE);
    }
    if (!TryCastInstantBuffSpell(SPELL_MASS_CAT_GRACE, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_CATS_GRACE, oTarget, FALSE);
    }
    if (!TryCastInstantBuffSpell(SPELL_MASS_BEAR_ENDURANCE, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_BEARS_ENDURANCE, oTarget, FALSE);
    }
    TryCastInstantBuffSpell(SPELL_FREEDOM_OF_MOVEMENT, oTarget, FALSE);
    if (!TryCastInstantBuffSpell(SPELL_MIND_BLANK, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_LESSER_MIND_BLANK, oTarget, FALSE);
    }
    if (!TryCastInstantBuffSpell(SPELL_GHOSTLY_VISAGE, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE, oTarget, TRUE);
    }
    TryCastInstantBuffSpell(SPELL_PROTECTION_FROM_SPELLS, oTarget, TRUE);
    TryCastInstantBuffSpell(SPELL_RESIST_ENERGY, oTarget, FALSE);
    TryCastInstantBuffSpell(SPELL_SHADOW_SHIELD, oTarget, TRUE);
    TryCastInstantBuffSpell(SPELL_SPELL_RESISTANCE, oTarget, FALSE);
    if (!TryCastInstantBuffSpell(SPELL_AURAOFGLORY, oTarget, TRUE))
    {
	    if (!TryCastInstantBuffSpell(SPELL_MASS_EAGLE_SPLENDOR, oTarget, TRUE))
	    {
	        TryCastInstantBuffSpell(SPELL_EAGLES_SPLENDOR, oTarget, FALSE);
	    }
	}
    if (!TryCastInstantBuffSpell(SPELL_MASS_OWL_WISDOM, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_OWLS_WISDOM, oTarget, FALSE);
    }
    if (!TryCastInstantBuffSpell(SPELL_MASS_FOX_CUNNING, oTarget, TRUE))
    {
        TryCastInstantBuffSpell(SPELL_FOXS_CUNNING, oTarget, FALSE);
    }
    TryCastInstantBuffSpell(SPELL_SHIELD, oTarget, TRUE);
    TryCastInstantBuffSpell(SPELL_ENTROPIC_SHIELD, oTarget, TRUE);
    TryCastInstantBuffSpell(SPELL_SHIELD_OF_FAITH, oTarget, FALSE);
//	SPELL_MAGIC_FANG
//	SPELL_GREATER_MAGIC_FANG
    TryCastInstantBuffSpell(SPELL_FLAME_WEAPON, oTarget, FALSE);
//	SPELLABILITY_AS_GHOSTLY_VISAGE
//	SPELLABILITY_BG_BULLS_STRENGTH
//	803	GrayEnlarge
//	SPELL_ENLARGE_PERSON
    TryCastInstantBuffSpell(SPELL_MIRROR_IMAGE, oTarget, TRUE);
    if (!TryCastInstantBuffSpell(SPELL_GREATER_HEROISM, oTarget, FALSE))
    {
        TryCastInstantBuffSpell(SPELL_HEROISM, oTarget, FALSE);
    }
	TryCastInstantBuffSpell(SPELL_SPIDERSKIN, oTarget, FALSE);
//	SPELL_RIGHTEOUS_MIGHT
//	SPELLABILITY_ENTROPIC_SHIELD	RacialEntropic_Shield
//	SPELL_JAGGED_TOOTH
    TryCastInstantBuffSpell(SPELL_MASS_DEATH_WARD, oTarget, TRUE);
//	SPELL_I_ENTROPIC_WARDING
}


void HenchIdentifyWeapons()
{
    // Jug_Debug("@@@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + " identify every item");
    // make sure items identified so they can be used
    int i;
    object oItem;
    oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
    if (GetIsObjectValid(oItem))
    {
        SetIdentified(oItem, TRUE);
    }
    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    if (GetIsObjectValid(oItem))
    {
        SetIdentified(oItem, TRUE);
    }
    oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem))
    {
        // Jug_Debug("@@@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + " test identify " + GetName(oItem));
        if (GetWeaponType(oItem) != WEAPON_TYPE_NONE)
        {
            // Jug_Debug("@@@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + " identify " + GetName(oItem));
            SetIdentified(oItem, TRUE);
        }
        else
        {
            switch (GetBaseItemType(oItem))
            {
                case BASE_ITEM_TOWERSHIELD:
                case BASE_ITEM_LARGESHIELD:
                case BASE_ITEM_SMALLSHIELD:
                case BASE_ITEM_ARROW:
                case BASE_ITEM_BOLT:
                case BASE_ITEM_BULLET:
                    // Jug_Debug("@@@@@@@@@@@@@@@@" + GetName(OBJECT_SELF) + " identify " + GetName(oItem));
                    SetIdentified(oItem, TRUE);
                    break;
            }
        }
        oItem = GetNextItemInInventory();
    }
}


void HenchQuickCastBuffs(int bMediumDuration)
{
    InitializeBasicTargetInfo();
    InitializeAllyList(FALSE);

    // Jug_Debug(GetName(OBJECT_SELF) + " doing instant buff");
    object oFriend = OBJECT_SELF;
    while (GetIsObjectValid(oFriend))
    {
        // Jug_Debug(GetName(OBJECT_SELF) + " doing instant buff on " + GetName(oFriend));
        TryCastInstantLongDurationBuffSpellOnTarget(oFriend);
		if (bMediumDuration)
		{
        	TryCastInstantMediumDurationBuffSpellOnTarget(oFriend);
		}
        if (!gbInstantBuffFound)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, henchAllyStr);
    }
    TryCastInstantBuffFeat(FEAT_AURA_OF_COURAGE, SPELLABILITY_AURA_OF_COURAGE);
    TryCastInstantBuffFeat(1805, SPELLABILITY_PROTECTIVE_AURA);
    TryCastInstantBuffFeat(1807, SPELLABILITY_WAR_GLORY);
    TryCastInstantBuffFeat(1832, SPELLABLILITY_AURA_OF_DESPAIR);
    if (GetLevelByClass(CLASS_TYPE_WARLOCK))
    {
        TryCastWarlockBuffSpells(TRUE);
    }
}


object HenchCreateNonDroppableItem(string sItemTemplate, int nStackSize=1, int checkIfExists=FALSE)
{
    if (nStackSize < 1)
    {
        return OBJECT_INVALID;
    }
    if (GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, sItemTemplate)))
    {
        return OBJECT_INVALID;
    }
    object oInvItem = CreateItemOnObject(sItemTemplate, OBJECT_SELF, nStackSize);
    SetDroppableFlag(oInvItem, FALSE);
    SetIdentified(oInvItem, TRUE);
//  Jug_Debug(GetName(OBJECT_SELF) + " created item " + GetName(oInvItem) + " SS " + IntToString(GetItemStackSize(oInvItem)));
    return oInvItem;
}


void HenchAllowUseofEquippedItemSpells()
{
    int slotIndex;
    for (slotIndex = INVENTORY_SLOT_HEAD; slotIndex <= INVENTORY_SLOT_BELT; slotIndex++)
    {
        object oItem = GetItemInSlot(slotIndex, OBJECT_SELF);
        if (GetIsObjectValid(oItem))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " checking item " + GetName(oItem));
            itemproperty curItemProp = GetFirstItemProperty(oItem);
            object oInvItem;
            while(GetIsItemPropertyValid(curItemProp))
            {
                int iItemTypeValue = GetItemPropertyType(curItemProp);
                if (iItemTypeValue == ITEM_PROPERTY_CAST_SPELL)
                {
                    if (!GetIsObjectValid(oInvItem))
                    {
                        oInvItem = HenchCreateNonDroppableItem("x2_it_cfm_wand");
                        SetFirstName(oInvItem, GetName(oItem));
                        int nItemCharges = GetItemCharges(oItem);
                        if (nItemCharges > 0)
                        {
                        // set to 100 so it doesn't run out, small number of charges prevents talents from working
                            SetItemCharges(oInvItem, 100);
                        }
//                      Jug_Debug(GetName(OBJECT_SELF) + " created item " + GetName(oInvItem) + " SS " + IntToString(GetItemStackSize(oInvItem)));
                    }
                    AddItemProperty(DURATION_TYPE_PERMANENT, curItemProp, oInvItem);
                }
                curItemProp = GetNextItemProperty(oItem);
            }
//          if (GetIsObjectValid(oInvItem))
//          {
//              Jug_Debug(GetName(OBJECT_SELF) + " created item " + GetName(oInvItem) + " SS " + IntToString(GetItemStackSize(oInvItem)) + " identified " + IntToString(GetIdentified(oInvItem)));
//          }
        }
    }
}


void HenchCreateItemsToUse()
{
    int nHitDice = GetHitDice(OBJECT_SELF);
    int nIntel = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);
    int nAdjustment = -3;
    if (nIntel < 10)
    {
        --nAdjustment;
    }
    else if (nIntel > 12)
    {
        ++nAdjustment;
    }
    if (nHitDice <= 2)
    {
        // cure light
        HenchCreateNonDroppableItem("NW_IT_MPOTION001", (d4() + nHitDice + nAdjustment) / 3, TRUE);
    }
    else if (nHitDice <= 5)
    {
        // cure moderate
        int number = (d4() + nHitDice - 2 + nAdjustment) / 3;
        HenchCreateNonDroppableItem("NW_IT_MPOTION020", number, TRUE);
        if (number == 0)
        {
            HenchCreateNonDroppableItem("NW_IT_MPOTION001", 1, TRUE);
        }
    }
    else if (nHitDice <= 8)
    {
        // cure serious
        int number = (d4() + nHitDice - 5 + nAdjustment) / 3;
        HenchCreateNonDroppableItem("NW_IT_MPOTION002", number, TRUE);
        if (number == 0)
        {
            HenchCreateNonDroppableItem("NW_IT_MPOTION020", 1, TRUE);
        }
    }
    else if (nHitDice <= 14)
    {
        // cure critical
        int number = (d4() + nHitDice - 8 + nAdjustment) / 3;
        HenchCreateNonDroppableItem("NW_IT_MPOTION003", number, TRUE);
        if (number == 0)
        {
            HenchCreateNonDroppableItem("NW_IT_MPOTION002", 1, TRUE);
        }
    }
    else
    {
        // heal
        int number = (d4() + nHitDice - 14 + nAdjustment) / 4;
        HenchCreateNonDroppableItem("NW_IT_MPOTION012", number, TRUE);
        if (number == 0)
        {
            HenchCreateNonDroppableItem("NW_IT_MPOTION003", 2, TRUE);
        }
    }
    // speed potion
    if ((nHitDice > 10) && d20() == 1)
    {
        HenchCreateNonDroppableItem("NW_IT_MPOTION003", 2, TRUE);
    }
    // barkskin potion
    if ((nHitDice > 7) && d8() == 1)
    {
        HenchCreateNonDroppableItem("NW_IT_MPOTION004", 2, TRUE);
    }
}