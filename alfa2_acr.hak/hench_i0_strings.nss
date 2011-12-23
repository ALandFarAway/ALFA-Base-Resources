/*

    Companion and Monster AI

    This file contains all strings shown to the PC. (Useful for
    multilanguage support and customization.)

*/


//	Weapons Equipping

//	"I don't know how to use this shield."
#define sHenchCantUseShield hench_i0_strings_get_sHenchCantUseShield()
string sHenchCantUseShield_cached;
string hench_i0_strings_get_sHenchCantUseShield()
{
	if (sHenchCantUseShield_cached == "")
		sHenchCantUseShield_cached = GetStringByStrRef(230391);
	return sHenchCantUseShield_cached;
}

//	"I can't use ranged weapons."
#define sHenchCantUseRanged hench_i0_strings_get_sHenchCantUseRanged()
string sHenchCantUseRanged_cached;
string hench_i0_strings_get_sHenchCantUseRanged()
{
	if (sHenchCantUseRanged_cached == "")
		sHenchCantUseRanged_cached = GetStringByStrRef(230392);
	return sHenchCantUseRanged_cached;
}

//	"I'm switching back to my missile weapon."
#define sHenchSwitchToMissle hench_i0_strings_get_sHenchSwitchToMissle()
string sHenchSwitchToMissle_cached;
string hench_i0_strings_get_sHenchSwitchToMissle()
{
	if (sHenchSwitchToMissle_cached == "")
		sHenchSwitchToMissle_cached = GetStringByStrRef(230393);
	return sHenchSwitchToMissle_cached;
}

//	"I'm switching to my melee weapon for now."
#define sHenchSwitchToRanged hench_i0_strings_get_sHenchSwitchToRanged()
string sHenchSwitchToRanged_cached;
string hench_i0_strings_get_sHenchSwitchToRanged()
{
	if (sHenchSwitchToRanged_cached == "")
		sHenchSwitchToRanged_cached = GetStringByStrRef(230394);
	return sHenchSwitchToRanged_cached;
}

//	"I'm stuck. Switching to my missile weapon."
#define sHenchSwitchToMissle1 hench_i0_strings_get_sHenchSwitchToMissle1()
string sHenchSwitchToMissle1_cached;
string hench_i0_strings_get_sHenchSwitchToMissle1()
{
	if (sHenchSwitchToMissle1_cached == "")
		sHenchSwitchToMissle1_cached = GetStringByStrRef(230395);
	return sHenchSwitchToMissle1_cached;
}

//	"I'm switching back to my melee weapon for now."
#define sHenchSwitchToRanged1 hench_i0_strings_get_sHenchSwitchToRanged1()
string sHenchSwitchToRanged1_cached;
string hench_i0_strings_get_sHenchSwitchToRanged1()
{
	if (sHenchSwitchToRanged1_cached == "")
		sHenchSwitchToRanged1_cached = GetStringByStrRef(230396);
	return sHenchSwitchToRanged1_cached;
}


//	Generic

//	"There's something interesting near that door."
#define sHenchSomethingFishy hench_i0_strings_get_sHenchSomethingFishy()
string sHenchSomethingFishy_cached;
string hench_i0_strings_get_sHenchSomethingFishy()
{
	if (sHenchSomethingFishy_cached == "")
		sHenchSomethingFishy_cached = GetStringByStrRef(230408);
	return sHenchSomethingFishy_cached;
}


//	Hen Shout

//	"**Peaceful Follow Mode Canceled**"
#define sHenchPeacefulModeCancel hench_i0_strings_get_sHenchPeacefulModeCancel()
string sHenchPeacefulModeCancel_cached;
string hench_i0_strings_get_sHenchPeacefulModeCancel()
{
	if (sHenchPeacefulModeCancel_cached == "")
		sHenchPeacefulModeCancel_cached = GetStringByStrRef(230409);
	return sHenchPeacefulModeCancel_cached;
}

//	"**Peaceful Follow Mode Enabled**"
//	 Was "I will follow but not attack our enemies until you tell me otherwise."
#define sHenchHenchmanFollow hench_i0_strings_get_sHenchHenchmanFollow()
string sHenchHenchmanFollow_cached;
string hench_i0_strings_get_sHenchHenchmanFollow()
{
	if (sHenchHenchmanFollow_cached == "")
		sHenchHenchmanFollow_cached = GetStringByStrRef(230410);
	return sHenchHenchmanFollow_cached;
}

//	"**Peaceful Follow Mode Enabled**"
//	Was "I will be happy to follow you, avoiding combat until you tell me otherwise!"
#define sHenchFamiliarFollow hench_i0_strings_get_sHenchFamiliarFollow()
string sHenchFamiliarFollow_cached;
string hench_i0_strings_get_sHenchFamiliarFollow()
{
	if (sHenchFamiliarFollow_cached == "")
		sHenchFamiliarFollow_cached = GetStringByStrRef(230410);
	return sHenchFamiliarFollow_cached;
}

//	" understands that it should follow, waiting for your command to attack.]"
#define sHenchAnCompFollow hench_i0_strings_get_sHenchAnCompFollow()
string sHenchAnCompFollow_cached;
string hench_i0_strings_get_sHenchAnCompFollow()
{
	if (sHenchAnCompFollow_cached == "")
		sHenchAnCompFollow_cached = GetStringByStrRef(230411);
	return sHenchAnCompFollow_cached;
}

//	"[The "
#define sHenchOtherFollow1 hench_i0_strings_get_sHenchOtherFollow1()
string sHenchOtherFollow1_cached;
string hench_i0_strings_get_sHenchOtherFollow1()
{
	if (sHenchOtherFollow1_cached == "")
		sHenchOtherFollow1_cached = GetStringByStrRef(230412);
	return sHenchOtherFollow1_cached;
}

//	" will now follow you, and be peaceful until told otherwise.]"
#define sHenchOtherFollow2 hench_i0_strings_get_sHenchOtherFollow2()
string sHenchOtherFollow2_cached;
string hench_i0_strings_get_sHenchOtherFollow2()
{
	if (sHenchOtherFollow2_cached == "")
		sHenchOtherFollow2_cached = GetStringByStrRef(230413);
	return sHenchOtherFollow2_cached;
}


//	Hench Heartbeat

//	"I'm not doing anything until these traps are cleared."
#define sHenchWaitTrapsCleared hench_i0_strings_get_sHenchWaitTrapsCleared()
string sHenchWaitTrapsCleared_cached;
string hench_i0_strings_get_sHenchWaitTrapsCleared()
{
	if (sHenchWaitTrapsCleared_cached == "")
		sHenchWaitTrapsCleared_cached = GetStringByStrRef(230414);
	return sHenchWaitTrapsCleared_cached;
}

//	"There is something important here you should look at."
#define sHenchSomethingImportant hench_i0_strings_get_sHenchSomethingImportant()
string sHenchSomethingImportant_cached;
string hench_i0_strings_get_sHenchSomethingImportant()
{
	if (sHenchSomethingImportant_cached == "")
		sHenchSomethingImportant_cached = GetStringByStrRef(230415);
	return sHenchSomethingImportant_cached;
}

//	"Look what I found."
#define sHenchFoundSomething hench_i0_strings_get_sHenchFoundSomething()
string sHenchFoundSomething_cached;
string hench_i0_strings_get_sHenchFoundSomething()
{
	if (sHenchFoundSomething_cached == "")
		sHenchFoundSomething_cached = GetStringByStrRef(230416);
	return sHenchFoundSomething_cached;
}

//	" Acquired Item: "
#define sHenchAcquiredItem hench_i0_strings_get_sHenchAcquiredItem()
string sHenchAcquiredItem_cached;
string hench_i0_strings_get_sHenchAcquiredItem()
{
	if (sHenchAcquiredItem_cached == "")
		sHenchAcquiredItem_cached = GetStringByStrRef(230417);
	return sHenchAcquiredItem_cached;
}

//	"My inventory is full."
#define sHenchInventoryFull hench_i0_strings_get_sHenchInventoryFull()
string sHenchInventoryFull_cached;
string hench_i0_strings_get_sHenchInventoryFull()
{
	if (sHenchInventoryFull_cached == "")
		sHenchInventoryFull_cached = GetStringByStrRef(230418);
	return sHenchInventoryFull_cached;
}


//	Main AI

//	"Sorry, I can't heal you."
#define sHenchCantHealMaster hench_i0_strings_get_sHenchCantHealMaster()
string sHenchCantHealMaster_cached;
string hench_i0_strings_get_sHenchCantHealMaster()
{
	if (sHenchCantHealMaster_cached == "")
		sHenchCantHealMaster_cached = GetStringByStrRef(230419);
	return sHenchCantHealMaster_cached;
}

//	"Should I heal you?"
#define sHenchAskHealMaster hench_i0_strings_get_sHenchAskHealMaster()
string sHenchAskHealMaster_cached;
string hench_i0_strings_get_sHenchAskHealMaster()
{
	if (sHenchAskHealMaster_cached == "")
		sHenchAskHealMaster_cached = GetStringByStrRef(230420);
	return sHenchAskHealMaster_cached;
}

//	"Should I attack?"
#define sHenchHenchmanAskAttack hench_i0_strings_get_sHenchHenchmanAskAttack()
string sHenchHenchmanAskAttack_cached;
string hench_i0_strings_get_sHenchHenchmanAskAttack()
{
	if (sHenchHenchmanAskAttack_cached == "")
		sHenchHenchmanAskAttack_cached = GetStringByStrRef(230421);
	return sHenchHenchmanAskAttack_cached;
}

//	"Let me know if I should attack."
#define sHenchFamiliarAskAttack hench_i0_strings_get_sHenchFamiliarAskAttack()
string sHenchFamiliarAskAttack_cached;
string hench_i0_strings_get_sHenchFamiliarAskAttack()
{
	if (sHenchFamiliarAskAttack_cached == "")
		sHenchFamiliarAskAttack_cached = GetStringByStrRef(230422);
	return sHenchFamiliarAskAttack_cached;
}

//	" is waiting for you to give the command to attack.]"
#define sHenchAnCompAskAttack hench_i0_strings_get_sHenchAnCompAskAttack()
string sHenchAnCompAskAttack_cached;
string hench_i0_strings_get_sHenchAnCompAskAttack()
{
	if (sHenchAnCompAskAttack_cached == "")
		sHenchAnCompAskAttack_cached = GetStringByStrRef(230423);
	return sHenchAnCompAskAttack_cached;
}

//	" patiently awaits your command to attack.]"
#define sHenchOtherAskAttack hench_i0_strings_get_sHenchOtherAskAttack()
string sHenchOtherAskAttack_cached;
string hench_i0_strings_get_sHenchOtherAskAttack()
{
	if (sHenchOtherAskAttack_cached == "")
		sHenchOtherAskAttack_cached = GetStringByStrRef(230424);
	return sHenchOtherAskAttack_cached;
}

//	"Don't make me laugh!"
#define sHenchWeakAttacker hench_i0_strings_get_sHenchWeakAttacker()
string sHenchWeakAttacker_cached;
string hench_i0_strings_get_sHenchWeakAttacker()
{
	if (sHenchWeakAttacker_cached == "")
		sHenchWeakAttacker_cached = GetStringByStrRef(230425);
	return sHenchWeakAttacker_cached;
}

//	"We'll best them yet!"
#define sHenchModAttacker hench_i0_strings_get_sHenchModAttacker()
string sHenchModAttacker_cached;
string hench_i0_strings_get_sHenchModAttacker()
{
	if (sHenchModAttacker_cached == "")
		sHenchModAttacker_cached = GetStringByStrRef(230426);
	return sHenchModAttacker_cached;
}

//	"Watch out for this one!"
#define sHenchStrongAttacker hench_i0_strings_get_sHenchStrongAttacker()
string sHenchStrongAttacker_cached;
string hench_i0_strings_get_sHenchStrongAttacker()
{
	if (sHenchStrongAttacker_cached == "")
		sHenchStrongAttacker_cached = GetStringByStrRef(230427);
	return sHenchStrongAttacker_cached;
}

//	"Gods help us!"
#define sHenchOverpoweringAttacker hench_i0_strings_get_sHenchOverpoweringAttacker()
string sHenchOverpoweringAttacker_cached;
string hench_i0_strings_get_sHenchOverpoweringAttacker()
{
	if (sHenchOverpoweringAttacker_cached == "")
		sHenchOverpoweringAttacker_cached = GetStringByStrRef(230428);
	return sHenchOverpoweringAttacker_cached;
}

//	"Time for me to get out of here!"
#define sHenchFamiliarFlee1 hench_i0_strings_get_sHenchFamiliarFlee1()
string sHenchFamiliarFlee1_cached;
string hench_i0_strings_get_sHenchFamiliarFlee1()
{
	if (sHenchFamiliarFlee1_cached == "")
		sHenchFamiliarFlee1_cached = GetStringByStrRef(230429);
	return sHenchFamiliarFlee1_cached;
}

//	"Eeeeek!"
#define sHenchFamiliarFlee2 hench_i0_strings_get_sHenchFamiliarFlee2()
string sHenchFamiliarFlee2_cached;
string hench_i0_strings_get_sHenchFamiliarFlee2()
{
	if (sHenchFamiliarFlee2_cached == "")
		sHenchFamiliarFlee2_cached = GetStringByStrRef(230430);
	return sHenchFamiliarFlee2_cached;
}

//	"Make way, make way!"
#define sHenchFamiliarFlee3 hench_i0_strings_get_sHenchFamiliarFlee3()
string sHenchFamiliarFlee3_cached;
string hench_i0_strings_get_sHenchFamiliarFlee3()
{
	if (sHenchFamiliarFlee3_cached == "")
		sHenchFamiliarFlee3_cached = GetStringByStrRef(230431);
	return sHenchFamiliarFlee3_cached;
}

//	"I'll be back!"
#define sHenchFamiliarFlee4 hench_i0_strings_get_sHenchFamiliarFlee4()
string sHenchFamiliarFlee4_cached;
string hench_i0_strings_get_sHenchFamiliarFlee4()
{
	if (sHenchFamiliarFlee4_cached == "")
		sHenchFamiliarFlee4_cached = GetStringByStrRef(230432);
	return sHenchFamiliarFlee4_cached;
}

//	":: Danger ::"
#define sHenchAniCompFlee hench_i0_strings_get_sHenchAniCompFlee()
string sHenchAniCompFlee_cached;
string hench_i0_strings_get_sHenchAniCompFlee()
{
	if (sHenchAniCompFlee_cached == "")
		sHenchAniCompFlee_cached = GetStringByStrRef(230433);
	return sHenchAniCompFlee_cached;
}

//	"Help! I can't heal myself!"
#define sHenchHealMe hench_i0_strings_get_sHenchHealMe()
string sHenchHealMe_cached;
string hench_i0_strings_get_sHenchHealMe()
{
	if (sHenchHealMe_cached == "")
		sHenchHealMe_cached = GetStringByStrRef(230434);
	return sHenchHealMe_cached;
}


// Hench Scout

//	"Please get out of my way."
#define sHenchGetOutofWay hench_i0_strings_get_sHenchGetOutofWay()
string sHenchGetOutofWay_cached;
string hench_i0_strings_get_sHenchGetOutofWay()
{
	if (sHenchGetOutofWay_cached == "")
		sHenchGetOutofWay_cached = GetStringByStrRef(230435);
	return sHenchGetOutofWay_cached;
}

//	"[Scouting can only be done by associates, not companions.]"
#define sHenchNoScoutCompanions hench_i0_strings_get_sHenchNoScoutCompanions()
string sHenchNoScoutCompanions_cached;
string hench_i0_strings_get_sHenchNoScoutCompanions()
{
	if (sHenchNoScoutCompanions_cached == "")
		sHenchNoScoutCompanions_cached = GetStringByStrRef(230436);
	return sHenchNoScoutCompanions_cached;
}

//	"This area looks safe enough."
#define sHenchSafeEnough hench_i0_strings_get_sHenchSafeEnough()
string sHenchSafeEnough_cached;
string hench_i0_strings_get_sHenchSafeEnough()
{
	if (sHenchSafeEnough_cached == "")
		sHenchSafeEnough_cached = GetStringByStrRef(230437);
	return sHenchSafeEnough_cached;
}


//	Hench Block

//	"Something is on the other side of this door."
#define sHenchMonsterOnOtherSide hench_i0_strings_get_sHenchMonsterOnOtherSide()
string sHenchMonsterOnOtherSide_cached;
string hench_i0_strings_get_sHenchMonsterOnOtherSide()
{
	if (sHenchMonsterOnOtherSide_cached == "")
		sHenchMonsterOnOtherSide_cached = GetStringByStrRef(230438);
	return sHenchMonsterOnOtherSide_cached;
}


//	Hench Fail

//	"I can't see "
#define sHenchCantSeeTarget hench_i0_strings_get_sHenchCantSeeTarget()
string sHenchCantSeeTarget_cached;
string hench_i0_strings_get_sHenchCantSeeTarget()
{
	if (sHenchCantSeeTarget_cached == "")
		sHenchCantSeeTarget_cached = GetStringByStrRef(230439);
	return sHenchCantSeeTarget_cached;
}

//	" is not a melee weapon."
#define sHenchNotAMeleeWeapon hench_i0_strings_get_sHenchNotAMeleeWeapon()
string sHenchNotAMeleeWeapon_cached;
string hench_i0_strings_get_sHenchNotAMeleeWeapon()
{
	if (sHenchNotAMeleeWeapon_cached == "")
		sHenchNotAMeleeWeapon_cached = GetStringByStrRef(230440);
	return sHenchNotAMeleeWeapon_cached;
}

//	" is not a ranged weapon."
#define sHenchNotARangedWeapon hench_i0_strings_get_sHenchNotARangedWeapon()
string sHenchNotARangedWeapon_cached;
string hench_i0_strings_get_sHenchNotARangedWeapon()
{
	if (sHenchNotARangedWeapon_cached == "")
		sHenchNotARangedWeapon_cached = GetStringByStrRef(230441);
	return sHenchNotARangedWeapon_cached;
}

//	" is not a shield."
#define sHenchNotAShield hench_i0_strings_get_sHenchNotAShield()
string sHenchNotAShield_cached;
string hench_i0_strings_get_sHenchNotAShield()
{
	if (sHenchNotAShield_cached == "")
		sHenchNotAShield_cached = GetStringByStrRef(230442);
	return sHenchNotAShield_cached;
}


//	Companion/Associate Behavior Options

//	"Automatic Weapon Switching"
#define sHenchEnableWeaonSwitch hench_i0_strings_get_sHenchEnableWeaonSwitch()
string sHenchEnableWeaonSwitch_cached;
string hench_i0_strings_get_sHenchEnableWeaonSwitch()
{
	if (sHenchEnableWeaonSwitch_cached == "")
		sHenchEnableWeaonSwitch_cached = GetStringByStrRef(232501);
	return sHenchEnableWeaonSwitch_cached;
}

//	"This character will automatically switch weapons during combat."
#define sHenchEnableWeaonSwitchOn hench_i0_strings_get_sHenchEnableWeaonSwitchOn()
string sHenchEnableWeaonSwitchOn_cached;
string hench_i0_strings_get_sHenchEnableWeaonSwitchOn()
{
	if (sHenchEnableWeaonSwitchOn_cached == "")
		sHenchEnableWeaonSwitchOn_cached = GetStringByStrRef(232502);
	return sHenchEnableWeaonSwitchOn_cached;
}

//	"This character will not automatically switch weapons during combat."
#define sHenchEnableWeaonSwitchOff hench_i0_strings_get_sHenchEnableWeaonSwitchOff()
string sHenchEnableWeaonSwitchOff_cached;
string hench_i0_strings_get_sHenchEnableWeaonSwitchOff()
{
	if (sHenchEnableWeaonSwitchOff_cached == "")
		sHenchEnableWeaonSwitchOff_cached = GetStringByStrRef(232503);
	return sHenchEnableWeaonSwitchOff_cached;
}

//	"This character will use ranged weapons during combat."
#define sHenchRangedWeaponsSwitchOn hench_i0_strings_get_sHenchRangedWeaponsSwitchOn()
string sHenchRangedWeaponsSwitchOn_cached;
string hench_i0_strings_get_sHenchRangedWeaponsSwitchOn()
{
	if (sHenchRangedWeaponsSwitchOn_cached == "")
		sHenchRangedWeaponsSwitchOn_cached = GetStringByStrRef(232504);
	return sHenchRangedWeaponsSwitchOn_cached;
}

//	"This character will not use ranged weapons during combat."
#define sHenchRangedWeaponsSwitchOff hench_i0_strings_get_sHenchRangedWeaponsSwitchOff()
string sHenchRangedWeaponsSwitchOff_cached;
string hench_i0_strings_get_sHenchRangedWeaponsSwitchOff()
{
	if (sHenchRangedWeaponsSwitchOff_cached == "")
		sHenchRangedWeaponsSwitchOff_cached = GetStringByStrRef(232505);
	return sHenchRangedWeaponsSwitchOff_cached;
}

//	"Switch To Melee Distance"
#define sHenchSwitchToMeleeDist hench_i0_strings_get_sHenchSwitchToMeleeDist()
string sHenchSwitchToMeleeDist_cached;
string hench_i0_strings_get_sHenchSwitchToMeleeDist()
{
	if (sHenchSwitchToMeleeDist_cached == "")
		sHenchSwitchToMeleeDist_cached = GetStringByStrRef(232506);
	return sHenchSwitchToMeleeDist_cached;
}

//	"This character will switch to melee weapons only when enemies are close."
#define sHenchSwitchToMeleeDistNear hench_i0_strings_get_sHenchSwitchToMeleeDistNear()
string sHenchSwitchToMeleeDistNear_cached;
string hench_i0_strings_get_sHenchSwitchToMeleeDistNear()
{
	if (sHenchSwitchToMeleeDistNear_cached == "")
		sHenchSwitchToMeleeDistNear_cached = GetStringByStrRef(232507);
	return sHenchSwitchToMeleeDistNear_cached;
}

//	 "This character will switch to melee weapons only when enemies are a medium distance away."
#define sHenchSwitchToMeleeDistMed hench_i0_strings_get_sHenchSwitchToMeleeDistMed()
string sHenchSwitchToMeleeDistMed_cached;
string hench_i0_strings_get_sHenchSwitchToMeleeDistMed()
{
	if (sHenchSwitchToMeleeDistMed_cached == "")
		sHenchSwitchToMeleeDistMed_cached = GetStringByStrRef(232508);
	return sHenchSwitchToMeleeDistMed_cached;
}

//	"This character will switch to melee weapons when enemies are fairly far away." 
#define sHenchSwitchToMeleeDistFar hench_i0_strings_get_sHenchSwitchToMeleeDistFar()
string sHenchSwitchToMeleeDistFar_cached;
string hench_i0_strings_get_sHenchSwitchToMeleeDistFar()
{
	if (sHenchSwitchToMeleeDistFar_cached == "")
		sHenchSwitchToMeleeDistFar_cached = GetStringByStrRef(232509);
	return sHenchSwitchToMeleeDistFar_cached;
}

//	"Back Away"
#define sHenchEnableBackAway hench_i0_strings_get_sHenchEnableBackAway()
string sHenchEnableBackAway_cached;
string hench_i0_strings_get_sHenchEnableBackAway()
{
	if (sHenchEnableBackAway_cached == "")
		sHenchEnableBackAway_cached = GetStringByStrRef(232510);
	return sHenchEnableBackAway_cached;
}

//	"This character will avoid melee combat by moving away from enemies." 
#define sHenchEnableBackAwayOn hench_i0_strings_get_sHenchEnableBackAwayOn()
string sHenchEnableBackAwayOn_cached;
string hench_i0_strings_get_sHenchEnableBackAwayOn()
{
	if (sHenchEnableBackAwayOn_cached == "")
		sHenchEnableBackAwayOn_cached = GetStringByStrRef(232511);
	return sHenchEnableBackAwayOn_cached;
}

//	"This character will not avoid melee combat by moving away from enemies."
#define sHenchEnableBackAwayOff hench_i0_strings_get_sHenchEnableBackAwayOff()
string sHenchEnableBackAwayOff_cached;
string hench_i0_strings_get_sHenchEnableBackAwayOff()
{
	if (sHenchEnableBackAwayOff_cached == "")
		sHenchEnableBackAwayOff_cached = GetStringByStrRef(232512);
	return sHenchEnableBackAwayOff_cached;
}

//	"Summoning"
#define sHenchEnableSummons hench_i0_strings_get_sHenchEnableSummons()
string sHenchEnableSummons_cached;
string hench_i0_strings_get_sHenchEnableSummons()
{
	if (sHenchEnableSummons_cached == "")
		sHenchEnableSummons_cached = GetStringByStrRef(232513);
	return sHenchEnableSummons_cached;
}

//	"This character will summon creatures during combat."	  
#define sHenchEnableSummonsOn hench_i0_strings_get_sHenchEnableSummonsOn()
string sHenchEnableSummonsOn_cached;
string hench_i0_strings_get_sHenchEnableSummonsOn()
{
	if (sHenchEnableSummonsOn_cached == "")
		sHenchEnableSummonsOn_cached = GetStringByStrRef(232514);
	return sHenchEnableSummonsOn_cached;
}

//	"This character will not summon creatures during combat."
#define sHenchEnableSummonsOff hench_i0_strings_get_sHenchEnableSummonsOff()
string sHenchEnableSummonsOff_cached;
string hench_i0_strings_get_sHenchEnableSummonsOff()
{
	if (sHenchEnableSummonsOff_cached == "")
		sHenchEnableSummonsOff_cached = GetStringByStrRef(232515);
	return sHenchEnableSummonsOff_cached;
}

//	"Dual Wielding"
#define sHenchDualWielding hench_i0_strings_get_sHenchDualWielding()
string sHenchDualWielding_cached;
string hench_i0_strings_get_sHenchDualWielding()
{
	if (sHenchDualWielding_cached == "")
		sHenchDualWielding_cached = GetStringByStrRef(232516);
	return sHenchDualWielding_cached;
}

//	"This character will dual wield melee weapons."
#define sHenchDualWieldingOn hench_i0_strings_get_sHenchDualWieldingOn()
string sHenchDualWieldingOn_cached;
string hench_i0_strings_get_sHenchDualWieldingOn()
{
	if (sHenchDualWieldingOn_cached == "")
		sHenchDualWieldingOn_cached = GetStringByStrRef(232517);
	return sHenchDualWieldingOn_cached;
}

//	"This character will not dual wield melee weapons."	 
#define sHenchDualWieldingOff hench_i0_strings_get_sHenchDualWieldingOff()
string sHenchDualWieldingOff_cached;
string hench_i0_strings_get_sHenchDualWieldingOff()
{
	if (sHenchDualWieldingOff_cached == "")
		sHenchDualWieldingOff_cached = GetStringByStrRef(232518);
	return sHenchDualWieldingOff_cached;
}

//	"This character will use the default behavior for dual wielding melee weapons."	
#define sHenchDualWieldingDefault hench_i0_strings_get_sHenchDualWieldingDefault()
string sHenchDualWieldingDefault_cached;
string hench_i0_strings_get_sHenchDualWieldingDefault()
{
	if (sHenchDualWieldingDefault_cached == "")
		sHenchDualWieldingDefault_cached = GetStringByStrRef(232519);
	return sHenchDualWieldingDefault_cached;
}

//	"Heavy Off Hand Weapons"
#define sHenchEnableHeavyOffHand hench_i0_strings_get_sHenchEnableHeavyOffHand()
string sHenchEnableHeavyOffHand_cached;
string hench_i0_strings_get_sHenchEnableHeavyOffHand()
{
	if (sHenchEnableHeavyOffHand_cached == "")
		sHenchEnableHeavyOffHand_cached = GetStringByStrRef(232520);
	return sHenchEnableHeavyOffHand_cached;
}

//	 "This character will use heavy off hand weapons."
#define sHenchEnableHeavyOffHandOn hench_i0_strings_get_sHenchEnableHeavyOffHandOn()
string sHenchEnableHeavyOffHandOn_cached;
string hench_i0_strings_get_sHenchEnableHeavyOffHandOn()
{
	if (sHenchEnableHeavyOffHandOn_cached == "")
		sHenchEnableHeavyOffHandOn_cached = GetStringByStrRef(232521);
	return sHenchEnableHeavyOffHandOn_cached;
}

//	 "This character will not use heavy off hand weapons."
#define sHenchEnableHeavyOffHandOff hench_i0_strings_get_sHenchEnableHeavyOffHandOff()
string sHenchEnableHeavyOffHandOff_cached;
string hench_i0_strings_get_sHenchEnableHeavyOffHandOff()
{
	if (sHenchEnableHeavyOffHandOff_cached == "")
		sHenchEnableHeavyOffHandOff_cached = GetStringByStrRef(232522);
	return sHenchEnableHeavyOffHandOff_cached;
}

//	"Use Shields"	
#define sHenchEnableShieldUse hench_i0_strings_get_sHenchEnableShieldUse()
string sHenchEnableShieldUse_cached;
string hench_i0_strings_get_sHenchEnableShieldUse()
{
	if (sHenchEnableShieldUse_cached == "")
		sHenchEnableShieldUse_cached = GetStringByStrRef(232523);
	return sHenchEnableShieldUse_cached;
}

//	 "This character will use shields."
#define sHenchEnableShieldUseOn hench_i0_strings_get_sHenchEnableShieldUseOn()
string sHenchEnableShieldUseOn_cached;
string hench_i0_strings_get_sHenchEnableShieldUseOn()
{
	if (sHenchEnableShieldUseOn_cached == "")
		sHenchEnableShieldUseOn_cached = GetStringByStrRef(232524);
	return sHenchEnableShieldUseOn_cached;
}

//	 "This character will not use shields."
#define sHenchEnableShieldUseOff hench_i0_strings_get_sHenchEnableShieldUseOff()
string sHenchEnableShieldUseOff_cached;
string hench_i0_strings_get_sHenchEnableShieldUseOff()
{
	if (sHenchEnableShieldUseOff_cached == "")
		sHenchEnableShieldUseOff_cached = GetStringByStrRef(232525);
	return sHenchEnableShieldUseOff_cached;
}

//	"Recover Traps"
#define sHenchEnableRecoverTraps hench_i0_strings_get_sHenchEnableRecoverTraps()
string sHenchEnableRecoverTraps_cached;
string hench_i0_strings_get_sHenchEnableRecoverTraps()
{
	if (sHenchEnableRecoverTraps_cached == "")
		sHenchEnableRecoverTraps_cached = GetStringByStrRef(232526);
	return sHenchEnableRecoverTraps_cached;
}

//	 "This character will recover all traps. Only works with disarm traps turned on."
#define sHenchEnableRecoverTrapsOn hench_i0_strings_get_sHenchEnableRecoverTrapsOn()
string sHenchEnableRecoverTrapsOn_cached;
string hench_i0_strings_get_sHenchEnableRecoverTrapsOn()
{
	if (sHenchEnableRecoverTrapsOn_cached == "")
		sHenchEnableRecoverTrapsOn_cached = GetStringByStrRef(232527);
	return sHenchEnableRecoverTrapsOn_cached;
}

//	 "This character will recover traps when the risk of failure isn't great. Only works with disarm traps turned on."
#define sHenchEnableRecoverTrapsOnSafe hench_i0_strings_get_sHenchEnableRecoverTrapsOnSafe()
string sHenchEnableRecoverTrapsOnSafe_cached;
string hench_i0_strings_get_sHenchEnableRecoverTrapsOnSafe()
{
	if (sHenchEnableRecoverTrapsOnSafe_cached == "")
		sHenchEnableRecoverTrapsOnSafe_cached = GetStringByStrRef(232528);
	return sHenchEnableRecoverTrapsOnSafe_cached;
}

//	 "This character will not recover traps."
#define sHenchEnableRecoverTrapsOff hench_i0_strings_get_sHenchEnableRecoverTrapsOff()
string sHenchEnableRecoverTrapsOff_cached;
string hench_i0_strings_get_sHenchEnableRecoverTrapsOff()
{
	if (sHenchEnableRecoverTrapsOff_cached == "")
		sHenchEnableRecoverTrapsOff_cached = GetStringByStrRef(232529);
	return sHenchEnableRecoverTrapsOff_cached;
}

//	"Automatically Open Locks"
#define sHenchEnableAutoOpenLocks hench_i0_strings_get_sHenchEnableAutoOpenLocks()
string sHenchEnableAutoOpenLocks_cached;
string hench_i0_strings_get_sHenchEnableAutoOpenLocks()
{
	if (sHenchEnableAutoOpenLocks_cached == "")
		sHenchEnableAutoOpenLocks_cached = GetStringByStrRef(232530);
	return sHenchEnableAutoOpenLocks_cached;
}

//	"This character will automatically open nearby locks."	 
#define sHenchEnableAutoOpenLocksOn hench_i0_strings_get_sHenchEnableAutoOpenLocksOn()
string sHenchEnableAutoOpenLocksOn_cached;
string hench_i0_strings_get_sHenchEnableAutoOpenLocksOn()
{
	if (sHenchEnableAutoOpenLocksOn_cached == "")
		sHenchEnableAutoOpenLocksOn_cached = GetStringByStrRef(232531);
	return sHenchEnableAutoOpenLocksOn_cached;
}

//	 "This character will not automatically open locks."
#define sHenchEnableAutoOpenLocksOff hench_i0_strings_get_sHenchEnableAutoOpenLocksOff()
string sHenchEnableAutoOpenLocksOff_cached;
string hench_i0_strings_get_sHenchEnableAutoOpenLocksOff()
{
	if (sHenchEnableAutoOpenLocksOff_cached == "")
		sHenchEnableAutoOpenLocksOff_cached = GetStringByStrRef(232532);
	return sHenchEnableAutoOpenLocksOff_cached;
}

//	"Automatically Pick Up Items"
#define sHenchEnableAutoPickup hench_i0_strings_get_sHenchEnableAutoPickup()
string sHenchEnableAutoPickup_cached;
string hench_i0_strings_get_sHenchEnableAutoPickup()
{
	if (sHenchEnableAutoPickup_cached == "")
		sHenchEnableAutoPickup_cached = GetStringByStrRef(232533);
	return sHenchEnableAutoPickup_cached;
}

//	"This character will automatically pick up nearby items."
#define sHenchEnableAutoPickupOn hench_i0_strings_get_sHenchEnableAutoPickupOn()
string sHenchEnableAutoPickupOn_cached;
string hench_i0_strings_get_sHenchEnableAutoPickupOn()
{
	if (sHenchEnableAutoPickupOn_cached == "")
		sHenchEnableAutoPickupOn_cached = GetStringByStrRef(232534);
	return sHenchEnableAutoPickupOn_cached;
}

//	"This character will not automatically pick up items."
#define sHenchEnableAutoPickupOff hench_i0_strings_get_sHenchEnableAutoPickupOff()
string sHenchEnableAutoPickupOff_cached;
string hench_i0_strings_get_sHenchEnableAutoPickupOff()
{
	if (sHenchEnableAutoPickupOff_cached == "")
		sHenchEnableAutoPickupOff_cached = GetStringByStrRef(232535);
	return sHenchEnableAutoPickupOff_cached;
}

//	"Polymorph"	
#define sHenchEnablePolymorph hench_i0_strings_get_sHenchEnablePolymorph()
string sHenchEnablePolymorph_cached;
string hench_i0_strings_get_sHenchEnablePolymorph()
{
	if (sHenchEnablePolymorph_cached == "")
		sHenchEnablePolymorph_cached = GetStringByStrRef(232536);
	return sHenchEnablePolymorph_cached;
}

//	"This character will polymorph during combat. This also includes similar spells like stone and iron body."	 
#define sHenchEnablePolymorphOn hench_i0_strings_get_sHenchEnablePolymorphOn()
string sHenchEnablePolymorphOn_cached;
string hench_i0_strings_get_sHenchEnablePolymorphOn()
{
	if (sHenchEnablePolymorphOn_cached == "")
		sHenchEnablePolymorphOn_cached = GetStringByStrRef(232537);
	return sHenchEnablePolymorphOn_cached;
}

//	"This character will not polymorph during combat. This also includes similar spells like stone and iron body." 
#define sHenchEnablePolymorphOff hench_i0_strings_get_sHenchEnablePolymorphOff()
string sHenchEnablePolymorphOff_cached;
string hench_i0_strings_get_sHenchEnablePolymorphOff()
{
	if (sHenchEnablePolymorphOff_cached == "")
		sHenchEnablePolymorphOff_cached = GetStringByStrRef(232538);
	return sHenchEnablePolymorphOff_cached;
}

//	"Infinite Buffs"
#define sHenchEnableInfiniteBuff hench_i0_strings_get_sHenchEnableInfiniteBuff()
string sHenchEnableInfiniteBuff_cached;
string hench_i0_strings_get_sHenchEnableInfiniteBuff()
{
	if (sHenchEnableInfiniteBuff_cached == "")
		sHenchEnableInfiniteBuff_cached = GetStringByStrRef(232539);
	return sHenchEnableInfiniteBuff_cached;
}

//	"This character will use unlimited spells to buff while not in combat. Only works with warlocks and bard inspirations. This option is turned off automatically if no buffs can be done."
#define sHenchEnableInfiniteBuffOn hench_i0_strings_get_sHenchEnableInfiniteBuffOn()
string sHenchEnableInfiniteBuffOn_cached;
string hench_i0_strings_get_sHenchEnableInfiniteBuffOn()
{
	if (sHenchEnableInfiniteBuffOn_cached == "")
		sHenchEnableInfiniteBuffOn_cached = GetStringByStrRef(232540);
	return sHenchEnableInfiniteBuffOn_cached;
}

//	 "This character will not use unlimited spells to buff while not in combat."
#define sHenchEnableInfiniteBuffOff hench_i0_strings_get_sHenchEnableInfiniteBuffOff()
string sHenchEnableInfiniteBuffOff_cached;
string hench_i0_strings_get_sHenchEnableInfiniteBuffOff()
{
	if (sHenchEnableInfiniteBuffOff_cached == "")
		sHenchEnableInfiniteBuffOff_cached = GetStringByStrRef(232541);
	return sHenchEnableInfiniteBuffOff_cached;
}

//	"Use Healing and Curing Items"
#define sHenchEnableHealingItemUseBuff hench_i0_strings_get_sHenchEnableHealingItemUseBuff()
string sHenchEnableHealingItemUseBuff_cached;
string hench_i0_strings_get_sHenchEnableHealingItemUseBuff()
{
	if (sHenchEnableHealingItemUseBuff_cached == "")
		sHenchEnableHealingItemUseBuff_cached = GetStringByStrRef(232542);
	return sHenchEnableHealingItemUseBuff_cached;
}

//	"This character will use healing and curing items. This setting overrides the item usage setting." 
#define sHenchEnableHealingItemUseOn hench_i0_strings_get_sHenchEnableHealingItemUseOn()
string sHenchEnableHealingItemUseOn_cached;
string hench_i0_strings_get_sHenchEnableHealingItemUseOn()
{
	if (sHenchEnableHealingItemUseOn_cached == "")
		sHenchEnableHealingItemUseOn_cached = GetStringByStrRef(232543);
	return sHenchEnableHealingItemUseOn_cached;
}

//	"This character will use the item usage setting for healing and curing items."; 
#define sHenchEnableHealingItemUseOff hench_i0_strings_get_sHenchEnableHealingItemUseOff()
string sHenchEnableHealingItemUseOff_cached;
string hench_i0_strings_get_sHenchEnableHealingItemUseOff()
{
	if (sHenchEnableHealingItemUseOff_cached == "")
		sHenchEnableHealingItemUseOff_cached = GetStringByStrRef(232544);
	return sHenchEnableHealingItemUseOff_cached;
}

//	"Automatic Hiding"	
#define sHenchEnableAutoHide hench_i0_strings_get_sHenchEnableAutoHide()
string sHenchEnableAutoHide_cached;
string hench_i0_strings_get_sHenchEnableAutoHide()
{
	if (sHenchEnableAutoHide_cached == "")
		sHenchEnableAutoHide_cached = GetStringByStrRef(232545);
	return sHenchEnableAutoHide_cached;
}

//	"This character will hide during combat."	 
#define sHenchEnableAutoHideOn hench_i0_strings_get_sHenchEnableAutoHideOn()
string sHenchEnableAutoHideOn_cached;
string hench_i0_strings_get_sHenchEnableAutoHideOn()
{
	if (sHenchEnableAutoHideOn_cached == "")
		sHenchEnableAutoHideOn_cached = GetStringByStrRef(232546);
	return sHenchEnableAutoHideOn_cached;
}

//	"This character will not hide during combat."	 
#define sHenchEnableAutoHideOff hench_i0_strings_get_sHenchEnableAutoHideOff()
string sHenchEnableAutoHideOff_cached;
string hench_i0_strings_get_sHenchEnableAutoHideOff()
{
	if (sHenchEnableAutoHideOff_cached == "")
		sHenchEnableAutoHideOff_cached = GetStringByStrRef(232547);
	return sHenchEnableAutoHideOff_cached;
}

//	"Guard Distance"	
#define sHenchGuardDist hench_i0_strings_get_sHenchGuardDist()
string sHenchGuardDist_cached;
string hench_i0_strings_get_sHenchGuardDist()
{
	if (sHenchGuardDist_cached == "")
		sHenchGuardDist_cached = GetStringByStrRef(232548);
	return sHenchGuardDist_cached;
}

//	"This character will attack only when enemies are close." 
#define sHenchGuardDistNear hench_i0_strings_get_sHenchGuardDistNear()
string sHenchGuardDistNear_cached;
string hench_i0_strings_get_sHenchGuardDistNear()
{
	if (sHenchGuardDistNear_cached == "")
		sHenchGuardDistNear_cached = GetStringByStrRef(232549);
	return sHenchGuardDistNear_cached;
}

//	 "This character will attack only when enemies are a medium distance away."
#define sHenchGuardDistMed hench_i0_strings_get_sHenchGuardDistMed()
string sHenchGuardDistMed_cached;
string hench_i0_strings_get_sHenchGuardDistMed()
{
	if (sHenchGuardDistMed_cached == "")
		sHenchGuardDistMed_cached = GetStringByStrRef(232550);
	return sHenchGuardDistMed_cached;
}

//	 "This character will attack when enemies are fairly far away."
#define sHenchGuardDistFar hench_i0_strings_get_sHenchGuardDistFar()
string sHenchGuardDistFar_cached;
string hench_i0_strings_get_sHenchGuardDistFar()
{
	if (sHenchGuardDistFar_cached == "")
		sHenchGuardDistFar_cached = GetStringByStrRef(232551);
	return sHenchGuardDistFar_cached;
}

//	 "This character will attack based on ranged weapon use."
#define sHenchGuardDistDefault hench_i0_strings_get_sHenchGuardDistDefault()
string sHenchGuardDistDefault_cached;
string hench_i0_strings_get_sHenchGuardDistDefault()
{
	if (sHenchGuardDistDefault_cached == "")
		sHenchGuardDistDefault_cached = GetStringByStrRef(232552);
	return sHenchGuardDistDefault_cached;
}

//	"Following "
#define sHenchFollowing hench_i0_strings_get_sHenchFollowing()
string sHenchFollowing_cached;
string hench_i0_strings_get_sHenchFollowing()
{
	if (sHenchFollowing_cached == "")
		sHenchFollowing_cached = GetStringByStrRef(232555);
	return sHenchFollowing_cached;
}

//	" player controlled character (Default)"	 
#define sHenchPCC hench_i0_strings_get_sHenchPCC()
string sHenchPCC_cached;
string hench_i0_strings_get_sHenchPCC()
{
	if (sHenchPCC_cached == "")
		sHenchPCC_cached = GetStringByStrRef(232556);
	return sHenchPCC_cached;
}

//	" master (Default)"	 
#define sHenchMaster hench_i0_strings_get_sHenchMaster()
string sHenchMaster_cached;
string hench_i0_strings_get_sHenchMaster()
{
	if (sHenchMaster_cached == "")
		sHenchMaster_cached = GetStringByStrRef(232557);
	return sHenchMaster_cached;
}

//	" no one";	  
#define sHenchNoOne hench_i0_strings_get_sHenchNoOne()
string sHenchNoOne_cached;
string hench_i0_strings_get_sHenchNoOne()
{
	if (sHenchNoOne_cached == "")
		sHenchNoOne_cached = GetStringByStrRef(232558);
	return sHenchNoOne_cached;
}

//	"Defending "	 
#define sHenchDefending hench_i0_strings_get_sHenchDefending()
string sHenchDefending_cached;
string hench_i0_strings_get_sHenchDefending()
{
	if (sHenchDefending_cached == "")
		sHenchDefending_cached = GetStringByStrRef(232559);
	return sHenchDefending_cached;
}

//	"Disable Melee Attacks"
#define sHenchDisableMeleeAttacks hench_i0_strings_get_sHenchDisableMeleeAttacks()
string sHenchDisableMeleeAttacks_cached;
string hench_i0_strings_get_sHenchDisableMeleeAttacks()
{
	if (sHenchDisableMeleeAttacks_cached == "")
		sHenchDisableMeleeAttacks_cached = GetStringByStrRef(232560);
	return sHenchDisableMeleeAttacks_cached;
}

//	"This character will not use melee attacks. Only spells and ranged weapons are used."	 
#define sHenchDisableMeleeAttacksOn hench_i0_strings_get_sHenchDisableMeleeAttacksOn()
string sHenchDisableMeleeAttacksOn_cached;
string hench_i0_strings_get_sHenchDisableMeleeAttacksOn()
{
	if (sHenchDisableMeleeAttacksOn_cached == "")
		sHenchDisableMeleeAttacksOn_cached = GetStringByStrRef(232561);
	return sHenchDisableMeleeAttacksOn_cached;
}

//	"This character will use melee attacks." 
#define sHenchDisableMeleeAttacksOff hench_i0_strings_get_sHenchDisableMeleeAttacksOff()
string sHenchDisableMeleeAttacksOff_cached;
string hench_i0_strings_get_sHenchDisableMeleeAttacksOff()
{
	if (sHenchDisableMeleeAttacksOff_cached == "")
		sHenchDisableMeleeAttacksOff_cached = GetStringByStrRef(232562);
	return sHenchDisableMeleeAttacksOff_cached;
}

//	"Melee Attack for Party"
#define sHenchEnableMeleeAttacksAny hench_i0_strings_get_sHenchEnableMeleeAttacksAny()
string sHenchEnableMeleeAttacksAny_cached;
string hench_i0_strings_get_sHenchEnableMeleeAttacksAny()
{
	if (sHenchEnableMeleeAttacksAny_cached == "")
		sHenchEnableMeleeAttacksAny_cached = GetStringByStrRef(232563);
	return sHenchEnableMeleeAttacksAny_cached;
}

//	"This character will go into melee attack if any member of the party is in melee attack."
#define sHenchEnableMeleeAttacksAnyOn hench_i0_strings_get_sHenchEnableMeleeAttacksAnyOn()
string sHenchEnableMeleeAttacksAnyOn_cached;
string hench_i0_strings_get_sHenchEnableMeleeAttacksAnyOn()
{
	if (sHenchEnableMeleeAttacksAnyOn_cached == "")
		sHenchEnableMeleeAttacksAnyOn_cached = GetStringByStrRef(232564);
	return sHenchEnableMeleeAttacksAnyOn_cached;
}

//	"This character will use standard melee attack distances."	 
#define sHenchEnableMeleeAttacksAnyOff hench_i0_strings_get_sHenchEnableMeleeAttacksAnyOff()
string sHenchEnableMeleeAttacksAnyOff_cached;
string hench_i0_strings_get_sHenchEnableMeleeAttacksAnyOff()
{
	if (sHenchEnableMeleeAttacksAnyOff_cached == "")
		sHenchEnableMeleeAttacksAnyOff_cached = GetStringByStrRef(232565);
	return sHenchEnableMeleeAttacksAnyOff_cached;
}


//	Party Options

//	"Unequip Weapons After Combat (Party)"
#define sHenchUnequipWeapons hench_i0_strings_get_sHenchUnequipWeapons()
string sHenchUnequipWeapons_cached;
string hench_i0_strings_get_sHenchUnequipWeapons()
{
	if (sHenchUnequipWeapons_cached == "")
		sHenchUnequipWeapons_cached = GetStringByStrRef(232566);
	return sHenchUnequipWeapons_cached;
}

//	"Party members will unequip weapons after of combat."	 
#define sHenchUnequipWeaponsOn hench_i0_strings_get_sHenchUnequipWeaponsOn()
string sHenchUnequipWeaponsOn_cached;
string hench_i0_strings_get_sHenchUnequipWeaponsOn()
{
	if (sHenchUnequipWeaponsOn_cached == "")
		sHenchUnequipWeaponsOn_cached = GetStringByStrRef(232567);
	return sHenchUnequipWeaponsOn_cached;
}

//	"Party members will leave weapons equipped after combat."	 
#define sHenchUnequipWeaponsOff hench_i0_strings_get_sHenchUnequipWeaponsOff()
string sHenchUnequipWeaponsOff_cached;
string hench_i0_strings_get_sHenchUnequipWeaponsOff()
{
	if (sHenchUnequipWeaponsOff_cached == "")
		sHenchUnequipWeaponsOff_cached = GetStringByStrRef(232568);
	return sHenchUnequipWeaponsOff_cached;
}

//	"Auto Summon Familiars (Party)"
#define sHenchSummonFamiliars hench_i0_strings_get_sHenchSummonFamiliars()
string sHenchSummonFamiliars_cached;
string hench_i0_strings_get_sHenchSummonFamiliars()
{
	if (sHenchSummonFamiliars_cached == "")
		sHenchSummonFamiliars_cached = GetStringByStrRef(232569);
	return sHenchSummonFamiliars_cached;
}

//	"Party members will summon familiars outside of combat."
#define sHenchSummonFamiliarsOn hench_i0_strings_get_sHenchSummonFamiliarsOn()
string sHenchSummonFamiliarsOn_cached;
string hench_i0_strings_get_sHenchSummonFamiliarsOn()
{
	if (sHenchSummonFamiliarsOn_cached == "")
		sHenchSummonFamiliarsOn_cached = GetStringByStrRef(232570);
	return sHenchSummonFamiliarsOn_cached;
}

//	"Party members will not summon familiars outside of combat."
#define sHenchSummonFamiliarsOff hench_i0_strings_get_sHenchSummonFamiliarsOff()
string sHenchSummonFamiliarsOff_cached;
string hench_i0_strings_get_sHenchSummonFamiliarsOff()
{
	if (sHenchSummonFamiliarsOff_cached == "")
		sHenchSummonFamiliarsOff_cached = GetStringByStrRef(232571);
	return sHenchSummonFamiliarsOff_cached;
}

//	"Auto Summon Animal Companions (Party)"
#define sHenchSummonCompanions hench_i0_strings_get_sHenchSummonCompanions()
string sHenchSummonCompanions_cached;
string hench_i0_strings_get_sHenchSummonCompanions()
{
	if (sHenchSummonCompanions_cached == "")
		sHenchSummonCompanions_cached = GetStringByStrRef(232572);
	return sHenchSummonCompanions_cached;
}

//	"Party members will summon animal companions outside of combat."	 
#define sHenchSummonCompanionsOn hench_i0_strings_get_sHenchSummonCompanionsOn()
string sHenchSummonCompanionsOn_cached;
string hench_i0_strings_get_sHenchSummonCompanionsOn()
{
	if (sHenchSummonCompanionsOn_cached == "")
		sHenchSummonCompanionsOn_cached = GetStringByStrRef(232573);
	return sHenchSummonCompanionsOn_cached;
}

//	"Party members will not summon animal companions outside of combat."	 
#define sHenchSummonCompanionsOff hench_i0_strings_get_sHenchSummonCompanionsOff()
string sHenchSummonCompanionsOff_cached;
string hench_i0_strings_get_sHenchSummonCompanionsOff()
{
	if (sHenchSummonCompanionsOff_cached == "")
		sHenchSummonCompanionsOff_cached = GetStringByStrRef(232574);
	return sHenchSummonCompanionsOff_cached;
}

//	"Ally Damage (Party)"
#define sHenchAllyDamage hench_i0_strings_get_sHenchAllyDamage()
string sHenchAllyDamage_cached;
string hench_i0_strings_get_sHenchAllyDamage()
{
	if (sHenchAllyDamage_cached == "")
		sHenchAllyDamage_cached = GetStringByStrRef(232575);
	return sHenchAllyDamage_cached;
}

//	"Party members will avoid damaging party members with area of effect spells." 
#define sHenchAllyDamageLow hench_i0_strings_get_sHenchAllyDamageLow()
string sHenchAllyDamageLow_cached;
string hench_i0_strings_get_sHenchAllyDamageLow()
{
	if (sHenchAllyDamageLow_cached == "")
		sHenchAllyDamageLow_cached = GetStringByStrRef(232576);
	return sHenchAllyDamageLow_cached;
}

//	"Party members damage party members with area of effect spells to some extent."
#define sHenchAllyDamageMed hench_i0_strings_get_sHenchAllyDamageMed()
string sHenchAllyDamageMed_cached;
string hench_i0_strings_get_sHenchAllyDamageMed()
{
	if (sHenchAllyDamageMed_cached == "")
		sHenchAllyDamageMed_cached = GetStringByStrRef(232577);
	return sHenchAllyDamageMed_cached;
}

//	 "Party members damage party members with area of effect spells to a greater extent."
#define sHenchAllyDamageHigh hench_i0_strings_get_sHenchAllyDamageHigh()
string sHenchAllyDamageHigh_cached;
string hench_i0_strings_get_sHenchAllyDamageHigh()
{
	if (sHenchAllyDamageHigh_cached == "")
		sHenchAllyDamageHigh_cached = GetStringByStrRef(232578);
	return sHenchAllyDamageHigh_cached;
}

//	"Peaceful Follow (Party)"
#define sHenchPeacefulFollow hench_i0_strings_get_sHenchPeacefulFollow()
string sHenchPeacefulFollow_cached;
string hench_i0_strings_get_sHenchPeacefulFollow()
{
	if (sHenchPeacefulFollow_cached == "")
		sHenchPeacefulFollow_cached = GetStringByStrRef(232579);
	return sHenchPeacefulFollow_cached;
}

//	"Party members will not attack enemies after being issued a follow command." 
#define sHenchPeacefulFollowOn hench_i0_strings_get_sHenchPeacefulFollowOn()
string sHenchPeacefulFollowOn_cached;
string hench_i0_strings_get_sHenchPeacefulFollowOn()
{
	if (sHenchPeacefulFollowOn_cached == "")
		sHenchPeacefulFollowOn_cached = GetStringByStrRef(232580);
	return sHenchPeacefulFollowOn_cached;
}

//	"Party members will still attack enemies after being issued a follow command."
#define sHenchPeacefulFollowOff hench_i0_strings_get_sHenchPeacefulFollowOff()
string sHenchPeacefulFollowOff_cached;
string hench_i0_strings_get_sHenchPeacefulFollowOff()
{
	if (sHenchPeacefulFollowOff_cached == "")
		sHenchPeacefulFollowOff_cached = GetStringByStrRef(232581);
	return sHenchPeacefulFollowOff_cached;
}

//	"Self Buff or Heal (Party)"
#define sHenchSelfBuffOrHeal hench_i0_strings_get_sHenchSelfBuffOrHeal()
string sHenchSelfBuffOrHeal_cached;
string hench_i0_strings_get_sHenchSelfBuffOrHeal()
{
	if (sHenchSelfBuffOrHeal_cached == "")
		sHenchSelfBuffOrHeal_cached = GetStringByStrRef(232582);
	return sHenchSelfBuffOrHeal_cached;
}

//	"Player character will buff or heal when group command is given." 
#define sHenchSelfBuffOrHealOn hench_i0_strings_get_sHenchSelfBuffOrHealOn()
string sHenchSelfBuffOrHealOn_cached;
string hench_i0_strings_get_sHenchSelfBuffOrHealOn()
{
	if (sHenchSelfBuffOrHealOn_cached == "")
		sHenchSelfBuffOrHealOn_cached = GetStringByStrRef(232583);
	return sHenchSelfBuffOrHealOn_cached;
}

//	"Player character will not buff or heal when group command is given." 
#define sHenchSelfBuffOrHealOff hench_i0_strings_get_sHenchSelfBuffOrHealOff()
string sHenchSelfBuffOrHealOff_cached;
string hench_i0_strings_get_sHenchSelfBuffOrHealOff()
{
	if (sHenchSelfBuffOrHealOff_cached == "")
		sHenchSelfBuffOrHealOff_cached = GetStringByStrRef(232584);
	return sHenchSelfBuffOrHealOff_cached;
}


//	Global Options

//	"Monster Stealth (Global)"
#define sHenchMonsterStealth hench_i0_strings_get_sHenchMonsterStealth()
string sHenchMonsterStealth_cached;
string hench_i0_strings_get_sHenchMonsterStealth()
{
	if (sHenchMonsterStealth_cached == "")
		sHenchMonsterStealth_cached = GetStringByStrRef(233031);
	return sHenchMonsterStealth_cached;
}

//	"Monsters will use stealth if they have any skill ranks with hide or move silently."	
#define sHenchMonsterStealthOn hench_i0_strings_get_sHenchMonsterStealthOn()
string sHenchMonsterStealthOn_cached;
string hench_i0_strings_get_sHenchMonsterStealthOn()
{
	if (sHenchMonsterStealthOn_cached == "")
		sHenchMonsterStealthOn_cached = GetStringByStrRef(233032);
	return sHenchMonsterStealthOn_cached;
}

//	"Monsters will not use stealth."	
#define sHenchMonsterStealthOff hench_i0_strings_get_sHenchMonsterStealthOff()
string sHenchMonsterStealthOff_cached;
string hench_i0_strings_get_sHenchMonsterStealthOff()
{
	if (sHenchMonsterStealthOff_cached == "")
		sHenchMonsterStealthOff_cached = GetStringByStrRef(233033);
	return sHenchMonsterStealthOff_cached;
}

//	"Monster Wander (Global)"
#define sHenchMonsterWander hench_i0_strings_get_sHenchMonsterWander()
string sHenchMonsterWander_cached;
string hench_i0_strings_get_sHenchMonsterWander()
{
	if (sHenchMonsterWander_cached == "")
		sHenchMonsterWander_cached = GetStringByStrRef(233034);
	return sHenchMonsterWander_cached;
}

//	"Monsters will wander around looking for you."
#define sHenchMonsterWanderOn hench_i0_strings_get_sHenchMonsterWanderOn()
string sHenchMonsterWanderOn_cached;
string hench_i0_strings_get_sHenchMonsterWanderOn()
{
	if (sHenchMonsterWanderOn_cached == "")
		sHenchMonsterWanderOn_cached = GetStringByStrRef(233035);
	return sHenchMonsterWanderOn_cached;
}

//	"Monsters will not wander around."
#define sHenchMonsterWanderOff hench_i0_strings_get_sHenchMonsterWanderOff()
string sHenchMonsterWanderOff_cached;
string hench_i0_strings_get_sHenchMonsterWanderOff()
{
	if (sHenchMonsterWanderOff_cached == "")
		sHenchMonsterWanderOff_cached = GetStringByStrRef(233036);
	return sHenchMonsterWanderOff_cached;
}

//	"Monster Open Doors (Global)"
#define sHenchMonsterOpen hench_i0_strings_get_sHenchMonsterOpen()
string sHenchMonsterOpen_cached;
string hench_i0_strings_get_sHenchMonsterOpen()
{
	if (sHenchMonsterOpen_cached == "")
		sHenchMonsterOpen_cached = GetStringByStrRef(233037);
	return sHenchMonsterOpen_cached;
}

//	"Monsters will open doors when looking for you. Only works if Monster Wander is turned on."
#define sHenchMonsterOpenOn hench_i0_strings_get_sHenchMonsterOpenOn()
string sHenchMonsterOpenOn_cached;
string hench_i0_strings_get_sHenchMonsterOpenOn()
{
	if (sHenchMonsterOpenOn_cached == "")
		sHenchMonsterOpenOn_cached = GetStringByStrRef(233038);
	return sHenchMonsterOpenOn_cached;
}

//	"Monsters will not open doors."	
#define sHenchMonsterOpenOff hench_i0_strings_get_sHenchMonsterOpenOff()
string sHenchMonsterOpenOff_cached;
string hench_i0_strings_get_sHenchMonsterOpenOff()
{
	if (sHenchMonsterOpenOff_cached == "")
		sHenchMonsterOpenOff_cached = GetStringByStrRef(233039);
	return sHenchMonsterOpenOff_cached;
}

//	"Monster Unlock or Bash Doors (Global)"
#define sHenchMonsterUnlock hench_i0_strings_get_sHenchMonsterUnlock()
string sHenchMonsterUnlock_cached;
string hench_i0_strings_get_sHenchMonsterUnlock()
{
	if (sHenchMonsterUnlock_cached == "")
		sHenchMonsterUnlock_cached = GetStringByStrRef(233040);
	return sHenchMonsterUnlock_cached;
}

//	 "Monsters will unlock or bash open doors looking for you. Only works if Monster Open Doors is turned on."
#define sHenchMonsterUnlockOn hench_i0_strings_get_sHenchMonsterUnlockOn()
string sHenchMonsterUnlockOn_cached;
string hench_i0_strings_get_sHenchMonsterUnlockOn()
{
	if (sHenchMonsterUnlockOn_cached == "")
		sHenchMonsterUnlockOn_cached = GetStringByStrRef(233041);
	return sHenchMonsterUnlockOn_cached;
}

//	"Monsters will unlock or bash open doors." 
#define sHenchMonsterUnlockOff hench_i0_strings_get_sHenchMonsterUnlockOff()
string sHenchMonsterUnlockOff_cached;
string hench_i0_strings_get_sHenchMonsterUnlockOff()
{
	if (sHenchMonsterUnlockOff_cached == "")
		sHenchMonsterUnlockOff_cached = GetStringByStrRef(233042);
	return sHenchMonsterUnlockOff_cached;
}

//	"Knockdown (Global)"
#define sHenchKnockdown hench_i0_strings_get_sHenchKnockdown()
string sHenchKnockdown_cached;
string hench_i0_strings_get_sHenchKnockdown()
{
	if (sHenchKnockdown_cached == "")
		sHenchKnockdown_cached = GetStringByStrRef(233043);
	return sHenchKnockdown_cached;
}

//	"Knockdown use is turned on."	 
#define sHenchKnockdownOn hench_i0_strings_get_sHenchKnockdownOn()
string sHenchKnockdownOn_cached;
string hench_i0_strings_get_sHenchKnockdownOn()
{
	if (sHenchKnockdownOn_cached == "")
		sHenchKnockdownOn_cached = GetStringByStrRef(233044);
	return sHenchKnockdownOn_cached;
}

//	"Sometimes"	 
#define sHenchSometimes hench_i0_strings_get_sHenchSometimes()
string sHenchSometimes_cached;
string hench_i0_strings_get_sHenchSometimes()
{
	if (sHenchSometimes_cached == "")
		sHenchSometimes_cached = GetStringByStrRef(233045);
	return sHenchSometimes_cached;
}

//	"Knockdown use is used sometimes."; 
#define sHenchKnockdownSometimes hench_i0_strings_get_sHenchKnockdownSometimes()
string sHenchKnockdownSometimes_cached;
string hench_i0_strings_get_sHenchKnockdownSometimes()
{
	if (sHenchKnockdownSometimes_cached == "")
		sHenchKnockdownSometimes_cached = GetStringByStrRef(233046);
	return sHenchKnockdownSometimes_cached;
}

//	"Knockdown use is turned off."; 
#define sHenchKnockdownOff hench_i0_strings_get_sHenchKnockdownOff()
string sHenchKnockdownOff_cached;
string hench_i0_strings_get_sHenchKnockdownOff()
{
	if (sHenchKnockdownOff_cached == "")
		sHenchKnockdownOff_cached = GetStringByStrRef(233047);
	return sHenchKnockdownOff_cached;
}

//	"Auto Set of Companion Behaviors (Global)";
#define sHenchAutoBehaviorSet hench_i0_strings_get_sHenchAutoBehaviorSet()
string sHenchAutoBehaviorSet_cached;
string hench_i0_strings_get_sHenchAutoBehaviorSet()
{
	if (sHenchAutoBehaviorSet_cached == "")
		sHenchAutoBehaviorSet_cached = GetStringByStrRef(233048);
	return sHenchAutoBehaviorSet_cached;
}

//	"The first time you meet a companion default behaviors are assigned to them."	 
#define sHenchAutoBehaviorSetOn hench_i0_strings_get_sHenchAutoBehaviorSetOn()
string sHenchAutoBehaviorSetOn_cached;
string hench_i0_strings_get_sHenchAutoBehaviorSetOn()
{
	if (sHenchAutoBehaviorSetOn_cached == "")
		sHenchAutoBehaviorSetOn_cached = GetStringByStrRef(233049);
	return sHenchAutoBehaviorSetOn_cached;
}

//	 "No default behaviors are assigned to companions."
#define sHenchAutoBehaviorSetOff hench_i0_strings_get_sHenchAutoBehaviorSetOff()
string sHenchAutoBehaviorSetOff_cached;
string hench_i0_strings_get_sHenchAutoBehaviorSetOff()
{
	if (sHenchAutoBehaviorSetOff_cached == "")
		sHenchAutoBehaviorSetOff_cached = GetStringByStrRef(233050);
	return sHenchAutoBehaviorSetOff_cached;
}

//	"Enemies Auto Cast Buffs (Global)"	
#define sHenchAutoBuff hench_i0_strings_get_sHenchAutoBuff()
string sHenchAutoBuff_cached;
string hench_i0_strings_get_sHenchAutoBuff()
{
	if (sHenchAutoBuff_cached == "")
		sHenchAutoBuff_cached = GetStringByStrRef(233051);
	return sHenchAutoBuff_cached;
}

//	"The first time you meet an enemy they will already have cast long duration buffs on themselves."	 
#define sHenchAutoBuffLongOn hench_i0_strings_get_sHenchAutoBuffLongOn()
string sHenchAutoBuffLongOn_cached;
string hench_i0_strings_get_sHenchAutoBuffLongOn()
{
	if (sHenchAutoBuffLongOn_cached == "")
		sHenchAutoBuffLongOn_cached = GetStringByStrRef(233052);
	return sHenchAutoBuffLongOn_cached;
}

//	"The first time you meet an enemy they will already have cast medium and long duration buffs on themselves.";
#define sHenchAutoBuffMedOn hench_i0_strings_get_sHenchAutoBuffMedOn()
string sHenchAutoBuffMedOn_cached;
string hench_i0_strings_get_sHenchAutoBuffMedOn()
{
	if (sHenchAutoBuffMedOn_cached == "")
		sHenchAutoBuffMedOn_cached = GetStringByStrRef(233053);
	return sHenchAutoBuffMedOn_cached;
}

//	"No enemy pre cast of buffs."	 
#define sHenchAutoBuffOff hench_i0_strings_get_sHenchAutoBuffOff()
string sHenchAutoBuffOff_cached;
string hench_i0_strings_get_sHenchAutoBuffOff()
{
	if (sHenchAutoBuffOff_cached == "")
		sHenchAutoBuffOff_cached = GetStringByStrRef(233054);
	return sHenchAutoBuffOff_cached;
}

//	"Enemies Create Items (Global)"
#define sHenchCreateItems hench_i0_strings_get_sHenchCreateItems()
string sHenchCreateItems_cached;
string hench_i0_strings_get_sHenchCreateItems()
{
	if (sHenchCreateItems_cached == "")
		sHenchCreateItems_cached = GetStringByStrRef(233055);
	return sHenchCreateItems_cached;
}

//	"The first time you meet an enemy they will create some basic items (healing, buff) for use on themselves.";	 
#define sHenchCreateItemsOn hench_i0_strings_get_sHenchCreateItemsOn()
string sHenchCreateItemsOn_cached;
string hench_i0_strings_get_sHenchCreateItemsOn()
{
	if (sHenchCreateItemsOn_cached == "")
		sHenchCreateItemsOn_cached = GetStringByStrRef(233056);
	return sHenchCreateItemsOn_cached;
}

//	"No enemy creation of items."	 
#define sHenchCreateItemsOff hench_i0_strings_get_sHenchCreateItemsOff()
string sHenchCreateItemsOff_cached;
string hench_i0_strings_get_sHenchCreateItemsOff()
{
	if (sHenchCreateItemsOff_cached == "")
		sHenchCreateItemsOff_cached = GetStringByStrRef(233057);
	return sHenchCreateItemsOff_cached;
}

//	"Enemies Use Equipped Items (Global)"	
#define sHenchEquipppedItems hench_i0_strings_get_sHenchEquipppedItems()
string sHenchEquipppedItems_cached;
string hench_i0_strings_get_sHenchEquipppedItems()
{
	if (sHenchEquipppedItems_cached == "")
		sHenchEquipppedItems_cached = GetStringByStrRef(233058);
	return sHenchEquipppedItems_cached;
}

//	"Enemies are able to use equipped items (not normally possible)."	 
#define sHenchEquipppedItemsOn hench_i0_strings_get_sHenchEquipppedItemsOn()
string sHenchEquipppedItemsOn_cached;
string hench_i0_strings_get_sHenchEquipppedItemsOn()
{
	if (sHenchEquipppedItemsOn_cached == "")
		sHenchEquipppedItemsOn_cached = GetStringByStrRef(233059);
	return sHenchEquipppedItemsOn_cached;
}

//	"Enemies don't use equipped items." 
#define sHenchEquipppedItemsOff hench_i0_strings_get_sHenchEquipppedItemsOff()
string sHenchEquipppedItemsOff_cached;
string hench_i0_strings_get_sHenchEquipppedItemsOff()
{
	if (sHenchEquipppedItemsOff_cached == "")
		sHenchEquipppedItemsOff_cached = GetStringByStrRef(233060);
	return sHenchEquipppedItemsOff_cached;
}

//	"Warlock One Round Hideous Blow (Global)"	
#define sHenchHideousBlow hench_i0_strings_get_sHenchHideousBlow()
string sHenchHideousBlow_cached;
string hench_i0_strings_get_sHenchHideousBlow()
{
	if (sHenchHideousBlow_cached == "")
		sHenchHideousBlow_cached = GetStringByStrRef(233061);
	return sHenchHideousBlow_cached;
}

//	"Warlocks use hideous blow in one round."	 
#define sHenchHideousBlowOn hench_i0_strings_get_sHenchHideousBlowOn()
string sHenchHideousBlowOn_cached;
string hench_i0_strings_get_sHenchHideousBlowOn()
{
	if (sHenchHideousBlowOn_cached == "")
		sHenchHideousBlowOn_cached = GetStringByStrRef(233062);
	return sHenchHideousBlowOn_cached;
}

//	"Warlocks use hideous blow in two rounds.";	 
#define sHenchHideousBlowOff hench_i0_strings_get_sHenchHideousBlowOff()
string sHenchHideousBlowOff_cached;
string hench_i0_strings_get_sHenchHideousBlowOff()
{
	if (sHenchHideousBlowOff_cached == "")
		sHenchHideousBlowOff_cached = GetStringByStrRef(233063);
	return sHenchHideousBlowOff_cached;
}

//	"Monster Ally Damage (Global)"	
#define sHenchMonsterAllyDamage hench_i0_strings_get_sHenchMonsterAllyDamage()
string sHenchMonsterAllyDamage_cached;
string hench_i0_strings_get_sHenchMonsterAllyDamage()
{
	if (sHenchMonsterAllyDamage_cached == "")
		sHenchMonsterAllyDamage_cached = GetStringByStrRef(233064);
	return sHenchMonsterAllyDamage_cached;
}

//	"Monsters damage allies with area of effect spells based on alignment."	 
#define sHenchMonsterAllyDamageOn hench_i0_strings_get_sHenchMonsterAllyDamageOn()
string sHenchMonsterAllyDamageOn_cached;
string hench_i0_strings_get_sHenchMonsterAllyDamageOn()
{
	if (sHenchMonsterAllyDamageOn_cached == "")
		sHenchMonsterAllyDamageOn_cached = GetStringByStrRef(233065);
	return sHenchMonsterAllyDamageOn_cached;
}

//	"Monsters avoid damaging allies with area of effect spells." 
#define sHenchMonsterAllyDamageOff hench_i0_strings_get_sHenchMonsterAllyDamageOff()
string sHenchMonsterAllyDamageOff_cached;
string hench_i0_strings_get_sHenchMonsterAllyDamageOff()
{
	if (sHenchMonsterAllyDamageOff_cached == "")
		sHenchMonsterAllyDamageOff_cached = GetStringByStrRef(233066);
	return sHenchMonsterAllyDamageOff_cached;
}


// companion or henchman battle cry, called during attack
void HenchBattleCry()
{
/*
    // left in case anyone wants this
    
    string sName = GetName(OBJECT_SELF);
    // Probability of Battle Cry. MUST be a number from 1 to at least 8
    int iSpeakProb = Random(125)+1;
    if (FindSubString(sName,"Sharw") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Take this, fool!"); break;
       case 2: SpeakString("Spare me your song and dance!"); break;
       case 3: SpeakString("To hell with you, hideous fiend!"); break;
       case 4: SpeakString("Come here. Come here I say!"); break;
       case 5: SpeakString("How dare you, impetuous beast?"); break;
       case 6: SpeakString("Pleased to meet you!"); break;
       case 7: SpeakString("Fantastic. Just fantastic!"); break;
       case 8: SpeakString("You CAN do better than this, can you not?"); break;

       default: break;
    }

    if (FindSubString(sName,"Tomi") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Tomi's got a little present for you here!"); break;
       case 2: SpeakString("Poor sod, soon to bite the earth!"); break;
       case 3: SpeakString("Think twice before messing with Tomi!"); break;
       case 4: SpeakString("Tomi's fast; YOU are slow!"); break;
       case 5: SpeakString("Your momma raised ya to become THIS?"); break;
       case 6: SpeakString("Hey! Where's your manners!"); break;
       case 7: SpeakString("Tomi's got a BIG problem with you. Scram!"); break;
       case 8: SpeakString("You're an ugly little beastie, ain't ya?"); break;

       default: break;
    }

    if (FindSubString(sName,"Grim") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Destruction for all!"); break;
       case 2: SpeakString("Embrace Death, and long for it!"); break;
       case 3: SpeakString("My Silent Lord comes to take you!"); break;
       case 4: SpeakString("Be still: your End approaches."); break;
       case 5: SpeakString("Prepare yourself! Your time is near!"); break;
       case 6: SpeakString("Eternal Silence engulfs you!"); break;
       case 7: SpeakString("I am at one with my End. And you?"); break;
       case 8: SpeakString("Suffering ends; but Death is eternal!"); break;
       default: break;
    }

    if (FindSubString(sName,"Dael") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("I'd spare you if you would only desist."); break;
       case 2: SpeakString("It needn't end like this. Leave us be!"); break;
       case 3: SpeakString("You attack us, only to die. Why?"); break;
       case 4: SpeakString("Must you all chase destruction? Very well!"); break;
       case 5: SpeakString("It does not please me to crush you like this."); break;
       case 6: SpeakString("Do not provoke me!"); break;
       case 7: SpeakString("I am at my wit's end with you all!"); break;
       case 8: SpeakString("Do you even know what you face?"); break;
       default: break;
    }

    if (FindSubString(sName,"Linu") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Oooops! I nearly fell!"); break;
       case 2: SpeakString("What is your grievance? Begone!"); break;
       case 3: SpeakString("I won't allow you to harm anyone else!"); break;
       case 4: SpeakString("Retreat or feel Sehanine's wrath!"); break;
       case 5: SpeakString("By Sehanine Moonbow, you will not pass unchecked."); break;
       case 6: SpeakString("Smite you I will, though unwillingly."); break;
       case 7: SpeakString("Sehanine willing, you'll soon be undone!"); break;
       case 8: SpeakString("Have you no shame? Then suffer!"); break;
       default: break;
    }

    if (FindSubString(sName,"Boddy") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("You face a sorcerer of considerable power!"); break;
       case 2: SpeakString("I find your resistance illogical."); break;
       case 3: SpeakString("I bind the powers of the very Planes!"); break;
       case 4: SpeakString("Fighting for now, and research for later."); break;
       case 5: SpeakString("Sad to destroy a fine specimen such as yourself."); break;
       case 6: SpeakString("Your chances of success are quite low, you know?"); break;
       case 7: SpeakString("It's hard to argue with these fools."); break;
       case 8: SpeakString("Now you are making me lose my patience."); break;
       default: break;
    } */
}


// monster battle cry, called during attack
void MonsterBattleCry()
{


}

