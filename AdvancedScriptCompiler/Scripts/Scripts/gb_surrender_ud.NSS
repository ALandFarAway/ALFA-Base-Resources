//gb_surrender_ud
/*
    When creature drop below percentage of HP, he surrenders and speaks w/ the nearest PC
	
	How to use:
	make copy of this script and assign it and gb_surrender_sp to creature.
	works best if creature is immortal
	
*/

#include "x0_i0_partywide"  //has SurrenderAllToEnemies()
#include "ginc_misc"


const float HP_PERCENT_SURRENDER = 25.0f;


void main()
{
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1001) //HEARTBEAT
    {

    }
    else if(nUser == 1002) // PERCEIVE
    {

    }
    else if(nUser == 1003) // END OF COMBAT
    {

    }
    else if(nUser == 1004) // ON DIALOGUE
    {

    }
    else if(nUser == 1005) // ATTACKED
    {

    }
    else if(nUser == 1006) // DAMAGED
    {
		if (IsMarkedAsDone())
			return;

        int nMaxHP = GetMaxHitPoints();
        int nCurrHP = GetCurrentHitPoints();
		
        int nPercentofMaxHP = FloatToInt((IntToFloat(nMaxHP) * (HP_PERCENT_SURRENDER/100.0f)));

         // * generic surrender should only fire once
        if((GetIsDead(OBJECT_SELF) == FALSE) && ((nCurrHP <= nPercentofMaxHP) || (nCurrHP <=1)))
        {
 			MarkAsDone();
           	PrintString (GetName(OBJECT_SELF) + " surrenders!");
            SurrenderAllToEnemies(OBJECT_SELF);
			object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
            SurrenderAllToEnemies(oPC);
			
			ActionStartConversation(oPC);

        }
    }
    else if(nUser == 1007) // DEATH
    {

    }
    else if(nUser == 1008) // DISTURBED
    {

    }

}

