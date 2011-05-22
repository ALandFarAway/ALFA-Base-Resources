//  ga_jump_party_in_formation
//  CGaw 3/16/06
//
//  Jumps entire party to a waypoint in the formation specified.
//
// 	string sWaypoint - the string of tag to jump the party to.
//
// 	int iFormationNum - the number that corresponds to the formation you want the party	
//		jumped in.
//		0 = BenMa Formation - creates a standard party group formation:
//		       1       
//		      2 3       
//		     4 5 6       
//		      7 8  
//		1 = Line Formation
//		2 = Half circle formation, facing outward
//		3 = Full circle formation, facing outward
//		4 = Rectangle formation
//
//	float fFormationTightness - float value to determine how far apart each party member
//		is from one another.  Each formation type has a specified default value:
//		0 = 1.5f
//		1 = 1.5f
//		2 = 1.5f
// 		3 = 1.5f
//		4 = 1.5f
//
//	int bDisableNoise - determines whether noise for imperfect group formations should
//		be applied.
//		0 = default noise values applied (DEFAULT VALUE)
//		1 = noise disabled
//	Note: To ensure that the party group appears in the expected formation, each party
//		member's associate state for "NW_ASC_MODE_STAND_GROUND" should be set to FALSE. 
//		The global script ga_party_freeze can also be used to accomplish this.

#include "ginc_group"

void main(string sWaypoint, int iFormationNum, float fFormationTightness, int bDisableNoise)
{
	object oPC = GetFirstPC();
	string sGroupName = "Party_Jump_Group";

	ResetGroup(sGroupName);
	GroupAddFaction(sGroupName, oPC, GROUP_LEADER_FIRST, TRUE);

	if (fFormationTightness < 0.1)
	{
		fFormationTightness = 1.5f;
	}

	
	switch(iFormationNum)
	{
		case 0:
			GroupSetBMAFormation(sGroupName, fFormationTightness);
			break;
		case 1:
			GroupSetLineFormation(sGroupName, fFormationTightness);
			break;
		case 2:
			GroupSetSemicircleFormation(sGroupName, FORMATION_SEMICIRCLE_FACE_OUT, fFormationTightness);
			break;
		case 3:
			GroupSetCircleFormation(sGroupName, FORMATION_HUDDLE_FACE_OUT, fFormationTightness);
			break;
		case 4:
			GroupSetRectangleFormation(sGroupName, fFormationTightness);
			break;
		default:
			GroupSetBMAFormation(sGroupName, fFormationTightness);
			break;
	}

	switch(bDisableNoise)
	{
		case 0:
			GroupSetNoise(sGroupName, 0.0f, 10.0f, 0.5f);
			break;
		case 1:
			break;
		default:
			GroupSetNoise(sGroupName, 0.0f, 10.0f, 0.5f);
			break;			
	}

	GroupJumpToWP(sGroupName, sWaypoint);
}