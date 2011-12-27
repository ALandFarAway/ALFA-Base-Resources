//---------------------------------------------------------------------
//                     Constants
//---------------------------------------------------------------------

const int VARIABLE_INVALID_INDEX			= -1;

const int ARMOR_INVALID						= -1;
const int ARMOR_CLOTH						= 0;
const int ARMOR_CLOTH_PADDED				= 1;
const int ARMOR_LEATHER						= 2;
const int ARMOR_LEATHER_STUDDED				= 3;
const int ARMOR_CHAIN_SHIRT					= 4;
const int ARMOR_SCALE						= 5;
const int ARMOR_BANDED						= 6;
const int ARMOR_HALF_PLATE					= 7;
const int ARMOR_FULL_PLATE					= 8;
const int ARMOR_HIDE						= 12;
const int ARMOR_CHAIN_MAIL					= 13;
const int ARMOR_BREASTPLATE					= 14;
const int ARMOR_SPLINT						= 15;
const int ARMOR_CHAIN_SHIRT_MITHRAL			= 16;
const int ARMOR_SCALE_MITHRAL				= 17;
const int ARMOR_BANDED_MITHRAL				= 18;
const int ARMOR_HALF_PLATE_MITHRAL			= 19;
const int ARMOR_FULL_PLATE_MITHRAL			= 20;
const int ARMOR_CHAIN_MAIL_MITHRAL			= 21;
const int ARMOR_BREASTPLATE_MITHRAL			= 22;
const int ARMOR_SPLINT_MITHRAL				= 23;
const int ARMOR_CLOTH_PADDED_MASTERWORK		= 24;
const int ARMOR_LEATHER_MASTERWORK			= 25;
const int ARMOR_LEATHER_STUDDED_MASTERWORK	= 26;
const int ARMOR_CHAIN_SHIRT_MASTERWORK		= 27;
const int ARMOR_HIDE_MASTERWORK				= 28;
const int ARMOR_SCALE_MASTERWORK			= 29;
const int ARMOR_BREASTPLATE_MASTERWORK		= 30;
const int ARMOR_CHAIN_MAIL_MASTERWORK		= 31;
const int ARMOR_SPLINT_MASTERWORK			= 32;
const int ARMOR_BANDED_MASTERWORK			= 33;
const int ARMOR_HALF_PLATE_MASTERWORK		= 34;
const int ARMOR_FULL_PLATE_MASTERWORK		= 35;

const int ARMOR_WEIGHT_INVALID						= -1;
const int ARMOR_WEIGHT_CLOTH						= 70;
const int ARMOR_WEIGHT_CLOTH_PADDED					= 100;
const int ARMOR_WEIGHT_LEATHER						= 145;
const int ARMOR_WEIGHT_LEATHER_STUDDED				= 195;
const int ARMOR_WEIGHT_CHAIN_SHIRT					= 245;
const int ARMOR_WEIGHT_SCALE						= 300;
const int ARMOR_WEIGHT_BANDED						= 350;
const int ARMOR_WEIGHT_HALF_PLATE					= 470;
const int ARMOR_WEIGHT_FULL_PLATE					= 500;
const int ARMOR_WEIGHT_HIDE							= 230;
const int ARMOR_WEIGHT_CHAIN_MAIL					= 400;
const int ARMOR_WEIGHT_BREASTPLATE					= 320;
const int ARMOR_WEIGHT_SPLINT						= 450;
const int ARMOR_WEIGHT_CHAIN_SHIRT_MITHRAL			= 125;
const int ARMOR_WEIGHT_SCALE_MITHRAL				= 150;
const int ARMOR_WEIGHT_BANDED_MITHRAL				= 175;
const int ARMOR_WEIGHT_HALF_PLATE_MITHRAL			= 235;
const int ARMOR_WEIGHT_FULL_PLATE_MITHRAL			= 250;
const int ARMOR_WEIGHT_CHAIN_MAIL_MITHRAL			= 200;
const int ARMOR_WEIGHT_BREASTPLATE_MITHRAL			= 160;
const int ARMOR_WEIGHT_SPLINT_MITHRAL				= 225;
const int ARMOR_WEIGHT_CLOTH_PADDED_MASTERWORK		= 95;
const int ARMOR_WEIGHT_LEATHER_MASTERWORK			= 147;
const int ARMOR_WEIGHT_LEATHER_STUDDED_MASTERWORK	= 197;
const int ARMOR_WEIGHT_CHAIN_SHIRT_MASTERWORK		= 240;
const int ARMOR_WEIGHT_HIDE_MASTERWORK				= 227;
const int ARMOR_WEIGHT_SCALE_MASTERWORK				= 297;
const int ARMOR_WEIGHT_BREASTPLATE_MASTERWORK		= 395;
const int ARMOR_WEIGHT_CHAIN_MAIL_MASTERWORK		= 315;
const int ARMOR_WEIGHT_SPLINT_MASTERWORK			= 445;
const int ARMOR_WEIGHT_BANDED_MASTERWORK			= 345;
const int ARMOR_WEIGHT_HALF_PLATE_MASTERWORK		= 465;
const int ARMOR_WEIGHT_FULL_PLATE_MASTERWORK		= 495;

//---------------------------------------------------------------------
//                     Interface
//---------------------------------------------------------------------


// Distrugge un qualunque oggetto e tutto ciò in esso contenuto
void DestroyObjectSafe (object oTarget);

// Ritorna TRUE se nell'area non sono presenti PG
int IsPcEmptyArea(object oArea = OBJECT_SELF);

// Ritorna TRUE se il giocatore è un DM
int IsDm (object oPc);

//---------------------------------------------------------------------
//                     Implementation
//---------------------------------------------------------------------

/*********************************************************************/
/*********************************************************************/
void ClearInventory(object oTarget) {

	object oItem = GetFirstItemInInventory(oTarget);
	
	while (GetIsObjectValid(oItem)) {
	
		DelayCommand(0.0, DestroyObjectSafe (oItem));
		oItem = GetNextItemInInventory(oTarget);
	}
	return;
}

/*********************************************************************/
/*********************************************************************/
void DestroyObjectSafe (object oTarget) {

	SetPlotFlag(oTarget,FALSE);
    SetImmortal(oTarget,FALSE);
    AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
	ClearInventory(oTarget);
	DestroyObject(oTarget, 0.0, FALSE);
}

/*********************************************************************/
/*********************************************************************/
int IsPcEmptyArea(object oArea = OBJECT_SELF) {
    
	location lChecker = GetLocation(GetFirstObjectInArea(oArea));
    object oPC = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,lChecker);

    if (GetIsObjectValid(oPC))
        return FALSE;

    return TRUE;
}

/*********************************************************************/
/*********************************************************************/
void ShoutDisturbed(object oDoor, object oAttacker, float fRadius)
{
	location lMyLocation = GetLocation(oDoor);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lMyLocation, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget)) {
	
		if (GetFactionEqual(oTarget, oDoor) == TRUE) {
			// * Make anyone who is a member of my faction hostile if I am violated
		    SetIsTemporaryEnemy(oAttacker, oTarget);
		    AssignCommand(oTarget, ActionAttack(oAttacker));
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lMyLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
   
}

/*********************************************************************/
/*********************************************************************/
int GetArmorType (object oArmor) {
	
	if (GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
		return ARMOR_INVALID;
	
	int iWeight = GetWeight(oArmor);		
	switch (iWeight) {
		case ARMOR_WEIGHT_CLOTH							: return ARMOR_CLOTH;						
		case ARMOR_WEIGHT_CLOTH_PADDED					: return ARMOR_CLOTH_PADDED;
		case ARMOR_WEIGHT_LEATHER						: return ARMOR_LEATHER;
		case ARMOR_WEIGHT_LEATHER_STUDDED				: return ARMOR_LEATHER_STUDDED;
		case ARMOR_WEIGHT_CHAIN_SHIRT					: return ARMOR_CHAIN_SHIRT;
		case ARMOR_WEIGHT_SCALE							: return ARMOR_SCALE;
		case ARMOR_WEIGHT_BANDED						: return ARMOR_BANDED;
		case ARMOR_WEIGHT_HALF_PLATE					: return ARMOR_HALF_PLATE;
		case ARMOR_WEIGHT_FULL_PLATE					: return ARMOR_FULL_PLATE;
		case ARMOR_WEIGHT_HIDE							: return ARMOR_HIDE;
		case ARMOR_WEIGHT_CHAIN_MAIL					: return ARMOR_CHAIN_MAIL;
		case ARMOR_WEIGHT_BREASTPLATE					: return ARMOR_BREASTPLATE;
		case ARMOR_WEIGHT_SPLINT						: return ARMOR_SPLINT;
		case ARMOR_WEIGHT_CHAIN_SHIRT_MITHRAL			: return ARMOR_CHAIN_SHIRT_MITHRAL;
		case ARMOR_WEIGHT_SCALE_MITHRAL					: return ARMOR_SCALE_MITHRAL;
		case ARMOR_WEIGHT_BANDED_MITHRAL				: return ARMOR_BANDED_MITHRAL;
		case ARMOR_WEIGHT_HALF_PLATE_MITHRAL			: return ARMOR_HALF_PLATE_MITHRAL;
		case ARMOR_WEIGHT_FULL_PLATE_MITHRAL			: return ARMOR_FULL_PLATE_MITHRAL;
		case ARMOR_WEIGHT_CHAIN_MAIL_MITHRAL			: return ARMOR_CHAIN_MAIL_MITHRAL;
		case ARMOR_WEIGHT_BREASTPLATE_MITHRAL			: return ARMOR_BREASTPLATE_MITHRAL;
		case ARMOR_WEIGHT_SPLINT_MITHRAL				: return ARMOR_SPLINT_MITHRAL;
		case ARMOR_WEIGHT_CLOTH_PADDED_MASTERWORK		: return ARMOR_CLOTH_PADDED_MASTERWORK;
		case ARMOR_WEIGHT_LEATHER_MASTERWORK			: return ARMOR_LEATHER_MASTERWORK;
		case ARMOR_WEIGHT_LEATHER_STUDDED_MASTERWORK	: return ARMOR_LEATHER_STUDDED_MASTERWORK;
		case ARMOR_WEIGHT_CHAIN_SHIRT_MASTERWORK		: return ARMOR_CHAIN_SHIRT_MASTERWORK;
		case ARMOR_WEIGHT_HIDE_MASTERWORK				: return ARMOR_HIDE_MASTERWORK;
		case ARMOR_WEIGHT_SCALE_MASTERWORK				: return ARMOR_SCALE_MASTERWORK;
		case ARMOR_WEIGHT_BREASTPLATE_MASTERWORK		: return ARMOR_BREASTPLATE_MASTERWORK;
		case ARMOR_WEIGHT_CHAIN_MAIL_MASTERWORK			: return ARMOR_CHAIN_MAIL_MASTERWORK;
		case ARMOR_WEIGHT_SPLINT_MASTERWORK				: return ARMOR_SPLINT_MASTERWORK;
		case ARMOR_WEIGHT_BANDED_MASTERWORK				: return ARMOR_BANDED_MASTERWORK;
		case ARMOR_WEIGHT_HALF_PLATE_MASTERWORK			: return ARMOR_HALF_PLATE_MASTERWORK;
		case ARMOR_WEIGHT_FULL_PLATE_MASTERWORK			: return ARMOR_FULL_PLATE_MASTERWORK;
		default: return ARMOR_INVALID;		
	}	
	return ARMOR_INVALID;
}

/*********************************************************************/
/*********************************************************************/
int IsDm (object oPc) {
	return (GetIsDM(oPc) || GetIsDMPossessed(oPc));
}

/*********************************************************************/
/*********************************************************************/
object GetLastDraggedItem (object oPc) {
	return GetLocalObject(oPc, "LAST_DRAGGED_ITEM");
}

/*********************************************************************/
/*********************************************************************/
string MyFloatToString(float fFloat) {
	string sIntPart = IntToString(FloatToInt(fFloat));	
	string sFloat = FloatToString(fFloat);
	int iCommaPos = FindSubString(sFloat, ".");
	return sIntPart + GetSubString(sFloat, iCommaPos, GetStringLength(sFloat) - iCommaPos);	
}

/*********************************************************************/
/*********************************************************************/
// Ritorna VARIABLE_INVALID_INDEX le la variabile non è presente su oTarget
int GetVariableIndex (object oTarget, string sVarName, int VarType) {

	int iVarIndex = 0;
	int iVariableType = GetVariableType(oTarget, iVarIndex);
		
	while (iVariableType != VARIABLE_TYPE_NONE) {
	
		if (GetVariableName(oTarget, iVarIndex) == sVarName
			&& iVariableType == VarType) {
			return iVarIndex;
		}

		iVariableType = GetVariableType(oTarget, ++iVarIndex);
	}
	
	return VARIABLE_INVALID_INDEX;
}

/*********************************************************************/
/*********************************************************************/
// Ritorna -1 se l'oggetto non è indossato
int GetSlotItemEquippedIn (object oPc, object oItem) {
	int iIndex;
	
	for (iIndex = 0; iIndex < NUM_INVENTORY_SLOTS; iIndex++) {
		if (oItem == GetItemInSlot(iIndex, oPc))
			return iIndex;
	}
	
	return -1;
}

/*********************************************************************/
/*********************************************************************/
string GetItemIconResRef(object oItem) { 
	string sIcon = Get2DAString("nwn2_icons", "ICON", GetItemIcon(oItem)); 
	return sIcon == "" ? "temp0.tga" : sIcon + ".tga"; 
}