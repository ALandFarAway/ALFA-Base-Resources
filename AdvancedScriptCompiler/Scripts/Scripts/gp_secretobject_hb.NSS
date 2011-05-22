//::///////////////////////////////////////////////////////////////////////////
//:: gp_secretobject_hb
//::
//:: OnHeartBeat event for secret objects.
//::///////////////////////////////////////////////
//   DBR 1/5/6


//constants
const string sID_SECRET_NEW_OBJECT = "SECRET_NEW_OBJECT";
const string sID_REPLACED_RESREF   = "REPLACED_RESREF";
const string sID_REPLACED_LOCATION = "REPLACED_LOCATION";
const string sID_REPLACED_OBJECT_TYPE = "REPLACED_OBJECT_TYPE";

const string sID_RESREF = "SecretObject_ResRef";
const string sID_TIMETORESET = "TimeToReset";
const string sID_SCRIPT = "RunScript";
const string sID_REPLACE_TAG = "ReplacedObjectTag";
const string sID_JUMPTO_TAG = "JumpDestinationTag";
const string sID_SEARCH_RADIUS = "SearchRadius";
const string sID_DC            = "SearchDC";
const string sID_DC_DETECTMODE = "SearchDCDetectMode";
const string sID_VFX           = "VisualFX";
const string sID_NEWTAG        = "NewObjectTag";

int WasObjectDetected();


int CheckIfDetected(object oSearcher)
{
	int nSkill = GetSkillRank(SKILL_SEARCH,oSearcher);
	int nDetectMode = GetActionMode(oSearcher,ACTION_MODE_DETECT);
	if (GetRacialType(oSearcher)==RACIAL_TYPE_ELF) nDetectMode=1;
	int nRoll, nDC;
	if (nDetectMode)
	{
		nDC = GetLocalInt(OBJECT_SELF,sID_DC_DETECTMODE);
		if (nDC==0)
			nDC = GetLocalInt(OBJECT_SELF,sID_DC);
		nRoll=20;
	}
	else
	{
		nRoll=d20();
		nDC = GetLocalInt(OBJECT_SELF,sID_DC);
	}
	//THE CHECK!
	if (nSkill+nRoll>=nDC)
	{
		PlayVoiceChat(VOICE_CHAT_LOOKHERE, oSearcher);	//I found something!
		return 1;
	}
	return 0;
}


void ResetSecretObject()
{
	if (GetLocalInt(OBJECT_SELF,"SECRET_OBJECT_APPEARED")==0)
		return;
	if (WasObjectDetected())
	{
		DelayCommand(GetLocalFloat(OBJECT_SELF,sID_TIMETORESET),ResetSecretObject());
		return;
	}
	object oSecret=GetLocalObject(OBJECT_SELF,sID_SECRET_NEW_OBJECT);
	string sReplacedResRef=GetLocalString(OBJECT_SELF,sID_REPLACED_RESREF);
	location lReplacedLoc=GetLocalLocation(OBJECT_SELF,sID_REPLACED_LOCATION);
	int nReplacedObjectType=GetLocalInt(OBJECT_SELF,sID_REPLACED_OBJECT_TYPE);
	
	DestroyObject(oSecret);		//out with the new
	object oReplaced;
	if (sReplacedResRef!="")		//in with the old
		oReplaced=CreateObject(nReplacedObjectType,sReplacedResRef,lReplacedLoc,TRUE);
	DeleteLocalInt(OBJECT_SELF,"SECRET_OBJECT_APPEARED");

	string sTag=GetTag(OBJECT_SELF),sPair;	//are we paired?	
	int nLen = GetStringLength(sTag);   	
	string sNewTag = GetStringLeft(sTag, nLen - 1);
	if(GetStringRight(sTag, 1) == "a")
		sPair=sNewTag + "b";
	else
		sPair=sNewTag + "a";
	object oPair=GetObjectByTag(sPair);
	if (GetIsObjectValid(oPair))		//paired doors
		AssignCommand(oPair,ResetSecretObject());
}







void RevealObject()
{
	if (GetLocalInt(OBJECT_SELF,"SECRET_OBJECT_APPEARED")==1) //redundent check for double door safety
		return;

	location lLoc = GetLocation (OBJECT_SELF);
	string sNewTag=GetLocalString(OBJECT_SELF,sID_NEWTAG);
	object oSpawn;

	string sSpawnResRef = GetLocalString(OBJECT_SELF,sID_RESREF);	//Create ResRef
	if (sSpawnResRef!="")	//create object
	{
		oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE,sSpawnResRef,lLoc,TRUE,sNewTag);	
		if (!GetIsObjectValid(oSpawn))					
			oSpawn = CreateObject(OBJECT_TYPE_ITEM,sSpawnResRef,lLoc,TRUE,sNewTag);
		if (!GetIsObjectValid(oSpawn))					
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE,sSpawnResRef,lLoc,TRUE,sNewTag);
		if (!GetIsObjectValid(oSpawn))
		{
			PrintString("gp_secretobject_hb: ERROR, Cannot find ResRef: "+sSpawnResRef);
			DelayCommand(0.2f,DestroyObject(OBJECT_SELF));
			return;
		}

    	int nEffect=GetLocalInt(OBJECT_SELF,sID_VFX);			//what effect?
		if (nEffect!=-1)
		{
			effect eVis = EffectVisualEffect(nEffect);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oSpawn,10.0f);
		}
		//STORE NEW OBJECT'S POINTER FOR RESETTING
		SetLocalObject(OBJECT_SELF,sID_SECRET_NEW_OBJECT,oSpawn);
	}

	string sJumpToTag = GetLocalString(OBJECT_SELF,sID_JUMPTO_TAG);//Used for secret doors
	if (sJumpToTag!="")	
	{
		object oDest=GetObjectByTag(sJumpToTag);
		SetLocalObject(oSpawn,"DOOR_DESTINATION",oDest);
		//SetEventHandler(oSpawn,On used event, on used script);  TO BE IMPLEMENTED LATER

		string sTag=GetTag(OBJECT_SELF), sPair;		//are we paired?
		int nLen = GetStringLength(sTag);   
		string sNewTag = GetStringLeft(sTag, nLen - 1);
		if(GetStringRight(sTag, 1) == "a")
			sPair=sNewTag + "b";
		else
			sPair=sNewTag + "a";
		object oPair=GetObjectByTag(sPair);
		if (GetIsObjectValid(oPair))		//paired doors
			AssignCommand(oPair,RevealObject());
	}

	//Replacement bits
	string sReplaceTag = GetLocalString(OBJECT_SELF,sID_REPLACE_TAG);
	if (sReplaceTag!="")
	{
		object oReplace = GetObjectByTag(sReplaceTag);
		SetLocalString(OBJECT_SELF,sID_REPLACED_RESREF,GetResRef(oReplace));
		SetLocalLocation(OBJECT_SELF,sID_REPLACED_LOCATION,GetLocation(oReplace));
		SetLocalInt(OBJECT_SELF,sID_REPLACED_OBJECT_TYPE,GetObjectType(oReplace));
		DestroyObject(oReplace);
	}

	//Reset bits
	float fTimeToReset=GetLocalFloat(OBJECT_SELF,sID_TIMETORESET);
	if (fTimeToReset>0.0f)
		DelayCommand(fTimeToReset,ResetSecretObject());

	SetLocalInt(OBJECT_SELF,"SECRET_OBJECT_APPEARED",1);

	string sScript=GetLocalString(OBJECT_SELF,sID_SCRIPT);  //in case script is provided
	if (sScript!="")
		ExecuteScript(sScript,OBJECT_SELF);
}


int WasObjectDetected()
{
    // get the radius and DC of the secret door.
    float fSearchDist = GetLocalFloat(OBJECT_SELF,sID_SEARCH_RADIUS);

    // what is the tag of this object used in setting the destination
    string sTag = GetTag(OBJECT_SELF);

    int nCount = 1;

    object oNearestCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
    while (oNearestCreature != OBJECT_INVALID)
    {
        if(GetIsPC(GetMaster(oNearestCreature)) || GetIsPC(oNearestCreature))
        {
            // what is the distance of the PC to the door location
            float fDist = GetDistanceBetween(OBJECT_SELF,oNearestCreature);
            if (fDist <= fSearchDist)
                if (LineOfSightObject(OBJECT_SELF, oNearestCreature) == TRUE)
					if (CheckIfDetected(oNearestCreature))
						return 1;
        }
		nCount++;
        oNearestCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF ,nCount);
    }
	return 0;
}

void main()
{
    int nAppeared = GetLocalInt(OBJECT_SELF, "SECRET_OBJECT_APPEARED");
    if(nAppeared == 1)
         return;
	if (WasObjectDetected())
		RevealObject();
}