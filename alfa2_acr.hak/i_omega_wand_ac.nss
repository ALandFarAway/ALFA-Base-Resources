////////////////////////////////////////////////////////////////////////////////
//
//                     Wynna			9/18/2008   
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////


#include "acr_spawn_i"

//void ConversationBegin(string sConv, object oSpeaker) { BeginConversation(sConv,oSpeaker); }

void main()
{   SendMessageToPC(GetItemActivator(), "Leave area after NPC possession to refresh Omega Wand abilities.");
    object oObject = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();
	SetLocalLocation(GetItemActivator(), "lCreate", lTarget);
	int nTargetType = GetObjectType(oObject);
 	if ((nTargetType == OBJECT_TYPE_DOOR) || (nTargetType == OBJECT_TYPE_PLACEABLE)|| (nTargetType == OBJECT_TYPE_CREATURE)) 
		{ 
    	SetLocalObject(GetItemActivator(), "Object_Target", oObject);
		} 
	else 
		{
	    oObject = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lTarget);
		SetLocalObject(GetItemActivator(), "Object_Target", oObject);
		}
	
	AssignCommand(GetItemActivator(), ActionStartConversation(GetItemActivator(), "omega_wand", TRUE, TRUE, TRUE, TRUE ));
   	}