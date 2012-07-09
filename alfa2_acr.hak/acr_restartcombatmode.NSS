////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_restartcombatmode.nss
//    $Revision:: x        $ current version of the file
//        $Date:: 2009-07-22#$ date the file was created or modified
//       Author : Creslyn & AcadiusLost
//
//   Var Prefix : ACR_NLD
//  Dependencies:
//
//  Description
//  This script restarts stat adjustments for combat modes after they've been
//  disabled by spellhooking.
//
//  Revision History

#include "acr_combat_actions_i"

void main()
{
    DeleteLocalInt(OBJECT_SELF, POST_SPELLCAST_NO_COMBAT_MODE);
    int nMode = GetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);

    int nAction = GetCurrentAction(OBJECT_SELF);
    if(nAction == ACTION_CASTSPELL ||
       nAction == ACTION_ITEMCASTSPELL)
    {
        // There's another spell coming up. We don't provide bonuses now, 
        // but we re-check each round for a lack of more spells.
        // We check here, and -not- in spellhooking to account for spells that
        // get canceled by whatever means.
        DelayCommand(6.0f, ExecuteScript("acr_restartcombatmode", OBJECT_SELF));
        return;
    }
    if(nMode > 0)
    {
        FightWithExpertise(OBJECT_SELF, nMode);
    }
}