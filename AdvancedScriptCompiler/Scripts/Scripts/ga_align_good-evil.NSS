// ga_align_good-evil(int nActType, int nAlignmentShiftRule)
/*
    This changes the creature's alignment on the good & evil axis
        nActType     - On a scale from +3 (Saintly) to -3 (Fiendish), 
				      how much the act affects alignment
					  
		nAlignmentShiftRule -
				0 = no special rules - shift normally
				1 = good act shifts align toward good up to limit of 50 (neutral).
					evil act shifts align toward evil down to limit of 50 (neutral).
				2 = shift toward neutral in whatever direction necessary (good or evil).				

	============				
	Examples:
		ga_alignment_good-evil(2,2)  [or ga_alignment_good-evil(-2,2)]
			shift alignment by +3 for those with alignment less than 50 (to a max of 50); 
			shift alignment by -3 for those with alignment greater than 50 (to a min of 50)
		
		ga_alignment_good-evil(-2,1)
			shift alignment by 0 for those with alignment <= than 50;
			shift alignment by -3 for those with alignment greater that 50 (to a min of 50)
								
*/

#include "ginc_alignment"


void main(int nActType, int nAlignmentShiftRule)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int nAlignmentValue = GetGoodEvilValue(oPC);
	int nAdjustment	= GetGoodEvilActAdjustment(nActType);
	int nNewAdjustment = 0;
	
	switch (nAlignmentShiftRule)
	{
		case 0:
			// use nAdjustment as is
			nNewAdjustment = nAdjustment;
			break;
		
		case 1:
		{
			if (  (nAdjustment > 0) && (nAlignmentValue < ALIGN_SCALE_NEUTRAL_BAND_MIDDLE)  // good act and we tend toward evil
				||(nAdjustment < 0) && (nAlignmentValue > ALIGN_SCALE_NEUTRAL_BAND_MIDDLE)) // evil act and we tend toward good
			{
				nNewAdjustment = GetNeutralAdjustment(nAlignmentValue, nAdjustment);
			}
			break;
		}
		case 2:
			nNewAdjustment = GetNeutralAdjustment(nAlignmentValue, nAdjustment);
			break;
			
	}
	
	AdjustAlignmentGoodEvil(oPC, nNewAdjustment);
	
	PrettyMessage("Alignment shifted on Good-Evil Axis by " + IntToString(nNewAdjustment));
	PrettyMessage("Overall Alignment on this axis = " + IntToString(GetGoodEvilValue(oPC)));
}

