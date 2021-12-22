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

using OEIShared.IO.GFF;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Items
{
    public class GenerateScroll: CLRScriptBase
    {
        private const int PRICE_SCROLL_LEVEL_0 = 5;
        private const int PRICE_SCROLL_LEVEL_1 = 10;
        private const int PRICE_SCROLL_LEVEL_2 = 60;
        private const int PRICE_SCROLL_LEVEL_3 = 150;
        private const int PRICE_SCROLL_LEVEL_4 = 280;
        private const int PRICE_SCROLL_LEVEL_5 = 450;
        private const int PRICE_SCROLL_LEVEL_6 = 660;
        private const int PRICE_SCROLL_LEVEL_7 = 910;
        private const int PRICE_SCROLL_LEVEL_8 = 1200;
        private const int PRICE_SCROLL_LEVEL_9 = 1530;

        public static int NewScroll(CLRScriptBase script, int maxValue)
        {
            #region Early Return if No Scrolls Fit the Criteria
            if (maxValue < PRICE_SCROLL_LEVEL_0)
            {
                return 0;
            }
            #endregion

            #region Generate up to Level 9 Scrolls
            if (maxValue >= PRICE_SCROLL_LEVEL_9)
            {
                int roll = Generation.rand.Next(512);
                if((roll & 256) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if((roll & 128) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 64) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else if ((roll & 32) == 0)
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
                else if ((roll & 16) == 0)
                {
                    script.CreateItemOnObject(Level4Scrolls[Generation.rand.Next(Level4Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_4;
                }
                else if ((roll & 8) == 0)
                {
                    script.CreateItemOnObject(Level5Scrolls[Generation.rand.Next(Level5Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_5;
                }
                else if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level6Scrolls[Generation.rand.Next(Level6Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_6;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level7Scrolls[Generation.rand.Next(Level7Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_7;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level8Scrolls[Generation.rand.Next(Level8Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_8;
                }
                else
                {
                    script.CreateItemOnObject(Level9Scrolls[Generation.rand.Next(Level9Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_9;
                }
            }
            #endregion

            #region Generate up to Level 8 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_8)
            {
                int roll = Generation.rand.Next(256);
                if ((roll & 128) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 64) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 32) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else if ((roll & 16) == 0)
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
                else if ((roll & 8) == 0)
                {
                    script.CreateItemOnObject(Level4Scrolls[Generation.rand.Next(Level4Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_4;
                }
                else if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level5Scrolls[Generation.rand.Next(Level5Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_5;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level6Scrolls[Generation.rand.Next(Level6Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_6;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level7Scrolls[Generation.rand.Next(Level7Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_7;
                }
                else
                {
                    script.CreateItemOnObject(Level8Scrolls[Generation.rand.Next(Level8Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_8;
                }
            }
            #endregion

            #region Generate up to Level 7 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_7)
            {
                int roll = Generation.rand.Next(128);
                if ((roll & 64) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 32) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 16) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else if ((roll & 8) == 0)
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
                else if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level4Scrolls[Generation.rand.Next(Level4Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_4;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level5Scrolls[Generation.rand.Next(Level5Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_5;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level6Scrolls[Generation.rand.Next(Level6Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_6;
                }
                else
                {
                    script.CreateItemOnObject(Level7Scrolls[Generation.rand.Next(Level7Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_7;
                }
            }
            #endregion

            #region Generate up to Level 6 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_6)
            {
                int roll = Generation.rand.Next(64);
                if ((roll & 32) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 16) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 8) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level4Scrolls[Generation.rand.Next(Level4Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_4;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level5Scrolls[Generation.rand.Next(Level5Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_5;
                }
                else
                {
                    script.CreateItemOnObject(Level6Scrolls[Generation.rand.Next(Level6Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_6;
                }
            }
            #endregion

            #region Generate up to Level 5 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_5)
            {
                int roll = Generation.rand.Next(32);
                if ((roll & 16) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 8) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level4Scrolls[Generation.rand.Next(Level4Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_4;
                }
                else
                {
                    script.CreateItemOnObject(Level5Scrolls[Generation.rand.Next(Level5Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_5;
                }
            }
            #endregion

            #region Generate up to Level 4 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_4)
            {
                int roll = Generation.rand.Next(16);
                if ((roll & 8) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
                else
                {
                    script.CreateItemOnObject(Level4Scrolls[Generation.rand.Next(Level4Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_4;
                }
            }
            #endregion

            #region Generate up to Level 3 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_3)
            {
                int roll = Generation.rand.Next(8);
                if ((roll & 4) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
                else
                {
                    script.CreateItemOnObject(Level3Scrolls[Generation.rand.Next(Level3Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_3;
                }
            }
            #endregion

            #region Generate up to Level 2 Scrolls
            else if (maxValue > PRICE_SCROLL_LEVEL_2)
            {
                int roll = Generation.rand.Next(4);
                if ((roll & 2) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
                else
                {
                    script.CreateItemOnObject(Level2Scrolls[Generation.rand.Next(Level2Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_2;
                }
            }
            #endregion

            #region Generate up to Level 1 Spells
            else if (maxValue > PRICE_SCROLL_LEVEL_1)
            {
                int roll = Generation.rand.Next(2);
                if ((roll & 1) == 0)
                {
                    script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_0;
                }
                else
                {
                    script.CreateItemOnObject(Level1Scrolls[Generation.rand.Next(Level1Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                    return PRICE_SCROLL_LEVEL_1;
                }
            }
            #endregion

            #region Only Generate Level 0 Spells
            else
            {
                script.CreateItemOnObject(Level0Scrolls[Generation.rand.Next(Level0Scrolls.Count)], script.OBJECT_SELF, 1, "", FALSE);
                return PRICE_SCROLL_LEVEL_0;
            }
            #endregion
        }

        #region Level 0 Scrolls
        public static List<string> Level0Scrolls = new List<string>
        {
            "abr_scroll_0_acidsplash",
            "abr_scroll_0_cmi",
            "abr_scroll_0_daze",
            "abr_scroll_0_detmagic",
            "abr_scroll_0_disruptundead",
            "abr_scroll_0_flare",
            "abr_scroll_0_light",
            "abr_scroll_0_rayfrost",
            "abr_scroll_0_readmagic",
            "abr_scroll_0_resistance",
            "abr_scroll_0_touchfatigue",
            "abr_scroll_0_virtue",
            "abr_scroll_0_arcanemark",
            "abr_scroll_0_cureminorwounds",
            "abr_scroll_0_dancinglights",
            "abr_scroll_0_detpoison",
            "abr_scroll_0_ghostsound",
            "abr_scroll_0_knowdir",
            "abr_scroll_0_magehand",
            "abr_scroll_0_mending",
            "abr_scroll_0_message",
            "abr_scroll_0_open/close",
            "abr_scroll_0_prestidigitation",
            
        };
        #endregion

        #region Level 1 Scrolls
        public static List<string> Level1Scrolls = new List<string>
        {
            "abr_scroll_1_amplify",
            "abr_scroll_1_bane",
            "abr_scroll_1_bladeoffire",
            "abr_scroll_1_bless",
            "abr_scroll_1_brnghands",
            "abr_scroll_1_camouflage",
            "abr_scroll_1_causefear",
            "abr_scroll_1_chrmperson",
            "abr_scroll_1_clw",
            "abr_scroll_1_colorspray",
            "abr_scroll_1_complang",
            "abr_scroll_1_conviction",
            "abr_scroll_1_detectundead",
            "abr_scroll_1_divfav",
            "abr_scroll_1_doom",
            "abr_scroll_1_endureelements",
            "abr_scroll_1_enlarge",
            "abr_scroll_1_entangle",
            "abr_scroll_1_entropicshld",
            "abr_scroll_1_expedretreat",
            "abr_scroll_1_foundatstone",
            "abr_scroll_1_grease",
            "abr_scroll_1_inflictlight",
            "abr_scroll_1_lorbofacid",
            "abr_scroll_1_lorbofcold",
            "abr_scroll_1_lorbofelectricity",
            "abr_scroll_1_lorboffire",
            "abr_scroll_1_lorbofsound",
            "abr_scroll_1_lowlightvis",
            "abr_scroll_1_lsvigor",
            "abr_scroll_1_magearmor",
            "abr_scroll_1_magicfang",
            "abr_scroll_1_magicmissile",
            "abr_scroll_1_magicweapon",
            "abr_scroll_1_nightshield",
            "abr_scroll_1_protfrmalign",
            "abr_scroll_1_rayenfeeble",
            "abr_scroll_1_reduceperson",
            "abr_scroll_1_removefear",
            "abr_scroll_1_sanctuary",
            "abr_scroll_1_scare",
            "abr_scroll_1_shield",
            "abr_scroll_1_shieldfaith",
            "abr_scroll_1_shockgrasp",
            "abr_scroll_1_sleep",
            "abr_scroll_1_smncreat1",
            "abr_scroll_1_truestrike",
            "abr_scroll_1_alarm",
            "abr_scroll_1_complang",
            "abr_scroll_1_disguiseself",
            "abr_scroll_1_featherfall",
            "abr_scroll_1_identify",
            "abr_scroll_1_jump",
            "abr_scroll_1_magicaura",
            "abr_scroll_1_snakeswiftness",
            "abr_scroll_1_speakanimals",
        };
        #endregion

        #region Level 2 Scrolls
        public static List<string> Level2Scrolls = new List<string>
        {
            "abr_scroll_2_aid",
            "abr_scroll_2_animalisticpwr",
            "abr_scroll_2_animalmessenger",
            "abr_scroll_2_auraglory",
            "abr_scroll_2_barkskin",
            "abr_scroll_2_bearsendure",
            "abr_scroll_2_bilinddeaf",
            "abr_scroll_2_bladeweave",
            "abr_scroll_2_blgironhorn",
            "abr_scroll_2_blindsight",
            "abr_scroll_2_blur",
            "abr_scroll_2_bodysun",
            "abr_scroll_2_bullstr",
            "abr_scroll_2_catsgrace",
            "abr_scroll_2_cloudbewilder",
            "abr_scroll_2_cmw",
            "abr_scroll_2_combust",
            "abr_scroll_2_curseimpblade",
            "abr_scroll_2_darkness",
            "abr_scroll_2_dazemon",
            "abr_scroll_2_deatharmor",
            "abr_scroll_2_deathknell",
            "abr_scroll_2_delaypoison",
            "abr_scroll_2_detthoughts",
            "abr_scroll_2_eaglessplendor",
            "abr_scroll_2_falselife",
            "abr_scroll_2_findtraps",
            "abr_scroll_2_fireburst",
            "abr_scroll_2_flameweapon",
            "abr_scroll_2_foxcunning",
            "abr_scroll_2_gedleeelectloop",
            "abr_scroll_2_ghostlyvisage",
            "abr_scroll_2_ghoultouch",
            "abr_scroll_2_gustwind",
            "abr_scroll_2_healingsting",
            "abr_scroll_2_holdanimal",
            "abr_scroll_2_holdperson",
            "abr_scroll_2_impblades",
            "abr_scroll_2_inflictmoderate",
            "abr_scroll_2_invisibility",
            "abr_scroll_2_knock",
            "abr_scroll_2_lesserdispel",
            "abr_scroll_2_livingundeath",
            "abr_scroll_2_locateobj",
            "abr_scroll_2_lsrstr",
            "abr_scroll_2_melfacidarrow",
            "abr_scroll_2_mirrorimage",
            "abr_scroll_2_owlswisdom",
            "abr_scroll_2_protectfromarrows",
            "abr_scroll_2_reduceanimal",
            "abr_scroll_2_resistelements",
            "abr_scroll_2_resistenergy",
            "abr_scroll_2_rmprlys",
            "abr_scroll_2_scare",
            "abr_scroll_2_scorchingray",
            "abr_scroll_2_seeinvisible",
            "abr_scroll_2_shieldother",
            "abr_scroll_2_silence",
            "abr_scroll_2_snakeswift",
            "abr_scroll_2_snowballswarm",
            "abr_scroll_2_soundburst",
            "abr_scroll_2_spidclimb",
            "abr_scroll_2_stabilize",
            "abr_scroll_2_summoncreat02",
            "abr_scroll_2_touchidiocy",
            "abr_scroll_2_undetalign",
            "abr_scroll_2_web",
        };
        #endregion

        #region Level 3 Scrolls
        public static List<string> Level3Scrolls = new List<string>
        {
            "abr_scroll_3_animatedead",
            "abr_scroll_3_bestowcurse",
            "abr_scroll_3_calllightning",
            "abr_scroll_3_charmmonster",
            "abr_scroll_3_circlevsalign",
            "abr_scroll_3_clairaudivoy",
            "abr_scroll_3_confusion",
            "abr_scroll_3_contagion",
            "abr_scroll_3_csw",
            "abr_scroll_3_deepslumber",
            "abr_scroll_3_dehydrate",
            "abr_scroll_3_deityvisageless",
            "abr_scroll_3_dispelmagic",
            "abr_scroll_3_displacement",
            "abr_scroll_3_domanimal",
            "abr_scroll_3_fear",
            "abr_scroll_3_fireball",
            "abr_scroll_3_flamearrow",
            "abr_scroll_3_glyphwarding",
            "abr_scroll_3_greatmagicfang",
            "abr_scroll_3_greatmagicweap",
            "abr_scroll_3_gustofwind",
            "abr_scroll_3_haltundead",
            "abr_scroll_3_haste",
            "abr_scroll_3_heroism",
            "abr_scroll_3_hypothermia",
            "abr_scroll_3_impendingbladesmass",
            "abr_scroll_3_impmagearmor",
            "abr_scroll_3_infestmaggots",
            "abr_scroll_3_inflictserious",
            "abr_scroll_3_invispurge",
            "abr_scroll_3_invissphere",
            "abr_scroll_3_jaggedtooth",
            "abr_scroll_3_keenedge",
            "abr_scroll_3_lightning",
            "abr_scroll_3_magicvestment",
            "abr_scroll_3_massaid",
            "abr_scroll_3_mestilacidbreath",
            "abr_scroll_3_neutralpoison",
            "abr_scroll_3_poison",
            "abr_scroll_3_prayer",
            "abr_scroll_3_pwordmaladroit",
            "abr_scroll_3_pwordweaken",
            "abr_scroll_3_quillfire",
            "abr_scroll_3_rage",
            "abr_scroll_3_rayexhaust",
            "abr_scroll_3_removeblinddeaf",
            "abr_scroll_3_removedisease",
            "abr_scroll_3_rmvcrs",
            "abr_scroll_3_scintillsphere",
            "abr_scroll_3_seeinvis",
            "abr_scroll_3_slow",
            "abr_scroll_3_snakeswiftmass",
            "abr_scroll_3_spiderskin",
            "abr_scroll_3_spikegrowth",
            "abr_scroll_3_srglght",
            "abr_scroll_3_stinkingcloud",
            "abr_scroll_3_summoncreat03",
            "abr_scroll_3_tashhidlaugh",
            "abr_scroll_3_vampirtouch",
            "abr_scroll_3_vigor",
            "abr_scroll_3_vigorlessermass",
            "abr_scroll_3_vinemine",
            "abr_scroll_3_weaponimpact",
        };
        #endregion

        #region Level 4 Scrolls
        public static List<string> Level4Scrolls = new List<string>
        {
            "abr_scroll_4_assayresist",
            "abr_scroll_4_castigate",
            "abr_scroll_4_ccw",
            "abr_scroll_4_creepcoldgreat",
            "abr_scroll_4_deathward",
            "abr_scroll_4_dimdoor",
            "abr_scroll_4_divinepower",
            "abr_scroll_4_dominateperson",
            "abr_scroll_4_elementalshield",
            "abr_scroll_4_enervation",
            "abr_scroll_4_evardsblktent",
            "abr_scroll_4_flamestrike",
            "abr_scroll_4_freedomofmove",
            "abr_scroll_4_globeinvulnlesser",
            "abr_scroll_4_globeinvulnmin",
            "abr_scroll_4_hammerofgods",
            "abr_scroll_4_holdmonster",
            "abr_scroll_4_icestorm",
            "abr_scroll_4_inflictcrit",
            "abr_scroll_4_invisgreat",
            "abr_scroll_4_ismissilestormless",
            "abr_scroll_4_moonbolt",
            "abr_scroll_4_orbofacid",
            "abr_scroll_4_orbofcold",
            "abr_scroll_4_orbofelectricity",
            "abr_scroll_4_orboffire",
            "abr_scroll_4_orbofsound",
            "abr_scroll_4_phantkiller",
            "abr_scroll_4_polyself",
            "abr_scroll_4_recitation",
            "abr_scroll_4_reducepersonmass",
            "abr_scroll_4_resistgreat",
            "abr_scroll_4_restoration",
            "abr_scroll_4_shadowconj",
            "abr_scroll_4_shout",
            "abr_scroll_4_spellbreachless",
            "abr_scroll_4_spellbreachleast",
            "abr_scroll_4_stoneskin",
            "abr_scroll_4_sumcreat04",
            "abr_scroll_4_wallfire",
            "abr_scroll_4_warcry",
        };
        #endregion

        #region Level 5 Scrolls
        public static List<string> Level5Scrolls = new List<string>
        {
            "abr_scroll_5_arcoflightning",
            "abr_scroll_5_awaken",
            "abr_scroll_5_battletide",
            "abr_scroll_5_bigbyinterpose",
            "abr_scroll_5_cacaphonicburst",
            "abr_scroll_5_calllightningstorm",
            "abr_scroll_5_cloudkill",
            "abr_scroll_5_coneofcold",
            "abr_scroll_5_contagionmass",
            "abr_scroll_5_curelightmass",
            "abr_scroll_5_dismissal",
            "abr_scroll_5_etherealvisage",
            "abr_scroll_5_feeblemind",
            "abr_scroll_5_firebrand",
            "abr_scroll_5_fireburstgreat",
            "abr_scroll_5_healanimalcompanion",
            "abr_scroll_5_heroismgreat",
            "abr_scroll_5_inferno",
            "abr_scroll_5_inflictlightmass",
            "abr_scroll_5_mindblanklesser",
            "abr_scroll_5_mindfog",
            "abr_scroll_5_planebindless",
            "abr_scroll_5_pworddisable",
            "abr_scroll_5_reducepersongr",
            "abr_scroll_5_rejuvcocoon",
            "abr_scroll_5_rightmight",
            "abr_scroll_5_shroudflame",
            "abr_scroll_5_slaylive",
            "abr_scroll_5_songdiscrd",
            "abr_scroll_5_spellmantleless",
            "abr_scroll_5_spellresist",
            "abr_scroll_5_sumcreat05",
            "abr_scroll_5_trueseeing",
            "abr_scroll_5_vinemine",
            "abr_scroll_5_vitsphere",
            "abr_scroll_5_walldispel",
        };
        #endregion

        #region Level 6 Scrolls
        public static List<string> Level6Scrolls = new List<string>
        {
            "abr_scroll_6_acidfog",
            "abr_scroll_6_banishment",
            "abr_scroll_6_bearsendurancemass",
            "abr_scroll_6_bigbyforce",
            "abr_scroll_6_bladebar",
            "abr_scroll_6_bullsstmass",
            "abr_scroll_6_catsgracemass",
            "abr_scroll_6_chainlightn",
            "abr_scroll_6_circledeath",
            "abr_scroll_6_controlundead",
            "abr_scroll_6_createundead",
            "abr_scroll_6_crumble",
            "abr_scroll_6_curemodemass",
            "abr_scroll_6_dirge",
            "abr_scroll_6_dispellmagicgreat",
            "abr_scroll_6_eaglessplendmass",
            "abr_scroll_6_energyimmun",
            "abr_scroll_6_fleshtostone",
            "abr_scroll_6_foxscunngmass",
            "abr_scroll_6_gloveinvulnerable",
            "abr_scroll_6_harm",
            "abr_scroll_6_heal",
            "abr_scroll_6_inflictmodemass",
            "abr_scroll_6_ismissilestormgreat",
            "abr_scroll_6_ismissilestormgreat",
            "abr_scroll_6_legendlore",
            "abr_scroll_6_owlswismass",
            "abr_scroll_6_planarally",
            "abr_scroll_6_planebind",
            "abr_scroll_6_resistsuperior",
            "abr_scroll_6_shades",
            "abr_scroll_6_spellbreachgreat",
            "abr_scroll_6_stonebody",
            "abr_scroll_6_stonehold",
            "abr_scroll_6_stoneskingreat",
            "abr_scroll_6_stonetoflesh",
            "abr_scroll_6_summoncrea06",
            "abr_scroll_6_tensertransform",
            "abr_scroll_6_tortoiseshell",
            "abr_scroll_6_undeathtodeath",
            "abr_scroll_6_vigorouscycle",
        };
        #endregion

        #region Level 7 Scrolls
        public static List<string> Level7Scrolls = new List<string>
        {
            "abr_scroll_7_auravitality",
            "abr_scroll_7_avasculate",
            "abr_scroll_7_bigbygrasp",
            "abr_scroll_7_creepdoom",
            "abr_scroll_7_cureseriousmass",
            "abr_scroll_7_destruction",
            "abr_scroll_7_drown",
            "abr_scroll_7_etheraljaunt",
            "abr_scroll_7_fingerofdeath",
            "abr_scroll_7_fireballdelay",
            "abr_scroll_7_firestorm",
            "abr_scroll_7_inflictseriousmass",
            "abr_scroll_7_mordysword",
            "abr_scroll_7_prismaticspray",
            "abr_scroll_7_protectvsspells",
            "abr_scroll_7_pwordblind",
            "abr_scroll_7_pwordstun",
            "abr_scroll_7_regenerate",
            "abr_scroll_7_restoregreat",
            "abr_scroll_7_resurrection",
            "abr_scroll_7_shadowconjuregreat",
            "abr_scroll_7_shadowshield",
            "abr_scroll_7_spellmantle",
            "abr_scroll_7_summoncrea07",
            "abr_scroll_7_sunbeam",
            "abr_scroll_7_swamplung",
            "abr_scroll_7_wordoffath",
        };
        #endregion

        #region Level 8 Scrolls
        public static List<string> Level8Scrolls = new List<string>
        {
            "abr_scroll_8_auravsalign",
            "abr_scroll_8_bigbyclench",
            "abr_scroll_8_blackstaff",
            "abr_scroll_8_bodaksglare",
            "abr_scroll_8_bombardment",
            "abr_scroll_8_creaundeadgrt",
            "abr_scroll_8_curecritmass",
            "abr_scroll_8_earthquake",
            "abr_scroll_8_horridwilt",
            "abr_scroll_8_incendcloud",
            "abr_scroll_8_ironbody",
            "abr_scroll_8_massblinddeaf",
            "abr_scroll_8_masschmmonst",
            "abr_scroll_8_massdeathward",
            "abr_scroll_8_massinflictcrit",
            "abr_scroll_8_mindblank",
            "abr_scroll_8_planebindgrtr",
            "abr_scroll_8_polarray",
            "abr_scroll_8_premonition",
            "abr_scroll_8_pwordpetrify",
            "abr_scroll_8_stormavatar",
            "abr_scroll_8_summoncrea08",
            "abr_scroll_8_sunburst",
            "abr_scroll_8_walldispellgrt",
        };
        #endregion

        #region Level 9 Scrolls
        public static List<string> Level9Scrolls = new List<string>
        {
            "abr_scroll_9_bigbycrush",
            "abr_scroll_9_burstglawrath",
            "abr_scroll_9_dommonster",
            "abr_scroll_9_elemswarm",
            "abr_scroll_9_energydrain",
            "abr_scroll_9_etherealness",
            "abr_scroll_9_gate",
            "abr_scroll_9_grtrvisagediety",
            "abr_scroll_9_implosion",
            "abr_scroll_9_massdrown",
            "abr_scroll_9_massheal",
            "abr_scroll_9_masshldmonster",
            "abr_scroll_9_meteorswarm",
            "abr_scroll_9_miracle",
            "abr_scroll_9_mordsdisjunct",
            "abr_scroll_9_natureavatar",
            "abr_scroll_9_pwordkill",
            "abr_scroll_9_shapechange",
            "abr_scroll_9_spellmantlegrt",
            "abr_scroll_9_stormvengeance",
            "abr_scroll_9_undeatheternfoe",
            "abr_scroll_9_wailbanshee",
            "abr_scroll_9_weird",
            "abr_scroll_9_wish",
        };
        #endregion
    }
}
