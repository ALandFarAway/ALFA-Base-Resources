/*

    Companion and Monster AI

    This file contains all strings shown to the PC. (Useful for
    multilanguage support and customization.)

*/


//	Weapons Equipping

//	"I don't know how to use this shield."
string sHenchCantUseShield = GetStringByStrRef(230391);

//	"I can't use ranged weapons."
string sHenchCantUseRanged = GetStringByStrRef(230392);

//	"I'm switching back to my missile weapon."
string sHenchSwitchToMissle = GetStringByStrRef(230393);

//	"I'm switching to my melee weapon for now."
string sHenchSwitchToRanged = GetStringByStrRef(230394);

//	"I'm stuck. Switching to my missile weapon."
string sHenchSwitchToMissle1 = GetStringByStrRef(230395);

//	"I'm switching back to my melee weapon for now."
string sHenchSwitchToRanged1 = GetStringByStrRef(230396);


//	Generic

//	"There's something interesting near that door."
string sHenchSomethingFishy = GetStringByStrRef(230408);


//	Hen Shout

//	"**Peaceful Follow Mode Canceled**"
string sHenchPeacefulModeCancel = GetStringByStrRef(230409);

//	"**Peaceful Follow Mode Enabled**"
//	 Was "I will follow but not attack our enemies until you tell me otherwise."
string sHenchHenchmanFollow = GetStringByStrRef(230410);

//	"**Peaceful Follow Mode Enabled**"
//	Was "I will be happy to follow you, avoiding combat until you tell me otherwise!"
string sHenchFamiliarFollow = GetStringByStrRef(230410);

//	" understands that it should follow, waiting for your command to attack.]"
string sHenchAnCompFollow = GetStringByStrRef(230411);

//	"[The "
string sHenchOtherFollow1 = GetStringByStrRef(230412);

//	" will now follow you, and be peaceful until told otherwise.]"
string sHenchOtherFollow2 = GetStringByStrRef(230413);


//	Hench Heartbeat

//	"I'm not doing anything until these traps are cleared."
string sHenchWaitTrapsCleared = GetStringByStrRef(230414);

//	"There is something important here you should look at."
string sHenchSomethingImportant = GetStringByStrRef(230415);

//	"Look what I found."
string sHenchFoundSomething = GetStringByStrRef(230416);

//	" Acquired Item: "
string sHenchAcquiredItem = GetStringByStrRef(230417);

//	"My inventory is full."
string sHenchInventoryFull = GetStringByStrRef(230418);


//	Main AI

//	"Sorry, I can't heal you."
string sHenchCantHealMaster = GetStringByStrRef(230419);

//	"Should I heal you?"
string sHenchAskHealMaster = GetStringByStrRef(230420);

//	"Should I attack?"
string sHenchHenchmanAskAttack = GetStringByStrRef(230421);

//	"Let me know if I should attack."
string sHenchFamiliarAskAttack = GetStringByStrRef(230422);

//	" is waiting for you to give the command to attack.]"
string sHenchAnCompAskAttack = GetStringByStrRef(230423);

//	" patiently awaits your command to attack.]"
string sHenchOtherAskAttack = GetStringByStrRef(230424);

//	"Don't make me laugh!"
string sHenchWeakAttacker = GetStringByStrRef(230425);

//	"We'll best them yet!"
string sHenchModAttacker = GetStringByStrRef(230426);

//	"Watch out for this one!"
string sHenchStrongAttacker = GetStringByStrRef(230427);

//	"Gods help us!"
string sHenchOverpoweringAttacker = GetStringByStrRef(230428);

//	"Time for me to get out of here!"
string sHenchFamiliarFlee1 = GetStringByStrRef(230429);

//	"Eeeeek!"
string sHenchFamiliarFlee2 = GetStringByStrRef(230430);

//	"Make way, make way!"
string sHenchFamiliarFlee3 = GetStringByStrRef(230431);

//	"I'll be back!"
string sHenchFamiliarFlee4 = GetStringByStrRef(230432);

//	":: Danger ::"
string sHenchAniCompFlee = GetStringByStrRef(230433);

//	"Help! I can't heal myself!"
string sHenchHealMe = GetStringByStrRef(230434);


// Hench Scout

//	"Please get out of my way."
string sHenchGetOutofWay = GetStringByStrRef(230435);

//	"[Scouting can only be done by associates, not companions.]"
string sHenchNoScoutCompanions = GetStringByStrRef(230436);

//	"This area looks safe enough."
string sHenchSafeEnough = GetStringByStrRef(230437);


//	Hench Block

//	"Something is on the other side of this door."
string sHenchMonsterOnOtherSide = GetStringByStrRef(230438);


//	Hench Fail

//	"I can't see "
string sHenchCantSeeTarget = GetStringByStrRef(230439);

//	" is not a melee weapon."
string sHenchNotAMeleeWeapon = GetStringByStrRef(230440);

//	" is not a ranged weapon."
string sHenchNotARangedWeapon = GetStringByStrRef(230441);

//	" is not a shield."
string sHenchNotAShield = GetStringByStrRef(230442);


//	Companion/Associate Behavior Options

//	"Automatic Weapon Switching"
string sHenchEnableWeaonSwitch		= GetStringByStrRef(232501);

//	"This character will automatically switch weapons during combat."
string sHenchEnableWeaonSwitchOn	= GetStringByStrRef(232502);

//	"This character will not automatically switch weapons during combat."
string sHenchEnableWeaonSwitchOff	= GetStringByStrRef(232503);

//	"This character will use ranged weapons during combat."
string sHenchRangedWeaponsSwitchOn	= GetStringByStrRef(232504);

//	"This character will not use ranged weapons during combat."
string sHenchRangedWeaponsSwitchOff	= GetStringByStrRef(232505);

//	"Switch To Melee Distance"
string sHenchSwitchToMeleeDist		= GetStringByStrRef(232506);

//	"This character will switch to melee weapons only when enemies are close."
string sHenchSwitchToMeleeDistNear	= GetStringByStrRef(232507);

//	 "This character will switch to melee weapons only when enemies are a medium distance away."
string sHenchSwitchToMeleeDistMed	= GetStringByStrRef(232508);

//	"This character will switch to melee weapons when enemies are fairly far away." 
string sHenchSwitchToMeleeDistFar	= GetStringByStrRef(232509);

//	"Back Away"
string sHenchEnableBackAway			= GetStringByStrRef(232510);

//	"This character will avoid melee combat by moving away from enemies." 
string sHenchEnableBackAwayOn		= GetStringByStrRef(232511);

//	"This character will not avoid melee combat by moving away from enemies."
string sHenchEnableBackAwayOff		= GetStringByStrRef(232512);  

//	"Summoning"
string sHenchEnableSummons			= GetStringByStrRef(232513);

//	"This character will summon creatures during combat."	  
string sHenchEnableSummonsOn		= GetStringByStrRef(232514);

//	"This character will not summon creatures during combat."
string sHenchEnableSummonsOff		= GetStringByStrRef(232515); 

//	"Dual Wielding"
string sHenchDualWielding			= GetStringByStrRef(232516); 

//	"This character will dual wield melee weapons."
string sHenchDualWieldingOn			= GetStringByStrRef(232517); 

//	"This character will not dual wield melee weapons."	 
string sHenchDualWieldingOff		= GetStringByStrRef(232518); 

//	"This character will use the default behavior for dual wielding melee weapons."	
string sHenchDualWieldingDefault	= GetStringByStrRef(232519);

//	"Heavy Off Hand Weapons"
string sHenchEnableHeavyOffHand		= GetStringByStrRef(232520);

//	 "This character will use heavy off hand weapons."
string sHenchEnableHeavyOffHandOn	= GetStringByStrRef(232521);

//	 "This character will not use heavy off hand weapons."
string sHenchEnableHeavyOffHandOff	= GetStringByStrRef(232522); 

//	"Use Shields"	
string sHenchEnableShieldUse		= GetStringByStrRef(232523); 

//	 "This character will use shields."
string sHenchEnableShieldUseOn		= GetStringByStrRef(232524);

//	 "This character will not use shields."
string sHenchEnableShieldUseOff		= GetStringByStrRef(232525); 

//	"Recover Traps"
string sHenchEnableRecoverTraps		= GetStringByStrRef(232526);

//	 "This character will recover all traps. Only works with disarm traps turned on."
string sHenchEnableRecoverTrapsOn	= GetStringByStrRef(232527);

//	 "This character will recover traps when the risk of failure isn't great. Only works with disarm traps turned on."
string sHenchEnableRecoverTrapsOnSafe	= GetStringByStrRef(232528);

//	 "This character will not recover traps."
string sHenchEnableRecoverTrapsOff	= GetStringByStrRef(232529);  

//	"Automatically Open Locks"
string sHenchEnableAutoOpenLocks	= GetStringByStrRef(232530);

//	"This character will automatically open nearby locks."	 
string sHenchEnableAutoOpenLocksOn	= GetStringByStrRef(232531);

//	 "This character will not automatically open locks."
string sHenchEnableAutoOpenLocksOff	= GetStringByStrRef(232532);  

//	"Automatically Pick Up Items"
string sHenchEnableAutoPickup		= GetStringByStrRef(232533);

//	"This character will automatically pick up nearby items."
string sHenchEnableAutoPickupOn		= GetStringByStrRef(232534);

//	"This character will not automatically pick up items."
string sHenchEnableAutoPickupOff	= GetStringByStrRef(232535);

//	"Polymorph"	
string sHenchEnablePolymorph		= GetStringByStrRef(232536);

//	"This character will polymorph during combat. This also includes similar spells like stone and iron body."	 
string sHenchEnablePolymorphOn		= GetStringByStrRef(232537);

//	"This character will not polymorph during combat. This also includes similar spells like stone and iron body." 
string sHenchEnablePolymorphOff		= GetStringByStrRef(232538);

//	"Infinite Buffs"
string sHenchEnableInfiniteBuff		= GetStringByStrRef(232539);

//	"This character will use unlimited spells to buff while not in combat. Only works with warlocks and bard inspirations. This option is turned off automatically if no buffs can be done."
string sHenchEnableInfiniteBuffOn	= GetStringByStrRef(232540);

//	 "This character will not use unlimited spells to buff while not in combat."
string sHenchEnableInfiniteBuffOff	= GetStringByStrRef(232541);  

//	"Use Healing and Curing Items"
string sHenchEnableHealingItemUseBuff	= GetStringByStrRef(232542);

//	"This character will use healing and curing items. This setting overrides the item usage setting." 
string sHenchEnableHealingItemUseOn		= GetStringByStrRef(232543);

//	"This character will use the item usage setting for healing and curing items."; 
string sHenchEnableHealingItemUseOff	= GetStringByStrRef(232544); 

//	"Automatic Hiding"	
string sHenchEnableAutoHide				= GetStringByStrRef(232545); 

//	"This character will hide during combat."	 
string sHenchEnableAutoHideOn			= GetStringByStrRef(232546);

//	"This character will not hide during combat."	 
string sHenchEnableAutoHideOff			= GetStringByStrRef(232547); 

//	"Guard Distance"	
string sHenchGuardDist					= GetStringByStrRef(232548); 

//	"This character will attack only when enemies are close." 
string sHenchGuardDistNear				= GetStringByStrRef(232549);

//	 "This character will attack only when enemies are a medium distance away."
string sHenchGuardDistMed				= GetStringByStrRef(232550);

//	 "This character will attack when enemies are fairly far away."
string sHenchGuardDistFar				= GetStringByStrRef(232551);

//	 "This character will attack based on ranged weapon use."
string sHenchGuardDistDefault			= GetStringByStrRef(232552);

//	"Following "
string sHenchFollowing = GetStringByStrRef(232555);

//	" player controlled character (Default)"	 
string sHenchPCC = GetStringByStrRef(232556);

//	" master (Default)"	 
string sHenchMaster = GetStringByStrRef(232557);

//	" no one";	  
string sHenchNoOne = GetStringByStrRef(232558);

//	"Defending "	 
string sHenchDefending = GetStringByStrRef(232559);

//	"Disable Melee Attacks"
string sHenchDisableMeleeAttacks = GetStringByStrRef(232560);

//	"This character will not use melee attacks. Only spells and ranged weapons are used."	 
string sHenchDisableMeleeAttacksOn	= GetStringByStrRef(232561);

//	"This character will use melee attacks." 
string sHenchDisableMeleeAttacksOff	= GetStringByStrRef(232562); 

//	"Melee Attack for Party"
string sHenchEnableMeleeAttacksAny	= GetStringByStrRef(232563);

//	"This character will go into melee attack if any member of the party is in melee attack."
string sHenchEnableMeleeAttacksAnyOn	= GetStringByStrRef(232564);

//	"This character will use standard melee attack distances."	 
string sHenchEnableMeleeAttacksAnyOff	= GetStringByStrRef(232565);


//	Party Options

//	"Unequip Weapons After Combat (Party)"
string sHenchUnequipWeapons				= GetStringByStrRef(232566);

//	"Party members will unequip weapons after of combat."	 
string sHenchUnequipWeaponsOn			= GetStringByStrRef(232567);

//	"Party members will leave weapons equipped after combat."	 
string sHenchUnequipWeaponsOff			= GetStringByStrRef(232568);

//	"Auto Summon Familiars (Party)"
string sHenchSummonFamiliars			= GetStringByStrRef(232569);

//	"Party members will summon familiars outside of combat."
string sHenchSummonFamiliarsOn			= GetStringByStrRef(232570);

//	"Party members will not summon familiars outside of combat."
string sHenchSummonFamiliarsOff			= GetStringByStrRef(232571);

//	"Auto Summon Animal Companions (Party)"
string sHenchSummonCompanions			= GetStringByStrRef(232572);

//	"Party members will summon animal companions outside of combat."	 
string sHenchSummonCompanionsOn			= GetStringByStrRef(232573);

//	"Party members will not summon animal companions outside of combat."	 
string sHenchSummonCompanionsOff		= GetStringByStrRef(232574);

//	"Ally Damage (Party)"
string sHenchAllyDamage					= GetStringByStrRef(232575);

//	"Party members will avoid damaging party members with area of effect spells." 
string sHenchAllyDamageLow				= GetStringByStrRef(232576);

//	"Party members damage party members with area of effect spells to some extent."
string sHenchAllyDamageMed				= GetStringByStrRef(232577);

//	 "Party members damage party members with area of effect spells to a greater extent."
string sHenchAllyDamageHigh				= GetStringByStrRef(232578);

//	"Peaceful Follow (Party)"
string sHenchPeacefulFollow				= GetStringByStrRef(232579);

//	"Party members will not attack enemies after being issued a follow command." 
string sHenchPeacefulFollowOn			= GetStringByStrRef(232580);

//	"Party members will still attack enemies after being issued a follow command."
string sHenchPeacefulFollowOff			= GetStringByStrRef(232581);

//	"Self Buff or Heal (Party)"
string sHenchSelfBuffOrHeal				= GetStringByStrRef(232582);

//	"Player character will buff or heal when group command is given." 
string sHenchSelfBuffOrHealOn			= GetStringByStrRef(232583);

//	"Player character will not buff or heal when group command is given." 
string sHenchSelfBuffOrHealOff			= GetStringByStrRef(232584);


//	Global Options

//	"Monster Stealth (Global)"
string sHenchMonsterStealth			= GetStringByStrRef(233031);

//	"Monsters will use stealth if they have any skill ranks with hide or move silently."	
string sHenchMonsterStealthOn		= GetStringByStrRef(233032);

//	"Monsters will not use stealth."	
string sHenchMonsterStealthOff		= GetStringByStrRef(233033);  

//	"Monster Wander (Global)"
string sHenchMonsterWander			= GetStringByStrRef(233034);

//	"Monsters will wander around looking for you."
string sHenchMonsterWanderOn		= GetStringByStrRef(233035);

//	"Monsters will not wander around."
string sHenchMonsterWanderOff		= GetStringByStrRef(233036); 

//	"Monster Open Doors (Global)"
string sHenchMonsterOpen			= GetStringByStrRef(233037);

//	"Monsters will open doors when looking for you. Only works if Monster Wander is turned on."
string sHenchMonsterOpenOn			= GetStringByStrRef(233038);

//	"Monsters will not open doors."	
string sHenchMonsterOpenOff			= GetStringByStrRef(233039); 

//	"Monster Unlock or Bash Doors (Global)"
string sHenchMonsterUnlock			= GetStringByStrRef(233040);

//	 "Monsters will unlock or bash open doors looking for you. Only works if Monster Open Doors is turned on."
string sHenchMonsterUnlockOn		= GetStringByStrRef(233041);

//	"Monsters will unlock or bash open doors." 
string sHenchMonsterUnlockOff		= GetStringByStrRef(233042);

//	"Knockdown (Global)"
string sHenchKnockdown				= GetStringByStrRef(233043);

//	"Knockdown use is turned on."	 
string sHenchKnockdownOn			= GetStringByStrRef(233044);

//	"Sometimes"	 
string sHenchSometimes				= GetStringByStrRef(233045);

//	"Knockdown use is used sometimes."; 
string sHenchKnockdownSometimes		= GetStringByStrRef(233046);

//	"Knockdown use is turned off."; 
string sHenchKnockdownOff			= GetStringByStrRef(233047);

//	"Auto Set of Companion Behaviors (Global)";
string sHenchAutoBehaviorSet		= GetStringByStrRef(233048);

//	"The first time you meet a companion default behaviors are assigned to them."	 
string sHenchAutoBehaviorSetOn		= GetStringByStrRef(233049);

//	 "No default behaviors are assigned to companions."
string sHenchAutoBehaviorSetOff		= GetStringByStrRef(233050);

//	"Enemies Auto Cast Buffs (Global)"	
string sHenchAutoBuff 				= GetStringByStrRef(233051);

//	"The first time you meet an enemy they will already have cast long duration buffs on themselves."	 
string sHenchAutoBuffLongOn			= GetStringByStrRef(233052);

//	"The first time you meet an enemy they will already have cast medium and long duration buffs on themselves.";
string sHenchAutoBuffMedOn			= GetStringByStrRef(233053);

//	"No enemy pre cast of buffs."	 
string sHenchAutoBuffOff			= GetStringByStrRef(233054);

//	"Enemies Create Items (Global)"
string sHenchCreateItems	 		= GetStringByStrRef(233055);

//	"The first time you meet an enemy they will create some basic items (healing, buff) for use on themselves.";	 
string sHenchCreateItemsOn			= GetStringByStrRef(233056);

//	"No enemy creation of items."	 
string sHenchCreateItemsOff			= GetStringByStrRef(233057);

//	"Enemies Use Equipped Items (Global)"	
string sHenchEquipppedItems 		= GetStringByStrRef(233058);

//	"Enemies are able to use equipped items (not normally possible)."	 
string sHenchEquipppedItemsOn		= GetStringByStrRef(233059);

//	"Enemies don't use equipped items." 
string sHenchEquipppedItemsOff		= GetStringByStrRef(233060);

//	"Warlock One Round Hideous Blow (Global)"	
string sHenchHideousBlow 			= GetStringByStrRef(233061);

//	"Warlocks use hideous blow in one round."	 
string sHenchHideousBlowOn			= GetStringByStrRef(233062);

//	"Warlocks use hideous blow in two rounds.";	 
string sHenchHideousBlowOff			= GetStringByStrRef(233063);

//	"Monster Ally Damage (Global)"	
string sHenchMonsterAllyDamage		= GetStringByStrRef(233064);

//	"Monsters damage allies with area of effect spells based on alignment."	 
string sHenchMonsterAllyDamageOn	= GetStringByStrRef(233065);

//	"Monsters avoid damaging allies with area of effect spells." 
string sHenchMonsterAllyDamageOff	= GetStringByStrRef(233066);


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