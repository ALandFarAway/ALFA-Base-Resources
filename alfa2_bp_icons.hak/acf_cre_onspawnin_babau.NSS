////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acf_cre_onspawnin
//    $Revision:: 280        $ current version of the file
//        $Date:: 2007-03-20#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix:
//  Dependencies:
//
//  Description
//  This script calls the ACR's OnSpawnIn event handler for creatures
//  and any custom code a server may need. It is not updated in ACR updates.
//
//  Revision History
//    2010/11/17  AcadiusLost - Autodisabled flocking on creatures without a "parent" spawn point.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_creature_i"
#include "NW_I0_GENERIC"
#include "NW_O2_CONINCLUDE"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int USE_SPECIAL_ABILITY=75;


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


void main()
{
	int animal_lvls;
	object oCreature = OBJECT_SELF;
	
	ACR_CreatureOnSpawnIn();

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageShield(0, DAMAGE_BONUS_1d4, DAMAGE_TYPE_ACID)), OBJECT_SELF);
					
	// animal hack. modify AI for animals 
	animal_lvls = GetLevelByClass(CLASS_TYPE_ANIMAL);
	
	if (GetLocalInt(OBJECT_SELF,"ACR_CRE_WILD_ANIMAL") && (animal_lvls > 0)) {
		SetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL,TRUE);
		if (animal_lvls > 1)
			SetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE,TRUE);
		else
			SetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE,TRUE);	    
	}
		
	// animation code
	if (GetLocalInt(OBJECT_SELF,"USE_IMMOBILE_AMBIENT_ANIM"))
	{
		float fRand=IntToFloat(d6(3));
		DelayCommand(fRand,ExecuteScript("dpss_ambient_anim",OBJECT_SELF));
	}


	// This causes some lag per hb.  Probably not enough to worry, though. (and looks nice)
	SetLocalInt(OBJECT_SELF, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE", 1);
	
	// add glow if glowing
	if (GetLocalInt(OBJECT_SELF, "ACR_EFFECT_GLOW_BLUE")) 
	{
		
		effect eGlow = SupernaturalEffect( EffectVisualEffect( VFX_DUR_GLOW_LIGHT_BLUE ) );
	    ApplyEffectToObject( DURATION_TYPE_PERMANENT,eGlow,OBJECT_SELF );
		
	    effect eLight = SupernaturalEffect( EffectVisualEffect( VFX_DUR_LIGHT_BLUE_20 ) );
	    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight,OBJECT_SELF );

	}
	
	// freeze if needed
	if (GetLocalInt(OBJECT_SELF, "ACR_EFFECT_FREEZE")) 
	{	
		effect eFreeze = SupernaturalEffect( EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ) );
		ApplyEffectToObject( DURATION_TYPE_PERMANENT,eFreeze,OBJECT_SELF );
		SetIsDestroyable( FALSE,FALSE,FALSE );
		
						
		SetCommandable (FALSE, OBJECT_SELF);
		SetPlotFlag (OBJECT_SELF, TRUE);
   	 	SetOrientOnDialog(OBJECT_SELF, FALSE);
		
		effect eFX = EffectDeath();
		ApplyEffectToObject( DURATION_TYPE_INSTANT,eFX,OBJECT_SELF );
	}
	
	if (GetLocalInt(OBJECT_SELF, "X2_L_IS_INCORPOREAL")) {
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(50, DAMAGE_POWER_PLUS_ONE, 0, DR_TYPE_MAGICBONUS)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(50)), oCreature);
		effect eGhost = ExtraordinaryEffect(EffectCutsceneGhost());
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
		int nDeflection = GetAbilityModifier(ABILITY_CHARISMA, oCreature);
		if(nDeflection < 1) nDeflection = 1;
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nDeflection, AC_DEFLECTION_BONUS)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 50)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ENTANGLE)), oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN)), oCreature);
		FeatAdd(oCreature, FEAT_WEAPON_FINESSE, FALSE, FALSE, FALSE);
		// no collision because we're cool.
		SetCollision(OBJECT_SELF,0);
	}
	
	if (GetLocalInt(OBJECT_SELF, "ACR_EFFECT_NO_COLLISION"))
	{
		SetCollision(OBJECT_SELF,0);
	}


	// Hack to make NPC/friendlies not waste cycles on a good AI
	if (!GetFactionEqual(OBJECT_SELF, GetObjectByTag("hostile_faction_pig",0)))
		SetLocalInt(OBJECT_SELF,"ACR_NPC", 1);


	// Display names with modified color
	if (	GetLocalInt(OBJECT_SELF, "ACR_NPC") && 
		GetIsPlayableRacialType(OBJECT_SELF) &&
		!GetLocalInt(OBJECT_SELF, "ACR_NAME_TAG_IGNORE") &&
		animal_lvls == 0) {
		SetFirstName(OBJECT_SELF, "<c=#fffaaa>"+GetName(OBJECT_SELF)+"</c>");
		SetLastName(OBJECT_SELF, "");
	}

}