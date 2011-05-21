////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : i_acr_subdual_ac.nss
//    $Revision:: x        $ current version of the file
//        $Date:: 2008-08-27#$ date the file was created or modified
//       Author : Creslyn & AcadiusLost
//
//   Var Prefix : ACR_NLD
//  Dependencies:
//
//  Description
//  This script handles activation or deactivation of subdual mode.
//   it fires when a subdual mode toggle item is activated by a PC.
//
//  Revision History
//  2008/07/22  Creslyn  Subdual v11: Inception.
//  2007/08/27  AcadiusLost  reformatting/integration to ACR.

#include "acr_nonlethal_i"

/*
	Just using an item with UniquePower for now.
	Might want to go with a feat for live, if
	a new combat mode proves too difficult.
*/

void main()
{
  object oItem = GetItemActivated();
  object oUser = GetItemActivator();
  object oTarget = GetItemActivatedTarget();

  string sTag = GetTag(oItem);
  if(sTag == ACR_SUBDUAL_TOGGLE)
  {
    ACR_ToggleNLDMode(oUser);
	return;
  }
}