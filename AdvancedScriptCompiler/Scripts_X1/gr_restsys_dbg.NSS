// gr_restsys_dbg
/*
	Wandering Monster System Debugger
	
    Type runscript gr_restsys_dbg when in DebugMode
    to have this script dump the current Wandering
    Monster settings to the console.
	based on script By: Georg Zoeller

*/
// ChazM 5/31/07 
// ChazM 6/29/07 - Now with more data!

#include "ginc_restsys"
//#include "ginc_debug"

void MyDebug(object oPC, string sMessage)
{
	SendMessageToPC(oPC, sMessage);
	PrettyDebug(sMessage);
}

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oPC = OBJECT_SELF;
    struct wm_struct stInfo= WMGetAreaMonsterTable(oArea);
	int nCumIncL = GetLocalInt(oArea, VAR_WM_ENC_CUM_INCREASE_L);
	int nCumIncH = GetLocalInt(oArea, VAR_WM_ENC_CUM_INCREASE_H);
	int nCumTotal = GetLocalInt(oArea, VAR_WM_ENC_CUM_TOTAL);
	int nBaseProbDay = GetLocalInt(oArea, VAR_WM_ENC_PROB_DAY);
	int nBaseProbNight = GetLocalInt(oArea, VAR_WM_ENC_PROB_NIGHT);
	int nWMProb = WMGetWanderingMonsterProbability(oPC);

    MyDebug(oPC,"Wandering Monster System Debug");
    MyDebug(oPC,"REMINDER: You need to rest per area once to have correct values displayed here");
    MyDebug(oPC,"2DA: "+ WMGet2DAFileName());
    MyDebug(oPC,"Area: "+ GetName(GetArea(oPC)));
    MyDebug(oPC,"Cumulative Increase Range: " + IntToString(nCumIncL) 
										+ " - " + IntToString(nCumIncH));
    MyDebug(oPC,"Total accumulated Increase: " + IntToString(nCumTotal));
										
										
    MyDebug(oPC,"Base %Chance for WM Day: " + IntToString(nBaseProbDay) );
    MyDebug(oPC,"Base %Chance for WM Night: " + IntToString(nBaseProbNight) );
    MyDebug(oPC,"Current Total %Chance for WM: " + IntToString(nWMProb) );
	
    MyDebug(oPC,"Table:" + stInfo.sTable);
	//MyDebug(oPC,"(Row #: " + IntToString(WMGetAreaHasTable(oArea))+")" );
    //MyDebug(oPC,"ListenDC: " + IntToString (stInfo.nListenCheckDC));
    MyDebug(oPC,"Day1: " + stInfo.sEncounter1 + " (" +IntToString(stInfo.nEnc1Prob) + "%)");
    MyDebug(oPC,"Day2: " + stInfo.sEncounter2 +" (" +IntToString(stInfo.nEnc2Prob) + "%)");
    MyDebug(oPC,"Day3: " + stInfo.sEncounter3 + " (100%)");
    //MyDebug(oPC,"Night1: " + stInfo.sMonsterNight1 +" (" +IntToString(stInfo.nProbNight1) + "%)");
    //MyDebug(oPC,"Night2: " + stInfo.sMonsterNight2 +" (" +IntToString(stInfo.nProbNight2) + "%)");
    //MyDebug(oPC,"Night3: " + stInfo.sMonsterNight3 +  " (100%)");
    MyDebug(oPC,"Disabled:" + IntToString(WMGetWanderingMonstersDisabled(oArea)));
    MyDebug(oPC,"UseDoors: " + IntToString( GetLocalInt(GetArea(oPC),"WM_AREA_USEDOORS")) );
    MyDebug(oPC,"Flood Protection Active:" + IntToString(GetLocalInt(GetArea(oPC),"WM_AREA_FLOODPROTECTION")));
    MyDebug(oPC,"ListenFailureStrRef:" + IntToString(stInfo.nFeedBackStrRefFail));
    MyDebug(oPC,"ListenSuccessStrRef:" + IntToString(stInfo.nFeedBackStrRefSuccess));
  }