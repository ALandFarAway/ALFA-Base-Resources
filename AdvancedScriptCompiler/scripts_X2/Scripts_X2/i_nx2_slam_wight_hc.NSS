// i_nx2_slam_wight_hc
/*
   Template for an On Hit Cast Spell item script.
   This script runs when the item (a weapon) successfully hits an opponenet.
   
   How to use this script:
   Item needs an item property that will cause a custom activation on hit such as On Hit Cast Spell - Unique Power(on hit)
   Replace the word "temp" (in line 1) with the tag of the item.  Rename the script with this name.  
    
   Additional Info:
   In general, all the item "tag-based" scripts will be named as follows:
   - a prefix ("i_" by defualt)
   - the tag of the item
   - a postfix indicating the item event.
   
   This script will be called automatically (by defualt) whether it exists or not.  If if does not exist, nothing happens.
   
   Note: this script runs on the creature wielding the weapon item.
   -ChazM
*/
// JSH-OEI 01/29/08

void main()
{
	object oItem  		= GetSpellCastItem();    // The item casting that triggered this spellscript
	object oSpellOrigin = OBJECT_SELF ;
	object oSpellTarget = GetSpellTargetObject();

 	effect eLevelDrain	= EffectNegativeLevel(1);
	effect eTempHP		= EffectTemporaryHitpoints(5);
	eLevelDrain			= SupernaturalEffect(eLevelDrain);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLevelDrain, oSpellTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oSpellOrigin, HoursToSeconds(24));
}