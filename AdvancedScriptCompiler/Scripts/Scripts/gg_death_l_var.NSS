//::///////////////////////////////////////////////////////////////////////////
//::
//::	gg_death_l_var.nss
//::
//::	This is the DeathScript for GroupOnDeathSetLocal (int, float, string).
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 9/2/05
//::
//::///////////////////////////////////////////////////////////////////////////
// BMA-OEI 5/23/06 -- Updated w/ new group functions

#include "ginc_group"

void main()
{
	string sGroupName = GetGroupName( OBJECT_SELF );

	// Update number of sGroupName members killed
	IncGroupNumKilled( sGroupName );

	// If all group members are dead or invalid
	if ( GetIsGroupValid( sGroupName, TRUE ) == FALSE )
	{
		object oTarget = GetGroupObject( sGroupName, "TargetObject" );
		string sVarName = GetGroupString( sGroupName, "VarName" );

		switch ( GetGroupInt( sGroupName, "VarType" ) )
		{
			case TYPE_INT:
				SetLocalInt( oTarget, sVarName, GetGroupInt( sGroupName, "VarValue" ));
				break;
			case TYPE_FLOAT:
				SetLocalFloat( oTarget, sVarName, GetGroupFloat( sGroupName, "VarValue" ));
				break;
			case TYPE_STRING:
				SetLocalString( oTarget, sVarName, GetGroupString( sGroupName, "VarValue" ));
				break;
		}
	}                                 
}