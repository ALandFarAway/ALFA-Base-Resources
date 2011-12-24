#include "ginc_param_const"
#include "kemo_includes"

void main(string sNumber)
{
	object oPC = OBJECT_SELF;
	if (sNumber == "0")
		DisplayGuiScreen(oPC,"KEMO_ANIM_LAPSIT",FALSE,"kemo_anim_lapsit.xml");
	else
	{
		string sAnimB = "kemo_lapsit_" + sNumber;
		string sAnimC = sAnimB + "i";

		StoreAnimation(sAnimB,1.0f);
		StoreIdle(sAnimC);
		SetLocalLocation(oPC,"AnimationLocation",GetLocation(oPC));
		AnimationLoop(oPC,GetLocation(oPC)); // fires the looping idle animation
	}
}