// ga_align_law-chaos(int nActType, int nAlignmentShiftRule)
/*
    This changes the creature's alignment on the law & chaos axis
        nActType     - On a scale from +3 (Paragon) to -3 (Anarchic), 
				      how much the act affects alignment
					  
		nAlignmentShiftRule -
				0 = no special rules - shift normally
				1 = act shifts align toward limit of 50 (neutral).
				2 = shift toward neutral in whatever direction necessary (law or chaos).				
		
*/
// ChazM 4/9/07

#include "ginc_alignment"

void main(int nActType, int nAlignmentShiftRule)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int nAlignmentValue = GetLawChaosValue(oPC);
	int nAdjustment	= GetLawChaosActAdjustment(nActType);
	int nNewAdjustment = 0;
	
	switch (nAlignmentShiftRule)
	{
		case 0:
			// use nAdjustment as is
			nNewAdjustment = nAdjustment;
			break;
		
		case 1:
		{
			if (  (nAdjustment > 0) && (nAlignmentValue < ALIGN_SCALE_NEUTRAL_BAND_MIDDLE)  // lawful act and we tend toward chaos
				||(nAdjustment < 0) && (nAlignmentValue > ALIGN_SCALE_NEUTRAL_BAND_MIDDLE)) // chaotic act and we tend toward law
			{
				nNewAdjustment = GetNeutralAdjustment(nAlignmentValue, nAdjustment);
			}
			break;
		}
		case 2:
			nNewAdjustment = GetNeutralAdjustment(nAlignmentValue, nAdjustment);
			break;
			
	}
	
	AdjustAlignmentLawChaos(oPC, nNewAdjustment);
	
	PrettyMessage("Alignment shifted on Good-Evil Axis by " + IntToString(nNewAdjustment));
	PrettyMessage("Overall Alignment on this axis = " + IntToString(GetLawChaosValue(oPC)));
}

