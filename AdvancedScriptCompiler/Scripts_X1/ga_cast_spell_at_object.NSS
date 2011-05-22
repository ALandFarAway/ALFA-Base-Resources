// ga_cast_spell_at_object(float fSecondsDelay, string sCaster, int nSpell, string sSpellTarget, int nMetaMagic, int bCheat, int nDomainLevel, int nProjectilePathType, int bInstantSpell)
/*
	Description:
	Has sCaster cast a spell at sSpellTarget
	
	Parameters:
		float fSecondsDelay - Delay before casting
    	string sCaster  	- The caster's tag or identifier, if blank use Dialog Owner. see "ginc_param_const" for TARGET_* constants 
	    int nSpell			- spell ID. see NWSCRIPT.nss for SPELL_* constants
	    string sSpellTarget	- The caster's tag or identifier, if blank use PC Speaker. see "ginc_param_const" for TARGET_* constants 
	    int nMetaMagic 		- Metamagic to use.  use -1 for the standard default of METAMAGIC_ANY. 0 = METAMAGIC_NONE. see NWSCRIPT.nss for METAMAGIC_* constants 
	    int bCheat 			- If this is 1, then the executor of the action doesn't have to be able to cast the spell. 
	    int nDomainLevel 	- Should define the caster level
	    int nProjectilePathType - 0 = PROJECTILE_PATH_TYPE_DEFAULT. see NWSCRIPT.nss for PROJECTILE_PATH_TYPE_* constants
	    int bInstantSpell 	- If this is 1, the spell is cast immediately.
*/
// ChazM 4/26/07

#include "ginc_param_const"

void main(float fSecondsDelay, string sCaster, int nSpell, string sSpellTarget, int nMetaMagic, int bCheat, int nDomainLevel, int nProjectilePathType, int bInstantSpell)
{
	object oCaster = GetTarget(sCaster, TARGET_OWNER);
	object oSpellTarget = GetTarget(sSpellTarget, TARGET_PC_SPEAKER);
	
	if (nMetaMagic == -1)
		nMetaMagic = METAMAGIC_ANY;
		
	AssignCommand(oCaster, DelayCommand(fSecondsDelay, ActionCastSpellAtObject(nSpell, oSpellTarget, nMetaMagic, bCheat, nDomainLevel, nProjectilePathType, bInstantSpell)));
	
}