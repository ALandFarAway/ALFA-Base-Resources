//::///////////////////////////////////////////////
//:: Visual effect to apply different textures
//:: to differentiate each dragon species
//:: Copyright (c) 2015 Thierry Petitjean (4760).
//:://////////////////////////////////////////////
/*

	---------------------
	- Black: nwn_blackdragon_vfx.sef
	- Blue: nwn_bluedragon_vfx.sef
	- Brass: nwn_brassdragon_vfx.sef
	- Bronze: nwn_bronzedragon_vfx.sef
	- Copper: nwn_copperdragon_vfx.sef
	- Forest (not in D&D rules): nwn_forestdragon_vfx.sef
	- Gold: nwn_golddragon_vfx.sef
	- Green: nwn_greendragon_vfx.sef
	- Lich: none, uses c_nwndragon_cl_body02
	- Mist (not in D&D rules): nwn_mistdragon_vfx.sef
	- Prismatic: nwn_prismdragon_vfx.sef
	- Red: nwn_redragon_vfx.sef
	- Shadow (not in D&D rules): nwn_shadowdragon_vfx.sef
	- Silver: nwn_silverdragon_vfx.sef
	- Swamp (not in D&D rules): none, uses its own model
	- White: nwn_whitedragon_vfx.sef
	
*/
//:://////////////////////////////////////////////
//:: Created By: Thierry Petitjean (4760)
//:: Created On: 15th March 2015
//:://////////////////////////////////////////////

string GetAppliedTexture(effect eVFX)
{
	string sRet = "";
	switch (GetEffectSpellId(eVFX))
	{
		case 3: //barkskin
			sRet = "sp_barkskin";
			break;
		case 74: //greater stoneskin
			sRet = "sp_stoneskin";
			break;
		case 172: //stoneskin
			sRet = "sp_stoneskin";
			break;
		case 342: //SHADES stoneskin
			sRet = "sp_stoneskin";
			break;
		case 860: //spiderskin
				sRet = "sp_spiderskin";
			break;
		case 885: //ironbody
				sRet = "sp_ironbody";
			break;
		default:			
	}
	return sRet;
}

void main()
{
	object oSelf = OBJECT_SELF;
	// do we need to reapply the original skin?
	string sFound = "nwn_" + GetLocalString(oSelf, "sColor") + "dragon_vfx";
	effect eCurrentVFX = GetFirstEffect(oSelf);
	while (GetEffectType(eCurrentVFX) != EFFECT_TYPE_INVALIDEFFECT)
	{
		if (GetEffectType(eCurrentVFX) == EFFECT_TYPE_VISUALEFFECT)
		{
			// found a visual effect, but does it change the textures?
			if (GetAppliedTexture(eCurrentVFX) != "") sFound = GetAppliedTexture(eCurrentVFX);
		}
		eCurrentVFX = GetNextEffect(oSelf);
	}
	// if the visual effect hasn't modified the texture, then reapply the original one
	effect eDragonVFX = EffectNWN2SpecialEffectFile(sFound, oSelf);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDragonVFX, oSelf);
	// continue with the default end of combat turn script
	ExecuteScript("nw_c2_default3", oSelf);
}