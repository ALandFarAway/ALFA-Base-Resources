////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_subdual.nss
//    $Revision:: x        $ current version of the file
//        $Date:: 2009-07-22#$ date the file was created or modified
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
	Manages the InstantFeat for subdual mode.
*/

void main()
{

  object oUser = OBJECT_SELF;
  ACR_ToggleNLDMode(oUser);

}