//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Monster Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 05/30/2006:
//::	Changed summon animals.
//::	Changed duration from 24 hours to 3 + 1 round/lvl.
//:://////////////////////////////////////////////
//:: BDF-OEI 06/27/2006:
//::	Added support for SPELL_SHADES_TARGET_GROUND in GetCreatureAnimalDomain
//::	Modified to allow 

effect SetSummonEffect(int nSpellID);
string GetCreature( int nSpellID );
string GetCreatureAnimalDomain( int nSpellID );
int GetEffectID( int nSpellID );


#include "x2_inc_spellhook"
#include "acr_i" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nSpellID = GetSpellId();
    int nDuration = GetCasterLevel(OBJECT_SELF) + 3;
    if(GetHasFeat(FEAT_GOOD_DOMAIN_POWER)) nDuration++;
    else if(GetHasFeat(FEAT_EVIL_DOMAIN_POWER)) nDuration++;
    else if(GetHasFeat(FEAT_LAW_DOMAIN_POWER)) nDuration++;
    else if(GetHasFeat(FEAT_CHAOS_DOMAIN_POWER)) nDuration++;
    effect eSummon = SetSummonEffect(nSpellID);

    //Make metamagic check for extend
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
    //Apply the VFX impact and summon effect

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(),RoundsToSeconds(nDuration));
}


effect SetSummonEffect(int nSpellID)
{
 	int nFNF_Effect = GetEffectID( nSpellID );
  
    string sSummon = "c_cat";

	/*
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER)) //WITH THE ANIMAL DOMAIN
    {
		sSummon = GetCreatureAnimalDomain( nSpellID );
    }
    else  //WITOUT THE ANIMAL DOMAIN
    {
  		sSummon = GetCreatureAnimalDomain( nSpellID );
    }
	*/
	
	sSummon = GetCreatureAnimalDomain( nSpellID );
    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
    return eSummonedMonster;
}



string GetCreatureAnimalDomain( int nSpellID )
{
	int nRoll = d4();
	string sSummon = "c_dogwolf";
	
	switch (nSpellID)
	{
	case (SPELL_SUMMON_CREATURE_I):
       {
           sSummon = "c_dogwolf";
       }
	break;
	case (SPELL_SUMMON_CREATURE_II):
       {
           //sSummon = "c_badgerdire"; // HACK, pulled for the March '06 demo; model needs re-exported
           sSummon = "c_badgerdire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_III):
       {
           sSummon = "c_dogwolfdire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_IV):
       {
		   sSummon = "c_boardire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_V):
       {
           sSummon = "c_dogshado";
       }
	break;
    case (SPELL_SUMMON_CREATURE_VI):
       {
           sSummon = "c_beardire";
       }
	break;
	case (SPELL_SUMMON_CREATURE_VII):
       {
           switch (nRoll)
           {
               case 1:	sSummon = "c_elmairhuge";		break;
               case 2:	sSummon = "c_elmfirehuge";		break;
               case 3:	sSummon = "c_elmearthhuge";		break;
               case 4:	sSummon = "c_elmwaterhuge";		break;
           }
       }
	break;
	case (SPELL_SUMMON_CREATURE_VIII):
  	case (SPELL_SHADES_TARGET_GROUND):
     {
           switch (nRoll)
           {
               case 1:	sSummon = "c_elmairgreater";		break;
               case 2:	sSummon = "c_elmfiregreater";		break;
               case 3:	sSummon = "c_elmearthgreater";		break;
               case 4:	sSummon = "c_elmwatergreater";		break;
           }
       }
	break;
	case (SPELL_SUMMON_CREATURE_IX):
       {
         switch (nRoll)
          {
               case 1:	sSummon = "c_elmairelder";		break;
               case 2:	sSummon = "c_elmfireelder";		break;
               case 3:	sSummon = "c_elmearthelder";		break;
               case 4:	sSummon = "c_elmwaterelder";		break;
           }
       }
	break;
	}
	return sSummon;
}


string GetCreature( int nSpellID )
{
	int nRoll = d3();
	string sSummon = "c_chicken";

	switch ( nSpellID )
	{
	case (SPELL_SUMMON_CREATURE_I):
        {
            sSummon = "c_badger";
        }
	break;
	case (SPELL_SUMMON_CREATURE_II):
		{
            sSummon = "c_boar";
        }
	break;
	case (SPELL_SUMMON_CREATURE_III):
        {
            sSummon = "c_dogwolf";
        }
	break;
	case (SPELL_SUMMON_CREATURE_IV):
        {
            sSummon = "c_bear";
        }
	break;
	case (SPELL_SUMMON_CREATURE_V):
        {
            sSummon = "c_doghell";
        }
	break;
	case (SPELL_SUMMON_CREATURE_VI):
        {
            sSummon = "c_bugbear";
        }
	break;
	case (SPELL_SUMMON_CREATURE_VII):
        {
            switch (nRoll)
            {
               case 1:	sSummon = "c_impfire";		break;
               case 2:	sSummon = "c_impice";		break;
               case 3:	sSummon = "c_ratdire";		break;
            }
        }
	break;
	case (SPELL_SUMMON_CREATURE_VIII):
  	case (SPELL_SHADES_TARGET_GROUND):
        {
            switch (nRoll)
            {
               case 1:	sSummon = "c_impfire";		break;
               case 2:	sSummon = "c_impice";		break;
               case 3:	sSummon = "c_ratdire";		break;
            }
        }
	break;
	case (SPELL_SUMMON_CREATURE_IX):
        {
            switch (nRoll)
            {
               case 1:	sSummon = "c_impfire";		break;
               case 2:	sSummon = "c_impice";		break;
               case 3:	sSummon = "c_ratdire";		break;
            }
        }
	break;
	}

	return sSummon;
}

int GetEffectID( int nSpellID )
{
	return VFX_HIT_SPELL_SUMMON_CREATURE;
/* - BCH 03/10/06, all summon effects now have the same vfx associated with them.
	int nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;

	if(nSpellID == SPELL_SUMMON_CREATURE_I)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_II)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_III)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_IV)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_V)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_VI)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_VII)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_VIII)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
	}
	else if(nSpellID == SPELL_SUMMON_CREATURE_IX)
	{
	    nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
	}

	return nFNF_Effect;
*/
}