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
   
    // Custom code goes here.
			object oDM = OBJECT_SELF;
	        object oCritter = GetLocalObject(oDM, "Object_Target");
			int iRadius = GetLocalInt(oDM, "iRadiusFaction");
			int	iArea = GetLocalInt(oDM, "iAreaFaction");
				 
	        
			
			//Toggle Commoner functions for Omega Wand
							if(GetLocalInt(oCritter, "Factioned") == 0)
										{ClearAllActions(TRUE);
										 ChangeToStandardFaction(oCritter, STANDARD_FACTION_COMMONER);
										 SendMessageToPC(oDM, GetName(oCritter) + " set to Commoner.");
										 SetLocalInt(oCritter, "Factioned", 1);
										 if(iRadius != 0)
											{object oChild = GetFirstObjectInShape(SHAPE_SPHERE, 25.0, GetLocation(oCritter), FALSE, OBJECT_TYPE_CREATURE); 
					 						 while(oChild != OBJECT_INVALID) 
												{if((GetIsPC(oChild) == FALSE) && (GetLocalInt(oChild, "Factioned") != 0))
													{SendMessageToPC(oDM, GetName(oChild) + " set to Commoner");
								 					 ClearAllActions(TRUE);
													 ChangeToStandardFaction(oChild, STANDARD_FACTION_COMMONER);
										 			 SetLocalInt(oChild, "Factioned", 1);
											 		 }
											 	oChild = GetNextObjectInShape(SHAPE_SPHERE, 25.0, GetLocation(oCritter), FALSE, OBJECT_TYPE_CREATURE);
												}
											 SetLocalInt(oDM, "iRadiusFaction", 0);
											 }
										else if(iArea != 0)
											{object oChild = GetFirstObjectInArea(GetArea(oCritter)); 
					 						 while(oChild != OBJECT_INVALID) 
												{if((GetObjectType(oChild) == OBJECT_TYPE_CREATURE) && (GetIsPC(oChild) == FALSE) && (GetLocalInt(oChild, "Flocked") != 0))
													{SendMessageToPC(oDM, GetName(oChild) + " set to Commoner.");
								 					 ClearAllActions(TRUE);
													 ChangeToStandardFaction(oChild, STANDARD_FACTION_COMMONER);
										 			 SetLocalInt(oChild, "Factioned", 1);
											 		 }
											 	oChild = GetNextObjectInArea(GetArea(oCritter));
												}
											 SetLocalInt(oDM, "iAreaFaction", 0);
											 }
										return;
									 	}
			
			
			
			
			//Toggle Hostile functions for Omega Wand
				
						else if(GetLocalInt(oCritter, "Factioned") == 1)
										{ClearAllActions(TRUE);
										 ChangeToStandardFaction(oCritter, STANDARD_FACTION_HOSTILE);
										 SendMessageToPC(oDM, GetName(oCritter) + " set to Hostile.");
										 SetLocalInt(oCritter, "Factioned", 0);
										 if(iRadius != 0)
											{object oChild = GetFirstObjectInShape(SHAPE_SPHERE, 25.0, GetLocation(oCritter), FALSE, OBJECT_TYPE_CREATURE); 
					 						 while(oChild != OBJECT_INVALID) 
												{if((GetIsPC(oChild) == FALSE) && (GetLocalInt(oChild, "Factioned") != 0))
													{SendMessageToPC(oDM, GetName(oChild) + " set to Hostile.");
								 					 ClearAllActions(TRUE);
													 ChangeToStandardFaction(oChild, STANDARD_FACTION_HOSTILE);
										 			 SetLocalInt(oChild, "Factioned", 0);
											 		 }
											 	oChild = GetNextObjectInShape(SHAPE_SPHERE, 25.0, GetLocation(oCritter), FALSE, OBJECT_TYPE_CREATURE);
												}
											 SetLocalInt(oDM, "iRadiusFaction", 0);
											 }
										else if(iArea != 0)
											{object oChild = GetFirstObjectInArea(GetArea(oCritter)); 
					 						 while(oChild != OBJECT_INVALID) 
												{if((GetObjectType(oChild) == OBJECT_TYPE_CREATURE) && (GetIsPC(oChild) == FALSE) && (GetLocalInt(oChild, "Flocked") != 0))
													{SendMessageToPC(oDM, GetName(oChild) + " set to Hostile.");
								 					 ClearAllActions(TRUE);
													 ChangeToStandardFaction(oChild, STANDARD_FACTION_HOSTILE);
										 			 SetLocalInt(oChild, "Factioned", 0);
											 		 }
											 	oChild = GetNextObjectInArea(GetArea(oCritter));
												}
											 SetLocalInt(oDM, "iAreaFaction", 0);
											 }
										return;
									 	}
	
			
}