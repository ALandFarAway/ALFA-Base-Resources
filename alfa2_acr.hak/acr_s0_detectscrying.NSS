/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_detectscrying.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Detect Scrying. Sets an int on the PC that shows they have Detect Scrying
//	active for 24 hours. Looks for scrying sensors within range and reveals them
//	if found. Gives an opposed CL check against the caster of the scrying sensor
//	that can reveal information about the caster.

//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_spells_i"


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{		
	if (!ACR_PrecastEvent())
    {
        return;
    }

	SignalEvent( GetSpellTargetObject(), EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
	object oTarget = GetSpellTargetObject();
	//Set an int that marks the PC as actively detecting for scrying and remove it after expiration
	SetLocalInt(OBJECT_SELF, "abr_sp_detectScry", 1);
    float fDuration = 24 * 60.0 * 60.0;
	effect eIcon = EffectEffectIcon(54);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eIcon, oTarget, fDuration);
	DelayCommand(fDuration, SetLocalInt(OBJECT_SELF, "abr_sp_detectScry", 0));
    //Look for invisible sensors
	object oSensor = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	int nInc = 0;
	while((oSensor != OBJECT_INVALID) && (nInc < 50)) {
	if(FindSubString(GetTag(oSensor), "scry_send") != -1)
		{SendMessageToPC(OBJECT_SELF, "You see a small glowing orb floating in the air.");
		 object oScryer = GetLocalObject(oSensor, "oScryer");
		 object oScry = GetLocalObject(oScryer, "oScry");
		 object oScrySelf = GetLocalObject(oSensor, "oScrySelf");
		 object oScrySpeak = GetLocalObject(oSensor, "oScrySpeak");
		 if(oScrySelf != OBJECT_INVALID)
		 	{oScryer = oScrySelf;
			 }
		 object oScryerArea = GetArea(oScryer);
		 string sScryerArea = GetName(oScryerArea);
		 //Give an opposed caster level check against the scryer to learn who and where they are
		 int nCasterLevel = GetLocalInt(oSensor, "nCasterLevel");
		 int nCasterRoll = d20(1);
		 int nCasterOpposed = nCasterLevel + nCasterRoll;
		 int nDetectorLevel = GetCasterLevel(OBJECT_SELF);
		 int nDetectorRoll = d20(1);
		 int nDetectorOpposed = nDetectorLevel + nDetectorRoll;
		 if(nDetectorOpposed >= nCasterOpposed) {
		  	SendMessageToPC(OBJECT_SELF, "You feel your Detect Scrying spell best the defences of the caster of the scrying sensor.");
			SendMessageToPC(OBJECT_SELF, "You get a visual image of the scryer. They look like " + GetName(oScryer));
			SendMessageToPC(OBJECT_SELF, "You know that this person is located at the direction and distance of " + sScryerArea );
			}
		 else {SendMessageToPC(OBJECT_SELF, "You feel your Detect Scrying spell attempt to identify the person scrying you, but fail.");}
		 //Win or lose on the CL check, reveal the sensor
		 effect eEffect = GetFirstEffect(oSensor);
		 int nRep = 0;
		 while ((GetIsEffectValid(eEffect)) && (nRep < 10)) { 
			 RemoveEffect(oSensor, eEffect);
			 eEffect = GetNextEffect(oSensor);
			 nRep ++;
			}
		}
	oSensor = GetNextObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	nInc++;
	}
		
	// Post-cast event.
	ACR_PostcastEvent();
	}				