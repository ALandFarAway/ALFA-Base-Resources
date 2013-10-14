using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using ItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_PCHide
{
    class PCHide
    {
        private uint m_oCreature;
        private uint m_oHide;

        public PCHide([In] uint i_oCreature, [In] uint i_oHide)
        {
            m_oCreature = i_oCreature;
            m_oHide = i_oHide;
        }

        private void stripProperties(CLRScriptBase script, uint item)
        {
            for (ItemProperty ip = script.GetFirstItemProperty(item); script.GetIsItemPropertyValid(ip) == CLRScriptBase.TRUE; ip = script.GetNextItemProperty(item))
            {
                script.RemoveItemProperty(item, ip);
            }
        }

        private uint getHide( CLRScriptBase script )
        {
            uint oHide = script.GetItemPossessedBy(m_oCreature, "acr_pchide");
            if (script.GetIsObjectValid(oHide) == CLRScriptBase.FALSE)
            {
                oHide = script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CARMOUR, m_oCreature);
                if (script.GetIsObjectValid(oHide) == CLRScriptBase.FALSE || script.GetResRef(oHide) != "acr_pchide")
                {
                    oHide = CLRScriptBase.OBJECT_INVALID;
                }
            }
            return oHide;
        }

        public bool recalculate(CLRScriptBase script)
        {
            // Ensure that both our hide and our creature are still valid.
            if (script.GetIsObjectValid(m_oCreature) == CLRScriptBase.FALSE || script.GetIsObjectValid(m_oCreature) == CLRScriptBase.FALSE)
            {
                return false;
            }

            // Recreate the hide.
            script.AssignCommand(m_oCreature, delegate { script.ClearAllActions(CLRScriptBase.FALSE); });
            uint oOldHide = getHide(script);
            m_oHide = script.CreateItemOnObject("acr_pchide", m_oCreature, 1, "acr_pchide", CLRScriptBase.FALSE);

            // Temp variables to store bonuses, to allow stacking from different sources.
            Dictionary<int, int> saveBonuses = new Dictionary<int, int>();
            Dictionary<int, int> skillBonuses = new Dictionary<int, int>();
            Dictionary<string, int> otherBonuses = new Dictionary<string, int>();

            // Initialize dictionaries.
            for (int i = 0; i < 68; i++)
            {
                skillBonuses.Add(i, 0);
            }
            for (int i = 0; i < 4; i++)
            {
                saveBonuses.Add(i, 0);
            }

            // Lore is not an official ALFA skill.
            skillBonuses[CLRScriptBase.SKILL_LORE] -= 20;

            #region Skill Focus feats
            // Handle all new shiny skill focus feats.
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_BALANCE, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_BALANCE] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_CLIMB, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_CLIMB] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_CRFT_ALCH, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_CRAFT_ALCHEMY] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_CRFT_ARM, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_CRAFT_ARMORSMITHING] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_CRFT_BOW, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_CRAFT_BOWMAKING] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_CRFT_WPN, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_CRAFT_WEAPONSMITHING] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_DECIPHER, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_DECIPHER_SCRIPT] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_DISGUISE, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_DISGUISE] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_ESC_ART, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_ESCAPE_ARTIST] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_HAND_ANIM, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_HANDLE_ANIMAL] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_JUMP, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_JUMP] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_ARC, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_ARCANA] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_DUNG, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_DUNGEONEERING] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_ENG, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_ENGINEERING] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_GEO, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_GEOGRAPHY] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_HIST, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_HISTORY] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_LOC, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_LOCAL] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_NATR, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_NATURE] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_NOBL, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_NOBILITY] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_PLAN, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_THE_PLANES] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_KNOW_RELG, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_RELIGION] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_ACT, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_ACT] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_COMD, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_COMEDY] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_DANC, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_DANCE] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_KEYB, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_KEYBOARD] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_ORAT, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_ORATORY] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_PERC, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_PERCUSSION] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_SING, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_SING] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_STRG, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_STRING_INSTRUMENTS] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PERF_WIND, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PERFORM_WIND_INSTRUMENTS] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_PROF, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_PROFESSION] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_RIDE, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_RIDE] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_SENS_MOTV, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_SPEAK_LANGUAGE] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_SPK_LANG, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_KNOWLEDGE_LOCAL] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_SWIM, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_SWIM] += 3;
            if (script.GetHasFeat((int)FEATS.FEAT_SKILL_FOCUS_USE_ROPE, m_oCreature, 0) == CLRScriptBase.TRUE) skillBonuses[(int)SKILLS.SKILL_USE_ROPE] += 3;
            #endregion

            // Artist is one bad-ass feat.
            if (script.GetHasFeat(CLRScriptBase.FEAT_ARTIST, m_oCreature, 0) == CLRScriptBase.TRUE)
            {
                // Previously: +2 perform, +2 diplomacy
                // Currently: +2 perform (all), 3 extra bardic music uses per day
                skillBonuses[CLRScriptBase.SKILL_DIPLOMACY] -= 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_ACT] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_COMEDY] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_DANCE] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_KEYBOARD] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_ORATORY] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_PERCUSSION] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_SING] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_STRING_INSTRUMENTS] += 2;
                skillBonuses[(int)SKILLS.SKILL_PERFORM_WIND_INSTRUMENTS] += 2;
            }
            
            // Add skill bonuses to item.
            foreach (int skill in skillBonuses.Keys)
            {
                if (skillBonuses[skill] == 0)
                {
                    continue;
                }
                else if (skillBonuses[skill] > 0)
                {
                    script.AddItemProperty(CLRScriptBase.DURATION_TYPE_PERMANENT, script.ItemPropertyDecreaseSkill(skill, skillBonuses[skill]), m_oHide, 0.0f);
                }
                else if (skillBonuses[skill] < 0)
                {
                    script.AddItemProperty(CLRScriptBase.DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skill, skillBonuses[skill]), m_oHide, 0.0f);
                }
            }

            // Add save bonuses to item.
            foreach (int save in saveBonuses.Keys)
            {
                if (saveBonuses[save] == 0)
                {
                    continue;
                }
                else if (saveBonuses[save] > 0)
                {
                    script.AddItemProperty(CLRScriptBase.DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrow(save, saveBonuses[save]), m_oHide, 0.0f);
                }
                else if (saveBonuses[save] < 0)
                {
                    script.AddItemProperty(CLRScriptBase.DURATION_TYPE_PERMANENT, script.ItemPropertyReducedSavingThrow(save, saveBonuses[save]), m_oHide, 0.0f);
                }
            }

            // Make the person equip the new item.
            script.AssignCommand(m_oCreature, delegate { script.ClearAllActions(CLRScriptBase.FALSE); });
            script.AssignCommand(m_oCreature, delegate { script.ActionUnequipItem(oOldHide); });
            script.AssignCommand(m_oCreature, delegate { script.ActionEquipItem(m_oHide, CLRScriptBase.INVENTORY_SLOT_CARMOUR); });
            script.DestroyObject(oOldHide, 0.0f, CLRScriptBase.FALSE);
            script.SendMessageToPC(m_oCreature, "PC Hide refreshed.");

            // Everything looks fine, return our success.
            return true;
        }

        public enum FEATS
        {
            FEAT_SKILL_FOCUS_BALANCE = 3630,
            FEAT_SKILL_FOCUS_CLIMB = 3631,
            FEAT_SKILL_FOCUS_CRFT_ALCH = 3664,
            FEAT_SKILL_FOCUS_CRFT_ARM = 3665,
            FEAT_SKILL_FOCUS_CRFT_BOW = 3666,
            FEAT_SKILL_FOCUS_CRFT_WPN = 3667,
            FEAT_SKILL_FOCUS_DECIPHER = 3632,
            FEAT_SKILL_FOCUS_DISGUISE = 3633,
            FEAT_SKILL_FOCUS_ESC_ART = 3634,
            FEAT_SKILL_FOCUS_FORGERY = 3635,
            FEAT_SKILL_FOCUS_GATH_INFO = 3636,
            FEAT_SKILL_FOCUS_HAND_ANIM = 3637,
            FEAT_SKILL_FOCUS_JUMP = 3638,
            FEAT_SKILL_FOCUS_KNOW_ARC = 3645,
            FEAT_SKILL_FOCUS_KNOW_DUNG = 3646,
            FEAT_SKILL_FOCUS_KNOW_ENG = 3647,
            FEAT_SKILL_FOCUS_KNOW_GEO = 3648,
            FEAT_SKILL_FOCUS_KNOW_HIST = 3649,
            FEAT_SKILL_FOCUS_KNOW_LOC = 3650,
            FEAT_SKILL_FOCUS_KNOW_NATR = 3651,
            FEAT_SKILL_FOCUS_KNOW_NOBL = 3652,
            FEAT_SKILL_FOCUS_KNOW_PLAN = 3653,
            FEAT_SKILL_FOCUS_KNOW_RELG = 3654,
            FEAT_SKILL_FOCUS_PERF_ACT = 3655,
            FEAT_SKILL_FOCUS_PERF_COMD = 3656,
            FEAT_SKILL_FOCUS_PERF_DANC = 3657,
            FEAT_SKILL_FOCUS_PERF_KEYB = 3658,
            FEAT_SKILL_FOCUS_PERF_ORAT = 3659,
            FEAT_SKILL_FOCUS_PERF_PERC = 3660,
            FEAT_SKILL_FOCUS_PERF_SING = 3661,
            FEAT_SKILL_FOCUS_PERF_STRG = 3662,
            FEAT_SKILL_FOCUS_PERF_WIND = 3663,
            FEAT_SKILL_FOCUS_PROF = 3639,
            FEAT_SKILL_FOCUS_RIDE = 3640,
            FEAT_SKILL_FOCUS_SENS_MOTV = 3641,
            FEAT_SKILL_FOCUS_SPK_LANG = 3642,
            FEAT_SKILL_FOCUS_SWIM = 3643,
            FEAT_SKILL_FOCUS_USE_ROPE = 3644,
        }

        public enum SKILLS
        {
            SKILL_BALANCE = 30,
            SKILL_CLIMB = 31,
            SKILL_CRAFT_ALCHEMY = 64,
            SKILL_CRAFT_ARMORSMITHING = 65,
            SKILL_CRAFT_BOWMAKING = 66,
            SKILL_CRAFT_WEAPONSMITHING = 67,
            SKILL_DECIPHER_SCRIPT = 32,
            SKILL_DISGUISE = 34,
            SKILL_ESCAPE_ARTIST = 35,
            SKILL_FORGERY = 36,
            SKILL_GATHER_INFORMATION = 37,
            SKILL_HANDLE_ANIMAL = 38,
            SKILL_JUMP = 39,
            SKILL_KNOWLEDGE_ARCANA = 40,
            SKILL_KNOWLEDGE_DUNGEONEERING = 33,
            SKILL_KNOWLEDGE_ENGINEERING = 58,
            SKILL_KNOWLEDGE_GEOGRAPHY = 55,
            SKILL_KNOWLEDGE_HISTORY = 41,
            SKILL_KNOWLEDGE_LOCAL = 59,
            SKILL_KNOWLEDGE_NATURE = 42,
            SKILL_KNOWLEDGE_NOBILITY = 56,
            SKILL_KNOWLEDGE_RELIGION = 43,
            SKILL_KNOWLEDGE_THE_PLANES = 44,
            SKILL_PERFORM_ACT = 45,
            SKILL_PERFORM_COMEDY = 63,
            SKILL_PERFORM_DANCE = 46,
            SKILL_PERFORM_KEYBOARD = 61,
            SKILL_PERFORM_ORATORY = 47,
            SKILL_PERFORM_PERCUSSION = 60,
            SKILL_PERFORM_STRING_INSTRUMENTS = 48,
            SKILL_PERFORM_SING = 49,
            SKILL_PERFORM_WIND_INSTRUMENTS = 62,
            SKILL_PROFESSION = 50,
            SKILL_RIDE = CLRScriptBase.SKILL_RIDE,
            SKILL_SENSE_MOTIVE = 51,
            SKILL_SPEAK_LANGUAGE = 52,
            SKILL_SWIM = 53,
            SKILL_USE_ROPE = 54
        }
    }
}
