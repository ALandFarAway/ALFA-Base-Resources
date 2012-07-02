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
    object oUser = OBJECT_SELF;
    int nMode = GetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
    if(nMode > 0)
    {
        FightWithExpertise(OBJECT_SELF, nMode);
    }
}