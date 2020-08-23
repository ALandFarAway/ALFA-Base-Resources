//:://////////////////////////////////////////////////////////////////////////
//:: Draconic Energy Immunity
//:: Solorokai
//:: 9/21/2007
//:://////////////////////////////////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// Determine Immunity Type
	int nSpellId= GetSpellId();
    int nImmu;

    if (nSpellId == 1904) // lightning
    {
		nImmu = DAMAGE_TYPE_ELECTRICAL;
        }
	else if (nSpellId == 1905) // cold
    {
		nImmu = DAMAGE_TYPE_COLD;
        }	
	else if (nSpellId == 1906) // acid
    {
		nImmu = DAMAGE_TYPE_ACID;
        }

    //Declare major variables   
	effect eImmu = SupernaturalEffect(EffectDamageResistance(nImmu, 9999, 0));
	
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmu, OBJECT_SELF);
}
