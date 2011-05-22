// kinc_spirit_eater
/*
	Spirit Eater support 
	
*/
// ChazM 12/19/06
// ChazM 1/10/07 Added additional constants
// ChazM 3/2/07 Updated spirit/soul/undead checking
// ChazM 3/14/07 spelling fix
// ChazM 4/2/07 removed GetIsSpirit() - this is now in NWscript, added SpellAbility constants
// ChazM 4/5/07 added use count vars
// ChazM 4/12/07 VFX/string update
// ChazM 4/27/07 DoDevour() now drops spirit essences
// ChazM 5/1/07 DoDevour() drops configurable for num and type.
// ChazM 5/3/07 Added DoSpiritualEvisceration(), other minor changes; updated constants
// ChazM 5/11/07 added Spirt Bar Pause funcitons
// ChazM 5/23/07 VFX update/Signal event
// ChazM 5/23/07 Modified DoSpiritualEvisceration()
// ChazM 5/25/07 modified DoDevour()
// ChazM 5/29/07 Added res and don't heal the fully healed to DoBestowLifeForce()
// ChazM 5/29/07 Keep killing on stage 6
// ChazM 6/4/07 Added set of functions for supporting setting/transferring of Spirit Eater-ness
// ChazM 6/5/07 numerous multiplayer changes - unique ID's, etc.
// ChazM 6/6/07 SetSpiritEater() fix
// ChazM 6/6/07 moved UpdateSEPointsForTimePassed() here, changed GetSpiritEater() to return first PC if not initialized;
//				Spirit Eater Convo pausing functions added
// MDiekmann 6/8/07 - Added DelayCommand to damage effect on DoDevour() to solve pointer issues with Spirit Gorge
// ChazM 6/11/07 - remove SpawnScriptDebugger()
// ChazM 6/22/07 - SetSpiritEaterStage() now always applies stage - fix for certain corner cases.
// ChazM 6/22/07 - SpiritEaterFeatAdd() reports gaining of feat
// MDiekman 6/22/07 - Added some !'s to get opposite effect on disabling SE stage buttons.
// ChazM 6/22/07 - Added Spirit Eater Corruption Effects
// EPF 6/25/07 - increased power of devour abilities from 5-20% to 10-35% as part of rebalance.
// ChazM 6/29/07 - Updates for collapsable GUI elements
// ChazM 7/3/07 - added Multi scene support for collapsable GUI
// MDiekmann 7/3/07 - added constants for devour ability use
// MDiekmann 7/5/07 Modified DevourCorruptionPenalty() to include increase if devour ability already used.
// MDiekmann 7/10/07 - Modified ApplyDeathToSpiritEater so it now causes a game ending condition.
// ChazM 7/11/07 - Quick fix for compile issue 
// MDiekman 7/12/07 - Fix for compile issue, multiplayer support for death.
// ChazM 7/12/07 - Spirit eater passing fix 
// MDiekmann 7/13/07 - Fix for multiplayer spirit eater death
// MDiekmann 7/16/07 - Modified DoDevourDrop() to target creature being devoured, and not caster for essence drop information
// MDiekmann 7/17/07 - Added sound effect for stage change and corruption change.
// ChazM 7/18/07 - fix constant VFX_CAST_SPELL_SPIRITUAL_EVISCERATION
// ChazM 7/19/07 - UpdateWhoIsSpiritEater() now returns object
// ChazM 7/23/07 - VFX_CAST_SPELL_SPIRIT_EMERGE/_GOOD commented out (now in NWSCRIPT)
// ChazM 7/25/07 - fix for SE creature armors sometimes going into inventory.
// ChazM 8/17/07 - hide spirit stage armor notifications
// MDiekmann 8/29/07 - Added SE stage in inventory check for returning to stage 0

//void main (){}
#include "nwn2_inc_spells"
#include "x0_i0_spells"
#include "x0_i0_stringlib"
#include "ginc_vars"
#include "ginc_2da"
#include "ginc_effect"

//#include "x0_i0_match"
//#include "ginc_debug"

// -------------------------------------------------------
// Constants
// -------------------------------------------------------



// variables on creatures:
// if target devoured, he'll drop this number and type of objects as set on the character.
// The number value defaults to 1
// The type defaults to volatile spirit essences
const string VAR_nDEVOUR_DROP_NUM 		= "DEVOUR_DROP_NUM"; 	// int
const string VAR_sDEVOUR_DROP_RESREF	= "DEVOUR_DROP_RESREF"; // string


// spirit essences - for dropping!
const string SPIRIT_VOLATILE    = "nx1_cft_ess_spirit01";
const string SPIRIT_BRILLIANT   = "nx1_cft_ess_spirit02";
const string SPIRIT_PRISTINE    = "nx1_cft_ess_spirit03";

// Handy String Refs
const int STR_REF_INVALID_TARGET 	= 186227; // "Invalid Target."
const int STR_REF_TOO_WEAK 			= 186228; // "You are to weak to use this power."

// global variable names
const string VAR_bSE_INITIALIZED	= "00_bSEInit"; 
const string VAR_bSE_GUI_PAUSED 	= "00_bSE_GUI_PAUSED";
const string VAR_fSE_POINTS 		= "00_fSEPoints"; 
const string VAR_iSE_STAGE 			= "00_iSEStage";
const string VAR_fCORRUPTION_RATE 	= "00_fCorruption";
const string VAR_UNIQUE_ID_COUNT	= "00_nPlayerUniqueIDCount"; 	// Last Unique ID assigned.
const string VAR_SE_PLAYER_UNIQUE_ID = "00_nSEPlayerUniqueID";		// Unique ID of the Spirit Eater
const string VAR_PREFERRED_SE		= "00_nPreferredSEID";			// ID of the preferred spirit eater player.

// module variable names
//const string VAR_SPIRIT_BAR_PC 		= "__SPIRIT_EATER_PC"; // we use module for this so we can store an object reference.

// loval variables
const string VAR_UNIQUE_ID			= "00_nPlayerUniqueID";		// Player's Unique ID, stored on player

// spirit eater stages
const int SPIRIT_EATER_STAGE_0 = 0;
const int SPIRIT_EATER_STAGE_1 = 1;
const int SPIRIT_EATER_STAGE_2 = 2;
const int SPIRIT_EATER_STAGE_3 = 3;
const int SPIRIT_EATER_STAGE_4 = 4;
const int SPIRIT_EATER_STAGE_5 = 5;
const int SPIRIT_EATER_STAGE_6 = 6;

// spirit eater points
const float fSPIRIT_EATER_POINTS_MAX 	= 100.0f;
const float fSPIRIT_EATER_POINTS_MIN 	= 0.0f;
const float fSPIRIT_EATER_POINTS_START 	= 100.0f;

const float fSPIRIT_EATER_POINTS_STAGE_0 = 65.0;
const float fSPIRIT_EATER_POINTS_STAGE_1 = 37.0;
const float fSPIRIT_EATER_POINTS_STAGE_2 = 17.0;
const float fSPIRIT_EATER_POINTS_STAGE_3 = 7.0;
const float fSPIRIT_EATER_POINTS_STAGE_4 = 2.0;
const float fSPIRIT_EATER_POINTS_STAGE_5 = 1.0;
const float fSPIRIT_EATER_POINTS_STAGE_6 = 0.0;

const float fSE_BASE_HOURLY_DECAY 		= -2.0f;	// the base amount of Spirit Eater Points lost/hour

// corruption (change in rate of decay of spirit eater points)
const float fSPIRIT_EATER_CORRUPTION_MAX 	= 3.0f;
const float fSPIRIT_EATER_CORRUPTION_MIN 	= 0.5f;
const float fSPIRIT_EATER_CORRUPTION_START 	= 1.0f;

// devour spirit
const int nDEVOUR_BASE_ENERGY = 10;
const int nDEVOUR_MAX_ENERGY = 25;

// for ka_se_devour_effect
const int ID_DEVOUR_SPIRIT		= 1;
const int ID_DEVOUR_SOUL		= 2;
const int ID_ETERNAL_REST		= 3;
const int ID_BESTOW_LIFEFORCE 	= 4;

/*
// feats
const int FEAT_DEVOUR_SPIRIT_1      =1976;
const int FEAT_DEVOUR_SPIRIT_2      =1977;
const int FEAT_DEVOUR_SPIRIT_3      =1978;
const int FEAT_DEVOUR_SOUL          =1979;
const int FEAT_SPIRIT_GORGE         =1980;
const int FEAT_RAVENOUS_INCARNATION =1981;
const int FEAT_BESTOW_LIFE_FORCE    =1982;
const int FEAT_SUPPRESS             =1983;
const int FEAT_ETERNAL_REST         =1984;
const int FEAT_SATIATE              =1985;
const int FEAT_MOLD_SPIRIT          =1986;
const int FEAT_MALLEATE_SPIRIT      =2050;
const int FEAT_SPIRITUAL_EVISCERATION =2104;

// spell abilities
const int SPELLABILITY_DEVOUR_SPIRIT			=1068;
const int SPELLABILITY_SPIRIT_GORGE				=1069;
const int SPELLABILITY_RAVENOUS_INCARNATION		=1070;
const int SPELLABILITY_BESTOW_LIFE_FORCE		=1071;
const int SPELLABILITY_SUPPRESS					=1072;
const int SPELLABILITY_SATIATE					=1073;
const int SPELLABILITY_DEVOUR_SOUL				=1092;
const int SPELLABILITY_ETERNAL_REST				=1093;
const int SPELLABILITY_MOLD_SPIRIT				=1111;
const int SPELLABILITY_MALLEATE_SPIRIT			=1112;
const int SPELLABILITY_SPIRITUAL_EVISCERATION	=1125;
*/

// incremented each time they are used successfully.
const string VAR_SE_USE_COUNT_SUPPRESS 		= "se_use_count_suppress";
const string VAR_SE_USE_COUNT_DEVOUR_SPIRIT = "se_use_count_devour_spirit";

// variable used to see whether or not suppress or a devour ability have been used since the last rest

const string VAR_SE_HAS_BEEN_DEVOURED		= "se_has_been_devoured";
const string VAR_SE_HAS_USED_DEVOUR_ABILITY	= "se_has_used_devour_ability";
const int STR_REF_MULTIPLE_DEVOUR = 208072;

//variable to show that spirit eater has died

const string VAR_SE_DEATH		= "se_death";

// === GUI ===
const string VAR_SPIRIT_BAR_XML 		= "00_SPIRIT_BAR_XML"; // holds the currently used xml file name or ""
const string VAR_SPIRIT_BAR_SCREEN 		= "00_SPIRIT_BAR_SCREEN"; // holds the currently used screen name or ""


const string sSCREEN_GUI_SPIRIT_BAR     = "GUI_SPIRIT_BAR"; // The name by which we will refer to the GUI panel
const string sSCREEN_GUI_SPIRIT_BAR_MIN = "GUI_SPIRIT_BAR_MIN"; // The name by which we will refer to the minimized GUI panel

const string sFILE_NAME_GUI_SPIRIT_BAR  = "spiritbar.xml";  // the XML file
const string sFILE_NAME_GUI_SPIRIT_BAR_MIN  = "spiritbar_min.xml";  // the minimized XML file


const string BAR_SPIRITBAR 				= "SPIRITBAR";	// the spirit energy bar element
const string BAR_SPIRITBAR_PAUSE 		= "SPIRITBAR_PAUSE";	// the spirit energy bar element when paused
const string BAR_SPIRITBAR_BG 			= "SPIRITBAR_BG";	// the spirit energy bar background
const string BAR_SPIRITBAR_BG_PAUSE 	= "SPIRITBAR_BG_PAUSE";	// the spirit energy bar backgrounf when paused
 
const string BAR_CRAVINGBAR 			= "CRAVINGBAR";	// the craving bar element
const string BAR_CRAVINGBAR_PAUSE 		= "CRAVINGBAR_PAUSE";	// the craving bar element when paused 
const string BAR_CRAVINGBAR_BG 			= "CRAVINGBAR_BG";	// the craving bar background
const string BAR_CRAVINGBAR_BG_PAUSE 	= "CRAVINGBAR_BG_PAUSE";	// the craving bar background when paused 

const string BAR_SE_TEXT_RATIO 			= "SpiritEnergyRatioTXT";	// 


// these elements are actually buttons so that we can disable them, 
// but they don't do anything and so behave like icons.
const string ICON_SPIRIT_EATER_STAGE_0 = "SpiritLevel0";
const string ICON_SPIRIT_EATER_STAGE_1 = "SpiritLevel1";
const string ICON_SPIRIT_EATER_STAGE_2 = "SpiritLevel2";
const string ICON_SPIRIT_EATER_STAGE_3 = "SpiritLevel3";
const string ICON_SPIRIT_EATER_STAGE_4 = "SpiritLevel4";
const string ICON_SPIRIT_EATER_STAGE_5 = "SpiritLevel5";
const string ICON_SPIRIT_EATER_STAGE_6 = "SpiritLevel6";

//const string ICON_SPIRIT_EATER_STAGE_0 = "SpiritLevel0";
const string ICON_SPIRIT_EATER_STAGE_1_DISABLED = "SpiritLevel1_disabled";
const string ICON_SPIRIT_EATER_STAGE_2_DISABLED = "SpiritLevel2_disabled";
const string ICON_SPIRIT_EATER_STAGE_3_DISABLED = "SpiritLevel3_disabled";
const string ICON_SPIRIT_EATER_STAGE_4_DISABLED = "SpiritLevel4_disabled";
const string ICON_SPIRIT_EATER_STAGE_5_DISABLED = "SpiritLevel5_disabled";
const string ICON_SPIRIT_EATER_STAGE_6_DISABLED = "SpiritLevel6_disabled";


//const string ICON_SPIRIT_EATER_STAGE_0 = "SpiritLevel0";
const string ICON_SPIRIT_EATER_STAGE_1_TOP = "SpiritLevel1_top";
const string ICON_SPIRIT_EATER_STAGE_2_TOP = "SpiritLevel2_top";
const string ICON_SPIRIT_EATER_STAGE_3_TOP = "SpiritLevel3_top";
const string ICON_SPIRIT_EATER_STAGE_4_TOP = "SpiritLevel4_top";
const string ICON_SPIRIT_EATER_STAGE_5_TOP = "SpiritLevel5_top";
const string ICON_SPIRIT_EATER_STAGE_6_TOP = "SpiritLevel6_top";


// SEF files
/*
const string FX_SE_DEVOUR_SPIRIT 			= "fx_se_devour_spirit.sef";
const string FX_SE_SPIRIT_GORGE 			= "fx_se_spirit_gorge.sef";
const string FX_SE_RAVENOUS_INCARNATION 	= "fx_se_ravenous_incarnation.sef";
const string FX_SE_BESTOW_LIFE_FORCE 		= "fx_se_bestow_life_force.sef";
const string FX_SE_SUPPRESS					= "fx_se_suppress.sef";
const string FX_SE_ETERNAL_REST 			= "fx_se_eternal_rest.sef";
const string FX_SE_SATIATE 					= "fx_se_satiate.sef";
const string FX_SE_DEATH_SEQUENCE 			= "fx_se_death_sequence.sef"; //Spirit Energy Death Sequence Visual Effect
const string FX_SE_SPIRITUAL_EVISCERATION	= "fx_se_spiritual_evisceration.sef"; 


const string FX_SE_SUPPRESS					= "fx_se_suppress.sef";
const string FX_SE_SATIATE 					= "fx_se_satiate.sef";
const string FX_SE_SPIRITUAL_EVISCERATION	= "fx_se_spiritual_evisceration.sef"; 

const string FX_SE_DEATH_SEQUENCE 			= "fx_spirit_eater_death.sef"; //Spirit Energy Death Sequence Visual Effect

// hit effects
const string FX_SE_SPIRIT_GORGE 			= "fx_spirit_gorge_hit.sef";
const string FX_SE_DEVOUR_SPIRIT 			= "fx_devour_spirit_hit.sef";
const string FX_SE_BESTOW_LIFE_FORCE 		= "fx_bestow_life_hit.sef";
const string FX_SE_ETERNAL_REST 			= "fx_eternal_rest_hit.sef";
const string FX_SE_RAVENOUS_INCARNATION 	= "fx_ravenous_hit.sef";
*/


// VFX - defined in visualeffects.2da 

// caster visual effects
const int VFX_CAST_SPELL_DEVOUR_SPIRIT 			= 956;
const int VFX_CAST_SPELL_SPIRIT_GORGE 			= 957;
const int VFX_CAST_SPELL_BESTOW_LIFE 			= 958;
const int VFX_CAST_SPELL_SATIATE 				= 959; 	// no target
const int VFX_CAST_SPELL_SUPPRESS 				= 960;	// no target
const int VFX_CAST_SPELL_SPIRITUAL_EVISCERATION	= 961;	
//const int VFX_CAST_SPELL_SPIRIT_EMERGE			= 1016;
//const int VFX_CAST_SPELL_SPIRIT_EMERGE_GOOD		= 1017;

// target visual effects - these are all beams
const int VFX_HIT_SPELL_DEVOUR_SPIRIT 			= 932; // caster devour (devour soul does same)
const int VFX_HIT_SPELL_SPIRIT_GORGE 			= 933; // caster gorge
const int VFX_HIT_SPELL_SPIRITUAL_EVISCERATION	= 934;
const int VFX_HIT_SPELL_BESTOW_LIFE 			= 935;
const int VFX_HIT_SPELL_ETERNAL_REST 			= 937; // caster bestow life

// ravenous incarnation
const int VFX_ATTACK_RAVENOUS_INCARNATION 		= 0; // a ray that occurs on hit
const int VFX_DUR_RAVENOUS_INCARNATION 			= 962; // VFX that plays along with the effect (includes impact and cessation)

const int VFX_SPIRIT_EATER_DEATH 				= 939;

// SE Sound effect files

const string SFX_SE_CORRUPTION_INCREASE = "gui_mg_speattranincr";
const string SFX_SE_CORRUPTION_DECREASE = "gui_mg_speattrandecr";
const string SFX_SE_STAGE_INCREASE = "gui_mg_speattranup";
const string SFX_SE_STAGE_DECREASE = "gui_mg_speattrandwn";

// timing
const float VFX_SE_HIT_DELAY 		= 1.2f;
const float VFX_SE_HIT_DURATION 	= 2.0f;

const float VFX_SE_HIT_CUTSCENE_DELAY = 4.3f;	// for ka_se_emerge_attack.sef



// -------------------------------------------------------
// Prototypes
// -------------------------------------------------------

void ApplyDeathToSpiritEater(object oTarget);
void ApplySpiritEaterStage(int iStage, object oTarget);
int GetSpiritEaterStage();
void SetSpiritEaterStage(int iStage, object oTarget);
int SpiritEaterPointsToStage(float fNumPoints);
float GetSpiritEaterPoints();
void SetSpiritEaterPoints(float fAmount);
void UpdateSpiritEaterPoints(float fDelta);
float GetSpiritEaterCorruption();
void SetSpiritEaterCorruption(float fAmount);
void UpdateSpiritEaterCorruption(float fDelta);
void InitializeSpiritEater(object oPC);
void TerminateSpiritEater();
void UpdateSEPointsForTimePassed(int nNumHoursPassed);

// Spirit Bar
string GetSpiritBarScreenName();
string GetSpiritBarXMLFileName();
int GetIsSpiritBarPaused();
int GetIsSpiritEaterInitialized();
void SpiritBarPauseRequest(int bPause);
void SpiritBarPause(int bPause);
void DisplaySpiritBar(object oPC);
void CloseSpiritBar(object oPC);

// SE application
void RemoveSpiritEaterStatus(object oPC);
void ApplySpiritEaterStatus(object oPC);
int GetUniqueIDofPC(object oPC);
object GetPCByUniqueID(int nUniqueID);
object GetSpiritEater();
object SetSpiritEater(object oPC);
void SetPreferredSpiritEater(object oPreferredPC);
object GetPreferredSpiritEater();
object GetWhoShouldBeSpiritEater();
object UpdateWhoIsSpiritEater();

// Stage calculations
float GetSpiritEaterStageMinimumPoints(int nStage);
float GetSpiritEaterStageMaximumPoints(int nStage);
float GetPointsInStage(int nStage);
float GetRatioRemainingOfStage(float fSpiritEnergy);
float GetRatioMissingOfStage(float fSpiritEnergy);
void ReduceSpiritEaterPointsByStageRatio(float fRatioToReduce);

// Spirit Eater Convo pausing
int GetIsFactionMemberInConversation(object oMemberOfFaction, int bPCOnly=TRUE);
void SpiritEaterConversationPauseCheck(object oPC);
void CheckAllForSEConvoPause();

// Spirit eater powers
int SpiritEaterFeatAdd(int nFeat);
void ApplySpiritEaterFeatList(object oPC);
void RemoveSpiritEaterFeatList(object oPC);
int GetIsSoul(object oTarget);
int GetIsUndead(object oTarget);
void DevourCorruptionPenalty();
//void DoDevourDrop(object oTarget);
void DoDevourDrop(object oTarget, object oDevoured);
//void DoDevour(object oTarget, int bApplyCorruptionPenalty=TRUE, int nDevourVFX = VFX_HIT_SPELL_DEVOUR_SPIRIT);
void DoDevour(object oTarget, int bApplyCorruptionPenalty=TRUE, int nDevourVFX = VFX_HIT_SPELL_DEVOUR_SPIRIT, object oCaster = OBJECT_SELF, int bCutscene = FALSE);

void DoSpiritualEvisceration(object oTarget);

// -------------------------------------------------------
// Functions
// -------------------------------------------------------

// making this a function just in case we decide we want to tell the player
// a different way.
void PostFeedbackStrRef(object oPlayer, int iStringRef)
{
	SendMessageToPCByStrRef(OBJECT_SELF, STR_REF_INVALID_TARGET);
}

int RatioToPercent(float fRatio)
{
	return (FloatToInt(fRatio*100.0f));
	
}

float PercentToRatio(int nPercent)
{
	return (IntToFloat(nPercent)/100.0f);
}


void ApplyDeathToSpiritEater(object oTarget)
{
	if(GetIsSinglePlayer())
	{
		
		//set the variable so we know it was a spirit eater death
		SetLocalInt(oTarget, VAR_SE_DEATH, TRUE);

		//remove all roster members so that PC cannot change their player selection
		string sRoster = GetFirstRosterMember();
		while(sRoster != "")
		{
			RemoveRosterMemberFromParty(sRoster, oTarget, TRUE);
			sRoster = GetNextRosterMember();
		}
		int iTemp = 1;
		object oHenchman = GetHenchman(oTarget, iTemp);
		while( GetIsObjectValid(oHenchman))
		{
			DestroyObject(oHenchman);
			iTemp++;
			oHenchman = GetHenchman(oTarget, iTemp);
		}
	}
	else
	{
		//set the variable so we know it was a spirit eater death
		SetLocalInt(oTarget, VAR_SE_DEATH, TRUE);
		SetIsDestroyable(FALSE, FALSE, TRUE);
	}
    // Create the effect to apply
    effect eDeath = EffectDeath();

    // Create the visual portion of the effect. This is instantly
    // applied and not persistant with wether or not we have the
    // above effect.
    effect eVis = EffectVisualEffect(VFX_SPIRIT_EATER_DEATH);

    // Apply the visual effect to the target
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    // Apply the effect to the object   
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
}


// apply spirit eater stage to oTarget
void ApplySpiritEaterStage (int iStage, object oTarget)
{
	//object oTarget = GetSpiritEater();
	string sPostfix = IntToString(iStage);
	string sTemplate = "n2_it_creitem_se" + sPostfix; // spell eater level 1
	
	object oOldItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
	
	switch (iStage)
	{
		case SPIRIT_EATER_STAGE_0:
			if (GetIsObjectValid(oOldItem))
				{
				DestroyObject(oOldItem, 0.0f, FALSE); // no feedback.
				DelayCommand(1.0f, ExecuteScript("ka_se_equip_check", oTarget));
				}
			// armor slot left empty - no effect
			break;
		
		case SPIRIT_EATER_STAGE_1:
		case SPIRIT_EATER_STAGE_2:
		case SPIRIT_EATER_STAGE_3:
		case SPIRIT_EATER_STAGE_4:
		case SPIRIT_EATER_STAGE_5:	
		{		
			if (GetResRef(oOldItem) != sTemplate)
			{
				DestroyObject(oOldItem, 0.0f, FALSE);
				// might want to delay this so old item is destroyed and not 
				// first moved into inventory.
				object oNewItem = CreateItemOnObject(sTemplate, oTarget, 1, "", FALSE );
				AssignCommand(oTarget, ActionEquipItem(oNewItem, INVENTORY_SLOT_CARMOUR));
				DelayCommand(1.0f, ExecuteScript("ka_se_equip_check", oTarget));
			}				
			break;
		}			
		case SPIRIT_EATER_STAGE_6:
			// Disease has reached terminal stage.
			ApplyDeathToSpiritEater(oTarget);
			break;

		default:
			PrettyError("Invalid Spirit Eater Stage applied :" + sPostfix);
			break;
	}
}


int GetSpiritEaterStage()
{
	return GetGlobalInt(VAR_iSE_STAGE);
}

// Spirit Eater Stage is auto updated when Spirit Eater Points
// is updated.  Do no update manually
void SetSpiritEaterStage(int iStage, object oTarget)
{
	// don't bother to update if it's the same value (except for stage 6 - kill again as needed)
	int nSpiritEaterStage = GetSpiritEaterStage();
	//if ((nSpiritEaterStage != iStage) || (nSpiritEaterStage ==SPIRIT_EATER_STAGE_6))
	//{
		SetGlobalInt(VAR_iSE_STAGE, iStage);
		ApplySpiritEaterStage(iStage, oTarget);
		if(iStage < nSpiritEaterStage)
		{
			PlaySound(SFX_SE_STAGE_INCREASE);
		}
		else if(iStage > nSpiritEaterStage)
		{
			PlaySound(SFX_SE_STAGE_DECREASE);
		}
	//}		
}


// convert spirit eater points to a particular stage
// Spirit Eater points are measured on a scale from 0 to 100.
// Spirit Eater Stage is 0 (ok) to 6 (dead).
int SpiritEaterPointsToStage(float fNumPoints)
{
	int iRet;

	if (fNumPoints >= fSPIRIT_EATER_POINTS_STAGE_0)
		iRet = SPIRIT_EATER_STAGE_0;
	else if (fNumPoints >= fSPIRIT_EATER_POINTS_STAGE_1)		
		iRet = SPIRIT_EATER_STAGE_1;
	else if (fNumPoints >= fSPIRIT_EATER_POINTS_STAGE_2)		
		iRet = SPIRIT_EATER_STAGE_2;
	else if (fNumPoints >= fSPIRIT_EATER_POINTS_STAGE_3)		
		iRet = SPIRIT_EATER_STAGE_3;
	else if (fNumPoints >= fSPIRIT_EATER_POINTS_STAGE_4)		
		iRet = SPIRIT_EATER_STAGE_4;		
	else if (fNumPoints >= fSPIRIT_EATER_POINTS_STAGE_5)		
		iRet = SPIRIT_EATER_STAGE_5;
	else 		
		iRet = SPIRIT_EATER_STAGE_6;

	return iRet;
}

float GetSpiritEaterPoints()
{
	float fRet = GetGlobalFloat(VAR_fSE_POINTS);
	return(fRet);
}



// Changes to Spirit Eater Points should all route through here.
void SetSpiritEaterPoints(float fAmount)
{
	if (fAmount > fSPIRIT_EATER_POINTS_MAX)
		fAmount = fSPIRIT_EATER_POINTS_MAX;
	if (fAmount < fSPIRIT_EATER_POINTS_MIN)
		fAmount = fSPIRIT_EATER_POINTS_MIN;
		
	SetGlobalFloat(VAR_fSE_POINTS, fAmount);
    object oPlayerObject = GetSpiritEater();
	
	int iSpiritEaterStage = SpiritEaterPointsToStage(fAmount);
	SetSpiritEaterStage(iSpiritEaterStage, oPlayerObject);
    
    // update the GUI panel with the new spirit point level
    float fPosition = fAmount/fSPIRIT_EATER_POINTS_MAX;
	string sScreen = GetSpiritBarScreenName();
    SetGUIProgressBarPosition(oPlayerObject, sScreen, BAR_SPIRITBAR, fPosition);
	SetGUIProgressBarPosition(oPlayerObject, sScreen, BAR_SPIRITBAR_PAUSE, fPosition);
	
	string sOut = IntToString(FloatToInt(fPosition * 100.0f));
	SetGUIObjectText(oPlayerObject, sScreen, BAR_SE_TEXT_RATIO, -1, sOut);
    
    // set the stage icon.
    //SetGUIObjectDisabled( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_0, (iSpiritEaterStage <= 0));
	
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_1, !(iSpiritEaterStage >= 1));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_2, !(iSpiritEaterStage >= 2));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_3, !(iSpiritEaterStage >= 3));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_4, !(iSpiritEaterStage >= 4));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_5, !(iSpiritEaterStage >= 5));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_6, !(iSpiritEaterStage >= 6));

    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_1_DISABLED, (iSpiritEaterStage >= 1));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_2_DISABLED, (iSpiritEaterStage >= 2));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_3_DISABLED, (iSpiritEaterStage >= 3));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_4_DISABLED, (iSpiritEaterStage >= 4));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_5_DISABLED, (iSpiritEaterStage >= 5));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_6_DISABLED, (iSpiritEaterStage >= 6));

    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_1_TOP, !(iSpiritEaterStage == 1));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_2_TOP, !(iSpiritEaterStage == 2));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_3_TOP, !(iSpiritEaterStage == 3));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_4_TOP, !(iSpiritEaterStage == 4));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_5_TOP, !(iSpiritEaterStage == 5));
    SetGUIObjectHidden( oPlayerObject, sScreen, ICON_SPIRIT_EATER_STAGE_6_TOP, !(iSpiritEaterStage == 6));
			    
}

void UpdateSpiritEaterPoints(float fDelta)
{
	float fSpiritEaterPoints = GetSpiritEaterPoints() + fDelta;
	SetSpiritEaterPoints(fSpiritEaterPoints);
}

// corruption is a percentage applied to the base amount of spirit eater decay/hour
//  values over 1 increase the decay, while values under 1 decrease the decay.
float GetSpiritEaterCorruption()
{
	 float fRet = GetGlobalFloat(VAR_fCORRUPTION_RATE);
	 return(fRet);
}

effect ApplyEffectSubType(effect eEffect, int nEffectSubType=0)
{
	if (nEffectSubType == SUBTYPE_MAGICAL)
		eEffect = MagicalEffect(eEffect);
	else if (nEffectSubType == SUBTYPE_EXTRAORDINARY)
		eEffect = ExtraordinaryEffect(eEffect);
	else if (nEffectSubType == SUBTYPE_SUPERNATURAL)
		eEffect = SupernaturalEffect(eEffect);

	return (eEffect);
}

void SetEffect(object oObject, int bEnable, effect eEffect, int nEffectSubType=0)
{
	int nEffectType = GetEffectType(eEffect);
	if (bEnable)
	{
		if (!GetHasEffectType(oObject, nEffectType, nEffectSubType))
		{
			eEffect = ApplyEffectSubType(eEffect, nEffectSubType);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oObject);
		}			
	}
	else
	{
		if (GetHasEffectType(oObject, nEffectType, nEffectSubType))
			RemoveEffectsByType( oObject, nEffectType, nEffectSubType );
			
	}
	
}
void ApplySpiritEaterCorruptionEffects(object oTarget, float fAmount)
{
	int bDetectSpirits 	= FALSE;
	int bTrueSeeing 	= FALSE;
	int bIncorporeal 	= FALSE;
	int bEtherealness 	= FALSE;
	
	if (fAmount >=1.25)
		bDetectSpirits = TRUE;	

	if (fAmount >=2.00)
		bTrueSeeing = TRUE;	

	if (fAmount >=2.50)
		bIncorporeal = TRUE;	
		
	if (fAmount >=3.00)
		bEtherealness = TRUE;	
		
	SetEffect(oTarget, bDetectSpirits, EffectDetectSpirits(), SUBTYPE_SUPERNATURAL);
	SetEffect(oTarget, bTrueSeeing, EffectTrueSeeing(), SUBTYPE_SUPERNATURAL);
	SetEffect(oTarget, bIncorporeal, EffectConcealment(50), SUBTYPE_SUPERNATURAL);
	SetEffect(oTarget, bEtherealness, EffectEthereal(), SUBTYPE_SUPERNATURAL);
}

void SetSpiritEaterCorruption(float fAmount)
{
    object oPlayerObject = GetSpiritEater();
	if (fAmount > fSPIRIT_EATER_CORRUPTION_MAX)
		fAmount = fSPIRIT_EATER_CORRUPTION_MAX;
	if (fAmount < fSPIRIT_EATER_CORRUPTION_MIN)
		fAmount = fSPIRIT_EATER_CORRUPTION_MIN;
		
	SetGlobalFloat(VAR_fCORRUPTION_RATE, fAmount);
    ApplySpiritEaterCorruptionEffects(oPlayerObject, fAmount);
	
	int nVarIndex = 0; // variable to use on the gui screen
    string sVarValue = FloatToString(fAmount);
	string sScreen = GetSpiritBarScreenName();
	
    SetLocalGUIVariable(oPlayerObject, sScreen, nVarIndex, sVarValue);
	
    // update the craving bar (previously corruption)
	// an empty ramp indicates the player has reached minimum corruption, a full one represent he has reached the maximum.
    float fPosition = (fAmount - fSPIRIT_EATER_CORRUPTION_MIN)/(fSPIRIT_EATER_CORRUPTION_MAX - fSPIRIT_EATER_CORRUPTION_MIN);
    SetGUIProgressBarPosition(oPlayerObject, sScreen, BAR_CRAVINGBAR, fPosition);
	SetGUIProgressBarPosition(oPlayerObject, sScreen, BAR_CRAVINGBAR_PAUSE, fPosition);
}


void UpdateSpiritEaterCorruption(float fDelta)
{
	if(fDelta > 0.0)
	{
		PlaySound(SFX_SE_CORRUPTION_INCREASE);
	}
	else
	{
		PlaySound(SFX_SE_CORRUPTION_DECREASE);
	}
	float fAmount = GetSpiritEaterCorruption() + fDelta;
	SetSpiritEaterCorruption(fAmount);
}


void InitializeSpiritEater(object oPC)
{
 	//object oPC = GetSpiritEater();
	SetGlobalFloat(VAR_fCORRUPTION_RATE, fSPIRIT_EATER_CORRUPTION_START); // corruption starts at 100%
	SetGlobalFloat(VAR_fSE_POINTS, fSPIRIT_EATER_POINTS_START); // start at 100 spirit eater points
	// stage will be auto set to 0
	
	// Spirit eater effects won't be applied until spirit eater is marked as initialized
	SetGlobalInt(VAR_bSE_INITIALIZED, TRUE);
	
	oPC = SetSpiritEater(oPC); // will transfer spirit eater to oPC
	SetPreferredSpiritEater(oPC); // transfer spirit eater to this PC in the future if he is there.
    // must do this first or the updates below won't get reflected on GUI.
    //DisplaySpiritBar(oPC);
    
	//SetSpiritEaterCorruption(fSPIRIT_EATER_CORRUPTION_START); // corruption starts at 100%
	//SetSpiritEaterPoints(fSPIRIT_EATER_POINTS_START); // start at 100 spirit eater points.
	// stage will be auto set to 0
    
}

// end the spirit eater effect altogether.
// preferred PC will still be remembered
void TerminateSpiritEater()
{
 	object oPC = GetSpiritEater();
	RemoveSpiritEaterStatus(oPC);
	SetGlobalInt(VAR_bSE_INITIALIZED, FALSE);
}

// 
void UpdateSEPointsForTimePassed(int nNumHoursPassed)
{
	// spirit eater point loss applied only after initialized and only when not paused.
	if (GetIsSpiritBarPaused())
		return;
	if (!GetIsSpiritEaterInitialized())
		return;

	object oPC = GetSpiritEater();
	if (!GetIsObjectValid(oPC)) // should only happen if the server is empty
		return;
	
	// not using this since checking only if spirit eater in conversation may not be sufficient.
	// if (IsInConversation(oPC))
	// 	return;
	
	float fCorruptionRate = GetSpiritEaterCorruption();
	float fSEPointsToLose = IntToFloat(nNumHoursPassed) * fSE_BASE_HOURLY_DECAY * fCorruptionRate;
	UpdateSpiritEaterPoints(fSEPointsToLose);
}


//===================================================
// SPIRT BAR
//===================================================
string GetSpiritBarScreenName()
{
	string sScreen = GetGlobalString(VAR_SPIRIT_BAR_SCREEN);
	
	// if it isn't the minimized version, then use the normal version.
	if (sScreen != sSCREEN_GUI_SPIRIT_BAR_MIN)
		sScreen = sSCREEN_GUI_SPIRIT_BAR;
		
	return (sScreen);
}

string GetSpiritBarXMLFileName()
{
	string sXML = GetGlobalString(VAR_SPIRIT_BAR_XML);
	
	// if it isn't the minimized version, then use the normal version.
	if (sXML != sFILE_NAME_GUI_SPIRIT_BAR_MIN)
		sXML = sFILE_NAME_GUI_SPIRIT_BAR;
		
	return (sXML);
}

// Check if paused
int GetIsSpiritBarPaused()
{
	int bPause = GetGlobalInt(VAR_bSE_GUI_PAUSED);
	return (bPause);
}

int GetIsSpiritEaterInitialized()
{
	return (GetGlobalInt(VAR_bSE_INITIALIZED));
}



// Request to pause.  
void SpiritBarPauseRequest(int bPause)
{
	// ignore requests if spirit eater bar is not initialized
	if (!GetGlobalInt(VAR_bSE_INITIALIZED))
		return;

	// ignore request if we are already in the requested pasue state.
	int bCurrentlyPaused = GetIsSpiritBarPaused();
	if (bCurrentlyPaused == bPause)
		return;
		
	SpiritBarPause(bPause);
}

// pauses and unpauses the GUI
void SpiritBarPause(int bPause)
{
    object oSpiritEater = GetSpiritEater();
	SetGlobalInt(VAR_bSE_GUI_PAUSED, bPause);
    int bModal = FALSE;
	int bIsPaused = GetIsSpiritBarPaused();
	string sScreen = GetSpiritBarScreenName();
	
    PrettyDebug("SpiritBarPause :" + IntToString(bPause));
	SetGUIObjectHidden( oSpiritEater, sScreen, BAR_SPIRITBAR, bIsPaused);
	SetGUIObjectHidden( oSpiritEater, sScreen, BAR_SPIRITBAR_BG, bIsPaused);
	SetGUIObjectHidden( oSpiritEater, sScreen, BAR_CRAVINGBAR, bIsPaused);
	SetGUIObjectHidden( oSpiritEater, sScreen, BAR_CRAVINGBAR_BG, bIsPaused);
}



// Display/hide the spirit bar GUI for the specified PC
void DisplaySpiritBar(object oPC)
{
	string sXMLFileName = GetSpiritBarXMLFileName(); 
	string sScreen = GetSpiritBarScreenName();
	
	//string sXMLFileName = sFILE_NAME_GUI_SPIRIT_BAR_MIN; 
	PrettyDebug("DisplaySpiritBar() sXMLFileName=" + sXMLFileName);
    int bModal = FALSE;
    PrettyDebug("Displaying Spirit Bar GUI for " + GetName(oPC));
	DisplayGuiScreen(oPC, sScreen, bModal, sXMLFileName);
}

void CloseSpiritBar(object oPC)
{
	string sScreen = GetSpiritBarScreenName();
	CloseGUIScreen(oPC, sScreen);
}

//===================================================
// SE Application
//===================================================

// This will remove SE feats and hide the GUI
void RemoveSpiritEaterStatus(object oPC)
{
	// if not a valid object then abort
	if (!GetIsObjectValid(oPC))
		return;
		
	// checking for initialize mostly just because we don't want to 
	// remove creature armors via ApplySpiritEaterStage() because
	// other creature armors are used prior to the spirit bar which this call would affect.
	if (GetIsSpiritEaterInitialized())
	{
		ApplySpiritEaterStage(SPIRIT_EATER_STAGE_0, oPC); // Remove SE creature armor if any. 
		CloseSpiritBar(oPC);	// Get rid of SE GUI if currently displayed
		
	}
	
	
	// Remove all SE feats
	RemoveSpiritEaterFeatList(oPC);
}

// this function can be called at any time
// it will ensure that all spirit eater effects that are applied to the spirit eater 
void ApplySpiritEaterStatus(object oPC)
{
	// if not a valid object then abort
	if (!GetIsObjectValid(oPC))
		return;

	// Display SE GUI if currently initialized (state stored in globals)
	// Add creature armor if any
	if (GetIsSpiritEaterInitialized())
	{
      	// must do display first or the updates below won't get reflected on GUI.
 		DisplaySpiritBar(oPC);
		SetSpiritEaterCorruption(GetSpiritEaterCorruption());
		SetSpiritEaterPoints(GetSpiritEaterPoints());
	}
	
	// Add all SE feats that we don't already have. (state stored in globals)
	ApplySpiritEaterFeatList(oPC);
}

// return the Unique ID for the PC.  If the PC doesn't have one yet, then give it him now.
// ID's are never recycled
int GetUniqueIDofPC(object oPC)
{
	int nUniqueID = GetLocalInt(oPC, VAR_UNIQUE_ID);
	// hasn't been given an id yet, so give one now.
	if (nUniqueID == 0)
	{
		nUniqueID = ModifyGlobalInt(VAR_UNIQUE_ID_COUNT, 1);
		SetLocalInt(oPC, VAR_UNIQUE_ID, nUniqueID);
	}
	return(nUniqueID);
}


// will return the PC w/ the specified unique ID
// or object invalid if not found
object GetPCByUniqueID(int nUniqueID)
{
   	object oPC = GetFirstPC();
	int nThisID;
   	while (GetIsObjectValid(oPC) == TRUE)
   	{
   		nThisID = GetUniqueIDofPC(oPC);
		if (nThisID == nUniqueID)
			return(oPC);
      	oPC = GetNextPC();
   	}
	return (OBJECT_INVALID);	
}

// return whomever we stored as the spirit eater
// the spirt eater is set/updated when someone enters or leaves the game.
// If not yet initialized or can't find spirit eater for some reason, we default to FirstPC
// This should always return a valid object unless the server is empty.
object GetSpiritEater()
{
    // GetPrimaryPlayer() - will return invalid under many circumstances
	//return (GetFirstPC());
	object oPC = OBJECT_INVALID;
	int nUniqueID = GetGlobalInt(VAR_SE_PLAYER_UNIQUE_ID);
	if (nUniqueID == 0)
		PrettyDebug("GetSpiritEater() - Unique ID is 0!");
	else		
		oPC = GetPCByUniqueID(nUniqueID);
		
	if (!GetIsObjectValid(oPC))		
		oPC = GetFactionLeader(GetFirstPC());
	//object oOwnedPC = GetLocalObject(GetModule(), VAR_SPIRIT_BAR_PC);
	return (oPC);
}


// This is the primary way we set the spirit eater.
// it will remove SE-ness from the previous PC and 
// transfer it all to the newly specified player.
// returns the owned PC that is the actual spirit eater
object SetSpiritEater(object oPC)
{
	PrettyDebug("SetSpiritEater() - oPC (passed in) = " + GetName(oPC));
	object oOwnedPC = oPC;
	if (!GetIsOwnedByPlayer(oOwnedPC))
	{
		oOwnedPC = GetOwnedCharacter(oPC);
	}
	if (!GetIsOwnedByPlayer(oOwnedPC))
	{
		PrettyDebug("SetSpiritEater() - oOwnedPC is not owned by a PC - aborting");
		return (oPC);
	}
			
	PrettyDebug("SetSpiritEater() - oOwnedPC = " + GetName(oOwnedPC));
	
	object oPrveiousSpiritEater = GetSpiritEater();

// every time a request is sent to set the spirit eater, we need to remove spirit eaterness from the old object if it still exists.
// if this PC is already set as the spirit eater, no need to remove Spirit Eater Status
	if (oOwnedPC != oPrveiousSpiritEater)
	{ // another PC is being set, previous PC is still in the game
		RemoveSpiritEaterStatus(oPrveiousSpiritEater);
	
	}
	else
	{ 	// previous PC is not in the game -or- Spirit eater has never been set before on this module
		// if the former, then removal will be handled on next join.
		// if the latter, then no removal is necessary.
	}
	
	// remember this for later
	int nUniqueID = GetUniqueIDofPC(oOwnedPC);
	// Setting this global changes who GetSpiritEater() returns.
	// this will be needed when we ApplySpiritEaterStatus() (which will call GetSpiritEater())
	SetGlobalInt(VAR_SE_PLAYER_UNIQUE_ID, nUniqueID);
	ApplySpiritEaterStatus(oOwnedPC);
	
	
	return (oOwnedPC);
	//SetLocalObject(GetModule(), VAR_SPIRIT_BAR_PC, oOwnedPC);
}

void SetPreferredSpiritEater(object oPreferredPC)
{
	int nUniqueID = GetUniqueIDofPC(oPreferredPC);
	SetGlobalInt(VAR_PREFERRED_SE, nUniqueID);
}

object GetPreferredSpiritEater()
{
	int nUniqueID = GetGlobalInt(VAR_PREFERRED_SE);
	// run through all PC's looking for Preferred player's name.
	// return object of that PC or OBJECT_INVALID
	object oPC = GetPCByUniqueID(nUniqueID);
	return (oPC);
}


// Get who we think should be the spirit eater, taking into consideration all
// players including the one who just joined.
// if there are no PC in the game, this will return OBJECT_INVALID, otherwise
// one of the PC's will be returned.
object GetWhoShouldBeSpiritEater()
{
	object oWhoShouldBeSpiritEater = GetPreferredSpiritEater();
	
	if (!GetIsObjectValid(oWhoShouldBeSpiritEater))
	{		 
		oWhoShouldBeSpiritEater = GetPrimaryPlayer(); // - will return invalid under many circumstances
		if (!GetIsObjectValid(oWhoShouldBeSpiritEater))
			oWhoShouldBeSpiritEater = GetFirstPC();
	}
	return(oWhoShouldBeSpiritEater);
}

// Determine which character was the Spirit Eater before this PC joined the game.
object UpdateWhoIsSpiritEater()
{
	//SpawnScriptDebugger();
	// don't bother figuring out who the spirit eater is
	// if we haven't initialized it yet.
	if (!GetIsSpiritEaterInitialized())
		return OBJECT_INVALID;
		
	object oShouldBeSpiritEater = GetWhoShouldBeSpiritEater(); 
	PrettyDebug("UpdateWhoIsSpiritEater() - oShouldBeSpiritEater = " + GetName(oShouldBeSpiritEater));
	
	// this is who the spirit eater is at the moment, and may need to be changed.
	//object oCurrentSpiritEater = GetSpiritEater(); 
	
	// GetSpiritEater will return an object even if they aren't set up w/ the spirit eater, so it can't be used 
	// to check whether or not we have applied the spirit eater already.
	// so we can't do this:
	// do nothing if the person who should be SE already is.
	//if (oShouldBeSpiritEater != oCurrentSpiritEater)
	//{
	//	SetSpiritEater(oShouldBeSpiritEater);
	//}
	
	SetSpiritEater(oShouldBeSpiritEater);
	return (oShouldBeSpiritEater);
}

//===================================================
// Stage calculations
//===================================================

float GetSpiritEaterStageMinimumPoints(int nStage)
{
	float fRet = 0.0f;
	switch (nStage)
	{
		case SPIRIT_EATER_STAGE_0:
			fRet = fSPIRIT_EATER_POINTS_STAGE_0;
			break;
			
		case SPIRIT_EATER_STAGE_1:
			fRet = fSPIRIT_EATER_POINTS_STAGE_1;
			break;
			
		case SPIRIT_EATER_STAGE_2:
			fRet = fSPIRIT_EATER_POINTS_STAGE_2;
			break;
			
		case SPIRIT_EATER_STAGE_3:
			fRet = fSPIRIT_EATER_POINTS_STAGE_3;
			break;
			
		case SPIRIT_EATER_STAGE_4:
			fRet = fSPIRIT_EATER_POINTS_STAGE_4;
			break;
			
		case SPIRIT_EATER_STAGE_5:
			fRet = fSPIRIT_EATER_POINTS_STAGE_5;
			break;
			
		case SPIRIT_EATER_STAGE_6:
			fRet = fSPIRIT_EATER_POINTS_STAGE_6;
			break;
		
	}
	return (fRet);
}

float GetSpiritEaterStageMaximumPoints(int nStage)
{
	float fRet = 0.0f;
	switch (nStage)
	{
		case SPIRIT_EATER_STAGE_0:
			fRet = fSPIRIT_EATER_POINTS_MAX;
			break;
			
		case SPIRIT_EATER_STAGE_1:
			fRet = fSPIRIT_EATER_POINTS_STAGE_0;
			break;
			
		case SPIRIT_EATER_STAGE_2:
			fRet = fSPIRIT_EATER_POINTS_STAGE_1;
			break;
			
		case SPIRIT_EATER_STAGE_3:
			fRet = fSPIRIT_EATER_POINTS_STAGE_2;
			break;
			
		case SPIRIT_EATER_STAGE_4:
			fRet = fSPIRIT_EATER_POINTS_STAGE_3;
			break;
			
		case SPIRIT_EATER_STAGE_5:
			fRet = fSPIRIT_EATER_POINTS_STAGE_4;
			break;
			
		case SPIRIT_EATER_STAGE_6:
			fRet = fSPIRIT_EATER_POINTS_STAGE_5;
			break;
		
	}
	return (fRet);
}

// returns the number of points that are in the specified stage
float GetPointsInStage(int nStage)
{
	float fRet = GetSpiritEaterStageMaximumPoints(nStage) - GetSpiritEaterStageMinimumPoints(nStage);
	return (fRet);
}


// Calculate as a ratio (0.0f - 1.0f) what is remaining of the stage fSpiritEnergy is currently in.  
float GetRatioRemainingOfStage(float fSpiritEnergy)
{
	int nStage = SpiritEaterPointsToStage(fSpiritEnergy);
	float fPointsInStage = GetPointsInStage(nStage);
	float fPointsRemainingInStage = fSpiritEnergy - GetSpiritEaterStageMinimumPoints(nStage);
	
	float fRatioRemainingInStage = fPointsRemainingInStage/fPointsInStage;
	
	return (fRatioRemainingInStage);
}

float GetRatioMissingOfStage(float fSpiritEnergy)
{
	float fRet = 1.0f - GetRatioRemainingOfStage(fSpiritEnergy);
	return (fRet);
}

// Each stage measure 1.0, so 1.0 will take you to the next lower stage, 2.0 will drop by 2 stages, etc.
// negative percentages should also work to increase spirit energy.
void ReduceSpiritEaterPointsByStageRatio(float fRatioToReduce)
{
	float fSpiritEnergy = GetSpiritEaterPoints();
	int nStage = SpiritEaterPointsToStage(fSpiritEnergy);
	float fRatioMissingOfStage = GetRatioMissingOfStage(fSpiritEnergy);
	
	// find the total amount to be missing expressed as a ratio.  
	// example 1.7f means in stage 1 w/ only 30% remaining.
	float fTotalMissing = IntToFloat(nStage) + fRatioMissingOfStage + fRatioToReduce;
	
	
	int nNewStage = FloatToInt(fTotalMissing);
	float fNewRatioMissingOfStage = fTotalMissing - (IntToFloat(nNewStage));
	//nTotalPercentage%100;
	
	float fPointStartForStage = GetSpiritEaterStageMaximumPoints(nNewStage);
	float fNewPointsMissingOfStage = GetPointsInStage(nNewStage) * fNewRatioMissingOfStage;
	
	float fNewPointTotal = fPointStartForStage - fNewPointsMissingOfStage;
	SetSpiritEaterPoints(fNewPointTotal);
}

// -------------------------------------------------------
// Spirit Eater Convo pausing
// -------------------------------------------------------

// Returns whether any one in the faction is currently in conversation.
int GetIsFactionMemberInConversation(object oMemberOfFaction, int bPCOnly=TRUE)
{
	object oPartyMember = GetFirstFactionMember(oMemberOfFaction, bPCOnly);
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		if (IsInConversation(oPartyMember))
			return(TRUE);
        oPartyMember = GetNextFactionMember(oMemberOfFaction, bPCOnly);
    }
	return (FALSE);	
}

// 
void SpiritEaterConversationPauseCheck(object oPC)
{
	if (IsInConversation(oPC))
	{	
		SpiritBarPauseRequest(TRUE);
	}		
	else
	{
		// only do expensive unpause check if we are currently paused and initialized
		if (GetIsSpiritBarPaused() && GetIsSpiritEaterInitialized())
		{
			if (!GetIsFactionMemberInConversation(oPC))
			{
				SpiritBarPauseRequest(FALSE);
			}
		}
	}		
}	

void CheckAllForSEConvoPause()
{
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC))
	{
		SpiritEaterConversationPauseCheck(oPC);
		oPC = GetNextPC();
	}
}

// -------------------------------------------------------
// Spirit Eater Powers
// -------------------------------------------------------

const string VAR_SE_FEAT_LIST 		= "__SE_FEAT_LIST";
const int STRREF_NEW_FEAT_PREFIX = 208632; //"new spirit-eater feat acquired: "
const int MYFEAT_SPIRIT_EATER = 2135;	//spirit-eater history feat
//	 nFeat		= The number of the feat. See nwscript.nss for a list of feats.

// we only post notices for feats that aren't granted initially
int GetShouldPostNotice(int nFeat)
{
	return (nFeat == FEAT_DEVOUR_SOUL || nFeat == FEAT_SPIRIT_GORGE || nFeat == FEAT_RAVENOUS_INCARNATION 
		|| nFeat == FEAT_BESTOW_LIFE_FORCE || nFeat == FEAT_ETERNAL_REST || nFeat == FEAT_MOLD_SPIRIT || nFeat == FEAT_MALLEATE_SPIRIT ||
		nFeat == FEAT_SPIRITUAL_EVISCERATION || nFeat == MYFEAT_SPIRIT_EATER);
}	

int SpiritEaterFeatAdd(int nFeat)
{
    object oSpiritEater = GetSpiritEater();
    int bCheckReq = FALSE;
    int bSuccess = FeatAdd(oSpiritEater, nFeat, bCheckReq);
    PrettyDebug("Feat Add " + IntToString(nFeat) + " : " + IntToString(bSuccess));
	int nFeatStrRef = StringToInt(Get2DAString(FEATS_2DA, "Feat", nFeat));
	string sFeatName = GetStringByStrRef(nFeatStrRef);
	if(GetShouldPostNotice(nFeat))
	{
		SetNoticeText(oSpiritEater, GetStringByStrRef(STRREF_NEW_FEAT_PREFIX) + sFeatName);
	}
	// store feat addition globally
	// If the spirit eater is assigned to another player, then so to will all feats
	// add with this function.
	AppendGlobalList(VAR_SE_FEAT_LIST, IntToString(nFeat), TRUE);
	//string sList = GetGlobalString(VAR_SE_FEAT_LIST);
	//sList = AppendUniqueToList(sList, IntToString(nFeat));
	//SetGlobalString(VAR_SE_FEAT_LIST, sList);
	
    return (bSuccess);
}


// apply all feats in Spirit Eater feat list to PC
void ApplySpiritEaterFeatList(object oPC)
{
	string sList = GetGlobalString(VAR_SE_FEAT_LIST);
    int bCheckReq = FALSE;

    struct sStringTokenizer stFeatList = GetStringTokenizer(sList, ",");
    while (HasMoreTokens(stFeatList)) 
	{
        stFeatList = AdvanceToNextToken(stFeatList);
        int nFeat = StringToInt(GetNextToken(stFeatList));
		FeatAdd(oPC, nFeat, bCheckReq);
		//SpiritEaterFeatAdd(nFeat);
    }
}

// remove SE feats from specified PC
void RemoveSpiritEaterFeatList(object oPC)
{
	string sList = GetGlobalString(VAR_SE_FEAT_LIST);

    struct sStringTokenizer stFeatList = GetStringTokenizer(sList, ",");
    while (HasMoreTokens(stFeatList)) 
	{
        stFeatList = AdvanceToNextToken(stFeatList);
        int nFeat = StringToInt(GetNextToken(stFeatList));
		FeatRemove(oPC, nFeat);
    }
}


// Souls are humanoids that aren't marked as spirits.
int GetIsSoul(object oTarget)
{
	//special exception for Kaelyn, whose racial type is technically Outsider.
	if(GetTag(oTarget) == "dove")
		return TRUE;

    return (!GetIsSpirit(oTarget)
            && MatchHumanoidRacialType(GetRacialType(oTarget)));
}

// undead must both have that racial type and not be marked as spirits.
int GetIsUndead(object oTarget)
{
    return (GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD);
}

void DevourCorruptionPenalty()
{
    // only occurs if not in stage 0
  /*  if (GetSpiritEaterStage() > SPIRIT_EATER_STAGE_0)
        return;
                      
    float fPercentOfStage0 = ((GetSpiritEaterPoints() - fSPIRIT_EATER_POINTS_STAGE_0)) 
                                      /(fSPIRIT_EATER_POINTS_MAX - fSPIRIT_EATER_POINTS_STAGE_0);
    float fCorruptionDelta = fPercentOfStage0 / 4.0f;
*/
	float fCorruptionDelta = 0.f;
	// if we have already used a devour ability there is increased corruption
	if(GetGlobalInt(VAR_SE_HAS_USED_DEVOUR_ABILITY))
	{
		if(GetSpellId() == SPELLABILITY_SPIRIT_GORGE)
		{
			fCorruptionDelta = 0.5f;
		}
		else
		{
			fCorruptionDelta = 0.35f;
		}
	}
	else
	{
		if(GetSpellId() == SPELLABILITY_SPIRIT_GORGE)
		{
			fCorruptionDelta = 0.35f;
		}
	}
    UpdateSpiritEaterCorruption(fCorruptionDelta);
}

// when a creature is killed by a devour, he'll drop some spirit essence.
void DoDevourDrop(object oTarget, object oDevoured)
{
	int nNumToDrop = GetLocalInt(oDevoured, VAR_nDEVOUR_DROP_NUM);
	if (nNumToDrop < 1)
		nNumToDrop = 1;
	string sResRefToDrop = GetLocalString(oDevoured, VAR_sDEVOUR_DROP_RESREF);
	if (sResRefToDrop == "")
		sResRefToDrop = SPIRIT_VOLATILE;
	CreateItemOnObject(sResRefToDrop, oTarget, nNumToDrop);
}


void DelayedPlayCustomAnimation(object oTarg, string sAnim, int bLoop)
{
	PlayCustomAnimation(oTarg,sAnim,bLoop);
}

// damage target, increase spirit energy, increase corruption
void DoDevour(object oTarget, int bApplyCorruptionPenalty=TRUE, int nDevourVFX = VFX_HIT_SPELL_DEVOUR_SPIRIT, object oCaster = OBJECT_SELF, int bCutscene = FALSE)
{
    int nDamage, nDamagePercent;
    int nSpiritEnergyPercentBonus = nDEVOUR_BASE_ENERGY;
    
    int nTargetMaxHP = GetMaxHitPoints(oTarget);
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    nDamage = (nTargetMaxHP * nDEVOUR_MAX_ENERGY) / 100; // Target takes nDEVOUR_MAX_ENERGY% of max hp in damage.
    if (nDamage < 1)
        nDamage = 1;
        
	// visual effect on target
    effect eBeam = EffectBeam(nDevourVFX, oCaster, BODY_NODE_CHEST);
	
	if(!bCutscene)
	{
    	DelayCommand(VFX_SE_HIT_DELAY, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));		
	}
	else
	{
		DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));		
	}
		
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
		
	// if enough to kill creature, then more bonus energy!
    if (nCurrentHP <= nDamage)
    {
		nDamagePercent = (nCurrentHP * 100) / nTargetMaxHP;
		nSpiritEnergyPercentBonus += nDamagePercent;
		
		//  and also some spirit essences!
		DoDevourDrop(oCaster, oTarget);
		
		// try to do a cool "getting my soul sucked out" animation before death
		SetLocalInt(oTarget,"Focused",2);
		AssignCommand(oTarget, ClearAllActions(TRUE));
		if(!bCutscene)
		{
			DelayCommand(VFX_SE_HIT_DELAY, AssignCommand(oTarget,DelayedPlayCustomAnimation(oTarget, "mjr_conjureloop",TRUE)));
			DelayCommand(VFX_SE_HIT_DELAY + VFX_SE_HIT_DURATION, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE,TRUE,TRUE),oTarget));
		}
		
    }
    else	//not a killshot
	{
		if(!bCutscene)
		{
			//standard delay
			DelayCommand(VFX_SE_HIT_DELAY, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
		else
		{
			DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY, AssignCommand(oTarget,DelayedPlayCustomAnimation(oTarget, "mjr_conjureloop",TRUE)));
			DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY + VFX_SE_HIT_DURATION, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
	}
    
	// SpeakString(GetName(oCaster) + " is applying damgage of " + IntToString(nDamage) + " to " + GetName(oTarget));
	    // apply effects 

    // give spirit energy bonus
    UpdateSpiritEaterPoints(IntToFloat(nSpiritEnergyPercentBonus));
    
    // increase corruption for devouring
	if (bApplyCorruptionPenalty)
    	DevourCorruptionPenalty();
}

// kill target, do a spirit drop
void DoSpiritualEvisceration(object oTarget)
{
    object oCaster 	= OBJECT_SELF;

    int nTargetMaxHP = GetMaxHitPoints(oTarget);
    effect eDam = EffectDamage(nTargetMaxHP, DAMAGE_TYPE_NEGATIVE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	
	// visual effect on target
    effect eBeam = EffectBeam(VFX_HIT_SPELL_SPIRITUAL_EVISCERATION, oCaster, BODY_NODE_HAND);
    DelayCommand(VFX_SE_HIT_DELAY, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));

	DoDevourDrop(oCaster, oTarget);
}


void DoBestowLifeForce()
{
    object oCaster 	= OBJECT_SELF;
    // Apply effects to everyone in your party
    int bPCOnly = FALSE;
    object oLeader = GetFactionLeader(OBJECT_SELF);
    int nTargetMaxHP		= 0;
	int nTargetCurrentHP	= 0;
    int nCumMaxHP			= 0;
    int nCumCurrentHP		= 0;
	
 	int bIsDead = FALSE;
   	effect eHeal;
	// visual effect on target
    effect eBeam = EffectBeam(VFX_HIT_SPELL_BESTOW_LIFE, oCaster, BODY_NODE_HAND);
    effect eRaise = EffectResurrection();
 
    // PrettyDebug ("Bestow Life Force oLeader: " + GetName(oLeader));
	// Heal everyone
	object oTarget = GetFirstFactionMember(oLeader, bPCOnly);
	while (GetIsObjectValid(oTarget))
	{
		// free resurrection for dead people!
		// (dead people fail spellsIsTarget() checks)
		bIsDead = GetIsDead(oTarget);
		if (bIsDead)
		{
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
			// the res effect appears to occur synchronously.
			//bIsDead = GetIsDead(oTarget);
        	//PrettyDebug (GetName(oTarget) + " was dead. applied res and now GetIsDead() returns: " + IntToString(bIsDead));
		}
		
        //PrettyDebug ("Bestow Life Force Target: " + GetName(oTarget));
    	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
            nTargetMaxHP = GetMaxHitPoints(oTarget);
			nTargetCurrentHP = GetCurrentHitPoints(oTarget);
            nCumMaxHP += nTargetMaxHP;
            nCumCurrentHP += nTargetCurrentHP;
        
			// count everyone for cumulative party totals, but only actually heal wounded people
			// (don't want messages about healing people for 0 hit points displaying)
			if (nTargetCurrentHP < nTargetMaxHP)
			{
	            eHeal = EffectHeal(nTargetMaxHP);
				//Fire cast spell at event for the specified target
		    	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE)); // not harmful
	            
	    		DelayCommand(VFX_SE_HIT_DELAY, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
			}
		}        	
        oTarget = GetNextFactionMember(oLeader, bPCOnly);
	}
	
	// Bestow Life Spirit Energy penalty
	// spirit energy is reduced by the percentage healed of the entire party
	// relative to the stage you are in.
	// example: if party was healed by 75%, spirit energy would be reduced 3/4 of a stage.
	// Thus if only 1/2 a stage was remaining, then an additional 1/4 of the next stage would be lost.
	float fRatioRemainingHP = IntToFloat(nCumCurrentHP)/IntToFloat(nCumMaxHP); // result will be an ratio: 0.0 (all dead) to 1.0 (all fully healed)
	float fRatioMissingHP = 1.0f - fRatioRemainingHP;
	ReduceSpiritEaterPointsByStageRatio(fRatioMissingHP);
	
	// Bestow Life corrutption bonus
	// corruption is reduced by 1/5 of the percentage healed of the entire party
	// example: if party was healed by 75%, corruption would improve by -0.15
	float fCorruptionDelta = -1.0f * fRatioMissingHP / 5.0f;
    UpdateSpiritEaterCorruption(fCorruptionDelta);
}

int GetDevourTargetVFX(int nDevourID)
{
	int nDevourVFX = -1;
	
	if (nDevourID == ID_DEVOUR_SPIRIT)// Devour Spirit
	{
		nDevourVFX = VFX_HIT_SPELL_DEVOUR_SPIRIT;
	}
	else if (nDevourID == ID_DEVOUR_SOUL)// Devour Soul			
	{
		nDevourVFX = VFX_HIT_SPELL_DEVOUR_SPIRIT;
	}
	else if (nDevourID == ID_ETERNAL_REST) // Eternal Rest			
	{
		nDevourVFX = VFX_HIT_SPELL_ETERNAL_REST;
	}
	else if (nDevourID == ID_BESTOW_LIFEFORCE)
	{
		nDevourVFX = VFX_HIT_SPELL_BESTOW_LIFE;
	}
	return (nDevourVFX);
}

void DoDevourTargetVFX(int nDevourVFX, object oCaster, object oTarget)
{
	// visual effect on target
    effect eBeam = EffectBeam(nDevourVFX, oCaster, BODY_NODE_CHEST);
	DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));
}

int GetDevourCasterVFX(int nDevourID)
{
	int nCasterEffect = -1;
	
	if (nDevourID == ID_DEVOUR_SPIRIT)// Devour Spirit
	{
		nCasterEffect = VFX_CAST_SPELL_SPIRIT_EMERGE; //VFX_CAST_SPELL_DEVOUR_SPIRIT;
	}
	else if (nDevourID == ID_DEVOUR_SOUL)// Devour Soul			
	{
		nCasterEffect = VFX_CAST_SPELL_SPIRIT_EMERGE;//VFX_CAST_SPELL_DEVOUR_SPIRIT;
	}
	else if (nDevourID == ID_ETERNAL_REST || nDevourID == ID_BESTOW_LIFEFORCE) // Eternal Rest or Bestow Lifeforce
	{
		nCasterEffect = VFX_CAST_SPELL_SPIRIT_EMERGE_GOOD;
	}
	return (nCasterEffect);

}

void DoDevourCasterVFX(int nCasterEffect, object oCaster)
{
	// Visual effect on caster
	effect eCasterVis = EffectVisualEffect(nCasterEffect);
    //AssignCommand(oCaster, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster));
	// This effect seems to run on the object that is running the script, regardless of the target.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
}

void DoDevourCasterAnimations(object oCaster)
{
	PlayCustomAnimation(oCaster,"def_conjure",FALSE);
	DelayCommand(0.4f,DelayedPlayCustomAnimation(oCaster,"def_conjureloop",TRUE));
	DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY - 3.0f, DelayedPlayCustomAnimation(oCaster, "*rage",FALSE));
	DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY - 1.5f, DelayedPlayCustomAnimation(oCaster, "%",FALSE));
	DelayCommand(VFX_SE_HIT_CUTSCENE_DELAY - 1.2f, DelayedPlayCustomAnimation(oCaster, "mjr_cast",FALSE));
}