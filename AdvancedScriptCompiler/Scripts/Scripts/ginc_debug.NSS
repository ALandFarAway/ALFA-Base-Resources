// ginc_debug
/*
    Debug functions
*/
// ChazM 9/22/05
// BMA-OEI 9/27/05 tweak default x,y, DebugMessage now prefixes "Debug: "
// ChazM 10/02/05 added more colors, added MessageLine() and DebugMessageLine()
// BMA-OEI 10/17/05 added PrettyPostString(), PrettyDebug(), PrettyError(), PrettyMessage()	
// ChazM 10/18/05 added Backdrop(), modified Message(), PrettyPostString(), added some constants
// BMA-OEI 10/19/05 fixed backdrop problem in Message()
// BMA-OEI 12/19/05 added GetFirstPCInFaction()
// BMA-OEI 1/23/06 updated to use GetFirstPC(FALSE)
// EPF 1/25/06 -- removing the color constants -- they've been added to nwscript.nss.
// BMA-OEI 1/25/06 adding POST_ colors
// ChazM 1/26/06 - modified GetFirstPCInFaction() to no longer use functions that affect the First/Next pointer.
// ChazM 5/14/07 - added SendMessageToAllPlayersByStrRef(), SendMessageToPartyByStrRef()

//void main(){}
		
const int POST_COLOR_RED 			= 4294901760; 	// FFFF0000
const int POST_COLOR_GREEN 			= 4278255360; 	// FF00FF00
const int POST_COLOR_BLUE 			= 4278190335; 	// FF0000FF
const int POST_COLOR_WHITE 			= 4294967295; 	// FFFFFFFF
const int POST_COLOR_BLACK 			= 4278190080; 	// FF000000
const int POST_COLOR_OFFSET 		= 4278190080; 	// FF000000
								
int POST_COLOR_RED_DARK    			= POST_COLOR_OFFSET + FOG_COLOR_RED_DARK;
int POST_COLOR_GREEN_DARK  			= POST_COLOR_OFFSET + FOG_COLOR_GREEN_DARK;
int POST_COLOR_BLUE_DARK   			= POST_COLOR_OFFSET + FOG_COLOR_BLUE_DARK;
int POST_COLOR_GREY        			= POST_COLOR_OFFSET + FOG_COLOR_GREY;
int POST_COLOR_YELLOW      			= POST_COLOR_OFFSET + FOG_COLOR_YELLOW;
int POST_COLOR_YELLOW_DARK 			= POST_COLOR_OFFSET + FOG_COLOR_YELLOW_DARK;
int POST_COLOR_CYAN        			= POST_COLOR_OFFSET + FOG_COLOR_CYAN;
int POST_COLOR_MAGENTA     			= POST_COLOR_OFFSET + FOG_COLOR_MAGENTA;
int POST_COLOR_ORANGE      			= POST_COLOR_OFFSET + FOG_COLOR_ORANGE;
int POST_COLOR_ORANGE_DARK 			= POST_COLOR_OFFSET + FOG_COLOR_ORANGE_DARK;
int POST_COLOR_BROWN       			= POST_COLOR_OFFSET + FOG_COLOR_BROWN; 
int POST_COLOR_BROWN_DARK  			= POST_COLOR_OFFSET + FOG_COLOR_BROWN_DARK;	
						
const int POST_COLOR_DEBUG			= 4291624857; // FFCCFF99 Pale Dull Spring
const int POST_COLOR_ERROR			= 4294941132; // FFFF99CC Pale Dull Pink

const int LINE_SIZE				= 13;
const int PRETTY_LINE_WRAP		= 42;
const int PRETTY_X_OFFSET		= 13;
const int PRETTY_Y_OFFSET		= 13;
const float PRETTY_DURATION		= 13.0f;
string PRETTY_LINE_COUNT_VAR 	= "00_nPrettyLineCount";

const float DURATION_NORMAL		= 10.0f;
const float DURATION_LONG		= 30.0f;

//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------

object GetFirstPCInFaction(object oPC);
	
void Message(string sMessage, int nX=50, int nY=50, float fDuration=DURATION_NORMAL, int nColor=POST_COLOR_GREEN, int nBackdropColor=POST_COLOR_BLACK);
void ErrorMessage(string sMessage, int nX=60, int nY=60, float fDuration=DURATION_LONG, int nColor=POST_COLOR_RED);
void DebugMessage(string sMessage, int nX=70, int nY=70, float fDuration=DURATION_NORMAL, int nColor=POST_COLOR_BLUE);
void OldFunctionMessage(string sOldFunctionName, string sNewFunctionName);

void MessageLine(int nLine, string sMessage, int nX=50, float fDuration=DURATION_LONG, int nColor=POST_COLOR_GREEN);
void DebugMessageLine(int nLine, string sMessage, int nX=50, float fDuration=DURATION_LONG, int nColor=POST_COLOR_BLUE);

void PrettyPostString(object oTarget, string sMessage, float fDuration, int nColor=POST_COLOR_WHITE);
void PrettyDebug(string sMessage, float fDuration=PRETTY_DURATION, int nColor=POST_COLOR_DEBUG);
void PrettyError(string sMessage, float fDuration=PRETTY_DURATION, int nColor=POST_COLOR_ERROR);
void PrettyMessage(string sMessage, float fDuration=PRETTY_DURATION, int nColor=POST_COLOR_WHITE);

void Backdrop(object oTarget, string sMessage, int nX, int nY, float fDuration, int nColor=POST_COLOR_BLACK);

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// Return first player object controlled by a player
object GetFirstPCInFaction(object oPC)
{
	object oRet = oPC;
	if (!GetIsPC(oRet))	// if not player controlled
	{
		oRet = GetPCSpeaker();
		if (!GetIsPC(oRet))
		{
			// this is problematic as it resets the flag used for some GetFirst* functions
			oRet = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_CONTROLLED, oPC);
		}
	}
	return (oRet);
}

// Post a message w/ a backdrop to make it more readable.
void Message(string sMessage, int nX=50, int nY=50, float fDuration=DURATION_NORMAL, int nColor=POST_COLOR_GREEN, int nBackdropColor=POST_COLOR_BLACK)
{
	object oPC = GetFirstPC(FALSE);
	Backdrop(oPC, sMessage, nX, nY, fDuration, nBackdropColor);
	DebugPostString(oPC, sMessage, nX, nY, fDuration, nColor);	
	PrintString(sMessage);
}

// Post an error meesage - these stay up for a while and are in Red
void ErrorMessage(string sMessage, int nX=60, int nY=60, float fDuration=DURATION_LONG, int nColor=POST_COLOR_RED)
{
	sMessage = "Error: " + sMessage;
	Message(sMessage, nX, nY, fDuration, nColor);
}

// messages in blue for debug purposes only.
void DebugMessage(string sMessage, int nX=70, int nY=70, float fDuration=DURATION_NORMAL, int nColor=POST_COLOR_BLUE)	
{
	sMessage = "Debug: " + sMessage;
	Message(sMessage, nX, nY, fDuration, nColor);
}

// a specialized error message for phasing out old stuff
void OldFunctionMessage(string sOldFunctionName, string sNewFunctionName)
{
	string sMessage = "Function '" + sOldFunctionName + "' is obsolete and should be replaced with '" + sNewFunctionName;
	ErrorMessage(sMessage);	
}

// Message posted at a specific line number.  Message stays longer by default since there are probably multiple lines to read
void MessageLine(int nLine, string sMessage, int nX=50, float fDuration=DURATION_LONG, int nColor=POST_COLOR_GREEN)
{
	int nY = nLine * LINE_SIZE;
	Message(sMessage, nX, nY, fDuration, nColor);
}

// messages line in blue for debug purposes only.
void DebugMessageLine(int nLine, string sMessage, int nX=50, float fDuration=DURATION_LONG, int nColor=POST_COLOR_BLUE)	
{
	int nY = nLine * LINE_SIZE;
	Message(sMessage, nX, nY, fDuration, nColor);
}

// Post message with drop-shadow and print to log
void PrettyPostString(object oTarget, string sMessage, float fDuration, int nColor=POST_COLOR_WHITE)
{
	int nX = PRETTY_X_OFFSET;
	int nLineOffset = GetGlobalInt(PRETTY_LINE_COUNT_VAR);
	int nY = PRETTY_Y_OFFSET + (nLineOffset * LINE_SIZE);

	Backdrop(oTarget, sMessage, nX, nY, fDuration, POST_COLOR_BLACK);
	DebugPostString(oTarget, sMessage, nX, nY, fDuration, nColor);
	PrintString(sMessage);

	nLineOffset = (nLineOffset + 1) % PRETTY_LINE_WRAP;
	SetGlobalInt(PRETTY_LINE_COUNT_VAR, nLineOffset);
}

// Pretty post message in debug color
void PrettyDebug(string sMessage, float fDuration=PRETTY_DURATION, int nColor=POST_COLOR_DEBUG)
{
	object oPC = GetFirstPC(FALSE);
	PrettyPostString(oPC, sMessage, fDuration, nColor);
}

// Pretty post message in error color
void PrettyError(string sMessage, float fDuration=PRETTY_DURATION, int nColor=POST_COLOR_ERROR)
{
	object oPC = GetFirstPC(FALSE);
	PrettyPostString(oPC, sMessage, fDuration, nColor);
}

// Pretty post message
void PrettyMessage(string sMessage, float fDuration=PRETTY_DURATION, int nColor=POST_COLOR_WHITE)
{
	object oPC = GetFirstPC(FALSE);
	PrettyPostString(oPC, sMessage, fDuration, nColor);
}

// Post message with drop-shadow and print to log
void Backdrop(object oTarget, string sMessage, int nX, int nY, float fDuration, int nColor=POST_COLOR_BLACK)
{
	DebugPostString(oTarget, sMessage, nX - 1, nY - 1, fDuration, nColor);
	DebugPostString(oTarget, sMessage, nX + 1, nY - 1, fDuration, nColor);
	DebugPostString(oTarget, sMessage, nX + 1, nY + 1, fDuration, nColor);
	DebugPostString(oTarget, sMessage, nX - 1, nY + 1, fDuration, nColor);
}


//-------------------------------------------------

void SendMessageToAllPlayersByStrRef(int nStrRef)
{
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC) == TRUE)
   {
		SendMessageToPCByStrRef( oPC, nStrRef);
      	oPC = GetNextPC();
   }
	
}

void SendMessageToPartyByStrRef(object oPlayer, int nStrRef)
{
    object oPartyMember = GetFirstFactionMember(oPlayer, TRUE);
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		SendMessageToPCByStrRef(oPartyMember, nStrRef);
        oPartyMember = GetNextFactionMember(oPlayer, TRUE);
    }
	
}


