// gb_assoc_block
/*
    Associate On Blocked
    
    This will cause blocked creatures to open
    or smash down doors depending on int and str.
*/
// ChazM 2/15/07

void main()
{
    object oDoor = GetBlockingDoor();
    int nInt = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);
    int nStr = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH);

    if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) &&  nInt >= 3) {
        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
    }

    else if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && nStr >= 16) {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}