//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_damagetracker_b
//::
//::	Tracks those who have hurt me, much like my lists of names from high school.
//::	from ginc_ai, used by the "attack who damaged me most" AI type
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 2/1/06

#include "ginc_ai"
//#include "ginc_debug"	


int GetCreatureIndex(object oDamager);
void BSortDown(int index);	

void main()
{
	object oDamager=GetLastDamager();
	int nDamage = GetTotalDamageDealt();

//	PrettyMessage(GetTag(oDamager) + " Has hit me for " + IntToString(nDamage));
	int index = GetCreatureIndex(oDamager);
	//increase totaled damage count
	SetLocalInt(OBJECT_SELF, VAR_AP_DAMAGER_PTS + IntToString(index), GetLocalInt(OBJECT_SELF,VAR_AP_DAMAGER_PTS+IntToString(index))+nDamage);
	if (index>1)
		BSortDown(index); 	


	AIContinueInterruptedScript(CREATURE_SCRIPT_ON_DAMAGED); //this script is an interrupt script, so this must be called
																//when you want the original to play
}




void BSortDown(int index)
{
	int nVal = GetLocalInt(OBJECT_SELF,VAR_AP_DAMAGER_PTS+IntToString(index));
	int nNextVal = GetLocalInt(OBJECT_SELF,VAR_AP_DAMAGER_PTS+IntToString(index-1));

	if (nVal>nNextVal)//swap me down one
	{
		object oMe=GetLocalObject(OBJECT_SELF,VAR_AP_DAMAGER+IntToString(index));
		object oNext=GetLocalObject(OBJECT_SELF,VAR_AP_DAMAGER+IntToString(index-1));
		SetLocalObject(OBJECT_SELF,VAR_AP_DAMAGER+IntToString(index-1),oMe);
		SetLocalObject(OBJECT_SELF,VAR_AP_DAMAGER+IntToString(index),oNext);
		SetLocalInt(OBJECT_SELF,VAR_AP_DAMAGER_PTS+IntToString(index-1),nVal);
		SetLocalInt(OBJECT_SELF,VAR_AP_DAMAGER_PTS+IntToString(index),nNextVal);
	}

	if (index>2)//reursive, unless we're at the beginning of the list
		BSortDown(index-1);
}



int GetCreatureIndex(object oDamager)
{
	int i=0;
	int nNumEntries=GetLocalInt(OBJECT_SELF,VAR_AP_NUM_DAMAGERS);

	while (i<nNumEntries)		//cycle through my list.
		if (oDamager==GetLocalObject(OBJECT_SELF,VAR_AP_DAMAGER+IntToString(++i)))
			return i;
	//wasn't in the list. Add an entry.
	i+=1;
	SetLocalInt(OBJECT_SELF,VAR_AP_NUM_DAMAGERS,i);
	SetLocalObject(OBJECT_SELF,VAR_AP_DAMAGER+IntToString(i),oDamager);
	SetLocalInt(OBJECT_SELF,VAR_AP_DAMAGER_PTS+IntToString(i),0);
	return i;
}



