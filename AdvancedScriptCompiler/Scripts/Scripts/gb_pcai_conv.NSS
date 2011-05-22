//:://////////////////////////////////////////////////////////////////////////
//:: Player Character Script:  On Dialog
//:: gb_pcai_conv
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    Temp placeholder script
*/
//:://////////////////////////////////////////////////////////////////////////
//:: Created By: Brock Heinz    
//:: Created On: 09/26/05
//:://////////////////////////////////////////////////////////////////////////


void main()
{
	string strScriptName = "ScriptDialogue";
	string strName = GetName(OBJECT_SELF);
	

    if ( GetIsPC( OBJECT_SELF ) )
    {
        ActionSpeakString( "WARNING! Player CONTROLLED object " +strName+ " running " + strScriptName );
    }
    else if ( GetIsOwnedByPlayer(OBJECT_SELF) )
    {
        ActionSpeakString( "Player OWNED object " +strName+ " running " + strScriptName );
    }
	else
	{
		ActionSpeakString( "Player UNOWNED object " +strName+ " running " + strScriptName );
	}

    ExecuteScript("gb_comp_conv", OBJECT_SELF);
}