////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : gui_choosercreator
//      Version : 1.0
//         Date : 2012-02-12
//       Author : Zelknolf
//
//  Local Variable Prefix = ACR_CHCR
//
//  Description
//  This script houses the callbacks for the ACR Chooser and Creator GUIs
//
////////////////////////////////////////////////////////////////////////////////


void main( string ActionType, string ActionArgument ) 
{
    object oPC = OBJECT_SELF;
    if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
        SendMessageToPC( oPC, "Only DMs may use this tool." );
        return;
    }
    
    if(ActionType == "42")
    {
        DisplayGuiScreen(OBJECT_SELF, "SCREEN_INFESTATION", FALSE, "infestation.xml", FALSE);
        return;
    }
    
    ClearScriptParams();
    AddScriptParameterInt(StringToInt(ActionType));
    AddScriptParameterString(ActionArgument);
    ExecuteScriptEnhanced("ACR_ChooserCreator", OBJECT_SELF, TRUE);
}

