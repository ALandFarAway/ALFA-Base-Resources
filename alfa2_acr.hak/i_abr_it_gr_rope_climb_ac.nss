//OnActivate for climbing items
//Wynna May 2009



#include "acr_creature_i"
#include "acr_xp_i"
#include "acr_quest_i"

// float GetNormalizedDirection(float fDirection):
// * This script returns a direction normalized to the range 0.0 - 360.0
// * Copyright (c) 2002 Floodgate Entertainment
// * Created By: Naomi Novik
// * Created On: 11/08/2002


void ACR_ApplyNLDDamageToCreature(object oTarget, int nSubdualDamage);


void ACR_ApplyNLDDamageToCreature(object oTarget, int nSubdualDamage)
{
    int nNLDTotal = _GetNLDTotal(oTarget);
    int nHPMax = GetMaxHitPoints(oTarget);
    int nCap = nHPMax + 10;
    nNLDTotal = ((nNLDTotal + nSubdualDamage) > nCap) ? nCap :
            nNLDTotal + nSubdualDamage;
    _SetNLDTotal(oTarget, nNLDTotal);
    ACR_ApplyNLDEffects(oTarget, nNLDTotal);
}

void main()
{
	 object oUser = GetItemActivator();
	 location lUser = GetLocation(oUser);
	 location lDest;
	 object oRopedOn1 = GetLocalObject(OBJECT_SELF, "oRopedOn1");
	 object oRopedOn2 = GetLocalObject(OBJECT_SELF, "oRopedOn2");
	 if((oRopedOn1 == GetItemActivatedTarget()) && (GetIsPC(GetItemActivatedTarget())))
	 	{FloatingTextStringOnCreature(GetName(oUser) + " unties " + GetName(oRopedOn1), oUser, TRUE);
		 AssignCommand(oRopedOn1, (ClearAllActions(TRUE)));
		 oRopedOn1 = OBJECT_INVALID;
		 SetLocalObject(OBJECT_SELF, "oRopedOn1", OBJECT_INVALID);
		 }
	 else if((oRopedOn2 == GetItemActivatedTarget()) && (GetIsPC(GetItemActivatedTarget())))
	 	{FloatingTextStringOnCreature(GetName(oUser) + " unties " + GetName(oRopedOn2), oUser, TRUE);
		 AssignCommand(oRopedOn2, (ClearAllActions(TRUE)));
		 oRopedOn2 = OBJECT_INVALID;
		 SetLocalObject(OBJECT_SELF, "oRopedOn2", OBJECT_INVALID);
		 }
	 else if ((GetIsPC(GetItemActivatedTarget())) && (oRopedOn1 == OBJECT_INVALID) && (oRopedOn2 == OBJECT_INVALID))
		{oRopedOn1 = GetItemActivatedTarget();
		 SetLocalObject(OBJECT_SELF, "oRopedOn1", oRopedOn1);
		 FloatingTextStringOnCreature(GetName(oUser) + " belays on " + GetName(oRopedOn1), oUser, TRUE);
		 AssignCommand(oRopedOn1, ActionForceFollowObject(oUser, 10.0));
		 }
	 else if ((GetIsPC(GetItemActivatedTarget())) && (oRopedOn2 == OBJECT_INVALID))
		{oRopedOn2 = GetItemActivatedTarget();
		 SetLocalObject(OBJECT_SELF, "oRopedOn2", oRopedOn2);
		 FloatingTextStringOnCreature(GetName(oUser) + " belays on " +  GetName(oRopedOn2) + " behind " + GetName(oRopedOn1), oUser, TRUE);
		 AssignCommand(oRopedOn2, ActionForceFollowObject(oRopedOn1, 10.0));
		 }
	 else if (GetIsPC(GetItemActivatedTarget()) && (oRopedOn1 != OBJECT_INVALID) && (oRopedOn2!= OBJECT_INVALID) && (oRopedOn1 != GetItemActivatedTarget()) && (oRopedOn2 != GetItemActivatedTarget())) 
		{FloatingTextStringOnCreature(GetName(oUser) + ", " + GetName(oRopedOn1) + " and " + GetName(oRopedOn2) + " are all belayed on. The rope is only long enough for three." , oUser, TRUE);
		 }
	 else 
	 	{lDest = GetItemActivatedTargetLocation();
	 
		
		 vector vUser = GetPositionFromLocation(lUser);
		 vector vDest = GetPositionFromLocation(lDest);
		 float vUserx = vUser.x;
		 float vUsery = vUser.y;
		 float vUserz = vUser.z;
		 string sUserx = FloatToString(vUserx);
		 string sUsery = FloatToString(vUsery);
		 string sUserz = FloatToString(vUserz);
		 float vDestx = vDest.x;
		 float vDesty = vDest.y;
		 float vDestz = vDest.z;
		 string sDestx = FloatToString(vDestx);
		 string sDesty = FloatToString(vDesty);
		 string sDestz = FloatToString(vDestz);
		 float xChange = vDestx - vUserx;
		 float yChange = vDesty - vUsery;
		 float zChange = vDestz - vUserz;
		 SendMessageToPC(oUser, "Altitude change = " + FloatToString(zChange));
		 float fDistance = GetDistanceBetweenLocations(lUser, lDest);
		 SendMessageToPC(oUser, "Distance = " + FloatToString(fDistance));
		 if(fDistance > 16.6)
		 	{FloatingTextStringOnCreature("The rope will not reach that far.", oUser, TRUE);
			 return;
			 }
		float fSlope = zChange / fDistance;
			
		if((fSlope < 0.6) && (fSlope > -0.6))
			{FloatingTextStringOnCreature(GetName(oUser) + " The slope is not steep enough to require a rope and grapple.", oUser, TRUE);
			 return;
			 }
			 
		 int iDC = 5;
		 if((fSlope >= 0.6) || (fSlope <= -0.6))
		 	{iDC = 10;}
		 if((fSlope > 0.9) || (fSlope < -0.9))
		 	{iDC = 15;}
		 if((fSlope > 0.95)|| (fSlope < -0.95))
		 	{iDC = 20;}
		 if((fSlope >= 1.0)|| (fSlope < -1.0))
		 	{iDC = 25;}
			
		 if(fDistance > 10.0)
		 	{iDC = iDC +5;}
		 SendMessageToPC(oUser, "ClimbDC = " + IntToString(iDC));
		 
		 effect eKnockdown = EffectKnockdown();
		 int iClimbRoll = GetSkillRank(SKILL_CLIMB, oUser, FALSE) + d20(1);
		 int iClimbRollRoped1 = GetSkillRank(SKILL_CLIMB, oRopedOn1, FALSE) + d20(1);
		 int iClimbRollRoped2 = GetSkillRank(SKILL_CLIMB, oRopedOn2, FALSE) + d20(1);
		 int iStrength = GetAbilityModifier(ABILITY_STRENGTH, oUser);
		 int iStrengthRoped1 = GetAbilityModifier(ABILITY_STRENGTH, oRopedOn1);
		 int iStrengthRoped2 = GetAbilityModifier(ABILITY_STRENGTH, oRopedOn2);
		 int iHalflingBonus = 0;
		 if(GetSubRace(oUser) == RACIAL_TYPE_HALFLING)
			 	{iHalflingBonus = 2;}
		 int iHalflingBonusRoped1 = 0;
		 if(GetSubRace(oRopedOn1) == RACIAL_TYPE_HALFLING)
			 	{iHalflingBonusRoped1 = 2;}
		 int iHalflingBonusRoped2 = 0;
		 if(GetSubRace(oRopedOn2) == RACIAL_TYPE_HALFLING)
			 	{iHalflingBonusRoped2 = 2;}
		 float fRadius = 7.5;
		 location lClimbTo = CalcSafeLocation(oUser, lDest, fRadius, FALSE, FALSE);
		 if(lClimbTo == lUser)
					{FloatingTextStringOnCreature("There is nothing at that spot for the grapple to catch and hold onto. Perhaps a different spot would offer a safer target.", oUser, TRUE);
					 return;
					}			 
			 			 
		 SendMessageToPC(oUser, "Climb Roll = " + IntToString(iClimbRoll));
		 int iHeightDmgPotential;
		 int iFallDmg;
		 effect eFallDamage;
		 float zChangeEnd;
		 string sNames = GetName(oUser) + " makes";
		 if((oRopedOn1 != OBJECT_INVALID) && (oRopedOn2 == OBJECT_INVALID))
		 	{sNames = GetName(oUser) + " and " + GetName(oRopedOn1) + " make";
			}
		 else if ((oRopedOn1 == OBJECT_INVALID) && (oRopedOn2 != OBJECT_INVALID))
		 	{sNames = GetName(oUser) + " and " + GetName(oRopedOn2) + " make";
			}
		 else if ((oRopedOn1 != OBJECT_INVALID) && (oRopedOn2 != OBJECT_INVALID))
		 	{sNames = GetName(oUser) + "," + GetName(oRopedOn1) + " and " + GetName(oRopedOn2) + " make";
			}
			
		int iUserClimb = 2 + iStrength + iHalflingBonus + iClimbRoll;
		int iRoped1Climb;
		if(oRopedOn1 != OBJECT_INVALID)
			{iRoped1Climb = 2 + iStrengthRoped1 + iHalflingBonusRoped1 + iClimbRollRoped1;}
			
		int iRoped2Climb; 
		if(oRopedOn1 != OBJECT_INVALID)
			{iRoped2Climb = 2 + iStrengthRoped2 + iHalflingBonusRoped2 + iClimbRollRoped2 ;}
			
		 if((iUserClimb >= iDC) && (((iRoped1Climb >= iDC) || (oRopedOn1 == OBJECT_INVALID)) && ((iRoped2Climb >= iDC) || (oRopedOn2 == OBJECT_INVALID))))
				     	{FloatingTextStringOnCreature("You climb safely to your destination.", oUser, TRUE);
						 AssignCommand(oUser, ActionJumpToLocation(lClimbTo));
		 				 DelayCommand(2.0, FloatingTextStringOnCreature("With the help of the lead climber, " + GetName(oRopedOn1) + " climbs safely to the destination.", oRopedOn1, TRUE));
						 DelayCommand(2.0, AssignCommand(oRopedOn1, ActionJumpToLocation(lClimbTo)));
		 				 DelayCommand(4.0, FloatingTextStringOnCreature("With the help of those ahead, " + GetName(oRopedOn2) + " climbs safely to the destination.", oRopedOn2, TRUE));
						 DelayCommand(4.0, AssignCommand(oRopedOn2, ActionJumpToLocation(lClimbTo)));
						 }
		 else if(iUserClimb >= iDC - 4)
					    {FloatingTextStringOnCreature(GetName(oUser) + " cannot find a way onward so " + sNames + " no progress in climbing this time.", oUser, TRUE);
						 return;
						 }		 
		 else if((iRoped1Climb >= iDC - 4) && (oRopedOn1 != OBJECT_INVALID))
					    {FloatingTextStringOnCreature(GetName(oRopedOn1) + " cannot manage to follow " + GetName(oUser) + " so " +  sNames + " no progress in climbing this time.", oRopedOn1, TRUE);
						 return;
						 }		 
		 else if((iRoped2Climb >= iDC - 4) && (oRopedOn2 != OBJECT_INVALID))
					    {FloatingTextStringOnCreature(GetName(oRopedOn2) + " cannot manage to follow the others, so " + sNames + " no progress in climbing this time.", oRopedOn2, TRUE);
						 return;
						 }		 
		 else if(iUserClimb < iDC - 4)
					    {FloatingTextStringOnCreature(GetName(oUser) + " falls!", oUser, TRUE);
						 int iUserFall = 1;
						 int iRoped1Fall;
						 int iRoped2Fall;
						 int iRoped1BAB = GetBaseAttackBonus(oRopedOn1);
						 int iRoped1Size;
						 if(GetCreatureSize(oRopedOn1) == CREATURE_SIZE_SMALL)
						 	{iRoped1Size = 1;}
						 int iRoped1Catch = iStrengthRoped1 + iRoped1BAB + iRoped1Size + d20(1);
		 				 int iRoped2BAB = GetBaseAttackBonus(oRopedOn2);
						 int iRoped2Size;
						 if(GetCreatureSize(oRopedOn2) == CREATURE_SIZE_SMALL)
						 	{iRoped2Size = 1;}
						 int iRoped2Catch = iStrengthRoped2 + iRoped2BAB + iRoped2Size + d20(1);
						 string sGenderUser = "his";
						 if(GetGender(oUser) == GENDER_FEMALE)
						 	{sGenderUser = "her";}
						 string sGenderRoped1 = "his";
						 if(GetGender(oRopedOn1) == GENDER_FEMALE)
						 	{sGenderRoped1 = "her";}
						 string sGenderRoped2 = "his";
						 if(GetGender(oRopedOn2) == GENDER_FEMALE)
						 	{sGenderRoped2 = "her";}
						 
						 if(iRoped1Catch >= iDC + 10)
						 	{FloatingTextStringOnCreature(GetName(oRopedOn1) + " catches " + GetName(oUser) + "!", oRopedOn1, TRUE);
							 iUserFall = 0;
							 return;
							 }
						 else if(iRoped1Catch >= iDC + 6)
						 	{FloatingTextStringOnCreature(GetName(oRopedOn1) + " does not catch " + GetName(oUser) + "!", oRopedOn1, TRUE);
							 if(iRoped2Catch >= iDC + 10)
							 	{FloatingTextStringOnCreature(GetName(oRopedOn2) + " catches " + GetName(oUser) + "!", oRopedOn2, TRUE);
								 iUserFall = 0;
								 return;
								 }
							  else if(iRoped2Catch >= iDC + 6)
						 		{FloatingTextStringOnCreature(GetName(oRopedOn2) + " does not catch " + GetName(oUser) + "!", oRopedOn2, TRUE);
							 	}
							  else if((iRoped2Catch < iDC + 6) && (oRopedOn2 != OBJECT_INVALID))
							 	{DelayCommand(1.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " does not catch " + GetName(oUser) + " and is falling too!", oRopedOn2, TRUE));
								 iRoped2Fall = 1;
						    	}
							}
						 else if((iRoped1Catch < iDC + 6) && (oRopedOn1 != OBJECT_INVALID))
						 	{FloatingTextStringOnCreature(GetName(oRopedOn1) + " does not catch " + GetName(oUser) + " and is falling too!", oRopedOn1, TRUE);
							 int iRoped1Fall = 1;
							 if((iRoped2Catch >= iDC + 10) && (iRoped2Fall != 1))
							 	{FloatingTextStringOnCreature(GetName(oRopedOn2) + " catches " + GetName(oRopedOn1) + "!", oRopedOn2, TRUE);
								 iRoped1Fall = 0;
							    }
							  else if(iRoped2Catch >= iDC + 6)
						 		{FloatingTextStringOnCreature(GetName(oRopedOn2) + " does not catch " + GetName(oRopedOn1) + "!", oRopedOn2, TRUE);
							 	}
							  else if((iRoped2Catch < iDC + 6) && (iRoped2Fall != 1) && (oRopedOn2 != OBJECT_INVALID))
							 	{DelayCommand(1.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " is pulled off the cliff by the other falling climbers!", oRopedOn2, TRUE));
								 iRoped2Fall = 1;
						    	}
						    }
						
						 int iTotal;	
						 if((oRopedOn1 != OBJECT_INVALID) && (oRopedOn2 != OBJECT_INVALID))
						 	{iTotal = iUserFall + iRoped1Fall + iRoped2Fall;
							 if(iTotal == 3)
							 	{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " cannot halt " + sGenderUser + " fall.", oUser, TRUE));
								 iUserFall = 0;
						    	 DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " cannot halt " + sGenderRoped1 + " fall.", oRopedOn1, TRUE));
								 iRoped1Fall = 0;
						    	DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " cannot halt " + sGenderRoped2 + " fall.", oRopedOn2, TRUE));
								 iRoped2Fall = 0;
						    	}
							 if(iTotal == 2)
							 	{if(iUserFall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " is pulled off the cliff by the other falling climbers!", oUser, TRUE));}
								 iUserFall = 0;
						    	 if(iRoped1Fall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " is pulled off the cliff by the other falling climbers!", oRopedOn1, TRUE));}
								 iRoped1Fall = 0;
						    	 if(iRoped2Fall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " is pulled off the cliff by the other falling climbers!", oRopedOn2, TRUE));}
								 iRoped2Fall = 0;
						    	}
							  if(iTotal <= 1)
							 	{if(iUserFall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " digs in " + sGenderUser + "heels and stabilizes a falling climber!", oUser, TRUE));}
								 else if(iUserFall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " is anchored safely by the combined efforts of the other climbers!", oUser, TRUE));}
								 iUserFall = 0;
						    	 if(iRoped1Fall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " digs in " + sGenderRoped1 + "heels and stabilizes a falling climber!", oRopedOn1, TRUE));}
								 else if(iRoped1Fall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " is anchored safely by the combined efforts of the other climbers!", oRopedOn1, TRUE));}
								 iRoped1Fall = 0;
						    	 if(iRoped2Fall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " digs in " + sGenderRoped2 + "heels and stabilizes a falling climber!", oRopedOn2, TRUE));}
								 else if(iRoped2Fall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " is anchored safely by the combined efforts of the other climbers!", oRopedOn2, TRUE));}
								 iRoped2Fall = 0;
						    	 return;
								 }
							   
							 }
		 				 else if((oRopedOn1 != OBJECT_INVALID) && (oRopedOn2 == OBJECT_INVALID))
						 	{iTotal = iUserFall + iRoped1Fall;
							 if(iTotal == 2)
							 	{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " cannot halt " + sGenderUser + " fall.", oUser, TRUE));
								 iUserFall = 0;
						    	 DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " cannot halt " + sGenderRoped1 + " fall.", oRopedOn1, TRUE));
								 iRoped1Fall = 0;
						    	 iRoped2Fall = 0;
						    	}
							 if(iTotal <= 1)
							 	{if(iUserFall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " digs in " + sGenderUser + "heels and stabilizes " + sGenderUser + " falling partner!", oUser, TRUE));}
								 else if(iUserFall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " is anchored safely by " + sGenderUser + " partner!", oUser, TRUE));}
								 iUserFall = 0;
						    	 if(iRoped1Fall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " digs in " + sGenderRoped1 + "heels and stabilizes " + sGenderRoped1 + " falling partner!", oRopedOn1, TRUE));}
								 else if(iRoped1Fall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn1) + " is anchored safely by " + sGenderRoped1 + " partner!", oRopedOn1, TRUE));}
								 iRoped1Fall = 0;
						    	 iRoped2Fall = 0;
						    	 return;
								 }
							}
		 				 else if((oRopedOn1 == OBJECT_INVALID) && (oRopedOn2 != OBJECT_INVALID))
						 	{iTotal = iUserFall + iRoped2Fall;
							 if(iTotal == 2)
							 	{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " cannot halt " + sGenderUser + " fall.", oUser, TRUE));
								 iUserFall = 0;
						    	 DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " cannot halt " + sGenderRoped2 + " fall.", oRopedOn2, TRUE));
								 iRoped1Fall = 0;
						    	 iRoped2Fall = 0;
						    	}
							 if(iTotal <= 1)
							 	{if(iUserFall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " digs in " + sGenderUser + "heels and stabilizes " + sGenderUser + " falling partner!", oUser, TRUE));}
								 else if(iUserFall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oUser) + " is anchored safely by " + sGenderUser + " partner!", oUser, TRUE));}
								 iUserFall = 0;
						    	 if(iRoped1Fall == 0)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " digs in " + sGenderRoped2 + "heels and stabilizes " + sGenderRoped2 + " falling partner!", oRopedOn2, TRUE));}
								 else if(iRoped1Fall == 1)
									{DelayCommand(3.0, FloatingTextStringOnCreature(GetName(oRopedOn2) + " is anchored safely by " + sGenderRoped2 + " partner!", oRopedOn2, TRUE));}
								 iRoped1Fall = 0;
						    	 iRoped2Fall = 0;
						    	 return;
								 }
							}
		 				 else if((oRopedOn1 == OBJECT_INVALID) && (oRopedOn2 == OBJECT_INVALID) && (iUserFall == 0))
						 	{return;}
						  
		 				 
						 
						 int iFall = Random(100)/100;
						 int iFall2 = Random(200)/100;
						 vector vFall1 = Vector(vUser.x + (xChange*iFall), vUser.y + (yChange*iFall), vUser.z + (zChange*iFall));
						 location lFall1 = Location(GetArea(oUser), vFall1, GetFacing(oUser));
						 location lFall2 = CalcSafeLocation(oUser, lFall1, 5.0, FALSE, FALSE);
						 vector vFall3 = Vector(vUser.x - (xChange*iFall), vUser.y - (yChange*iFall), vUser.z - (zChange*iFall));
						 if(zChange < 0.0)
						 	{vFall3 = Vector(vDest.x + (xChange*iFall), vDest.y + (yChange*iFall), vDest.z + (zChange*iFall));
							 }
						 location lFall3 = Location(GetArea(oUser), vFall3, GetFacing(oUser));
						 location lFall4 = CalcSafeLocation(oUser, lFall3, 5.0, FALSE, FALSE);
						 vector vFall5 = Vector(vUser.x - (xChange*iFall2), vUser.y - (yChange*iFall2), vUser.z - (zChange*iFall2));
						 if(zChange < 0.0)
						 	{vFall5 = Vector(vDest.x + (xChange*iFall2), vDest.y + (yChange*iFall2), vDest.z + (zChange*iFall2));
							 }
						 location lFall5 = Location(GetArea(oUser), vFall5, GetFacing(oUser));
						 location lFall6 = CalcSafeLocation(oUser, lFall5, 5.0, FALSE, FALSE);
						 	
						 
						 location lEnd;
						 
			 			 if(lFall1 == lUser)
						 	{SendMessageToPC(oUser, "lFall1 = lUser");
							}
						 else if (lFall1 != lUser)
						 	{AssignCommand(oUser, ActionJumpToLocation(lFall1));
							 DelayCommand(1.0, AssignCommand(oRopedOn1, ActionJumpToLocation(lFall1)));
							 DelayCommand(2.0, AssignCommand(oRopedOn2, ActionJumpToLocation(lFall1)));
							 lEnd = lFall1;
							 }
		 				 if (lFall2 != lUser)
						 	{DelayCommand(0.5, AssignCommand(oUser, ActionJumpToLocation(lFall2)));
							 DelayCommand(1.5, AssignCommand(oRopedOn1, ActionJumpToLocation(lFall2)));
							 DelayCommand(1.5, AssignCommand(oRopedOn2, ActionJumpToLocation(lFall2)));
							 lEnd = lFall2;
							 }
		 				 if (lFall3 != lUser)
						 	{DelayCommand(1.0, AssignCommand(oUser, ActionJumpToLocation(lFall3)));
							 DelayCommand(2.0, AssignCommand(oRopedOn1, ActionJumpToLocation(lFall3)));
							 DelayCommand(3.0, AssignCommand(oRopedOn2, ActionJumpToLocation(lFall3)));
							 lEnd = lFall3;
							 }
		 				 if (lFall4 != lUser)
						 	{DelayCommand(1.5, AssignCommand(oUser, ActionJumpToLocation(lFall4)));
							 DelayCommand(2.5, AssignCommand(oRopedOn1, ActionJumpToLocation(lFall4)));
							 DelayCommand(3.5, AssignCommand(oRopedOn2, ActionJumpToLocation(lFall4)));
							 lEnd = lFall4;
							 }
		 				 if (lFall5 != lUser)
						 	{DelayCommand(2.0, AssignCommand(oUser, ActionJumpToLocation(lFall5)));
							 DelayCommand(3.0, AssignCommand(oRopedOn1, ActionJumpToLocation(lFall5)));
							 DelayCommand(4.0, AssignCommand(oRopedOn2, ActionJumpToLocation(lFall5)));
							 lEnd = lFall5;
							 }
		 				 if (lFall6 != lUser)
						 	{DelayCommand(2.5, AssignCommand(oUser, ActionJumpToLocation(lFall6)));
							 DelayCommand(3.5, AssignCommand(oRopedOn1, ActionJumpToLocation(lFall6)));
							 DelayCommand(4.5, AssignCommand(oRopedOn2, ActionJumpToLocation(lFall6)));
							 lEnd = lFall6;
							 }
		 				 
						 float vFall1z = vFall1.z;
						 vector vFall2 = GetPositionFromLocation(lFall2);
						 float vFall2z = vFall2.z;
						 float vFall3z = vFall3.z;
						 vector vFall4 = GetPositionFromLocation(lFall4);
						 float vFall4z = vFall4.z;
						 float vFall5z = vFall5.z;
						 vector vFall6 = GetPositionFromLocation(lFall6);
						 float vFall6z = vFall6.z;
						 vector vEnd = GetPositionFromLocation(lEnd);
						 float vEndz = vEnd.z;
						 
						 zChangeEnd = vEndz - vUserz;
						 if(zChange > 0.0)
						 	{zChangeEnd = vEndz - vDestz;
							}
						 
						 
						 if(GetIsSkillSuccessful(oUser, SKILL_TUMBLE, 15, TRUE))
						 	{int iNonLethal = d6(1);
							 SendMessageToPC(oUser, "iNonLethal = " + IntToString(iNonLethal));
							 DelayCommand(2.7, ACR_ApplyNLDDamageToCreature(oUser, iNonLethal));
							 DelayCommand(2.7, ACR_NLD_ReportTotal(oUser, oUser, 0));
						 	 DelayCommand(3.7, ACR_ApplyNLDDamageToCreature(oRopedOn1, iNonLethal));
							 DelayCommand(3.7, ACR_NLD_ReportTotal(oRopedOn1, oRopedOn1, 0));
						 	 DelayCommand(4.7, ACR_ApplyNLDDamageToCreature(oRopedOn2, iNonLethal));
							 DelayCommand(4.7, ACR_NLD_ReportTotal(oRopedOn2, oRopedOn2, 0));
						 	 iHeightDmgPotential = FloatToInt(((zChangeEnd* -1) - 6.6) / 3.3) * 6;
							 }
		 				 else
						 	{iHeightDmgPotential = FloatToInt(((zChangeEnd) *-1)/3.3) * 6;
						 	 }
						  iFallDmg = Random(iHeightDmgPotential);
						  eFallDamage = EffectDamage(iFallDmg, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, FALSE);
						  DelayCommand(2.75, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFallDamage, oUser));
						  DelayCommand(2.75, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oUser, 5.0));
						  DelayCommand(3.75, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFallDamage, oRopedOn1));
						  DelayCommand(3.75, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oRopedOn1, 5.0));
						  DelayCommand(4.75, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFallDamage, oRopedOn2));
						  DelayCommand(4.75, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oRopedOn2, 5.0));
						  }
			}	
	 }

