// ga_heal_pc
/*
    This command heals the PC (and potentially their party)
        nHealPercent    = This is the % damage the PC will be healed, 0 = 100% by default
        bAllPartyMembers      = This is a boolean, by default it is FALSE and only the PC will be healed, 1 is full party including both PCs and NPCs
*/
// FAB 9/30
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nFullParty to bAllPartyMembers
//					   changed functionality so that if all party members is TRUE, script will heal all PCs and NPC's in party
//					   while if set to false heals only PC
// JSH-OEI 4/25/08 - Added a visual effect when the heal takes effect.

void main(int nHealPercent, int bAllPartyMembers)
{

/*
    object oPC = GetFirstPC();
    object oComp;
    int nCurrentHP;
    int nHP;
    int nCompNumber = 1;    // This is the companion number index
    effect eFX;

    if ( nHealPercent == 0 ) nHealPercent = 100;

    while( GetIsObjectValid(oPC) )
    {
        nCurrentHP = GetCurrentHitPoints( oPC );
        nHP = FloatToInt( IntToFloat(GetMaxHitPoints(oPC)) * IntToFloat(nHealPercent) / 100 ) - nCurrentHP;
        eFX = EffectHeal( nHP );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT,eFX,oPC );
        oPC = GetNextPC();
    }

    if ( bAllPartyMembers != 0 )
    {
        oPC = GetFirstPC();
        oComp = GetHenchman( oPC,1 );

        while( GetIsObjectValid(oComp) )
        {
            nCurrentHP = GetMaxHitPoints( oComp );
            nHP = FloatToInt( IntToFloat(nCurrentHP) * IntToFloat(nHealPercent) / 100 ) - nCurrentHP;
            eFX = EffectHeal( nHP );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT,eFX,oComp );
            nCompNumber++;
            oComp = GetHenchman( oPC,nCompNumber );
        }
    }
*/

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oComp;
	object oTarg;
    int nCurrentHP;
    int nHP;
    int nCompNumber = 1;    // This is the companion number index
    effect eFX;
	effect eVisual = EffectNWN2SpecialEffectFile("sp_cure_critical");

    if ( nHealPercent == 0 ) nHealPercent = 100;
	

	if ( bAllPartyMembers == 0 )
    {
        	nCurrentHP = GetCurrentHitPoints( oPC );
        	nHP = FloatToInt( IntToFloat(GetMaxHitPoints(oPC)) * IntToFloat(nHealPercent) / 100 ) - nCurrentHP;
        	eFX = EffectHeal( nHP );
        	ApplyEffectToObject( DURATION_TYPE_PERMANENT,eFX,oPC );
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
    }
	
	else
	{
		oComp = GetHenchman( oPC,1 );

        while( GetIsObjectValid(oComp) )
        {
            nCurrentHP = GetMaxHitPoints(oComp);
            nHP = FloatToInt(IntToFloat(nCurrentHP) * IntToFloat(nHealPercent) / 100) - nCurrentHP;
            eFX = EffectHeal(nHP);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oComp);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oComp);
            nCompNumber++;
            oComp = GetHenchman(oPC, nCompNumber);
        }
		
		oTarg = GetFirstFactionMember(oPC);
		
        while(GetIsObjectValid(oTarg))
        {
            nCurrentHP = GetCurrentHitPoints(oTarg);
       		nHP = FloatToInt(IntToFloat(GetMaxHitPoints(oTarg)) * IntToFloat(nHealPercent) / 100) - nCurrentHP;
        	eFX = EffectHeal(nHP);
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oTarg);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarg);
            oTarg = GetNextFactionMember(oPC);
        }
	}
}