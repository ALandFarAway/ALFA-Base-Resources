////////////////////////////////////////////////////////////////////////////////
//
//  System Name : 
//     Filename : 
//    $Revision:: 
//        $Date:: 
//       Author : 
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_trigger_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The main event handler.
void main();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


/*
 3500 = dwarf
 3501 = elf
 3502 = gnome
 3503 = halfling
 3504 = half elf
 3505 = half orc
 3506 = human
 3507 = aasimar
 3508 = tiefling
 3509 = sun elf
 3510 = wood elf
 3511 = drow
 3512 = svirfneblin
 3513 = gold dwarf
 3514 = duergar
 3515 = strongheart
 3516 = wild elf
 3517 = earth genasi
 3518 = fire genasi
 3519 = air genasi
 3520 = water genasi
 3521 = half drow
 3522 = yuanti
*/

void _SwimToWalk(object oPC)
{
    int nAppearance = GetAppearanceType(oPC);
    if(nAppearance < 3500)  return;
    if(nAppearance == 3500) nAppearance = 0;
    if(nAppearance == 3501) nAppearance = 1;
    if(nAppearance == 3502) nAppearance = 2;
    if(nAppearance == 3503) nAppearance = 3;
    if(nAppearance == 3504) nAppearance = 4;
    if(nAppearance == 3505) nAppearance = 5;
    if(nAppearance == 3506) nAppearance = 6;
    if(nAppearance == 3507) nAppearance = 563;
    if(nAppearance == 3508) nAppearance = 564;
    if(nAppearance == 3509) nAppearance = 565;
    if(nAppearance == 3510) nAppearance = 566;
    if(nAppearance == 3511) nAppearance = 567;
    if(nAppearance == 3512) nAppearance = 568;
    if(nAppearance == 3513) nAppearance = 569;
    if(nAppearance == 3514) nAppearance = 570;
    if(nAppearance == 3515) nAppearance = 571;
    if(nAppearance == 3516) nAppearance = 1036;
    if(nAppearance == 3517) nAppearance = 1037;
    if(nAppearance == 3518) nAppearance = 1038;
    if(nAppearance == 3519) nAppearance = 1039;
    if(nAppearance == 3520) nAppearance = 1040;
    if(nAppearance == 3521) nAppearance = 1041;
    if(nAppearance == 3522) nAppearance = 40;
    SetCreatureAppearanceType(oPC, nAppearance);
}

void main() 
{
    ACR_TriggerOnEnter();

    object oPC = GetEnteringObject();

    effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectCreator(eEffect) == OBJECT_SELF)
            RemoveEffect(oPC, eEffect);
        eEffect = GetNextEffect(oPC);
    }

//=== Everything else should be caught by the heartbeat ===//
    _SwimToWalk(oPC);
}