// ga_jump_faction(string sTagOfMember, string sTagOfWayPoint, int iFormation,  string sFormationParams)
/*
   Jump faction into formation at sTagOfWayPoint.

   Parameters:
     string sTagOfMember     = Tag of member in faction to jump.
     string sTagOfWayPoint   = Tag of waypoint.
     int iFormation          = DOES NOTHING.
     string sFormationParams = DOES NOTHING.
*/
// BMA 5/24/05
// ChazM 5/26/05
// ChazM 6/2/05 updated to work w/ new features
// BMA-OEI 1/11/06 removed default param, use default U7 formation
// ChazM 3/3/06 Added error message for when this is used in campaign on a PC to do an area transition

#include "ginc_param_const"
#include "ginc_group"
#include "ginc_transition"

void main(string sTagOfMember, string sTagOfWayPoint, int iFormation, string sFormationParams)
{
	object oTarget = GetTarget(sTagOfMember, TARGET_OBJECT_SELF);
	//float fRadius = StringToFloat(sFormationParams);
	//if (fRadius <= 0.1f) fRadius = 10.0f;
	string sGroupName = "tempGroup";

	ResetGroup(sGroupName);
	GroupAddFaction(sGroupName, oTarget, GROUP_LEADER_FIRST, TRUE);
	GroupSetBMAFormation(sGroupName);

	if (GetIsPC(oTarget) && (GetGlobalInt(VAR_GLOBAL_GATHER_PARTY)==1) && (GetArea(oTarget) != GetArea(GetWaypointByTag(sTagOfWayPoint))) )
	{
		PrettyError("Area transition of PC's made using ga_jump_faction in a campaign module.  Please report this as an error.");
	}

    GroupMoveToWP(sGroupName, sTagOfWayPoint, MOVE_JUMP_INSTANT);
}