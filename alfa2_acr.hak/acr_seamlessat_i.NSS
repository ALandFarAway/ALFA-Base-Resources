////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_seamlessat_i
//    $Revision::            $ current version of the file
//        $Date::            $ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix = ACR_SAT
//
//  Dependencies external of nwscript:
//    #acr_spawn_i (for prespawning)
//    #acf_spawn_i (for prespawn settings)
//
//  Description
//
//  Revision History
//   2007/01/26  AcadiusLost  Adapted for NWN2, accounting for 80.0-wide "gutter"
//   2007/02/04  AcadiusLost  Adapted to make ATing "abortable"
//   2007/02/19  AcadiusLost  Abstracted on_enter and on_exit hooks to their own functions.
//   2007/03/17  AcadiusLost  tied seamless ATs into the spawn system, ACR_SeamlessATEnter()
//   2007/03/18  AcadiusLost  changed name to acr_seamlessat_i.nss, added handling for prespawn
//          target prediction.
//   2007/03/19  AcadiusLost  Set an AOE report VFX to AT destination, also fixed a typo.
//   2007/03/24  AcadiusLost  Switched to caps for the seamless AT destination waypoint tag.
//   2007/03/25  AcadiusLost  Added limitations to spot checks with hostiles near Seamless AT
//          destinations.  (1 per 60 sec, configurable.) Also changed prespawn call to 
//          be compatible with the latest spawn system updates.
//   2007/06/07  Cipher  Changed var prefix to ACR_SAT, abstracted SAT tag, misc cleanup
//   2008/04/13  AcadiusLost  Converted system to use GetAreaSize, work on non-square areas.
//   2008/09/04  AcadiusLost  Added functions for standard (nonseamless) ATs, also fixed CheckSafe 
//                  to ignore z-axis discrepencies to help with areas that don't line up on the Z.
//   2008/09/21  AcadiusLost  Cleared some leftover DM channel debugging reports.
//   2008/09/27  AcadiusLost  AT warning range to 15.0, radius to 4.0, cleaned up report test to omit {}
//   2008/10/12  AcadiusLost  Fixed the OOC bracketed text reporting function.
//   2008/11/10  AcadiusLost  Migrated OOC cleaning function to acr_tools_i, handled exceptions for self in check radius,
//                             constants defined with 2.0f syntax.
//   2008/11/16  AcadiusLost  Fixed problem with location checking of distant hostiles in the presence of nearby friendlies. 
//   2008/12/08  AcadiusLost  swapped in GetIsReactionTypeHostile() so PCs don't trigger AT warnings for each other unless Hostile
//   2008/12/29  AcadiusLost  Added clause to keep DM avatars from causing transition VFX.
//   2009/01/24  AcadiusLost  Removed notification VFX for ATs within the same area.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_SEAMLESSAT_I
#define ACR_SEAMLESSAT_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/*    Not used in this version.
const string _AREA_XMAX = "ACR_SAT_XMAX";
const string _AREA_XMAX = "ACR_SAT_XMAX";
const string _PCMOVE_EAST = "ACR_SAT_EAST";
const string _PCMOVE_WEST = "ACR_SAT_WEST";
const string _PCMOVE_NORTH = "ACR_SAT_NORTH";
const string _PCMOVE_SOUTH = "ACR_SAT_SOUTH";
*/

//! This is the seamless AT trigger tag name
const string ACR_SAT_SEAMLESSAT_TAG = "SeamlessAT";

//! This sets the default "size" of an area with regards to the pXXXpYYYpZZZ 
//!   coordinates.  So, with iAreaSize = 5, adjacent areas would be p105, p110, etc.
//!   Builders are free to vary this using LocalInts on their areas if they choose,
//!   as LocalInt ACR_AREA_SCALE on an area will override this default.
const int iDefaultAreaSize = 5;

//! Constants for the AT warning scripts:
//!  -Sets the radius around the seamless AT destination which is checked for hostiles.
//!  -ReportRadius is the radius around the nearest hostile that is reported on a spot check
//!  -SpotDC sets the difficulty of this check. 
const float fDangerRadius = 15.0f;
const float fReportRadius = 4.0f;
const int iSpotDC = 15;
const int iListenDC = 15;

//! Set the length of the time delay before ATing, normally or when danger is present at destination.
const float fNormalATDelay = 3.0f;
const float fWarnedATDelay = 6.0f;

//! Set the length of time (in seconds) after which a PC gets another chance to make a spot check
//! for a spawn near the AT destination.
const float fWarningReset = 60.0f;

//! Sets the length of time PC is protected after "arriving" in the new area
const float fSafeATWindow = 4.0f;

//! Sets the VFX to play at an AT destination and the duration to play it for.
const int iArrivalVFX = VFX_HIT_AOE_ENCHANTMENT;
const float fNotifyDur = 6.0f;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// *** PUBLIC FUNCTIONS ***

//!  Main code for initiating Seamless ATs- called by acf_sat_onenter.nss
//!  takes GetEnteringObject as the input.
//!    -Handles Transitioning (PC enters trigger to AT)
//!    -Handles receiving PCs (AT'ing PC will arrive inside another sAT)
void  ACR_SeamlessATEnter(object oPC);

//!  Accessory code for Seamless ATs- called by acf_sat_onexit.nss
//!  takes GetExitingObject as the input.
//!    -Allows a PC to abort a potential AT
//!    -Clears all sAT-associated variables when a PC leaves the receiving sAT.
void ACR_SeamlessATExit(object oPC);

//!  Function works out the tag the target area ought to have based on the
//!  current area tag coordinates, and the PC's position within the area.
//!  returns the string "none" if no area with the computed tag exists.
string ACR_GetTargetTag(object oPC);

//!  Returns the direction of a PC's intended travel, as a string.
//!  determined by checking the local Int boolean values on the PC, set
//!  by the ACR_GetTargetTag funtion.
string ACR_ReportATDirection(object oPC);

//!  Clears any leftover AT direction information from a PC's local integers.
void ACR_ClearDirection(object oPC);

//!  Calculates the intended destination position in the target area.
//!  calls ACR_MeasureArea to work out what to do with the NE corner.
vector ACR_TargetPosition(object oPC, string sDestinationTag);

//!  Returns approximate maximum coordinate for a given area. Assumes 32x32, 24x24, 16x16, or 8x8
//!  called if an area lacks local Ints for X and Y area size.
int ACR_MeasureArea(object oAttempt);

//!  Creates notification effect at seamless AT target, unless PC transitioning is in stealth.
void ACR_NotifyTransition(object oPC, location lArrival);

//! Passes the AT notification message to the rest of the party
void ACR_SAT_NotifyParty(object oPC, string sMessage);

//! picks which size to use for the area (integer)
int ACR_SAT_ChooseSize(float fPosition);

//! checks for creatures near AT destination
int ACR_SAT_CheckSafe(location lSafe, object oChar);

//! determines what info, if any, to pass to a PC about spawns near an AT.
int ACR_SAT_ReconInfo(object oCreature, object oPC);

//! checks for existence of a return AT near a given location.
int ACR_SAT_CheckForAT(location lProbe);

//! composes an integer into a 3-character string, for tag prediction.
string ACR_SAT_IntCompose(int iCoord);

//! Handles moving the PC, assuming they're still inside the AT. (allows movement to be cancelled)
void ACR_SAT_MovePC(object oPC, location lDest, string sAT);

//! Handles placement of a temporary waypoint at a putative seamless AT destination-
//!  allows the spawn system to avoid that area when prespawning is enabled.
void ACR_SAT_PlaceWP(location lArrival);

//!! Handles safety check and confirmation for normal ATs and doors
void ACR_CheckAT(object oPC, object oDest, location lDest);

// *** PRIVATE FUNCTIONS ***

//! Clears the "WARNED" FLAG after fWarningReset seconds, from when a spot check is called.
void _ClearWarnedFlag(object oWarnedPC);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "X0_I0_PARTYWIDE"
#include "x0_i0_position"
#include "acr_spawn_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_SeamlessATEnter(object oPC) {

  object oTriggerArea = GetArea(oPC);
  object oParty = GetNextFactionMember(oPC);
  location lStart = GetLocation(oPC);
  string sTargetAreaTag = "";
  effect eTransit = EffectEthereal();

  if (GetLocalInt(oPC, "ACR_SAT_CURRENT")) { 
     if (!GetLocalInt(oPC, "ACR_SAT_DONE")) {
       // Reentering AT during abort window, just let the queued AT happen
	   return;
     } else {
       // PC should be entering the AT from another AT in this case: apply temporary ethereal effect.
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTransit, oPC, fSafeATWindow);
   	   SetLocalInt(oPC, "ACR_SAT_CURRENT", FALSE);
      //     SendMessageToAllDMs("entered AT in "+GetName(oTriggerArea)+" with CURRENT for PC "+GetName(oPC));
       return;
     }
  }

  // first, make sure PC doesn't have leftover AT info stored.
  ACR_ClearDirection(oPC);

  // Call the function to determine where the PC is going.
  sTargetAreaTag = ACR_GetTargetTag(oPC);
  // Prepare the report to pass to the PC.
   string sAT = ACR_ReportATDirection(oPC);
   object oTargetArea = GetObjectByTag(sTargetAreaTag);

   if (sTargetAreaTag != "none") {

     vector vDest = ACR_TargetPosition(oPC, sTargetAreaTag);
     if (vDest == Vector(0.0, 0.0, 0.0)) {
        SendMessageToPC(oPC, "Could not access AT target, aborting area transition.");
        return;
      }

     location lDest = Location(oTargetArea, vDest, GetFacing(oPC));
     
	 // If prespawning prediction is enabled, we'll want to create a waypoint at the
	 //  putative destination, so the spawn system knows not to drop a mob there.
	 if (GetPrespawnPrediction()) {
	   ACR_SAT_PlaceWP(lDest);
	 }
	 
	 // Tell the spawn system to get the next area ready. if enabled.
	 if (GetPrespawnsSeamless()) {
	   ACR_PreSpawnArea(oTargetArea);
	 }
	 
     if (!ACR_SAT_CheckForAT(lDest)) {
        SendMessageToPC(oPC, "No return transition detected in the next area, aborting.");
        return;
      }

     // Pass info to PC and party.
     FloatingTextStringOnCreature(sAT, oPC, FALSE);

     if (ACR_SAT_CheckSafe(lDest, oPC)) {
        // way is clear of hostiles, move PC in 3 seconds.
	    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTransit, oPC, (fNormalATDelay-1.0)));
        DelayCommand(fNormalATDelay, ACR_SAT_MovePC(oPC, lDest, sAT));
     } else {
        // hostile is within danger radius of destination, give the PC longer to abort the AT
    	SetLocalInt(oPC, "ACR_SAT_WARNED", TRUE);
	    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTransit, oPC, (fWarnedATDelay-1.0)));
	    DelayCommand(fWarnedATDelay, ACR_SAT_MovePC(oPC, lDest, sAT));
     }
      
     SetLocalInt(oPC, "ACR_SAT_CURRENT", TRUE);
   } else {
     SendMessageToPC(oPC, "Area Transition failure: Target does not exist in this module.");
   }
}

void ACR_SeamlessATExit(object oPC) {

  if (!GetLocalInt(oPC, "ACR_SAT_CURRENT")) {
    // current should only be "off" if the player is walking out from a successful AT. Clear all variables.
    SetLocalInt(oPC, "ACR_SAT_CURRENT", FALSE);
    SetLocalInt(oPC, "ACR_SAT_DONE", FALSE);
    // SetLocalInt(oPC, "ACR_SAT_WARNED", FALSE);
    //    SendMessageToAllDMs("Reset AT switches for PC "+GetName(oPC));
    return;
  } else if (!GetLocalInt(oPC, "ACR_SAT_DONE")) {
    // Current, but not done: should be an AT abort. Need to turn Current and Warned off.
    // SetLocalInt(oPC, "ACR_SAT_WARNED", TRUE);
	SetLocalInt(oPC, "ACR_SAT_CURRENT", FALSE);
    //    SendMessageToAllDMs(GetName(oPC)+" is Aborting AT.");
    return;
  } else {
    //    SendMessageToAllDMs(GetName(oPC)+" is exiting AT enroute to new area.");
    return;
  }
}

/*-------------------- Function code for internal sAT functions -------*/

string ACR_GetTargetTag(object oPC) {

   object oCurrentArea = GetArea(oPC);
   string sCurrentArea = GetTag(oCurrentArea);
   vector vPC = GetPosition(oPC);
   float fPC = GetFacing(oPC);
   float fXMax = IntToFloat(GetLocalInt(oCurrentArea, "ACR_SAT_XMAX"));
   float fYMax = IntToFloat(GetLocalInt(oCurrentArea, "ACR_SAT_YMAX"));
   int iAreaSize;
   int iNewMax = 0;
   string sComposedTag = "";

   // check for area grid scaling recorded as a local integer on the area.
   int iAreaScale = GetLocalInt(oCurrentArea, "ACR_AREA_SCALE");
   if (iAreaScale != 0 ) {
      iAreaSize = iAreaScale;
   } else iAreaSize = iDefaultAreaSize;

   // check for area X and Y limits, stored in local integers on the area. If missing, call
   //  area measurement function to generate them.
   if ((fXMax == 0.0) || (fYMax == 0.0)) {
      if (ACR_MeasureArea(oCurrentArea)) {
         fXMax = IntToFloat(GetLocalInt(oCurrentArea, "ACR_SAT_XMAX"));
         fYMax = IntToFloat(GetLocalInt(oCurrentArea, "ACR_SAT_YMAX"));
      } else {
      //   SendMessageToAllDMs("defaulting to 400 for direction tests");
         fXMax = 480.0;
         fYMax = 480.0;
      }
   }
   if (vPC.x > fXMax) {
      //SendMessageToAllDMs("Exceeded X bound, revising measure.");
      iNewMax = ACR_SAT_ChooseSize(vPC.x);
      SetLocalInt(oCurrentArea, "ACR_SAT_XMAX", iNewMax);
      SetLocalInt(oCurrentArea, "ACR_SAT_YMAX", iNewMax);
      fXMax = IntToFloat(GetLocalInt(oCurrentArea, "ACR_SAT_XMAX"));
      fYMax = fXMax;
   } else if (vPC.y > fYMax) {
      //SendMessageToAllDMs("Exceeded Y bound, revising measure.");
      iNewMax = ACR_SAT_ChooseSize(vPC.y);
      SetLocalInt(oCurrentArea, "ACR_SAT_XMAX", iNewMax);
      SetLocalInt(oCurrentArea, "ACR_SAT_YMAX", iNewMax);
      fYMax = IntToFloat(GetLocalInt(oCurrentArea, "ACR_SAT_YMAX"));
      fXMax = fYMax;
   }
   // Take the second to fourth characters of the tag, derive X: p120p123p000 would give 120.
   int iTargetX = StringToInt(GetStringRight(GetStringLeft(sCurrentArea, 4), 3));
   if (GetStringLeft(sCurrentArea, 1) == "n")
      iTargetX = (iTargetX * -1);
   // Take the 6th to 8th characters, derive Y coordinate of the area.
   int iTargetY = StringToInt(GetStringRight(GetStringLeft(sCurrentArea, 8), 3));
   if (GetStringRight(GetStringLeft(sCurrentArea, 5), 1) == "n")
      iTargetY = (iTargetY * -1);

   // Now, area coordinates in hand, we decide how what direction the PC will need to travel
   //  based on their position within the current area.  Modifiers will be applied to the target
   //  area coordinates accordingly.
   //SendMessageToPC(oPC, "Coordinate: "+FloatToString(vPC.x)+"x"+FloatToString(vPC.y)+"x"+FloatToString(vPC.z));
   
   if ((vPC.x - 7.5) < 80.0) {
      // Area Transition will involve westward movement, subtract from global X coordinate.
      iTargetX = iTargetX - iAreaSize;
      SetLocalInt(oPC, "West", TRUE);
      }
   else if (vPC.x + 87.5 > fXMax ) {
      // Further east doesn't exist here (beyond edge of area), so must be time to AT east.
      iTargetX = iTargetX + iAreaSize;
      SetLocalInt(oPC, "East", TRUE);
      };

   if ((vPC.y - 7.5) < 80.0) {
      // Area Transition will involve southward movement, subtract from global Y coordinate.
      iTargetY = iTargetY - iAreaSize;
      SetLocalInt(oPC, "South", TRUE);
      }
   else if (vPC.y + 87.5 > fYMax) {
      // Further north doesn't exist here (beyond edge of area), so must be time to AT north.
      iTargetY = iTargetY + iAreaSize;
      SetLocalInt(oPC, "North", TRUE);
      };

   // Now, we recompose the coordinates into a derived tag for the intended target area.
   if (iTargetX < 0) {
      sComposedTag = "n"+ACR_SAT_IntCompose((iTargetX * -1));
      } else {
      sComposedTag = "p"+ACR_SAT_IntCompose(iTargetX);
      };
   if (iTargetY < 0) {
      sComposedTag = sComposedTag+"n"+ACR_SAT_IntCompose((iTargetY * -1));
      } else {
      sComposedTag = sComposedTag+"p"+ACR_SAT_IntCompose(iTargetY);
      }
   // X and Y parameters set, we append the "Z" coordinate, from the current area.
   sComposedTag = sComposedTag + GetStringRight(sCurrentArea, 4);

   // Now the moment of truth, we test to see if this area exists.
   if (GetObjectByTag(sComposedTag) == OBJECT_INVALID) {
      SendMessageToPC(oPC, "Destination Area not found");
      //SendMessageToAllDMs("PC "+GetName(oPC)+" failed to AT to nonexistent area "+sComposedTag);
      return "none";
      }
   else {
      // SendMessageToPC(oPC, "Destination tag: "+sComposedTag);
      return sComposedTag;
   }
}

void ACR_ClearDirection(object oPC) {
   SetLocalInt(oPC, "North", FALSE);
   SetLocalInt(oPC, "South", FALSE);
   SetLocalInt(oPC, "West", FALSE);
   SetLocalInt(oPC, "East", FALSE);
   return;
}

string ACR_ReportATDirection(object oPC) {

   string sReport = "none";

  if (GetLocalInt(oPC, "North")) {
      if (GetLocalInt(oPC, "West"))
         sReport = "Moving Northwest...";
      else if (GetLocalInt(oPC, "East"))
         sReport = "Moving Northeast...";
      else
         sReport = "Moving North...";
  } else if (GetLocalInt(oPC, "South")) {
      if (GetLocalInt(oPC, "West"))
         sReport = "Moving Southwest...";
      else if (GetLocalInt(oPC, "East"))
         sReport = "Moving Southeast...";
      else
         sReport = "Moving South...";
   } else if (GetLocalInt(oPC, "West")) {
       sReport = "Moving West...";
   } else if (GetLocalInt(oPC, "East"))
       sReport = "Moving East...";

//   SendMessageToAllDMs("Testing report function for PC "+GetName(oPC)+", "+sReport);

   return sReport;
}

vector ACR_TargetPosition(object oPC, string sDestinationTag) {

   object oTargetArea = GetObjectByTag(sDestinationTag);
   float fPosX = GetPosition(oPC).x;
   float fPosY = GetPosition(oPC).y;
   float fXMaxT = IntToFloat(GetLocalInt(oTargetArea, "ACR_SAT_XMAX"));
   float fYMaxT = IntToFloat(GetLocalInt(oTargetArea, "ACR_SAT_YMAX"));

   if ((fXMaxT * fYMaxT) == 0.0) {
      if (!ACR_MeasureArea(oTargetArea)) {
         //SendMessageToAllDMs("Could not find any ATs in the Target Area, "+GetName(oTargetArea));
         return Vector(0.0, 0.0, 0.0);
      } else {
         fXMaxT = IntToFloat(GetLocalInt(oTargetArea, "ACR_SAT_XMAX"));
         fYMaxT = IntToFloat(GetLocalInt(oTargetArea, "ACR_SAT_YMAX"));
      }
   }

   if (GetLocalInt(oPC, "North"))
        fPosY = 80.75;
   else if (GetLocalInt(oPC, "South"))
        fPosY = fYMaxT -80.75;
   if (GetLocalInt(oPC, "East"))
        fPosX = 80.75;
   else if (GetLocalInt(oPC, "West"))
        fPosX = fXMaxT - 80.75;

   //SendMessageToPC(oPC, "Target: X"+FloatToString(fPosX)+", Y"+FloatToString(fPosY));
   return Vector(fPosX, fPosY, GetPosition(oPC).z);
}

int ACR_MeasureArea(object oAttempt) {

  int iTilesWide = GetAreaSize(AREA_WIDTH, oAttempt);
  int iTilesHigh = GetAreaSize(AREA_HEIGHT, oAttempt);
  SetLocalInt(oAttempt, "ACR_SAT_XMAX", (iTilesWide * 10));
  SetLocalInt(oAttempt, "ACR_SAT_YMAX", (iTilesHigh * 10));
  //SendMessageToAllDMs(GetName(oAttempt)+" reported as "+IntToString(iTilesWide)+"x"+IntToString(iTilesHigh));
  //SendMessageToAllDMs("translated to "+IntToString((iTilesWide * 10))+"x"+IntToString((iTilesHigh * 10)));
  return TRUE;
  
  // Deprecated measurement code from before GetAreaSize() 
  /*  int iMaxEdge = 0;

  vector vSearch = Vector(1.0, 1.0, 1.0);
  location lSearch = Location(oAttempt, vSearch, 90.0);
  float fTest = 0.0;
  int iNum = 1;
  object oAT = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lSearch);
  while (oAT != OBJECT_INVALID) {
     vSearch = GetPosition(oAT);
     if (vSearch.x > vSearch.y) {
        if (vSearch.x > fTest)
           fTest = vSearch.x;
     } else {
        if (vSearch.y > fTest)
           fTest = vSearch.y;
     }
//     SendMessageToAllDMs(FloatToString(fTest));
     iNum = iNum + 1;
     oAT = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lSearch, iNum);
  }
  if (fTest > 72.5) {
     iMaxEdge = ACR_SAT_ChooseSize(fTest);
     SetLocalInt(oAttempt, "ACR_SAT_XMAX", iMaxEdge);
     SetLocalInt(oAttempt, "ACR_SAT_YMAX", iMaxEdge);
//     SendMessageToAllDMs("Set Area "+GetName(oAttempt)+" with max of "+IntToString(iMaxEdge));
  } else if (fTest > 0.0) {
//     SendMessageToAllDMs("Trigger was too close to origin to determine maximum coordinate for "+GetName(oAttempt));
     iMaxEdge = FloatToInt(fTest);
     SetLocalInt(oAttempt, "ACR_SAT_XMAX", iMaxEdge);
     SetLocalInt(oAttempt, "ACR_SAT_YMAX", iMaxEdge);
  } else {
//     SendMessageToAllDMs("Could not set a maximum X or Y for area.");
     return FALSE;
  }
  return TRUE;
  */
}

void ACR_NotifyTransition(object oPC, location lArrival) {

   if ((GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED) || GetIsDM(oPC)){
      // PC is trying to sneak across the AT.  Give them the benefit of the doubt.
	  // also skip this part for DM avatars. Possessed NPCs should work like PCs.
      return;
   } else if (GetArea(oPC) == GetAreaFromLocation(lArrival)) {
   	  // Don't need the VFX if the destination is within the same area (no lag)
      return;
   }
   effect eNotify = EffectVisualEffect(iArrivalVFX);
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eNotify, lArrival, fNotifyDur);
   return;
}

void ACR_SAT_NotifyParty(object oPC, string sMessage) {

   if (GetNumberPartyMembers(oPC) > 2)
      return;

   object oNotified = GetFirstFactionMember(oPC);
   while (oNotified != OBJECT_INVALID) {
      if (oNotified != oPC) {
         SendMessageToPC(oNotified, GetName(oPC)+" is "+sMessage);
//         SendMessageToAllDMs("Notifying "+GetName(oNotified)+" that "+GetName(oPC)+" is "+sMessage);
         };
      oNotified = GetNextFactionMember(oPC);
      }
   return;
}

int ACR_SAT_ChooseSize(float fPosition) {

   if (fPosition > 392.5) {
      return 480;  // 32x32 exterior
   } else if (fPosition > 312.5) {
      return 400;  // 24x24 exterior
   } else if (fPosition > 232.5) {
      return 320;  // 16x16 exterior
   } else if (fPosition > 192.5) {
      return 280;  // 12x12 exterior
   } else if (fPosition > 172.5) {
      return 260;  // 10x10 exterior
   } else if (fPosition > 152.5) {
      return 240;  // 8x8 exterior
   } else {
//      SendMessageToAllDMs("Could not choose a reasonable area size.");
      return 0;
   }
}


int ACR_SAT_CheckSafe(location lSafe, object oChar)
{

  object oCreature;
  location lCreat;
  float fRange;
  
  for (ObjectToInt(oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fDangerRadius, lSafe, TRUE, OBJECT_TYPE_CREATURE)); oCreature != OBJECT_INVALID; ObjectToInt(oCreature = GetNextObjectInShape(SHAPE_SPHERE, fDangerRadius, lSafe, TRUE, OBJECT_TYPE_CREATURE))) {
  
    if ((!GetIsDead(oCreature)) && (GetIsReactionTypeHostile(oCreature,oChar))) {
      ACR_SAT_ReconInfo(oCreature, oChar);
      return FALSE;
    }
  }

  return TRUE;
}


int ACR_SAT_ReconInfo(object oCreature, object oPC)
{
  object oNextCreature;
  int iCreatIndex,iCreatNum;
  string sReport,sNum,sPrimary,sSecondary;
  location lDanger;

  iCreatIndex=1;
  iCreatNum = 1;
  sReport = "You sight ";
  sNum = "a ";
  sPrimary = ACR_CleanCreatureNameTextForPlayers(GetName(oCreature));
  sSecondary = "";
  lDanger = GetLocation(oCreature);

  if(GetLocalInt(oPC, "ACR_SAT_WARNED") == TRUE) {
     // PC has already been recently warned about ATing ahead, let them proceed
	 //  without further delays or warnings (keeps them from spamming the trigger 
	 //  entry to get a better Spot roll).
	 //SendMessageToAllDMs("Omitting recon report for PC "+GetName(oPC)+" due to previous warning.");
     return FALSE;
  }
  
  if (GetIsSkillSuccessful(oPC, SKILL_SPOT, iSpotDC + Random(6))) {
    for (ObjectToInt(oNextCreature = GetFirstObjectInShape(SHAPE_SPHERE, fReportRadius, lDanger, TRUE, OBJECT_TYPE_CREATURE));
          (oNextCreature != OBJECT_INVALID) && (oNextCreature != oPC);
          ObjectToInt(oNextCreature = GetNextObjectInShape(SHAPE_SPHERE, fReportRadius, lDanger, TRUE, OBJECT_TYPE_CREATURE))) {

      if (GetIsDead(oNextCreature))
        continue;
      if (GetName(oNextCreature) == sPrimary)
        iCreatNum++;
      else
        sSecondary = sSecondary + " and a "+ACR_CleanCreatureNameTextForPlayers(GetName(oNextCreature));
      iCreatIndex++;
    }
    if (iCreatNum > 1) {
      sNum = IntToString(iCreatNum)+" ";
      sPrimary = sPrimary+"s";
    }
    sReport = sReport+sNum+sPrimary+sSecondary+" ahead.";
    SetLocalInt(oPC, "ACR_SAT_WARNED", TRUE);
    SendMessageToPC(oPC, sReport);
    DelayCommand(fWarningReset, _ClearWarnedFlag(oPC));
    return TRUE;
  }
  else {
    if (GetIsSkillSuccessful(oPC, SKILL_SPOT, iListenDC + Random(6))) {
      SendMessageToPC(oPC, "You hear movement up ahead, likely not friendly; caution is advised.");
    }
    else {
      SendMessageToPC(oPC, "You can make out something just ahead; would be wise to be cautious.");
    }
    SetLocalInt(oPC, "ACR_SAT_WARNED", TRUE);
    DelayCommand(fWarningReset, _ClearWarnedFlag(oPC));
  }
  return FALSE;
}

int ACR_SAT_CheckForAT(location lProbe) {

 object oCheckArea = GetAreaFromLocation(lProbe);
 float fDimention = IntToFloat(GetLocalInt(oCheckArea, "ACR_SAT_XMAX"));
 int iTrigNum = 1;
 object oTrigger = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lProbe, iTrigNum);
 // without an X-max, we can't guess if an AT in the target area is close "enough"
 if (fDimention == 0.0) {
    SendMessageToAllDMs("X boundries not defined for area "+GetName(oCheckArea)+", with tag: "+GetTag(oCheckArea)+".  Presuming no return AT is present.");
    return FALSE;
 }
 // account for the "gutter" size of 80.0 per side, maximum distance to an AT point should be the
 //  width of the area, less both unwalkable "gutters".
 fDimention = fDimention - 160.0;
 while (oTrigger != OBJECT_INVALID) {
    if (GetTag(oTrigger) == "SeamlessAT") {
       if (GetDistanceBetweenLocations(lProbe, GetLocation(oTrigger)) < fDimention) {
          // If a standard template seamless AT has it's initial point within one length, we will
          //  assume it is correct.
          return TRUE;
       } else {
          return FALSE;
       }
    }
    iTrigNum = iTrigNum + 1;
    oTrigger = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lProbe, iTrigNum);
 }
 return FALSE;
}

string ACR_SAT_IntCompose(int iCoord) {

 if (iCoord > 999) {
   // Coordinate is too many digits, return XXX and report error to DM channel.
   SendMessageToAllDMs("Error: Seamless AT call for impossible (>999) world coordinate.");
   return "XXX";
 } else if (iCoord > 99) {
   // Coordinate is 3 digits, can just use IntToString.
   return IntToString(iCoord);
 } else if (iCoord > 9) {
   // 2-digit coordinate, pad string with one "0".
   return "0"+IntToString(iCoord);
 } else {
   // single-digit coordinate, pad with "00".
   return "00"+IntToString(iCoord);
 }
 
}

void ACR_SAT_MovePC(object oPC, location lDest, string sAT) {

  if (GetLocalInt(oPC, "ACR_SAT_CURRENT")) { 
    // Mark AT destination with VFX, unless the ATing PC is in stealth mode.
     ACR_NotifyTransition(oPC, lDest);
	// Pass PC's movement direction on to other PCs in their party.
	 ACR_SAT_NotifyParty(oPC, sAT);
     SetLocalInt(oPC, "ACR_SAT_DONE", TRUE);
	 AssignCommand(oPC, ClearAllActions(TRUE));
     AssignCommand(oPC, ActionJumpToLocation(lDest));
  }
}

void ACR_SAT_PlaceWP(location lArrival) {

   object oArrivalWP = CreateObject(OBJECT_TYPE_WAYPOINT, "acr_sat_wp", lArrival, FALSE, "ACR_SAT_WP");
   if (oArrivalWP != OBJECT_INVALID) {
      DelayCommand(fWarnedATDelay, DestroyObject(oArrivalWP));
   }

}


void ACR_CheckAT(object oPC, object oDest, location lDest)
{

	object oTransition = OBJECT_SELF;
	object oDestination = GetTransitionTarget(oTransition);
	string sWarned = IntToString(ACR_GetCharacterID(oPC))+"_WARNED";
	object oTargetArea = GetArea(oDestination);
	int bToObject = (oDest != OBJECT_INVALID);

	// if this PC has already been warned about this AT in the last minute, just AT them and clean up.
	if (GetLocalInt(oTransition, sWarned) == TRUE) {
		ACR_NotifyTransition(oPC, lDest);

		if (bToObject)
			AssignCommand(oPC, JumpToObject(oDest));
		else
			AssignCommand(oPC, JumpToLocation(lDest));
		DeleteLocalInt(oTransition, sWarned);
		return;
	}
	
	if (GetObjectType(oTransition) == OBJECT_TYPE_DOOR) {
	    if ((GetTransitionTarget(oDestination) != oTransition) && (!GetLocalInt(oTransition, "ACR_SAT_NO_WARN"))) {
		    SendMessageToPC(oPC, "This door is not linked from the other side, it may be a one-way transition.");
			AssignCommand(oPC, ActionSpeakString("((This door is not linked from the other side, it may be a one-way transition.))"));
			SendMessageToAllDMs("Door Transition "+GetName(oTransition)+" in area "+GetName(GetArea(oTransition))+" is not reciprocally linked to its destination in area "+GetName(oTargetArea)+".");
			SendMessageToPC(oPC, "Click the AT again to proceed if you wish.");
			SetLocalInt(oTransition, sWarned, TRUE);
			DelayCommand(fWarningReset, DeleteLocalInt(oTransition, sWarned));
			return;
		}
	}
	// if this switch is on, create a waypoint at the destination
	if (GetPrespawnPrediction()) {
		ACR_SAT_PlaceWP(lDest);
	}
	// Refresh the spawn system for the target area.
	if(GetArea(oDestination) != OBJECT_INVALID) {
		ACR_PreSpawnArea(oTargetArea);
	}
	// check for trouble
	if (ACR_SAT_CheckSafe(lDest, oPC)) {
        // way is clear of hostiles, move PC instantly.
		ACR_NotifyTransition(oPC, lDest);
		if (bToObject)
			AssignCommand(oPC, JumpToObject(oDest));
		else
			AssignCommand(oPC, JumpToLocation(lDest));
	} else {
		// hostile is within danger radius of destination, make the PC click again to continue
		SendMessageToPC(oPC, "Click the AT again to proceed if you wish.");
		SetLocalInt(oTransition, sWarned, TRUE);
		DelayCommand(fWarningReset, DeleteLocalInt(oTransition, sWarned));
	}
}

void _ClearWarnedFlag(object oWarnedPC) {

   // SendMessageToAllDMs("Clearing the WARNED flag for PC "+GetName(oWarnedPC));
   SetLocalInt(oWarnedPC, "ACR_SAT_WARNED", FALSE);
}


#endif