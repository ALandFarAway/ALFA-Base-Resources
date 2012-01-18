////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acf_plc_onused.nss
//    $Revision:: 183        $ current version of the file
//        $Date:: 2006-12-21#$ date the file was created or modified
//       Author : Ronan
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script calls the ACR's OnUsed code for placeables, and any
//  custom code a server may need. It is not updated in ACR updates.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_placeable_i"
#include "dmfi_inc_langexe" 
#include "acr_quest_i"

void main() {
 

	ACR_PlaceableOnUsed();

		

 //rowboats 	
if(FindSubString(GetTag(OBJECT_SELF), "_plc_rowboat") != -1)
	 {object oBoater = GetLocalObject(OBJECT_SELF, "oBoater");
	  if(oBoater == OBJECT_INVALID)
	  	{oBoater = GetLastUsedBy();
		 SetLocalObject(OBJECT_SELF, "oBoater", oBoater);
		 }
	  object oBoater2 = GetFirstObjectInShape(SHAPE_SPHERE, 2.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	  while(oBoater2 != OBJECT_INVALID)
	  	{if(oBoater2 != oBoater)
			{SetLocalObject(OBJECT_SELF, "oBoater2", oBoater2);
			 break;
			 }
		   oBoater2 = GetNextObjectInShape(SHAPE_SPHERE, 2.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	  	}
	  object oBoater3 = GetFirstObjectInShape(SHAPE_SPHERE, 2.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	  while(oBoater3 != OBJECT_INVALID)
	  	{if((oBoater3 != oBoater) && (oBoater3 != oBoater2))
			{SetLocalObject(OBJECT_SELF, "oBoater3", oBoater3);
			 break;
			 }
		   oBoater3 = GetNextObjectInShape(SHAPE_SPHERE, 2.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	  	}
  
	  location lHome = GetLocalLocation(OBJECT_SELF, "lHome");
	  if(GetIsLocationValid(lHome) == FALSE)
	  	{lHome = GetLocation(OBJECT_SELF);
		 SetLocalLocation(OBJECT_SELF, "lHome", lHome);
	  	}
	  object oBoatPrime = GetLocalObject(OBJECT_SELF, "oPrime");
	  if(oBoatPrime == OBJECT_INVALID)
		{oBoatPrime = OBJECT_SELF;
		}
		  
	  object oDestination = GetLocalObject(OBJECT_SELF, "oDestination");
	  if(oDestination == OBJECT_INVALID)  
			{oDestination = GetNearestObjectByTag(GetTag(OBJECT_SELF), OBJECT_SELF, 1);
			 SetLocalObject(OBJECT_SELF, "oDestination", oDestination);
			}
	  	   
	  object oVia = GetLocalObject(OBJECT_SELF, "oVia");
	  if(oVia == OBJECT_INVALID)
			{oVia = GetNearestObjectByTag(GetTag(OBJECT_SELF) + "_via", OBJECT_SELF, 1);
			 int iVia = 1;
		     while(iVia <= 5)
				{object oViaObject = GetLocalObject(oBoatPrime, GetName(oVia));
				 if(GetLocalObject(oBoatPrime, GetName(oVia)) != oVia)
					{SetLocalObject(OBJECT_SELF, "oVia", oVia);
					 SetLocalObject(oBoatPrime, GetName(oVia), oVia);
					 AssignCommand(oBoatPrime, DelayCommand(15.0, SetLocalObject(oBoatPrime, GetName(oVia), OBJECT_INVALID)));
					 break;
					 }
				 else
				 	{iVia++;
					 if(iVia == 5)
					 	{oVia = OBJECT_INVALID;}
					 else
					 	{oVia = GetNearestObjectByTag(GetTag(OBJECT_SELF) + "_via", OBJECT_SELF, iVia);
					 	}
					}
				}
			}
			
				 
		 oVia = GetLocalObject(OBJECT_SELF, "oVia");	 
		 location lNext = GetLocation(oVia);
		 location lDestination = GetLocation(oDestination);
		 
		if(GetIsLocationValid(lNext))
		  	{object oNextBoat = CreateObject(OBJECT_TYPE_PLACEABLE, "abr_plc_rowboat", lNext, FALSE, GetTag(OBJECT_SELF));
			  SetLocalObject(oNextBoat, "oPrime", oBoatPrime);
			  SetFirstName(oNextBoat, GetFirstName(OBJECT_SELF));
			  SetLocalObject(oNextBoat, "oBoater", oBoater);
			  SetLocalObject(oNextBoat, "oBoater2", oBoater2);
			  SetLocalObject(oNextBoat, "oBoater3", oBoater3);
			  SetLocalObject(oNextBoat, "oDestination", oDestination);
			  SetLocalLocation(oNextBoat, "lHome", lHome);
			  AssignCommand(oNextBoat, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      AssignCommand(oBoatPrime, DelayCommand(5.0, ExecuteScript("tsm_plc_onused", oNextBoat)));
			  if(GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), lHome) > 5.0)
			  	{DelayCommand(2.0, AssignCommand(oBoater, ActionJumpToLocation(lNext)));
			     DelayCommand(2.5, AssignCommand(oBoater, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE)));
		      	 DelayCommand(2.0, AssignCommand(oBoater2, ActionJumpToLocation(lNext)));
			     DelayCommand(2.5, AssignCommand(oBoater2, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE)));
		      	 DelayCommand(2.0, AssignCommand(oBoater3, ActionJumpToLocation(lNext)));
			     DelayCommand(2.5, AssignCommand(oBoater3, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE)));
		      	 DestroyObject(OBJECT_SELF, 4.0);
				 }
			  else
			  	{AssignCommand(oBoater, ActionJumpToLocation(lNext));
			     AssignCommand(oBoater, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      	 AssignCommand(oBoater2, ActionJumpToLocation(lNext));
			     AssignCommand(oBoater2, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      	 AssignCommand(oBoater3, ActionJumpToLocation(lNext));
			     AssignCommand(oBoater3, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      	 SetLocalObject(oBoatPrime, "oBoater", OBJECT_INVALID);
			     SetLocalObject(oBoatPrime, "oBoater2", OBJECT_INVALID);
			     SetLocalObject(oBoatPrime, "oBoater3", OBJECT_INVALID);
			     }
			}
		  else
			{if(GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), lHome) > 5.0)
			  	{DelayCommand(2.0, AssignCommand(oBoater, ActionJumpToLocation(lDestination)));
			     DelayCommand(2.5, AssignCommand(oBoater, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE)));
		      	 DelayCommand(2.0, AssignCommand(oBoater2, ActionJumpToLocation(lDestination)));
			     DelayCommand(2.5, AssignCommand(oBoater2, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE)));
		      	 DelayCommand(2.0, AssignCommand(oBoater3, ActionJumpToLocation(lDestination)));
			     DelayCommand(2.5, AssignCommand(oBoater3, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE)));
		      	 SetLocalObject(oBoatPrime, "oBoater", OBJECT_INVALID);
			     SetLocalObject(oBoatPrime, "oBoater2", OBJECT_INVALID);
			     SetLocalObject(oBoatPrime, "oBoater3", OBJECT_INVALID);
			     DestroyObject(OBJECT_SELF, 4.0);
				 }
			   else
			  	{AssignCommand(oBoater, ActionJumpToLocation(lDestination));
			     AssignCommand(oBoater, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      	 AssignCommand(oBoater2, ActionJumpToLocation(lDestination));
			     AssignCommand(oBoater2, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      	 AssignCommand(oBoater3, ActionJumpToLocation(lDestination));
			     AssignCommand(oBoater3, SetFacingPoint(GetPositionFromLocation(lDestination), FALSE));
		      	 SetLocalObject(oBoatPrime, "oBoater", OBJECT_INVALID);
			     SetLocalObject(oBoatPrime, "oBoater2", OBJECT_INVALID);
			     SetLocalObject(oBoatPrime, "oBoater3", OBJECT_INVALID);
			     }
			}
	 
	  }
	  
	  
			  
	//Temp AT objects
	
	if(GetTag(OBJECT_SELF)== "abr_plc_temp_at")
		{object oDestination = GetLocalObject(OBJECT_SELF, "oDestination");
		 if(oDestination == OBJECT_INVALID)
		 	{int iInt = 0;
			 oDestination = GetObjectByTagAndType(GetTag(OBJECT_SELF), OBJECT_TYPE_PLACEABLE, iInt);
			 while(oDestination != OBJECT_INVALID)
			 	{SendMessageToAllDMs("oDestination = " + GetName(oDestination));
				 if(GetName(oDestination) == GetName(OBJECT_SELF))
					{SetLocalObject(OBJECT_SELF, "oDestination", oDestination);
					 break; 
					}
				 iInt++;
				 oDestination = GetObjectByTagAndType(GetTag(OBJECT_SELF), OBJECT_TYPE_PLACEABLE, iInt);
			    }
			 
			 }
		 AssignCommand(GetLastUsedBy(), ActionJumpToObject(oDestination));
		}
 
		
	  
	
}