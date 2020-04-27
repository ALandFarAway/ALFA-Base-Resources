////////////////////////////////////////////////////////////////////////////////
// gui_shinn_sava_main
// Original Scripter:  Shinn      Design: Shinn
// Last modified : 20/06/2012 by Shinn
//------------------------------------------------------------------------------
// Main gui script for sava chess minigame, handling all gui interactions
////////////////////////////////////////////////////////////////////////////////


#include "shinn_sava_i"
#include "shinn_sava_config_i"


void main(string sPar1, string sPar2, string sPar3, string sPar4)
{

object oPC = OBJECT_SELF;
object oHub = GetLocalObject(oPC,"GAME_HUB");
int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");

int iOppSeat;
if(iPlayerSeat == 1) iOppSeat = 2; else iOppSeat = 1;

//------------------

if(sPar1 == "Heartbeat")
{

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

if(GetLocalInt(oHub,"GAME_IN_PROGERSS") == FALSE )return;

if(GetIsObjectValid(oPlayer1) != TRUE)
{
SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Disconnect",FALSE);
}

if(GetIsObjectValid(oPlayer2) != TRUE)
{
SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Disconnect",FALSE);
}

return;
}


//---------------------
if(sPar1 == "Startup")
{

//kamal: added this line to clean up any existing placeables in the area, setting things back to start positions
EndGameCleanUp(oHub);


SetLanguageVars(oPC);
// kamal commented out for chess CheckSpiderSettings(oHub);

string sName = GetName(oPC);
if(iPlayerSeat == 1) sName = "<c=lime>"+sName+"</c>";
else
sName = "<c=gold>"+sName+"</c>";

object oOpponent = GetLocalObject(oHub,"PLR_"+IntToString(iOppSeat));

// kamal comment out the below if for single player testing, leave the contents of the if itself
if(GetIsObjectValid(oOpponent)) 
{
SetGUIObjectDisabled(oOpponent,"SAVA_MAIN","Start_Game",FALSE);
SetGUIObjectDisabled(oPC,"SAVA_MAIN","Start_Game",FALSE);

CheckSaveSettings(oPC);
CheckSaveSettings(oOpponent);

string sOppName = GetName(oOpponent);
if(iPlayerSeat == 1) sOppName = "<c=gold>"+sOppName+"</c>";
else
sOppName = "<c=lime>"+sOppName+"</c>";


SetGUIObjectText(oOpponent,"SAVA_MAIN","Player_"+IntToString(iPlayerSeat)+"_BoxA",-1,sName);
SetGUIObjectText(oOpponent,"SAVA_MAIN","Player_"+IntToString(iPlayerSeat)+"_BoxB",-1,sName);

SetGUIObjectText(oPC,"SAVA_MAIN","Player_"+IntToString(iOppSeat)+"_BoxA",-1,sOppName);
SetGUIObjectText(oPC,"SAVA_MAIN","Player_"+IntToString(iOppSeat)+"_BoxB",-1,sOppName);
}

SetGUIObjectText(oPC,"SAVA_MAIN","Player_"+IntToString(iPlayerSeat)+"_BoxA",-1,sName);
SetGUIObjectText(oPC,"SAVA_MAIN","Player_"+IntToString(iPlayerSeat)+"_BoxB",-1,sName);

SetLocalInt(oHub,"Reseted", FALSE);

return;
}

//---------------------
if(sPar1 == "Exit")
{
//kamal: added this line to clean up pieces and reset them
EndGameCleanUp(oHub);

//original code

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

object oOpponent;
DeleteLocalObject(oHub,"PLR_"+IntToString(iPlayerSeat));

int i;

if(oPC == oPlayer1) oOpponent = oPlayer2; else oOpponent = oPlayer1;

	if(GetIsObjectValid(oOpponent) != TRUE)
	{
	
		for(i=11 ; i <= 88 ; i++)
		{
		DeleteLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT");
		DeleteLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece");
		DeleteLocalInt(oHub, "FIELD_"+IntToString(i)+"_Owner");
		}
		
	DeleteLocalObject(oHub,"PLR_1");
	DeleteLocalObject(oHub,"PLR_2");
	
	SetUseableFlag(GetNearestObjectByTag("sava_ctrl_1"),TRUE);
	SetUseableFlag(GetNearestObjectByTag("sava_ctrl_2"),TRUE);	
	SetLocalInt(oHub,"GAME_IN_PROGERSS", FALSE);
	
	SetLocalInt(oHub,"Kill_Count_1",0);
	SetLocalInt(oHub,"Kill_Count_2",0);
	
	
	}

	
		
return;
}

//---------------------

if(sPar1 == "Start")
{
object oOpponent = GetLocalObject(oHub,"PLR_"+IntToString(iOppSeat));

SetGUIObjectHidden(oPC,"SAVA_MAIN","BLOCK",TRUE);
SetGUIObjectHidden(oOpponent,"SAVA_MAIN","BLOCK",TRUE);

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

string sLog;

if(d100(1) > 50)
{
ChangeRound(oPlayer1,oHub);
sLog = GetFirstName(oPlayer2)+STARTS_GAME;
}
else
{
// kamal comment out changeround for single player testing
ChangeRound(oPlayer2,oHub);
sLog = GetFirstName(oPlayer1)+STARTS_GAME;
}

SetLocalString(oHub,"GAME_LOG",sLog);
SetGUIObjectText(oPlayer1, "SAVA_MAIN", "GameLog", -1, sLog);
SetGUIObjectText(oPlayer2, "SAVA_MAIN", "GameLog", -1, sLog);

SetLocalInt(oHub,"GAME_IN_PROGERSS",TRUE);

SetupGUIPieces(oPC, oOpponent, oHub);

SetGUIObjectText(oPlayer1,"SAVA_MAIN","Save_Name", -1, GetFirstName(oPlayer1)+" VS "+GetFirstName(oPlayer2) );
SetGUIObjectText(oPlayer2,"SAVA_MAIN","Save_Name", -1, GetFirstName(oPlayer1)+" VS "+GetFirstName(oPlayer2) );

return;
}

//----------------------

if(sPar1 == "FieldClick")
{


int iTargetPos = StringToInt(sPar2);
int iValid = GetLocalInt(oHub,"FIELD_"+sPar2+"_VT");
int iSelect = GetLocalInt(oHub,"SELECT_"+IntToString(iPlayerSeat));
int iPiece;
int iOwner = GetLocalInt(oHub, "FIELD_"+sPar2+"_Owner");
int iLider = GetLocalInt(oHub, "FIELD_"+IntToString(iTargetPos)+"_Lider");

if(iOwner == iPlayerSeat)
iPiece = GetLocalInt(oHub, "FIELD_"+sPar2+"_Piece");

if(iOwner >= 1 && iOwner != iPlayerSeat)
iPiece = GetLocalInt(oHub, "FIELD_"+IntToString(iSelect)+"_Piece");

if(iOwner <= 0 )
iPiece = GetLocalInt(oHub, "FIELD_"+IntToString(iSelect)+"_Piece");

/* // kamal commented out for chess, include for SAVA
	if(GetLocalInt(oHub,"KILLER_SWITCH_PLR_"+IntToString(iPlayerSeat))== TRUE && iOwner != 0 && iValid == TRUE)
	{

		int iRows = GetNum2DARows(sSpider2da);
		int index = 0; 
		int iDieces = GetLocalInt(oHub,"Throw_"+IntToString(iPlayerSeat));
		
		
		while(StringToInt(Get2DAString(sSpider2da, "Number", index)) != iDieces && index <= iRows-1 )
		{
		index++;
		}
		
	KillerSpiderActivation(oPC,index,oHub,iTargetPos);
	

	CleanSelection(oPC,oHub);
	ChangeRound(oPC,oHub);
	
	return;	
	}
*/

	
	if(iOwner == 0 && iValid == FALSE)
	{
	CleanSelection(oPC,oHub);
	return;
	}
	
	if(iValid != TRUE && iOwner > 0 && iOwner != iPlayerSeat )
	{	
	CleanSelection(oPC,oHub);
	return;	
	}	
	
	
	if(iOwner == iPlayerSeat)
	{
	CleanSelection(oPC,oHub);
//	if(iPiece == -1) iPiece = GetLocalInt(oHub, "FIELD_"+IntToString(iSelect)+"_Piece");
	SetLocalInt(oHub,"SELECT_"+IntToString(iPlayerSeat),iTargetPos);
	ShowMoveOptions(iPiece,iTargetPos,oPC,oHub);
	return;
	}
	

	if(iValid == TRUE && iOwner==0)
	{	
	MovePieceToField(iPiece,iSelect,iTargetPos,oPC,oHub);
	SendMessageToGameLog(oPC,iPiece,FALSE,-1,iSelect,iTargetPos,oHub);	
	CleanSelection(oPC,oHub);
	ChangeRound(oPC,oHub);	
	return;	
	}

	
	
	if(iValid == TRUE && iOwner!=0 && iOwner != iPlayerSeat)
	{
	TakePieceFromField(oPC,iPiece,iSelect,iTargetPos,oHub);	
	CleanSelection(oPC,oHub);
	ChangeRound(oPC,oHub);
	
		if(iLider == TRUE) DeclareWin(oPC,oHub);
		
	return;	
	}
	
	
	
return;
}

//kamal: this is not used for chess
if(sPar1 == "Dices")
{
/*
int D1 = Random(DICE_SIZE)+1;
int D2 = Random(DICE_SIZE)+1;


SetGUIObjectText(oPC,"SAVA_MAIN","D1",-1,"<c=red>"+IntToString(D1)+"</c>");
SetGUIObjectText(oPC,"SAVA_MAIN","D2",-1,"<c=red>"+IntToString(D2)+"</c>");

SetGUIObjectHidden(oPC,"SAVA_MAIN","Dices",TRUE);
SetGUIObjectHidden(oPC,"SAVA_MAIN","Killer_Spider",FALSE);

SetLocalInt(oHub,"Throw_"+IntToString(iPlayerSeat), D1+D2);
SetLocalInt(oHub,"D1_"+IntToString(iPlayerSeat), D1);
SetLocalInt(oHub,"D2_"+IntToString(iPlayerSeat), D2);

ShowKillerSpiderTooltip(oPC, D1+D2, oHub);

return;
*/
}

//---------------

//kamal: this is not used for chess
if(sPar1 == "Killer_Spider")
{
/*
SetLocalInt(oHub,"KILLER_SWITCH_PLR_"+IntToString(iPlayerSeat), TRUE);

int iDieces = GetLocalInt(oHub,"Throw_"+IntToString(iPlayerSeat));

KillerSpiderButton(oPC, iDieces, oHub);

return;
*/
}

//--------------

if(sPar1 == "SaveGame")
{
object oSave = CreateItemOnObject(SAVE_RESREF,oPC,1);
SaveGame(oSave, oHub);
SetFirstName(oSave, sPar2);

return;
}

//--------------

if(sPar1 == "LoadGame")
{

ClearListBox(oPC,"SAVA_MAIN","SAVES_LIST");

object oItem = GetFirstItemInInventory(oPC);
string sName;

while(GetIsObjectValid(oItem))
{

	if(GetResRef(oItem) == SAVE_RESREF)
	{
	sName = "SAVE_NAME="+GetName(oItem);
	AddListBoxRow(oPC,"SAVA_MAIN","SAVES_LIST","Row",sName,"","5="+IntToString(ObjectToInt(oItem)),"");
	}

oItem = GetNextItemInInventory(oPC);
}


return;
}

//----------------

if(sPar1 == "LoadThisGame")
{
object oSave = IntToObject(StringToInt(sPar2));
object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

string sTGA;

int i;
int iOwner, iPiece, iP1_D1, iP1_D2, iP2_D1, iP2_D2, iP1_Spider_Used, iP2_Spider_Used, iTaken;

	//Na początek figury
	for(i=11; i <= 88; i++)
	{
	iOwner = GetLocalInt(oSave,"OWNER_"+IntToString(i));
		if(iOwner != 0)	
		{
		iPiece = GetLocalInt(oSave,"PIECE_"+IntToString(i));
		SetGUIPiece(iPiece,i,iOwner,oHub);
		}
	
	}

iP1_D1 = 			GetLocalInt(oSave,"Player1_D1");
// testing commented out iP1_D2 = 			GetLocalInt(oSave,"Player1_D2");
iP1_Spider_Used =	GetLocalInt(oSave,"Player1_SP_USED");

iP2_D1 =			GetLocalInt(oSave,"Player2_D1");
// testing commented out iP2_D2 =			GetLocalInt(oSave,"Player2_D2");
// testing commented out iP2_Spider_Used =	GetLocalInt(oSave,"Player2_SP_USED");


//Pająk gracza 1
//kamal chess code doesn't need this
if(iP1_Spider_Used != TRUE)
{
//do nothing
}
else
{
//do nothing
}

/*  original sava code
if(iP1_Spider_Used != TRUE)
{
	if(iP1_D1 != 0)
	{
	SetGUIObjectText(oPlayer1,"SAVA_MAIN","D1",-1,"<c=red>"+IntToString(iP1_D1)+"</c>");
	SetGUIObjectText(oPlayer1,"SAVA_MAIN","D2",-1,"<c=red>"+IntToString(iP1_D2)+"</c>");
	
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Dices",TRUE);
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Killer_Spider",FALSE);
	
	SetLocalInt(oHub,"Throw_1", iP1_D1+iP1_D2);
	SetLocalInt(oHub,"D1_1", iP1_D1);
	SetLocalInt(oHub,"D2_1", iP1_D2);

	ShowKillerSpiderTooltip(oPlayer1, iP1_D1+iP1_D2, oHub);
	}

}
else
{
SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Dices",TRUE);
SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Killer_Spider",FALSE);
SetGUIObjectDisabled(oPlayer1,"SAVA_MAIN","Killer_Spider",TRUE);

SetGUIObjectText(oPlayer1,"SAVA_MAIN","D1",-1,"");
SetGUIObjectText(oPlayer1,"SAVA_MAIN","D2",-1,"");
ShowKillerSpiderTooltip(oPlayer1, iP1_D1+iP1_D2, oHub);

SetLocalGUIVariable(oPlayer1,"SAVA_MAIN",2,SPIDER_USED);
}
*/

//Pająk gracza 2
//kamal chess code doesn't need this
if(iP2_Spider_Used != TRUE)
{

}
else
{

}

/* original sava code
if(iP2_Spider_Used != TRUE)
{
	if(iP2_D1 != 0)
	{
	SetGUIObjectText(oPlayer2,"SAVA_MAIN","D1",-1,"<c=red>"+IntToString(iP2_D1)+"</c>");
	SetGUIObjectText(oPlayer2,"SAVA_MAIN","D2",-1,"<c=red>"+IntToString(iP2_D2)+"</c>");
	
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Dices",TRUE);
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Killer_Spider",FALSE);
	
	SetLocalInt(oHub,"Throw_2", iP2_D1+iP2_D2);
	SetLocalInt(oHub,"D1_2", iP2_D1);
	SetLocalInt(oHub,"D2_2", iP2_D2);

	ShowKillerSpiderTooltip(oPlayer2, iP2_D1+iP2_D2, oHub);
	}

}
else
{
SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Dices",TRUE);
SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Killer_Spider",FALSE);
SetGUIObjectDisabled(oPlayer2,"SAVA_MAIN","Killer_Spider",TRUE);

SetGUIObjectText(oPlayer2,"SAVA_MAIN","D1",-1,"");
SetGUIObjectText(oPlayer2,"SAVA_MAIN","D2",-1,"");
ShowKillerSpiderTooltip(oPlayer2, iP2_D1+iP2_D2, oHub);

SetLocalGUIVariable(oPlayer2,"SAVA_MAIN",2,SPIDER_USED);
}
*/

//And at the end of the clunky figures

	for(i=1; i <= 16; i++)
	{
	iTaken = GetLocalInt(oSave,"Player1_T_"+IntToString(i));
	
		if(iTaken > 0)
		{
			sTGA = Get2DAString(sPiece2da,"Image",iTaken);
			SetGUITexture(oPlayer1,"SAVA_MAIN","KILL_"+IntToString(i),sTGA);
// testing commented out			SetGUITexture(oPlayer2,"SAVA_MAIN","LOST_"+IntToString(i),sTGA);
		}
		
	}

	for(i=1; i <= 16; i++)
	{
	iTaken = GetLocalInt(oSave,"Player2_T_"+IntToString(i));
	
		if(iTaken > 0)
		{
			sTGA = Get2DAString(sPiece2da,"Image",iTaken);
// testing commented out			SetGUITexture(oPlayer2,"SAVA_MAIN","KILL_"+IntToString(i),sTGA);
			SetGUITexture(oPlayer1,"SAVA_MAIN","LOST_"+IntToString(i),sTGA);
		}
		
	}

	SetLocalInt(oHub,"Kill_Count_1",GetLocalInt(oSave,"Kill_Count_1"));
	SetLocalInt(oHub,"Kill_Count_2",GetLocalInt(oSave,"Kill_Count_2"));	
	
		
string sLog;

if(d100(1) > 50)
{
ChangeRound(oPlayer1,oHub);
// testing commented out  sLog = GetFirstName(oPlayer2)+CONT_GAME;
}
else
{
// testing commented out   ChangeRound(oPlayer2,oHub);
sLog = GetFirstName(oPlayer1)+CONT_GAME;
}	



SetLocalString(oHub,"GAME_LOG",sLog);

SetGUIObjectText(oPlayer1, "SAVA_MAIN", "GameLog", -1, sLog);
// testing commented out  SetGUIObjectText(oPlayer2, "SAVA_MAIN", "GameLog", -1, sLog);

SetLocalInt(oHub,"GAME_IN_PROGERSS",TRUE);

SetGUIObjectText(oPlayer1,"SAVA_MAIN","Save_Name", -1, GetFirstName(oPlayer1)+" VS "+GetFirstName(oPlayer2) );
// testing commented out  SetGUIObjectText(oPlayer2,"SAVA_MAIN","Save_Name", -1, GetFirstName(oPlayer1)+" VS "+GetFirstName(oPlayer2) );	

SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","BLOCK",TRUE);
// testing commented out SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","BLOCK",TRUE);

return;
}





}