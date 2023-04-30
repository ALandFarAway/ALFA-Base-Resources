////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : omega_faction
//    $Revision:: 236        $ current version of the file
//        $Date:: 2010-02-16#$ date the file was created or modified
//       Author : Wynna
//
//    Var Prefix:
//  Dependencies:
//
//  Description
//  This script sets hostiles to commoner and vice versa, as applied by the Omega Wand

//  Revision History
//  2010/02/16  Wynna  Inception
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_creature_i"
#include "acr_spawn_i"



void main()
{
    object oDM = OBJECT_SELF;
	object oCritter = GetItemActivatedTarget();
	int nFaction = GetLocalInt(oDM, "Omega_Faction");
	int nStandard = STANDARD_FACTION_COMMONER;
	string sStandard = "Commoner";
	if(nFaction == 1) {nStandard = STANDARD_FACTION_COMMONER;sStandard = "Commoner";}
	if(nFaction == 2) {nStandard = STANDARD_FACTION_DEFENDER;sStandard = "Defender";}
	if(nFaction == 3) {nStandard = STANDARD_FACTION_HOSTILE;sStandard = "Hostile";}
	if(nFaction == 4) {nStandard = STANDARD_FACTION_MERCHANT;sStandard = "Merchant";}
	int nRadius = GetLocalInt(oDM, "Omega_Radius");
	int	nArea = GetLocalInt(oDM, "Omega_Area");
	float fRadius = IntToFloat(nRadius);
				
	 	ChangeToStandardFaction(oCritter, nStandard);
		SendMessageToPC(oDM, GetName(oCritter) + " set to " + sStandard);
		if(nRadius != 0){
			object oChild = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCritter), FALSE, OBJECT_TYPE_CREATURE); 
			while(oChild != OBJECT_INVALID){ 
				if(GetIsPC(oChild) == FALSE){
					SendMessageToPC(oDM, GetName(oChild) + " set to " + sStandard);
					ChangeToStandardFaction(oChild, nStandard);
					}
				oChild = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCritter), FALSE, OBJECT_TYPE_CREATURE);
				}
			}
										
		else if(nArea != 0){
			object oChild = GetFirstObjectInArea(GetArea(oCritter)); 
			while(oChild != OBJECT_INVALID) {
				if((GetObjectType(oChild) == OBJECT_TYPE_CREATURE) && (GetIsPC(oChild) == FALSE)){
					SendMessageToPC(oDM, GetName(oChild) + " set to " + sStandard);
					ChangeToStandardFaction(oChild, nStandard);
					}
				oChild = GetNextObjectInArea(GetArea(oCritter));
				}
			}
			
	SetLocalInt(oDM, "Omega_Faction", 0);				
	SetLocalInt(oDM, "Omega_Radius", 0);				
	SetLocalInt(oDM, "Omega_Area", 0);
	}