// ga_rest_convo
/*
    master script for conversation "rest"
*/
// 
// ChazM 4/5/07 - change to use string ref

// #include "ginc_actions"
#include "ginc_restsys"

void main(int nAction)
{
    object oPC = GetPCSpeaker();

    switch ( nAction )
    {

        case 100:	// set up token
		{
			int nProb = WMGetWanderingMonsterProbability(oPC);
			int nResRef = WMGetRestStringRef(nProb);
			string sRestSafety = GetStringByStrRef(nResRef);
			SetCustomToken (99, sRestSafety);
			break;
		}
        case 200:	//
			break;

        case 300:	//
			break;

        case 400:	//
			break;

        case 500:	//
			break;
    }

}