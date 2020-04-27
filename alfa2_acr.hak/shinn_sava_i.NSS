////////////////////////////////////////////////////////////////////////////////
// shinn_sava_inc
// Original Scripter:  Shinn      Design: Shinn
// Last modified : 20/06/2012 by Shinn
//------------------------------------------------------------------------------
// Function library for sava chess minigame
////////////////////////////////////////////////////////////////////////////////

#include "X0_I0_STRINGLIB"
#include "shinn_sava_config_i"

const string sStart2da = "chess_starting_settings";
const string sPiece2da = "chess_pieces";
const string sSpider2da = "chess_spider";

//DEFINICJE

//kamal:  ran the comments through google translate

//Sets a figure on a chessboard on a specific field
void SetGUIPiece(int iType, int iPosition, int iPlayer, object oHub);

//Sets the figures at the beginning of the game
void SetupGUIPieces(object oPC, object oOpponent, object oHub);

// kamal: added code for placeable pieces
void SetPlaceablePiece(int iType, int iPosition, int iPlayer, object oHub);

//Draws the movement paths of a linear figure
void PrintMoveLine(string sMove, int iPosition, int HAMO, object oPC , object oHub);

//Draws the movements of the figure's jumping movements
void PrintMoveJumper(string sMove, int iPosition, int HAMO, object oPC , object oHub);

//draws the paths of the linear-jumping motion of the figure
void PrintMoveLineJumper(string sMove, int iPosition, int HAMO, object oPC , object oHub);

//Draws the path of offensive movement
void PrintMoveAttack(string sMove, int iPosition, object oPC , object oHub);

//Draws a motion path of a specific length
void PrintMoveRange(string sMove, int iPosition, int HAMO, int iRange, object oPC , object oHub);

//Generates all moves for a given figure
void ShowMoveOptions(int iType, int iPosition, object oPlayer, object oHub);

//Clears the selection and activations on the board
void CleanSelection(object oPC , object oHub);

//Generates a new position for displaying movements
int GenerateNewPosition(int iPos, int X, int Y);

//Moves the piece to a free active field
void MovePieceToField(int iType, int iSelect, int iDestination, object oPC, object oHub);

//Sends information to the game log about the figure's movement
void SendMessageToGameLog(object oPC, int iType, int iHostile, int iTarget, int Start, int End, object oHub);

//Collects the opponent's figure and displays the message in the log
void TakePieceFromField(object oPC, int iType, int iSelect, int iDestination, object oHub);

//Pass the round to the other player
void ChangeRound(object oPC, object oHub);

//Declares the player's victory
void DeclareWin(object oPC, object oHub);

//highlights his own figures of a specific type, -1 = all except the leader, a specific number - figure number
void ShowOwnPieces(int iSeat, object oPC, object oHub, int iPieceType = -1);

//Illuminates the figures of the opponent of a specific type, -1 = all except the leader, a specific number - figure number
void ShowEnemyPieces(int iSeat, object oPC, object oHub, int iPieceType = -1);

//Designates a random figure of a specific player with a certain type (see ShowOwnPieces)
int GetRandomPiece(int iSeat, object oHub, string sPieceType);

//Activates the active and passive spider button
void KillerSpiderActivation(object oPC, int iDef, object oHub, int iDestination = -1);

//Checks whether the player has saved game states and whether the game registration is allowed
void CheckSaveSettings(object oPC);

//Dumps the game variables to the indicated object by saving the game
int SaveGame(object oItem, object oHub);

//Checks if dice casts are on, if not - hides the button
void CheckSpiderSettings(object oHub);

//Checks whether the figure is subject to promotion and whether it is on the promotional field
int Promotion(int iPlayer, int iPiece, int iTarget, object oHub);

//Displays the message to selected players
void SendMessageToPlayers(string sText, int iPlayer, object oHub);

//Removes the piece from the chessboard
int DeletePiece(int iTarget, object oHub, int iDoFieldCheck = FALSE);

// kamal : extra functionality for the placeables
//place all the pieces from the board to begin the game
void StartGamePlaceableSetup(object oHub);
//remove all the pieces from the board at end of the game
void EndGameCleanUp(object oHub);

//IMPLEMETACJE

void SetupGUIPieces(object oPC, object oOpponent, object oHub)
{


int iRows = GetNum2DARows(sStart2da);
int i;

int iPosition;
int iType;
int iPlayer;

for(i=0 ; i <= iRows-1 ; i++)
{
iType = StringToInt(Get2DAString(sStart2da,"Type",i));
iPlayer = StringToInt(Get2DAString(sStart2da,"Player",i));
iPosition = StringToInt(Get2DAString(sStart2da,"Position",i));

SetGUIPiece(iType,iPosition,iPlayer,oHub);

//if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE) ExecuteScriptNx("shinn_sava_obs_exe", oHub, TRUE, 11, 88);

}

}

//---------------

void SetGUIPiece(int iType, int iPosition, int iPlayer, object oHub)
{


//gui code
string sTGA = Get2DAString(sPiece2da,"Image",iType);
string sName = Get2DAString(sPiece2da,"Name",iType);
int iLider = StringToInt(Get2DAString(sPiece2da,"Lider",iType));

SetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Piece",iType);
SetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Owner",iPlayer);
SetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Lider",iLider);

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

SetGUITexture(oPlayer1,"SAVA_MAIN",IntToString(iPosition)+"_Piece",sTGA);
SetGUITexture(oPlayer2,"SAVA_MAIN",IntToString(iPosition)+"_Piece",sTGA);

SetLocalGUIVariable(oPlayer1,"SAVA_MAIN",iPosition,sName);
SetLocalGUIVariable(oPlayer2,"SAVA_MAIN",iPosition,sName);

//if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE) CheckSpectatorField(iPosition, oHub);

}

void SetPlaceablePiece(int iType, int iPosition, int iPlayer, object oHub)
{

string sTGA = Get2DAString(sPiece2da,"Image",iType);
string sName = Get2DAString(sPiece2da,"Lable",iType);
int iLider = StringToInt(Get2DAString(sPiece2da,"Lider",iType));


//if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE) CheckSpectatorField(iPosition, oHub);

//create placeable in the square
if (sName == "Pawn_White")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1); //get wp in the given square of the board\
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_pawn_white"; //template of what we will create
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Pawn_Black")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1);
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_pawn_black";
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Knight_White")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1);
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_knight_white"; 
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Knight_Black")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1);
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_knight_black";
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Rook_White")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1); 
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_rook_white";
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Rook_Black")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1); 
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_rook_black"; 
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Bishop_White")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1); 
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_bishop_white"; 
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Bishop_Black")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1);
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_bishop_black";
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Queen_White")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1); 
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_queen_white"; 
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "Queen_Black")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1); 
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_queen_black"; 
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "King_White")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1);
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_king_white";
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else if (sName == "King_Black")
{
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iPosition), oHub, 1);
location lWP = GetLocation(oWP);
string sCreate = "rk_chess_king_black"; 
CreateObject(OBJECT_TYPE_PLACEABLE, sCreate, lWP, FALSE, sCreate);
}

else //do nothing, not a valid piece name
{

}

}





//--------------

void ShowMoveOptions(int iType, int iPosition, object oPlayer, object oHub)
{

string sMove;

int Jumper = StringToInt(Get2DAString(sPiece2da,"Jumper",iType));
int Line = StringToInt(Get2DAString(sPiece2da,"Line",iType));
int iRange = StringToInt(Get2DAString(sPiece2da,"Range",iType));

int iHAMO = StringToInt(Get2DAString(sPiece2da,"HAMO",iType));

//Kamal : note that iHAMO is only =1 for pawns, so we can identify a pawn
if (iHAMO==1)
	{
	string sPawnLable = Get2DAString(sPiece2da,"Lable",iType);
	//SendMessageToPC(GetFirstPC(), "pawn label is "); //debug testing
	//SendMessageToPC(GetFirstPC(), "position is " +IntToString(iPosition));
	if (((iPosition == 17) || (iPosition == 27) || (iPosition == 37) || (iPosition == 47) || (iPosition == 57) || (iPosition == 67)
	|| (iPosition == 77) || (iPosition == 87)) && sPawnLable == "Pawn_White")
		{//in first position for white pawn, so we can move two spaces
		iRange = iRange+1; //adjust
		}
	else if (((iPosition == 12) || (iPosition == 22) || (iPosition == 32) || (iPosition == 42) || (iPosition == 52) || (iPosition == 62)
	|| (iPosition == 72) || (iPosition == 82)) && sPawnLable == "Pawn_Black")
		{//in first position for black pawn, so we can move two spaces
		iRange = iRange+1; //adjust
		}
	}

//back to original code

int i;

{
	for(i = 1 ; i <= 2 ; i++)
	{
	sMove = Get2DAString(sPiece2da,"AttackMove"+IntToString(i),iType);	
	PrintMoveAttack(sMove, iPosition, oPlayer, oHub);
	}

}

if(Jumper == TRUE && Line == TRUE)
{
	for(i = 1 ; i <= 8 ; i++)
	{
	sMove = Get2DAString(sPiece2da,"Move"+IntToString(i),iType);	
	PrintMoveLineJumper(sMove, iPosition, iHAMO, oPlayer, oHub);
	}
return;
}

if(Line == TRUE)
{
	for(i = 1 ; i <= 8 ; i++)
	{
	sMove = Get2DAString(sPiece2da,"Move"+IntToString(i),iType);	
	PrintMoveLine(sMove, iPosition, iHAMO, oPlayer, oHub);
	}

return;
}

if(Jumper == TRUE)
{
	for(i = 1 ; i <= 8 ; i++)
	{
	sMove = Get2DAString(sPiece2da,"Move"+IntToString(i),iType);	
	PrintMoveJumper(sMove, iPosition, iHAMO, oPlayer, oHub);
	}
return;
}


	for(i = 1 ; i <= 8 ; i++)
	{
	sMove = Get2DAString(sPiece2da,"Move"+IntToString(i),iType);	
	PrintMoveRange(sMove, iPosition, iHAMO, iRange, oPlayer, oHub);
	}



}

//----------

void PrintMoveLine(string sMove, int iPosition, int HAMO, object oPC , object oHub)
{
int X = StringToInt(GetTokenByPosition(sMove,";",0));
int Y = StringToInt(GetTokenByPosition(sMove,";",1));

if(X == 0 && Y == 0) return;

int iSeat = GetLocalInt(oPC,"GAME_SEAT");
int iOwner;


while(iPosition <= 88 && iPosition >= 11 )
{
 
iPosition = GenerateNewPosition(iPosition, X, Y);
iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Owner");

    if(iPosition == -1) return;

	if(iOwner == iSeat) return;
	
	if(iOwner != 0 && iOwner != iSeat && HAMO == TRUE)
	return;


	if(iOwner != 0 && iOwner != iSeat)
	{
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_select_red.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);
	return;
	}
	
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_move_marker.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);

}

}

//--------------


void PrintMoveLineJumper(string sMove, int iPosition, int HAMO, object oPC , object oHub)
{
int X = StringToInt(GetTokenByPosition(sMove,";",0));
int Y = StringToInt(GetTokenByPosition(sMove,";",1));

if(X == 0 && Y == 0) return;

int iSeat = GetLocalInt(oPC,"GAME_SEAT");
int iOwner;


while(iPosition <= 88 && iPosition >= 11 )
{
 
iPosition = GenerateNewPosition(iPosition, X, Y);
iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Owner");

    if(iPosition == -1) return;

	if(iOwner == iSeat)
	{
	//Nie rób nic
	}
	
	if(iOwner != 0 && iOwner != iSeat && HAMO == TRUE)
	{
	//Nie rób nic
	}
	
	if(iOwner != 0 && iOwner != iSeat)
	{
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_select_red.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);
	}
	
	if(iOwner <= 0)
	{
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_move_marker.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);
	}
}

}


//-----------------


void PrintMoveJumper(string sMove, int iPosition, int HAMO, object oPC , object oHub)
{
int X = StringToInt(GetTokenByPosition(sMove,";",0));
int Y = StringToInt(GetTokenByPosition(sMove,";",1));


if(X == 0 && Y == 0) return;

int iSeat = GetLocalInt(oPC,"GAME_SEAT");
int iOwner;

iPosition = GenerateNewPosition(iPosition, X, Y);
iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Owner");

    if(iPosition == -1) return;

	if(iOwner == iSeat) return;
	
	if(iOwner != 0 && iOwner != iSeat && HAMO == TRUE)
	return;

	if(iOwner != 0 && iOwner != iSeat)
	{
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_select_red.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);
	return;
	}
	
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_move_marker.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);

}

//-------------

void PrintMoveAttack(string sMove, int iPosition, object oPC , object oHub)
{
int X = StringToInt(GetTokenByPosition(sMove,";",0));
int Y = StringToInt(GetTokenByPosition(sMove,";",1));

if(X == 0 && Y == 0) return;

int iSeat = GetLocalInt(oPC,"GAME_SEAT");
int iOwner;

iPosition = GenerateNewPosition(iPosition, X, Y);
iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Owner");

    if(iPosition == -1) return;

	if(iOwner == iSeat) return;
	

	if(iOwner != 0 && iOwner != iSeat)
	{
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_select_red.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);
	return;
	}
	
}

//----------

void PrintMoveRange(string sMove, int iPosition, int HAMO, int iRange, object oPC , object oHub)
{
int X = StringToInt(GetTokenByPosition(sMove,";",0));
int Y = StringToInt(GetTokenByPosition(sMove,";",1));

if(X == 0 && Y == 0) return;

int iSeat = GetLocalInt(oPC,"GAME_SEAT");
int iOwner;


while(iPosition <= 88 && iPosition >= 11 && iRange != 0 )
{
 
iPosition = GenerateNewPosition(iPosition, X, Y);
iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iPosition)+"_Owner");
iRange = iRange -1;

    if(iPosition == -1) return;

	if(iOwner == iSeat) return;
	
	if(iOwner != 0 && iOwner != iSeat && HAMO == TRUE)
	return;

	if(iOwner != 0 && iOwner != iSeat)
	{
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_select_red.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);
	return;
	}
	
	SetGUITexture(oPC, "SAVA_MAIN", IntToString(iPosition)+"_Actions", "sava_move_marker.tga");
	SetLocalInt(oHub,"FIELD_"+IntToString(iPosition)+"_VT", TRUE);

}

}


//--------------

void CleanSelection(object oPC , object oHub)
{
int i;
int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");

	for(i = 1; i <= 88 ; i++)
	{
		if(GetLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT") == TRUE)
		{
		SetGUITexture(oPC, "SAVA_MAIN", IntToString(i)+"_Actions", "");
		SetLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT", FALSE);
		}
	}
	
SetLocalInt(oHub,"KILLER_SWITCH_PLR_"+IntToString(iPlayerSeat), FALSE);	

}


int GenerateNewPosition(int iPos, int X, int Y)
{
int PosX = StringToInt(GetSubString(IntToString(iPos),0,1));
int PosY = iPos -(PosX * 10);


if(PosY <= 0 || PosY > 8) return -1;
if(PosX <= 0 || PosX > 8) return -1;

PosX = PosX + X;
PosY = PosY + Y;

return (PosX * 10) + PosY;

}

void MovePieceToField(int iType, int iSelect, int iDestination, object oPC, object oHub)
{
int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");

DeletePiece(iSelect, oHub);

if(Promotion(iPlayerSeat,iType,iDestination,oHub) == FALSE)
SetGUIPiece(iType,iDestination,iPlayerSeat,oHub);

// kamal : add code to move the placeable
SetPlaceablePiece(iType,iDestination,iPlayerSeat,oHub);

//if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE) CheckSpectatorField(iSelect, oHub);

}



void SendMessageToGameLog(object oPC, int iType, int iHostile, int iTarget, int Start, int End, object oHub)
{
int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

string sPlayerName = GetName(oPC);
string sName = Get2DAString(sPiece2da,"Name",iType);
string sTargetName = Get2DAString(sPiece2da,"Name",iTarget);
string sLog = GetLocalString(oHub, "GAME_LOG");
string sNewEntry;

string sTGA = Get2DAString(sPiece2da,"Image",iTarget);

string sLetter, sLetter2;

int StartX = StringToInt(GetSubString(IntToString(Start),0,1));
int StartY = Start -(StartX * 10);

int iKillCount = GetLocalInt(oHub,"Kill_Count_"+IntToString(iPlayerSeat));

int EndX = StringToInt(GetSubString(IntToString(End),0,1));
int EndY = End -(EndX * 10);

switch(StartY)
{
case 1: sLetter = "A"; break;
case 2: sLetter = "B"; break;
case 3: sLetter = "C"; break;
case 4: sLetter = "D"; break;
case 5: sLetter = "E"; break;
case 6: sLetter = "F"; break;
case 7: sLetter = "G"; break;
case 8: sLetter = "H"; break;
}

switch(EndY)
{
case 1: sLetter2 = "A"; break;
case 2: sLetter2 = "B"; break;
case 3: sLetter2 = "C"; break;
case 4: sLetter2 = "D"; break;
case 5: sLetter2 = "E"; break;
case 6: sLetter2 = "F"; break;
case 7: sLetter2 = "G"; break;
case 8: sLetter2 = "H"; break;
}

if(iType == -66)
{

	if(iPlayerSeat == 1)
	{
	sNewEntry = "\n<c=lime>"+sTargetName+"("+sLetter2+IntToString(EndX)+") "+DESTROYED+"</c>";
	}

	if(iPlayerSeat == 2)
	{
	sNewEntry= "\n<c=gold>"+sTargetName+"("+sLetter2+IntToString(EndX)+") "+DESTROYED+"</c>";
	}

sLog += sNewEntry;


if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE)
{
object oComment = GetNearestObjectByTag("SAVA_COMMENT", oHub);
AssignCommand(oComment,ActionSpeakString(sNewEntry));
} 

SetLocalString(oHub,"GAME_LOG",sLog);

SetGUIObjectText(oPlayer1, "SAVA_MAIN", "GameLog", -1, sLog);
SetGUIObjectText(oPlayer2, "SAVA_MAIN", "GameLog", -1, sLog);	

return;
}

if(iHostile != TRUE)
{

	if(iPlayerSeat == 1)
	{
	sNewEntry += "\n<c=lime>"+sName+"("+sLetter+IntToString(StartX)+") "+AT+sLetter2+IntToString(EndX)+"</c>";
	}

	if(iPlayerSeat == 2)
	{
	sNewEntry += "\n<c=gold>"+sName+"("+sLetter+IntToString(StartX)+") "+AT+sLetter2+IntToString(EndX)+"</c>";
	}

sLog += sNewEntry;		

}

if(iHostile == TRUE)
{

	if(iPlayerSeat == 1)
	{
	sNewEntry += "\n<c=lime>>>"+sName+"("+sLetter+IntToString(StartX)+") "+CAPTURES+sTargetName+"("+sLetter2+IntToString(EndX)+")</c>";
	SetLocalInt(oHub,"Kill_Count_"+IntToString(iPlayerSeat),iKillCount+1);
	SetGUITexture(oPlayer1,"SAVA_MAIN","KILL_"+IntToString(iKillCount+1),sTGA);
	SetGUITexture(oPlayer2,"SAVA_MAIN","LOST_"+IntToString(iKillCount+1),sTGA);
	SetLocalInt(oHub, IntToString(iPlayerSeat)+"_TAKEN_"+IntToString(iKillCount+1),iTarget);
	}

	if(iPlayerSeat == 2)
	{
	sNewEntry += "\n<c=gold>>>"+sName+"("+sLetter+IntToString(StartX)+") "+CAPTURES+sTargetName+"("+sLetter2+IntToString(EndX)+")</c>";
	SetLocalInt(oHub,"Kill_Count_"+IntToString(iPlayerSeat),iKillCount+1);
	SetGUITexture(oPlayer2,"SAVA_MAIN","KILL_"+IntToString(iKillCount+1),sTGA);
	SetGUITexture(oPlayer1,"SAVA_MAIN","LOST_"+IntToString(iKillCount+1),sTGA);
	SetLocalInt(oHub, IntToString(iPlayerSeat)+"_TAKEN_"+IntToString(iKillCount+1),iTarget);	
	}
	
sLog += sNewEntry;	

}
/*
if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE)
{
object oComment = GetNearestObjectByTag("SAVA_COMMENT", oHub);
AssignCommand(oComment,ActionSpeakString(sNewEntry));
} 
*/
SetLocalString(oHub,"GAME_LOG",sLog);

SetGUIObjectText(oPlayer1, "SAVA_MAIN", "GameLog", -1, sLog);
SetGUIObjectText(oPlayer2, "SAVA_MAIN", "GameLog", -1, sLog);

}


void TakePieceFromField(object oPC, int iType, int iSelect, int iDestination, object oHub)
{

int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");

int iTakenPiece = GetLocalInt(oHub, "FIELD_"+IntToString(iDestination)+"_Piece");

DeletePiece(iSelect, oHub);

if(Promotion(iPlayerSeat,iType,iDestination,oHub) == FALSE)
SetGUIPiece(iType,iDestination,iPlayerSeat,oHub);

SendMessageToGameLog(oPC, iType,TRUE, iTakenPiece,iSelect, iDestination, oHub);

//if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE) CheckSpectatorField(iSelect, oHub);


}


//kamal : the SAVA gui functions should never call, but they have been commented out in any case
void ChangeRound(object oPC, object oHub)
{

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

	if(oPC == oPlayer1)
	{
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Red_Passive",FALSE);	
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Red_Active",TRUE);
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Green_Active",TRUE);
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Green_Passive",TRUE);	
	
//	SetGUIObjectDisabled(oPlayer1,"SAVA_MAIN","Dices", TRUE);
	if(GetLocalInt(oHub,"1_SP_USED") != TRUE)	
//	SetGUIObjectDisabled(oPlayer1,"SAVA_MAIN","Killer_Spider",TRUE);
	
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Red_Passive",TRUE);	
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Red_Active",FALSE);
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Green_Active",TRUE);
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Green_Passive",TRUE);
	
//	SetGUIObjectDisabled(oPlayer2,"SAVA_MAIN","Dices", FALSE);
	if(GetLocalInt(oHub,"2_SP_USED") != TRUE)
//	SetGUIObjectDisabled(oPlayer2,"SAVA_MAIN","Killer_Spider",FALSE);
	
	SendMessageToPlayers(TURN, 2, oHub);
	
	return;		
	}
	
	if(oPC == oPlayer2)
	{
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Red_Passive",TRUE);	
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Red_Active",TRUE);
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Green_Active",FALSE);
	SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Green_Passive",TRUE);	
	
//	SetGUIObjectDisabled(oPlayer1,"SAVA_MAIN","Dices", FALSE);
	if(GetLocalInt(oHub,"1_SP_USED") != TRUE)	
//	SetGUIObjectDisabled(oPlayer1,"SAVA_MAIN","Killer_Spider",FALSE);
		
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Red_Passive",TRUE);	
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Red_Active",TRUE);
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Green_Active",TRUE);
	SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Green_Passive",FALSE);
	
//	SetGUIObjectDisabled(oPlayer2,"SAVA_MAIN","Dices", TRUE);
	if(GetLocalInt(oHub,"2_SP_USED") != TRUE)	
//	SetGUIObjectDisabled(oPlayer2,"SAVA_MAIN","Killer_Spider",TRUE);	
		
	SendMessageToPlayers(TURN, 1, oHub);
		
	return;	
	}

}	
	
//----------------	


void ShowEnemyPieces(int iSeat, object oPC, object oHub, int iPieceType = -1)
{
	
	int i;
	int iOwner, iLider, iType;
	for(i = 11; i <= 88 ; i++)
	{
	iOwner = GetLocalInt(oHub,"FIELD_"+IntToString(i)+"_Owner");
	iLider = GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Lider");
	iType = GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece");

		if(iOwner != iSeat && iOwner != 0 && iLider != TRUE )
		{
			if( iType == iPieceType )
			{
			SetGUITexture(oPC, "SAVA_MAIN", IntToString(i)+"_Actions", "sava_select_red.tga");
			SetLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT", TRUE);
			}
			
			if( iPieceType == -1)
			{
			SetGUITexture(oPC, "SAVA_MAIN", IntToString(i)+"_Actions", "sava_select_red.tga");
			SetLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT", TRUE);
			}
		}
	}
	
	
}

//-----------------



void ShowOwnPieces(int iSeat, object oPC, object oHub, int iPieceType = -1)
{
	
	int i;
	int iOwner, iLider, iType;
	for(i = 11; i <= 88 ; i++)
	{
	iOwner = GetLocalInt(oHub,"FIELD_"+IntToString(i)+"_Owner");
	iLider = GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Lider");
	iType = GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece");

		if(iOwner == iSeat && iLider != TRUE )
		{
			if( iType == iPieceType )
			{
			SetGUITexture(oPC, "SAVA_MAIN", IntToString(i)+"_Actions", "sava_select_darkblue.tga");
			SetLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT", TRUE);
			}
			
			if( iPieceType == -1)
			{
			SetGUITexture(oPC, "SAVA_MAIN", IntToString(i)+"_Actions", "sava_select_darkblue.tga");
			SetLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT", TRUE);
			}
		}
	}
	
	
}


//----------------	

//technically this is only used for SAVA
int GetRandomPiece(int iSeat, object oHub, string sPieceType)
{
	
	int i,index;
	int iOwner, iLider, iType;
	
	string sSelect;
	

int iTokensA = GetNumberTokens(sPieceType,";");

		for (index = 0 ; index <= iTokensA -1 ; index ++ )
		{

			for(i = 11; i <= 88 ; i++)
			{
			iOwner = GetLocalInt(oHub,"FIELD_"+IntToString(i)+"_Owner");
			iLider = GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Lider");
			iType = GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece");

				if(iOwner == iSeat && iLider != TRUE )
				{
					if( iType == StringToInt(GetTokenByPosition(sPieceType,";",index)))
					{
					sSelect = sSelect + IntToString(i)+";";
					}
			
					if( sPieceType == "-1"  && iLider != TRUE )
					{
					sSelect = sSelect + IntToString(i)+";";
					}
				}
			}
			
			}
	
	int iTokens = GetNumberTokens(sSelect,";") -1 ;
	int iRandom = Random(iTokens)+1 ;
	
	return StringToInt(GetTokenByPosition(sSelect,";",iRandom));

}

//-----------------


void DeclareWin(object oPC, object oHub)
{
object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

	if(oPC == oPlayer1)
	{
	SetGUIObjectHidden(oPlayer1, "SAVA_MAIN", "WIN", FALSE);
	SetGUIObjectHidden(oPlayer2, "SAVA_MAIN", "LOOSE", FALSE);
	}
	else
	{
	SetGUIObjectHidden(oPlayer2, "SAVA_MAIN", "WIN", FALSE);
	SetGUIObjectHidden(oPlayer1, "SAVA_MAIN", "LOOSE", FALSE);	
	}
	
	SetLocalInt(oHub,"GAME_IN_PROGERSS", FALSE);

}


//------------------
/* //original sava code
void KillerSpiderButton(object oPC, int iDieces, object oHub)
{

int iRows = GetNum2DARows(sSpider2da);
int index = 0; 

while(StringToInt(Get2DAString(sSpider2da, "Number", index)) != iDieces && index <= iRows-1 )
{
index++;
}

string sPieces = Get2DAString(sSpider2da, "Pieces", index);
int iPassive = StringToInt(Get2DAString(sSpider2da, "Passive", index));
int iSelf = StringToInt(Get2DAString(sSpider2da, "Self", index));

if(iPassive == FALSE)
{
int iSeat = GetLocalInt(oPC,"GAME_SEAT");
int iTokens = GetNumberTokens(sPieces,";");

		for (index = 0 ; index <= iTokens -1 ; index ++ )
		{
		if(iSelf == TRUE)
		ShowOwnPieces(iSeat, oPC, oHub, StringToInt(GetTokenByPosition(sPieces,";",index)));		
		else
		ShowEnemyPieces(iSeat, oPC, oHub, StringToInt(GetTokenByPosition(sPieces,";",index)));
		}
			
return;
}	

if(iPassive == TRUE)
{
KillerSpiderActivation(oPC, index, oHub);
ChangeRound(oPC,oHub);
}	
	
}
*/

//intentionall empty, only used for SAVA
void KillerSpiderButton(object oPC, int iDieces, object oHub)
{
	
	
}

//----------------

void ShowKillerSpiderTooltip(object oPC, int iDieces, object oHub)
{
//intentional do nothing. Not used for chess, only used for Sava
	
}

// original sava code
/*
void ShowKillerSpiderTooltip(object oPC, int iDieces, object oHub)
{
int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

int iRows = GetNum2DARows(sSpider2da);
int index = 0; 

while(StringToInt(Get2DAString(sSpider2da, "Number", index)) != iDieces && index <= iRows-1 )
{
index++;
}

string sTooltip = Get2DAString(sSpider2da, "Tooltip", index);

SetLocalGUIVariable(oPC,"SAVA_MAIN",2,sTooltip);	

if(iPlayerSeat == 1)
{
SetGUIObjectHidden(oPlayer2,"SAVA_MAIN", "Player1_Small_Spider", FALSE);
SetLocalGUIVariable(oPlayer2,"SAVA_MAIN",92,sTooltip);
return;
}

if(iPlayerSeat == 2)
{
SetGUIObjectHidden(oPlayer1,"SAVA_MAIN", "Player2_Small_Spider", FALSE);
SetLocalGUIVariable(oPlayer1,"SAVA_MAIN",93,sTooltip);
return;
}
	
}
*/

//-----------------

int DeletePiece(int iTarget, object oHub, int iDoFieldCheck = FALSE)
{
//add placeable deletion from the square
object oWP= GetNearestObjectByTag("wp_rkchess_"+IntToString(iTarget), oHub, 1); //get wp in the given square of the board\
location lWP =GetLocation(oWP);
 //the RADIUS_SIZE_SMALL size here is a size smaller than one square of the board, to make sure we don't select a piece in an adjacent square
object oPiece= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lWP, FALSE, OBJECT_TYPE_PLACEABLE); 
string sTag = GetTag(oPiece); 

while (GetIsObjectValid(oPiece)==TRUE)
{
	//we're going to make sure this is a chess piece by checking for the tag identifying it as a piece
	if ((GetSubString(sTag, 0, 9) == "rk_chess_"))
	{
	SetLocalString(oHub, "CurrentPiece",GetTag(oPiece)); //save piece tag so we know what piece to create at move location
	DestroyObject(oPiece,0.0);
	}
	else
	{//do nothing
	}
	GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lWP, FALSE, OBJECT_TYPE_PLACEABLE);
}



//this code is all for the gui
SetLocalInt(oHub, "FIELD_"+IntToString(iTarget)+"_Piece",-1);
SetLocalInt(oHub, "FIELD_"+IntToString(iTarget)+"_Owner",0);
SetLocalInt(oHub, "FIELD_"+IntToString(iTarget)+"_Lider",FALSE);

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

SetGUITexture(oPlayer1,"SAVA_MAIN",IntToString(iTarget)+"_Piece","");
SetGUITexture(oPlayer2,"SAVA_MAIN",IntToString(iTarget)+"_Piece","");

SetLocalGUIVariable(oPlayer1,"SAVA_MAIN",iTarget,"");
SetLocalGUIVariable(oPlayer2,"SAVA_MAIN",iTarget,"");


//if(GetLocalInt(oHub,"SPECTATOR_MODE") == TRUE && iDoFieldCheck == TRUE)
//CheckSpectatorField(iTarget, oHub);



return  GetLocalInt(oHub, "FIELD_"+IntToString(iTarget)+"_Piece");

}


//------------------

//kamal, for chess, this function shouldn't do anything. It's used for random dice during sava
void KillerSpiderActivation(object oPC, int iDef, object oHub, int iDestination = -1)
{



}


//original sava code
/*
void KillerSpiderActivation(object oPC, int iDef, object oHub, int iDestination = -1)
{

int iPlayerSeat = GetLocalInt(oPC,"GAME_SEAT");
int iAction = StringToInt(Get2DAString(sSpider2da, "Action", iDef));
int iSelf = StringToInt(Get2DAString(sSpider2da, "Self", iDef));
string sPieces = Get2DAString(sSpider2da, "Pieces", iDef);

if(iAction == 1) // Removal of the player's piece
{
DeletePiece(iDestination, oHub, TRUE);
}


if(iAction == 2) //Change one piece to the other player
{
int iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iDestination)+"_Owner");

DeletePiece(iDestination, oHub);

int iReplacement;

if(iOwner == 1) iReplacement = StringToInt(Get2DAString(sSpider2da, "P1_AltPiece", iDef));
else
iReplacement = StringToInt(Get2DAString(sSpider2da, "P2_AltPiece", iDef));

SetGUIPiece(iReplacement, iDestination, iOwner, oHub);

}

if(iAction == 3) //Change one piece to the other player
{
int iOwner = GetLocalInt(oHub, "FIELD_"+IntToString(iDestination)+"_Owner");

DeletePiece(iDestination, oHub);

int iReplacement;

if(iPlayerSeat == 1) iReplacement = StringToInt(Get2DAString(sSpider2da, "P1_AltPiece", iDef));
else
iReplacement = StringToInt(Get2DAString(sSpider2da, "P2_AltPiece", iDef));

SetGUIPiece(iReplacement, iDestination, iPlayerSeat, oHub);

}


if(iAction == 4) // Changing the player's random piece to another piece
{

int iOwner;

if(iSelf == TRUE)
{
	iOwner = iPlayerSeat;
}
else
{
	if(iPlayerSeat == 1) iOwner = 2;
	else
	iOwner = 1;
}

iDestination = GetRandomPiece(iOwner, oHub, sPieces);


DeletePiece(iDestination, oHub);

int iReplacement;

if(iOwner == 1) iReplacement = StringToInt(Get2DAString(sSpider2da, "P1_AltPiece", iDef));
else
iReplacement = StringToInt(Get2DAString(sSpider2da, "P2_AltPiece", iDef));

SetGUIPiece(iReplacement, iDestination, iOwner, oHub);

}

if(iAction == 5) //Changing opponent's random piece to another
{

int iOwner,iEnemy;

if(iSelf == TRUE)
{
	iOwner = iPlayerSeat;
}
else
{
	if(iPlayerSeat == 1) iOwner = 2;
	else
	iOwner = 1;
}

if(iOwner == 1) iEnemy = 2; else iEnemy = 1;

iDestination = GetRandomPiece(iOwner, oHub, sPieces);

DeletePiece(iDestination, oHub);

int iReplacement;

if(iEnemy == 1) iReplacement = StringToInt(Get2DAString(sSpider2da, "P1_AltPiece", iDef));
else
iReplacement = StringToInt(Get2DAString(sSpider2da, "P2_AltPiece", iDef));

SetGUIPiece(iReplacement, iDestination, iEnemy, oHub);

}

if(iAction == 6) // Removal of a random player piece
{
int iOwner;

if(iSelf == TRUE)
{
	iOwner = iPlayerSeat;
}
else
{
	if(iPlayerSeat == 1) iOwner = 2;
	else
	iOwner = 1;
}

iDestination = GetRandomPiece(iOwner, oHub, sPieces);

DeletePiece(iDestination, oHub, TRUE);
}



SetGUIObjectText(oPC,"SAVA_MAIN","D1",-1,"");
SetGUIObjectText(oPC,"SAVA_MAIN","D2",-1,"");
SetGUIObjectDisabled(oPC,"SAVA_MAIN","Killer_Spider",TRUE);
SetLocalGUIVariable(oPC,"SAVA_MAIN",2,SPIDER_USED);
SetLocalInt(oHub,IntToString(iPlayerSeat)+"_SP_USED", TRUE);


}
*/
//-------------------

void CheckSaveSettings(object oPC)
{

if(SAVE_ALLOWED == FALSE)
{
SetGUIObjectDisabled(oPC,"SAVA_MAIN","Save_Game1",TRUE);
SetGUIObjectDisabled(oPC,"SAVA_MAIN","Save_Game2",TRUE);
SetGUIObjectDisabled(oPC,"SAVA_MAIN","Load_Game",TRUE);
return;
}

object oItem = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oItem))
{

	if(GetResRef(oItem) == SAVE_RESREF)
	{
	SetGUIObjectDisabled(oPC,"SAVA_MAIN","Load_Game",FALSE);
	return;
	}

oItem = GetNextItemInInventory(oPC);
}

SetGUIObjectDisabled(oPC,"SAVA_MAIN","Load_Game",TRUE);

}

//------------------

int SaveGame(object oItem, object oHub)
{

int i;

for(i=11; i <= 88; i++)
{
SetLocalInt(oItem,"OWNER_"+IntToString(i), GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Owner"));
SetLocalInt(oItem,"PIECE_"+IntToString(i), GetLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece"));
}

SetLocalInt(oItem,"Player1_D1",GetLocalInt(oHub,"D1_1"));
SetLocalInt(oItem,"Player1_D2",GetLocalInt(oHub,"D2_1"));
SetLocalInt(oItem,"Player1_SP_USED", GetLocalInt(oHub,"1_SP_USED"));

SetLocalInt(oItem,"Player2_D1",GetLocalInt(oHub,"D1_2"));
SetLocalInt(oItem,"Player2_D2",GetLocalInt(oHub,"D2_2"));
SetLocalInt(oItem,"Player2_SP_USED", GetLocalInt(oHub,"2_SP_USED"));

for(i = 1 ; i <= 16 ; i++)
{
SetLocalInt(oItem,"Player1_T_"+IntToString(i),GetLocalInt(oHub,"1_TAKEN_"+IntToString(i)));
}


for(i = 1 ; i <= 16 ; i++)
{
SetLocalInt(oItem,"Player2_T_"+IntToString(i),GetLocalInt(oHub,"2_TAKEN_"+IntToString(i)));
}

	SetLocalInt(oItem,"Kill_Count_1",GetLocalInt(oHub,"Kill_Count_1"));
	SetLocalInt(oItem,"Kill_Count_2",GetLocalInt(oHub,"Kill_Count_2"));

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

	SetGUIObjectText(oPlayer1,"SAVA_MAIN","GENERIC_INFO",-1,SAVED);
	DelayCommand(1.5, SetGUIObjectText(oPlayer1,"SAVA_MAIN","GENERIC_INFO",-1,""));

	SetGUIObjectText(oPlayer2,"SAVA_MAIN","GENERIC_INFO",-1,SAVED);
	DelayCommand(1.5, SetGUIObjectText(oPlayer2,"SAVA_MAIN","GENERIC_INFO",-1,""));
	

return TRUE;
}

//----------------

//original sava
/*
void CheckSpiderSettings(object oHub)
{

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

if(SPIDER_ALLOWED == FALSE)
{
SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Dices",TRUE);
SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Dices",TRUE);

	SetGUIObjectText(oPlayer1,"SAVA_MAIN","D1",-1,"");
	SetGUIObjectText(oPlayer1,"SAVA_MAIN","D2",-1,"");

	SetGUIObjectText(oPlayer2,"SAVA_MAIN","D1",-1,"");
	SetGUIObjectText(oPlayer2,"SAVA_MAIN","D2",-1,"");
	
}

}
*/

// kamal, basically, make sure we're not actually doing anything for the sava spider
void CheckSpiderSettings(object oHub)
{
/*
object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

if(SPIDER_ALLOWED == FALSE)
{
SetGUIObjectHidden(oPlayer1,"SAVA_MAIN","Dices",TRUE);
SetGUIObjectHidden(oPlayer2,"SAVA_MAIN","Dices",TRUE);

	SetGUIObjectText(oPlayer1,"SAVA_MAIN","D1",-1,"");
	SetGUIObjectText(oPlayer1,"SAVA_MAIN","D2",-1,"");

	SetGUIObjectText(oPlayer2,"SAVA_MAIN","D1",-1,"");
	SetGUIObjectText(oPlayer2,"SAVA_MAIN","D2",-1,"");
	
}
*/
}

//-------------------

int Promotion(int iPlayer, int iPiece, int iTarget, object oHub)
{

string sX = Get2DAString(sPiece2da,"Promotion_X",iPiece);
string sTargetXLine = GetSubString(IntToString(iTarget),0,1);

string sY = Get2DAString(sPiece2da,"Promotion_Y",iPiece);
string sTargetYLine = GetSubString(IntToString(iTarget),1,1);

if(sTargetXLine == sX)
{
int iPromotion = StringToInt(Get2DAString(sPiece2da,"Promotion_Figure",iPiece));
SetGUIPiece(iPromotion, iTarget, iPlayer, oHub);
return TRUE;
}

if(sTargetYLine == sY)
{
int iPromotion = StringToInt(Get2DAString(sPiece2da,"Promotion_Figure",iPiece));
SetGUIPiece(iPromotion, iTarget, iPlayer, oHub);
return TRUE;
}

return FALSE;
}

//--------------------

void SendMessageToPlayers(string sText, int iPlayer, object oHub)
{
object oPlayer1 = GetLocalObject(oHub,"PLR_1");
object oPlayer2 = GetLocalObject(oHub,"PLR_2");

	if( iPlayer == 1 || iPlayer == 0)
	{
	SetGUIObjectText(oPlayer1,"SAVA_MAIN","GENERIC_INFO",-1,sText);
	DelayCommand(1.5, SetGUIObjectText(oPlayer1,"SAVA_MAIN","GENERIC_INFO",-1,""));
	}
	
	if( iPlayer == 2 || iPlayer == 0)
	{
	SetGUIObjectText(oPlayer2,"SAVA_MAIN","GENERIC_INFO",-1,sText);
	DelayCommand(1.5, SetGUIObjectText(oPlayer2,"SAVA_MAIN","GENERIC_INFO",-1,""));
	}
	
}

//if you wanted to start with a blank board and spawn the pieces in, you'd do this here
void StartGamePlaceableSetup(object oHub)
{
int iRows = GetNum2DARows(sStart2da);
int i;

int iPosition;
int iType;
int iPlayer;

for(i=0 ; i <= iRows-1 ; i++)
	{
	iType = StringToInt(Get2DAString(sStart2da,"Type",i));
	iPlayer = StringToInt(Get2DAString(sStart2da,"Player",i));
	iPosition = StringToInt(Get2DAString(sStart2da,"Position",i));
	SetPlaceablePiece(iType,iPosition,iPlayer,oHub);
	}
}

//remove all the pieces from the board at end of the game, then place pieces to default location for new game
void EndGameCleanUp(object oHub)
{
//add placeable deletion from the square
object oWP= GetNearestObjectByTag("wp_rkchess_44", oHub, 1); //get wp in the approximate center of the board\
location lWP =GetLocation(oWP);
object oArea = GetArea(oHub);
object oPiece= GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lWP, FALSE, OBJECT_TYPE_PLACEABLE);  //the 100.0 size here is the radius of the gameboard
//object oPiece= GetFirstObjectInArea();  //the 100.0 size here is the radius of the gameboard
string sTag = GetTag(oPiece); 
//GetNearestObjectByTag("rk_chess_"+iTarget, oWP, 1); //get the piece in this square
	string sChess = "rk_chess_";

while(oPiece != OBJECT_INVALID)
{
	string sTarget = GetTag(oPiece);
	//we're going to make sure this is a chess piece by checking for the tag identifying it as a piece
	if (GetSubString(sTarget, 0,9) =="rk_chess_")
	{
	DestroyObject(oPiece);
	}

	else
	{ //do nothing
	}
	oPiece = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lWP, FALSE, OBJECT_TYPE_PLACEABLE);
}

//'cleanup finished, now spawn pieces in for new game
StartGamePlaceableSetup(oHub);
}