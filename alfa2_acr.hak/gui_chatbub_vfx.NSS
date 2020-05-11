#include "x0_i0_spells"

const string LIST_SEP_CHAR = ",";
const string WILDCARD_CHAR = "*";

const string CHAT_BUBBLE_WHISPER_MODE = "bWhisperMode"; // local int on PC for if whispering
const string CHAT_BUBBLE_DISPLAY_OFF = "bChatBubbleDisabled"; // token int on PC for turning chat bubbles on/off
const string CHAT_BUBBLE_TEXT_LENGTH = "nChatTextLength"; // local int on PC for text entry length
const string CHAT_BUBBLE_IGNORE_LIST = "!*,/r*,/t*,/d*,/w*,#*,/"; // ignore strings with an entry in this list
const int    CHAT_BUBBLE_VFXNUM = 34050;
const string CHAT_BUBBLE_FILENAME = "fx_chatbubble";
const float  CHAT_BUBBLE_DURATION = 4.0f;

string RemoveStringLeft(string sString, int nCount = 1) 
{
    return GetStringRight(sString,GetStringLength(sString)-nCount);
}

string RemoveStringRight(string sString, int nCount = 1) 
{
    return GetStringLeft(sString,GetStringLength(sString)-nCount);
}

string GetStringAfter(string sTokStr) 
{
    int nPos=FindSubString(sTokStr, LIST_SEP_CHAR);
    if (nPos<0)
    {
        return "";
    }
    return RemoveStringLeft(sTokStr, nPos+GetStringLength(LIST_SEP_CHAR));
}

string GetStringBefore(string sToken) 
{
    string sIn = sToken;
    int nPos = FindSubString(sToken, LIST_SEP_CHAR);
    string sOut;
    if(nPos < 0) sOut = sToken;
    else sOut = GetStringLeft(sToken, nPos);
    return sOut;
}

int StringInList(string sEntry, string sList)
{
    int nReturn = 1;
    int nWildCharLength = GetStringLength(WILDCARD_CHAR);
    int bAllowFront = FALSE;
    int bAllowBack = FALSE;
    while (sList!="")
    {
        string sTest = GetStringBefore(sList);
        if (nWildCharLength)
        {
            string sChar = GetStringLeft(sTest, nWildCharLength);
            bAllowFront = (sChar == WILDCARD_CHAR);
            if (bAllowFront)
            {
                sTest = RemoveStringLeft(sTest, nWildCharLength);
            }
            sChar = GetStringRight(sTest, nWildCharLength);
            bAllowBack = (sChar == WILDCARD_CHAR);
            if (bAllowBack)
            {
                sTest = RemoveStringRight(sTest, nWildCharLength);
            }
        }
        else
        {
            bAllowFront = FALSE;
            bAllowBack = FALSE;
        }
        int nPos = FindSubString(sEntry,sTest);
        if (nPos>=0)
        {
            int nTestLength = GetStringLength(sTest);
            int nEntryLength = GetStringLength(sEntry);
            if ((bAllowFront || nPos == 0) && (bAllowBack || nEntryLength == (nPos + nTestLength)))
            {
                return nReturn;
            }
        }
        ++nReturn;
        sList = GetStringAfter(sList);
    }
    return 0;
}

void main(string mode, string text)
{
    object oPC = OBJECT_SELF;
    int bDisabled = FALSE;

	// Nothing happening: leave before further checks
    if (mode == "type" && text == "") {
		return;
	}
	
    // This is a whisper, enable whisper mode
    if (mode == "W")
    {
        SetLocalInt(oPC, CHAT_BUBBLE_WHISPER_MODE, TRUE);
        return;
    }

    // Clear out any chat bubbles and whisper mode
    if (mode == "clear" || mode == "S")
    {
        RemoveAnySpellEffects(CHAT_BUBBLE_VFXNUM, oPC);
		DeleteLocalInt(oPC, CHAT_BUBBLE_WHISPER_MODE);
        return;
    }

    bDisabled = GetLocalInt(oPC, CHAT_BUBBLE_DISPLAY_OFF);
    // Check to see if this is bubble-able
    if (
        mode == "type" &&
        !GetLocalInt(oPC, CHAT_BUBBLE_WHISPER_MODE) &&
        GetIsObjectValid(oPC) &&
        GetIsPC(oPC) &&
        !GetIsPossessedFamiliar(oPC) &&
        !GetIsDM(oPC) &&
        !GetIsDMPossessed(oPC) &&
        !bDisabled
    )
    {
        int nCurrentChatLength = GetStringLength(text);

        // If length is the same, PC isn't typing
        if (GetLocalInt(oPC, CHAT_BUBBLE_TEXT_LENGTH) == nCurrentChatLength)
        {
            return;
        }
        // Check ignore list
        if (StringInList(text, CHAT_BUBBLE_IGNORE_LIST))
        {
            return;
        }
    
        SetLocalInt(oPC, CHAT_BUBBLE_TEXT_LENGTH, nCurrentChatLength);

        // Only refresh if it already exists
        if (GetHasSpellEffect(CHAT_BUBBLE_VFXNUM, oPC))
        {
            RefreshSpellEffectDurations(oPC, CHAT_BUBBLE_VFXNUM, CHAT_BUBBLE_DURATION);
        }
        // Otherwise, create a new effect
        else
        {
            effect eVFX = EffectNWN2SpecialEffectFile(CHAT_BUBBLE_FILENAME);
            eVFX = SetEffectSpellId(eVFX, CHAT_BUBBLE_VFXNUM);
            eVFX = ExtraordinaryEffect(eVFX);
            
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, CHAT_BUBBLE_DURATION);
        }
    }
}
