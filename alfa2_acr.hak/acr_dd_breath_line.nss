//::///////////////////////////////////////////////
//:: Line Type Breath Weapons for Dragon Disciples
//:: acr_dd_breath_line
//:: Written by: Solorokai
//:://////////////////////////////////////////////


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
	if (!X2PreSpellCastCode())
	{
		return;			// If code withing PreSpellCaseHook (i.e., UMD) reports FALSE, do not run this spell
	}

	// Determine breath damage
	int nLevel = GetLevelByClass( CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF);
	int nDamageDice;
    if (nLevel <7)
    {
        nDamageDice = 2;
    }
    else if (nLevel <10)
    {
        nDamageDice = 4;
    }
    else if (nLevel ==10)
    {
        nDamageDice = 6;
    }
    else
    {
      nDamageDice = 6+((nLevel -10)/3);
    }
    int nDamage = d8(nDamageDice);	// Possible max damage (before reflex saves)

	// Determine Save DC
	int nSaveDC = 10 + nLevel + GetAbilityModifier( ABILITY_CONSTITUTION, OBJECT_SELF);

	// Determine Breath Weapon Damage Type/Visuals
	int nSpellId= GetSpellId();
    int nVis;
    int nType;
    int nSave;
	int nBreath;
	int nBeam;

	if (nSpellId == 1908) // fire
    {
        nVis = VFX_IMP_FLAME_S;
        nType = DAMAGE_TYPE_FIRE;
        nSave = SAVING_THROW_TYPE_FIRE;
		nBreath = VFX_DUR_CONE_FIRE;
		nBeam = VFX_BEAM_FIRE;
    }
    else if (nSpellId == 1909) // lightning
    {
        nVis = VFX_HIT_SPELL_LIGHTNING;
        nType = DAMAGE_TYPE_ELECTRICAL;
        nSave = SAVING_THROW_TYPE_ELECTRICITY;
		nBreath = VFX_DUR_CONE_LIGHTNING;
		nBeam = VFX_BEAM_LIGHTNING;
    }
    else if (nSpellId == 1910) // cold
    {
        nVis = VFX_IMP_FROST_S;
        nType = DAMAGE_TYPE_COLD;
        nSave = SAVING_THROW_TYPE_COLD;
		nBreath = VFX_DUR_CONE_ICE;
		nBeam = VFX_BEAM_COLD;
    }
    else // acid
    {
        nVis = VFX_IMP_ACID_S;
        nType = DAMAGE_TYPE_ACID;
        nSave = SAVING_THROW_TYPE_ACID;
		nBreath = VFX_DUR_CONE_ACID;
		nBeam = VFX_BEAM_ACID;
    }

	//Declare major variables
	int nPersonalDamage;		// Damage actually applied (after reflex saves)
	effect eDamage;
    effect eVis = EffectVisualEffect(nVis);		// Visual effect from taking damage from spell
	effect eBreath = EffectVisualEffect(nBreath);	// Visual effect of caster breathing <- PLACEHOLDER EFFECT!	
	//Set the lightning stream to start at the caster's hands
    effect eBeam = EffectBeam(nBeam, OBJECT_SELF, BODY_NODE_HAND);
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
	location lTarget2 = GetSpellTargetLocation();
	
	//string sTarget2 = "wp_lbolttrgt2";
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPoint, 1.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
	//CreateObject(OBJECT_TYPE_WAYPOINT, sTarget2, lTarget2);
	//object oPoint = GetObjectByTag(sTarget2);
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPoint, 1.0);
	//PrettyDebug("Lightning bolt!  Woo Hoo!");
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 60.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 60.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		//PrettyDebug("investigating target " + GetName(oTarget));
         while (GetIsObjectValid(oTarget))
        {
           //Exclude the caster from the damage effects
           if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
           {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
                   //Make an SR check
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	       {
        		        
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        nPersonalDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),nSave);
                        //Set damage effect
                        eDamage = EffectDamage(nPersonalDamage, nType);
                        if(nDamage > 0)
                        {
                            fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        }
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eBeam = EffectBeam(nBeam, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 60.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}
