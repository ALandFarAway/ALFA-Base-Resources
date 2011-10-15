// kemo_chair_anim
// called by kemo_sitting_conv
// 7/20/08 by KEMO
// now called by kemo_chairs.xml --KEMO 3/11/09

#include "ginc_param_const"
#include "kemo_includes"

void main(string sPose)
{
	//object oPC = GetPCSpeaker();
	object oPC = GetControlledCharacter(OBJECT_SELF);
	
	if (sPose == "close")
	{
		SetCommandable(1,oPC); // allows the PC to move again after the interface closes
		return;
	}
	
	string sAnim;
	if (sPose == "0") // dwarves, gnomes and half-orcs
		sAnim = GetLocalString(oPC,"SittingPose");
	else sAnim = GetLocalString(oPC,"SittingPose") + sPose;
	location lChairLoc = GetLocation(oPC);
	object oChair = GetLocalObject(oPC,"SittingChair");
	int iOverlap = GetLocalInt(oPC,"AnimationOverlap"); //animation count (to check overlapped animations)
	iOverlap++; SetLocalInt(oPC,"AnimationOverlap",iOverlap);
	
	SetCommandable(1,oPC); // allows the PC to move again after the interface closes
	SetChairFacing(oPC,oChair);
	SetLocalLocation(oPC,"AnimationLocation",lChairLoc);

	AssignCommand(oPC,StoreIdle(sAnim));

	DelayCommand(1.0,SetOrientOnDialog(oPC,TRUE)); //fixes the post-dialogue-with-placeable bug
	AssignCommand(oPC,AnimationLoop(oPC, lChairLoc));
}