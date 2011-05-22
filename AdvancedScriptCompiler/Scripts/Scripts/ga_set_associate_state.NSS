// ga_set_associate_state(int nFlag, int bState, string sTarget)
/*

	Sets Associate State flag.  See below for list of flags.  
	Some flags should probably not be altered by this script.

*/
// ChazM


/*
From x0_i0_assoc.nss:

//Distance
const int NW_ASC_DISTANCE_2_METERS =   0x00000001;		1
const int NW_ASC_DISTANCE_4_METERS =   0x00000002;		2
const int NW_ASC_DISTANCE_6_METERS =   0x00000004;		4

// Percentage of master's damage at which the
// assoc will try to heal them.
const int NW_ASC_HEAL_AT_75 =          0x00000008;		8
const int NW_ASC_HEAL_AT_50 =          0x00000010;		16
const int NW_ASC_HEAL_AT_25 =          0x00000020;		32

//Auto AI
const int NW_ASC_AGGRESSIVE_BUFF =     0x00000040;		64
const int NW_ASC_AGGRESSIVE_SEARCH =   0x00000080;		128
const int NW_ASC_AGGRESSIVE_STEALTH =  0x00000100;		256

//Open Locks on master fail
const int NW_ASC_RETRY_OPEN_LOCKS =    0x00000200;		512

//Casting power
const int NW_ASC_OVERKIll_CASTING =    0x00000400; 		1024	// GetMax Spell
const int NW_ASC_POWER_CASTING =       0x00000800; 		2048	// Get Double CR or max 4 casting
const int NW_ASC_SCALED_CASTING =      0x00001000; 		4096	// CR + 4;

const int NW_ASC_USE_CUSTOM_DIALOGUE = 0x00002000;		8192
const int NW_ASC_DISARM_TRAPS =        0x00004000;		16384
const int NW_ASC_USE_RANGED_WEAPON   = 0x00008000;		32768

// Playing Dead mode, used to make sure the associate is
// not targeted while dying.
const int NW_ASC_MODE_DYING          = 0x00010000;		65536

//Guard Me Mode, Attack Nearest sets this to FALSE.
const int NW_ASC_MODE_DEFEND_MASTER =  0x04000000;		67108864

//The Henchman will ignore move to object in their OnHeartbeat.
//If this is set to FALSE then they are in follow mode.
const int NW_ASC_MODE_STAND_GROUND =   0x08000000;		134217728

const int NW_ASC_MASTER_GONE =         0x10000000;		268435456

const int NW_ASC_MASTER_REVOKED =      0x20000000;		536870912

//Only busy if attempting to bash or pick a lock or dead
const int NW_ASC_IS_BUSY =             0x40000000;		1073741824
*/
#include "X0_I0_ASSOC"
#include "ginc_param_const"

void main(int nFlag, int bState, string sTarget)
{
	object oAssoc = GetTarget(sTarget);
	
	SetAssociateState(nFlag, bState, oAssoc);
}