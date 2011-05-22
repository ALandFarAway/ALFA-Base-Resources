// ginc_alignment
/*
    This include file has functions for adjusting alignment
*/
// FAB 2/8
// ChazM 3/8/05	- file name changed

/*
============================================================================================
Notes on Adjusting alignment (fron the NWLexicon)
Alignment is not treated as a continuous scale running from 0 to 100, but in three bands
running from 0 to 30, 31 to 69 and 70 to 100. 

Whenever a call to AdjustAlignment takes you over one of these boundaries, your characters
alignment is automatically placed at the middle of the new band, ie 15, 50 or 85. 

If we look at a character (oSubject) with a good/evil alignment value of 71 who performs
an act that moves their alignment towards evil we get the following behaviour... If the
adjustment was a single point, their new alignment value would be 70, if the adjustment
is more, two or even ten points, the new alignment would be 50. 

However, if the alignment shift is sufficiently large, then the characters alignment will
'skip' a band. In the case given here, an alignment shift of 41 points or more would be
sufficient to give the character an evil alignment, with a good/evil value of 15. 

Example for ALIGNMENT_NEUTRAL: if oSubject has a law/chaos value of 10 (i.e. chaotic)
and a good/evil value of 85 (i.e. good) then if nShift is 15, the law/chaos value will
become (10+15)=25 and the good/evil value will become (85-15)=70. 

Note, the ALIGNMENT_NEUTRAL shift will at most take the alignment value to 50 and not
beyond (above or below). 

Characters in a party with a PC who is the target of an AdjustAlignment will also have
their alignments affected as well. The perpetrator of the act (oSubject) receives the
full adjustment to their alignment. Party members of the target receive a 20% adjustment
to their alignment rounded up, ie a minimum of 1 point. 

Also note that current alignment of the party members has no effect on the 'knock on'
adjustment. That is, if a Lawful Neutral party member performs a chaotic act, the
alignment of Chaotic party members will be shifted towards chaotic as well. 

Adjust alignment does not affect DMs.
============================================================================================
*/

/*
// alignment consntants (NWSCRIPT) 
int    ALIGNMENT_ALL                    = 0;
int    ALIGNMENT_NEUTRAL                = 1;
int    ALIGNMENT_LAWFUL                 = 2;
int    ALIGNMENT_CHAOTIC                = 3;
int    ALIGNMENT_GOOD                   = 4;
int    ALIGNMENT_EVIL                   = 5;

*/

#include "ginc_debug"

// Act constants.
// these define the kinds of acts that can be performed.
// *** Good & Evil
const int ACT_EVIL_INCARNATE	= -4;
const int ACT_EVIL_FIENDISH		= -3;
const int ACT_EVIL_MALEVOLENT	= -2;
const int ACT_EVIL_IMPISH		= -1;

const int ACT_GOOD_KINDLY		= 1;
const int ACT_GOOD_BENEVOLENT	= 2;
const int ACT_GOOD_SAINTLY		= 3;
const int ACT_GOOD_INCARNATE	= 4;

// *** Law & Chaos
const int ACT_CHAOTIC_INCARNATE	= -4;
const int ACT_CHAOTIC_ANARCHIC	= -3;
const int ACT_CHAOTIC_FEY		= -2;
const int ACT_CHAOTIC_WILD		= -1;

const int ACT_LAWFUL_HONEST		= 1;
const int ACT_LAWFUL_ORDERLY	= 2;
const int ACT_LAWFUL_PARAGON	= 3;
const int ACT_LAWFUL_INCARNATE	= 4;



// Alignment scale values. 
const int ALIGN_SCALE_MIN 							= 0;
const int ALIGN_SCALE_MAX 							= 100;
// evil/chaotic
const int ALIGN_SCALE_LOW_BAND_LOWER_BOUNDARY 		= 0;
const int ALIGN_SCALE_LOW_BAND_MIDDLE 				= 15;
const int ALIGN_SCALE_LOW_BAND_UPPER_BOUNDARY 		= 30;
// neutral
const int ALIGN_SCALE_NEUTRAL_BAND_LOWER_BOUNDARY 	= 31;
const int ALIGN_SCALE_NEUTRAL_BAND_MIDDLE 			= 50;
const int ALIGN_SCALE_NEUTRAL_BAND_UPPER_BOUNDARY 	= 69;
// goood/lawful
const int ALIGN_SCALE_HIGH_BAND_LOWER_BOUNDARY 		= 70;
const int ALIGN_SCALE_HIGH_BAND_MIDDLE 				= 85;
const int ALIGN_SCALE_HIGH_BAND_UPPER_BOUNDARY 		= 100;

// 
/*
const int ALIGN_VALUE_CHAOTIC = 33;
const int ALIGN_VALUE_LAWFUL = 67;
const int ALIGN_VALUE_GOOD = 67;
const int ALIGN_VALUE_EVIL = 33;
*/

// functions to check if creature is lawful, evil, etc...

int GetIsLawful(object oCreature)
{
	return(GetAlignmentLawChaos(oCreature) == ALIGNMENT_LAWFUL);
}

int GetIsChaotic(object oCreature)
{
	return(GetAlignmentLawChaos(oCreature) == ALIGNMENT_CHAOTIC);
}

int GetIsGood(object oCreature)
{
	return(GetAlignmentGoodEvil(oCreature) == ALIGNMENT_GOOD);
}

int GetIsEvil(object oCreature)
{
	return(GetAlignmentGoodEvil(oCreature) == ALIGNMENT_EVIL);
}


// Adjust Alignment notes: 
// Alignment is not treated as a continuous scale running from 0 to 100, but in three bands running from 0 to 30, 31 to 69 and 70 to 100. 
// Whenever a call to AdjustAlignment takes you over one of these boundaries, 
// your characters alignment is automatically placed at the middle of the new band, ie 15, 50 or 85. 

int GetLawChaosActAdjustment(int iLawChaosActType)
{	
	int iAdjustment = 0;
	switch ( iLawChaosActType )
	{
	    case ACT_CHAOTIC_INCARNATE:
	        iAdjustment = -70;
	        break;
	    case ACT_CHAOTIC_ANARCHIC:
	        iAdjustment = -10;
	        break;
	    case ACT_CHAOTIC_FEY:
	        iAdjustment = -3;
	        break;
	    case ACT_CHAOTIC_WILD:
	        iAdjustment = -1;
	        break;
	    case 0:	// Neutral acts not currently tracked
	        iAdjustment = 0;
	        break;
	    case ACT_LAWFUL_HONEST:
	        iAdjustment = 1;
	        break;
	    case ACT_LAWFUL_ORDERLY:
	        iAdjustment = 3;
	        break;
	    case ACT_LAWFUL_PARAGON:
	        iAdjustment = 10;
	        break;
	    case ACT_LAWFUL_INCARNATE:
	        iAdjustment = 70;
	        break;
	}
	return (iAdjustment);
}	



int GetGoodEvilActAdjustment(int iGoodEvilActType)
{	
	int iAdjustment = 0;
	switch ( iGoodEvilActType )
	{
	    case ACT_EVIL_INCARNATE:
	        iAdjustment = -70;
	        break;
	    case ACT_EVIL_FIENDISH:
	        iAdjustment = -10;
	        break;
	    case ACT_EVIL_MALEVOLENT:
	        iAdjustment = -3;
	        break;
	    case ACT_EVIL_IMPISH:
	        iAdjustment = -1;
	        break;
	    case 0:	// Neutral acts not currently tracked
	        iAdjustment = 0;
	        break;
	    case ACT_GOOD_KINDLY:
	        iAdjustment = 1;
	        break;
	    case ACT_GOOD_BENEVOLENT:
	        iAdjustment = 3;
	        break;
	    case ACT_GOOD_SAINTLY:
	        iAdjustment = 10;
	        break;
	    case ACT_GOOD_INCARNATE:
	        iAdjustment = 70;
	        break;
	}
	return (iAdjustment);
}

// Adjust toward law or chaos by iAdjustment
void AdjustAlignmentLawChaos(object oPC, int iAdjustment)
{
    if (iAdjustment > 0) 
		AdjustAlignment(oPC, ALIGNMENT_LAWFUL, iAdjustment);
    else 
		AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, -iAdjustment);
}

// Adjust toward good or evil by iAdjustment
void AdjustAlignmentGoodEvil(object oPC, int iAdjustment)
{
    if (iAdjustment > 0) 
		AdjustAlignment(oPC, ALIGNMENT_GOOD, iAdjustment);
    else 
		AdjustAlignment(oPC, ALIGNMENT_EVIL, -iAdjustment);
}


int LawChaosAxisAdjustment(object oPC, int iLawChaosActType)
{	
	int iAdjustment = GetLawChaosActAdjustment(iLawChaosActType);
	AdjustAlignmentLawChaos(oPC, iAdjustment);
	return (iAdjustment);
}

int GoodEvilAxisAdjustment(object oPC, int iGoodEvilActType)
{	
	int iAdjustment = GetGoodEvilActAdjustment(iGoodEvilActType);
	AdjustAlignmentGoodEvil(oPC, iAdjustment);
	return (iAdjustment);
}



// get adjustment that is always in the direction of neutral (50)
int GetNeutralAdjustment(int nAlignmentValue, int nAdjustment)
{
	int nNewAdjustment = 0;
	int nMaxAdjustment = ALIGN_SCALE_NEUTRAL_BAND_MIDDLE - nAlignmentValue;
	int nSign = nMaxAdjustment/abs(nMaxAdjustment);
	int nMaxAdjustmentMag = abs(nMaxAdjustment);
	int nAdjustmentMag = abs(nAdjustment);
	
	if (nMaxAdjustmentMag < nAdjustmentMag)
		nNewAdjustment = nMaxAdjustmentMag * nSign;
	else
		nNewAdjustment = nAdjustmentMag * nSign;
		
	return (nNewAdjustment);
}


// *** OLD ***

/*
// This function adjusts oPC's Good/Evil alignment. nChange is from
// -3 (truly evil acts) to +3 (truly saintly acts).
int AdjustGood(object oPC, int nChange);

// This function adjusts oPC's Law/Chaos alignment. nChange is from
// -3 (truly chaotic acts) to +3 (truly lawful acts).
int AdjustLaw(object oPC, int nChange);

int AdjustGood(object oPC, int nChange)
{

    int nAlignCurrent = GetAlignmentGoodEvil( oPC );    // Current alignment
    int nAdjustment;        // How much alignment moves
    int nAlignScale;        // Scale of the alignment (from +3 to -3)

    // Set their current scale
    if ( nAlignCurrent >= 85 ) nAlignScale = 3;
    else if ( nAlignCurrent >= 60 ) nAlignScale = 2;
    else if ( nAlignCurrent >= 25 ) nAlignScale = 1;
    else if ( nAlignCurrent >= -24 ) nAlignScale = 0;
    else if ( nAlignCurrent >= -59 ) nAlignScale = -1;
    else if ( nAlignCurrent >= -84 ) nAlignScale = -2;
    else nAlignScale = -3;

    switch ( nChange )
    {
        case -3:        // FIENDISH ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = -2;
                    break;
                case -2:
                    nAdjustment = -4;
                    break;
                case -1:
                    nAdjustment = -71 - nAlignCurrent;
                    break;
                case 0:
                    nAdjustment = -42 - nAlignCurrent;
                    break;
                case 1:
                    nAdjustment = -nAlignCurrent;
                    break;
                case 2:
                    nAdjustment = 42 - nAlignCurrent;
                    break;
                case 3:
                    nAdjustment = 42 - nAlignCurrent;
                    break;
            }
            break;

        case -2:        // MALEVOLENT ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = -2;
                    break;
                case -1:
                    nAdjustment = -4;
                    break;
                case 0:
                    nAdjustment = -6;
                    break;
                case 1:
                    nAdjustment = -8;
                    break;
                case 2:
                    nAdjustment = 42 - nAlignCurrent;
                    break;
                case 3:
                    nAdjustment = 72 - nAlignCurrent;
                    break;
            }
            break;

        case -1:        // IMPISH ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = 0;
                    break;
                case -1:
                    nAdjustment = -1;
                    break;
                case 0:
                    nAdjustment = -1;
                    break;
                case 1:
                    nAdjustment = -2;
                    break;
                case 2:
                    nAdjustment = -3;
                    break;
                case 3:
                    nAdjustment = 72 - nAlignCurrent;
                    break;
            }
            break;

        case 1:         // KIND ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 3;
                    break;
                case -2:
                    nAdjustment = 3;
                    break;
                case -1:
                    nAdjustment = 2;
                    break;
                case 0:
                    nAdjustment = 1;
                    break;
                case 1:
                    nAdjustment = 1;
                    break;
                case 2:
                    nAdjustment = 0;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 2:         // BENEVOLENT ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 4;
                    break;
                case -2:
                    nAdjustment = 4;
                    break;
                case -1:
                    nAdjustment = 4;
                    break;
                case 0:
                    nAdjustment = 3;
                    break;
                case 1:
                    nAdjustment = 2;
                    break;
                case 2:
                    nAdjustment = 1;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 3:         // SAINTLY ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 5;
                    break;
                case -2:
                    nAdjustment = 5;
                    break;
                case -1:
                    nAdjustment = 5;
                    break;
                case 0:
                    nAdjustment = 4;
                    break;
                case 1:
                    nAdjustment = 3;
                    break;
                case 2:
                    nAdjustment = 2;
                    break;
                case 3:
                    nAdjustment = 1;
                    break;
            }
            break;
    }

    if ( nAdjustment > 0 ) AdjustAlignment( oPC,ALIGNMENT_GOOD,nAdjustment );
    else AdjustAlignment( oPC,ALIGNMENT_EVIL,-nAdjustment );

    return nAdjustment;
}

int AdjustLaw(object oPC, int nChange)
{

    int nAlignCurrent = GetAlignmentLawChaos( oPC );    // Current alignment
    int nAdjustment;        // How much alignment moves
    int nAlignScale;        // Scale of the alignment (from +3 to -3)

    // Set their current scale
    if ( nAlignCurrent >= 85 ) nAlignScale = 3;
    else if ( nAlignCurrent >= 60 ) nAlignScale = 2;
    else if ( nAlignCurrent >= 25 ) nAlignScale = 1;
    else if ( nAlignCurrent >= -24 ) nAlignScale = 0;
    else if ( nAlignCurrent >= -59 ) nAlignScale = -1;
    else if ( nAlignCurrent >= -84 ) nAlignScale = -2;
    else nAlignScale = -3;

    switch ( nChange )
    {
        case -3:        // ANARCHIC ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = -1;
                    break;
                case -2:
                    nAdjustment = -2;
                    break;
                case -1:
                    nAdjustment = -3;
                    break;
                case 0:
                    nAdjustment = -4;
                    break;
                case 1:
                    nAdjustment = -5;
                    break;
                case 2:
                    nAdjustment = -5;
                    break;
                case 3:
                    nAdjustment = -5;
                    break;
            }
            break;

        case -2:        // FEY ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = -1;
                    break;
                case -1:
                    nAdjustment = -2;
                    break;
                case 0:
                    nAdjustment = -3;
                    break;
                case 1:
                    nAdjustment = -4;
                    break;
                case 2:
                    nAdjustment = -4;
                    break;
                case 3:
                    nAdjustment = -4;
                    break;
            }
            break;

        case -1:        // WILD ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 0;
                    break;
                case -2:
                    nAdjustment = 0;
                    break;
                case -1:
                    nAdjustment = -1;
                    break;
                case 0:
                    nAdjustment = -1;
                    break;
                case 1:
                    nAdjustment = -2;
                    break;
                case 2:
                    nAdjustment = -2;
                    break;
                case 3:
                    nAdjustment = -3;
                    break;
            }
            break;

        case 1:         // HONEST ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 3;
                    break;
                case -2:
                    nAdjustment = 3;
                    break;
                case -1:
                    nAdjustment = 2;
                    break;
                case 0:
                    nAdjustment = 1;
                    break;
                case 1:
                    nAdjustment = 1;
                    break;
                case 2:
                    nAdjustment = 0;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 2:         // ORDERLY ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 4;
                    break;
                case -2:
                    nAdjustment = 4;
                    break;
                case -1:
                    nAdjustment = 4;
                    break;
                case 0:
                    nAdjustment = 3;
                    break;
                case 1:
                    nAdjustment = 2;
                    break;
                case 2:
                    nAdjustment = 1;
                    break;
                case 3:
                    nAdjustment = 0;
                    break;
            }
            break;

        case 3:         // PARAGON ACTS
            switch ( nAlignScale )
            {
                case -3:
                    nAdjustment = 5;
                    break;
                case -2:
                    nAdjustment = 5;
                    break;
                case -1:
                    nAdjustment = 5;
                    break;
                case 0:
                    nAdjustment = 4;
                    break;
                case 1:
                    nAdjustment = 3;
                    break;
                case 2:
                    nAdjustment = 2;
                    break;
                case 3:
                    nAdjustment = 1;
                    break;
            }
            break;
    }

    if ( nAdjustment > 0 ) AdjustAlignment( oPC,ALIGNMENT_LAWFUL,nAdjustment );
    else AdjustAlignment( oPC,ALIGNMENT_CHAOTIC,-nAdjustment );

    return nAdjustment;
}
*/