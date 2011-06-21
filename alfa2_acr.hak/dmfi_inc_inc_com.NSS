////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_inc_com - DM Friendly Initiative - Include file for functions in dmfi_inc_command
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           10/9/6  Qk: 10/07/07
//					AcadiusLost				11/13/07 - commented out 821
//											1/7/2008 - added custom skills 765
//  										4/12/2008 - fixes for DMFI follow and death
//											8/8/2009 - skills finalized, enabled
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// PURPOSE:  Simply serves to break dmfi_inc_command into smaller pieces

#include "dmfi_inc_tool"
#include "dmfi_inc_const"

// ***************************** DECLARATIONS **********************************

// FILE: dmfi_inc_inc_com
// Returns the Best Roller from oTarget's Party for a particular skill or ability.
// sSkill 1 is skill, 2 is ability, 3 is save.  nConstant is the nwscript constant.
object DMFI_BestRoller(object oTarget, int bSkill, int nConstant);

// FILE: dmfi_inc_inc_com
// Creates effects with NO PARAMETERS - simplest form of effects only are
// applied via this function.
void DMFI_CreateEffect(string sCommand, string sParam1, object oPC, object oTarget);

// FILE: dmfi_inc_inc_com
// Creates a sound at a specified location.  sCommand is referenced in DMFI_INC_STRINGS
void DMFI_CreateSound(object oTool, object oPC, object oTarget, object oSpeaker, location lTargetLoc,  string sCommand, string sParam1);

// FILE: dmfi_inc_inc_com
//Purpose: Create a Visual effect according to preferences.  sText is the
//Label for the VFX and sParam is the row of the 2da file.
void DMFI_CreateVFX(object oTool, object oSpeaker, string sText, string sParam);

// Breaks sOriginal into sTool, sCommand, sParam1, sParam2 and sets these values
// on oPC.  Allows easy use by Command code and any command plugins.
void DMFI_DefineStructure(object oPC, string sOriginal);

// FILE: dmfi_inc_inc_com
// Returns a EMT form of a partial skill to allow for the end user DM to type
// only a portion of a skill as a shortcut.
string DMFI_FindPartialSkill(string sCommand);

// FILE: dmfi_inc_inc_com
// DMFI Follow Function: oPC will follow a target.  The target is stored on the
// DMFI Tool.  It will repeat until the target is not valid (.follow off command).
void DMFI_Follow(object oPC);

// FILE: dmfi_inc_inc_com
//Purpose: Returns Net Worth value for oTarget
int DMFI_GetNetWorth(object oTarget);

// FILE: dmfi_inc_inc_com
// Identifies all of oTargets inventory at the request of oDM.
void DMFI_IdentifyInventory(object oTarget, object oDM);

// FILE: dmfi_inc_inc_com
//Purpose: Stores the default local music as default music - only runs once.
void DMFI_InitializeAreaMusic(object oPC);

// FILE: dmfi_inc_inc_com
// DMFI Follow Function: oPC has directed an NPC to follow a target.  Both target's
// are stored on oPC's DMFI Tool.  It will repeat until the follower is no longer
// valid on the DMFI Tool (.npc follow off command).
void DMFI_NPCFollow(object oPC);

// FILE: dmfi_inc_inc_com
// Removes items more valuable than the max value listed for sLevel in the 2da
// max item value file.  Reports action to oPC.
void DMFI_RemoveUber(object oPC, object oTarget, string sLevel);

// FILE: dmfi_inc_inc_com
// Function to report information about all characters on the server to oPC
void DMFI_Report(object oPC, object oTool, string sCommand);

// FILE: dmfi_inc_inc_com
// Rolls dice for oTarget.  oPC can be a DM or Player.  Format: 2d4
void DMFI_RollBones(object oPC, object oTarget, string sCommand);

// Rolls checks for the DMFI
void DMFI_RollCheck(object oSpeaker, string sSkill, int bDMRequest=FALSE, object oDM=OBJECT_INVALID, object oTool=OBJECT_INVALID);

// FILE: dmfi_inc_inc_com
// Removes all inventory from oTarget.  Requested by oDM.  Server log is created
// to log this action.
void DMFI_StripInventory(object oTarget, object oDM);

// FILE: dmfi_inc_inc_com
// Returns a players storage unit for any DMFI taken items
object DMFI_Storage(object oPC, object oTarget);


// ****************************** FUNCTIONS ************************************
object DMFI_BestRoller(object oTarget, int bSkill, int nConstant)
{   //Purpose: Return the "best roller" for the skill from oTarget's Party
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 1/7/7
    object oRoller;
    int nMod;
    int nBestMod = -99;
    object oBestRoller;
	int nTest;
	
	if (!GetIsPC(oTarget))
		return oTarget;

    oRoller = GetFirstFactionMember(oTarget, FALSE);
    while (oRoller!=OBJECT_INVALID)
    {
       		if (bSkill==1)
	        { // get skill mod
	            nMod = GetSkillRank(nConstant, oRoller);
	            if (nMod>nBestMod)
	            {
	                nBestMod = nMod;
	                oBestRoller = oRoller;
	            }
	        } // get skill mod
	        else if (bSkill==2)
	        { // get ability mod
	            nMod = GetAbilityModifier(nConstant, oRoller);
	            if (nMod>nBestMod)
	            {
	                nBestMod = nMod;
	                oBestRoller = oRoller;
	            }
	        } // get ability mod
	        else if (bSkill==3)
	        {// get saving throw mod
	            if (nConstant==1)       nMod = GetFortitudeSavingThrow(oRoller);
	            else if (nConstant==2)  nMod = GetReflexSavingThrow(oRoller);
	            else if (nConstant==3)  nMod = GetWillSavingThrow(oRoller);
	        
				if (nMod>nBestMod)
		        {
		            nBestMod = nMod;
		            oBestRoller = oRoller;
		        }
			}// get saving throw mod
		        
        oRoller = GetNextFactionMember(oTarget, FALSE);
    }
    
    return oBestRoller;
}

void DMFI_CreateEffect(string sCommand, string sParam1, object oPC, object oTarget)
{  // PURPOSE: Creates simple effects with no parameters
   // Original scripter: Demetrious
   // Last Modified by:  Demetrious 8/16/6
    int bNumber;
    float fTime;
    effect eEffect;

    if (FindSubString(sCommand, EFF_BLINDNESS))  eEffect = EffectBlindness();
    else if (FindSubString(sCommand, EFF_CHARMED))  eEffect = EffectCharmed();
    else if (FindSubString(sCommand, EFF_CONFUSED))  eEffect = EffectConfused();
    else if (FindSubString(sCommand, EFF_CUTDOMINATED))  eEffect = EffectCutsceneDominated();
    else if (FindSubString(sCommand, EFF_CUTGHOST))  eEffect = EffectCutsceneGhost();
    else if (FindSubString(sCommand, EFF_CUTIMMOBILIZE))  eEffect = EffectCutsceneImmobilize();
    else if (FindSubString(sCommand, EFF_CUTPARALYZE))  eEffect = EffectCutsceneParalyze();
    else if (FindSubString(sCommand, EFF_DARKNESS))  eEffect = EffectDarkness();
    else if (FindSubString(sCommand, EFF_DAZED))  eEffect = EffectDazed();
    else if (FindSubString(sCommand, EFF_DEAF))  eEffect = EffectDeaf();
    //else if (FindSubString(sCommand, EFF_DISPELALL))  eEffect = EffectDispelMagicAll(); NWN2 edit
    //else if (FindSubString(sCommand, EFF_DISPELBEST))  eEffect = EffectDispelMagicBest(); NWN2 edit

    else if (FindSubString(sCommand, EFF_DOMINATED))  eEffect = EffectDominated();
    else if (FindSubString(sCommand, EFF_ENTANGLE))  eEffect = EffectEntangle();
    else if (FindSubString(sCommand, EFF_ETHEREAL))  eEffect = EffectEthereal();

    else if (FindSubString(sCommand, EFF_FRIGHTENED))  eEffect = EffectFrightened();
    else if (FindSubString(sCommand, EFF_HASTE))  eEffect = EffectHaste();
    else if (FindSubString(sCommand, EFF_KNOCKDOWN))  eEffect = EffectKnockdown();
    else if (FindSubString(sCommand, EFF_PARALYZE))  eEffect = EffectParalyze();
    else if (FindSubString(sCommand, EFF_PETRIFY))  eEffect = EffectPetrify();
    else if (FindSubString(sCommand, EFF_RESURRECTION))  eEffect = EffectResurrection();
    else if (FindSubString(sCommand, EFF_SEEINVIS))  eEffect = EffectSeeInvisible();
    else if (FindSubString(sCommand, EFF_SILENCE))  eEffect = EffectSilence();
    else if (FindSubString(sCommand, EFF_SLEEP))  eEffect = EffectSleep();
    else if (FindSubString(sCommand, EFF_SLOW))  eEffect = EffectSlow();
    else if (FindSubString(sCommand, EFF_STUNNED))  eEffect = EffectStunned();
    else if (FindSubString(sCommand, EFF_TIMESTOP))  eEffect = EffectTimeStop();
    else if (FindSubString(sCommand, EFF_TRUESEEING))  eEffect = EffectTrueSeeing();
    else if (FindSubString(sCommand, EFF_TURNED))  eEffect = EffectTurned();
    else if (FindSubString(sCommand, EFF_ULTRAVISION))  eEffect = EffectUltravision();

    if (GetIsEffectValid(eEffect))
    {
        bNumber = DMFI_IsNumber(sParam1);
        if (bNumber)
            fTime = StringToFloat(sParam1);
        else
            fTime = 30.0;
		
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fTime);
        SendText(oPC, TXT_EFFECT_APPLIED + sCommand, TRUE, COLOR_GREEN);
    }
    SendText(oPC, TXT_EFFECT_ERROR, FALSE, COLOR_RED);
}

void DMFI_CreateSound(object oTool, object oPC, object oTarget, object oSpeaker, location lTargetLoc,  string sCommand, string sParam1)
{  // PURPOSE: Creates a localized sound effect
   // Original scripter: Demetrious
   // Last Modified by:  Demetrious 10/9/6
    string sSound;
    object oSound;
    int nDelay;

    sSound = DMFI_GetSoundString(StringToInt(sParam1), sCommand);
    //SendText(oPC, "DEBUG sSound: " + sSound);
	nDelay = StringToInt(GetLocalString(oTool, DMFI_SOUND_DELAY));
    
	//SendText(oPC, "DEBUG sLoc: " + sLoc);
    
    if (oTarget==OBJECT_INVALID)
		oSound = CreateObject(OBJECT_TYPE_PLACEABLE, DMFI_STORAGE_RESREF, GetLocation(oSpeaker));
    else
        oSound = CreateObject(OBJECT_TYPE_PLACEABLE, DMFI_STORAGE_RESREF, GetLocation(oTarget));

    // verify oSound is valid
    if (!GetIsObjectValid(oSound))
    {
       SendText(oPC, TXT_INVALID_OBJECT, FALSE, COLOR_RED);
       return;
    }
    
	if (GetStringLeft(sSound, 3)!="al_")
	{	
		DelayCommand(1.0 + IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));		
		DelayCommand(5.0, SetPlotFlag(oSound, FALSE));
		DelayCommand(6.0, DestroyObject(oSound));
	}	
	else
	{	// Looping sounds - we run for about 20 seconds - not perfect because times are not consistent.
		DelayCommand(1.0+IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));
	    DelayCommand(6.0+IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));
	    DelayCommand(11.0+IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));
	    DelayCommand(16.0 + IntToFloat(nDelay), DestroyObject(oSound));
		DelayCommand(20.0, SetPlotFlag(oSound, FALSE));
		DelayCommand(21.0, DestroyObject(oSound));
	}	
    SendText(oPC, TXT_SOUND_PLAYED + sSound, TRUE, COLOR_GREEN);
}

void DMFI_CreateVFX(object oTool, object oSpeaker, string sText, string sParam)
{  //Purpose: Create a Visual effect according to preferences.  sText is the
   //Label for the VFX and sParam is the row of the 2da file.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 1/8/7
    object oTarget;
    effect eVFX, eEffect;
	int nAppear;
    float fDur;
    object oEffect;
    string sDur;
    location lTargetLoc;
	
	sDur = GetLocalString(oTool, DMFI_VFX_DURATION);
	fDur = StringToFloat(sDur);
	
	if (fDur<5.0) fDur=5.0;
    
	oTarget = GetLocalObject(oTool, DMFI_TARGET);
	
	if (FindSubString(sText, "_FNF_")!=-1)
    {  //Simply apply these to a location
	    eVFX = EffectVisualEffect(StringToInt(sParam));
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oTarget));
		return;
	}

    if (FindSubString(sText, "_BEAM_")!=-1)
        eVFX = EffectBeam(StringToInt(sParam), oTarget, BODY_NODE_CHEST);
    else
        eVFX = EffectVisualEffect(StringToInt(sParam));
    
    if (FindSubString(sText, "_BEAM_")!=-1)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oSpeaker, fDur);
    else
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, fDur);
}

void DMFI_DefineStructure(object oPC, string sOriginal)
{ //Purpose: Defines sTool, sCommand, sParam1, sParam2 from sOriginal
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/3/6
  string sTool;
  string sRemains;
  string sCommand;
  string sParam1;
  string sParam2;

  sOriginal = GetStringLowerCase(sOriginal);

  sTool=DMFI_Parse(sOriginal," ");
  sRemains=DMFI_RemoveParsed(sOriginal, sTool, " ");
  sCommand=DMFI_Parse(sRemains, " ");
  sRemains=DMFI_RemoveParsed(sRemains, sCommand, " ");
  sParam1=DMFI_Parse(sRemains, " ");
  sParam2=DMFI_RemoveParsed(sRemains, sParam1, " ");

  SetLocalString(oPC, DMFI_sTool, sTool);
  SetLocalString(oPC, DMFI_sCommand, sCommand);
  SetLocalString(oPC, DMFI_sParam1, sParam1);
  SetLocalString(oPC, DMFI_sParam2, sParam2);
}

string DMFI_FindPartialSkill(string sCommand)
{   //Purpose: Returns full version of a shortcut skill, ability, save
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 6/27/6
        string sSkill;
        if      (FindSubString(sCommand, PRM_ABILITY_STRENGTH)!=-1)     { sSkill = EMT_ABL_STRENGTH; }
        else if (FindSubString(sCommand, PRM_ABILITY_DEXTERITY)!=-1)    { sSkill = EMT_ABL_DEXTERITY; }
        else if (FindSubString(sCommand, PRM_ABILITY_CONSTITUTION)!=-1) { sSkill = EMT_ABL_CONSTITUTION; }
        else if (FindSubString(sCommand, PRM_ABILITY_INTELLIGENCE)!=-1) { sSkill = EMT_ABL_INTELLIGENCE; }
        else if (FindSubString(sCommand, PRM_ABILITY_WISDOM)!=-1)       { sSkill = EMT_ABL_WISDOM; }
        else if (FindSubString(sCommand, PRM_ABILITY_CHARISMA)!=-1)     { sSkill = EMT_ABL_CHARISMA; }

        else if (FindSubString(sCommand, PRM_SAVE_FORTITUDE)!=-1)       { sSkill = EMT_SAVE_FORTITUDE; }
        else if (FindSubString(sCommand, PRM_SAVE_REFLEX)!=-1)          { sSkill = EMT_SAVE_REFLEX; }
        else if (FindSubString(sCommand, PRM_SAVE_WILL)!=-1)            { sSkill = EMT_SAVE_WILL; }

        //else if (FindSubString(sCommand, PRM_SKILL_ANIMAL_EMPATHY)!=-1) { sSkill = EMT_SKL_ANIMAL_EMPATHY; }
        else if (FindSubString(sCommand, PRM_SKILL_CONCENTRATION)!=-1)  { sSkill = EMT_SKL_CONCENTRATION; }
        else if (FindSubString(sCommand, PRM_SKILL_DISABLE_TRAP)!=-1)   { sSkill = EMT_SKL_DISABLE_TRAP; }
        //else if (FindSubString(sCommand, PRM_SKILL_DISCIPLINE)!=-1)     { sSkill = EMT_SKL_DISCIPLINE; }   // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_HEAL)!=-1)           { sSkill = EMT_SKL_HEAL; }
        else if (FindSubString(sCommand, PRM_SKILL_HIDE)!=-1)           { sSkill = EMT_SKL_HIDE; }
        else if (FindSubString(sCommand, PRM_SKILL_LISTEN)!=-1)         { sSkill = EMT_SKL_LISTEN; }
        //else if (FindSubString(sCommand, PRM_SKILL_LORE)!=-1)           { sSkill = EMT_SKL_LORE; }   // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_MOVE_SILENTLY)!=-1)  { sSkill = EMT_SKL_MOVE_SILENTLY; }
        else if (FindSubString(sCommand, PRM_SKILL_OPEN_LOCK)!=-1)      { sSkill = EMT_SKL_OPEN_LOCK; }   // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_PARRY)!=-1)          { sSkill = EMT_SKL_PARRY; }
        //else if (FindSubString(sCommand, PRM_SKILL_PERFORM)!=-1)        { sSkill = EMT_SKL_PERFORM; }
        //else if (FindSubString(sCommand, PRM_SKILL_PERSUADE)!=-1)       { sSkill = EMT_SKL_PERSUADE; }
        //else if (FindSubString(sCommand, PRM_SKILL_PICK_POCKET)!=-1)    { sSkill = EMT_SKL_PICK_POCKET; }
        else if (FindSubString(sCommand, PRM_SKILL_SEARCH)!=-1)         { sSkill = EMT_SKL_SEARCH; }
        //else if (FindSubString(sCommand, PRM_SKILL_SET_TRAP)!=-1)       { sSkill = EMT_SKL_SET_TRAP; }  // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_SPELLCRAFT)!=-1)     { sSkill = EMT_SKL_SPELLCRAFT; }
        else if (FindSubString(sCommand, PRM_SKILL_SPOT)!=-1)           { sSkill = EMT_SKL_SPOT; }
        //else if (FindSubString(sCommand, PRM_SKILL_TAUNT)!=-1)          { sSkill = EMT_SKL_TAUNT; }  // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_USE_MAGIC_DEVICE)!=-1) { sSkill = EMT_SKL_USE_MAGIC_DEVICE; }
        else if (FindSubString(sCommand, PRM_SKILL_APPRAISE)!=-1)       { sSkill = EMT_SKL_APPRAISE; }
        else if (FindSubString(sCommand, PRM_SKILL_TUMBLE)!=-1)         { sSkill = EMT_SKL_TUMBLE; }
        // else if (FindSubString(sCommand, PRM_SKILL_CRAFT_TRAP)!=-1)     { sSkill = EMT_SKL_CRAFT_TRAP; }  // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_BLUFF)!=-1)          { sSkill = EMT_SKL_BLUFF; }
        else if (FindSubString(sCommand, PRM_SKILL_INTIMIDATE)!=-1)     { sSkill = EMT_SKL_INTIMIDATE; }
        // else if (FindSubString(sCommand, PRM_SKILL_CRAFT_ARMOR)!=-1)    { sSkill = EMT_SKL_CRAFT_ARMOR; } // ALFA edit
        // else if (FindSubString(sCommand, PRM_SKILL_CRAFT_WEAPON)!=-1)   { sSkill = EMT_SKL_CRAFT_WEAPON; } // ALFA edit

        else if (FindSubString(sCommand, PRM_SKILL_DIPLOMACY)!=-1)      { sSkill = EMT_SKL_DIPLOMACY; }
        // else if (FindSubString(sCommand, PRM_SKILL_CRAFT_ALCHEMY)!=-1)  { sSkill = EMT_SKL_CRAFT_ALCHEMY; } // ALFA edit
        else if (FindSubString(sCommand, PRM_SKILL_SURVIVAL)!=-1)       { sSkill = EMT_SKL_SURVIVAL; }
        else if (FindSubString(sCommand, PRM_SKILL_SLEIGHT_OF_HAND)!=-1){ sSkill = EMT_SKL_SLEIGHT_OF_HAND; }
		// ALFA additions:

		else if (FindSubString(sCommand, PRM_SKILL_BALANCE) != -1)      { sSkill = EMT_SKL_BALANCE;}
		else if (FindSubString(sCommand, PRM_SKILL_CLIMB) != -1)        { sSkill = EMT_SKL_CLIMB;}
		else if (FindSubString(sCommand, PRM_SKILL_CRAFT__ALCHEMY) != -1)        { sSkill = EMT_SKL_CRAFT__ALCHEMY;}
		else if (FindSubString(sCommand, PRM_SKILL_CRAFT_ARMORSMITHING) != -1)   { sSkill = EMT_SKL_CRAFT_ARMORSMITHING;}
		else if (FindSubString(sCommand, PRM_SKILL_CRAFT_BOWMAKING) != -1)       { sSkill = EMT_SKL_CRAFT_BOWMAKING;}
		else if (FindSubString(sCommand, PRM_SKILL_CRAFT_WEAPONSMITHING) != -1)  { sSkill = EMT_SKL_CRAFT_WEAPONSMITHING;}
		else if (FindSubString(sCommand, PRM_SKILL_DECIPHER_SCRIPT) != -1)  { sSkill = EMT_SKL_DECIPHER_SCRIPT;}
		else if (FindSubString(sCommand, PRM_SKILL_DISGUISE) != -1)         { sSkill = EMT_SKL_DISGUISE;}
		else if (FindSubString(sCommand, PRM_SKILL_ESCAPE_ARTIST) != -1)    { sSkill = EMT_SKL_ESCAPE_ARTIST;}
		else if (FindSubString(sCommand, PRM_SKILL_FORGERY) != -1)          { sSkill = EMT_SKL_FORGERY;}
		else if (FindSubString(sCommand, PRM_SKILL_GATHER_INFORMATION) != -1)  { sSkill = EMT_SKL_GATHER_INFORMATION;}
		else if (FindSubString(sCommand, PRM_SKILL_HANDLE_ANIMAL) != -1)       { sSkill = EMT_SKL_HANDLE_ANIMAL;}
		else if (FindSubString(sCommand, PRM_SKILL_JUMP) != -1)        	       { sSkill = EMT_SKL_JUMP;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_ARCANA) != -1)    	     { sSkill = EMT_SKL_KNOWLEDGE_ARCANA;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_DUNGEONEERING) != -1)   { sSkill = EMT_SKL_KNOWLEDGE_DUNGEONEERING;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_GEOGRAPHY) != -1)       { sSkill = EMT_SKL_KNOWLEDGE_GEOGRAPHY;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_HISTORY) != -1)         { sSkill = EMT_SKL_KNOWLEDGE_HISTORY;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_NATURE) != -1)          { sSkill = EMT_SKL_KNOWLEDGE_NATURE;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_NOBILITY) != -1)          { sSkill = EMT_SKL_KNOWLEDGE_NOBILITY;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_RELIGION) != -1)        { sSkill = EMT_SKL_KNOWLEDGE_RELIGION;}
		else if (FindSubString(sCommand, PRM_SKILL_KNOWLEDGE_THEPLANES) != -1)       { sSkill = EMT_SKL_KNOWLEDGE_THEPLANES;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_ACT) != -1)        	     { sSkill = EMT_SKL_PERFORM_ACT;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_COMEDY) != -1)        	 { sSkill = EMT_SKL_PERFORM_COMEDY;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_DANCE) != -1)        	 { sSkill = EMT_SKL_PERFORM_DANCE;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_ORATORY) != -1)        	 { sSkill = EMT_SKL_PERFORM_ORATORY;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_KEYBOARDS) != -1)         { sSkill = EMT_SKL_PERFORM_KEYBOARDS;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_PERCUSSION) != -1)        { sSkill = EMT_SKL_PERFORM_PERCUSSION;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_STRINGINSTRUMENTS) != -1) { sSkill = EMT_SKL_PERFORM_STRINGINSTRUMENTS;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_WINDINSTRUMENTS) != -1)   { sSkill = EMT_SKL_PERFORM_WINDINSTRUMENTS;}
		else if (FindSubString(sCommand, PRM_SKILL_PERFORM_SING) != -1)        	     { sSkill = EMT_SKL_PERFORM_SING;}
		else if (FindSubString(sCommand, PRM_SKILL_PROFESSION) != -1)                { sSkill = EMT_SKL_PROFESSION;}
        else if (FindSubString(sCommand, PRM_SKILL_RIDE)!=-1)           			 { sSkill = EMT_SKL_RIDE; }	
		else if (FindSubString(sCommand, PRM_SKILL_SENSE_MOTIVE) != -1)              { sSkill = EMT_SKL_SENSE_MOTIVE;}
		else if (FindSubString(sCommand, PRM_SKILL_SPEAK_LANGUAGE) != -1)            { sSkill = EMT_SKL_SPEAK_LANGUAGE;}
		else if (FindSubString(sCommand, PRM_SKILL_SWIM) != -1)              	{ sSkill = EMT_SKL_SWIM;}
		else if (FindSubString(sCommand, PRM_SKILL_USE_ROPE) != -1)             { sSkill = EMT_SKL_USE_ROPE;}		

        else sSkill = "";
        return sSkill;
}

void DMFI_Follow(object oPC)
{  // PURPOSE: Forces oPC to follow oFollow
   // Original scripter: Demetrious
   // Last Modified by:  Demetrious 1/19/7
   // AcadiusLost - 4/12/2008, added handling for dead followee
    object oTool = DMFI_GetTool(oPC);
    object oFollow = GetLocalObject(oTool, DMFI_FOLLOW);

    if (oFollow!=OBJECT_INVALID)
    {
	    if (GetLocalInt(oFollow, "ACR_DTH_DEAD")) {
		    // the PC being followed is transitioning/transitioned to the morgue- cancel following
			return;
        } else if (GetArea(oPC)!=GetArea(oFollow)) {
            AssignCommand(oPC,ClearAllActions(TRUE));
            AssignCommand(oPC,JumpToObject(oFollow));
        }
        else if (GetDistanceBetween(oPC, oFollow)>12.0)
		{
			AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionForceMoveToObject(oFollow, TRUE, 1.5));
		}		
		else if (GetDistanceBetween(oPC, oFollow)>3.0)
        { // use Force Follow to smooth out camera
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionForceMoveToObject(oFollow, FALSE, 1.5));
        }
        DelayCommand(3.0, DMFI_Follow(oPC));
    }
}

int DMFI_GetNetWorth(object oTarget)
{   //Purpose: Returns Net Worth value for oTarget
    //Gold Value, XP, Net Worth.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 12/23/6
	// AL: ALFA edit to block negative additon, 7/10/2009
   int n, nSlot, i;
   object oItem = GetFirstItemInInventory(oTarget);

   while(GetIsObjectValid(oItem))
   {
   	  // ALFA edit: only add value if it is positive.
   	  i = GetGoldPieceValue(GetItemInSlot(nSlot, oTarget));
      if ( i > 0 ) {  n= n + i; }
      oItem = GetNextItemInInventory(oTarget);
   }
   for (nSlot=0; nSlot<18; nSlot++)
   {
   	  // ALFA edit: only add value if it is positive.
   	  i = GetGoldPieceValue(GetItemInSlot(nSlot, oTarget));
	  if ( i > 0 ) {  n= n + i; }
   }
   n = n + GetGold(oTarget);	 
		 
   return n;
}

void DMFI_IdentifyInventory(object oTarget, object oDM)
{ //Purpose: Identifies all of oTargets inventory at the request of oDM
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 7/3/6
    int n;
    object oTest;
    oTest = GetFirstItemInInventory(oTarget);
    while (oTest!=OBJECT_INVALID)
    { // identify inventory items
        if (!GetIdentified(oTest))
            SetIdentified(oTest, TRUE);
        oTest = GetNextItemInInventory(oTarget);
    }
     for (n=0; n<18; n++)
    { // identify any equiped items
        oTest = GetItemInSlot(n, oTarget);
        if (oTest!=OBJECT_INVALID)
        {
            if (!GetIdentified(oTest))
                SetIdentified(oTest, TRUE);
        }
    }

    SendText(oDM, TXT_INVENTORY_IDENTIFIED, TRUE, COLOR_GREEN);
    SendText(oTarget, TXT_PC_INVENTORY_IDENTIFIED, TRUE);
}

void DMFI_InitializeAreaMusic(object oPC)
{  //Purpose: Stores the default local music as default music - only runs once.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 6/6/6
    int nMusic;
    object oArea = GetArea(oPC);

    if (GetLocalInt(oArea, DMFI_MUSIC_INITIALIZED)!=1)
    {
        SetLocalInt(oArea, DMFI_MUSIC_INITIALIZED, 1);
        nMusic = MusicBackgroundGetBattleTrack(oArea);
        SetLocalInt(oArea, DMFI_MUSIC_BATTLE, nMusic);
        nMusic = MusicBackgroundGetDayTrack(oArea);
        SetLocalInt(oArea, DMFI_MUSIC_DAY, nMusic);
        nMusic = MusicBackgroundGetNightTrack(oArea);
        SetLocalInt(oArea, DMFI_MUSIC_NIGHT, nMusic);
    }
    return;
}

void DMFI_LanguageOff(object oPC)
{
	DeleteLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	CloseGUIScreen(oPC, SCREEN_DMFI_TEXT);
}

void DMFI_NPCFollow(object oPC)
{  // PURPOSE: Forces oNPCFollow to follow oNPCFollowTarget which is stored on
   // oPC's DMFI Tool.
   // Original scripter: Demetrious
   // Last Modified by:  Demetrious 8/13/6
    object oTool = DMFI_GetTool(oPC);

    object oNPCFollow = GetLocalObject(oTool, DMFI_FOLLOW_NPC);
    object oNPCFollowTarget = GetLocalObject(oTool, DMFI_FOLLOW_TARGET);

    if (oNPCFollow!=OBJECT_INVALID)
    {
        if (GetDistanceBetween(oNPCFollow, oNPCFollowTarget)>10.0)
        {
            AssignCommand(oNPCFollow, ClearAllActions(TRUE));
            AssignCommand(oNPCFollow, ActionForceFollowObject(oNPCFollowTarget));
        }
        else if (GetArea(oNPCFollow)!=GetArea(oNPCFollowTarget))
        {
            AssignCommand(oNPCFollow,ClearAllActions(TRUE));
            AssignCommand(oNPCFollow,JumpToObject(oNPCFollowTarget));
        }
        DelayCommand(3.0, DMFI_NPCFollow(oPC));
    }
}

void DMFI_RemoveUber(object oDM, object oTarget, string sLevel)
{ // Purpose: Removes items more valuable than the max value listed for sLevel
  // in the 2da max item value file.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/27/6
   	int n;
  	object oTest, oStorage;
    string sMax = Get2DAString(DMFI_2DA_ITEMVALUE, DMFI_2DA_COL_MAXVALUE, StringToInt(sLevel)-1);  // -1 is for 2da offset
	SendText(oDM, TXT_MAX_VALUE + sMax);
    
	oStorage = DMFI_Storage(oDM, oTarget);
    oTest = GetFirstItemInInventory(oTarget);
    AssignCommand(oTarget, ClearAllActions(TRUE));
    while (oTest!=OBJECT_INVALID)
    {
        if (GetGoldPieceValue(oTest)>(StringToInt(sMax)))
        {
            SetPlotFlag(oTest, FALSE);
            SetItemCursedFlag(oTest, FALSE);
            SetDroppableFlag(oTest, FALSE);
 			AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
        }
        oTest = GetNextItemInInventory(oTarget);
    }
	
	for (n=0; n<18; n++)
    {  // Equiped
        oTest = GetItemInSlot(n, oTarget);
        if (GetGoldPieceValue(oTest)>(StringToInt(sMax)))
		{
            SetPlotFlag(oTest, FALSE);
            SetItemCursedFlag(oTest, FALSE);
            SetDroppableFlag(oTest, FALSE);
			AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
			n++;
        }
    }	
    AssignCommand(oDM, ActionPickUpItem(oStorage));
	SendText(oDM, TXT_INVENTORY_UBER, TRUE, COLOR_GREEN);
    SendText(oTarget, TXT_PC_INVENTORY_UBER, TRUE);
    WriteTimestampedLogEntry(TXT_DM_ACTION + GetName(oDM) + " " + TXT_INVENTORY_UBER + GetName(oTarget));
}

void DMFI_RenameObject(object oPC, object oTarget)
{
	object oItemHolder;
	string sFirstName;
	string sLastName;	
	
	if ((!DMFI_PLAYER_NAME_CHANGING) && (GetIsPC(oTarget)))
	{
		SendText(oPC, TXT_NAME_CHANGING_DISABLED, TRUE, COLOR_RED);
		return;
	}	
		
	if (!DMFI_GetIsDM(oPC))		
    {  			
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{  
			if ((oTarget==oPC) || (GetMaster(oTarget)==oPC))
			{
				sFirstName = GetName(oTarget);
				sLastName ="";
				DisplayGuiScreen(oPC, SCREEN_DMFI_CHGNAME, FALSE, "dmfichgname.xml");
				SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtFirstName", -1, sFirstName);
				SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtLastName", -1, sLastName);
			}
			else
				SendText(oPC, TXT_RENAME_INVALID_TARGET, TRUE, COLOR_RED);
		}
		else if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)	
		{
			oItemHolder = GetItemPossessor(oTarget);
			if ((oItemHolder==oPC) || (GetMaster(oItemHolder)==oPC))
			{
				sFirstName = GetName(oTarget);
				DisplayGuiScreen(oPC, SCREEN_DMFI_CHGITEM, FALSE, "dmfichgitem.xml");
				SetGUIObjectText(oPC, SCREEN_DMFI_CHGITEM, "txtFirstName", -1, sFirstName);
			}
			else
				SendText(oPC, TXT_RENAME_INVALID_TARGET, TRUE, COLOR_RED);
		}
	}
	else
	{		
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{  
			sFirstName = GetName(oTarget);
			sLastName = "";
			DisplayGuiScreen(oPC, SCREEN_DMFI_CHGNAME, FALSE, "dmfichgname.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtFirstName", -1, sFirstName);
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGNAME, "txtLastName", -1, sLastName);
		}
		else if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)	
		{
			sFirstName = GetName(oTarget);
			DisplayGuiScreen(oPC, SCREEN_DMFI_CHGITEM, FALSE , "dmfichgitem.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGITEM, "txtFirstName", -1, sFirstName);
		}
		else if (GetObjectType(oTarget)==OBJECT_TYPE_PLACEABLE)
		{
			sFirstName = GetName(oTarget);
			DisplayGuiScreen(oPC, SCREEN_DMFI_CHGITEM, FALSE, "dmfichgitem.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_CHGITEM, "txtFirstName", -1, sFirstName);
		}	
	}		
}

void DMFI_Report(object oPC, object oTool, string sCommand)
{   //Purpose: Report information for all PCs on the server. sCommand can be
    //Gold Value, XP, Net Worth.
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 6/29/6
    string sMessage;
    object oTarget = GetFirstPC();
    
	SendText(oPC, TXT_REPORT);
	while (oTarget!=OBJECT_INVALID)
    {
        if (sCommand==PRM_GOLD)
            sMessage = TXT_REPORT_GOLD + IntToString(GetGold(oTarget));
        else if (sCommand==PRM_XP)
            sMessage = TXT_REPORT_XP + IntToString(GetXP(oTarget));
        else if (sCommand==PRM_NETWORTH)
            sMessage = TXT_REPORT_NETWORTH + IntToString(DMFI_GetNetWorth(oTarget));

        SendText(oPC, GetName(oTarget) + sMessage);
        oTarget = GetNextPC();
    }
}

void DMFI_RollBones(object oPC, object oTarget, string sCommand)
{   //Purpose: Rolls dice for oTarget: 2d4 = two dice with 4 sides
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 9/22/6
    int n, nLength, nTest, nNum, nDice;
    string sDice, sReport, sRoll;
    object oTool, oTest;
    nLength = GetStringLength(sCommand);
    nTest = FindSubString(sCommand, "d");

    nNum = StringToInt(GetStringLeft(sCommand, nTest));
    nDice = StringToInt(GetStringRight(sCommand, nLength -(nTest+1)));

    n = ((nDice==2) || (nDice==3) || (nDice==4) || (nDice==6) || (nDice==8) ||
        (nDice==10) || (nDice==12) || (nDice==20) || (nDice==100));

    if ( n && nTest!=-1)
    { // valid format
        if (DMFI_GetIsDM(oPC))
        {   // DM Code
            oTool = DMFI_GetTool(oPC);
            sReport = GetStringLowerCase(GetLocalString(oTool, DMFI_DICEBAG_REPORT));
            sRoll = GetStringLowerCase(GetLocalString(oTool, DMFI_DICEBAG_ROLL));

            if (sReport==PRM_PARTY)
                oTest = GetFirstFactionMember(oTarget, FALSE);
            else
                oTest = oTarget;
        }   // END DM Code
        else
            oTest = oPC;

        while (oTest!=OBJECT_INVALID)
        { // WHILE STATEMENT
            switch (nDice)
            {
                case 2: { n = d2(nNum); sDice = "d2" ; break;}
                case 3: { n = d3(nNum); sDice = "d3" ; break;}
                case 4: { n = d4(nNum); sDice = "d4" ; break;}
                case 6: { n = d6(nNum); sDice = "d6" ; break;}
                case 8: { n = d8(nNum); sDice = "d8" ; break;}
                case 10:{ n = d10(nNum);sDice = "d10" ;break;}
                case 12:{ n = d12(nNum);sDice = "d12" ;break;}
                case 20:{ n = d20(nNum);sDice = "d20" ;break;}
                case 100:{ n= d100(nNum);sDice = "d100" ;break;}
                default: n=0;
            }
            if (nNum==0) n=0; // special case override			
			if (DMFI_GetIsDM(oPC))
            {
                if (sReport==PRM_DM)
                    SendText(oPC, TXT_ROLLER + GetName(oTest) + PRM_ + TXT_ROLL_DICE + IntToString(nNum) + sDice + "= " + IntToString(n), TRUE, COLOR_CYAN);
                if (sReport==PRM_PARTY)
                {
                    SendTalkText(oTest, PRM_ + TXT_ROLL_DICE + IntToString(nNum) + sDice+" = " + IntToString(n), COLOR_CYAN);
                    SendText(oPC, TXT_ROLLER + GetName(oTest) + PRM_ + TXT_ROLL_DICE + IntToString(nNum) + sDice + "= " + IntToString(n), TRUE, COLOR_CYAN);
                }
                else
                {
                    SendText(oTest, PRM_ + TXT_ROLL_DICE + IntToString(nNum) + sDice+" = " + IntToString(n), TRUE, COLOR_CYAN);
                    SendText(oPC, TXT_ROLLER + GetName(oTest) + PRM_ + TXT_ROLL_DICE + IntToString(nNum) + sDice + "= " + IntToString(n), TRUE, COLOR_CYAN);
                }
            }
            else
            {
                SendTalkText(oTest, PRM_ + TXT_ROLL_DICE + IntToString(nNum) + sDice+" = " + IntToString(n), COLOR_CYAN);
            }
            if (sReport==PRM_PARTY)
                oTest = GetNextFactionMember(oTarget, TRUE);
            else
                oTest=OBJECT_INVALID;
        } // WHILE STATEMENT
    } // VALID FORMAT
    else
    { // NOT VALID FORMAT
        SendText(oPC, TXT_ROLL_DICE_FORMAT_ERROR, FALSE, COLOR_RED);
    } // NOT VALID FORMAT
}

void DMFI_RollCheck(object oSpeaker, string sSkill, int bDMRequest=FALSE, object oDM=OBJECT_INVALID, object oTool=OBJECT_INVALID)
{   //Purpose: Rolls a check for oSpeaker
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 9/22/6
    int nMod;
    int nRoll;
    int bSkill;
    int nConstant;
    int nTotal;
    int bFail;
    string sText;
    string sDC;
    string sDetail;
    string sReport;
    string sRoll;
    string sRollText;
    string sDMRollText;
    object oRoller;
	object oAgainst;
	string sName;

         if (sSkill == EMT_ABL_STRENGTH)      { bSkill=2; nConstant=0;}
    else if (sSkill == EMT_ABL_DEXTERITY)     { bSkill=2; nConstant=1; }
    else if (sSkill == EMT_ABL_CONSTITUTION)  { bSkill=2; nConstant=2; }
    else if (sSkill == EMT_ABL_INTELLIGENCE)  { bSkill=2; nConstant=3; }
    else if (sSkill == EMT_ABL_WISDOM)        { bSkill=2; nConstant=4; }
    else if (sSkill == EMT_ABL_CHARISMA)      { bSkill=2; nConstant=5; }

    else if (sSkill == EMT_SAVE_FORTITUDE)     { bSkill=3; nConstant=1; }
    else if (sSkill == EMT_SAVE_REFLEX)        { bSkill=3; nConstant=2; }
    else if (sSkill == EMT_SAVE_WILL)          { bSkill=3; nConstant=3; }

    //else if (sSkill == EMT_SKL_ANIMAL_EMPATHY){ bSkill=1; nConstant=0; bFail=1; }
    else if (sSkill == EMT_SKL_APPRAISE)      { bSkill=1; nConstant=20;  }
    else if (sSkill == EMT_SKL_BLUFF)         { bSkill=1; nConstant=23; }
    else if (sSkill == EMT_SKL_CONCENTRATION) { bSkill=1; nConstant=1; }
    //else if (sSkill == EMT_SKL_CRAFT_ALCHEMY) { bSkill=1; nConstant=27; }   // ALFA edit
    //else if (sSkill == EMT_SKL_CRAFT_ARMOR)   { bSkill=1; nConstant=25;  }   // ALFA edit
    //else if (sSkill == EMT_SKL_CRAFT_TRAP)    { bSkill=1; nConstant=22; }   // ALFA edit
    //else if (sSkill == EMT_SKL_CRAFT_WEAPON)  { bSkill=1; nConstant=26; }   // ALFA edit
    else if (sSkill == EMT_SKL_DISABLE_TRAP)  { bSkill=1; nConstant=2; bFail=1; }
    //else if (sSkill == EMT_SKL_DISCIPLINE)    { bSkill=1; nConstant=3; }   // ALFA edit
    else if (sSkill == EMT_SKL_DIPLOMACY)     { bSkill=1; nConstant=12; }
    else if (sSkill == EMT_SKL_HEAL)          { bSkill=1; nConstant=4; }
    else if (sSkill == EMT_SKL_HIDE)          { bSkill=1; nConstant=5; }
    else if (sSkill == EMT_SKL_INTIMIDATE)    { bSkill=1; nConstant=24; }
    else if (sSkill == EMT_SKL_LISTEN)        { bSkill=1; nConstant=6; }
    //else if (sSkill == EMT_SKL_LORE)          { bSkill=1; nConstant=7; }   // ALFA edit
    else if (sSkill == EMT_SKL_MOVE_SILENTLY) { bSkill=1; nConstant=8; }
    else if (sSkill == EMT_SKL_OPEN_LOCK)     { bSkill=1; nConstant=9; bFail=1; }
    else if (sSkill == EMT_SKL_PARRY)         { bSkill=1; nConstant=10; }
    //else if (sSkill == EMT_SKL_PERFORM)       { bSkill=1; nConstant=11; }
    //else if (sSkill == EMT_SKL_PERSUADE)      { bSkill=1; nConstant=12; }
    //else if (sSkill == EMT_SKL_PICK_POCKET)   { bSkill=1; nConstant=13; bFail=1; }
    else if (sSkill == EMT_SKL_SEARCH)        { bSkill=1; nConstant=14; }
    //else if (sSkill == EMT_SKL_SET_TRAP)      { bSkill=1; nConstant=15; bFail=1; }   // ALFA edit
    else if (sSkill == EMT_SKL_SLEIGHT_OF_HAND){ bSkill=1; nConstant=13; bFail=1; }
    else if (sSkill == EMT_SKL_SPELLCRAFT)    { bSkill=1; nConstant=16; bFail=1;; }
    else if (sSkill == EMT_SKL_SPOT)          { bSkill=1; nConstant=17; }
    else if (sSkill == EMT_SKL_SURVIVAL)      { bSkill=1; nConstant=29; }
    //else if (sSkill == EMT_SKL_TAUNT)         { bSkill=1; nConstant=18;; }   // ALFA edit
    else if (sSkill == EMT_SKL_TUMBLE)        { bSkill=1; nConstant=21; bFail=1; }
    else if (sSkill == EMT_SKL_USE_MAGIC_DEVICE) { bSkill=1; nConstant=19; bFail=1;; }
	// ALFA custom skill additions
	/*
	else if (sSkill == EMT_SKL_BALANCE) { bSkill=1; nConstant=30; }
	else if (sSkill == EMT_SKL_CLIMB) { bSkill=1; nConstant=31; }
	else if (sSkill == EMT_SKL_CRAFT__ALCHEMY) { bSkill=1; nConstant=64; }
	else if (sSkill == EMT_SKL_CRAFT_ARMORSMITHING) { bSkill=1; nConstant=65; }
	else if (sSkill == EMT_SKL_CRAFT_BOWMAKING) { bSkill=1; nConstant=66; }
	else if (sSkill == EMT_SKL_CRAFT_WEAPONSMITHING) { bSkill=1; nConstant=67; }
	else if (sSkill == EMT_SKL_DECIPHER_SCRIPT) { bSkill=1; nConstant=32; bFail=1;; }
	else if (sSkill == EMT_SKL_DISGUISE) { bSkill=1; nConstant=34; }
	else if (sSkill == EMT_SKL_ESCAPE_ARTIST) { bSkill=1; nConstant=35; }
	else if (sSkill == EMT_SKL_FORGERY) { bSkill=1; nConstant=36; }
	else if (sSkill == EMT_SKL_GATHER_INFORMATION) { bSkill=1; nConstant=37; }
	else if (sSkill == EMT_SKL_HANDLE_ANIMAL) { bSkill=1; nConstant=38; bFail=1;; }
	else if (sSkill == EMT_SKL_JUMP) { bSkill=1; nConstant=39; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_ARCANA) { bSkill=1; nConstant=40; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_DUNGEONEERING) { bSkill=1; nConstant=33; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_GEOGRAPHY) { bSkill=1; nConstant=55; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_HISTORY) { bSkill=1; nConstant=41; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_NATURE) { bSkill=1; nConstant=42; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_NOBILITY) { bSkill=1; nConstant=56; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_RELIGION) { bSkill=1; nConstant=43; bFail=1;; }
	else if (sSkill == EMT_SKL_KNOWLEDGE_THEPLANES) { bSkill=1; nConstant=44; bFail=1;; }
	else if (sSkill == EMT_SKL_PERFORM_ACT) { bSkill=1; nConstant=45; }
	else if (sSkill == EMT_SKL_PERFORM_COMEDY) { bSkill=1; nConstant=63; }
	else if (sSkill == EMT_SKL_PERFORM_DANCE) { bSkill=1; nConstant=46; }
	else if (sSkill == EMT_SKL_PERFORM_KEYBOARDS) { bSkill=1; nConstant=61; }
	else if (sSkill == EMT_SKL_PERFORM_ORATORY) { bSkill=1; nConstant=47; }
	else if (sSkill == EMT_SKL_PERFORM_PERCUSSION) { bSkill=1; nConstant=60; }
	else if (sSkill == EMT_SKL_PERFORM_STRINGINSTRUMENTS) { bSkill=1; nConstant=48; }
	else if (sSkill == EMT_SKL_PERFORM_SING) { bSkill=1; nConstant=49; }
	else if (sSkill == EMT_SKL_PERFORM_WINDINSTRUMENTS) { bSkill=1; nConstant=62; }
	else if (sSkill == EMT_SKL_PROFESSION) { bSkill=1; nConstant=50; bFail=1;; }
    else if (sSkill == EMT_SKL_RIDE)          { bSkill=1; nConstant=28; }
	else if (sSkill == EMT_SKL_SENSE_MOTIVE) { bSkill=1; nConstant=51; }
	else if (sSkill == EMT_SKL_SPEAK_LANGUAGE) { bSkill=1; nConstant=52; bFail=1;; }
	else if (sSkill == EMT_SKL_SWIM) { bSkill=1; nConstant=53; }
	else if (sSkill == EMT_SKL_USE_ROPE) { bSkill=1; nConstant=54; }
	else { SendMessageToPC(oSpeaker, "Error interpreting sSkill: "+sSkill); }
	*/
    if (!bDMRequest)
    { // PLAYER CODE
       	oAgainst = GetLocalObject(oTool, DMFI_TARGET);
		if (bSkill==1)
        {// get the skill
            nMod = GetSkillRank(nConstant, oSpeaker);
            if ((bFail) && (nMod==0))
            {
                sText = ColorText(TXT_ROLL + DMFI_CapitalizeWord(sSkill) + TXT_NOT_TRAINED, COLOR_RED);
				AssignCommand(oSpeaker, SpeakString(" " + sText));
                return;
            }
        }// get the skill
        else if (bSkill==2)
            nMod = GetAbilityModifier(nConstant, oSpeaker);
        else if (bSkill==3)
        {// get saving throw mod
            if (nConstant==1)       nMod = GetFortitudeSavingThrow(oSpeaker);
            else if (nConstant==2)  nMod = GetReflexSavingThrow(oSpeaker);
            else if (nConstant==3)  nMod = GetWillSavingThrow(oSpeaker);
        }// get saving throw mod
        nRoll = d20();
        
		if (GetIsObjectValid(oAgainst))
			sName = GetName(oAgainst);
		else 
			sName = TXT_AREA;	
		//sText = TXT_AGAINST + sName;
		
		sText = sText + "\n" + ColorText(TXT_ROLL + DMFI_CapitalizeWord(sSkill) + TXT_MODIFIER + IntToString(nMod) + TXT_TOTAL + IntToString(nRoll+nMod), COLOR_CYAN);
        AssignCommand(oSpeaker, SpeakString(PRM_ + sText));
        SetLocalObject(GetModule(), DMFI_LAST_ROLLER, oSpeaker);
    } // PLAYER CODE
    
	else
    { // DM CODE
        sDC = GetStringLowerCase(GetLocalString(oTool, DMFI_DICEBAG_DC));
        sDetail = GetStringLowerCase(GetLocalString(oTool, DMFI_DICEBAG_DETAIL));
        sReport = GetStringLowerCase(GetLocalString(oTool, DMFI_DICEBAG_REPORT));
        sRoll = GetStringLowerCase(GetLocalString(oTool, DMFI_DICEBAG_ROLL));

        if (sRoll==PRM_PARTY)
            oRoller = GetFirstFactionMember(oSpeaker, FALSE);
        else if (sRoll==PRM_PC)
            oRoller = oSpeaker;
        else if (sRoll==PRM_BEST)
            oRoller = DMFI_BestRoller(oSpeaker, bSkill, nConstant);

        while (oRoller!=OBJECT_INVALID)
        {
            if (bSkill==1)
            {
                nMod = GetSkillRank(nConstant, oRoller);
                if (bFail==1 && nMod==0)
                {
                    sText = ColorText(TXT_ROLLER + GetName(oRoller) + TXT_NOT_TRAINED, COLOR_RED);
					
					if (sReport==PRM_DM)
						SendText(oDM, sText, TRUE);
                
           			else if (sReport==PRM_PARTY)
            		{
                		SendTalkText(oRoller, sText);
                		SendText(oDM, sText, TRUE);
					}	
           	        else
            		{
                		SendText(oRoller, sText, TRUE);
                		SendText(oDM, sText, TRUE);
            		}
					return;
                }
            }
            else if (bSkill==2)  nMod=GetAbilityModifier(nConstant, oRoller);
            else if (bSkill==3)
            {// get saving throw mod
                if (nConstant==1)       nMod = GetFortitudeSavingThrow(oSpeaker);
                else if (nConstant==2)  nMod = GetReflexSavingThrow(oSpeaker);
                else if (nConstant==3)  nMod = GetWillSavingThrow(oSpeaker);
            }// get saving throw mod

            nRoll = d20();
            nTotal = nRoll + nMod;

            if (nTotal >= StringToInt(sDC)) sRollText = TXT_ROLL_PASSED;
            else sRollText = TXT_ROLL_FAILED;

            // EXAMPLE:  WISDOM  FAILED
            sRollText = DMFI_CapitalizeWord(sSkill) + sRollText;
            sDMRollText = sRollText;
            // EXAMPLE:  WIS FAILED + ROLL RESULT
            if (sDetail!=PRM_LOW) sRollText = sRollText + TXT_MODIFIER + IntToString(nMod) + TXT_TOTAL + IntToString(nTotal);
            sDMRollText = sDMRollText + TXT_MODIFIER + IntToString(nMod) + TXT_TOTAL + IntToString(nTotal);
            // EXAMPLE:  WIS FAILED + ROLL RESULT AGAINST DC OF
            if (sDetail==PRM_HIGH) sRollText = sRollText + TXT_AGAINST_DC + sDC;
            sDMRollText = sDMRollText + TXT_AGAINST_DC + sDC;

            if (sReport==PRM_DM)
                SendText(oDM, TXT_ROLLER + GetName(oRoller) + PRM_ + sDMRollText, TRUE, COLOR_CYAN);
            else if (sReport==PRM_PARTY)
            {
                SendTalkText(oRoller, PRM_+ sRollText, COLOR_CYAN);
                SendText(oDM, TXT_ROLLER + GetName(oRoller) + PRM_ + sDMRollText, TRUE, COLOR_CYAN);
            }
            else
            {
                SendText(oRoller, PRM_ + sRollText, TRUE, COLOR_CYAN);
                SendText(oDM, TXT_ROLLER + GetName(oRoller) + PRM_ + sDMRollText, TRUE, COLOR_CYAN);
            }
            // REPEAT IF APPROPRIATE AND IF NOT, BREAK FROM LOOP
            if ((sRoll==PRM_PARTY) && (GetIsPC(oSpeaker)))
				oRoller = GetNextFactionMember(oSpeaker, FALSE);
            else
				oRoller = OBJECT_INVALID;
        }
    }// DM CODE

} // DMFI_RollCheck()

object DMFI_Storage(object oPC, object oTarget)
{ // Purpose: Create a storage locker for the player in case we want to give back
  // items to the player.  If there is not one valid, this creates one for you.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 2/4/7, Qk 10/08/07  (dragonsbane fixes)
    object oStorage, oTemp, oTest;
	
	oStorage = GetItemPossessedBy(oPC, GetName(oTarget));
	if (!GetIsObjectValid(oStorage))
	{
		SendText(oPC, TXT_CREATE_STORAGE + GetName(oTarget));
		oTest = CreateItemOnObject(DMFI_STORAGE, oPC);
		oStorage = CopyObject(oTest, GetLocation(oPC), oPC, DMFI_INVEN_TEMP);
        // QK -> Dragonsbane: Fix for NWN2 v1.10 
        oStorage = GetNearestObjectByTag(DMFI_INVEN_TEMP,oPC); 
        // End Update 
		DestroyObject(oTest);
		SetFirstName(oStorage, GetName(oTarget));
		SetIdentified(oStorage, TRUE);
	}
  
	return oStorage;
}

void DMFI_StripInventory(object oTarget, object oDM)
{ //Purpose: Strips oTargets inventory as requested by oDM.  It will log the
  //server that this action occurred.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/27/6 
    int n;
    object oStorage;
    object oTest;
    oStorage = DMFI_Storage(oDM, oTarget);
    oTest = GetFirstItemInInventory(oTarget);
	AssignCommand(oTarget, ClearAllActions(TRUE));
    while (oTest!=OBJECT_INVALID)
    { // strip inventory items
        SetPlotFlag(oTest, FALSE);
        SetItemCursedFlag(oTest, FALSE);
        SetDroppableFlag(oTest, FALSE);
		AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
        oTest = GetNextItemInInventory(oTarget);
    }
    for (n=0; n<18; n++)
    { // strip equiped items
        oTest = GetItemInSlot(n, oTarget);
        if (oTest!=OBJECT_INVALID)
        {
			AssignCommand(oTarget, ActionUnequipItem(oTest));
            SetPlotFlag(oTest, FALSE);
            SetItemCursedFlag(oTest, FALSE);
            SetDroppableFlag(oTest, FALSE);
            AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
        }
    }
    AssignCommand(oDM, ActionPickUpItem(oStorage));
	SendText(oDM, TXT_INVENTORY_STRIPPED, TRUE, COLOR_GREEN);
    SendText(oDM, TXT_PLOT_CURSED_DROPPED_FLAG);
    WriteTimestampedLogEntry(TXT_DM_ACTION + GetName(oDM) + " " + TXT_INVENTORY_STRIPPED + GetName(oTarget));
}

void DMFI_ManageInventory(object oTarget, object oPC)
{
	int n;
	object oTest, oSubTest;
	object oNew;
	object oStorage = GetItemPossessedBy(oPC, DMFI_INVEN_TEMP);
	
	if (GetIsObjectValid(oStorage))
	{
		SetPlotFlag(oStorage, FALSE);
		DestroyObject(oStorage);
	}		
	
	SendText(oPC, TXT_CREATE_STORAGE + DMFI_INVEN_TEMP);
	oTest = CreateItemOnObject(DMFI_STORAGE, oPC,1,DMFI_INVEN_TEMP);
	//oStorage = CopyObject(oTest, GetLocation(oPC), oPC, DMFI_INVEN_TEMP);
	oStorage = oTest;
	  // Qk, dragonsbane fix didn't work
      // the workaround was to use the new CreateitemOnObject parameter, thanks god
     // oStorage = GetNearestObjectByTag(DMFI_INVEN_TEMP,oPC);
	//DestroyObject(oTest);
	      // End Update
	SetFirstName(oStorage, DMFI_INVEN_TEMP + GetName(oTarget));
	SetIdentified(oStorage, TRUE);
	SetLocalObject(oPC, DMFI_INVENTORY_TARGET, oTarget);
	
	// Get Target's Inventory	
	oTest = GetFirstItemInInventory(oTarget);
	while (oTest!=OBJECT_INVALID)
    { // strip inventory items
		oNew = CopyItem(oTest, oStorage, TRUE);
		SetLocalObject(oNew, DMFI_INVENTORY_TARGET, oTest);	
		oTest = GetNextItemInInventory(oTarget);
    }
    for (n=0; n<18; n++)
    { // strip equiped items
        oTest = GetItemInSlot(n, oTarget);
        if (oTest!=OBJECT_INVALID)
        {
			oNew = CopyItem(oTest, oStorage, TRUE);
			SetLocalObject(oNew, DMFI_INVENTORY_TARGET, oTest);	
        }
    }
	AssignCommand(oPC, ActionPickUpItem(oStorage));
	SendText(oPC, TXT_INVENTORY_MANAGE, TRUE, COLOR_GREEN);
}		




//void main(){}