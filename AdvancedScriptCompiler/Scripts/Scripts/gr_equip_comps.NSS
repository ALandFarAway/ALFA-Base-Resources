// gr_equip_comps.nss
// Equip companions with high level gear

#include "ginc_debug"

const string EQUIP_WEAPON_KHELGAR 	= "x2_wmdwraxe006";
const string EQUIP_WEAPON_CASAVIR	= "x0_wdbmma002";
const string EQUIP_WEAPON_ZHJAEVE	= "nw_c3_wblmhw005";
const string EQUIP_WEAPON_GROBNAR	= "x0_it_mthnmisc18";
const string EQUIP_WEAPON_ELANEE	= "n2_wdbmqs002";
const string EQUIP_WEAPON_SAND		= "nw_wmgst003";
const string EQUIP_WEAPON_AMMON		= "silver_sword";
const string EQUIP_WEAPON_QARA		= "nw_wmgst003";
//const string EQUIP_WEAPON_BISHOP	= "";

const string EQUIP_MELEE_ARMS 	= "nw_it_mbracer010";
const string EQUIP_MELEE_BELT 	= "x2_it_mbelt002";
const string EQUIP_MELEE_BOOTS 	= "nw_it_mboots005";
const string EQUIP_MELEE_CHEST	= "x0_maarcl023";
const string EQUIP_MELEE_CLOAK	= "x0_maarcl040";
const string EQUIP_MELEE_HEAD	= "x2_helm_004";
const string EQUIP_MELEE_LRING	= "nw_it_mring004";
const string EQUIP_MELEE_NECK	= "nw_it_mneck013";
const string EQUIP_MELEE_RRING	= "nw_it_mring033";

const string EQUIP_MAGIC_ARMS	= "nw_it_mbracer010";
const string EQUIP_MAGIC_BELT	= "x2_it_mbelt006";
const string EQUIP_MAGIC_BOOTS	= "nw_it_mboots005";
const string EQUIP_MAGIC_CHEST	= "n2_mcloth001";
const string EQUIP_MAGIC_CLOAK	= "x0_maarcl040";
const string EQUIP_MAGIC_HEAD	= "x2_helm_004";
const string EQUIP_MAGIC_LRING	= "nw_it_mring004";
const string EQUIP_MAGIC_NECK	= "nw_it_mneck013";
const string EQUIP_MAGIC_RRING	= "nw_it_mring033";

const string EQUIP_OTHER_ARMS	= "nw_it_mbracer010";
const string EQUIP_OTHER_BELT	= "x2_it_mbelt006";
const string EQUIP_OTHER_BOOTS	= "nw_it_mboots005";
const string EQUIP_OTHER_CHEST	= "x0_maarcl006";
const string EQUIP_OTHER_CLOAK	= "x0_maarcl040";
const string EQUIP_OTHER_HEAD	= "x2_helm_004";
const string EQUIP_OTHER_LRING	= "nw_it_mring004";
const string EQUIP_OTHER_NECK	= "nw_it_mneck013";
const string EQUIP_OTHER_RRING	= "nw_it_mring033";

int GetMeleeLevels( object oCreature )
{
	return ( GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_BARBARIAN, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_BLACKGUARD, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_CLERIC, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_DIVINECHAMPION, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_DUELIST, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_DWARVENDEFENDER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_ELDRITCH_KNIGHT, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_FIGHTER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_FRENZIEDBERSERKER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_PALADIN, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_WARPRIEST, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_WEAPON_MASTER, oCreature ) );
}

int GetMagicLevels( object oCreature )
{
	return ( GetLevelByClass( CLASS_TYPE_ARCANETRICKSTER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_DRAGONDISCIPLE, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_PALEMASTER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_SORCERER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_WIZARD, oCreature ) );
}

int GetOtherLevels( object oCreature )
{
	return ( GetLevelByClass( CLASS_TYPE_ASSASSIN, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_BARD, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_DRUID, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_HARPER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_MONK, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_RANGER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_ROGUE, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_SHADOWTHIEFOFAMN, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_SHAPECHANGER, oCreature ) +
			 GetLevelByClass( CLASS_TYPE_WARLOCK, oCreature ) );
}

// unequip all slots
void UnequipAll( object oCreature )
{
	object oItem;
	int n;
	for ( n = 0; n <= 15; n++ )
	{
		oItem = GetItemInSlot( n, oCreature );
		AssignCommand( oCreature, ActionUnequipItem( oItem ) );
	}
}

void IdentifyAll( object oCreature )
{
	object oItem = GetFirstItemInInventory( oCreature );
	while ( GetIsObjectValid( oItem ) )
	{
		SetIdentified( oItem, TRUE );
		oItem = GetNextItemInInventory( oCreature );
	}
}

void EquipMelee( object oCreature )
{
	UnequipAll( oCreature );
	
	object oArms = CreateItemOnObject( EQUIP_MELEE_ARMS, oCreature, 1 );
	object oBelt = CreateItemOnObject( EQUIP_MELEE_BELT, oCreature, 1 );
	object oBoots = CreateItemOnObject( EQUIP_MELEE_BOOTS, oCreature, 1 );
	object oChest = CreateItemOnObject( EQUIP_MELEE_CHEST, oCreature, 1 );
	object oCloak = CreateItemOnObject( EQUIP_MELEE_CLOAK, oCreature, 1 );
	object oHead = CreateItemOnObject( EQUIP_MELEE_HEAD, oCreature, 1 );
	object oLRing = CreateItemOnObject( EQUIP_MELEE_LRING, oCreature, 1 );
	object oNeck = CreateItemOnObject( EQUIP_MELEE_NECK, oCreature, 1 );
	object oRRing = CreateItemOnObject( EQUIP_MELEE_RRING, oCreature, 1 );

	IdentifyAll( oCreature );
	
	AssignCommand( oCreature, ActionEquipItem( oArms, INVENTORY_SLOT_ARMS ) );
	AssignCommand( oCreature, ActionEquipItem( oBelt, INVENTORY_SLOT_BELT ) );
	AssignCommand( oCreature, ActionEquipItem( oBoots, INVENTORY_SLOT_BOOTS ) );
	AssignCommand( oCreature, ActionEquipItem( oChest, INVENTORY_SLOT_CHEST ) );
	AssignCommand( oCreature, ActionEquipItem( oCloak, INVENTORY_SLOT_CLOAK ) );
	AssignCommand( oCreature, ActionEquipItem( oHead, INVENTORY_SLOT_HEAD ) );
	AssignCommand( oCreature, ActionEquipItem( oLRing, INVENTORY_SLOT_LEFTRING ) );
	AssignCommand( oCreature, ActionEquipItem( oNeck, INVENTORY_SLOT_NECK ) );
	AssignCommand( oCreature, ActionEquipItem( oRRing, INVENTORY_SLOT_RIGHTRING ) );
}

void EquipMagic( object oCreature )
{
	UnequipAll( oCreature );
	
	object oArms = CreateItemOnObject( EQUIP_MAGIC_ARMS, oCreature, 1 );
	object oBelt = CreateItemOnObject( EQUIP_MAGIC_BELT, oCreature, 1 );
	object oBoots = CreateItemOnObject( EQUIP_MAGIC_BOOTS, oCreature, 1 );
	object oChest = CreateItemOnObject( EQUIP_MAGIC_CHEST, oCreature, 1 );
	object oCloak = CreateItemOnObject( EQUIP_MAGIC_CLOAK, oCreature, 1 );
	object oHead = CreateItemOnObject( EQUIP_MAGIC_HEAD, oCreature, 1 );
	object oLRing = CreateItemOnObject( EQUIP_MAGIC_LRING, oCreature, 1 );
	object oNeck = CreateItemOnObject( EQUIP_MAGIC_NECK, oCreature, 1 );
	object oRRing = CreateItemOnObject( EQUIP_MAGIC_RRING, oCreature, 1 );
		
	IdentifyAll( oCreature );

	AssignCommand( oCreature, ActionEquipItem( oArms, INVENTORY_SLOT_ARMS ) );
	AssignCommand( oCreature, ActionEquipItem( oBelt, INVENTORY_SLOT_BELT ) );
	AssignCommand( oCreature, ActionEquipItem( oBoots, INVENTORY_SLOT_BOOTS ) );
	AssignCommand( oCreature, ActionEquipItem( oChest, INVENTORY_SLOT_CHEST ) );
	AssignCommand( oCreature, ActionEquipItem( oCloak, INVENTORY_SLOT_CLOAK ) );
	AssignCommand( oCreature, ActionEquipItem( oHead, INVENTORY_SLOT_HEAD ) );
	AssignCommand( oCreature, ActionEquipItem( oLRing, INVENTORY_SLOT_LEFTRING ) );
	AssignCommand( oCreature, ActionEquipItem( oNeck, INVENTORY_SLOT_NECK ) );
	AssignCommand( oCreature, ActionEquipItem( oRRing, INVENTORY_SLOT_RIGHTRING ) );
}

void EquipOther( object oCreature )
{
	UnequipAll( oCreature );
	
	object oArms = CreateItemOnObject( EQUIP_OTHER_ARMS, oCreature, 1 );
	object oBelt = CreateItemOnObject( EQUIP_OTHER_BELT, oCreature, 1 );
	object oBoots = CreateItemOnObject( EQUIP_OTHER_BOOTS, oCreature, 1 );
	object oChest = CreateItemOnObject( EQUIP_OTHER_CHEST, oCreature, 1 );
	object oCloak = CreateItemOnObject( EQUIP_OTHER_CLOAK, oCreature, 1 );
	object oHead = CreateItemOnObject( EQUIP_OTHER_HEAD, oCreature, 1 );
	object oLRing = CreateItemOnObject( EQUIP_OTHER_LRING, oCreature, 1 );
	object oNeck = CreateItemOnObject( EQUIP_OTHER_NECK, oCreature, 1 );
	object oRRing = CreateItemOnObject( EQUIP_OTHER_RRING, oCreature, 1 );
	
	IdentifyAll( oCreature );

	AssignCommand( oCreature, ActionEquipItem( oArms, INVENTORY_SLOT_ARMS ) );
	AssignCommand( oCreature, ActionEquipItem( oBelt, INVENTORY_SLOT_BELT ) );
	AssignCommand( oCreature, ActionEquipItem( oBoots, INVENTORY_SLOT_BOOTS ) );
	AssignCommand( oCreature, ActionEquipItem( oChest, INVENTORY_SLOT_CHEST ) );
	AssignCommand( oCreature, ActionEquipItem( oCloak, INVENTORY_SLOT_CLOAK ) );
	AssignCommand( oCreature, ActionEquipItem( oHead, INVENTORY_SLOT_HEAD ) );
	AssignCommand( oCreature, ActionEquipItem( oLRing, INVENTORY_SLOT_LEFTRING ) );
	AssignCommand( oCreature, ActionEquipItem( oNeck, INVENTORY_SLOT_NECK ) );
	AssignCommand( oCreature, ActionEquipItem( oRRing, INVENTORY_SLOT_RIGHTRING ) );
}

void EquipWeapon( object oCompanion )
{
	string sTag = GetTag( oCompanion );
	object oWeapon;
	
	if ( sTag == "ammon_jerro" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_AMMON, oCompanion, 1 );
	}
	else if ( sTag == "bishop" )
	{
		//oWeapon = CreateItemOnObject( EQUIP_WEAPON_BISHOP, oCompanion, 1 );
	}
	else if ( sTag == "casavir" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_CASAVIR, oCompanion, 1 );
	}
	else if ( sTag == "khelgar" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_KHELGAR, oCompanion, 1 );
	}
	else if ( sTag == "grobnar" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_GROBNAR, oCompanion, 1 );
	}
	else if ( sTag == "elanee" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_ELANEE, oCompanion, 1 );
	}
	else if ( sTag == "qara" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_QARA, oCompanion, 1 );
	}
	else if ( sTag == "sand" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_SAND, oCompanion, 1 );
	}
	else if ( sTag == "zhjaeve" )
	{
		oWeapon = CreateItemOnObject( EQUIP_WEAPON_ZHJAEVE, oCompanion, 1 );
	}
	
	SetIdentified( oWeapon, TRUE );
	AssignCommand( oCompanion, ActionEquipItem( oWeapon, INVENTORY_SLOT_RIGHTHAND ) );
}

void Equip( object oCreature )
{
	int nClass = 0;
	int nMelee = GetMeleeLevels( oCreature );
	int nMagic = GetMagicLevels( oCreature );
	int nOther = GetOtherLevels( oCreature );
	
	if ( ( nMagic > nMelee ) && ( nMagic > nOther ) )
	{
		nClass = 1;
	}
	
	if ( ( nOther > nMelee ) && ( nOther > nMagic ) ) 
	{
		nClass = 2;
	}
	
	switch ( nClass )
	{
		case 0:
			EquipMelee( oCreature );
			break;
		case 1:
			EquipMagic( oCreature );
			break;
		case 2:
			EquipOther( oCreature );
			break;		
	}
	
	EquipWeapon( oCreature );
}

void main()
{
	PrettyDebug( "gr_equip_comps: equiping companions with high level gear" );
	
	object oPC = GetFirstPC();
	object oFM = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid(oFM) )
	{
		// Give all roster members in party some equipment
		if ( GetIsRosterMember(oFM) == TRUE )
		{
			Equip( oFM );
		}
		oFM = GetNextFactionMember( oPC, FALSE );
	}
}