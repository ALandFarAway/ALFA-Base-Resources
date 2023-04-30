/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_nondetection.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Nondetection. This sets an int on the PC that tells the Scrying scripts the
//  PC has nondetection active and is cloaked from scrying.
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
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCL = GetCasterLevel(OBJECT_SELF);
	float fDuration = nCL * 60.0 * 60.0;
	effect eIcon = EffectEffectIcon(52);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eIcon, oTarget, fDuration);
	int nDC = 15 + nCL;
	if(oCaster != oTarget) {
		nDC = 11 + nCL;
		}
	SetLocalInt(oTarget, "abr_sp_nondetect", nDC);
	SendMessageToPC(OBJECT_SELF, "You feel protections cloaking your mind from external discovery.");
	effect eSanctuary = EffectVisualEffect(VFX_DUR_SANCTUARY, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanctuary, oTarget, 5.0);
	DelayCommand(fDuration, SetLocalInt(OBJECT_SELF, "abr_sp_nondetect", 0));

		
	// Post-cast event.
	ACR_PostcastEvent();
	}				