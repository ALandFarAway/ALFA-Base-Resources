// ga_alignment
/*
    This changes the player's alignment
        nActType     = From a scale from +3 (Saintly/Paragon) to -3 (Fiendish/Anarchic), 
				      how much the act affects alignment
        bLawChaosAxis = 0 means adjust Good/Evil axis, 1 means adjust Law/Chaos axis
*/
// FAB 10/5
// EPF 6/6/05 chose different variable name for second parameter
// ChazM 4/3/06 - Added conversion functions to maintain the functionality of this script, calibrated to the 101 point scale being used.
// DBR 4/13/6 - Adjustment was being converted as if it was a final value instead of a delta.
// DBR 4/18/6 - forgot to adjust for good/lawful as well.
// ChazM 5/3/06 - complete rewrite - simplified to no longer be context sensitive to current alignment.
// ChazM 5/3/06 - changed adjustment for 1-point acts, added "incarnate" acts
// EPF 7/10/06 - added debug strings for balance testing
// EPF 7/20/06 - dampened adjustment values for 1-3.  Previous values made it too difficult to 
//				 remain neutral, which makes it just about impossible to play a druid.
// ChazM 8/31/06 - Changed debug display to values instead of alignment constants; removed old commented code


#include "ginc_alignment"

void main(int iActType, int bLawChaosAxis)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int nAdjustment;
		
    if (bLawChaosAxis == 0) 
	{
		nAdjustment = GoodEvilAxisAdjustment(oPC, iActType);
		PrettyMessage("Alignment shifted on Good-Evil Axis by " + IntToString(nAdjustment));
		PrettyMessage("Overall Alignment on this axis = " + IntToString(GetGoodEvilValue(oPC)));
	}
    else 
	{
		nAdjustment = LawChaosAxisAdjustment(oPC, iActType);
		PrettyMessage("Alignment shifted on Law-Chaos Axis by " + IntToString(nAdjustment));
		PrettyMessage("Overall Alignment on this axis = " + IntToString(GetLawChaosValue(oPC)));
	}
}



		