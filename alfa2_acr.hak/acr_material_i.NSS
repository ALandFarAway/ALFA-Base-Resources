////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_material_i
//       Author : Paazin
//
//  Description
//  This library is intended for use with ALFA's systems of item materials.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int  GMATERIAL_INVALID = -1;
const int  GMATERIAL_ARANDUR = 13;
const int  GMATERIAL_ASTRAL_DRIFTMETAL = 14;
const int  GMATERIAL_BLUEWOOD = 15;
const int  GMATERIAL_COPPER = 16;
const int  GMATERIAL_DLARUN = 17;
const int  GMATERIAL_DRAGONFANG = 18;
const int  GMATERIAL_FEVER_IRON = 19;
const int  GMATERIAL_FIENDBONE = 20;
const int  GMATERIAL_FRYSTALLINE = 21;
const int  GMATERIAL_GOLD = 22;
const int  GMATERIAL_HIZAGKUUR = 23;
const int  GMATERIAL_LIVING_METAL = 24;
const int  GMATERIAL_PANDEMONIC_SILVER = 25;
const int  GMATERIAL_PLATINUM = 26;
const int  GMATERIAL_SERREN = 27;
const int  GMATERIAL_SONDARR = 28;
const int  GMATERIAL_SUZAILIAN_CHAINWEAVE = 29;
const int  GMATERIAL_CREATURE_BLACK_DRAGON = 30;
const int  GMATERIAL_CREATURE_BLUE_DRAGON = 31;
const int  GMATERIAL_CREATURE_GREEN_DRAGON = 32;
const int  GMATERIAL_CREATURE_WHITE_DRAGON = 33;
const int  GMATERIAL_CREATURE_BRASS_DRAGON = 34;
const int  GMATERIAL_CREATURE_BRONZE_DRAGON = 35;
const int  GMATERIAL_CREATURE_COPPER_DRAGON = 36;
const int  GMATERIAL_CREATURE_GOLD_DRAGON = 37;
const int  GMATERIAL_CREATURE_SILVER_DRAGON = 38;
const int  GMATERIAL_CREATURE_BULETTE = 39;
const int  GMATERIAL_CREATURE_ANKHEG = 40;
const int  GMATERIAL_CREATURE_DRAGONHIDE = 41;
const int  GMATERIAL_LEATHER_NONSPECIFIC = 42;
const int  GMATERIAL_METAL_STEEL = 43;
const int  GMATERIAL_METAL_BRONZE = 44;
const int  GMATERIAL_METAL_BRASS = 45;
const int  GMATERIAL_METAL_TIN = 46;
const int  GMATERIAL_METAL_LEAD = 47;
const int  GMATERIAL_METAL_PEWTER = 48;
const int  GMATERIAL_METAL_ELECTRUM = 49;
const int  GMATERIAL_METAL_NONSPECIFIC = 50;
const int  GMATERIAL_STONE_JADE = 51;
const int  GMATERIAL_STONE_OBSIDIAN = 52;
const int  GMATERIAL_STONE_NONSPECIFIC = 53;
const int  GMATERIAL_EARTHENWARE_NONSPECIFIC = 54;
const int  GMATERIAL_WOOD_NONSPECIFIC = 55;
const int  GMATERIAL_CLOTH_NONSPECIFIC = 56;
const int  GMATERIAL_BONE_NONSPECIFIC = 57;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Returns TRUE if this material is of a wooden type
void isMaterialWooden(int nMaterialType, int bAssumeWoodenIfUnset);

// Returns TRUE if this material is of a metal type
void isMaterialMetal(int nMaterialType, int bAssumeMetalIfUnset);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int IsMaterialWooden(int nMaterialType, int bAssumeWoodenIfUnset = TRUE)
{
    if (nMaterialType == GMATERIAL_NONSPECIFIC) {
        return bAssumeWoodenIfUnset;
    }

    return (
        nMaterialType == GMATERIAL_WOOD_DUSKWOOD ||
        nMaterialType == GMATERIAL_WOOD_DARKWOOD ||
        nMaterialType == GMATERIAL_BLUEWOOD ||
        nMaterialType == GMATERIAL_SERREN ||
        nMaterialType == GMATERIAL_WOOD_NONSPECIFIC
    );
}


int IsMaterialMetal(int nMaterialType, int bAssumeMetalIfUnset = TRUE)
{
    if (nMaterialType == GMATERIAL_NONSPECIFIC) {
        return bAssumeMetalIfUnset;
    }

    return (
        nMaterialType == GMATERIAL_METAL_ADAMANTINE ||
        nMaterialType == GMATERIAL_METAL_COLD_IRON ||
        nMaterialType == GMATERIAL_METAL_DARKSTEEL ||
        nMaterialType == GMATERIAL_METAL_IRON ||
        nMaterialType == GMATERIAL_METAL_MITHRAL ||
        nMaterialType == GMATERIAL_METAL_ALCHEMICAL_SILVER ||
        nMaterialType == GMATERIAL_ARANDUR ||
        nMaterialType == GMATERIAL_ASTRAL_DRIFTMETAL ||
        nMaterialType == GMATERIAL_COPPER ||
        nMaterialType == GMATERIAL_DLARUN ||
        nMaterialType == GMATERIAL_FEVER_IRON ||
        nMaterialType == GMATERIAL_GOLD ||
        nMaterialType == GMATERIAL_HIZAGKUUR ||
        nMaterialType == GMATERIAL_LIVING_METAL ||
        nMaterialType == GMATERIAL_PANDEMONIC_SILVER ||
        nMaterialType == GMATERIAL_PLATINUM ||
        nMaterialType == GMATERIAL_SUZAILIAN_CHAINWEAVE ||
        nMaterialType == GMATERIAL_METAL_STEEL ||
        nMaterialType == GMATERIAL_METAL_BRONZE ||
        nMaterialType == GMATERIAL_METAL_BRASS ||
        nMaterialType == GMATERIAL_METAL_TIN ||
        nMaterialType == GMATERIAL_METAL_LEAD ||
        nMaterialType == GMATERIAL_METAL_PEWTER ||
        nMaterialType == GMATERIAL_METAL_ELECTRUM ||
        nMaterialType == GMATERIAL_METAL_NONSPECIFIC
    );
}
