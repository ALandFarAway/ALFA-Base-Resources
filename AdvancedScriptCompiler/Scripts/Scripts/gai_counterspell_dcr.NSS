//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_counterspell_dcr
//::
//::	Determine Combat Round for the Spell Queue AI.
//::
//::        Spell Queue AI's will cast spells form an ordered list attached to them.
//::		To Attach a list, use the function ******, the conversation script ******,
//::		or manually using these variables (must be done pre-spawn) *******.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/30/06

#include "nw_i0_generic"
#include "x2_inc_switches"
#include "ginc_param_const"
#include "ginc_ai"
#include "nw_i0_plot"

//#include "ginc_debug"


object GetSuitableSpellCaster()
{
	object oWiz=GetNearestCreature(CREATURE_TYPE_CLASS,CLASS_TYPE_WIZARD,OBJECT_SELF,1,CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,CREATURE_TYPE_IS_ALIVE,TRUE);
	object oSor=GetNearestCreature(CREATURE_TYPE_CLASS,CLASS_TYPE_SORCERER,OBJECT_SELF,1,CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,CREATURE_TYPE_IS_ALIVE,TRUE);
	if (!GetIsObjectValid(oWiz))
		return oSor;
	if (!GetIsObjectValid(oSor))
		return oWiz;
	if ((GetDistanceBetween(OBJECT_SELF,oSor))<(GetDistanceBetween(OBJECT_SELF,oWiz)))
		return oSor;
	else
		return oWiz;
}
	
void main()
{
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget(); //Handling Determine Combat round red tape
	
	int nDebuf=-1;
	if (GetHasSpell(SPELL_GREATER_DISPELLING))
		nDebuf=SPELL_GREATER_DISPELLING;
	else if (GetHasSpell(SPELL_DISPEL_MAGIC))
		nDebuf=SPELL_DISPEL_MAGIC;
	else if (GetHasSpell(SPELL_LESSER_DISPEL))
		nDebuf=SPELL_LESSER_DISPEL;

	if (nDebuf!=-1)
	{
		//check for enemy buffs
		object oTemp,oCaster;		
		int i=0;
		float fDist=0.0f;
		effect eFX;
		while ((fDist<13.0f) && (GetIsObjectValid(oTemp=GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,OBJECT_SELF,++i,CREATURE_TYPE_IS_ALIVE,TRUE))))
		{
			fDist=GetDistanceBetween(OBJECT_SELF,oTemp);
			eFX=GetFirstEffect(oTemp);
			while(GetIsEffectValid(eFX))
			{
				oCaster=GetEffectCreator(eFX);
				if (GetReputation(oCaster,oTemp)>10)	//if they are friends... probably a buff.
				{
//					PrettyMessage("Debuffing!");
					__TurnCombatRoundOn(TRUE);
					ActionCastSpellAtObject(nDebuf,oTemp,METAMAGIC_ANY);	
					__TurnCombatRoundOn(FALSE);
	    			SetCreatureOverrideAIScriptFinished();//Tell Determine Combat Round That I handled things.
					return;
				}
				eFX=GetNextEffect(oTemp);
			}			
		}	
	
		//
		//ok, no buffs. Go in Counterspell mode for nearby spellcasters
		object oSpellCaster=GetSuitableSpellCaster();	
		if ((GetDistanceBetween(oSpellCaster,OBJECT_SELF)>10.0f)||(!GetIsObjectValid(oSpellCaster)))
			return;//standard DCR
		else if (!GetActionMode(OBJECT_SELF,ACTION_MODE_COUNTERSPELL))
			{
//				PrettyDebug("Trying to perform CounterSpell on: " + GetTag(oSpellCaster));
				SetActionMode(OBJECT_SELF,ACTION_MODE_COUNTERSPELL,TRUE);
				__TurnCombatRoundOn(TRUE);
				ActionCounterSpell(oSpellCaster);	
				__TurnCombatRoundOn(FALSE);
	    		SetCreatureOverrideAIScriptFinished();//Tell Determine Combat Round That I handled things.
				return;
			}
	}
	//otherwise standard DCR
}
