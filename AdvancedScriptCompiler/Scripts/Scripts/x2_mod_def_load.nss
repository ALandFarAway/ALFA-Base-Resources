//::///////////////////////////////////////////////
//:: Example XP2 OnLoad Script
//:: x2_mod_def_load
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnModuleLoad Event

    This example script demonstrates how to tweak the
    behavior of several subsystems in your module.

    For more information, please check x2_inc_switches
    which holds definitions for several variables that
    can be set on modules, creatures, doors or waypoints
    to change the default behavior of Bioware scripts.

    Warning:
    Using some of these switches may change your games
    balancing and may introduce bugs or instabilities. We
    recommend that you only use these switches if you
    know what you are doing. Consider these features
    unsupported!

    Please do NOT report any bugs you experience while
    these switches have been changed from their default
    positions.

    Make sure you visit the forums at nwn.bioware.com
    to find out more about these scripts.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
// ChazM 9/10/06 Item scripts defaulted to seperate item scripts that start w/ "i_".  This is needed for crafting to work.
//    			Also added new flags (commented out).
// 9/18/06 ChazM - added switch MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE + other comments
// BMA-OEI 11/14/06 -- CAMPAIGN_SWITCH_USE_PERSONAL_REPUTATION: Defaulted TRUE to enable spell targetting neutral PC associates (nw_i0_spells)

#include "x2_inc_switches"
#include "x2_inc_restsys"
void main()
{
   if (GetGameDifficulty() ==  GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty() ==  GAME_DIFFICULTY_DIFFICULT)
   {
        // * Setting the switch below will enable a seperate Use Magic Device Skillcheck for
        // * rogues when playing on Hardcore+ difficulty. This only applies to scrolls
        SetModuleSwitch (MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);

		// ChazM: this doesn't appear to be used anywhere...
       // * Activating the switch below will make AOE spells hurt neutral NPCS by default
       // SetModuleSwitch (MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, TRUE);
	   
	   // ChazM: controls whether NPC can hurt each other with AOE's.
       //SetModuleSwitch (MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES, TRUE);
	   
	   // ChazM: controls whether a PC party can hurt each other with AOE's.
       SetModuleSwitch (MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE, TRUE);
   }

   // * AI: Activating the switch below will make the creaures using the WalkWaypoint function
   // * able to walk across areas
   // SetModuleSwitch (MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);

   // * Spells: Activating the switch below will make the Glyph of Warding spell behave differently:
   // * The visual glyph will disappear after 6 seconds, making them impossible to spot
   // SetModuleSwitch (MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);

   // * Craft Feats: Want 50 charges on a newly created wand? We found this unbalancing,
   // * but since it is described this way in the book, here is the switch to get it back...
   // SetModuleSwitch (MODULE_SWITCH_ENABLE_CRAFT_WAND_50_CHARGES, TRUE);

   // * Craft Feats: Use this to disable Item Creation Feats if you do not want
   // * them in your module
   // SetModuleSwitch (MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS, TRUE);

   // * Palemaster: Deathless master touch in PnP only affects creatures up to a certain size.
   // * We do not support this check for balancing reasons, but you can still activate it...
   // SetModuleSwitch (MODULE_SWITCH_SPELL_CORERULES_DMASTERTOUCH, TRUE);

   // * Epic Spellcasting: Some Epic spells feed on the liveforce of the caster. However this
   // * did not fit into NWNs spell system and was confusing, so we took it out...
   // SetModuleSwitch (MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER, TRUE);

   // * Epic Spellcasting: Some Epic spells feed on the liveforce of the caster. However this
   // * did not fit into NWNs spell system and was confusing, so we took it out...
   // SetModuleSwitch (MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT, TRUE);

    // * Spellcasting: Some people don't like caster's abusing combat expertise to raise their AC
    // * Uncommenting this line will drop expertise mode whenever a spell is cast by a player
    // SetModuleSwitch (MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);


    // * Item Event Scripts: The game's default event scripts allow routing of all item related events
    // * into a single file, based on the tag of that item. If an item's tag is "test", it will fire a
    // * script called "test" when an item based event (equip, unequip, acquire, unacquire, activate,...)
    // * is triggered. Check "x2_it_example.nss" for an example.
    // * This feature is disabled by default.
   SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
	// Enabling this causes tagbased scripting to use 7 different scripts for item events instead of 
	// having them packaged all in one.  
	// The scripts are postfixed with "_aq", "_ua", "_eq", "_ue", "_ac", "_ci", and "hc"
   SetModuleSwitch (MODULE_SWITCH_ENABLE_SEPERATE_ITEM_SCRIPTS, TRUE);

   if (GetModuleSwitchValue (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
   {
        // * If Tagbased scripts are enabled, and you are running a Local Vault Server
        // * you should use the line below to add a layer of security to your server, preventing
        // * people to execute script you don't want them to. If you use the feature below,
        // * all called item scrips will be the prefix + the Tag of the item you want to execute, up to a
        // * maximum of 16 chars, instead of the pure tag of the object.
        // * i.e. without the line below a user activating an item with the tag "test",
        // * will result in the execution of a script called "test". If you uncomment the line below
        // * the script called will be "1_test.nss"
        SetUserDefinedItemEventPrefix("i_");

   }


   // * This initializes Bioware's wandering monster system as used in Hordes of the Underdark
   // * You can deactivate it, making your module load faster if you do not use it.
   // * If you want to use it, make sure you set "x2_mod_def_rest" as your module's OnRest Script
   // SetModuleSwitch (MODULE_SWITCH_USE_XP2_RESTSYSTEM, TRUE);

   if (GetModuleSwitchValue(MODULE_SWITCH_USE_XP2_RESTSYSTEM) == TRUE)
   {

       // * This allows you to specify a different 2da for the wandering monster system.
       // SetWanderingMonster2DAFile("des_restsystem");

       //* Do not change this line.
       WMBuild2DACache();
   }
   
	// Only setup once for entire campaign
	if ( GetGlobalInt("CAMPAIGN_SETUP_FLAG") == FALSE )
	{
		SetGlobalInt( "CAMPAIGN_SETUP_FLAG", TRUE );
	
		//This variable makes all transitions a "gather your party" transition.
		// SetGlobalInt( VAR_GLOBAL_GATHER_PARTY, 1 );
		
		// Force kills dominated group members if no valid members remain - checked on HeartBeat ( nw_g0_dominate )
		//SetGlobalInt( CAMPAIGN_SWITCH_FORCE_KILL_DOMINATED_GROUP, TRUE );
		
		// Removes effect and prevents transition if object is dominated - checked in ginc_transition / nw_g0_transition
		//SetGlobalInt( CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION, TRUE );		
		
		// A flag that reflects the engine setting for whether or not we use personal reputation; this is a consideration in spell targeting
		// BMA-OEI 11/14/2006: Defaulted TRUE to enable spell targetting neutral PC associates (nw_i0_spells)
		SetGlobalInt( CAMPAIGN_SWITCH_USE_PERSONAL_REPUTATION, TRUE );
	}

}