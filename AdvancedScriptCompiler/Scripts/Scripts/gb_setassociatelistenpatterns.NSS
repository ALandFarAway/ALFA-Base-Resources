//:://////////////////////////////////////////////////////////////////////////
//:: Creature Script:  Set Associate Listen Patterns 
//:: gb_setassociatelistenpatterns
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
     This script called by SetAssociateListenPatterns() script command

     Sets up the special henchmen listening patterns, now also used for
     party companions as well

*/
//:://////////////////////////////////////////////////////////////////////////
//:: Created By: ChazM    
//:: Created On: 11/21/05
//:://////////////////////////////////////////////////////////////////////////
// ChazM 5/5/06 - commented out debug ActionSpeakString()

void main()
{
	//string strScriptName = "gb_setassociatelistenpatterns";
	//string strName = GetName(OBJECT_SELF);
	

    //ActionSpeakString( strName+ " running " + strScriptName );

    //Sets up the special henchmen listening patterns
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_GUARDMASTER",          ASSOCIATE_COMMAND_GUARDMASTER);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_STANDGROUND",          ASSOCIATE_COMMAND_STANDGROUND);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_ATTACKNEAREST",        ASSOCIATE_COMMAND_ATTACKNEAREST);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_HEALMASTER",           ASSOCIATE_COMMAND_HEALMASTER);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_FOLLOWMASTER",         ASSOCIATE_COMMAND_FOLLOWMASTER);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK", ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_MASTERUNDERATTACK",    ASSOCIATE_COMMAND_MASTERUNDERATTACK);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_UNPOSSESSFAMILIAR",    ASSOCIATE_COMMAND_UNPOSSESSFAMILIAR);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_MASTERSAWTRAP",        ASSOCIATE_COMMAND_MASTERSAWTRAP);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_MASTERATTACKEDOTHER",  ASSOCIATE_COMMAND_MASTERATTACKEDOTHER);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED",ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_LEAVEPARTY",           ASSOCIATE_COMMAND_LEAVEPARTY);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_PICKLOCK",             ASSOCIATE_COMMAND_PICKLOCK);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_INVENTORY",            ASSOCIATE_COMMAND_INVENTORY);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_DISARMTRAP",           ASSOCIATE_COMMAND_DISARMTRAP);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_TOGGLECASTING",        ASSOCIATE_COMMAND_TOGGLECASTING);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_TOGGLESTEALTH",        ASSOCIATE_COMMAND_TOGGLESTEALTH);
    SetListenPattern (OBJECT_SELF, "ASSOCIATE_COMMAND_TOGGLESEARCH",         ASSOCIATE_COMMAND_TOGGLESEARCH);

}