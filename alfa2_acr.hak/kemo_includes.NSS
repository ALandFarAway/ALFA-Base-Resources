#include "acr_movement_i"

// Determines the loop animation trigger delay based on PC's race/subrace; KEMO Emotes/Partners only
float RacialDelay(object oTarget);

// Plays the custom animation with an automatic loop, which works around the animation bug
void PlayKemoAnimation(object oTarget, string sAnim);

// Turns the PC to face the direction of the chair
void SetChairFacing(object oPC, object oChair);

// This function works around the NWN2 bug where PCs entering an area do not see looping animations that
// are currently in progress. AnimationLoop re-triggers the animation at a set interval as long as the PC has
// not moved from the original spot. lCurrentSpot is the animation's starting location, which is checked against
// the PC's current location.
void AnimationLoop(object oPC, location lCurrentSpot);

// Stores the parameters necessary to re-trigger the starting current/previous animation.
void StoreAnimation(string sAnim, float fDelay);

// Stores the parameters necessary to re-trigger the idle of the current/previous animation.
void StoreIdle(string sAnim);

float RacialDelay(object oTarget)
{
	switch (GetSubRace(oTarget)) // attempts to deal with the varying race speeds
		// I use this instead of a fractional animation speed because a fractional speed causes the
		// PC to move more slowly than is normal for his/her race
		// without these switches, a non-human-sized PC will "jump" right before the looping animation
	{
		case RACIAL_SUBTYPE_DROW: return 0.8f; break;
	}
	switch (GetRacialType(oTarget))	{
		case RACIAL_TYPE_HALFLING: return 0.5f; break; 
		case RACIAL_TYPE_ELF: return 0.9f; break; 
		case RACIAL_TYPE_HALFELF: return 0.95f; break; 
	}

	return 1.0f;
}

void PlayKemoAnimation(object oTarget, string sAnim)	//so it returns a void
{
	PlayCustomAnimation(oTarget,sAnim,1);
}

void SetChairFacing(object oPC, object oChair)
{
	float fChairFace = GetFacing(oChair);
	string sChairTag = GetTag(oChair);
	float fRot = GetLocalFloat(oChair,"ROTATE");

	if (fabs(fRot) > 0.01)
		fChairFace += fRot;
	
	if (sChairTag == "kemo_chair_4")
		return;

	if (sChairTag == "kemo_bench_2" ||
		sChairTag == "kemo_chair_5")
		{}
	else if (sChairTag == "kemo_booth_1")
		fChairFace -= 90.0f;
	else
		fChairFace += 180.0f;

	AssignCommand(oPC,SetFacing(fChairFace));
}

void AnimationLoop(object oPC, location lCurrentSpot)
{
    /* This script now sets the animation information on a Secret Object and starts its heartbeat
    on a 48 second interval. If the Ipoint already exists, it transfers the new animation
    name to that Secret Object. Thanks to GrinningFool for this more elegant solution. 7/29/08 */
    object oPoint = GetLocalObject(oPC,"AnimationPoint");
    string sAnim = GetLocalString(oPC,"StoredAnimationIdle");

    ACR_SetCollision(oPC,0); //turns collision off for the course of the animation.
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(81, "****","****","kemo_move"), GetLocation(oPC));
    if (oPoint != OBJECT_INVALID)
    {
        SetLocalString(oPoint,"StoredAnimationIdle",sAnim);
        PlayKemoAnimation(oPC,sAnim);
    }
    else
    {
        object oPoint = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_secretobject",lCurrentSpot,FALSE,"AnimationPoint");
        SetLocalObject(oPC,"AnimationPoint",oPoint);
        SetLocalObject(oPoint,"StoredAnimationPC",oPC);
        SetLocalString(oPoint,"StoredAnimationIdle",sAnim);
        SetUseableFlag(oPoint,0);
        SetCustomHeartbeat(oPoint,12000);
        SetEventHandler(oPoint,SCRIPT_PLACEABLE_ON_HEARTBEAT,"kemo_animation_hb");
        PlayKemoAnimation(oPC,sAnim);
    }
}

/* the following is the original loop script, now replaced with a heartbeat on an Ipoint 7/29/08
{
	object oPC = OBJECT_SELF;
	location lSpot = GetLocalLocation(oPC,"AnimationLocation");
	vector vSpot = GetPositionFromLocation(lSpot);
	vector vCurrentSpot = GetPositionFromLocation(lCurrentSpot);
	string sAnim = GetLocalString(oPC,"StoredAnimationIdle");
	int iOverlap = GetLocalInt(oPC,"AnimationOverlap");
	
	// This function gets re-called for each new animation, so that more than one iteration of the
	// function can be running at the same time if the PC hasn't spent at least 48 seconds not in an
	// animation. The first two IF statements eliminate the excess function iterations (the overlaps)
	// while continuing to show the current animation. The third IF statement continues the animation
	// if the PC is still in the same spot. The ELSE statement clears the overlap count if all animations
	// have ceased (through PC movement without a new animation).
	//SendMessageToPC(oPC,"Overlap: " + IntToString(iOverlap)); //debug line
	//SendMessageToPC(oPC,"Animation: " + sAnim);				//debug line
	
	if (vSpot != vCurrentSpot)
	{
		iOverlap = 1;
		SetLocalInt(oPC,"AnimationOverlap",iOverlap);
		return;					 
	}
	if (iOverlap > 1)
	{
		iOverlap--;
		SetLocalInt(oPC,"AnimationOverlap",iOverlap);						 
		ActionDoCommand(PlayKemoAnimation(oPC,sAnim));
		return;
	}
	if (vSpot == GetPosition(oPC))
	{
		ActionDoCommand(PlayKemoAnimation(oPC,sAnim));
		ActionDoCommand(DelayCommand(48.0f,AnimationLoop(lCurrentSpot)));
	}
	else SetLocalInt(oPC,"AnimationOverlap",0);
}*/

void StoreAnimation(string sAnim, float fDelay)
{
	SetLocalString(OBJECT_SELF,"StoredAnimation",sAnim); // stores the animation name for re-triggering
	SetLocalFloat(OBJECT_SELF,"StoredDelay",fDelay); // stores the delay for re-triggering		
}

void StoreIdle(string sAnim)
{
	SetLocalString(OBJECT_SELF,"StoredAnimationIdle",sAnim);
}
