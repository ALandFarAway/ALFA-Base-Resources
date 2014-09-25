using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Quest
{
    public static class Spawn
    {
        const int _SPAWN_FLAGS_IN_PC_SIGHT    = 0x000000001;
        const int _SPAWN_FLAGS_WITH_ANIMATION = 0x000000004;
        const int _SPAWN_FLAGS_RANDOM_FACING  = 0x000000010;
        const int _SPAWN_IN_STEALTH           = 0x000000040;
        const int _SPAWN_IN_DETECT            = 0x000000080;
        const int _SPAWN_BUFFED               = 0x000000100;

        const float PC_PERCEPTION_RANGE = 40.0f;

        const string _SPAWN_FLAGS = "ACR_SPA_F";
        const string _SPAWNED_OBJECT_ARRAY_LENGTH = "ACR_SPA_OAL";
        const string _SPAWN_PRESPAWN_PREDICTION_GB = "ACR_SPA_PP";
        const string _SPAWNED_OBJECT_ARRAY = "ACR_SPA_OA_";
        const string _SPAWN_PARENT_WP = "ACR_SPAWN_PARENT_WP";
        const string _WP_SPAWN_ANIMATION = "ACR_SPAWN_ANIMATION";
        const string _WP_SPAWN_IN_VFX = "ACR_SPAWN_IN_VFX";
        const string _WP_SPAWN_IN_SFX = "ACR_SPAWN_IN_SFX";
        const string _WP_SPAWN_IN_SCRIPT_ARRAY = "ACR_SPAWN_IN_SCRIPT_";

        const string ACR_COLOR_NAME = "ACR_COLOR_NAME";

        public static void SpawnCreature(string sResRef, CLRScriptBase s)
        {
            _SpawnObject(sResRef, CLRScriptBase.OBJECT_TYPE_CREATURE, s.OBJECT_SELF, s.GetLocation(s.OBJECT_SELF), s.GetLocalInt(s.OBJECT_SELF, _SPAWN_FLAGS), CLRScriptBase.FALSE, s);
        }

        public static uint _SpawnObject(string sResRef, int nObjectType, uint oWP, NWLocation lLoc, int nFlags, int nAlternate, CLRScriptBase s)
        {
            // if the object is not being spawned at it's waypoint location, we need to make sure
            // the actual spawn-in location isn't violating the "in PC sight" guidelines.
            if ((nAlternate != CLRScriptBase.FALSE) && ((nFlags & _SPAWN_FLAGS_IN_PC_SIGHT) == 0))
            {
                uint oNeighbor = s.GetNearestCreatureToLocation(CLRScriptBase.CREATURE_TYPE_PLAYER_CHAR, CLRScriptBase.PLAYER_CHAR_IS_PC, lLoc, 1, -1, -1, -1, -1);
                if (s.GetIsObjectValid(oNeighbor) == CLRScriptBase.FALSE && (s.GetDistanceBetweenLocations(lLoc, s.GetLocation(oNeighbor)) <= PC_PERCEPTION_RANGE))
                { // ACR_GetPCVisualRange() )) {
                    return CLRScriptBase.OBJECT_INVALID;
                }
                if (GetPrespawnPrediction(s) == CLRScriptBase.FALSE)
                {
                    uint oTestWP = s.GetNearestObjectToLocation(CLRScriptBase.OBJECT_TYPE_WAYPOINT, lLoc, 1);
                    int nWP_Index = 1;
                    while ((oTestWP != CLRScriptBase.OBJECT_INVALID) && (s.GetDistanceBetweenLocations(lLoc, s.GetLocation(oTestWP)) <= PC_PERCEPTION_RANGE))
                    { // ACR_GetPC_VisualRange() )) {
                        if (s.GetTag(oTestWP) == "ACR_SA_WP")
                        {
                            return CLRScriptBase.OBJECT_INVALID;
                        }
                        else
                        {
                            nWP_Index = nWP_Index + 1;
                            oTestWP = s.GetNearestObjectToLocation(CLRScriptBase.OBJECT_TYPE_WAYPOINT, lLoc, nWP_Index);
                        }
                    }
                }
            }

            uint oSpawned = s.CreateObject(nObjectType, sResRef, lLoc, nFlags & _SPAWN_FLAGS_WITH_ANIMATION, "");

            // Check to make sure it spawned ok, print an error and exit if not.
            if (s.GetIsObjectValid(oSpawned) == CLRScriptBase.FALSE)
            {
                return CLRScriptBase.OBJECT_INVALID;
            }

            // If it should be in stealth mode, place it there.
            if ((nFlags & _SPAWN_IN_STEALTH) == _SPAWN_IN_STEALTH)
            {
                s.SetActionMode(oSpawned, CLRScriptBase.ACTION_MODE_STEALTH, 1);
            }

            // If it should be in detect mode, place it there.
            if ((nFlags & _SPAWN_IN_DETECT) == _SPAWN_IN_DETECT)
            {
                s.SetActionMode(oSpawned, CLRScriptBase.ACTION_MODE_DETECT, 1);
            }

            // If this creature should buff himself, do it.
            if ((nFlags & _SPAWN_BUFFED) == _SPAWN_BUFFED)
            {
                ActivateLongTermBuffs(oSpawned, s);
            }

            // Play the spawn animation.
            s.PlayAnimation(s.GetLocalInt(oWP, _WP_SPAWN_ANIMATION), 1.0f, 0.0f);

            // Play the spawn in VFX.
            s.ApplyEffectAtLocation(CLRScriptBase.DURATION_TYPE_INSTANT, s.EffectVisualEffect(s.GetLocalInt(oWP, _WP_SPAWN_IN_VFX), CLRScriptBase.FALSE), s.GetLocation(oSpawned), 0.0f);

            // Play the spawn in SFX.
            s.AssignCommand(oSpawned, delegate { s.PlaySound(s.GetLocalString(oWP, _WP_SPAWN_IN_SFX), CLRScriptBase.FALSE); });

            // Determine facing.
            if ((nFlags & _SPAWN_FLAGS_RANDOM_FACING) == _SPAWN_FLAGS_RANDOM_FACING)
            {
                // Spawn facing is random.
                s.AssignCommand(oSpawned, delegate { s.SetFacing(new Random().Next() * 360.0f, CLRScriptBase.FALSE); });
            }

            // Colorize name if needed.
            if (s.GetLocalString(oSpawned, ACR_COLOR_NAME) != "")
            {
                s.SetFirstName(oSpawned, "<C='" + s.GetLocalString(oSpawned, ACR_COLOR_NAME) + "'>" + s.GetName(oSpawned) + "</C>");
                s.SetLastName(oSpawned, "");
            }

            // Run the spawn-in scripts, if any.
            int i = 1;
            while (true)
            {
                string sScript = s.GetLocalString(oWP, _WP_SPAWN_IN_SCRIPT_ARRAY + s.IntToString(i));
                if (sScript == "")
                {
                    break;
                }
                s.ExecuteScript(sScript, oSpawned);
                i++;
            }

            _AddObjectToSpawnPoint(oWP, oSpawned, s);

            return oSpawned;
        }

        public static int GetPrespawnPrediction(CLRScriptBase s) { return s.GetGlobalInt(_SPAWN_PRESPAWN_PREDICTION_GB); }

        public static void ActivateLongTermBuffs(uint oCaster, CLRScriptBase s)
        {

            // Cast protection from good/evil based on alignment.
            if (s.GetAlignmentGoodEvil(oCaster) == CLRScriptBase.ALIGNMENT_EVIL)
            {
                _QuickBuff(oCaster, CLRScriptBase.SPELL_PROTECTION_FROM_GOOD, s);
            }
            else
            {
                _QuickBuff(oCaster, CLRScriptBase.SPELL_PROTECTION_FROM_EVIL, s);
            }

            // Buff armor, if the creature has any.
            uint oItem = s.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CHEST, s.OBJECT_SELF);
            if (oItem != CLRScriptBase.OBJECT_INVALID)
            {
                _QuickBuff(oCaster, CLRScriptBase.SPELL_MAGIC_VESTMENT, s, oItem);
            }

            // Buff the shield, if the creature has one.
            uint oLeftHandItem = s.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_LEFTHAND, oCaster);
            uint oRightHandItem = s.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_RIGHTHAND, oCaster);
            int nLeftItemType = s.GetBaseItemType(oLeftHandItem);
            int nRightItemType = s.GetBaseItemType(oRightHandItem);
            if (GetIsItemShield(oLeftHandItem, s) != CLRScriptBase.FALSE)
            {
                _QuickBuff(oCaster, CLRScriptBase.SPELL_MAGIC_VESTMENT, s, oLeftHandItem);
            }

            // FIX ME!! Weapon-buffing should be more intelligent. But we need to be
            // able to tell what a weapon is.
            _QuickBuff(oCaster, CLRScriptBase.SPELL_KEEN_EDGE, s);
            if (s.GetHasSpell(CLRScriptBase.SPELL_GREATER_MAGIC_WEAPON, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_MAGIC_WEAPON, s);
            else _QuickBuff(oCaster, CLRScriptBase.SPELL_MAGIC_WEAPON, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_WEAPON_OF_IMPACT, s);

            _QuickBuff(oCaster, CLRScriptBase.SPELL_BARKSKIN, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_SPIDERSKIN, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_CONVICTION, s);

            if (s.GetHasSpell(CLRScriptBase.SPELL_PROTECTION_FROM_ENERGY, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_PROTECTION_FROM_ENERGY, s);
            else _QuickBuff(oCaster, CLRScriptBase.SPELL_ENDURE_ELEMENTS, s);

            _QuickBuff(oCaster, CLRScriptBase.SPELL_FREEDOM_OF_MOVEMENT, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_HEROISM, s);

            if (s.GetHasSpell(CLRScriptBase.SPELL_IMPROVED_MAGE_ARMOR, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_IMPROVED_MAGE_ARMOR, s);
            else _QuickBuff(oCaster, CLRScriptBase.SPELL_MAGE_ARMOR, s);

            if (s.GetHasSpell(CLRScriptBase.SPELL_GREATER_PLANAR_BINDING, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_PLANAR_BINDING, s);
            else if (s.GetHasSpell(CLRScriptBase.SPELL_PLANAR_BINDING, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_PLANAR_BINDING, s);
            else if (s.GetHasSpell(CLRScriptBase.SPELL_PLANAR_ALLY, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_PLANAR_ALLY, s);
            else _QuickBuff(oCaster, CLRScriptBase.SPELL_LESSER_PLANAR_BINDING, s);

            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_RESISTANCE, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_MIND_BLANK, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_ONE_WITH_THE_LAND, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_PREMONITION, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_PROTECTION_FROM_SPELLS, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_PROTECTION_FROM_ARROWS, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_BULLS_STRENGTH, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_CATS_GRACE, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_EAGLE_SPLENDOR, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_BEARS_ENDURANCE, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_FOXS_CUNNING, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_OWLS_WISDOM, s);
            _QuickBuff(oCaster, CLRScriptBase.SPELL_SEE_INVISIBILITY, s);

            if (s.GetHasSpell(CLRScriptBase.SPELL_PREMONITION, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_PREMONITION, s);
            else if (s.GetHasSpell(CLRScriptBase.SPELL_GREATER_STONESKIN, oCaster) != CLRScriptBase.FALSE)
                _QuickBuff(oCaster, CLRScriptBase.SPELL_GREATER_STONESKIN, s);
            else _QuickBuff(oCaster, CLRScriptBase.SPELL_STONESKIN, s);

            // Delay party buffs a bit in case this guy has buddies spawning in next to him.
            s.DelayCommand(6.0f, delegate { _QuickBuff(oCaster, CLRScriptBase.SPELL_MASS_CAMOFLAGE, s); });
        }

        public static void _AddObjectToSpawnPoint(uint oWP, uint oObject, CLRScriptBase s)
        {
            int i;

            // Add this creature to the list of creatures spawned from this waypoint and
            // area.

            i = s.GetLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH);
            SetLocalArrayObject(oWP, _SPAWNED_OBJECT_ARRAY, i, oObject, s);
            s.SetLocalInt(oWP, _SPAWNED_OBJECT_ARRAY_LENGTH, i + 1);

            // Add a pointer back to the waypoint, for death reporting.
            s.SetLocalObject(oObject, _SPAWN_PARENT_WP, oWP);
        }

        public static void _QuickBuff(uint oCaster, int nSpell, CLRScriptBase s, uint oTarget = CLRScriptBase.OBJECT_INVALID)
        {
            if (oTarget == CLRScriptBase.OBJECT_INVALID) oTarget = oCaster;
            s.AssignCommand(oCaster, delegate { s.ActionCastSpellAtObject(nSpell, oCaster, CLRScriptBase.METAMAGIC_ANY, CLRScriptBase.FALSE, 0, CLRScriptBase.PROJECTILE_PATH_TYPE_DEFAULT, CLRScriptBase.TRUE); });
        }

        public static int GetIsItemShield(uint oItem, CLRScriptBase s)
        {
            int nItemType = s.GetBaseItemType(oItem);
            if (nItemType == CLRScriptBase.BASE_ITEM_LARGESHIELD ||
                nItemType == CLRScriptBase.BASE_ITEM_SMALLSHIELD ||
                nItemType == CLRScriptBase.BASE_ITEM_TOWERSHIELD)
                return 1;

            return 0;
        }

        public static void SetLocalArrayObject(uint oObject, string sVarName, int nIndex, uint oValue, CLRScriptBase s)
        {
            s.SetLocalObject(oObject, sVarName + s.IntToString(nIndex), oValue);
        }
    }
}
