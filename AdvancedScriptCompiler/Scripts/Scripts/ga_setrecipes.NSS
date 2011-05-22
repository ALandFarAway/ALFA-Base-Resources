// ga_setrecipes
/*
    sets up all the recipes for creating magic items
	this can be run at any time prior to a PC using them in game. (module load might be good)

    Reference Info:
    see lexicon for constants:
    Home > Reference > Constants > SPELL_*
    Home > Reference > Constants > ITEM_PROPERTY_*
    specific constants available for most item properties:
    Home > Reference > Constants > IP_CONST_ABILITY_* ... IP_CONST_WEIGHTINCREASE_*
*/
// ChazM 12/15/05
// FAB 1/13/06 - Plugging in the materials, working on recipes
// ChazM 1/31/06 - implementing in NWN2
// ChazM 2/1/06 - Reorganized/updated file. 
// ChazM 3/1/06 - Incorporated aditional recipes
// TDE 3/4/06 - Added Gold Filigree Charm for summoning Mephasm in Crossroad Keep
// ChazM 3/1/06 - Massaged new distillation recipes.
// ChazM 3/23/06 - Updated all mold constants
// ChazM 4/11/06 - Added Traps
// ChazM 4/18/06 - globally replaced tag suffix list with item category constants, removed test recipes
// TDE 6/8/06 - Added Infernal Focus recipes for bargaining with Mephasm in Crossroad Keep
// ChazM 8/3/06 - Iron Golem Fragments now distill to Radiant Earth Essence
// ChazM 8/14/06 - corrected 3 mold tags
// ChazM 9/9/06 - minor constant changes
// ChazM 9/10/06 - fixed dragon blood, fire beetle belly, removed unused test constants and commented out recipes
//				replaced old constant SPELL_RESIST_ELEMENTS with SPELL_RESIST_ENERGY
// ChazM 9/10/06 - fixes from Annie for recipes: RING_DIVINE_POWER_2, RING_WIZARDRY_2, SCABBARD_KEEN_EDGES
// ChazM 9/27/06 - Added WarMace, silver bastard sword, and silver falchion
// ChazM 9/27/06 - Added SetUpAlchemyRecipes6()
// ChazM 9/29/06 - Added SetUpStandardMetalItem(), added flails, weapon mold comments, removed double bladed sword mold
// ChazM 9/29/06 - Added armor comments, removed duskwood breastplate mold and recipe, modified SetUpMundaneRecipes6()
// ChazM 10/20/06 - Modified weapon and armor Haste effect recipes - replaced w/ ability to cast haste 3x/day 
// ChazM 11/9/06 - The charm and focus can be created using standard darkness or the warlock invocation darkness
// ChazM 11/10/06 - fixed MEDALLION_THOUGHTS, armor Arrow Deflection, weapon Poison
// ChazM 11/13/06 -  fixed Invulnerable
// ChazM 4/5/07 - Eagles Splendor constant change
// ChazM 5/7/07 - fixed haste spell constant reference to the IP_CONST variety.
// MDiekmann 7/17/07 - Fixes for Acid trap recipes, morningstar recipes as well


#include "ginc_crafting"

// =================================================================================
// Constants
// =================================================================================


// Tags of all Essences
const string FIRE1 			= "cft_ess_fire1";
const string FIRE2 			= "cft_ess_fire2";
const string FIRE3 			= "cft_ess_fire3";
const string FIRE4 			= "cft_ess_fire4";
const string WATER1 		= "cft_ess_water1";
const string WATER2 		= "cft_ess_water2";
const string WATER3 		= "cft_ess_water3";
const string WATER4 		= "cft_ess_water4";
const string AIR1 			= "cft_ess_air1";
const string AIR2 			= "cft_ess_air2";
const string AIR3 			= "cft_ess_air3";
const string AIR4 			= "cft_ess_air4";
const string EARTH1 		= "cft_ess_earth1";
const string EARTH2 		= "cft_ess_earth2";
const string EARTH3 		= "cft_ess_earth3";
const string EARTH4 		= "cft_ess_earth4";
const string POWER1 		= "cft_ess_power1";
const string POWER2 		= "cft_ess_power2";
const string POWER3 		= "cft_ess_power3";
const string POWER4 		= "cft_ess_power4";

// Tags of all Gems
const string BLOODSTONE 	= "cft_gem_01";
const string TOPAZ 			= "NW_IT_GEM010";
const string OBSIDIAN 		= "cft_gem_03";
const string SAPPHIRE 		= "NW_IT_GEM008";
const string FIRE_OPAL 		= "NW_IT_GEM009";
const string DIAMOND 		= "NW_IT_GEM005";
const string RUBY 			= "NW_IT_GEM006";
const string EMERALD 		= "NW_IT_GEM012";
const string CANARY_DIAMOND = "cft_gem_09";
const string STAR_SAPPHIRE 	= "cft_gem_10";
const string JACINTH 		= "cft_gem_11";
const string BLUE_DIAMOND 	= "cft_gem_12";
const string ROGUE_STONE 	= "cft_gem_13";
const string BELJURIL 		= "cft_gem_14";
const string KINGS_TEAR 	= "cft_gem_15";
const string GARNET         = "NW_IT_GEM011";


// Tags of all Basic Crafting Materials
const string HIDE_LEATHER 		= "n2_crft_hideleather";
const string HIDE_DRAGON 		= "n2_crft_hidedragon";
const string HIDE_SALAMANDER	= "n2_crft_hidesalam";
const string HIDE_UMBER_HULK	= "n2_crft_hideumber";
const string HIDE_WYVERN 		= "n2_crft_hidewyvern";
const string INGOT_IRON 		= "n2_crft_ingiron";
const string INGOT_ADAMANTINE 	= "n2_crft_ingadamant";
const string INGOT_COLD_IRON	= "n2_crft_ingcldiron";
const string INGOT_DARKSTEEL	= "n2_crft_ingdrksteel";
const string INGOT_MITHRAL 		= "n2_crft_ingmithral";
const string INGOT_SILVER 		= "n2_crft_ingsilver";
const string PLANK_WOOD 		= "n2_crft_plkwood";
const string PLANK_DUSKWOOD		= "n2_crft_plkdskwood";
const string PLANK_ZALANTAR		= "n2_crft_plkzalantar";
const string PLANK_SHEDERRAN	= "n2_crft_plkshed";

// TDE: Added Gold Necklace for Gold Filigree Charm (used for summoning Mephasm in Crossroad Keep)
const string GOLD_NECKLACE		= "NW_IT_MNECK022";

// Tags of Wondrous Items (long list)
const string BOOTS_STRIDING_2		= "NW_IT_MBOOTS006";
const string BOOTS_STRIDING_4		= "NW_IT_MBOOTS008";
const string BOOTS_STRIDING_6		= "X2_IT_MBOOTS006";
const string BOOTS_STRIDING_8		= "X2_IT_MBOOTS008";
const string AMULET_NATURAL_ARMOR_1		= "NW_IT_MNECK001";
const string AMULET_NATURAL_ARMOR_2		= "NW_IT_MNECK012";
const string AMULET_NATURAL_ARMOR_3		= "NW_IT_MNECK013";
const string AMULET_NATURAL_ARMOR_4		= "NW_IT_MNECK014";
const string AMULET_NATURAL_ARMOR_5		= "NW_IT_MNECK015";
const string BELT_FROST_GIANT_STRENGTH		= "NW_IT_MBELT007";
const string BELT_STONE_GIANT_STRENGTH		= "n2_it_mbelt001";
const string BELT_CLOUD_GIANT_STRENGTH		= "X2_IT_MBELT001";
const string BOOTS_ELVENKIND		= "NW_IT_MBOOTS002";
const string BOOTS_SPEED			= "NW_IT_MBOOTS005";
const string BRACERS_ARMOR_1		= "NW_IT_MBRACER002";
const string BRACERS_ARMOR_2		= "NW_IT_MBRACER007";
const string BRACERS_ARMOR_3		= "NW_IT_MBRACER008";
const string BRACERS_ARMOR_4		= "NW_IT_MBRACER009";
const string BRACERS_ARMOR_5		= "NW_IT_MBRACER010";
const string BRACERS_ARMOR_6		= "X2_IT_MBRACER001";
const string BRACERS_ARMOR_7		= "X2_IT_MBRACER002";
const string BRACERS_ARMOR_8		= "X2_IT_MBRACER003";
const string BROOCH_SHIELDING		= "X0_IT_MMEDMISC01";
const string NYMPH_CLOAK_2			= "NW_MAARCL092";
const string NYMPH_CLOAK_4			= "NW_MAARCL094";
const string NYMPH_CLOAK_6			= "X2_IT_MCLOAK008";
const string NYMPH_CLOAK_8			= "n2_it_mcloak001";
const string CLOAK_DISPLACEMENT		= "X0_MAARCL032";
const string CLOAK_ELVENKIND		= "NW_MAARCL057";
const string CLOAK_RESISTANCE_1		= "X0_MAARCL025";
const string CLOAK_RESISTANCE_2		= "X0_MAARCL026";
const string CLOAK_RESISTANCE_3		= "X0_MAARCL027";
const string CLOAK_RESISTANCE_4		= "X0_MAARCL028";
const string CLOAK_RESISTANCE_5		= "X0_MAARCL029";
//const string EYES_EAGLE				= "X0_ARMHE005"; (no "Eyes" items)
const string GAUNTLETS_OGRE_POWER	= "NW_IT_MBRACER013";
const string GEM_SEEING				= "X0_IT_MSMLMISC04";
const string BELT_AGILITY_2			= "nw_it_mbelt019";
const string BELT_AGILITY_4			= "nw_it_mbelt021";
const string BELT_AGILITY_6			= "X2_IT_MBELT004";
const string BELT_AGILITY_8			= "X2_IT_MBELT006";
//const string GOGGLES_MINUTE_SEEING	= "X0_ARMHE007"; (no "Goggles" items)
//const string GOGGLES_NIGHT			= "X0_ARMHE008"; (no "Goggles" items)
const string HEADBAND_INTELLECT_2	= "X0_ARMHE009";
const string HEADBAND_INTELLECT_4	= "X0_ARMHE010";
const string HEADBAND_INTELLECT_6	= "X0_ARMHE011";
const string HEADBAND_INTELLECT_8	= "n2_armhe001";
//const string HORN_GOODNESS			= "X0_IT_MTHNMISC09"; (no horns)
const string MANTLE_GREATER_SPELL_RESISTANCE	= "X0_MAARCL034";
const string MEDALLION_THOUGHTS		= "n2_it_mneck002";
const string RING_DIVINE_POWER_1	= "n2_it_mring006";
const string RING_DIVINE_POWER_2	= "n2_it_mring002";
const string RING_DIVINE_POWER_3	= "n2_it_mring003";
const string RING_DIVINE_POWER_4	= "n2_it_mring004";
const string RING_DIVINE_POWER_5	= "n2_it_mring005";
const string RING_WIZARDRY_1		= "n2_it_mring007";
const string RING_WIZARDRY_2		= "n2_it_mring008";
const string RING_WIZARDRY_3		= "n2_it_mring009";
const string RING_WIZARDRY_4		= "n2_it_mring010";
const string RING_WIZARDRY_5		= "n2_it_mring011";
const string AMULET_HEALTH			= "NW_IT_MNECK036";
const string LESSER_AMULET_HEALTH	= "NW_IT_MNECK035";
const string GREATER_AMULET_HEALTH	= "NW_IT_MNECK037";
const string PERIAPT_WISDOM_2		= "NW_IT_MNECK008";
const string PERIAPT_WISDOM_4		= "NW_IT_MNECK010";
const string PERIAPT_WISDOM_6		= "X2_IT_MNECK006";
const string PERIAPT_WISDOM_8		= "X2_IT_MNECK008";
const string ROBE_ARCHMAGE			= "n2_mcloth001";
const string SCABBARD_KEEN_EDGES	= "n2_it_mmidmisc01";
const string SCARAB_GREATER_PROTECTION		= "X0_IT_MNECK003";

// TDE: Added Gold Filigree Charm (used for summoning Mephasm in Crossroad Keep)
const string MEPHASM_CHARM	= "31_mephasm_charm";

// TDE: Added Infernal Focus (used for bargaining with Mephasm in Crossroad Keep)
const string MEPHASM_FOCUS	= "31_mephasm_focus";

// Tags of all Craft Weapon and Armor Molds
// Missile Weapons
const string MOLD_WPN_BWXH    = "n2_crft_mold_bwxh";	// Heavy Crossbow
const string MOLD_WPN_BWXL    = "n2_crft_mold_bwxl";	// Light Crossbow
const string MOLD_WPN_BWLN    = "n2_crft_mold_bwln";	// Longbow
const string MOLD_WPN_BWSH    = "n2_crft_mold_bwsh";	// Shortbow
// Melee Weapons
const string MOLD_WPN_SWBS    = "n2_crft_mold_swbs";	// Bastard Sword
const string MOLD_WPN_AXBT    = "n2_crft_mold_axbt";	// Battle Axe
const string MOLD_WPN_BLCL    = "n2_crft_mold_blcl";	// Club
const string MOLD_WPN_SWDG    = "n2_crft_mold_swdg";	// Dagger
const string MOLD_WPN_AXDV    = "n2_crft_mold_axdv";	// Dwarvish Axe
const string MOLD_WPN_SWFL    = "n2_crft_mold_swfl";	// Falchion
const string MOLD_WPN_FLAIL   = "n2_crft_mold_blfl";	// Flail
const string MOLD_WPN_AXGR    = "n2_crft_mold_axgr";	// Greataxe
const string MOLD_WPN_SWGS    = "n2_crft_mold_swgs";	// Great Sword
const string MOLD_WPN_PLHB    = "n2_crft_mold_plhb";	// Halberd
const string MOLD_WPN_BLHL    = "n2_crft_mold_blhl";	// Light Hammer
const string MOLD_WPN_AXHN    = "n2_crft_mold_axhn";	// Hand Axe
const string MOLD_WPN_SPKA    = "n2_crft_mold_spka";	// Kama
const string MOLD_WPN_SWKA    = "n2_crft_mold_swka";	// Katana
const string MOLD_WPN_SPKU    = "n2_crft_mold_spku";	// Kukri
const string MOLD_WPN_SWLS    = "n2_crft_mold_swls";	// Long Sword
const string MOLD_WPN_BLML    = "n2_crft_mold_blml";	// Mace
const string MOLD_WPN_BLMS    = "n2_crft_mold_blms";	// Morningstar
const string MOLD_WPN_DBQS    = "n2_crft_mold_dbqs";	// Quarterstaff
const string MOLD_WPN_SWRP    = "n2_crft_mold_swrp";	// Rapier
const string MOLD_WPN_SWSC    = "n2_crft_mold_swsc";	// Scimitar
const string MOLD_WPN_PLSC    = "n2_crft_mold_plsc";	// Scythe
const string MOLD_WPN_SWSS    = "n2_crft_mold_swss";	// Short Sword
const string MOLD_WPN_SPSC    = "n2_crft_mold_spsc";	// Sickle
const string MOLD_WPN_PLSS    = "n2_crft_mold_plss";	// Spear
//const string MOLD_WPN_SWDB    = "n2_crft_mold_swdb";	// Double bladed sword
const string MOLD_WPN_BLHW    = "n2_crft_mold_blhw";	// Warhammer
const string MOLD_WPN_WARMACE	= "n2_crft_mold_bldm";	// Warmace

// Armor
const string MOLD_ARM_LTPD    = "n2_crft_mold_ltpd"; 	// Padded Armor
const string MOLD_ARM_LTLT    = "n2_crft_mold_ltlt";	// Leather Armor
const string MOLD_ARM_LTSL    = "n2_crft_mold_ltsl";	// Studded Leather Armor
const string MOLD_ARM_LTCS    = "n2_crft_mold_ltcs";	// Chain Shirt
const string MOLD_ARM_MDHD    = "n2_crft_mold_mdhd";	// Hide Armor
const string MOLD_ARM_MDSM    = "n2_crft_mold_mdsm";	// Scale Mail
const string MOLD_ARM_MDCM    = "n2_crft_mold_mdcm";	// Chainmail
const string MOLD_ARM_MDBP    = "n2_crft_mold_mdbp";	// Breastplate
const string MOLD_ARM_HVBM    = "n2_crft_mold_hvbm";	// Banded Mail
const string MOLD_ARM_HVHP    = "n2_crft_mold_hvhp";	// Half Plate
const string MOLD_ARM_HVFP    = "n2_crft_mold_hvfp";	// Full Plate
// Shields
const string MOLD_ARM_SHLT    = "n2_crft_mold_shlt";	// Light Shield
const string MOLD_ARM_SHHV    = "n2_crft_mold_shhv";	// Heavy Shield
const string MOLD_ARM_SHTW    = "n2_crft_mold_shtw";	// Tower Shield
									 
// Tags of all Crafted Weapons
const string WPN_AXBT_ADA   = "mst_axbt_ada_3";
const string WPN_AXBT_CLD   = "mst_axbt_cld_3";
const string WPN_AXBT_DRK   = "mst_axbt_drk_3";
const string WPN_AXBT_IRN   = "nw_waxbt001";
const string WPN_AXBT_MTH   = "mst_axbt_mth_3";
const string WPN_AXBT_SLV   = "mst_axbt_slv_3";
const string WPN_AXDV_ADA   = "mst_axdv_ada_3";
const string WPN_AXDV_CLD   = "mst_axdv_cld_3";
const string WPN_AXDV_DRK   = "mst_axdv_drk_3";
const string WPN_AXDV_IRN   = "x2_wdwraxe001";
const string WPN_AXDV_MTH   = "mst_axdv_mth_3";
const string WPN_AXDV_SLV   = "mst_axdv_slv_3";
const string WPN_AXGR_ADA   = "mst_axgr_ada_3";
const string WPN_AXGR_CLD   = "mst_axgr_cld_3";
const string WPN_AXGR_DRK   = "mst_axgr_drk_3";
const string WPN_AXGR_IRN   = "nw_waxgr001";
const string WPN_AXGR_MTH   = "mst_axgr_mth_3";
const string WPN_AXGR_SLV   = "mst_axgr_slv_3";
const string WPN_AXHN_ADA   = "mst_axhn_ada_3";
const string WPN_AXHN_CLD   = "mst_axhn_cld_3";
const string WPN_AXHN_DRK   = "mst_axhn_drk_3";
const string WPN_AXHN_IRN   = "nw_waxhn001";
const string WPN_AXHN_MTH   = "mst_axhn_mth_3";
const string WPN_AXHN_SLV   = "mst_axhn_slv_3";
const string WPN_BLCL_DSK   = "mst_blcl_dsk_3";
const string WPN_BLCL_FWD   = "mst_blcl_fwd_3";
const string WPN_BLCL_LAN   = "nw_wblcl001";
const string WPN_BLCL_ZAL   = "mst_blcl_zal_3";
const string WPN_BLHL_ADA   = "mst_blhl_ada_3";
const string WPN_BLHL_CLD   = "mst_blhl_cld_3";
const string WPN_BLHL_DRK   = "mst_blhl_drk_3";
const string WPN_BLHL_IRN   = "nw_wblhl001";
const string WPN_BLHL_MTH   = "mst_blhl_mth_3";
const string WPN_BLHL_SLV   = "mst_blhl_slv_3";
const string WPN_BLHW_ADA   = "mst_blhw_ada_3";
const string WPN_BLHW_CLD   = "mst_blhw_cld_3";
const string WPN_BLHW_DRK   = "mst_blhw_drk_3";
const string WPN_BLHW_IRN   = "nw_wblhw001";
const string WPN_BLHW_MTH   = "mst_blhw_mth_3";
const string WPN_BLHW_SLV   = "mst_blhw_slv_3";
const string WPN_BLML_ADA   = "mst_blml_ada_3";
const string WPN_BLML_CLD   = "mst_blml_cld_3";
const string WPN_BLML_DRK   = "mst_blml_drk_3";
const string WPN_BLML_IRN   = "nw_wblml001";
const string WPN_BLML_MTH   = "mst_blml_mth_3";
const string WPN_BLML_SLV   = "mst_blml_slv_3";
const string WPN_BLMS_ADA   = "mst_blms_ada_3";
const string WPN_BLMS_CLD   = "mst_blms_cld_3";
const string WPN_BLMS_DRK   = "mst_blms_drk_3";
const string WPN_BLMS_IRN   = "nw_wblms001";
const string WPN_BLMS_MTH   = "mst_blms_mth_3";
const string WPN_BLMS_SLV   = "mst_blms_slv_3";
const string WPN_BWLN_DSK   = "mwr_bwln_dsk_4";
const string WPN_BWLN_FWD   = "mwr_bwln_fwd_3";
const string WPN_BWLN_LAN   = "nw_wbwln001";
const string WPN_BWLN_SHD   = "mwr_bwln_shd_3";
const string WPN_BWLN_ZAL   = "mwr_bwln_zal_3";
const string WPN_BWSH_DSK   = "mwr_bwsh_dsk_4";
const string WPN_BWSH_FWD   = "mwr_bwsh_fwd_3";
const string WPN_BWSH_LAN   = "nw_wbwsh001";
const string WPN_BWSH_SHD   = "mwr_bwsh_shd_3";
const string WPN_BWSH_ZAL   = "mwr_bwsh_zal_3";
const string WPN_BWXH_DSK   = "mwr_bwxh_dsk_4";
const string WPN_BWXH_FWD   = "mwr_bwxh_fwd_4";
const string WPN_BWXH_LAN   = "nw_wbwxh001";
const string WPN_BWXH_SHD   = "mwr_bwxh_shd_3";
const string WPN_BWXH_ZAL   = "mwr_bwxh_zal_3";
const string WPN_BWXL_DSK   = "mwr_bwxl_dsk_4";
const string WPN_BWXL_FWD   = "mwr_bwxl_fwd_3";
const string WPN_BWXL_LAN   = "nw_wbwxl001";
const string WPN_BWXL_SHD   = "mwr_bwxl_shd_3";
const string WPN_BWXL_ZAL   = "mwr_bwxl_zal_3";
const string WPN_DBQS_DSK   = "mst_dbqs_dsk_3";
const string WPN_DBQS_FWD   = "mst_dbqs_fwd_3";
const string WPN_DBQS_LAN   = "nw_wdbqs001";
const string WPN_DBQS_ZAL   = "mst_dbqs_zal_3";
const string WPN_PLHB_ADA   = "mst_plhb_ada_3";
const string WPN_PLHB_CLD   = "mst_plhb_cld_3";
const string WPN_PLHB_DRK   = "mst_plhb_drk_3";
const string WPN_PLHB_IRN   = "nw_wplhb001";
const string WPN_PLHB_MTH   = "mst_plhb_mth_3";
const string WPN_PLHB_SLV   = "mst_plhb_slv_3";
const string WPN_PLSC_ADA   = "mst_plsc_ada_3";
const string WPN_PLSC_CLD   = "mst_plsc_cld_3";
const string WPN_PLSC_DRK   = "mst_plsc_drk_3";
const string WPN_PLSC_IRN   = "nw_wplsc001";
const string WPN_PLSC_MTH   = "mst_plsc_mth_3";
const string WPN_PLSC_SLV   = "mst_plsc_slv_3";
const string WPN_PLSS_DSK   = "mst_plss_dsk_3";
const string WPN_PLSS_FWD   = "mst_plss_fwd_3";
const string WPN_PLSS_LAN   = "nw_wplss001";
const string WPN_PLSS_ZAL   = "mst_plss_zal_3";
const string WPN_SPKA_ADA   = "mst_spka_ada_3";
const string WPN_SPKA_CLD   = "mst_spka_cld_3";
const string WPN_SPKA_DRK   = "mst_spka_drk_3";
const string WPN_SPKA_IRN   = "nw_wspka001";
const string WPN_SPKA_MTH   = "mst_spka_mth_3";
const string WPN_SPKA_SLV   = "mst_spka_slv_3";
const string WPN_SPKU_ADA   = "mst_spku_ada_3";
const string WPN_SPKU_CLD   = "mst_spku_cld_3";
const string WPN_SPKU_DRK   = "mst_spku_drk_3";
const string WPN_SPKU_IRN   = "nw_wspku001";
const string WPN_SPKU_MTH   = "mst_spku_mth_3";
const string WPN_SPKU_SLV   = "mst_spku_slv_3";
const string WPN_SPSC_ADA   = "mst_spsc_ada_3";
const string WPN_SPSC_CLD   = "mst_spsc_cld_3";
const string WPN_SPSC_DRK   = "mst_spsc_drk_3";
const string WPN_SPSC_IRN   = "nw_wspsc001";
const string WPN_SPSC_MTH   = "mst_spsc_mth_3";
const string WPN_SPSC_SLV   = "mst_spsc_slv_3";
const string WPN_SWBS_ADA   = "mst_swbs_ada_3";
const string WPN_SWBS_CLD   = "mst_swbs_cld_3";
const string WPN_SWBS_DRK   = "mst_swbs_drk_3";
const string WPN_SWBS_IRN   = "nw_wswbs001";
const string WPN_SWBS_MTH   = "mst_swbs_mth_3";
const string WPN_SWBS_SLV   = "mst_swbs_slv_3";
const string WPN_SWDG_ADA   = "mst_swdg_ada_3";
const string WPN_SWDG_CLD   = "mst_swdg_cld_3";
const string WPN_SWDG_DRK   = "mst_swdg_drk_3";
const string WPN_SWDG_IRN   = "nw_wswdg001";
const string WPN_SWDG_MTH   = "mst_swdg_mth_3";
const string WPN_SWDG_SLV   = "mst_swdg_slv_3";
const string WPN_SWFL_ADA   = "mst_swfl_ada_3";
const string WPN_SWFL_CLD   = "mst_swfl_cld_3";
const string WPN_SWFL_DRK   = "mst_swfl_drk_3";
const string WPN_SWFL_IRN   = "n2_wswfl001";
const string WPN_SWFL_MTH   = "mst_swfl_mth_3";
const string WPN_SWFL_SLV   = "mst_swfl_slv_3";
const string WPN_SWGS_ADA   = "mst_swgs_ada_3";
const string WPN_SWGS_CLD   = "mst_swgs_cld_3";
const string WPN_SWGS_DRK   = "mst_swgs_drk_3";
const string WPN_SWGS_IRN   = "nw_wswgs001";
const string WPN_SWGS_MTH   = "mst_swgs_mth_3";
const string WPN_SWGS_SLV   = "mst_swgs_slv_3";
const string WPN_SWKA_ADA   = "mst_swka_ada_3";
const string WPN_SWKA_CLD   = "mst_swka_cld_3";
const string WPN_SWKA_DRK   = "mst_swka_drk_3";
const string WPN_SWKA_IRN   = "nw_wswka001";
const string WPN_SWKA_MTH   = "mst_swka_mth_3";
const string WPN_SWKA_SLV   = "mst_swka_slv_3";
const string WPN_SWLS_ADA   = "mst_swls_ada_3";
const string WPN_SWLS_CLD   = "mst_swls_cld_3";
const string WPN_SWLS_DRK   = "mst_swls_drk_3";
const string WPN_SWLS_IRN   = "nw_wswls001";
const string WPN_SWLS_MTH   = "mst_swls_mth_3";
const string WPN_SWLS_SLV   = "mst_swls_slv_3";
const string WPN_SWRP_ADA   = "mst_swrp_ada_3";
const string WPN_SWRP_CLD   = "mst_swrp_cld_3";
const string WPN_SWRP_DRK   = "mst_swrp_drk_3";
const string WPN_SWRP_IRN   = "nw_wswrp001";
const string WPN_SWRP_MTH   = "mst_swrp_mth_3";
const string WPN_SWRP_SLV   = "mst_swrp_slv_3";
const string WPN_SWSC_ADA   = "mst_swsc_ada_3";
const string WPN_SWSC_CLD   = "mst_swsc_cld_3";
const string WPN_SWSC_DRK   = "mst_swsc_drk_3";
const string WPN_SWSC_IRN   = "nw_wswsc001";
const string WPN_SWSC_MTH   = "mst_swsc_mth_3";
const string WPN_SWSC_SLV   = "mst_swsc_slv_3";
const string WPN_SWSS_ADA   = "mst_swss_ada_3";
const string WPN_SWSS_CLD   = "mst_swss_cld_3";
const string WPN_SWSS_DRK   = "mst_swss_drk_3";
const string WPN_SWSS_IRN   = "nw_wswss001";
const string WPN_SWSS_MTH   = "mst_swss_mth_3";
const string WPN_SWSS_SLV   = "mst_swss_slv_3";

// Warmaces
const string WPN_WARMACE_ADA   	= "mst_bldm_ada_3";
const string WPN_WARMACE_CLD   	= "mst_bldm_cld_3";
const string WPN_WARMACE_DRK   	= "mst_bldm_drk_3";
const string WPN_WARMACE_IRN   	= "nw_wdbma001";
const string WPN_WARMACE_MTH   	= "mst_bldm_mth_3";
const string WPN_WARMACE_SLV   	= "mst_bldm_slv_3";

// Flails
const string WPN_FLAIL_ADA   	= "mst_blfl_ada_3";
const string WPN_FLAIL_CLD   	= "mst_blfl_cld_3";
const string WPN_FLAIL_DRK   	= "mst_blfl_drk_3";
const string WPN_FLAIL_IRN   	= "nw_wblfl001";
const string WPN_FLAIL_MTH   	= "mst_blfl_mth_3";
const string WPN_FLAIL_SLV   	= "mst_blfl_slv_3";

// Constants for all Crafted Armor
const string ARM_HVBM_ADA   = "mwa_hvbm_ada_3";
const string ARM_HVBM_DRK   = "mwa_hvbm_drk_3";
const string ARM_HVBM_IRN   = "nw_aarcl011";
const string ARM_HVBM_MTH   = "mwa_hvbm_mth_3";
const string ARM_HVFP_ADA   = "mwa_hvfp_ada_4";
const string ARM_HVFP_DRK   = "mwa_hvfp_drk_3";
const string ARM_HVFP_IRN   = "nw_aarcl007";
const string ARM_HVFP_MTH   = "mwa_hvfp_mth_4";
const string ARM_HVFP_SLH   = "mwa_hvfp_slh_3";
const string ARM_HVFP_WYH   = "mwa_hvfp_wyh_3";
const string ARM_HVHP_ADA   = "mwa_hvhp_ada_4";
const string ARM_HVHP_DRK   = "mwa_hvhp_drk_3";
const string ARM_HVHP_IRN   = "nw_aarcl006";
const string ARM_HVHP_MTH   = "mwa_hvhp_mth_4";
const string ARM_HVHP_RDH   = "mwa_hvhp_rdh_3";
const string ARM_HVHP_SLH   = "mwa_hvhp_slh_3";
const string ARM_HVHP_UHH   = "mwa_hvhp_uhh_3";
const string ARM_HVHP_WYH   = "mwa_hvhp_wyh_3";
const string ARM_LTCS_ADA   = "mwa_ltcs_ada_4";
const string ARM_LTCS_DRK   = "mwa_ltcs_drk_3";
const string ARM_LTCS_IRN   = "nw_aarcl012";
const string ARM_LTCS_MTH   = "mwa_ltcs_mth_4";
const string ARM_LTCS_SLH   = "mwa_ltcs_slh_3";
const string ARM_LTLT_HID   = "nw_aarcl001";
const string ARM_LTLT_SLH   = "mwa_ltlt_slh_3";
const string ARM_LTPD_HID   = "nw_aarcl009";
const string ARM_LTSL_HID   = "nw_aarcl002";
const string ARM_LTSL_SLH   = "mwa_ltsl_slh_3";
const string ARM_MDBP_ADA   = "mwa_mdbp_ada_4";
const string ARM_MDBP_DRK   = "mwa_mdbp_drk_3";
//const string ARM_MDBP_DSK   = "mwa_mdbp_dsk_3"; // no duskwood breastplate
const string ARM_MDBP_IRN   = "nw_aarcl010";
const string ARM_MDBP_MTH   = "mwa_mdbp_mth_4";
const string ARM_MDBP_RDH   = "mwa_mdbp_rdh_3";
const string ARM_MDBP_SLH   = "mwa_mdbp_slh_3";
const string ARM_MDBP_UHH   = "mwa_mdbp_uhh_3";
const string ARM_MDBP_WYH   = "mwa_mdbp_wyh_3";
const string ARM_MDCM_ADA   = "mwa_mdcm_ada_4";
const string ARM_MDCM_DRK   = "mwa_mdcm_drk_3";
const string ARM_MDCM_IRN   = "nw_aarcl004";
const string ARM_MDCM_MTH   = "mwa_mdcm_mth_4";
const string ARM_MDCM_SLH   = "mwa_mdcm_slh_3";
const string ARM_MDHD_HID   = "nw_aarcl008";
const string ARM_MDHD_SLH   = "mwa_mdhd_slh_3";
const string ARM_MDSM_ADA   = "mwa_mdsm_ada_4";
const string ARM_MDSM_DRK   = "mwa_mdsm_drk_3";
const string ARM_MDSM_IRN   = "nw_aarcl003";
const string ARM_MDSM_MTH   = "mwa_mdsm_mth_4";
const string ARM_MDSM_RDH   = "mwa_mdsm_rdh_3";
const string ARM_MDSM_SLH   = "mwa_mdsm_slh_3";
const string ARM_MDSM_WYH   = "mwa_mdsm_wyh_3";
const string ARM_SHHV_ADA   = "mwa_shhv_ada_4";
const string ARM_SHHV_DRK   = "mwa_shhv_drk_3";
const string ARM_SHHV_DSK   = "mwa_shhv_dsk_3";
const string ARM_SHHV_IRN   = "nw_ashlw001";
const string ARM_SHHV_MTH   = "mwa_shhv_mth_4";
const string ARM_SHHV_UHH   = "mwa_shhv_uhh_3";
const string ARM_SHHV_ZAL   = "mwa_shhv_zal_3";
const string ARM_SHLT_ADA   = "mwa_shlt_ada_4";
const string ARM_SHLT_DRK   = "mwa_shlt_drk_3";
const string ARM_SHLT_DSK   = "mwa_shlt_dsk_3";
const string ARM_SHLT_IRN   = "nw_ashsw001";
const string ARM_SHLT_MTH   = "mwa_shlt_mth_4";
const string ARM_SHLT_UHH   = "mwa_shlt_uhh_3";
const string ARM_SHLT_ZAL   = "mwa_shlt_zal_3";
const string ARM_SHTW_ADA   = "mwa_shtw_ada_4";
const string ARM_SHTW_DRK   = "mwa_shtw_drk_3";
const string ARM_SHTW_DSK   = "mwa_shtw_dsk_3";
const string ARM_SHTW_IRN   = "nw_ashto001";
const string ARM_SHTW_MTH   = "mwa_shtw_mth_4";
const string ARM_SHTW_UHH   = "mwa_shtw_uhh_3";
const string ARM_SHTW_ZAL   = "mwa_shtw_zal_3";
	

// Tags of all Alchemy Ingredients
const string DISTILLED_ALCOHOL	= "n2_alc_disalcohol";
const string POWDERED_SILVER	= "n2_alc_powsilver";
const string QUICKSILVER	= "n2_alc_quicksilver";
const string DIAMOND_DUST	= "n2_alc_dmnddust";
const string VENOM_GLAND	= "n2_alc_venomgland";
const string GARLIC		= "NW_IT_MSMLMISC24";
const string FAIRY_DUST		= "NW_IT_MSMLMISC19";
const string BELLADONNA		= "NW_IT_MSMLMISC23";
const string AMETHYST		= "NW_IT_GEM003";
const string BEE_GLAND          = "n2_alc_beegland";
const string CENTIPEDE_GLAND    = "n2_alc_centgland";
const string SCORPION_GLAND     = "n2_alc_scorpgland";

// Tags of all Alchemy Items
const string ACID_FLASK_1               = "X1_WMGRENADE001";
const string ACID_FLASK_2               = "n2_it_acid_2";
const string ACID_FLASK_3               = "n2_it_acid_3";
const string ACID_FLASK_4               = "n2_it_acid_4";
const string ALCHEMIST_FIRE_1           = "X1_WMGRENADE002";
const string ALCHEMIST_FIRE_2           = "n2_it_alch_2";
const string ALCHEMIST_FIRE_3           = "n2_it_alch_3";
const string ALCHEMIST_FIRE_4           = "n2_it_alch_4";
const string CHOKING_POWDER_1           = "X1_WMGRENADE004";
const string CHOKING_POWDER_2           = "n2_it_chok_2";
const string CHOKING_POWDER_3           = "n2_it_chok_3";
const string CHOKING_POWDER_4           = "n2_it_chok_4";
const string HOLY_WATER_1               = "X1_WMGRENADE005";
const string HOLY_WATER_2               = "n2_it_holy_2";
const string HOLY_WATER_3               = "n2_it_holy_3";
const string HOLY_WATER_4               = "n2_it_holy_4";
const string TANGLEFOOT_BAG_1           = "X1_WMGRENADE006";
const string TANGLEFOOT_BAG_2           = "n2_it_tang_2";
const string TANGLEFOOT_BAG_3           = "n2_it_tang_3";
const string TANGLEFOOT_BAG_4           = "n2_it_tang_4";
const string THUNDERSTONE_1             = "X1_WMGRENADE007";
const string THUNDERSTONE_2             = "n2_it_thun_2";
const string THUNDERSTONE_3             = "n2_it_thun_3";
const string THUNDERSTONE_4             = "n2_it_thun_4";
const string BEE_POISON_1               = "x2_it_poison015";
const string BEE_POISON_2               = "x2_it_poison021";
const string BEE_POISON_3               = "x2_it_poison027";
const string BEE_POISON_4               = "x2_it_poison039";
const string CENTIPEDE_POISON_1         = "x2_it_poison014";
const string CENTIPEDE_POISON_2         = "x2_it_poison020";
const string CENTIPEDE_POISON_3         = "x2_it_poison026";
const string CENTIPEDE_POISON_4         = "x2_it_poison038";
const string SCORPION_POISON_1          = "x2_it_poison013";
const string SCORPION_POISON_2          = "x2_it_poison019";
const string SCORPION_POISON_3          = "x2_it_poison025";
const string SCORPION_POISON_4          = "x2_it_poison037";

// Distillation items;
const string BLADELING_SPIKE		= "N2_CRFT_DIST001";
const string BAT_TOOTH				= "N2_CRFT_DIST002";
const string BEAR_CLAW				= "N2_CRFT_DIST003";
const string DIRE_BEAR_CLAW			= "N2_CRFT_DIST004";
const string BEETLE_GLAND			= "N2_CRFT_DIST005";
const string FIRE_BEETLE_BELLY		= "N2_CRFT_DIST006";
const string STAG_BEETLE_HORN		= "N2_CRFT_DIST007";
const string DIRE_BOAR_TUSK			= "N2_CRFT_DIST008";
const string BUGBEAR_TUSK			= "N2_CRFT_DIST009";
const string DEMON_BLOOD			= "N2_CRFT_DIST010";
const string DEVIL_BLOOD			= "N2_CRFT_DIST011";
const string DRAGON_BLOOD			= "N2_CRFT_DIST012";
const string GARGOYLE_HORN			= "N2_CRFT_DIST014";
const string GHOUL_CLAWS			= "N2_CRFT_DIST015";
const string GHAST_CLAWS			= "N2_CRFT_DIST016";
const string GHOST_RESIDUE			= "N2_CRFT_DIST017";
const string FIRE_GIANT_HEAD		= "N2_CRFT_DIST018";
const string FROST_GIANT_HEAD		= "N2_CRFT_DIST019";
const string IRON_GOLEM_FRAGMENTS	= "N2_CRFT_DIST020";
const string HELLHOUND_TOOTH		= "N2_CRFT_DIST021";
const string IMP_TAIL				= "N2_CRFT_DIST022";
const string LICH_DUST				= "N2_CRFT_DIST023";
const string FIRE_MEPHIT_HIDE		= "N2_CRFT_DIST024";
const string ICE_MEPHIT_HIDE		= "N2_CRFT_DIST025";
const string OGRE_MAGE_SKULL		= "N2_CRFT_DIST026";
const string SHADOW_RESIDUE			= "N2_CRFT_DIST027";
const string SKELETON_KNUCKLE		= "N2_CRFT_DIST029";	// this is actually a skeleton rib.
const string SPIDER_VENOM_GLAND		= "N2_CRFT_DIST030";
const string PHASE_SPIDER_MANDIBLE	= "N2_CRFT_DIST031";
const string SWORD_SPIDER_LEG		= "N2_CRFT_DIST032";
const string TROLL_BLOOD			= "N2_CRFT_DIST033";
const string UMBER_HULK_MANDIBLE	= "N2_CRFT_DIST034";
const string VAMPIRE_TOOTH			= "N2_CRFT_DIST035";
const string DIRE_WOLF_TOOTH		= "N2_CRFT_DIST036";
const string WINTER_WOLF_PELT		= "N2_CRFT_DIST037";
const string WRAITH_RESIDUE			= "N2_CRFT_DIST038";
const string WYVERN_SCALE			= "N2_CRFT_DIST039";
const string CRYSTAL_HEART			= "N2_CRFT_DIST040";

	
// =================================================================================
// Functions
// =================================================================================

// Set up the 6 recipes for typical metal weapons.
void SetUpStandardMetalItem(string sMold, int iNumIngots, int iBaseSkill, 
	 string sAdamantine, string sColdIron, string sDarksteel,string sIron, string sMithral, string sSilver)
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;
	
	// Adamantine Item
    sReagentList = MakeRepeatedItemList(INGOT_ADAMANTINE, iNumIngots);
    CreateMundaneRecipe(sMold, SKILL_CRAFT_WEAPON, iBaseSkill+15, sReagentList, sAdamantine);
	
    // Cold Iron Item
    sReagentList = MakeRepeatedItemList(INGOT_COLD_IRON, iNumIngots);
    CreateMundaneRecipe(sMold, SKILL_CRAFT_WEAPON, iBaseSkill+5, sReagentList, sColdIron);

    // Darksteel Item
    sReagentList = MakeRepeatedItemList(INGOT_DARKSTEEL, iNumIngots);
    CreateMundaneRecipe(sMold, SKILL_CRAFT_WEAPON, iBaseSkill+10, sReagentList, sDarksteel);

    // Iron Item
    sReagentList = MakeRepeatedItemList(INGOT_IRON, iNumIngots);
    CreateMundaneRecipe(sMold, SKILL_CRAFT_WEAPON, iBaseSkill, sReagentList, sIron);

    // Mithral Item
    sReagentList = MakeRepeatedItemList(INGOT_MITHRAL, iNumIngots);
    CreateMundaneRecipe(sMold, SKILL_CRAFT_WEAPON, iBaseSkill+10, sReagentList, sMithral);
	
    // Silver Item
    sReagentList = MakeRepeatedItemList(INGOT_SILVER, iNumIngots);
    CreateMundaneRecipe(sMold, SKILL_CRAFT_WEAPON, iBaseSkill+5, sReagentList, sSilver);

}
	
// =================================================================================
// Magical recipes
// =================================================================================

void SetUpMagicalRecipes1()
{
	// Function Prototype:
	// void CreateMagicalRecipe(int iSpellId, string sEffect, string sTagSuffixList, string sReagentList);

    string sReagentList;
    string sRecipeEffect;

    //---------------------------
    //          ARMOR
    //---------------------------

    // Acid Resistance I - gives Acid/10
    sReagentList = MakeList(EARTH1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 3);

    // Acid Resistance II - gives Acid/20
    sReagentList = MakeList(EARTH2, ROGUE_STONE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_20);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 7);

    // Acid Resistance III - gives Acid/30
    sReagentList = MakeList(EARTH3, KINGS_TEAR);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_30);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 11);

    // Arrow Deflection - gives the Deflect Arrows feat
    sReagentList = MakeList(AIR2, POWER1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_DEFLECT_ARROWS);
    CreateMagicalRecipe(SPELL_MAGE_ARMOR, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 5);

    // Cold Resistance I - gives Cold/10
    sReagentList = MakeList(WATER1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 3);

    // Cold Resistance II - gives Cold/20
    sReagentList = MakeList(WATER2, ROGUE_STONE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 7);

    // Cold Resistance III - gives Cold/30
    sReagentList = MakeList(WATER3, KINGS_TEAR);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_30);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 11);

    // Electricty Resistance I - gives Elec./10
    sReagentList = MakeList(AIR1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 3);

    // Electricty Resistance II - gives Elec./20
    sReagentList = MakeList(AIR2, ROGUE_STONE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 7);

    // Electricty Resistance III - gives Elec./30
    sReagentList = MakeList(AIR3, KINGS_TEAR);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_30);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 11);

    // Fire Resistance I - gives Fire/10
    sReagentList = MakeList(FIRE1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 3);

    // Fire Resistance II - gives Fire/20
    sReagentList = MakeList(FIRE2, ROGUE_STONE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 7);

    // Fire Resistance III - gives Fire/30
    sReagentList = MakeList(FIRE3, KINGS_TEAR);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_30);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 11);

	// Fortified Armor - gives immunity to sneak attack/critical hits
	sReagentList = MakeList(EARTH4, POWER3, BLUE_DIAMOND);
	sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_CRITICAL_HITS, IP_CONST_IMMUNITYMISC_BACKSTAB);
	CreateMagicalRecipe(SPELL_BANISHMENT, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 13);

    // Invulnerable - gives Magic/10
    sReagentList = MakeList(POWER4, BLUE_DIAMOND);
    //sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGESOAK_10_HP, IP_CONST_DAMAGEREDUCTION_1, 0, DR_TYPE_MAGICBONUS);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_REDUCTION, 10, DAMAGE_TYPE_MAGICAL, 0, DR_TYPE_DMGTYPE);
    CreateMagicalRecipe(SPELL_STONESKIN, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 18);
}

void SetUpMagicalRecipes2()
{
	// Function Prototype:
	// void CreateMagicalRecipe(int iSpellId, string sEffect, string sTagSuffixList, string sReagentList);

    string sReagentList;
    string sRecipeEffect;

    //---------------------------
    //          ARMOR -2
    //---------------------------

    // Shadowy I - gives a +5 bonus to Hide checks
    sReagentList = MakeList(WATER1, FIRE_OPAL);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE, 5);
    CreateMagicalRecipe(SPELL_INVISIBILITY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 5);

    // Shadowy II - gives a +10 bonus to Hide checks
    sReagentList = MakeList(WATER2, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE, 10);
    CreateMagicalRecipe(SPELL_INVISIBILITY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 10);

    // Shadowy III - gives a +15 bonus to Hide checks
    sReagentList = MakeList(WATER3, BLUE_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE, 15);
    CreateMagicalRecipe(SPELL_INVISIBILITY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 15);

    // Silent I - gives a +5 bonus to Move Silently checks
    sReagentList = MakeList(WATER1, FIRE_OPAL);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY, 5);
    CreateMagicalRecipe(SPELL_SILENCE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 5);

    // Silent II - gives a +10 bonus to Move Silently checks
    sReagentList = MakeList(WATER2, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY, 10);
    CreateMagicalRecipe(SPELL_SILENCE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 10);

    // Silent III - gives a +15 bonus to Move Silently checks
    sReagentList = MakeList(WATER3, BLUE_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY, 15);
    CreateMagicalRecipe(SPELL_SILENCE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 15);

    // Sonic Resistance I - gives Sonic/10
    sReagentList = MakeList(POWER1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_10);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 3);

    // Sonic Resistance II - gives Sonic/20
    sReagentList = MakeList(POWER2, ROGUE_STONE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_20);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 7);

    // Sonic Resistance III - gives Sonic/30
    sReagentList = MakeList(POWER3, KINGS_TEAR);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_30);
    CreateMagicalRecipe(SPELL_RESIST_ENERGY, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 11);

    // Spell Resistance I - gives SR14
    sReagentList = MakeList(FIRE3, POWER2, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SPELL_RESISTANCE, IP_CONST_SPELLRESISTANCEBONUS_14);
    CreateMagicalRecipe(SPELL_SPELL_RESISTANCE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 15);

    // Spell Resistance II - gives SR18
    sReagentList = MakeList(FIRE4, POWER3, BLUE_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SPELL_RESISTANCE, IP_CONST_SPELLRESISTANCEBONUS_18);
    CreateMagicalRecipe(SPELL_SPELL_RESISTANCE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 15);

    // Spell Resistance III - gives SR22
    sReagentList = MakeList(FIRE4, POWER4, BELJURIL);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SPELL_RESISTANCE, IP_CONST_SPELLRESISTANCEBONUS_22);
    CreateMagicalRecipe(SPELL_SPELL_RESISTANCE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 15);

    // Speed - Adds the Haste effect
    sReagentList = MakeList(AIR2, POWER2, BLUE_DIAMOND);
    //sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_HASTE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_CAST_SPELL, IP_CONST_CASTSPELL_HASTE_10, IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);	
    CreateMagicalRecipe(SPELL_HASTE, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 7);

    // Base +1 AC enchantment
    sReagentList = MakeList(EARTH1, OBSIDIAN);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 1);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 3);

    // Base +2 AC enchantment
    sReagentList = MakeList(EARTH1, DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 2);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 6);

    // Base +3 AC enchantment
    sReagentList = MakeList(EARTH2, POWER1, EMERALD);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 3);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 9);

    // Base +4 AC enchantment
    sReagentList = MakeList(EARTH3, POWER2, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 4);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 12);

    // Base +5 AC enchantment
    sReagentList = MakeList(EARTH3, POWER3, BLUE_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 5);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_ARMOR_SHIELD, sReagentList, 15);
}


void SetUpMagicalRecipes3()
{
	// Function Prototype:
	// void CreateMagicalRecipe(int iSpellId, string sEffect, string sTagSuffixList, string sReagentList);

    string sReagentList;
    string sRecipeEffect;

    //---------------------------
    //          WEAPONS 
    //---------------------------

    // Anarchic - Adds +2d6 damage against lawful creatures
    // FAB: Will need a check to see if the caster is Chaotic alignment
    sReagentList = MakeList(POWER1, AIR1, CANARY_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP, IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d6);
    CreateMagicalRecipe(SPELL_INFLICT_CRITICAL_WOUNDS, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Axiomatic - Adds +2d6 damage against chaotic creatures
    // FAB: Will need a check to see if the caster is Lawful alignment
    sReagentList = MakeList(POWER1, EARTH1, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP, IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d6);
    CreateMagicalRecipe(SPELL_INFLICT_CRITICAL_WOUNDS, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Defending I - Adds +1 to AC
    sReagentList = MakeList(EARTH2, DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 1);
    CreateMagicalRecipe(SPELL_MAGE_ARMOR, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
    CreateMagicalRecipe(SPELL_SHIELD_OF_FAITH, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 8);

    // Defending II - Adds +2 to AC
    sReagentList = MakeList(EARTH3, EMERALD);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 2);
    CreateMagicalRecipe(SPELL_MAGE_ARMOR, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
    CreateMagicalRecipe(SPELL_SHIELD_OF_FAITH, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);

    // Defending III - Adds +3 to AC
    sReagentList = MakeList(EARTH4, BLUE_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_AC_BONUS, 3);
    CreateMagicalRecipe(SPELL_MAGE_ARMOR, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
    CreateMagicalRecipe(SPELL_SHIELD_OF_FAITH, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 12);

    // Disruption - If an undead fails a DC14 Will save they are destroyed
    sReagentList = MakeList(POWER3, WATER3, JACINTH);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ON_HIT_PROPERTIES, IP_CONST_ONHIT_SLAYRACE, IP_CONST_ONHIT_SAVEDC_14, RACIAL_TYPE_UNDEAD);
    CreateMagicalRecipe(SPELL_UNDEATH_TO_DEATH, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 14);

    // Flaming - Adds 1d6 fire damage
    sReagentList = MakeList(FIRE2, RUBY);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
    CreateMagicalRecipe(SPELL_FIREBALL, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
    CreateMagicalRecipe(SPELL_FLAME_STRIKE, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);

    // Flaming Burst - Adds 1d10 fire damage to Criticals
    sReagentList = MakeList(FIRE3, POWER1, FIRE_OPAL);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_MASSIVE_CRITICALS, IP_CONST_DAMAGEBONUS_1d10);
    CreateMagicalRecipe(SPELL_FIREBALL, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
    CreateMagicalRecipe(SPELL_FLAME_STRIKE, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 12);

    // Frost - Adds 1d6 cold damage
    sReagentList = MakeList(WATER2, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6);
    CreateMagicalRecipe(SPELL_ICE_STORM, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);

    // Holy - Adds +2d6 damage against evil creatures
    // FAB: Will need a check to see if the caster is Good alignment
    sReagentList = MakeList(POWER1, WATER1, DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP, IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d6);
    CreateMagicalRecipe(SPELL_CURE_CRITICAL_WOUNDS, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Keen - Doubles Threat Range
    sReagentList = MakeList(EARTH2, RUBY);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_KEEN);
    //CreateMagicalRecipe(SPELL_KEEN_EDGE, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
    CreateMagicalRecipe(SPELL_LIGHTNING_BOLT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);

    // Shock - Adds 1d6 electricity damage
    sReagentList = MakeList(AIR2, CANARY_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6);
    CreateMagicalRecipe(SPELL_LIGHTNING_BOLT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);
    CreateMagicalRecipe(SPELL_CALL_LIGHTNING, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);

    // Speed - Adds the Haste effect
    sReagentList = MakeList(AIR2, POWER2, BLUE_DIAMOND);
    //sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_HASTE);
	sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_CAST_SPELL, IP_CONST_CASTSPELL_HASTE_10, IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
    CreateMagicalRecipe(SPELL_HASTE, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Unholy - Adds +2d6 damage against good creatures
    // FAB: Will need a check to see if the caster is Evil alignment
    sReagentList = MakeList(POWER1, FIRE1, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP, IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_2d6);
    CreateMagicalRecipe(SPELL_INFLICT_CRITICAL_WOUNDS, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Poison - Adds 1d6 poison damage (possibly rename to power? get rid of?)
    sReagentList = MakeList(EARTH2, EMERALD);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_POISON, 4);
    CreateMagicalRecipe(SPELL_POISON, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList);
  
    // Life Stealing I - Adds Vampiric Regeneration 1 to the weapon
    sReagentList = MakeList(POWER2, FIRE2, RUBY);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_REGENERATION_VAMPIRIC, 1);
    CreateMagicalRecipe(SPELL_ENERVATION, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Life Stealing II - Adds Vampiric Regeneration 3 to the weapon
    sReagentList = MakeList(POWER3, FIRE3, CANARY_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_REGENERATION_VAMPIRIC, 3);
    CreateMagicalRecipe(SPELL_ENERVATION, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 11);

    // Life Stealing III - Adds Vampiric Regeneration 5 to the weapon
    sReagentList = MakeList(POWER4, FIRE4, BELJURIL);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_REGENERATION_VAMPIRIC, 5);
    CreateMagicalRecipe(SPELL_ENERVATION, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 15);

    // Luck - Adds +1 to all saves
    sReagentList = MakeList(POWER1, EARTH1, OBSIDIAN);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_SAVING_THROW_BONUS, 1);
    CreateMagicalRecipe(SPELL_RESISTANCE, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 5);
}

void SetUpMagicalRecipes4()
{
	// Function Prototype:
	// void CreateMagicalRecipe(int iSpellId, string sEffect, string sTagSuffixList, string sReagentList);

    string sReagentList;
    string sRecipeEffect;

    //---------------------------
    //          WEAPONS 
    //---------------------------

    // Acid - Adds 1d6 acid damage
    sReagentList = MakeList(EARTH2, EMERALD);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1d6);
    CreateMagicalRecipe(SPELL_MELFS_ACID_ARROW, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 10);

    // Hunting - Adds +2d6 damage against beasts
    sReagentList = MakeList(POWER1, WATER1, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_BEAST, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d6);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 7);

    // Base Enchantment +1
    sReagentList = MakeList(AIR1, OBSIDIAN);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ENHANCEMENT_BONUS, 1);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 3);

    // Base Enchantment +2
    sReagentList = MakeList(AIR1, DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ENHANCEMENT_BONUS, 2);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 6);

    // Base Enchantment +3
    sReagentList = MakeList(AIR2, POWER1, EMERALD);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ENHANCEMENT_BONUS, 3);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 9);

    // Base Enchantment +4
    sReagentList = MakeList(AIR3, POWER2, STAR_SAPPHIRE);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ENHANCEMENT_BONUS, 4);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 12);

    // Base Enchantment +5
    sReagentList = MakeList(AIR3, POWER3, BLUE_DIAMOND);
    sRecipeEffect = MakeEncodedEffect(ITEM_PROPERTY_ENHANCEMENT_BONUS, 5);
    CreateMagicalRecipe(SPELL_LIGHT, sRecipeEffect, ITEM_CATEGORY_WEAPON, sReagentList, 15);

}

// =================================================================================
// Wondrous recipes
// =================================================================================
void SetUpWondrousRecipes1()
{
	// Function Prototype:
	// void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Boots of Striding +2
    sReagentList = MakeList(EARTH1, DIAMOND, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BEARS_ENDURANCE, sReagentList, BOOTS_STRIDING_2, 8);

	// Boots of Striding +4
    sReagentList = MakeList(EARTH2, JACINTH, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BEARS_ENDURANCE, sReagentList, BOOTS_STRIDING_4, 8);

	// Boots of Striding +6
    sReagentList = MakeList(EARTH3, ROGUE_STONE, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BEARS_ENDURANCE, sReagentList, BOOTS_STRIDING_6, 8);

	// Boots of Striding +8
    sReagentList = MakeList(EARTH4, BELJURIL, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BEARS_ENDURANCE, sReagentList, BOOTS_STRIDING_8, 8);

	// Amulet of Natural Armor +1
    sReagentList = MakeList(EARTH1, SAPPHIRE, INGOT_IRON);
	CreateWondrousRecipe(SPELL_BARKSKIN, sReagentList, AMULET_NATURAL_ARMOR_1, 5);

	// Amulet of Natural Armor +2
    sReagentList = MakeList(EARTH2, EMERALD, INGOT_IRON);
	CreateWondrousRecipe(SPELL_BARKSKIN, sReagentList, AMULET_NATURAL_ARMOR_2, 6);

	// Amulet of Natural Armor +3
    sReagentList = MakeList(EARTH3, POWER1, JACINTH, INGOT_IRON);
	CreateWondrousRecipe(SPELL_BARKSKIN, sReagentList, AMULET_NATURAL_ARMOR_3, 9);

	// Amulet of Natural Armor +4
    sReagentList = MakeList(EARTH3, POWER2, BLUE_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_BARKSKIN, sReagentList, AMULET_NATURAL_ARMOR_4, 12);

	// Amulet of Natural Armor +5
    sReagentList = MakeList(EARTH4, POWER2, BELJURIL, INGOT_IRON);
	CreateWondrousRecipe(SPELL_BARKSKIN, sReagentList, AMULET_NATURAL_ARMOR_5, 15);

	// Belt of Frost Giant Strength +4
    sReagentList = MakeList(FIRE2, BLUE_DIAMOND, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BULLS_STRENGTH, sReagentList, BELT_FROST_GIANT_STRENGTH, 8);

	// Belt of Stone Giant Strength +6
    sReagentList = MakeList(FIRE3, BELJURIL, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BULLS_STRENGTH, sReagentList, BELT_STONE_GIANT_STRENGTH, 8);

	// Belt of Cloud Giant Strength +8
    sReagentList = MakeList(FIRE4, KINGS_TEAR, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_BULLS_STRENGTH, sReagentList, BELT_CLOUD_GIANT_STRENGTH, 8);

	// Boots of Elvenkind
	// FAB: Check to see if the crafter is an elf
    sReagentList = MakeList(WATER1, FIRE_OPAL, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_SILENCE, sReagentList, BOOTS_ELVENKIND, 5);

	// Boots of Speed
    sReagentList = MakeList(AIR2, POWER2, STAR_SAPPHIRE, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_HASTE, sReagentList, BOOTS_SPEED, 7);

	// Bracers of Armor +1
    sReagentList = MakeList(EARTH1, OBSIDIAN, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_1, 7);

	// Bracers of Armor +2
    sReagentList = MakeList(EARTH1, DIAMOND, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_2, 7);

	// Bracers of Armor +3
    sReagentList = MakeList(EARTH2, CANARY_DIAMOND, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_3, 7);

	// Bracers of Armor +4
    sReagentList = MakeList(EARTH2, JACINTH, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_4, 8);

	// Bracers of Armor +5
    sReagentList = MakeList(EARTH3, BLUE_DIAMOND, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_5, 10);

	// Bracers of Armor +6
    sReagentList = MakeList(EARTH3, ROGUE_STONE, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_6, 12);

	// Bracers of Armor +7
    sReagentList = MakeList(EARTH4, BELJURIL, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_7, 14);

	// Bracers of Armor +8
    sReagentList = MakeList(EARTH4, KINGS_TEAR, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BRACERS_ARMOR_8, 16);

}
	
void SetUpWondrousRecipes2()
{
	// Function Prototype:
	// void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Brooch of Shielding
    sReagentList = MakeList(POWER1, SAPPHIRE, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, BROOCH_SHIELDING, 1);

	// Nymph Cloak +2
    sReagentList = MakeList(WATER1, DIAMOND, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_EAGLES_SPLENDOR, sReagentList, NYMPH_CLOAK_2, 8);

	// Nymph Cloak +4
    sReagentList = MakeList(WATER2, STAR_SAPPHIRE, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_EAGLES_SPLENDOR, sReagentList, NYMPH_CLOAK_4, 8);

	// Nymph Cloak +6
    sReagentList = MakeList(WATER3, ROGUE_STONE, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_EAGLES_SPLENDOR, sReagentList, NYMPH_CLOAK_6, 8);

	// Nymph Cloak +8
    sReagentList = MakeList(WATER4, BELJURIL, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_EAGLES_SPLENDOR, sReagentList, NYMPH_CLOAK_8, 8);

	// Cloak of Displacement
    sReagentList = MakeList(AIR2, BLUE_DIAMOND, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_DISPLACEMENT, sReagentList, CLOAK_DISPLACEMENT, 3);

	// Cloak of Elvenkind
	// FAB: Check to see if the crafter is an elf
    sReagentList = MakeList(WATER1, FIRE_OPAL, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_INVISIBILITY, sReagentList, CLOAK_ELVENKIND, 3);

	// Cloak of Resistance +1
    sReagentList = MakeList(EARTH1, OBSIDIAN, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_RESISTANCE, sReagentList, CLOAK_RESISTANCE_1, 5);

	// Cloak of Resistance +2
    sReagentList = MakeList(EARTH1, DIAMOND, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_RESISTANCE, sReagentList, CLOAK_RESISTANCE_2, 6);

	// Cloak of Resistance +3
    sReagentList = MakeList(EARTH2, CANARY_DIAMOND, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_RESISTANCE, sReagentList, CLOAK_RESISTANCE_3, 9);

	// Cloak of Resistance +4
    sReagentList = MakeList(EARTH3, JACINTH, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_RESISTANCE, sReagentList, CLOAK_RESISTANCE_4, 12);

	// Cloak of Resistance +5
    sReagentList = MakeList(EARTH4, BLUE_DIAMOND, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_RESISTANCE, sReagentList, CLOAK_RESISTANCE_5, 15);

	// Eyes of the Eagle
    //sReagentList = MakeList(AIR1, FIRE_OPAL, INGOT_IRON);
	//CreateWondrousRecipe(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, sReagentList, EYES_EAGLE, 3);

	// Gauntlets of Ogre Power
    sReagentList = MakeList(FIRE1, RUBY, INGOT_IRON, INGOT_IRON);
	CreateWondrousRecipe(SPELL_BULLS_STRENGTH, sReagentList, GAUNTLETS_OGRE_POWER, 6);

	// Gem of Seeing
    sReagentList = MakeList(AIR2, KINGS_TEAR);
	CreateWondrousRecipe(SPELL_TRUE_SEEING, sReagentList, GEM_SEEING, 10);

	// Belt of Agility +2
    sReagentList = MakeList(AIR1, DIAMOND, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_CATS_GRACE, sReagentList, BELT_AGILITY_2, 8);

	// Belt of Agility +4
    sReagentList = MakeList(AIR2, STAR_SAPPHIRE, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_CATS_GRACE, sReagentList, BELT_AGILITY_4, 8);

	// Belt of Agility +6
    sReagentList = MakeList(AIR3, ROGUE_STONE, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_CATS_GRACE, sReagentList, BELT_AGILITY_6, 8);

	// Belt of Agility +8
    sReagentList = MakeList(AIR4, BELJURIL, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_CATS_GRACE, sReagentList, BELT_AGILITY_8, 8);

	// Goggles of Minute Seeing
    //sReagentList = MakeList(AIR1, OBSIDIAN, INGOT_IRON);
	//CreateWondrousRecipe(SPELL_TRUE_SEEING, sReagentList, GOGGLES_MINUTE_SEEING, 3);

	// Goggles of Night
	//sReagentList = MakeList(POWER1, STAR_SAPPHIRE, INGOT_IRON);
	//CreateWondrousRecipe(SPELL_LIGHT, sReagentList, GOGGLES_NIGHT, 3);

	// Headband of Intellect +2
    sReagentList = MakeList(FIRE1, DIAMOND, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, HEADBAND_INTELLECT_2, 9);

	// Headband of Intellect +4
    sReagentList = MakeList(FIRE2, STAR_SAPPHIRE, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, HEADBAND_INTELLECT_4, 8);

	// Headband of Intellect +6
    sReagentList = MakeList(FIRE3, ROGUE_STONE, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, HEADBAND_INTELLECT_6, 8);

	// Headband of Intellect +8
    sReagentList = MakeList(FIRE4, BELJURIL, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, HEADBAND_INTELLECT_8, 8);

}
	
void SetUpWondrousRecipes3()
{
	// Function Prototype:
	// void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Horn of Goodness
   // sReagentList = MakeList(POWER2, WATER2, EMERALD, INGOT_IRON);
	//CreateWondrousRecipe(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, sReagentList, HORN_GOODNESS, 6);

	// Greater Mantle of Spell Resistance
    sReagentList = MakeList(POWER4, FIRE4, KINGS_TEAR, HIDE_LEATHER, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_SPELL_RESISTANCE, sReagentList, MANTLE_GREATER_SPELL_RESISTANCE, 9);

	// Medallion of Thought
    sReagentList = MakeList(WATER2, POWER2, CANARY_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, MEDALLION_THOUGHTS, 8);

	// Ring of Divine Power 1
    sReagentList = MakeList(FIRE1, OBSIDIAN, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, RING_DIVINE_POWER_1, 8);

	// Ring of Divine Power 2
    sReagentList = MakeList(FIRE2, OBSIDIAN, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, RING_DIVINE_POWER_2, 8);

	// Ring of Divine Power 3
    sReagentList = MakeList(POWER1, FIRE2, CANARY_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, RING_DIVINE_POWER_3, 8);

	// Ring of Divine Power 4
    sReagentList = MakeList(POWER2, FIRE3, STAR_SAPPHIRE, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, RING_DIVINE_POWER_4, 9);

	// Ring of Divine Power 5
    sReagentList = MakeList(POWER3, FIRE4, BLUE_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, RING_DIVINE_POWER_5, 11);
}
void SetUpWondrousRecipes3a()
{
	// Function Prototype:
	// void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Ring of Wizardry 1
    sReagentList = MakeList(AIR1, OBSIDIAN, INGOT_IRON);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, RING_WIZARDRY_1, 8);

	// Ring of Wizardry 2
    sReagentList = MakeList(AIR2, OBSIDIAN, INGOT_IRON);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, RING_WIZARDRY_2, 8);

	// Ring of Wizardry 3
    sReagentList = MakeList(POWER1, AIR2, CANARY_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, RING_WIZARDRY_3, 8);

	// Ring of Wizardry 4
    sReagentList = MakeList(POWER2, AIR3, STAR_SAPPHIRE, INGOT_IRON);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, RING_WIZARDRY_4, 9);

	// Ring of Wizardry 5
    sReagentList = MakeList(POWER3, AIR4, BLUE_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_FOXS_CUNNING, sReagentList, RING_WIZARDRY_5, 11);

	// Lesser Amulet of Health
    sReagentList = MakeList(POWER2, WATER2, OBSIDIAN, INGOT_IRON);
	CreateWondrousRecipe(SPELL_REMOVE_DISEASE, sReagentList, LESSER_AMULET_HEALTH, 5);
	CreateWondrousRecipe(SPELL_NEUTRALIZE_POISON, sReagentList, LESSER_AMULET_HEALTH, 5);

	// Amulet of Health
    sReagentList = MakeList(POWER3, WATER3, CANARY_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_REMOVE_DISEASE, sReagentList, AMULET_HEALTH, 5);
	CreateWondrousRecipe(SPELL_NEUTRALIZE_POISON, sReagentList, AMULET_HEALTH, 5);

	// Amulet of Health
    sReagentList = MakeList(POWER4, WATER4, BLUE_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_REMOVE_DISEASE, sReagentList, GREATER_AMULET_HEALTH, 5);
	CreateWondrousRecipe(SPELL_NEUTRALIZE_POISON, sReagentList, GREATER_AMULET_HEALTH, 5);
}
void SetUpWondrousRecipes3b()
{
	// Function Prototype:
	// void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Periapt of Wisdom +2
    sReagentList = MakeList(WATER1, DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, PERIAPT_WISDOM_2, 8);

	// Periapt of Wisdom +4
    sReagentList = MakeList(WATER2, STAR_SAPPHIRE, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, PERIAPT_WISDOM_4, 8);

	// Periapt of Wisdom +6
    sReagentList = MakeList(WATER3, ROGUE_STONE, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, PERIAPT_WISDOM_6, 8);

	// Periapt of Wisdom +8
    sReagentList = MakeList(WATER4, BELJURIL, INGOT_IRON);
	CreateWondrousRecipe(SPELL_OWLS_WISDOM, sReagentList, PERIAPT_WISDOM_8, 8);

	// Robe of the Archmage
    sReagentList = MakeList(WATER4, FIRE4, EARTH4, AIR4, POWER3, KINGS_TEAR, INGOT_IRON, HIDE_LEATHER);
	CreateWondrousRecipe(SPELL_MAGE_ARMOR, sReagentList, ROBE_ARCHMAGE, 14);
	CreateWondrousRecipe(SPELL_SHIELD_OF_FAITH, sReagentList, ROBE_ARCHMAGE, 14);

	// Scabbard of Keen Edges
    sReagentList = MakeList(EARTH1, JACINTH, PLANK_WOOD);
	CreateWondrousRecipe(SPELL_KEEN_EDGE, sReagentList, SCABBARD_KEEN_EDGES, 5);

	// Greater Scarab of Protection
    sReagentList = MakeList(POWER4, FIRE4, WATER4, BLUE_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_DEATH_WARD, sReagentList, SCARAB_GREATER_PROTECTION, 18);

	// The charm and focus can be created using standard darkness or the warlock invocation darkness
	// Gold Filigree Charm
	// TDE: used for summoning Mephasm in Crossroad Keep
    sReagentList = MakeList(POWER1, FIRE3, STAR_SAPPHIRE, GOLD_NECKLACE);
	CreateWondrousRecipe(SPELL_DARKNESS, sReagentList, MEPHASM_CHARM);
	CreateWondrousRecipe(SPELL_I_DARKNESS, sReagentList, MEPHASM_CHARM);
	
	// Infernal Focus 1
	// TDE: used for bargaining with Mephasm in Crossroad Keep
    sReagentList = MakeList(POWER3, RUBY, INGOT_DARKSTEEL);
	CreateWondrousRecipe(SPELL_DARKNESS, sReagentList, MEPHASM_FOCUS);
	CreateWondrousRecipe(SPELL_I_DARKNESS, sReagentList, MEPHASM_FOCUS);

	// Infernal Focus 2
	// TDE: used for bargaining with Mephasm in Crossroad Keep
    sReagentList = MakeList(FIRE3, SAPPHIRE, INGOT_MITHRAL);
	CreateWondrousRecipe(SPELL_DARKNESS, sReagentList, MEPHASM_FOCUS);
	CreateWondrousRecipe(SPELL_I_DARKNESS, sReagentList, MEPHASM_FOCUS);

	// Infernal Focus 3
	// TDE: used for bargaining with Mephasm in Crossroad Keep
    sReagentList = MakeList(POWER1, FIRE1, BLUE_DIAMOND, INGOT_IRON);
	CreateWondrousRecipe(SPELL_DARKNESS, sReagentList, MEPHASM_FOCUS);
	CreateWondrousRecipe(SPELL_I_DARKNESS, sReagentList, MEPHASM_FOCUS);

}

// =================================================================================
// Mundane recipes
// =================================================================================
void SetUpMundaneRecipes1()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Adamantine Battleaxe
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_AXBT, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_AXBT_ADA);

    // Cold Iron Battleaxe
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXBT, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_AXBT_CLD);

    // Darksteel Battleaxe
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_AXBT, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_AXBT_DRK);

    // Iron Battleaxe
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXBT, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_AXBT_IRN);

    // Mithral Battleaxe
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_AXBT, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_AXBT_MTH);

    // Silver Battleaxe
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_AXBT, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_AXBT_SLV);

    // Adamantine Dwarven waraxe
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_AXDV, SKILL_CRAFT_WEAPON, 23, sReagentList, WPN_AXDV_ADA);

    // Cold Iron Dwarven waraxe
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXDV, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_AXDV_CLD);

    // Darksteel Dwarven waraxe
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_AXDV, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_AXDV_DRK);

    // Iron Dwarven waraxe
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXDV, SKILL_CRAFT_WEAPON, 8, sReagentList, WPN_AXDV_IRN);

    // Mithral Dwarven waraxe
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_AXDV, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_AXDV_MTH);

    // Silver Dwarven waraxe
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_AXDV, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_AXDV_SLV);

    // Adamantine Greataxe
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_AXGR, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_AXGR_ADA);

    // Cold Iron Greataxe
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXGR, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_AXGR_CLD);

    // Darksteel Greataxe
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_AXGR, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_AXGR_DRK);

    // Iron Greataxe
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXGR, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_AXGR_IRN);

    // Mithral Greataxe
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_AXGR, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_AXGR_MTH);

    // Silver Greataxe
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_AXGR, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_AXGR_SLV);
}

void SetUpMundaneRecipes2()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;


    // Adamantine Handaxe
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_AXHN, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_AXHN_ADA);

    // Cold Iron Handaxe
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXHN, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_AXHN_CLD);

    // Darksteel Handaxe
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_AXHN, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_AXHN_DRK);

    // Iron Handaxe
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_AXHN, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_AXHN_IRN);

    // Mithral Handaxe
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_AXHN, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_AXHN_MTH);

    // Silver Handaxe
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_AXHN, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_AXHN_SLV);

    // Duskwood Club
    sReagentList = MakeList(PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_BLCL, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BLCL_DSK);

    // Wooden Club
    sReagentList = MakeList(PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_BLCL, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_BLCL_LAN);

    // Zalantar Club
    sReagentList = MakeList(PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_BLCL, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BLCL_ZAL);

}

void SetUpMundaneRecipes3()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;
	
	// -------------------------------------------------------------------------------------
    // Adamantine Hammer, light
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_BLHL, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_BLHL_ADA);

    // Cold Iron Hammer, light
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_BLHL, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BLHL_CLD);

    // Darksteel Hammer, light
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_BLHL, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_BLHL_DRK);

    // Iron Hammer, light
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_BLHL, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_BLHL_IRN);

    // Mithral Hammer, light
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_BLHL, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_BLHL_MTH);

    // Silver Hammer, light
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_BLHL, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BLHL_SLV);

	// -------------------------------------------------------------------------------------
    // Adamantine Warhammer
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_BLHW, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_BLHW_ADA);

    // Cold Iron Warhammer
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_BLHW, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BLHW_CLD);

    // Darksteel Warhammer
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_BLHW, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_BLHW_DRK);

    // Iron Warhammer
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_BLHW, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_BLHW_IRN);

    // Mithral Warhammer
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_BLHW, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_BLHW_MTH);

    // Silver Warhammer
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_BLHW, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BLHW_SLV);

	// -------------------------------------------------------------------------------------
    // Adamantine Mace
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_BLML, SKILL_CRAFT_WEAPON, 17, sReagentList, WPN_BLML_ADA);

    // Cold Iron Mace
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_BLML, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BLML_CLD);

    // Darksteel Mace
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_BLML, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BLML_DRK);

    // Iron Mace
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_BLML, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_BLML_IRN);

    // Mithral Mace
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_BLML, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BLML_MTH);

    // Silver Mace
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_BLML, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BLML_SLV);

	// -------------------------------------------------------------------------------------
    // Adamantine War Mace
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_WARMACE, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_WARMACE_ADA);

    // Cold Iron War Mace
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_WARMACE, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_WARMACE_CLD);

    // Darksteel War Mace
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_WARMACE, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_WARMACE_DRK);

    // Iron War Mace
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_WARMACE, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_WARMACE_IRN);

    // Mithral War Mace
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_WARMACE, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_WARMACE_MTH);

    // Silver War Mace
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_WARMACE, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_WARMACE_SLV);
	
}

void SetUpMundaneRecipes4()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Adamantine Morningstar
    sReagentList = MakeRepeatedItemList(INGOT_ADAMANTINE, 2);
    CreateMundaneRecipe(MOLD_WPN_BLMS, SKILL_CRAFT_WEAPON, 17, sReagentList, WPN_BLMS_ADA);

    // Cold Iron Morningstar
    sReagentList = MakeRepeatedItemList(INGOT_COLD_IRON, 2);
    CreateMundaneRecipe(MOLD_WPN_BLMS, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BLMS_CLD);

    // Darksteel Morningstar
    sReagentList = MakeRepeatedItemList(INGOT_DARKSTEEL, 2);
    CreateMundaneRecipe(MOLD_WPN_BLMS, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BLMS_DRK);

    // Iron Morningstar
    sReagentList = MakeRepeatedItemList(INGOT_IRON, 2);
    CreateMundaneRecipe(MOLD_WPN_BLMS, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_BLMS_IRN);

    // Mithral Morningstar
    sReagentList = MakeRepeatedItemList(INGOT_MITHRAL, 2);
    CreateMundaneRecipe(MOLD_WPN_BLMS, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BLMS_MTH);

    // Silver Morningstar
    sReagentList = MakeRepeatedItemList(INGOT_SILVER, 2);
    CreateMundaneRecipe(MOLD_WPN_BLMS, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BLMS_SLV);

    // Duskwood Longbow*
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_BWLN, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BWLN_DSK);

    // Wooden Longbow*
    sReagentList = MakeList(PLANK_WOOD, PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_BWLN, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_BWLN_LAN);

    // Shederran Longbow*
    sReagentList = MakeList(PLANK_SHEDERRAN, PLANK_SHEDERRAN);
    CreateMundaneRecipe(MOLD_WPN_BWLN, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BWLN_SHD);

    // Zalantar Longbow*
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_BWLN, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BWLN_ZAL);

    // Duskwood Shortbow*
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_BWSH, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_BWSH_DSK);

    // Wooden Shortbow*
    sReagentList = MakeList(PLANK_WOOD, PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_BWSH, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_BWSH_LAN);

    // Shederran Shortbow*
    sReagentList = MakeList(PLANK_SHEDERRAN, PLANK_SHEDERRAN);
    CreateMundaneRecipe(MOLD_WPN_BWSH, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BWSH_SHD);

    // Zalantar Shortbow*
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_BWSH, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_BWSH_ZAL);

    // Duskwood Crossbow, heavy*
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_BWXH, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BWXH_DSK);

    // Wooden Crossbow, heavy*
    sReagentList = MakeList(PLANK_WOOD, PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_BWXH, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_BWXH_LAN);

    // Shederran Crossbow, heavy*
    sReagentList = MakeList(PLANK_SHEDERRAN, PLANK_SHEDERRAN);
    CreateMundaneRecipe(MOLD_WPN_BWXH, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_BWXH_SHD);

    // Zalantar Crossbow, heavy*
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_BWXH, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_BWXH_ZAL);

    // Duskwood Crossbow, light*
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_BWXL, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_BWXL_DSK);

    // Wooden Crossbow, light*
    sReagentList = MakeList(PLANK_WOOD, PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_BWXL, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_BWXL_LAN);

    // Shederran Crossbow, light*
    sReagentList = MakeList(PLANK_SHEDERRAN, PLANK_SHEDERRAN);
    CreateMundaneRecipe(MOLD_WPN_BWXL, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_BWXL_SHD);

    // Zalantar Crossbow, light*
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_BWXL, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_BWXL_ZAL);
}

void SetUpMundaneRecipes5()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Duskwood Quarterstaff
    sReagentList = MakeList(PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_DBQS, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_DBQS_DSK);

    // Wooden Quarterstaff
    sReagentList = MakeList(PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_DBQS, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_DBQS_LAN);

    // Zalantar Quarterstaff
    sReagentList = MakeList(PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_DBQS, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_DBQS_ZAL);

    // Adamantine Halberd
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_PLHB, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_PLHB_ADA);

    // Cold Iron Halberd
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_PLHB, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_PLHB_CLD);

    // Darksteel Halberd
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_PLHB, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_PLHB_DRK);

    // Iron Halberd
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_PLHB, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_PLHB_IRN);

    // Mithral Halberd
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_PLHB, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_PLHB_MTH);

    // Silver Halberd
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_PLHB, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_PLHB_SLV);

    // Adamantine Scythe
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_PLSC, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_PLSC_ADA);

    // Cold Iron Scythe
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_PLSC, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_PLSC_CLD);

    // Darksteel Scythe
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_PLSC, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_PLSC_DRK);

    // Iron Scythe
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_PLSC, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_PLSC_IRN);

    // Mithral Scythe
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_PLSC, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_PLSC_MTH);

    // Silver Scythe
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_PLSC, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_PLSC_SLV);

    // Duskwood Spear
    sReagentList = MakeList(PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_WPN_PLSS, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_PLSS_DSK);

    // Wooden Spear
    sReagentList = MakeList(PLANK_WOOD);
    CreateMundaneRecipe(MOLD_WPN_PLSS, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_PLSS_LAN);

    // Zalantar Spear
    sReagentList = MakeList(PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_WPN_PLSS, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_PLSS_ZAL);

    // Adamantine Kama 
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SPKA, SKILL_CRAFT_WEAPON, 23, sReagentList, WPN_SPKA_ADA);

    // Cold Iron Kama 
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SPKA, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SPKA_CLD);

    // Darksteel Kama 
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SPKA, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SPKA_DRK);

    // Iron Kama 
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SPKA, SKILL_CRAFT_WEAPON, 8, sReagentList, WPN_SPKA_IRN);

    // Mithral Kama 
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SPKA, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SPKA_MTH);

    // Silver Kama 
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SPKA, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SPKA_SLV);
}

void SetUpMundaneRecipes6()
{
	// Kukri
	SetUpStandardMetalItem(MOLD_WPN_SPKU, 1, 8, WPN_SPKU_ADA, WPN_SPKU_CLD, WPN_SPKU_DRK, WPN_SPKU_IRN, WPN_SPKU_MTH, WPN_SPKU_SLV);

	// Sickle			
	SetUpStandardMetalItem(MOLD_WPN_SPSC, 1, 2, WPN_SPSC_ADA, WPN_SPSC_CLD, WPN_SPSC_DRK, WPN_SPSC_IRN, WPN_SPSC_MTH, WPN_SPSC_SLV);

	// Bastard Sword
	SetUpStandardMetalItem(MOLD_WPN_SWBS, 2, 8, WPN_SWBS_ADA, WPN_SWBS_CLD, WPN_SWBS_DRK, WPN_SWBS_IRN, WPN_SWBS_MTH, WPN_SWBS_SLV);
	
	// Falchion
	SetUpStandardMetalItem(MOLD_WPN_SWFL, 2, 8, WPN_SWFL_ADA, WPN_SWFL_CLD, WPN_SWFL_DRK, WPN_SWFL_IRN, WPN_SWFL_MTH, WPN_SWFL_SLV);
	
/*	
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

	// -------------------------------------------------------------------------------------
    // Adamantine Kukri
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SPKU, SKILL_CRAFT_WEAPON, 23, sReagentList, WPN_SPKU_ADA);

    // Cold Iron Kukri
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SPKU, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SPKU_CLD);

    // Darksteel Kukri
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SPKU, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SPKU_DRK);

    // Iron Kukri
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SPKU, SKILL_CRAFT_WEAPON, 8, sReagentList, WPN_SPKU_IRN);

    // Mithral Kukri
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SPKU, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SPKU_MTH);

    // Silver Kukri
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SPKU, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SPKU_SLV);

	// -------------------------------------------------------------------------------------
    // Adamantine Sickle
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SPSC, SKILL_CRAFT_WEAPON, 17, sReagentList, WPN_SPSC_ADA);

    // Cold Iron Sickle
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SPSC, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_SPSC_CLD);

    // Darksteel Sickle
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SPSC, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_SPSC_DRK);

    // Iron Sickle
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SPSC, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_SPSC_IRN);

    // Mithral Sickle
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SPSC, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_SPSC_MTH);

    // Silver Sickle
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SPSC, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_SPSC_SLV);

	// -------------------------------------------------------------------------------------
    // Adamantine Bastard sword
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWBS, SKILL_CRAFT_WEAPON, 23, sReagentList, WPN_SWBS_ADA);

    // Cold Iron Bastard sword
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWBS, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SWBS_CLD);

    // Darksteel Bastard sword
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWBS, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SWBS_DRK);

    // Iron Bastard sword
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWBS, SKILL_CRAFT_WEAPON, 8, sReagentList, WPN_SWBS_IRN);

    // Mithral Bastard sword
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWBS, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SWBS_MTH);

   	// Silver Bastard sword
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWBS, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SPSC_SLV);

	// -------------------------------------------------------------------------------------
    // Adamantine Falchion
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWFL, SKILL_CRAFT_WEAPON, 23, sReagentList, WPN_SWFL_ADA);

    // Cold Iron Falchion
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWFL, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SWFL_CLD);

    // Darksteel Falchion
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWFL, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SWFL_DRK);

    // Iron Falchion
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWFL, SKILL_CRAFT_WEAPON, 8, sReagentList, WPN_SWFL_IRN);

    // Mithral Falchion
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWFL, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SWFL_MTH);

   	// Silver Falchion
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWFL, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWFL_SLV);
	*/	
}

void SetUpMundaneRecipes7()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Adamantine Dagger
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWDG, SKILL_CRAFT_WEAPON, 17, sReagentList, WPN_SWDG_ADA);

    // Cold Iron Dagger
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWDG, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_SWDG_CLD);

    // Darksteel Dagger
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWDG, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_SWDG_DRK);

    // Iron Dagger
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWDG, SKILL_CRAFT_WEAPON, 2, sReagentList, WPN_SWDG_IRN);

    // Mithral Dagger
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWDG, SKILL_CRAFT_WEAPON, 12, sReagentList, WPN_SWDG_MTH);

    // Silver Dagger
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWDG, SKILL_CRAFT_WEAPON, 7, sReagentList, WPN_SWDG_SLV);

    // Adamantine Greatsword
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWGS, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_SWGS_ADA);

    // Cold Iron Greatsword
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWGS, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWGS_CLD);

    // Darksteel Greatsword
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWGS, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWGS_DRK);

    // Iron Greatsword
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWGS, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_SWGS_IRN);

    // Mithral Greatsword
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWGS, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWGS_MTH);

    // Silver Greatsword
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWGS, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWGS_SLV);

    // Adamantine Katana
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWKA, SKILL_CRAFT_WEAPON, 23, sReagentList, WPN_SWKA_ADA);

    // Cold Iron Katana
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWKA, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SWKA_CLD);

    // Darksteel Katana
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWKA, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SWKA_DRK);

    // Iron Katana
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWKA, SKILL_CRAFT_WEAPON, 8, sReagentList, WPN_SWKA_IRN);

    // Mithral Katana
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWKA, SKILL_CRAFT_WEAPON, 18, sReagentList, WPN_SWKA_MTH);

    // Silver Katana
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWKA, SKILL_CRAFT_WEAPON, 13, sReagentList, WPN_SWKA_SLV);

    // Adamantine Longsword
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWLS, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_SWLS_ADA);

    // Cold Iron Longsword
    sReagentList = MakeList(INGOT_COLD_IRON, INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWLS, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWLS_CLD);

    // Darksteel Longsword
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWLS, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWLS_DRK);

    // Iron Longsword
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWLS, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_SWLS_IRN);

    // Mithral Longsword
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWLS, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWLS_MTH);

    // Silver Longsword
    sReagentList = MakeList(INGOT_SILVER, INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWLS, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWLS_SLV);
}

void SetUpMundaneRecipes8()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Adamantine Rapier
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWRP, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_SWRP_ADA);

    // Cold Iron Rapier
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWRP, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWRP_CLD);

    // Darksteel Rapier
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWRP, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWRP_DRK);

    // Iron Rapier
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWRP, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_SWRP_IRN);

    // Mithral Rapier
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWRP, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWRP_MTH);

    // Silver Rapier
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWRP, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWRP_SLV);

    // Adamantine Scimitar
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWSC, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_SWSC_ADA);

    // Cold Iron Scimitar
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWSC, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWSC_CLD);

    // Darksteel Scimitar
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWSC, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWSC_DRK);

    // Iron Scimitar
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWSC, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_SWSC_IRN);

    // Mithral Scimitar
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWSC, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWSC_MTH);

    // Silver Scimitar
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWSC, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWSC_SLV);

    // Adamantine Shortsword
    sReagentList = MakeList(INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_WPN_SWSS, SKILL_CRAFT_WEAPON, 20, sReagentList, WPN_SWSS_ADA);

    // Cold Iron Shortsword
    sReagentList = MakeList(INGOT_COLD_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWSS, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWSS_CLD);

    // Darksteel Shortsword
    sReagentList = MakeList(INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_WPN_SWSS, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWSS_DRK);

    // Iron Shortsword
    sReagentList = MakeList(INGOT_IRON);
    CreateMundaneRecipe(MOLD_WPN_SWSS, SKILL_CRAFT_WEAPON, 5, sReagentList, WPN_SWSS_IRN);

    // Mithral Shortsword
    sReagentList = MakeList(INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_WPN_SWSS, SKILL_CRAFT_WEAPON, 15, sReagentList, WPN_SWSS_MTH);

    // Silver Shortsword
    sReagentList = MakeList(INGOT_SILVER);
    CreateMundaneRecipe(MOLD_WPN_SWSS, SKILL_CRAFT_WEAPON, 10, sReagentList, WPN_SWSS_SLV);

    // Adamantine Full Plate
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_HVFP, SKILL_CRAFT_ARMOR, 23, sReagentList, ARM_HVFP_ADA);

    // Darksteel Full Plate
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_HVFP, SKILL_CRAFT_ARMOR, 18, sReagentList, ARM_HVFP_DRK);

    // Iron Full Plate
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_HVFP, SKILL_CRAFT_ARMOR, 8, sReagentList, ARM_HVFP_IRN);

    // Mithral Full Plate
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_HVFP, SKILL_CRAFT_ARMOR, 18, sReagentList, ARM_HVFP_MTH);

    // Wyvern Hide Full Plate
    sReagentList = MakeList(HIDE_WYVERN, HIDE_WYVERN, HIDE_WYVERN);
    CreateMundaneRecipe(MOLD_ARM_HVFP, SKILL_CRAFT_ARMOR, 28, sReagentList, ARM_HVFP_WYH);

}

void SetUpMundaneRecipes9()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Adamantine Half-plate
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 22, sReagentList, ARM_HVHP_ADA);

    // Darksteel Half-plate
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 17, sReagentList, ARM_HVHP_DRK);

    // Iron Half-plate
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 7, sReagentList, ARM_HVHP_IRN);

    // Mithral Half-plate
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 17, sReagentList, ARM_HVHP_MTH);

    // Red Dragon Hide Half-plate
    sReagentList = MakeList(HIDE_DRAGON, HIDE_DRAGON, HIDE_DRAGON);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 30, sReagentList, ARM_HVHP_RDH);

    // Umber Hulk Hide Half-plate
    sReagentList = MakeList(HIDE_UMBER_HULK, HIDE_UMBER_HULK, HIDE_UMBER_HULK);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 24, sReagentList, ARM_HVHP_UHH);

    // Wyvern Hide Half-plate
    sReagentList = MakeList(HIDE_WYVERN, HIDE_WYVERN, HIDE_WYVERN);
    CreateMundaneRecipe(MOLD_ARM_HVHP, SKILL_CRAFT_ARMOR, 27, sReagentList, ARM_HVHP_WYH);

    // Adamantine Chain Shirt
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_LTCS, SKILL_CRAFT_ARMOR, 19, sReagentList, ARM_LTCS_ADA);

    // Darksteel Chain Shirt
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_LTCS, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_LTCS_DRK);

    // Iron Chain Shirt
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_LTCS, SKILL_CRAFT_ARMOR, 4, sReagentList, ARM_LTCS_IRN);

    // Mithral Chain Shirt
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_LTCS, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_LTCS_MTH);

}

void SetUpMundaneRecipes9a()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Iron Banded Mail
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_HVBM, SKILL_CRAFT_ARMOR, 6, sReagentList, ARM_HVBM_IRN);

    // Adamantine Banded Mail
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_HVBM, SKILL_CRAFT_ARMOR, 21, sReagentList, ARM_HVBM_ADA);

    // Darksteel Banded Mail
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_HVBM, SKILL_CRAFT_ARMOR, 16, sReagentList, ARM_HVBM_DRK);

    // Mithral Banded Mail
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_HVBM, SKILL_CRAFT_ARMOR, 16, sReagentList, ARM_HVBM_MTH);



    // Leather Leather
    sReagentList = MakeList(HIDE_LEATHER, HIDE_LEATHER, HIDE_LEATHER);
    CreateMundaneRecipe(MOLD_ARM_LTLT, SKILL_CRAFT_ARMOR, 4, sReagentList, ARM_LTLT_HID);

    // Salamander Hide Leather
    sReagentList = MakeList(HIDE_SALAMANDER, HIDE_SALAMANDER, HIDE_SALAMANDER);
    CreateMundaneRecipe(MOLD_ARM_LTLT, SKILL_CRAFT_ARMOR, 16, sReagentList, ARM_LTLT_SLH);

    // Leather Studded Leather
    sReagentList = MakeList(HIDE_LEATHER, HIDE_LEATHER, HIDE_LEATHER);
    CreateMundaneRecipe(MOLD_ARM_LTSL, SKILL_CRAFT_ARMOR, 5, sReagentList, ARM_LTSL_HID);

    // Salamander Hide Studded Leather
    sReagentList = MakeList(HIDE_SALAMANDER, HIDE_SALAMANDER, HIDE_SALAMANDER);
    CreateMundaneRecipe(MOLD_ARM_LTSL, SKILL_CRAFT_ARMOR, 17, sReagentList, ARM_LTSL_SLH);

    // Adamantine Breastplate
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 20, sReagentList, ARM_MDBP_ADA);

    // Darksteel Breastplate
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 15, sReagentList, ARM_MDBP_DRK);

    // Duskwood Breastplate
    //sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    //CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 10, sReagentList, ARM_MDBP_DSK);

    // Iron Breastplate
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 5, sReagentList, ARM_MDBP_IRN);

    // Mithral Breastplate
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 15, sReagentList, ARM_MDBP_MTH);

}

void SetUpMundaneRecipes10()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

    // Red Dragon Hide Breastplate
    sReagentList = MakeList(HIDE_DRAGON, HIDE_DRAGON, HIDE_DRAGON);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 28, sReagentList, ARM_MDBP_RDH);

    // Umber Hulk Hide Breastplate
    sReagentList = MakeList(HIDE_UMBER_HULK, HIDE_UMBER_HULK, HIDE_UMBER_HULK);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 22, sReagentList, ARM_MDBP_UHH);

    // Wyvern Hide Breastplate
    sReagentList = MakeList(HIDE_WYVERN, HIDE_WYVERN, HIDE_WYVERN);
    CreateMundaneRecipe(MOLD_ARM_MDBP, SKILL_CRAFT_ARMOR, 25, sReagentList, ARM_MDBP_WYH);

    // Adamantine Chainmail
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_MDCM, SKILL_CRAFT_ARMOR, 20, sReagentList, ARM_MDCM_ADA);

    // Darksteel Chainmail
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_MDCM, SKILL_CRAFT_ARMOR, 15, sReagentList, ARM_MDCM_DRK);

    // Iron Chainmail
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_MDCM, SKILL_CRAFT_ARMOR, 5, sReagentList, ARM_MDCM_IRN);

    // Mithral Chainmail
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_MDCM, SKILL_CRAFT_ARMOR, 15, sReagentList, ARM_MDCM_MTH);

    // Leather Hide
    sReagentList = MakeList(HIDE_LEATHER, HIDE_LEATHER);
    CreateMundaneRecipe(MOLD_ARM_MDHD, SKILL_CRAFT_ARMOR, 5, sReagentList, ARM_MDHD_HID);

    //Salamander Hide
    sReagentList = MakeList(HIDE_SALAMANDER, HIDE_SALAMANDER);
    CreateMundaneRecipe(MOLD_ARM_MDHD, SKILL_CRAFT_ARMOR, 17, sReagentList, ARM_MDHD_SLH);

    // Padded Armor
    sReagentList = "";
    CreateMundaneRecipe(MOLD_ARM_LTPD, SKILL_CRAFT_ARMOR, 2, sReagentList, ARM_LTPD_HID);

}

void SetUpMundaneRecipes10a()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;


    // Adamantine Scale Mail
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_MDSM, SKILL_CRAFT_ARMOR, 19, sReagentList, ARM_MDSM_ADA);

    // Darksteel Scale Mail
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_MDSM, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_MDSM_DRK);

    // Iron Scale Mail
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_MDSM, SKILL_CRAFT_ARMOR, 4, sReagentList, ARM_MDSM_IRN);

    // Mithral Scale Mail
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_MDSM, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_MDSM_MTH);

    // Red Dragon Hide Scale Mail
    sReagentList = MakeList(HIDE_DRAGON, HIDE_DRAGON, HIDE_DRAGON);
    CreateMundaneRecipe(MOLD_ARM_MDSM, SKILL_CRAFT_ARMOR, 27, sReagentList, ARM_MDSM_RDH);

    // Wyvern Hide Scale Mail
    sReagentList = MakeList(HIDE_WYVERN, HIDE_WYVERN, HIDE_WYVERN);
    CreateMundaneRecipe(MOLD_ARM_MDSM, SKILL_CRAFT_ARMOR, 24, sReagentList, ARM_MDSM_WYH);

    // Adamantine Heavy Shield
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 17, sReagentList, ARM_SHHV_ADA);

    // Darksteel Heavy Shield
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 12, sReagentList, ARM_SHHV_DRK);

    // Duskwood Heavy Shield
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 7, sReagentList, ARM_SHHV_DSK);

    // Iron Heavy Shield
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 2, sReagentList, ARM_SHHV_IRN);

    // Mithral Heavy Shield
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 12, sReagentList, ARM_SHHV_MTH);

    // Umber Hulk Hide Heavy Shield
    sReagentList = MakeList(HIDE_UMBER_HULK, HIDE_UMBER_HULK);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 19, sReagentList, ARM_SHHV_UHH);

    // Zalantar Heavy Shield
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_ARM_SHHV, SKILL_CRAFT_ARMOR, 12, sReagentList, ARM_SHHV_ZAL);

}

void SetUpMundaneRecipes11()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;


    // Adamantine Light Shield
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 16, sReagentList, ARM_SHLT_ADA);

    // Darksteel Light Shield
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 11, sReagentList, ARM_SHLT_DRK);

    // Duskwood Light Shield
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 6, sReagentList, ARM_SHLT_DSK);

    // Iron Light Shield
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 1, sReagentList, ARM_SHLT_IRN);

    // Mithral Light Shield
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 11, sReagentList, ARM_SHLT_MTH);

    // Umber Hulk Hide Light Shield
    sReagentList = MakeList(HIDE_UMBER_HULK, HIDE_UMBER_HULK);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 18, sReagentList, ARM_SHLT_UHH);

    // Zalantar Light Shield
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_ARM_SHLT, SKILL_CRAFT_ARMOR, 11, sReagentList, ARM_SHLT_ZAL);

    // Adamantine Tower Shield
    sReagentList = MakeList(INGOT_ADAMANTINE, INGOT_ADAMANTINE, INGOT_ADAMANTINE);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 19, sReagentList, ARM_SHTW_ADA);

    // Darksteel Tower Shield
    sReagentList = MakeList(INGOT_DARKSTEEL, INGOT_DARKSTEEL, INGOT_DARKSTEEL);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_SHTW_DRK);

    // Duskwood Tower Shield
    sReagentList = MakeList(PLANK_DUSKWOOD, PLANK_DUSKWOOD, PLANK_DUSKWOOD);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 9, sReagentList, ARM_SHTW_DSK);

    // Iron Tower Shield
    sReagentList = MakeList(INGOT_IRON, INGOT_IRON, INGOT_IRON);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 4, sReagentList, ARM_SHTW_IRN);

    // Mithral Tower Shield
    sReagentList = MakeList(INGOT_MITHRAL, INGOT_MITHRAL, INGOT_MITHRAL);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_SHTW_MTH);

    // Umber Hulk Hide Tower Shield
    sReagentList = MakeList(HIDE_UMBER_HULK, HIDE_UMBER_HULK, HIDE_UMBER_HULK);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 21, sReagentList, ARM_SHTW_UHH);

    // Zalantar Tower Shield
    sReagentList = MakeList(PLANK_ZALANTAR, PLANK_ZALANTAR, PLANK_ZALANTAR);
    CreateMundaneRecipe(MOLD_ARM_SHTW, SKILL_CRAFT_ARMOR, 14, sReagentList, ARM_SHTW_ZAL);

}

// =================================================================================
// Alchemy recipes
// =================================================================================
void SetUpAlchemyRecipes1()
{
	// Function Prototype:
	// void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

        //Acid Flask
        sReagentList = MakeList(VENOM_GLAND, QUICKSILVER);
        CreateAlchemyRecipe(4, sReagentList, ACID_FLASK_1);

        //Improved Acid Flask
        sReagentList = MakeList(VENOM_GLAND, VENOM_GLAND, QUICKSILVER, QUICKSILVER);
        CreateAlchemyRecipe(8, sReagentList, ACID_FLASK_2);

        //Greater Acid Flask
        sReagentList = MakeList(VENOM_GLAND, VENOM_GLAND, VENOM_GLAND, QUICKSILVER, QUICKSILVER, QUICKSILVER);
        CreateAlchemyRecipe(12, sReagentList, ACID_FLASK_3);

        //Perfected Acid Flask
        sReagentList = MakeList(VENOM_GLAND, VENOM_GLAND, VENOM_GLAND, VENOM_GLAND, QUICKSILVER, QUICKSILVER, QUICKSILVER, QUICKSILVER);
        CreateAlchemyRecipe(16, sReagentList, ACID_FLASK_4);

        //Alchemists Fire
        sReagentList = MakeList(FAIRY_DUST, DISTILLED_ALCOHOL);
        CreateAlchemyRecipe(4, sReagentList, ALCHEMIST_FIRE_1);

        //Improved Alchemists Fire
        sReagentList = MakeList(FAIRY_DUST, FAIRY_DUST, DISTILLED_ALCOHOL, DISTILLED_ALCOHOL);
        CreateAlchemyRecipe(8, sReagentList, ALCHEMIST_FIRE_2);
}

void SetUpAlchemyRecipes2()
{
	// Function Prototype:
	// void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;


	    //Greater Alchemists Fire
        sReagentList = MakeList(FAIRY_DUST, FAIRY_DUST, FAIRY_DUST, DISTILLED_ALCOHOL, DISTILLED_ALCOHOL, DISTILLED_ALCOHOL);
        CreateAlchemyRecipe(12, sReagentList, ALCHEMIST_FIRE_3);

        //Perfected Alchemists Fire
        sReagentList = MakeList(FAIRY_DUST, FAIRY_DUST, FAIRY_DUST, FAIRY_DUST, DISTILLED_ALCOHOL, DISTILLED_ALCOHOL, DISTILLED_ALCOHOL, DISTILLED_ALCOHOL);
        CreateAlchemyRecipe(16, sReagentList, ALCHEMIST_FIRE_4);

        //Choking Powder
        sReagentList = MakeList(BELLADONNA, GARLIC);
        CreateAlchemyRecipe(4, sReagentList, CHOKING_POWDER_1);

        //Improved Choking Powder
        sReagentList = MakeList(BELLADONNA, BELLADONNA, GARLIC, GARLIC);
        CreateAlchemyRecipe(8, sReagentList, CHOKING_POWDER_2);

        //Greater Choking Powder
        sReagentList = MakeList(BELLADONNA, BELLADONNA, BELLADONNA, GARLIC, GARLIC, GARLIC);
        CreateAlchemyRecipe(12, sReagentList, CHOKING_POWDER_3);

        //Perfected Choking Powder
        sReagentList = MakeList(BELLADONNA, BELLADONNA, BELLADONNA, BELLADONNA, GARLIC, GARLIC, GARLIC, GARLIC);
        CreateAlchemyRecipe(16, sReagentList, CHOKING_POWDER_4);
}
void SetUpAlchemyRecipes3()
{
	// Function Prototype:
	// void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

        //Holy Water
        sReagentList = MakeList(POWDERED_SILVER, AMETHYST);
        CreateAlchemyRecipe(4, sReagentList, HOLY_WATER_1);

        //Improved Holy Water
        sReagentList = MakeList(POWDERED_SILVER, POWDERED_SILVER, AMETHYST, AMETHYST);
        CreateAlchemyRecipe(8, sReagentList, HOLY_WATER_2);

        //Greater Holy Water
        sReagentList = MakeList(POWDERED_SILVER, POWDERED_SILVER, POWDERED_SILVER, AMETHYST, AMETHYST, AMETHYST);
        CreateAlchemyRecipe(12, sReagentList, HOLY_WATER_3);

        //Perfected Holy Water
        sReagentList = MakeList(POWDERED_SILVER, POWDERED_SILVER, POWDERED_SILVER, POWDERED_SILVER, AMETHYST, AMETHYST, AMETHYST, AMETHYST);
        CreateAlchemyRecipe(16, sReagentList, HOLY_WATER_4);

        //Tanglefoot Bag
        sReagentList = MakeList(QUICKSILVER, BELLADONNA);
        CreateAlchemyRecipe(4, sReagentList, TANGLEFOOT_BAG_1);

        //Improved Tanglefoot Bag
        sReagentList = MakeList(QUICKSILVER, QUICKSILVER, BELLADONNA, BELLADONNA);
        CreateAlchemyRecipe(8, sReagentList, TANGLEFOOT_BAG_2);
}
void SetUpAlchemyRecipes4()
{
	// Function Prototype:
	// void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

        //Greater Tanglefoot Bag
        sReagentList = MakeList(QUICKSILVER, QUICKSILVER, QUICKSILVER, BELLADONNA, BELLADONNA, BELLADONNA);
        CreateAlchemyRecipe(12, sReagentList, TANGLEFOOT_BAG_3);

        //Perfected Tanglefoot Bag
        sReagentList = MakeList(QUICKSILVER, QUICKSILVER, QUICKSILVER, QUICKSILVER, BELLADONNA, BELLADONNA, BELLADONNA, BELLADONNA);
        CreateAlchemyRecipe(16, sReagentList, TANGLEFOOT_BAG_4);

        //Thunderstone
        sReagentList = MakeList(DIAMOND_DUST, AMETHYST);
        CreateAlchemyRecipe(4, sReagentList, THUNDERSTONE_1);

        //Improved Thunderstone
        sReagentList = MakeList(DIAMOND_DUST, DIAMOND_DUST, AMETHYST, AMETHYST);
        CreateAlchemyRecipe(8, sReagentList, THUNDERSTONE_2);

        //Greater Thunderstone
        sReagentList = MakeList(DIAMOND_DUST, DIAMOND_DUST, DIAMOND_DUST, AMETHYST, AMETHYST, AMETHYST);
        CreateAlchemyRecipe(12, sReagentList, THUNDERSTONE_3);

        //Perfected Thunderstone
        sReagentList = MakeList(DIAMOND_DUST, DIAMOND_DUST, DIAMOND_DUST, DIAMOND_DUST, AMETHYST, AMETHYST, AMETHYST, AMETHYST);
        CreateAlchemyRecipe(16, sReagentList, THUNDERSTONE_4);
}

void SetUpAlchemyRecipes5()
{
	string sReagentList; 
	
	// Mild Centipede Venom
	sReagentList = MakeList(CENTIPEDE_GLAND);
	CreateAlchemyRecipe(4, sReagentList, CENTIPEDE_POISON_1);

	// Average Centipede Venom
	sReagentList = MakeList(CENTIPEDE_GLAND, CENTIPEDE_GLAND);
	CreateAlchemyRecipe(8, sReagentList, CENTIPEDE_POISON_2);

	// Strong Centipede Venom
	sReagentList = MakeList(CENTIPEDE_GLAND, CENTIPEDE_GLAND, CENTIPEDE_GLAND);
	CreateAlchemyRecipe(12, sReagentList, CENTIPEDE_POISON_3);

	// Deadly Centipede Venom
	sReagentList = MakeList(CENTIPEDE_GLAND, CENTIPEDE_GLAND, CENTIPEDE_GLAND, CENTIPEDE_GLAND);
	CreateAlchemyRecipe(16, sReagentList, CENTIPEDE_POISON_4);

	// Mild Giant Bee Venom
	sReagentList = MakeList(BEE_GLAND);
	CreateAlchemyRecipe(4, sReagentList, BEE_POISON_1);

	// Average Giant Bee Venom
	sReagentList = MakeList(BEE_GLAND, BEE_GLAND);
	CreateAlchemyRecipe(8, sReagentList, BEE_POISON_2);

	// Strong Giant Bee Venom
	sReagentList = MakeList(BEE_GLAND, BEE_GLAND, BEE_GLAND);
	CreateAlchemyRecipe(12, sReagentList, BEE_POISON_3);

	// Deadly Giant Bee Venom
	sReagentList = MakeList(BEE_GLAND, BEE_GLAND, BEE_GLAND, BEE_GLAND);
	CreateAlchemyRecipe(16, sReagentList, BEE_POISON_4);

	// Weak Scorpion Venom
	sReagentList = MakeList(SCORPION_GLAND);
	CreateAlchemyRecipe(4, sReagentList, SCORPION_POISON_1);

	// Average Scorpion Venom
	sReagentList = MakeList(SCORPION_GLAND, SCORPION_GLAND);
	CreateAlchemyRecipe(8, sReagentList, SCORPION_POISON_2);

	// Strong Scorpion Venom
	sReagentList = MakeList(SCORPION_GLAND, SCORPION_GLAND, SCORPION_GLAND);
	CreateAlchemyRecipe(12, sReagentList, SCORPION_POISON_3);

	// Deadly Scorpion Venom
	sReagentList = MakeList(SCORPION_GLAND, SCORPION_GLAND, SCORPION_GLAND, SCORPION_GLAND);
	CreateAlchemyRecipe(16, sReagentList, SCORPION_POISON_4);
}


// Alchemy recipes for coalescing essences.
const int NUM_ESSENCES_FOR_COALESCENCE = 2;
const int WEAK_COALESCENCE_SKILL = 5;
const int GLOWING_COALESCENCE_SKILL = 10;
const int RADIANT_COALESCENCE_SKILL = 15;

void SetUpAlchemyRecipes6()
{
	// Function Prototype:
	// void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

	// AIR 1 -> AIR 2
	sReagentList = MakeRepeatedItemList(AIR1, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(WEAK_COALESCENCE_SKILL, sReagentList, AIR2);

	// AIR 2 -> AIR 3
	sReagentList = MakeRepeatedItemList(AIR2, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(GLOWING_COALESCENCE_SKILL, sReagentList, AIR3);

	// AIR 3 -> AIR 4
	sReagentList = MakeRepeatedItemList(AIR3, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(RADIANT_COALESCENCE_SKILL, sReagentList, AIR4);

	// WATER 1 -> WATER 2
	sReagentList = MakeRepeatedItemList(WATER1, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(WEAK_COALESCENCE_SKILL, sReagentList, WATER2);

	// WATER 2 -> WATER 3
	sReagentList = MakeRepeatedItemList(WATER2, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(GLOWING_COALESCENCE_SKILL, sReagentList, WATER3);

	// WATER 3 -> WATER 4
	sReagentList = MakeRepeatedItemList(WATER3, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(RADIANT_COALESCENCE_SKILL, sReagentList, WATER4);

	// FIRE 1 -> FIRE 2
	sReagentList = MakeRepeatedItemList(FIRE1, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(WEAK_COALESCENCE_SKILL, sReagentList, FIRE2);

	// FIRE 2 -> FIRE 3
	sReagentList = MakeRepeatedItemList(FIRE2, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(GLOWING_COALESCENCE_SKILL, sReagentList, FIRE3);

	// FIRE 3 -> FIRE 4
	sReagentList = MakeRepeatedItemList(FIRE3, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(RADIANT_COALESCENCE_SKILL, sReagentList, FIRE4);

	// EARTH 1 -> EARTH 2
	sReagentList = MakeRepeatedItemList(EARTH1, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(WEAK_COALESCENCE_SKILL, sReagentList, EARTH2);

	// EARTH 2 -> EARTH 3
	sReagentList = MakeRepeatedItemList(EARTH2, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(GLOWING_COALESCENCE_SKILL, sReagentList, EARTH3);

	// EARTH 3 -> EARTH 4
	sReagentList = MakeRepeatedItemList(EARTH3, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(RADIANT_COALESCENCE_SKILL, sReagentList, EARTH4);

	// POWER 1 -> POWER 2
	sReagentList = MakeRepeatedItemList(POWER1, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(WEAK_COALESCENCE_SKILL, sReagentList, POWER2);

	// POWER 2 -> POWER 3
	sReagentList = MakeRepeatedItemList(POWER2, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(GLOWING_COALESCENCE_SKILL, sReagentList, POWER3);

	// POWER 3 -> POWER 4
	sReagentList = MakeRepeatedItemList(POWER3, NUM_ESSENCES_FOR_COALESCENCE);
	CreateAlchemyRecipe(RADIANT_COALESCENCE_SKILL, sReagentList, POWER4);
				
}


// =================================================================================
// Distillation recipes
// =================================================================================
void SetUpDistillationRecipes1()
{
	// Function Prototype:
	// void CreateDistillationRecipe(int iSkillLevel, string sReagent, string sOutputResRefList);

    string sOutputList;
    //string sRandomEssence;
    //string sRandomEssenceHigh;


	//Bladeling Spike
	CreateDistillationRecipe(4, BLADELING_SPIKE, POWER1);
	
	//Bat Tooth
	CreateDistillationRecipe(4, BAT_TOOTH, AIR1);
	
	//Bear Claw
	CreateDistillationRecipe(6, BEAR_CLAW, EARTH2);
	
	//Dire Bear Claw
	CreateDistillationRecipe(8, DIRE_BEAR_CLAW, EARTH3);
	
	//Beetle Gland
	CreateDistillationRecipe(6, BEETLE_GLAND, EARTH2);
	
	//Fire Beetle Belly
	CreateDistillationRecipe(6, FIRE_BEETLE_BELLY, FIRE2);
	
	//Stag Beetle Horn
	CreateDistillationRecipe(4, STAG_BEETLE_HORN, EARTH1);
	
	//Dire Boar Tusk
	CreateDistillationRecipe(4, DIRE_BOAR_TUSK, EARTH1);
	
	//Bugbear Tusk
	CreateDistillationRecipe(8, BUGBEAR_TUSK, WATER3);

	
	//Demon Blood
	sOutputList = MakeList(POWER3, FIRE1);
	CreateDistillationRecipe(8, DEMON_BLOOD, sOutputList);
	
	//Devil Blood
	sOutputList = MakeList(POWER3, FIRE1);
	CreateDistillationRecipe(8, DEVIL_BLOOD, sOutputList);
	
	//Dragon Blood
	CreateDistillationRecipe(10, DRAGON_BLOOD, POWER4);

	//Gargoyle Horn
	CreateDistillationRecipe(6, GARGOYLE_HORN, EARTH2);
	
	//Ghoul Claws
	sOutputList = MakeList(AIR2, POWER1);
	CreateDistillationRecipe(6, GHOUL_CLAWS, sOutputList);
	
	//Ghast Claws
	sOutputList = MakeList(AIR3, POWER2);
	CreateDistillationRecipe(8, GHAST_CLAWS, sOutputList);
	
	//Ghost Residue
	CreateDistillationRecipe(8, GHOST_RESIDUE, AIR3);
	

}

// =================================================================================
// Distillation recipes
// =================================================================================
void SetUpDistillationRecipes2()
{
	// Function Prototype:
	// void CreateDistillationRecipe(int iSkillLevel, string sReagent, string sOutputResRefList);

    string sOutputList;
    //string sRandomEssence;
    //string sRandomEssenceHigh;

	//Fire Giant Head
	CreateDistillationRecipe(10, FIRE_GIANT_HEAD, FIRE4);
	
	//Frost Giant Head
	CreateDistillationRecipe(10, FROST_GIANT_HEAD, WATER4);
	
	//Iron Golem Fragments
	CreateDistillationRecipe(10, IRON_GOLEM_FRAGMENTS, EARTH4);
	
	//Hellhound Tooth
	CreateDistillationRecipe(8, HELLHOUND_TOOTH, FIRE3);
	
	//Imp Tail
	CreateDistillationRecipe(4, IMP_TAIL, FIRE1);
	
	//Lich Dust
	sOutputList = MakeList(POWER4, AIR4);
	CreateDistillationRecipe(10, LICH_DUST, sOutputList);
	
	//Fire Mephit Hide
	CreateDistillationRecipe(6, FIRE_MEPHIT_HIDE, FIRE2);
	
	//Ice Mephit Hide
	CreateDistillationRecipe(6, ICE_MEPHIT_HIDE, WATER2);

	




		
	//Ogre Mage Skull
	CreateDistillationRecipe(8, OGRE_MAGE_SKULL, POWER3);
	
	//Shadow Residue
	CreateDistillationRecipe(8, SHADOW_RESIDUE, AIR4);
	
	
	//Skeleton Knuckle
	CreateDistillationRecipe(4, SKELETON_KNUCKLE, EARTH1);
	
	//Spider Venom Gland
	CreateDistillationRecipe(6, SPIDER_VENOM_GLAND, WATER2);
	
	//Phase Spider Mandible
	sOutputList = MakeList(POWER3, WATER3);
	CreateDistillationRecipe(8, PHASE_SPIDER_MANDIBLE, sOutputList);
	
	//Blade Spider Leg
	CreateDistillationRecipe(8, SWORD_SPIDER_LEG, EARTH3);
	
	//Troll Blood
	sOutputList = MakeList(POWER2, WATER2);
	CreateDistillationRecipe(6, TROLL_BLOOD, sOutputList);
	
	//Umber Hulk Mandible
	sOutputList = MakeList(POWER1, WATER2);
	CreateDistillationRecipe(6, UMBER_HULK_MANDIBLE, sOutputList);
	


	//Vampire Tooth
	sOutputList = MakeList(POWER3, FIRE3);
	CreateDistillationRecipe(8, VAMPIRE_TOOTH, sOutputList);
	
	//Dire Wolf Tooth
	CreateDistillationRecipe(4, DIRE_WOLF_TOOTH, WATER1);
	
	//Winter Wolf Pelt
	CreateDistillationRecipe(8, WINTER_WOLF_PELT, WATER3);
	
	//Wraith Residue
	sOutputList = MakeList(POWER2, AIR2);
	CreateDistillationRecipe(6, WRAITH_RESIDUE, sOutputList);
	
	//Wyvern Scale
	CreateDistillationRecipe(6, WYVERN_SCALE, AIR2);

	//Crystal Heart
	sOutputList = MakeList(POWER4, AIR4, WATER4);
	CreateDistillationRecipe(10, CRYSTAL_HEART, sOutputList);
}

// =================================================================================
// Distillation recipes
// =================================================================================
void SetUpDistillationRecipes3()
{
	// Function Prototype:
	// void CreateDistillationRecipe(int iSkillLevel, string sReagent, string sOutputResRefList);

    string sOutputList;
    //string sRandomEssence;
    //string sRandomEssenceHigh;

	//Faint Air Essence
	CreateDistillationRecipe(4, AIR2, AIR1);

	//Weak Air Essence
	CreateDistillationRecipe(6, AIR3, AIR2);

	//Glowing Air Essence
	CreateDistillationRecipe(8, AIR4, AIR3);

	//Faint Earth Essence
	CreateDistillationRecipe(4, EARTH2, EARTH1);

	//Weak Earth Essence
	CreateDistillationRecipe(6, EARTH3, EARTH2);

	//Glowing Earth Essence
	CreateDistillationRecipe(8, EARTH4, EARTH3);

	//Faint Fire Essence
	CreateDistillationRecipe(4, FIRE2, FIRE1);

	//Weak Fire Essence
	CreateDistillationRecipe(6, FIRE3, FIRE2);

	//Glowing Fire Essence
	CreateDistillationRecipe(8, FIRE4, FIRE3);

	//Faint Water Essence
	CreateDistillationRecipe(4, WATER2, WATER1);

	//Weak Water Essence
	CreateDistillationRecipe(6, WATER3, WATER2);

	//Glowing Water Essence
	CreateDistillationRecipe(8, WATER4, WATER3);

	//Faint Power Essence
	CreateDistillationRecipe(4, POWER2, POWER1);

	//Weak Power Essence
	CreateDistillationRecipe(6, POWER3, POWER2);

	//Glowing Power Essence
	CreateDistillationRecipe(8, POWER4, POWER3);
}


const string MOLD_TRAP_KIT    			= "n2_crft_mold_trap";

const string TRAP_FIRE_COMPONENT 		= "X1_WMGRENADE002";    // alchemists fire
const string TRAP_ELECTRICAL_COMPONENT 	= "NW_IT_MSMLMISC11";	// quartz crystal
const string TRAP_TANGLE_COMPONENT 		= "X1_WMGRENADE006";    // tanglefoot bag
const string TRAP_SPIKE_COMPONENT 		= "NW_WSWDG001";    // dagger
const string TRAP_HOLY_COMPONENT		= "X1_WMGRENADE005";    // holy water
const string TRAP_GAS_COMPONENT 		= "X1_WMGRENADE004";    // choking powder
const string TRAP_FROST_COMPONENT 		= "X1_IT_MSMLMISC01";   // coldstone
const string TRAP_NEGATIVE_COMPONENT 	= "cft_gem_03";  	// Obsidian
const string TRAP_SONIC_COMPONENT 		= "X1_WMGRENADE007";    // thunderstone
const string TRAP_ACID_COMPONENT 		= "X1_WMGRENADE001";    // acid flask
const string TRAP_ACID_BLOB_COMPONENT           = "X1_WMGRENADE001, X1_WMGRENADE006"; //ACID FLASK AND TANGLEFOOT BAG

// the number of components required for each trap type
const int TRAP_COMPONENT_COUNT_MINOR 	= 1;
const int TRAP_COMPONENT_COUNT_AVERAGE 	= 3;
const int TRAP_COMPONENT_COUNT_STRONG 	= 5;
const int TRAP_COMPONENT_COUNT_DEADLY	= 7;

const string SPIKE_TRAP_KIT_MINOR 			= "nw_it_trap001";
const string SPIKE_TRAP_KIT_AVERAGE 		= "nw_it_trap002";
const string SPIKE_TRAP_KIT_STRONG 			= "nw_it_trap003";
const string SPIKE_TRAP_KIT_DEADLY 			= "nw_it_trap004";

const string HOLY_TRAP_KIT_MINOR 			= "nw_it_trap005";
const string HOLY_TRAP_KIT_AVERAGE 			= "nw_it_trap006";
const string HOLY_TRAP_KIT_STRONG 			= "nw_it_trap007";
const string HOLY_TRAP_KIT_DEADLY 			= "nw_it_trap008";

const string TANGLE_TRAP_KIT_MINOR 			= "nw_it_trap009";
const string TANGLE_TRAP_KIT_AVERAGE 		= "nw_it_trap010";
const string TANGLE_TRAP_KIT_STRONG 		= "nw_it_trap011";
const string TANGLE_TRAP_KIT_DEADLY 		= "nw_it_trap012";

const string ACID_BLOB_TRAP_KIT_MINOR 		= "nw_it_trap013";
const string ACID_BLOB_TRAP_KIT_AVERAGE 	= "nw_it_trap014";
const string ACID_BLOB_TRAP_KIT_STRONG 		= "nw_it_trap015";
const string ACID_BLOB_TRAP_KIT_DEADLY 		= "nw_it_trap016";

const string FIRE_TRAP_KIT_MINOR 			= "nw_it_trap017";
const string FIRE_TRAP_KIT_AVERAGE 			= "nw_it_trap018";
const string FIRE_TRAP_KIT_STRONG 			= "nw_it_trap019";
const string FIRE_TRAP_KIT_DEADLY 			= "nw_it_trap020";

const string ELECTRICAL_TRAP_KIT_MINOR 		= "nw_it_trap021";
const string ELECTRICAL_TRAP_KIT_AVERAGE 	= "nw_it_trap022";
const string ELECTRICAL_TRAP_KIT_STRONG 	= "nw_it_trap023";
const string ELECTRICAL_TRAP_KIT_DEADLY 	= "nw_it_trap024";

const string GAS_TRAP_KIT_MINOR 			= "nw_it_trap025";
const string GAS_TRAP_KIT_AVERAGE 			= "nw_it_trap026";
const string GAS_TRAP_KIT_STRONG 			= "nw_it_trap027";
const string GAS_TRAP_KIT_DEADLY 			= "nw_it_trap028";

const string FROST_TRAP_KIT_MINOR 			= "nw_it_trap029";
const string FROST_TRAP_KIT_AVERAGE 		= "nw_it_trap030";
const string FROST_TRAP_KIT_STRONG 			= "nw_it_trap031";
const string FROST_TRAP_KIT_DEADLY 			= "nw_it_trap032";

const string ACID_SPLASH_TRAP_KIT_MINOR 	= "nw_it_trap033";
const string ACID_SPLASH_TRAP_KIT_AVERAGE 	= "nw_it_trap034";
const string ACID_SPLASH_TRAP_KIT_STRONG 	= "nw_it_trap035";
const string ACID_SPLASH_TRAP_KIT_DEADLY 	= "nw_it_trap036";

const string SONIC_TRAP_KIT_MINOR 			= "nw_it_trap037";
const string SONIC_TRAP_KIT_AVERAGE 		= "nw_it_trap038";
const string SONIC_TRAP_KIT_STRONG 			= "nw_it_trap039";
const string SONIC_TRAP_KIT_DEADLY 			= "nw_it_trap040";

const string NEGATIVE_TRAP_KIT_MINOR 		= "nw_it_trap041";
const string NEGATIVE_TRAP_KIT_AVERAGE 		= "nw_it_trap042";
const string NEGATIVE_TRAP_KIT_STRONG 		= "nw_it_trap043";
const string NEGATIVE_TRAP_KIT_DEADLY 		= "nw_it_trap044";


void SetUpTraps1()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Spike Traps
	sReagentList = MakeRepeatedItemList (TRAP_SPIKE_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, SPIKE_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_SPIKE_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, SPIKE_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_SPIKE_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, SPIKE_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_SPIKE_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, SPIKE_TRAP_KIT_DEADLY);


	// Holy  Traps
	sReagentList = MakeRepeatedItemList (TRAP_HOLY_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, HOLY_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_HOLY_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, HOLY_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_HOLY_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, HOLY_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_HOLY_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, HOLY_TRAP_KIT_DEADLY);


	// Tangle Traps
	sReagentList = MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, TANGLE_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, TANGLE_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, TANGLE_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, TANGLE_TRAP_KIT_DEADLY);
}
void SetUpTraps2()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

//  Acid Blob Traps
	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	sReagentList += FormListElement(MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_MINOR)); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, ACID_BLOB_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE);
	sReagentList += FormListElement(MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE)); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, ACID_BLOB_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	sReagentList += FormListElement(MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_STRONG));
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, ACID_BLOB_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	sReagentList += FormListElement(MakeRepeatedItemList (TRAP_TANGLE_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY));
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, ACID_BLOB_TRAP_KIT_DEADLY);


	// Fire Traps
	sReagentList = MakeRepeatedItemList (TRAP_FIRE_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, FIRE_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_FIRE_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, FIRE_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_FIRE_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, FIRE_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_FIRE_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, FIRE_TRAP_KIT_DEADLY);


	// Electrical Traps
	sReagentList = MakeRepeatedItemList (TRAP_ELECTRICAL_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, ELECTRICAL_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_ELECTRICAL_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, ELECTRICAL_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_ELECTRICAL_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, ELECTRICAL_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_ELECTRICAL_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, ELECTRICAL_TRAP_KIT_DEADLY);
}

void SetUpTraps3()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Gas Traps
	sReagentList = MakeRepeatedItemList (TRAP_GAS_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, GAS_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_GAS_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, GAS_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_GAS_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, GAS_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_GAS_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, GAS_TRAP_KIT_DEADLY);


	// Frost Traps
	sReagentList = MakeRepeatedItemList (TRAP_FROST_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, FROST_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_FROST_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, FROST_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_FROST_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, FROST_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_FROST_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, FROST_TRAP_KIT_DEADLY);


	// Acid Splash Traps
	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, ACID_SPLASH_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, ACID_SPLASH_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, ACID_SPLASH_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_ACID_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, ACID_SPLASH_TRAP_KIT_DEADLY);
}
void SetUpTraps4()
{
	// Function Prototype:
	// void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);

    string sReagentList;

	// Sonic Traps
	sReagentList = MakeRepeatedItemList (TRAP_SONIC_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, SONIC_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_SONIC_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, SONIC_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_SONIC_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, SONIC_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_SONIC_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, SONIC_TRAP_KIT_DEADLY);

	// Negative Traps
	sReagentList = MakeRepeatedItemList (TRAP_NEGATIVE_COMPONENT, TRAP_COMPONENT_COUNT_MINOR); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 5, sReagentList, NEGATIVE_TRAP_KIT_MINOR);

	sReagentList = MakeRepeatedItemList (TRAP_NEGATIVE_COMPONENT, TRAP_COMPONENT_COUNT_AVERAGE); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 10, sReagentList, NEGATIVE_TRAP_KIT_AVERAGE);

	sReagentList = MakeRepeatedItemList (TRAP_NEGATIVE_COMPONENT, TRAP_COMPONENT_COUNT_STRONG); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 15, sReagentList, NEGATIVE_TRAP_KIT_STRONG);

	sReagentList = MakeRepeatedItemList (TRAP_NEGATIVE_COMPONENT, TRAP_COMPONENT_COUNT_DEADLY); 
	CreateMundaneRecipe(MOLD_TRAP_KIT, SKILL_CRAFT_TRAP, 20, sReagentList, NEGATIVE_TRAP_KIT_DEADLY);

}
	

// =================================================================================
// main
// =================================================================================
void main()
{
//    object oPC = GetLastUsedBy();
//	if (oPC == OBJECT_INVALID)
//		oPC = GetEnteringObject();

    // only set up recipies once
    if (GetGlobalInt(VAR_REC_SET) == TRUE)
    {
        output("Recipies already set!");
        return;
    }



// These functions set up all the recipes into global memory
	int iSetupCount = ModifyGlobalInt("SETUP_COUNT", 1);
	int bDone = FALSE;
    output("Setting up Recipe set " + IntToString(iSetupCount) + "...");
	switch (iSetupCount)
	{
		case 1: // armor 1
    		SetUpMagicalRecipes1();
			break;

		case 2: // armor 2
    		SetUpMagicalRecipes2();
			break;

		case 3: // weapon 1
    		SetUpMagicalRecipes3();
			break;

		case 4: // weapon 2
    		SetUpMagicalRecipes4();
			break;

		case 5:	// Wondrous 1 of 3
			SetUpWondrousRecipes1();
			break;

		case 6:	// Wondrous 2 of 3
			SetUpWondrousRecipes2();
			break;

		case 7:	// Wondrous 3 of 3
			SetUpWondrousRecipes3();
			break;

		case 8: // Mundane Recipes 1 of 11
			SetUpMundaneRecipes1();
			break;

		case 9: // Mundane Recipes 2 of 11
			SetUpMundaneRecipes2();
			break;

		case 10: // Mundane Recipes 3 of 11
			SetUpMundaneRecipes3();
			break;

		case 11: // Mundane Recipes 4 of 11
			SetUpMundaneRecipes4();
			break;

		case 12: // Mundane Recipes 5 of 11
			SetUpMundaneRecipes5();
			break;

		case 13: // Mundane Recipes 6 of 11
			SetUpMundaneRecipes6();
			break;

		case 14: // Mundane Recipes 7 of 11
			SetUpMundaneRecipes7();
			break;

		case 15: // Mundane Recipes 8 of 11
			SetUpMundaneRecipes8();
			break;

		case 16: // Mundane Recipes 9 of 11
			SetUpMundaneRecipes9();
			break;

		case 17: // Mundane Recipes 9 of 11
			SetUpMundaneRecipes9a();
			break;

		case 18: // Mundane Recipes 10 of 11
			SetUpMundaneRecipes10();
			break;

		case 19: // Mundane Recipes 10 of 11
			SetUpMundaneRecipes10a();
			break;

		case 20: // Mundane Recipes 11 of 11
			SetUpMundaneRecipes11();
			break;

		case 21: // Alchemy 1
			SetUpAlchemyRecipes1();
			break;
	
	    case 22: // Alchemy 2
	        SetUpAlchemyRecipes2();
	        break;
	
		case 23: // Alchemy 3
			SetUpAlchemyRecipes3();
			break;
	
		case 24: // Alchemy 4
			SetUpAlchemyRecipes4();
			break;

		case 25: // Distillation 1
			SetUpDistillationRecipes1();
			break;

		case 26: // Distillation 2
			SetUpDistillationRecipes2();
			break;

		case 27: // Distillation 3
			SetUpDistillationRecipes3();
			break;

		case 28: // Trap 1
			SetUpTraps1();
			break;
	
		case 29: // Trap 2
			SetUpTraps2();
			break;
	
		case 30: // Trap 3
			SetUpTraps3();
			break;

		case 31: // Trap 4
			SetUpTraps4();
			break;

		case 32: // Alchemy 5 (Poison)
			SetUpAlchemyRecipes5();
			break;

		case 33: //Wondrous 3a
			SetUpWondrousRecipes3a();
			break;

		case 34: //Wondrous 3b
			SetUpWondrousRecipes3b();
			break;

		case 35: // Coalescing Essence Alchemy Recipes
			SetUpAlchemyRecipes6();
			break;

		case 36: // the flails
		 	SetUpStandardMetalItem(MOLD_WPN_FLAIL, 1, 2, WPN_FLAIL_ADA, WPN_FLAIL_CLD, WPN_FLAIL_DRK, WPN_FLAIL_IRN, WPN_FLAIL_MTH, WPN_FLAIL_SLV);
						
		default:
    		SetGlobalInt(VAR_REC_SET, TRUE);
			bDone = TRUE;
			output("Recipes now loaded in Global Memory.  Crafting now based on Global Memory set up for this session.");
			output("Recipe data can be exported to 2da format in the log by stepping into designated area.");
	}
	output("Script completed.");

	if (!bDone)
	{
		DelayCommand(0.2f, ExecuteScript("ga_setrecipes", OBJECT_SELF));
	}
}