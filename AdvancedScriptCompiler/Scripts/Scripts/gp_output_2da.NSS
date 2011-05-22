// gp_output_2da
/*
    output 2da data for crafting to the log file
*/
// ChazM 2/2/06
// ChazM 3/1/06 - Restructured to call self multiple times so we don't run out of instructions.

	
#include "ginc_crafting"


const string VAR_REC_SET_2DA 	= "VAR_REC_SET_2DA";
const string SETUP_COUNT_2DA 	= "SETUP_COUNT_2DA";


const int MAX_RECIPE_PROCESSING_COUNT = 50;
// output all recipes of specific type, using the list of indexes to find them all
// returns remaining sIndexList if we run over MAX_RECIPE_PROCESSING_COUNT
string OutputRecipeTypePortion(string sRecipePrefix, string sIndexList)
{
	//output ("OutputRecipeType: sRecipePrefix: " + sRecipePrefix + " sIndexList:" + sIndexList);
	string sIndex;
    struct sStringTokenizer stTok = GetStringTokenizer(sIndexList, ",");
	int iRecipeCount = 0;
	
	// loop through recipe index list
    while (HasMoreTokens(stTok) && iRecipeCount<MAX_RECIPE_PROCESSING_COUNT) {
        stTok = AdvanceToNextToken(stTok);
        sIndex = GetNextToken(stTok);
		iRecipeCount += OutputRecipeSet(sRecipePrefix, sIndex);
    }
	if (iRecipeCount<MAX_RECIPE_PROCESSING_COUNT)	// force finish if we aren't over MAX
		return "";
	else
		return(stTok.sRemaining);
}

// need a version that doesn't print to log since that's where the 2da output is going.
// Post message with drop-shadow and print to log
void MyPrettyPostString(string sMessage, float fDuration=15.0f, int nColor=POST_COLOR_WHITE)
{
	object oTarget = OBJECT_SELF;
	int nX = PRETTY_X_OFFSET;
	int nLineOffset = GetGlobalInt(PRETTY_LINE_COUNT_VAR);
	int nY = PRETTY_Y_OFFSET + (nLineOffset * LINE_SIZE);

	Backdrop(oTarget, sMessage, nX, nY, fDuration, POST_COLOR_BLACK);
	DebugPostString(oTarget, sMessage, nX, nY, fDuration, nColor);
	//PrintString(sMessage);

	nLineOffset = (nLineOffset + 1) % PRETTY_LINE_WRAP;
	SetGlobalInt(PRETTY_LINE_COUNT_VAR, nLineOffset);
}


void main()
{
//    object oPC = GetLastUsedBy();
//	if (oPC == OBJECT_INVALID)
//		oPC = GetEnteringObject();

    // only set up recipies once
    if (GetGlobalInt(VAR_REC_SET_2DA) == TRUE)
    {
        output("Recipies already set!");
        return;
    }

// These functions set up all the recipes into global memory
	int iSetupCount = GetGlobalInt(SETUP_COUNT_2DA);
	int bDone = FALSE;
	string sRemaining = "";

    MyPrettyPostString("executing script portion " + IntToString(iSetupCount) + "...");
	switch (iSetupCount)
	{
		case 0:
			ModifyGlobalInt(SETUP_COUNT_2DA, 1);
				
		case 1: // prep
			output("Outputting recipes");
			PrintString("Save the following as 'crafting.2da'");
			PrintString("===================================================");
			FormatHeaderRow();
			ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;

		case 2: // 
			sRemaining = OutputRecipeTypePortion(MAGICAL_RECIPE_PREFIX, GetGlobalString(VAR_RECIPE_SPELLID_LIST));  	
			SetGlobalString(VAR_RECIPE_SPELLID_LIST, sRemaining);
			if (sRemaining == "")
				ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;

		case 3: // 
			sRemaining = OutputRecipeTypePortion(MUNDANE_RECIPE_PREFIX, GetGlobalString(VAR_RECIPE_RESREF_LIST));	
			SetGlobalString(VAR_RECIPE_RESREF_LIST, sRemaining);
			if (sRemaining == "")
				ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;

		case 4: // 
			OutputRecipeType(ALCHEMY_RECIPE_PREFIX, ALCHEMY_RECIPE_SUFFIX);
			ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;

		case 5:	// 
			OutputRecipeType(DISTILLATION_RECIPE_PREFIX, DISTILLATION_RECIPE_SUFFIX);
			ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;

		case 6:	// 
			PrintString("===================================================");
			output("Recipes completed.");
			ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;

		case 7:	//
			output("Outputting recipe index");
			OutputRecipeIndex();
			output("Recipe index completed.");
			ModifyGlobalInt(SETUP_COUNT_2DA, 1);
			break;


		default:
    		SetGlobalInt(VAR_REC_SET_2DA, TRUE);
			bDone = TRUE;
			output("2DA output complete.");
			break;
	}

	if (!bDone)
	{
		DelayCommand(0.2f, ExecuteScript("gp_output_2da", OBJECT_SELF));
	}
}