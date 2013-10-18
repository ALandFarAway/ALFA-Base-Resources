//============================================================================================
// ALFA Overland Map System
//============================================================================================
// This system is intended to work as a generic resource for DMs inside of ALFA to create
// overland map areas with minimal pressure placed upon the builders. The maps should be
// able to be persistently customized on the fly and should make efficient use of instanced
// areas.
//============================================================================================
// 7/4/2011 -- Inception, Zelknolf
//============================================================================================

#ifndef ACR_TRAVELMAP_I
#define ACR_TRAVELMAP_I

// This function is used to make a creature transition from a normal area into
// a travel map area.
void TransitionTravelMapIn(object oCreature);

// This function is used to make a creature transition from a travel map area
// to a normal area.
void TransitionTravelMapOut(object oCreature, int nEncounter=FALSE);

// This is a generic function to be applied to any character who is entering the travel map.
// oCreature is the creature being sent to the travel map.
void AddTravelMapEffects(object oCreature);

// This is a generic function that reverses the effects of AddTravelMapEffects.
void RemoveTravelMapEffects(object oCreature);

// This is a fledgling version of a function to restore functionality to items that have had properties
// stripped by effects such as a mythal, dead magic, or the overland map.
void RestoreItemProperties(object oItem);

// This function strips the properties of oItem to conform to the expectations
// of the travel map.
void TravelMap_RemoveItemProperties(object oItem);

// This function should be called from a travel map's area on enter event.
void TravelMap_OnAreaEnter();

// This function should be called from a travel map's area on exit event.
void TravelMap_AreaOnExit();

// This function shuold be called from the OnEnter event of any area transition
// which points toward the travel map or which exists on a travel map.
void TravelMap_TriggerOnEnter();

// This function fires on the Area of Effect that is attached to the party leader. It is designed to
// note who is approaching the party and handles interactions with other groups.
void TravelMap_AOEOnEnter();

// This function fires on the Area of Effect that is attached to the party leader. It pulls lagging party
// members up to the rest of the group.
void TravelMap_AOEOnExit();

// This function returns TRUE if an area is a travel map.
int TravelMap_IsTravelMapArea(object oArea);

void TravelMap_AreaOnEnter()
{
	AddTravelMapEffects(GetEnteringObject());
}

void TravelMap_AreaOnExit()
{
	RemoveTravelMapEffects(GetExitingObject());
}

void TravelMap_TriggerOnEnter()
{
	object oTarget = GetArea(GetTransitionTarget(OBJECT_SELF));
	object oCurrent = GetArea(OBJECT_SELF);
	if(oTarget == oCurrent) // Not actually an AT; just jump.
	{
		JumpPartyToArea(GetEnteringObject(), 
		                GetTransitionTarget(OBJECT_SELF));
		return;
	}
	else if(TravelMap_IsTravelMapArea(oTarget)  == 1 &&
	        TravelMap_IsTravelMapArea(oCurrent) == 1) // Travel map to travel map; just jump
	{
		JumpPartyToArea(GetEnteringObject(), 
		                GetTransitionTarget(OBJECT_SELF));
		return;	
	}
	else if(TravelMap_IsTravelMapArea(oTarget)  == 0 &&
			  TravelMap_IsTravelMapArea(oCurrent) == 1) // Leaving the travel map; cancel following.
	{
		object oLead = GetEnteringObject();	
		object oParty = GetFirstFactionMember(oLead);
		while(GetIsObjectValid(oParty))
		{
			AssignCommand(oParty, ClearAllActions(TRUE));
			oParty = GetNextFactionMember(oLead);
		}
		JumpPartyToArea(GetEnteringObject(), 
		                GetTransitionTarget(OBJECT_SELF));
		return;		
	}
	else if(TravelMap_IsTravelMapArea(oTarget)  == 1 &&
			  TravelMap_IsTravelMapArea(oCurrent) == 0)
	{	
		TransitionTravelMapIn(GetEnteringObject());
		return;
	}
	else
	{
		SendMessageToPC(GetEnteringObject(), "Error-- Travel map or travel map scripts configured incorrectly. Contact a DM with this error.");
		return;		
	}
}

void AddTravelMapEffects(object oCreature)
{
//=== Check if the character has any existing effects from the OLM and remove them ===//
//=== Also, clear out any effects that will prevent the OLM from functioning.      ===//
	effect eEffect = GetFirstEffect(oCreature);
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectType(eEffect)         == EFFECT_TYPE_VISUALEFFECT &&
		   GetEffectInteger(eEffect, 0)   == 100001 &&
		   GetEffectSubType(eEffect)      == SUBTYPE_SUPERNATURAL &&
		   GetEffectDurationType(eEffect) == DURATION_TYPE_PERMANENT)
		     RemoveEffect(oCreature, eEffect);
			 
		if(GetEffectType(eEffect)         == EFFECT_TYPE_IMMUNITY &&
		   GetEffectSubType(eEffect)      == IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE)
			 RemoveEffect(oCreature, eEffect); // this breaks the OLM very hard.
			 
		if(GetEffectType(eEffect)         == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ||
		   GetEffectType(eEffect)         == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
		     RemoveEffect(oCreature, eEffect); // this causes more minor breakage.
			 
		eEffect = GetNextEffect(oCreature);	
	}
	DeleteLocalInt(oCreature, "FOLLOW_NUMBER");
	
//=== Freedom of Movement is your enemy. Purge it. ===//
	int nSlot = 0;
	object oItem = GetItemInSlot(nSlot, oCreature);
	while(nSlot < 18)
	{
		if(GetIsObjectValid(oItem))
			TravelMap_RemoveItemProperties(oItem);
		nSlot++;
		oItem = GetItemInSlot(nSlot, oCreature);
	}
	
	
//=== Our seed is VFX Number 100,001. This is so we can find the effects later. ===//
	effect eOLM = SupernaturalEffect(EffectVisualEffect(100001));
	
//=== Calculate the existing scale of the creature. We want to multiply, not add, scales.===//
	float fScaleX = GetScale(oCreature, SCALE_X) * 0.10;
	float fScaleY = GetScale(oCreature, SCALE_Y) * 0.10;
	float fScaleZ = GetScale(oCreature, SCALE_Z) * 0.10;

	eOLM = EffectLinkEffects(SupernaturalEffect(EffectSetScale(fScaleX, fScaleY, fScaleZ)), eOLM);

//=== Speed is Significant. Try to make happy feet make less of a difference on the OLM ===//
	float fMove = 1.0f;
	if(GetHasFeat(1849, oCreature)) fMove += 0.10f; // Travel domain
	if(GetHasFeat(194,  oCreature)) fMove += 0.10f; // Barbarian
	if(GetHasFeat(200,  oCreature)) fMove += 0.10f; // woodland stride
	if(GetLevelByClass(CLASS_TYPE_MONK, oCreature)      >= 18) fMove += 0.50f;
	else if(GetLevelByClass(CLASS_TYPE_MONK, oCreature) >= 15) fMove += 0.45f;
	else if(GetLevelByClass(CLASS_TYPE_MONK, oCreature) >= 12) fMove += 0.40f;
	else if(GetLevelByClass(CLASS_TYPE_MONK, oCreature) >= 9)  fMove += 0.30f;
	else if(GetLevelByClass(CLASS_TYPE_MONK, oCreature) >= 6)  fMove += 0.20f;
	else if(GetLevelByClass(CLASS_TYPE_MONK, oCreature) >= 3)  fMove += 0.10f;
	float fMod = 1 - (0.10/fMove); // We want to increase this 0.10 when we add horses to the OLM.
	int nMod = FloatToInt(fMod * 100);
	
	eOLM = EffectLinkEffects(SupernaturalEffect(EffectMovementSpeedDecrease(nMod)), eOLM);
	
//=== Handle Following ===//
	object oLeader = GetFactionLeader(oCreature);
	if(oLeader != oCreature)
	{
		int nFollow = GetLocalInt(oLeader, "FOLLOW_NUMBER") + 1;
		SetLocalInt(oLeader, "FOLLOW_NUMBER", nFollow);
		ActionForceFollowObject(oLeader, 1.0f, nFollow);
		eOLM = EffectLinkEffects(SupernaturalEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)), eOLM);
	}
	else
	{
		eOLM = EffectLinkEffects(SupernaturalEffect(EffectAreaOfEffect(AOE_PER_INVIS_SPHERE, "acr_tmaoea", "****", "acr_tmaoec")), eOLM);
	}
	
//=== Applying the Effects. ===//
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eOLM, oCreature);	
}

void RemoveTravelMapEffects(object oCreature)
{
//=== Simple check; kill the VFX and get the linked effects with it ===//
	effect eEffect = GetFirstEffect(oCreature);
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectType(eEffect)         == EFFECT_TYPE_VISUALEFFECT &&
		   GetEffectInteger(eEffect, 0)   == 100001 &&
		   GetEffectSubType(eEffect)      == SUBTYPE_SUPERNATURAL &&
		   GetEffectDurationType(eEffect) == DURATION_TYPE_PERMANENT)
		     RemoveEffect(oCreature, eEffect);		 
		eEffect = GetNextEffect(oCreature);	
	}
//=== We broke some items. Fix them ===//
	int nSlot = 0;
	object oItem = GetItemInSlot(nSlot, oCreature);
	while(nSlot < 18)
	{
		if(GetIsObjectValid(oItem))
			RestoreItemProperties(oItem);
		nSlot++;
		oItem = GetItemInSlot(nSlot, oCreature);
	}	
	DeleteLocalInt(oCreature, "FOLLOW_NUMBER");
}

void TravelMap_RemoveItemProperties(object oItem)
{
	itemproperty ipProp = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ipProp))
	{
		if(GetItemPropertyType(ipProp) == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT)
		{			
			if(GetItemPropertyDurationType(ipProp) == DURATION_TYPE_PERMANENT)
			{
				SetLocalString(oItem, "IP_001", "075_000_000_000_000_000");
				//Type_Subtype_CostTable_CTValue_Param1_P1Value
				RemoveItemProperty(oItem, ipProp);
			}
			else
				RemoveItemProperty(oItem, ipProp);
		}
		ipProp = GetNextItemProperty(oItem);
	}
}

void RestoreItemProperties(object oItem)
{
	string sVar = "IP_001";
	int nCount = 1;
	string sProp = GetLocalString(oItem, sVar);
	while(sProp != "")
	{
		int nItemPropertyType = StringToInt(GetStringLeft(sProp, 3));
		sProp = GetStringRight(sProp, GetStringLength(sProp) - 4);
		int nItemPropertySubType = StringToInt(GetStringLeft(sProp, 3));
		sProp = GetStringRight(sProp, GetStringLength(sProp) - 4);
		int nItemPropertyCostTable = StringToInt(GetStringLeft(sProp, 3));
		sProp = GetStringRight(sProp, GetStringLength(sProp) - 4);
		int nItemPropertyCostTableValue = StringToInt(GetStringLeft(sProp, 3));
		sProp = GetStringRight(sProp, GetStringLength(sProp) - 4);
		int nItemPropertyParam1 = StringToInt(GetStringLeft(sProp, 3));
		sProp = GetStringRight(sProp, 3);
		int nItemPropertyParam1Value = StringToInt(sProp);
		
		//=== Freedom of Movement ===//
		if(nItemPropertyType == 75)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyFreeAction(), oItem);
		}
		
		nCount++;
		sVar = "IP_";
		if(nCount < 10)        sVar += "00"+IntToString(nCount);
		else if(nCount < 100)  sVar += "0"+IntToString(nCount);
		else if(nCount < 1000) sVar += IntToString(nCount);
		else SendMessageToPC(GetItemPossessor(oItem), "Error: Item Property array overflow on item "+GetName(oItem)+". Contact a DM to report this error.");
	}
}

void TransitionTravelMapIn(object oCreature)
{
	int bTrans = GetLocalInt(oCreature, "TRANS_IP");
	if(bTrans) // Transition is in progress. Return.
		return;

//=== Make sure that everyone is near enough to travel. === //				
	object oParty = GetFirstFactionMember(oCreature);	
	while(GetIsObjectValid(oParty))
	{
		if(GetDistanceBetween(oCreature, oParty) > 20.0f)
		{
			if(oParty == oCreature)
				FloatingTextStringOnCreature("You must gather your party to travel.", oCreature);
			return;
		}
		oParty = GetNextFactionMember(oCreature);
	}

//=== We're definitely traveling now. Get everyone ready. ===//
	FloatingTextStringOnCreature("You gather your party and prepare to travel.", oCreature);
	
//=== Bard song is the devil. Get rid of it. ===//
	oParty = GetFirstFactionMember(oCreature);
	while(GetIsObjectValid(oParty))
	{
		effect eCheck = GetFirstEffect(oParty);
	    while(GetIsEffectValid(eCheck))
	    {
	        if(GetEffectType(eCheck) == EFFECT_TYPE_BARDSONG_SINGING)
	        {
                 RemoveEffect(oParty, eCheck);
                 return;
	        }
	        eCheck = GetNextEffect(oParty);
	    }
		oParty = GetNextFactionMember(oCreature);
	}

//=== Ready the tracking for transitions already in progress ===//
	oParty = GetFirstFactionMember(oCreature);	
	while(GetIsObjectValid(oParty))
	{
		SetLocalInt(oParty, "TRANS_IP", 1);
		DelayCommand(7.0f, DeleteLocalInt(oParty, "TRANS_IP"));
		oParty = GetNextFactionMember(oCreature);
	}
	
//=== Jump the players into the area. ===//
	DelayCommand(6.5f, JumpPartyToArea(oCreature, GetTransitionTarget(OBJECT_SELF)));
}

int TravelMap_IsTravelMapArea(object oArea)
{
	return GetLocalInt(oArea, "ACR_IS_TRAVEL_AREA") != FALSE;
}

#endif