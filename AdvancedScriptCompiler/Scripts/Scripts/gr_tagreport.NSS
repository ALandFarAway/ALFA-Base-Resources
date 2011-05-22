// DEBUG SCRIPT - REPORT TAGS
// DBR



//#include "ginc_debug"

void TRIterate(location lOrigin, int i)
{
	if (i>27)
		return;
	object oObj=GetNearestObjectToLocation(OBJECT_TYPE_ALL,lOrigin,++i);
	while ((GetTag(oObj)=="blergblerg")||(GetObjectType(oObj)==OBJECT_TYPE_CREATURE))
		oObj=GetNearestObjectToLocation(OBJECT_TYPE_ALL,lOrigin,++i);
	if (!GetIsObjectValid(oObj))
		return;
	//PrettyMessage("-"+GetTag(oObj));
	//object oYeller = CreateObject(OBJECT_TYPE_CREATURE,"n_duncan",GetLocation(oObj),FALSE,"blergblerg");
	//SetScriptHidden(oYeller,TRUE);
	AssignCommand(OBJECT_SELF,SpeakString(GetTag(oObj),TALKVOLUME_SHOUT));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectNWN2SpecialEffectFile("sp_fire_hit"),oObj,1.2f);
	
	//DelayCommand(7.0f,DestroyObject(oYeller));
	DelayCommand(1.0f,TRIterate(lOrigin,i+1));
}



void main()
{
	int i=0;
	AssignCommand(OBJECT_SELF,TRIterate(GetLocation(OBJECT_SELF),0));		
	object oC=GetNearestObject(OBJECT_TYPE_CREATURE,OBJECT_SELF,++i);
	while (GetIsObjectValid(oC))
	{
		AssignCommand(oC,SpeakString(GetTag(oC)));
		oC=GetNearestObject(OBJECT_TYPE_CREATURE,OBJECT_SELF,++i);
	}
}