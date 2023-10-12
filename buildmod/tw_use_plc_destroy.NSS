// Created By Arri 2020 to use with secret doors
//Destroy self a little while after moving toon

 /* This goes in the OnUsed event handler of the actual
 * placeable door object.  use a WP tagged dst_<tagofplaceable>
 *for where you want to land after touching the placeable
 */

#include "tw_secret"

void main()

{	
//object oTarget;
//oTarget = OBJECT_SELF;
object oPLC = OBJECT_SELF;
//DelayCommand(300.0, DestroyObject(oTarget, 0.0)); // we don't want the secret entry to hang around
AssignCommand(GetArea(oPLC), DestroyObject(oPLC, 300.0));

 {
 object oUser = GetLastUsedBy();
 // if ( !GetIsPC(oUser)  ||  GetIsDMPossessed(oUser) )// removed because it does not let possessed NPCs through
       // return;
 if (!GetIsSecretItemOpen(OBJECT_SELF))

 {
 SetIsSecretItemOpen(OBJECT_SELF, TRUE);
    } 
	else 
	{
	UseSecretTransport(GetLastUsedBy());
	SetIsSecretItemOpen(OBJECT_SELF, FALSE);
	}

}}