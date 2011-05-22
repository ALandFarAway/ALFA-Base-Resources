// gc_class_level(int nClass, string sLevelCheck, string sTarget)
/*
	This script checks to see if a character has a certain number of levels of a particular class.
	Parameters:
    int nClass  		= The CLASS_TYPE_* integer of the class to check for.
    string sLevelCheck 	= The level to check for this class.
						  You can specify <, >, =, or !
                          e.g. sLevelCheck of "<12" returns TRUE if level in the class is <12
                          a sLevelCheck of "9" or "=9" returns TRUE if level in the class is exactly 9
                          and a sLevelCheck of "!0" returns TRUE if level in the class is not equal to 0.
                          Default value if left blanck is "!0"
    string sTarget    	= Tag or identifier of Target. If blank then use PC Speaker.
		
	Example 1:
	Check if PC Speaker is a monk (has any levels of monk):
	gc_class_level(5, "", "")

	Example 2:
	Check if PC Speaker is at least a 15th level wizard:
	gc_class_level(10, ">14", "")

The complete list of class type constants can be found in NWScript.		
Below is a partial list
// ----------------------------------
int CLASS_TYPE_BARBARIAN = 0;
int CLASS_TYPE_BARD      = 1;
int CLASS_TYPE_CLERIC    = 2;
int CLASS_TYPE_DRUID     = 3;
int CLASS_TYPE_FIGHTER   = 4;
int CLASS_TYPE_MONK      = 5;
int CLASS_TYPE_PALADIN   = 6;
int CLASS_TYPE_RANGER    = 7;
int CLASS_TYPE_ROGUE     = 8;
int CLASS_TYPE_SORCERER  = 9;
int CLASS_TYPE_WIZARD    = 10;
int CLASS_TYPE_WARLOCK	 = 39;

int CLASS_TYPE_SHADOWDANCER 	= 27;
int CLASS_TYPE_HARPER 			= 28;
int CLASS_TYPE_ARCANE_ARCHER 	= 29;
int CLASS_TYPE_ASSASSIN 		= 30;
int CLASS_TYPE_BLACKGUARD 		= 31;
int CLASS_TYPE_DIVINECHAMPION   = 32;
int CLASS_TYPE_WEAPON_MASTER    = 33;
int CLASS_TYPE_PALEMASTER       = 34;
int CLASS_TYPE_SHIFTER          = 35;
int CLASS_TYPE_DWARVENDEFENDER  = 36;
int CLASS_TYPE_DRAGONDISCIPLE   = 37;

// New Classes - NWN2
int CLASS_TYPE_ARCANETRICKSTER 	= 40;
int CLASS_TYPE_FRENZIEDBERSERKER= 43;
int CLASS_TYPE_SHADOWTHIEFOFAMN = 46;
int CLASS_NWNINE_WARDER			= 47;		// AFW-OEI 04/18/2006
int CLASS_TYPE_DUELIST			= 50;		// AFW-OEI 04/18/2006
int CLASS_TYPE_WARPRIEST		= 51;		// AFW-OEI 05/20/2006
int CLASS_TYPE_ELDRITCH_KNIGHT  = 52;		// AFW-OEI 05/22/2006

// New Classes - NX1
int CLASS_TYPE_SACRED_FIST 		= 45
int CLASS_TYPE_RED_WIZARD 		= 53
int CLASS_TYPE_ARCANE_SCHOLAR 	= 54
int CLASS_TYPE_SPIRIT_SHAMAN 	= 55
int CLASS_TYPE_STORMLORD 		= 56
int CLASS_TYPE_INVISIBLE_BLADE 	= 57
int CLASS_TYPE_FAVORED_SOUL 	= 58

// New Classes - NX2
int CLASS_TYPE_SWASHBUCKLER		= 59
int CLASS_TYPE_DOOMGUIDE		= 60

// Monster Classes
int CLASS_TYPE_ABERRATION 		= 11;
int CLASS_TYPE_ANIMAL    		= 12;
int CLASS_TYPE_CONSTRUCT 		= 13;
int CLASS_TYPE_HUMANOID  		= 14;
int CLASS_TYPE_MONSTROUS		= 15;
int CLASS_TYPE_ELEMENTAL 		= 16;
int CLASS_TYPE_FEY       		= 17;
int CLASS_TYPE_DRAGON    		= 18;
int CLASS_TYPE_UNDEAD    		= 19;
int CLASS_TYPE_COMMONER  		= 20;
int CLASS_TYPE_BEAST     		= 21;
int CLASS_TYPE_GIANT     		= 22;
int CLASS_TYPE_MAGICAL_BEAST 	= 23;
int CLASS_TYPE_OUTSIDER  		= 24;
int CLASS_TYPE_SHAPECHANGER 	= 25;
int CLASS_TYPE_VERMIN    		= 26;
int CLASS_TYPE_OOZE 			= 38;


// ----------------------------------

*/
// ChazM 5/14/07

#include "ginc_var_ops"
#include "ginc_param_const"

int StartingConditional(int nClass, string sLevelCheck, string sTarget)
{
    object oTarget = GetTarget(sTarget, TARGET_PC_SPEAKER);

	int nClassLevel = GetLevelByClass(nClass, oTarget);
	if (sLevelCheck == "")
		sLevelCheck = "!0";
	
    int nRet = CompareInts(nClassLevel, sLevelCheck);

	return (nRet);
}