// ga_create_obj(string sObjectType, string sTemplate, string sLocationTag, int bUseAppearAnimation, string sNewTag, float fDelay)
/*
   Wrapper for CreateObject() with optional delay.

   Parameters:
     string sObjectType      = Object type. The following are allowed:
                               C - CREATURE
                               P - PLACEABLE
                               I - ITEM
                               W - WAYPOINT
                               S - STORE
							   V - VISUAL EFFECT
							   L - LIGHT
     string sTemplate        = Name of the template to create.
     string sLocationTag     = Tag of the waypoint at which to create the object.  Defaults to OBJECT_SELF
     int bUseAppearAnimation = If =1, object will use appear animation.
     string sNewTag          = Optional new tag for created object.
     float fDelay            = Delay, in seconds, before creating the object.
*/
// TDE 3/9/05
// ChazM 3/11/05
// BMA-OEI 1/11/06 removed default params
// EPF 7/10/07 - extending for light and placed effect
// ChazM 7/17/07 - Location now defaults to OBJECT_SELF

#include "ginc_param_const"
#include "ginc_actions"

void main(string sObjectType, string sTemplate, string sLocationTag, int bUseAppearAnimation, string sNewTag, float fDelay)
{
	object oLocation = GetObjectByTag(sLocationTag);
	if (!GetIsObjectValid(oLocation))
		oLocation = OBJECT_SELF;
    location lLocation = GetLocation(oLocation);
    int iObjType = GetObjectTypes(sObjectType);

    DelayCommand(fDelay, ActionCreateObject(iObjType, sTemplate, lLocation, bUseAppearAnimation, sNewTag));
}