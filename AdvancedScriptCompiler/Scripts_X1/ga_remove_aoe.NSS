// ga_remove_aoe
//
// destroy all AOEs in the current area

// EPF 7/11/07

void RemoveAOEs()
{
	int i = 1;
    object oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT,OBJECT_SELF,i);
    while(GetIsObjectValid(oAOE))
    {
        DestroyObject(oAOE, 0.2f);
        i++;
        oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT,OBJECT_SELF,i);
    }
}

void main()
{
	RemoveAOEs();
}