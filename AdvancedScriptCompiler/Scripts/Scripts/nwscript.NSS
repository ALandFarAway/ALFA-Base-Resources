//////////////////////////////////////////////////////////
//
//  NWScript
//
//  The list of actions and pre-defined constants.
//
//  (c) BioWare Corp, 1999
//
////////////////////////////////////////////////////////

#define ENGINE_NUM_STRUCTURES   5
#define ENGINE_STRUCTURE_0      effect
#define ENGINE_STRUCTURE_1      event
#define ENGINE_STRUCTURE_2      location
#define ENGINE_STRUCTURE_3      talent
#define ENGINE_STRUCTURE_4      itemproperty

// Constants

int    NUM_INVENTORY_SLOTS      = 18;

int    TRUE                     = 1;
int    FALSE                    = 0;

float  DIRECTION_EAST           = 0.0;
float  DIRECTION_NORTH          = 90.0;
float  DIRECTION_WEST           = 180.0;
float  DIRECTION_SOUTH          = 270.0;
float  PI                       = 3.141592;

int    ATTITUDE_NEUTRAL         = 0;
int    ATTITUDE_AGGRESSIVE      = 1;
int    ATTITUDE_DEFENSIVE       = 2;
int    ATTITUDE_SPECIAL         = 3;

int    TALKVOLUME_TALK          = 0;
int    TALKVOLUME_WHISPER       = 1;
int    TALKVOLUME_SHOUT         = 2;
int    TALKVOLUME_SILENT_TALK   = 3;
int    TALKVOLUME_SILENT_SHOUT  = 4;

int    INVENTORY_SLOT_HEAD      = 0;
int    INVENTORY_SLOT_CHEST     = 1;
int    INVENTORY_SLOT_BOOTS     = 2;
int    INVENTORY_SLOT_ARMS      = 3;
int    INVENTORY_SLOT_RIGHTHAND = 4;
int    INVENTORY_SLOT_LEFTHAND  = 5;
int    INVENTORY_SLOT_CLOAK     = 6;
int    INVENTORY_SLOT_LEFTRING  = 7;
int    INVENTORY_SLOT_RIGHTRING = 8;
int    INVENTORY_SLOT_NECK      = 9;
int    INVENTORY_SLOT_BELT      = 10;
int    INVENTORY_SLOT_ARROWS    = 11;
int    INVENTORY_SLOT_BULLETS   = 12;
int    INVENTORY_SLOT_BOLTS     = 13;
int    INVENTORY_SLOT_CWEAPON_L = 14;
int    INVENTORY_SLOT_CWEAPON_R = 15;
int    INVENTORY_SLOT_CWEAPON_B = 16;
int    INVENTORY_SLOT_CARMOUR   = 17;

//Effect type constants
int    DURATION_TYPE_INSTANT    = 0;
int    DURATION_TYPE_TEMPORARY  = 1;
int    DURATION_TYPE_PERMANENT  = 2;

int    SUBTYPE_MAGICAL          = 8;
int    SUBTYPE_SUPERNATURAL     = 16;
int    SUBTYPE_EXTRAORDINARY    = 24;

int    ABILITY_STRENGTH         = 0; // should be the same as in nwseffectlist.cpp
int    ABILITY_DEXTERITY        = 1;
int    ABILITY_CONSTITUTION     = 2;
int    ABILITY_INTELLIGENCE     = 3;
int    ABILITY_WISDOM           = 4;
int    ABILITY_CHARISMA         = 5;

int    SHAPE_SPELLCYLINDER      = 0;
int    SHAPE_CONE               = 1;
int    SHAPE_CUBE               = 2;
int    SHAPE_SPELLCONE          = 3;
int    SHAPE_SPHERE             = 4;

int    METAMAGIC_NONE                    = 0;
int    METAMAGIC_EMPOWER                 = 1;
int    METAMAGIC_EXTEND                  = 2;
int    METAMAGIC_MAXIMIZE                = 4;
int    METAMAGIC_QUICKEN                 = 8;
int    METAMAGIC_SILENT                  = 16;
int    METAMAGIC_STILL                   = 32;
// JLR - OEI 08/19/05 -- New Metamagic Types
int    METAMAGIC_PERSISTENT              = 64;
int    METAMAGIC_PERMANENT               = 128;
int    METAMAGIC_INVOC_DRAINING_BLAST    = 256;
int    METAMAGIC_INVOC_ELDRITCH_SPEAR    = 512;
int    METAMAGIC_INVOC_FRIGHTFUL_BLAST   = 1024;
int    METAMAGIC_INVOC_HIDEOUS_BLOW      = 2048;
int    METAMAGIC_INVOC_BESHADOWED_BLAST  = 4096;
int    METAMAGIC_INVOC_BRIMSTONE_BLAST   = 8192;
int    METAMAGIC_INVOC_ELDRITCH_CHAIN    = 16384;
int    METAMAGIC_INVOC_HELLRIME_BLAST    = 32768;
int    METAMAGIC_INVOC_BEWITCHING_BLAST  = 65536;
int    METAMAGIC_INVOC_ELDRITCH_CONE     = 131072;
int    METAMAGIC_INVOC_NOXIOUS_BLAST     = 262144;
int    METAMAGIC_INVOC_VITRIOLIC_BLAST   = 524288;
int    METAMAGIC_INVOC_ELDRITCH_DOOM     = 1048576;
int    METAMAGIC_INVOC_UTTERDARK_BLAST   = 2097152;
int    METAMAGIC_INVOC_HINDERING_BLAST   = 4194304; // AFW-OEI 05/07/2007
int    METAMAGIC_INVOC_BINDING_BLAST     = 8388608; // AFW-OEI 05/07/2007
int    METAMAGIC_ANY                     = 4294967295;
//int    METAMAGIC_ANY                     = 255;


int    OBJECT_TYPE_CREATURE         = 1;
int    OBJECT_TYPE_ITEM             = 2;
int    OBJECT_TYPE_TRIGGER          = 4;
int    OBJECT_TYPE_DOOR             = 8;
int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
int    OBJECT_TYPE_WAYPOINT         = 32;
int    OBJECT_TYPE_PLACEABLE        = 64;
int    OBJECT_TYPE_STORE            = 128;
int    OBJECT_TYPE_ENCOUNTER        = 256;
int    OBJECT_TYPE_LIGHT            = 512;
int    OBJECT_TYPE_PLACED_EFFECT    = 1024;
int    OBJECT_TYPE_ALL              = 32767;

int    OBJECT_TYPE_INVALID          = 32767;

int    GENDER_MALE    = 0;
int    GENDER_FEMALE  = 1;
int    GENDER_BOTH    = 2;
int    GENDER_OTHER   = 3;
int    GENDER_NONE    = 4;


// Damage Reduction Types (3.5)
int    DR_TYPE_NONE                 = 0;
int    DR_TYPE_DMGTYPE              = 1;
int    DR_TYPE_MAGICBONUS           = 2;
int    DR_TYPE_EPIC                 = 3;
int    DR_TYPE_GMATERIAL            = 4;
int    DR_TYPE_ALIGNMENT            = 5;
int    DR_TYPE_NON_RANGED           = 6;


// Material Types (3.5) -- For Damage Reduction
int    GMATERIAL_NONSPECIFIC               = 0;
int    GMATERIAL_METAL_ADAMANTINE          = 1;
int    GMATERIAL_METAL_COLD_IRON           = 2;
int    GMATERIAL_METAL_DARKSTEEL           = 3;
int    GMATERIAL_METAL_IRON                = 4;
int    GMATERIAL_METAL_MITHRAL             = 5;
int    GMATERIAL_METAL_ALCHEMICAL_SILVER   = 6;
int    GMATERIAL_WOOD_DUSKWOOD             = 7;
int    GMATERIAL_WOOD_DARKWOOD             = 8;
int    GMATERIAL_CREATURE_RED_DRAGON       = 9;
int    GMATERIAL_CREATURE_SALAMANDER       = 10;
int    GMATERIAL_CREATURE_UMBER_HULK       = 11;
int    GMATERIAL_CREATURE_WYVERN           = 12;


// Damage Types
int    DAMAGE_TYPE_ALL          = 0;    // AFW-OEI 06/07/2007: Deprecated.  May function correctly for EffectDamage(); results are undefined for EffectDamageImmunity() and EffectDamageResistance().
int    DAMAGE_TYPE_BLUDGEONING  = 1;
int    DAMAGE_TYPE_PIERCING     = 2;
int    DAMAGE_TYPE_SLASHING     = 4;
int    DAMAGE_TYPE_MAGICAL      = 8;
int    DAMAGE_TYPE_ACID         = 16;
int    DAMAGE_TYPE_COLD         = 32;
int    DAMAGE_TYPE_DIVINE       = 64;
int    DAMAGE_TYPE_ELECTRICAL   = 128;
int    DAMAGE_TYPE_FIRE         = 256;
int    DAMAGE_TYPE_NEGATIVE     = 512;
int    DAMAGE_TYPE_POSITIVE     = 1024;
int    DAMAGE_TYPE_SONIC        = 2048;

// Special versus flag just for AC effects
int    AC_VS_DAMAGE_TYPE_ALL    = 4103;

int    DAMAGE_BONUS_1           = 1;
int    DAMAGE_BONUS_2           = 2;
int    DAMAGE_BONUS_3           = 3;
int    DAMAGE_BONUS_4           = 4;
int    DAMAGE_BONUS_5           = 5;
int    DAMAGE_BONUS_1d4         = 6;
int    DAMAGE_BONUS_1d6         = 7;
int    DAMAGE_BONUS_1d8         = 8;
int    DAMAGE_BONUS_1d10        = 9;
int    DAMAGE_BONUS_2d6         = 10;
int    DAMAGE_BONUS_2d8         = 11;
int    DAMAGE_BONUS_2d4         = 12;
int    DAMAGE_BONUS_2d10        = 13;
int    DAMAGE_BONUS_1d12        = 14;
int    DAMAGE_BONUS_2d12        = 15;
int    DAMAGE_BONUS_6           = 16;
int    DAMAGE_BONUS_7           = 17;
int    DAMAGE_BONUS_8           = 18;
int    DAMAGE_BONUS_9           = 19;
int    DAMAGE_BONUS_10          = 20;
int    DAMAGE_BONUS_11          = 21;
int    DAMAGE_BONUS_12          = 22;
int    DAMAGE_BONUS_13          = 23;
int    DAMAGE_BONUS_14          = 24;
int    DAMAGE_BONUS_15          = 25;
int    DAMAGE_BONUS_16          = 26;
int    DAMAGE_BONUS_17          = 27;
int    DAMAGE_BONUS_18          = 28;
int    DAMAGE_BONUS_19          = 29;
int    DAMAGE_BONUS_20          = 30;
int    DAMAGE_BONUS_21          = 31;   // AFW-OEI 02/08/2007: Need more damage bonus numbers.
int    DAMAGE_BONUS_22          = 32;
int    DAMAGE_BONUS_23          = 33;
int    DAMAGE_BONUS_24          = 34;
int    DAMAGE_BONUS_25          = 35;
int    DAMAGE_BONUS_26          = 36;
int    DAMAGE_BONUS_27          = 37;
int    DAMAGE_BONUS_28          = 38;
int    DAMAGE_BONUS_29          = 39;
int    DAMAGE_BONUS_30          = 40;
int    DAMAGE_BONUS_31          = 41;
int    DAMAGE_BONUS_32          = 42;
int    DAMAGE_BONUS_33          = 43;
int    DAMAGE_BONUS_34          = 44;
int    DAMAGE_BONUS_35          = 45;
int    DAMAGE_BONUS_36          = 46;
int    DAMAGE_BONUS_37          = 47;
int    DAMAGE_BONUS_38          = 48;
int    DAMAGE_BONUS_39          = 49;
int    DAMAGE_BONUS_40          = 50;


int    DAMAGE_POWER_NORMAL         = 0;
int    DAMAGE_POWER_PLUS_ONE       = 1;
int    DAMAGE_POWER_PLUS_TWO       = 2;
int    DAMAGE_POWER_PLUS_THREE     = 3;
int    DAMAGE_POWER_PLUS_FOUR      = 4;
int    DAMAGE_POWER_PLUS_FIVE      = 5;
int    DAMAGE_POWER_ENERGY         = 6;
int    DAMAGE_POWER_PLUS_SIX       = 7;
int    DAMAGE_POWER_PLUS_SEVEN     = 8;
int    DAMAGE_POWER_PLUS_EIGHT     = 9;
int    DAMAGE_POWER_PLUS_NINE      = 10;
int    DAMAGE_POWER_PLUS_TEN       = 11;
int    DAMAGE_POWER_PLUS_ELEVEN    = 12;
int    DAMAGE_POWER_PLUS_TWELVE    = 13;
int    DAMAGE_POWER_PLUS_THIRTEEN  = 14;
int    DAMAGE_POWER_PLUS_FOURTEEN  = 15;
int    DAMAGE_POWER_PLUS_FIFTEEN   = 16;
int    DAMAGE_POWER_PLUS_SIXTEEN   = 17;
int    DAMAGE_POWER_PLUS_SEVENTEEN = 18;
int    DAMAGE_POWER_PLUS_EIGHTEEN  = 19;
int    DAMAGE_POWER_PLUS_NINTEEN   = 20;
int    DAMAGE_POWER_PLUS_TWENTY    = 21;

int    ATTACK_BONUS_MISC                = 0;
int    ATTACK_BONUS_ONHAND              = 1;
int    ATTACK_BONUS_OFFHAND             = 2;

int    AC_DODGE_BONUS                   = 0;
int    AC_NATURAL_BONUS                 = 1;
int    AC_ARMOUR_ENCHANTMENT_BONUS      = 2;
int    AC_SHIELD_ENCHANTMENT_BONUS      = 3;
int    AC_DEFLECTION_BONUS              = 4;

int    MISS_CHANCE_TYPE_NORMAL          = 0;
int    MISS_CHANCE_TYPE_VS_RANGED       = 1;
int    MISS_CHANCE_TYPE_VS_MELEE        = 2;

int    DOOR_ACTION_OPEN                 = 0;
int    DOOR_ACTION_UNLOCK               = 1;
int    DOOR_ACTION_BASH                 = 2;
int    DOOR_ACTION_IGNORE               = 3;
int    DOOR_ACTION_KNOCK                = 4;

int    PLACEABLE_ACTION_USE                  = 0;
int    PLACEABLE_ACTION_UNLOCK               = 1;
int    PLACEABLE_ACTION_BASH                 = 2;
int    PLACEABLE_ACTION_KNOCK                = 4;


int    RACIAL_TYPE_DWARF                = 0;
int    RACIAL_TYPE_ELF                  = 1;
int    RACIAL_TYPE_GNOME                = 2;
int    RACIAL_TYPE_HALFLING             = 3;
int    RACIAL_TYPE_HALFELF              = 4;
int    RACIAL_TYPE_HALFORC              = 5;
int    RACIAL_TYPE_HUMAN                = 6;
int    RACIAL_TYPE_ABERRATION           = 7;
int    RACIAL_TYPE_ANIMAL               = 8;
int    RACIAL_TYPE_BEAST                = 9;
int    RACIAL_TYPE_CONSTRUCT            = 10;
int    RACIAL_TYPE_DRAGON               = 11;
int    RACIAL_TYPE_HUMANOID_GOBLINOID   = 12;
int    RACIAL_TYPE_HUMANOID_MONSTROUS   = 13;
int    RACIAL_TYPE_HUMANOID_ORC         = 14;
int    RACIAL_TYPE_HUMANOID_REPTILIAN   = 15;
int    RACIAL_TYPE_ELEMENTAL            = 16;
int    RACIAL_TYPE_FEY                  = 17;
int    RACIAL_TYPE_GIANT                = 18;
int    RACIAL_TYPE_MAGICAL_BEAST        = 19;
int    RACIAL_TYPE_OUTSIDER             = 20;
int    RACIAL_TYPE_SHAPECHANGER         = 23;
int    RACIAL_TYPE_UNDEAD               = 24;
int    RACIAL_TYPE_VERMIN               = 25;
int    RACIAL_TYPE_ALL                  = 28;
int    RACIAL_TYPE_INVALID              = 28;
int    RACIAL_TYPE_OOZE                 = 29;
int    RACIAL_TYPE_INCORPOREAL          = 30;       // AFW-OEI 04/18/2006
int    RACIAL_TYPE_YUANTI               = 31;       // JWR-OEI 07/28/2008
int    RACIAL_TYPE_GRAYORC              = 32;       // JWR-OEI 07/28/2008


// FAK - OEI 6/24/04 added subrace defines
int    RACIAL_SUBTYPE_GOLD_DWARF        = 0;
int    RACIAL_SUBTYPE_GRAY_DWARF        = 1;
int    RACIAL_SUBTYPE_SHIELD_DWARF      = 2;
int    RACIAL_SUBTYPE_DROW              = 3;
int    RACIAL_SUBTYPE_MOON_ELF          = 4;
int    RACIAL_SUBTYPE_SUN_ELF           = 5;
int    RACIAL_SUBTYPE_WILD_ELF          = 6;
int    RACIAL_SUBTYPE_WOOD_ELF          = 7;
int    RACIAL_SUBTYPE_SVIRFNEBLIN       = 8;
int    RACIAL_SUBTYPE_ROCK_GNOME        = 9;
int    RACIAL_SUBTYPE_GHOSTWISE_HALF    = 10;
int    RACIAL_SUBTYPE_LIGHTFOOT_HALF    = 11;
int    RACIAL_SUBTYPE_STRONGHEART_HALF  = 12;
int    RACIAL_SUBTYPE_AASIMAR           = 13;
int    RACIAL_SUBTYPE_TIEFLING          = 14;
int    RACIAL_SUBTYPE_HALFELF           = 15;
int    RACIAL_SUBTYPE_HALFORC           = 16;
int    RACIAL_SUBTYPE_HUMAN             = 17;
int    RACIAL_SUBTYPE_AIR_GENASI        = 18;
int    RACIAL_SUBTYPE_EARTH_GENASI      = 19;
int    RACIAL_SUBTYPE_FIRE_GENASI       = 20;
int    RACIAL_SUBTYPE_WATER_GENASI      = 21;
int    RACIAL_SUBTYPE_ABERRATION        = 22;
int    RACIAL_SUBTYPE_ANIMAL            = 23;
int    RACIAL_SUBTYPE_BEAST             = 24;
int    RACIAL_SUBTYPE_CONSTRUCT         = 25;
int    RACIAL_SUBTYPE_HUMANOID_GOBLINOID    = 26;
int    RACIAL_SUBTYPE_HUMANOID_MONSTROUS    = 27;
int    RACIAL_SUBTYPE_HUMANOID_ORC          = 28;
int    RACIAL_SUBTYPE_HUMANOID_REPTILIAN    = 29;
int    RACIAL_SUBTYPE_ELEMENTAL         = 30;
int    RACIAL_SUBTYPE_FEY               = 31;
int    RACIAL_SUBTYPE_GIANT             = 32;
int    RACIAL_SUBTYPE_OUTSIDER          = 33;
int    RACIAL_SUBTYPE_SHAPECHANGER      = 34;
int    RACIAL_SUBTYPE_UNDEAD            = 35;
int    RACIAL_SUBTYPE_VERMIN            = 36;
int    RACIAL_SUBTYPE_OOZE              = 37;
int    RACIAL_SUBTYPE_DRAGON            = 38;
int    RACIAL_SUBTYPE_MAGICAL_BEAST     = 39;
int    RACIAL_SUBTYPE_INCORPOREAL       = 40;   // AFW-OEI 04/18/2006
int    RACIAL_SUBTYPE_GITHYANKI         = 41;   // BMA-OEI 09/11/2006
int    RACIAL_SUBTYPE_GITHZERAI         = 42;
int    RACIAL_SUBTYPE_HALFDROW          = 43;   // AFW-OEI 05/16/2007
int    RACIAL_SUBTYPE_PLANT             = 44;   // AFW-OEI 05/16/2007
int    RACIAL_SUBTYPE_HAGSPAWN          = 45;   // AFW-OEI 05/16/2007
int    RACIAL_SUBTYPE_HALFCELESTIAL     = 46;   // AFW-OEI 05/16/2007
int    RACIAL_SUBTYPE_YUANTI            = 47;   // JWR-OEI 06/29/2008
int    RACIAL_SUBTYPE_GRAYORC           = 48;    // JWR-OEI 07/01/2008


int    ALIGNMENT_ALL                    = 0;
int    ALIGNMENT_NEUTRAL                = 1;
int    ALIGNMENT_LAWFUL                 = 2;
int    ALIGNMENT_CHAOTIC                = 3;
int    ALIGNMENT_GOOD                   = 4;
int    ALIGNMENT_EVIL                   = 5;

int SAVING_THROW_ALL                    = 0;
int SAVING_THROW_FORT                   = 1;
int SAVING_THROW_REFLEX                 = 2;
int SAVING_THROW_WILL                   = 3;

int SAVING_THROW_CHECK_FAILED           = 0;
int SAVING_THROW_CHECK_SUCCEEDED        = 1;
int SAVING_THROW_CHECK_IMMUNE           = 2;


int SAVING_THROW_TYPE_ALL               = 0;
int SAVING_THROW_TYPE_NONE              = 0;
int SAVING_THROW_TYPE_MIND_SPELLS       = 1;
int SAVING_THROW_TYPE_POISON            = 2;
int SAVING_THROW_TYPE_DISEASE           = 3;
int SAVING_THROW_TYPE_FEAR              = 4;
int SAVING_THROW_TYPE_SONIC             = 5;
int SAVING_THROW_TYPE_ACID              = 6;
int SAVING_THROW_TYPE_FIRE              = 7;
int SAVING_THROW_TYPE_ELECTRICITY       = 8;
int SAVING_THROW_TYPE_POSITIVE          = 9;
int SAVING_THROW_TYPE_NEGATIVE          = 10;
int SAVING_THROW_TYPE_DEATH             = 11;
int SAVING_THROW_TYPE_COLD              = 12;
int SAVING_THROW_TYPE_DIVINE            = 13;
int SAVING_THROW_TYPE_TRAP              = 14;
int SAVING_THROW_TYPE_SPELL             = 15;
int SAVING_THROW_TYPE_GOOD              = 16;
int SAVING_THROW_TYPE_EVIL              = 17;
int SAVING_THROW_TYPE_LAW               = 18;
int SAVING_THROW_TYPE_CHAOS             = 19;

int IMMUNITY_TYPE_NONE              = 0;
int IMMUNITY_TYPE_MIND_SPELLS       = 1;
int IMMUNITY_TYPE_POISON            = 2;
int IMMUNITY_TYPE_DISEASE           = 3;
int IMMUNITY_TYPE_FEAR              = 4;
int IMMUNITY_TYPE_TRAP              = 5;
int IMMUNITY_TYPE_PARALYSIS         = 6;
int IMMUNITY_TYPE_BLINDNESS         = 7;
int IMMUNITY_TYPE_DEAFNESS          = 8;
int IMMUNITY_TYPE_SLOW              = 9;
int IMMUNITY_TYPE_ENTANGLE          = 10;
int IMMUNITY_TYPE_SILENCE           = 11;
int IMMUNITY_TYPE_STUN              = 12;
int IMMUNITY_TYPE_SLEEP             = 13;
int IMMUNITY_TYPE_CHARM             = 14;
int IMMUNITY_TYPE_DOMINATE          = 15;
int IMMUNITY_TYPE_CONFUSED          = 16;
int IMMUNITY_TYPE_CURSED            = 17;
int IMMUNITY_TYPE_DAZED             = 18;
int IMMUNITY_TYPE_ABILITY_DECREASE  = 19;
int IMMUNITY_TYPE_ATTACK_DECREASE   = 20;
int IMMUNITY_TYPE_DAMAGE_DECREASE   = 21;
int IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE = 22;
int IMMUNITY_TYPE_AC_DECREASE       = 23;
int IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE = 24;
int IMMUNITY_TYPE_SAVING_THROW_DECREASE = 25;
int IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE = 26;
int IMMUNITY_TYPE_SKILL_DECREASE    = 27;
int IMMUNITY_TYPE_KNOCKDOWN         = 28;
int IMMUNITY_TYPE_NEGATIVE_LEVEL    = 29;
int IMMUNITY_TYPE_SNEAK_ATTACK      = 30;
int IMMUNITY_TYPE_CRITICAL_HIT      = 31;
int IMMUNITY_TYPE_DEATH             = 32;

int AREA_TRANSITION_RANDOM        = 0;
int AREA_TRANSITION_USER_DEFINED  = 1;
int AREA_TRANSITION_CITY_01       = 2;
int AREA_TRANSITION_CITY_02       = 3;
int AREA_TRANSITION_CITY_03       = 4;
int AREA_TRANSITION_CITY_04       = 5;
int AREA_TRANSITION_CITY_05       = 6;
int AREA_TRANSITION_CRYPT_01      = 7;
int AREA_TRANSITION_CRYPT_02      = 8;
int AREA_TRANSITION_CRYPT_03      = 9;
int AREA_TRANSITION_CRYPT_04      = 10;
int AREA_TRANSITION_CRYPT_05      = 11;
int AREA_TRANSITION_DUNGEON_01    = 12;
int AREA_TRANSITION_DUNGEON_02    = 13;
int AREA_TRANSITION_DUNGEON_03    = 14;
int AREA_TRANSITION_DUNGEON_04    = 15;
int AREA_TRANSITION_DUNGEON_05    = 16;
int AREA_TRANSITION_DUNGEON_06    = 17;
int AREA_TRANSITION_DUNGEON_07    = 18;
int AREA_TRANSITION_DUNGEON_08    = 19;
int AREA_TRANSITION_MINES_01      = 20;
int AREA_TRANSITION_MINES_02      = 21;
int AREA_TRANSITION_MINES_03      = 22;
int AREA_TRANSITION_MINES_04      = 23;
int AREA_TRANSITION_MINES_05      = 24;
int AREA_TRANSITION_MINES_06      = 25;
int AREA_TRANSITION_MINES_07      = 26;
int AREA_TRANSITION_MINES_08      = 27;
int AREA_TRANSITION_MINES_09      = 28;
int AREA_TRANSITION_SEWER_01      = 29;
int AREA_TRANSITION_SEWER_02      = 30;
int AREA_TRANSITION_SEWER_03      = 31;
int AREA_TRANSITION_SEWER_04      = 32;
int AREA_TRANSITION_SEWER_05      = 33;
int AREA_TRANSITION_CASTLE_01     = 34;
int AREA_TRANSITION_CASTLE_02     = 35;
int AREA_TRANSITION_CASTLE_03     = 36;
int AREA_TRANSITION_CASTLE_04     = 37;
int AREA_TRANSITION_CASTLE_05     = 38;
int AREA_TRANSITION_CASTLE_06     = 39;
int AREA_TRANSITION_CASTLE_07     = 40;
int AREA_TRANSITION_CASTLE_08     = 41;
int AREA_TRANSITION_INTERIOR_01   = 42;
int AREA_TRANSITION_INTERIOR_02   = 43;
int AREA_TRANSITION_INTERIOR_03   = 44;
int AREA_TRANSITION_INTERIOR_04   = 45;
int AREA_TRANSITION_INTERIOR_05   = 46;
int AREA_TRANSITION_INTERIOR_06   = 47;
int AREA_TRANSITION_INTERIOR_07   = 48;
int AREA_TRANSITION_INTERIOR_08   = 49;
int AREA_TRANSITION_INTERIOR_09   = 50;
int AREA_TRANSITION_INTERIOR_10   = 51;
int AREA_TRANSITION_INTERIOR_11   = 52;
int AREA_TRANSITION_INTERIOR_12   = 53;
int AREA_TRANSITION_INTERIOR_13   = 54;
int AREA_TRANSITION_INTERIOR_14   = 55;
int AREA_TRANSITION_INTERIOR_15   = 56;
int AREA_TRANSITION_INTERIOR_16   = 57;
int AREA_TRANSITION_FOREST_01     = 58;
int AREA_TRANSITION_FOREST_02     = 59;
int AREA_TRANSITION_FOREST_03     = 60;
int AREA_TRANSITION_FOREST_04     = 61;
int AREA_TRANSITION_FOREST_05     = 62;
int AREA_TRANSITION_RURAL_01      = 63;
int AREA_TRANSITION_RURAL_02      = 64;
int AREA_TRANSITION_RURAL_03      = 65;
int AREA_TRANSITION_RURAL_04      = 66;
int AREA_TRANSITION_RURAL_05      = 67;
int AREA_TRANSITION_WRURAL_01  = 68;
int AREA_TRANSITION_WRURAL_02 = 69;
int AREA_TRANSITION_WRURAL_03 = 70;
int AREA_TRANSITION_WRURAL_04 = 71;
int AREA_TRANSITION_WRURAL_05 = 72;
int AREA_TRANSITION_DESERT_01 = 73;
int AREA_TRANSITION_DESERT_02 = 74;
int AREA_TRANSITION_DESERT_03 = 75;
int AREA_TRANSITION_DESERT_04 = 76;
int AREA_TRANSITION_DESERT_05 = 77;
int AREA_TRANSITION_RUINS_01 = 78;
int AREA_TRANSITION_RUINS_02 = 79;
int AREA_TRANSITION_RUINS_03 = 80;
int AREA_TRANSITION_RUINS_04 = 81;
int AREA_TRANSITION_RUINS_05 = 82;
int AREA_TRANSITION_CARAVAN_WINTER = 83;
int AREA_TRANSITION_CARAVAN_DESERT = 84;
int AREA_TRANSITION_CARAVAN_RURAL = 85;
int AREA_TRANSITION_MAGICAL_01 = 86;
int AREA_TRANSITION_MAGICAL_02 = 87;
int AREA_TRANSITION_UNDERDARK_01 = 88;
int AREA_TRANSITION_UNDERDARK_02 = 89;
int AREA_TRANSITION_UNDERDARK_03 = 90;
int AREA_TRANSITION_UNDERDARK_04 = 91;
int AREA_TRANSITION_UNDERDARK_05 = 92;
int AREA_TRANSITION_UNDERDARK_06 = 93;
int AREA_TRANSITION_UNDERDARK_07 = 94;
int AREA_TRANSITION_BEHOLDER_01  = 95;
int AREA_TRANSITION_BEHOLDER_02  = 96;
int AREA_TRANSITION_DROW_01  = 97;
int AREA_TRANSITION_DROW_02  = 98;
int AREA_TRANSITION_ILLITHID_01   = 99;
int AREA_TRANSITION_ILLITHID_02   = 100;
int AREA_TRANSITION_WASTELAND_01  = 101;
int AREA_TRANSITION_WASTELAND_02  = 102;
int AREA_TRANSITION_WASTELAND_03  = 103;
int AREA_TRANSITION_DROW_03       = 104;
int AREA_TRANSITION_DROW_04       = 105;



// Legacy area-transition constants.  Do not delete these.
int AREA_TRANSITION_CITY          = 2;
int AREA_TRANSITION_CRYPT         = 7;
int AREA_TRANSITION_FOREST        = 58;
int AREA_TRANSITION_RURAL         = 63;

int BODY_NODE_HAND                = 0;
int BODY_NODE_CHEST               = 1;
int BODY_NODE_MONSTER_0           = 2;
int BODY_NODE_MONSTER_1           = 3;
int BODY_NODE_MONSTER_2           = 4;
int BODY_NODE_MONSTER_3           = 5;
int BODY_NODE_MONSTER_4           = 6;
int BODY_NODE_MONSTER_5           = 7;
int BODY_NODE_MONSTER_6           = 8;
int BODY_NODE_MONSTER_7           = 9;
int BODY_NODE_MONSTER_8           = 10;
int BODY_NODE_MONSTER_9           = 11;

// Brock H. OEI 12/09/05 -- converted these to use meters,
// which are the native distance units of the engine
// 1 meter = 3.2808 feet, 0.3047 feet = 1 meter
float RADIUS_SIZE_SMALL           =  1.524f; // ~5 feet
float RADIUS_SIZE_MEDIUM          =  3.048f; // ~10 feet
float RADIUS_SIZE_LARGE           =  4.572f; // ~15 feet
float RADIUS_SIZE_HUGE            =  6.069f; // ~20 feet
float RADIUS_SIZE_GARGANTUAN      =  7.620f; // ~25 feet
float RADIUS_SIZE_COLOSSAL        =  9.144f; // ~30 feet
float RADIUS_SIZE_TREMENDOUS      =  12.191f; // ~40 feet   CG-OEI 7/16/2006
float RADIUS_SIZE_GINORMOUS       =  15.240f; // ~50 feet   AFW-OEI 04/24/2006
float RADIUS_SIZE_VAST            =  18.288f; // ~60 feet   CG-OEI 7/16/2006
float RADIUS_SIZE_ASTRONOMIC      =  24.384f; // ~80 feet   CG-OEI 7/16/2006

// these are magic numbers.  they should correspond to the values layed out in ExecuteCommandGetEffectType
int EFFECT_TYPE_INVALIDEFFECT               = 0;
int EFFECT_TYPE_DAMAGE_RESISTANCE           = 1;
//int EFFECT_TYPE_ABILITY_BONUS               = 2;
int EFFECT_TYPE_REGENERATE                  = 3;
//int EFFECT_TYPE_SAVING_THROW_BONUS          = 4;
//int EFFECT_TYPE_MODIFY_AC                   = 5;
//int EFFECT_TYPE_ATTACK_BONUS                = 6;
int EFFECT_TYPE_DAMAGE_REDUCTION            = 7;
//int EFFECT_TYPE_DAMAGE_BONUS                = 8;
int EFFECT_TYPE_TEMPORARY_HITPOINTS         = 9;
//int EFFECT_TYPE_DAMAGE_IMMUNITY             = 10;
int EFFECT_TYPE_ENTANGLE                    = 11;
int EFFECT_TYPE_INVULNERABLE                = 12;
int EFFECT_TYPE_DEAF                        = 13;
int EFFECT_TYPE_RESURRECTION                = 14;
int EFFECT_TYPE_IMMUNITY                    = 15;
//int EFFECT_TYPE_BLIND                       = 16;
int EFFECT_TYPE_ENEMY_ATTACK_BONUS          = 17;
int EFFECT_TYPE_ARCANE_SPELL_FAILURE        = 18;
//int EFFECT_TYPE_MOVEMENT_SPEED              = 19;
int EFFECT_TYPE_AREA_OF_EFFECT              = 20;
int EFFECT_TYPE_BEAM                        = 21;
//int EFFECT_TYPE_SPELL_RESISTANCE            = 22;
int EFFECT_TYPE_CHARMED                     = 23;
int EFFECT_TYPE_CONFUSED                    = 24;
int EFFECT_TYPE_FRIGHTENED                  = 25;
int EFFECT_TYPE_DOMINATED                   = 26;
int EFFECT_TYPE_PARALYZE                    = 27;
int EFFECT_TYPE_DAZED                       = 28;
int EFFECT_TYPE_STUNNED                     = 29;
int EFFECT_TYPE_SLEEP                       = 30;
int EFFECT_TYPE_POISON                      = 31;
int EFFECT_TYPE_DISEASE                     = 32;
int EFFECT_TYPE_CURSE                       = 33;
int EFFECT_TYPE_SILENCE                     = 34;
int EFFECT_TYPE_TURNED                      = 35;
int EFFECT_TYPE_HASTE                       = 36;
int EFFECT_TYPE_SLOW                        = 37;
int EFFECT_TYPE_ABILITY_INCREASE            = 38;
int EFFECT_TYPE_ABILITY_DECREASE            = 39;
int EFFECT_TYPE_ATTACK_INCREASE             = 40;
int EFFECT_TYPE_ATTACK_DECREASE             = 41;
int EFFECT_TYPE_DAMAGE_INCREASE             = 42;
int EFFECT_TYPE_DAMAGE_DECREASE             = 43;
int EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE    = 44;
int EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE    = 45;
int EFFECT_TYPE_AC_INCREASE                 = 46;
int EFFECT_TYPE_AC_DECREASE                 = 47;
int EFFECT_TYPE_MOVEMENT_SPEED_INCREASE     = 48;
int EFFECT_TYPE_MOVEMENT_SPEED_DECREASE     = 49;
int EFFECT_TYPE_SAVING_THROW_INCREASE       = 50;
int EFFECT_TYPE_SAVING_THROW_DECREASE       = 51;
int EFFECT_TYPE_SPELL_RESISTANCE_INCREASE   = 52;
int EFFECT_TYPE_SPELL_RESISTANCE_DECREASE   = 53;
int EFFECT_TYPE_SKILL_INCREASE              = 54;
int EFFECT_TYPE_SKILL_DECREASE              = 55;
int EFFECT_TYPE_INVISIBILITY                = 56;
int EFFECT_TYPE_GREATERINVISIBILITY         = 57;   // JLR - OEI 07/11/05 -- Name Changed
int EFFECT_TYPE_DARKNESS                    = 58;
int EFFECT_TYPE_DISPELMAGICALL              = 59;
int EFFECT_TYPE_ELEMENTALSHIELD             = 60;
int EFFECT_TYPE_NEGATIVELEVEL               = 61;
int EFFECT_TYPE_POLYMORPH                   = 62;
int EFFECT_TYPE_SANCTUARY                   = 63;
int EFFECT_TYPE_TRUESEEING                  = 64;
int EFFECT_TYPE_SEEINVISIBLE                = 65;
int EFFECT_TYPE_TIMESTOP                    = 66;
int EFFECT_TYPE_BLINDNESS                   = 67;
int EFFECT_TYPE_SPELLLEVELABSORPTION        = 68;
int EFFECT_TYPE_DISPELMAGICBEST             = 69;
int EFFECT_TYPE_ULTRAVISION                 = 70;
int EFFECT_TYPE_MISS_CHANCE                 = 71;
int EFFECT_TYPE_CONCEALMENT                 = 72;
int EFFECT_TYPE_SPELL_IMMUNITY              = 73;
int EFFECT_TYPE_VISUALEFFECT                = 74;
int EFFECT_TYPE_DISAPPEARAPPEAR             = 75;
int EFFECT_TYPE_SWARM                       = 76;
int EFFECT_TYPE_TURN_RESISTANCE_DECREASE    = 77;
int EFFECT_TYPE_TURN_RESISTANCE_INCREASE    = 78;
int EFFECT_TYPE_PETRIFY                     = 79;
int EFFECT_TYPE_CUTSCENE_PARALYZE           = 80;
int EFFECT_TYPE_ETHEREAL                    = 81;
int EFFECT_TYPE_SPELL_FAILURE               = 82;
int EFFECT_TYPE_CUTSCENEGHOST               = 83;
int EFFECT_TYPE_CUTSCENEIMMOBILIZE          = 84;
int EFFECT_TYPE_BARDSONG_SINGING            = 85;   // JLR-OEI 04/07/06: Bards
int EFFECT_TYPE_HIDEOUS_BLOW            = 86;   // AFW-OEI 06/07/2006: Warlocks
int EFFECT_TYPE_NWN2_DEX_ACMOD_DISABLE      = 87;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_DETECTUNDEAD            = 88;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_SHAREDDAMAGE            = 89;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_ASSAYRESISTANCE         = 90;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_DAMAGEOVERTIME          = 91;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_ABSORBDAMAGE            = 92;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_AMORPENALTYINC          = 93;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_DISINTEGRATE            = 94;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_HEAL_ON_ZERO_HP         = 95;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_BREAK_ENCHANTMENT       = 96;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_MESMERIZE           = 97;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_ON_DISPEL           = 98;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_BONUS_HITPOINTS         = 99;   // AFW-OEI 08/18/2006
int EFFECT_TYPE_JARRING             = 100;  // AFW-OEI 08/18/2006
int EFFECT_TYPE_MAX_DAMAGE          = 101;  // AFW-OEI 08/18/2006
int EFFECT_TYPE_WOUNDING            = 102;  // AFW-OEI 09/05/2006
int EFFECT_TYPE_WILDSHAPE           = 103;  // AFW-OEI 10/30/2006
int EFFECT_TYPE_EFFECT_ICON         = 104;  // AFW-OEI 02/12/2007
int EFFECT_TYPE_RESCUE              = 105;  // AFW-OEI 02/27/2007
int EFFECT_TYPE_DETECT_SPIRITS          = 106;  // AFW-OEI 03/13/2007
int EFFECT_TYPE_DAMAGE_REDUCTION_NEGATED    = 107;  // AFW-OEI 03/19/2007
int EFFECT_TYPE_CONCEALMENT_NEGATED     = 108;  // AFW-OEI 03/19/2007
int EFFECT_TYPE_INSANE                      = 109;  // AFW-OEI 04/16/2007
int EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING  = 110;  // NLC-OEI 09/4/2008


int ITEM_APPR_TYPE_SIMPLE_MODEL         = 0;
int ITEM_APPR_TYPE_WEAPON_COLOR         = 1;
int ITEM_APPR_TYPE_WEAPON_MODEL         = 2;
int ITEM_APPR_TYPE_ARMOR_MODEL          = 3;
int ITEM_APPR_TYPE_ARMOR_COLOR          = 4;
int ITEM_APPR_NUM_TYPES                 = 5;

int ITEM_APPR_ARMOR_COLOR_LEATHER1      = 0;
int ITEM_APPR_ARMOR_COLOR_LEATHER2      = 1;
int ITEM_APPR_ARMOR_COLOR_CLOTH1        = 2;
int ITEM_APPR_ARMOR_COLOR_CLOTH2        = 3;
int ITEM_APPR_ARMOR_COLOR_METAL1        = 4;
int ITEM_APPR_ARMOR_COLOR_METAL2        = 5;
int ITEM_APPR_ARMOR_NUM_COLORS          = 6;

int ITEM_APPR_ARMOR_MODEL_RFOOT         = 0;
int ITEM_APPR_ARMOR_MODEL_LFOOT         = 1;
int ITEM_APPR_ARMOR_MODEL_RSHIN         = 2;
int ITEM_APPR_ARMOR_MODEL_LSHIN         = 3;
int ITEM_APPR_ARMOR_MODEL_LTHIGH        = 4;
int ITEM_APPR_ARMOR_MODEL_RTHIGH        = 5;
int ITEM_APPR_ARMOR_MODEL_PELVIS        = 6;
int ITEM_APPR_ARMOR_MODEL_TORSO         = 7;
int ITEM_APPR_ARMOR_MODEL_BELT          = 8;
int ITEM_APPR_ARMOR_MODEL_NECK          = 9;
int ITEM_APPR_ARMOR_MODEL_RFOREARM      = 10;
int ITEM_APPR_ARMOR_MODEL_LFOREARM      = 11;
int ITEM_APPR_ARMOR_MODEL_RBICEP        = 12;
int ITEM_APPR_ARMOR_MODEL_LBICEP        = 13;
int ITEM_APPR_ARMOR_MODEL_RSHOULDER     = 14;
int ITEM_APPR_ARMOR_MODEL_LSHOULDER     = 15;
int ITEM_APPR_ARMOR_MODEL_RHAND         = 16;
int ITEM_APPR_ARMOR_MODEL_LHAND         = 17;
int ITEM_APPR_ARMOR_MODEL_ROBE          = 18;
int ITEM_APPR_ARMOR_NUM_MODELS          = 19;

int ITEM_APPR_WEAPON_MODEL_BOTTOM       = 0;
int ITEM_APPR_WEAPON_MODEL_MIDDLE       = 1;
int ITEM_APPR_WEAPON_MODEL_TOP          = 2;

int ITEM_APPR_WEAPON_COLOR_BOTTOM       = 0;
int ITEM_APPR_WEAPON_COLOR_MIDDLE       = 1;
int ITEM_APPR_WEAPON_COLOR_TOP          = 2;

int ITEM_PROPERTY_ABILITY_BONUS                            = 0 ;
int ITEM_PROPERTY_AC_BONUS                                 = 1 ;
int ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP              = 2 ;
int ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE                  = 3 ;
int ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP                 = 4 ;
int ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT           = 5 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS                        = 6 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP     = 7 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP        = 8 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT = 9 ;
int ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER           = 10 ;
int ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION               = 11 ;
int ITEM_PROPERTY_BONUS_FEAT                               = 12 ;
int ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N              = 13 ;

int ITEM_PROPERTY_CAST_SPELL                               = 15 ;
int ITEM_PROPERTY_DAMAGE_BONUS                             = 16 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP          = 17 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP             = 18 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT       = 19 ;
int ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE                     = 20 ;
int ITEM_PROPERTY_DECREASED_DAMAGE                         = 21 ;
// JLR-OEI 04/03/06: This version is DEPRECATED.  New version found below...
int ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED              = 22 ;
int ITEM_PROPERTY_DAMAGE_RESISTANCE                        = 23 ;
int ITEM_PROPERTY_DAMAGE_VULNERABILITY                     = 24 ;

int ITEM_PROPERTY_DARKVISION                               = 26 ;
int ITEM_PROPERTY_DECREASED_ABILITY_SCORE                  = 27 ;
int ITEM_PROPERTY_DECREASED_AC                             = 28 ;
int ITEM_PROPERTY_DECREASED_SKILL_MODIFIER                 = 29 ;


int ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT        = 32 ;
int ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE                  = 33 ;
int ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE                 = 34 ;
int ITEM_PROPERTY_HASTE                                    = 35 ;
int ITEM_PROPERTY_HOLY_AVENGER                             = 36 ;
int ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS                   = 37 ;
int ITEM_PROPERTY_IMPROVED_EVASION                         = 38 ;
int ITEM_PROPERTY_SPELL_RESISTANCE                         = 39 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS                       = 40 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC              = 41 ;
int ITEM_PROPERTY_KEEN                                     = 43 ;
int ITEM_PROPERTY_LIGHT                                    = 44 ;
int ITEM_PROPERTY_MIGHTY                                   = 45 ;
int ITEM_PROPERTY_MIND_BLANK                               = 46 ;
int ITEM_PROPERTY_NO_DAMAGE                                = 47 ;
int ITEM_PROPERTY_ON_HIT_PROPERTIES                        = 48 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS                  = 49 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC         = 50 ;
int ITEM_PROPERTY_REGENERATION                             = 51 ;
int ITEM_PROPERTY_SKILL_BONUS                              = 52 ;
int ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL                  = 53 ;
int ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL                    = 54 ;
int ITEM_PROPERTY_THIEVES_TOOLS                            = 55 ;
int ITEM_PROPERTY_ATTACK_BONUS                             = 56 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP          = 57 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP             = 58 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT       = 59 ;
int ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER                = 60 ;
int ITEM_PROPERTY_UNLIMITED_AMMUNITION                     = 61 ;
int ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP           = 62 ;
int ITEM_PROPERTY_USE_LIMITATION_CLASS                     = 63 ;
int ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE               = 64 ;
int ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT        = 65 ;
int ITEM_PROPERTY_BONUS_HITPOINTS                          = 66 ;
int ITEM_PROPERTY_REGENERATION_VAMPIRIC                    = 67 ;

int ITEM_PROPERTY_TRAP                                     = 70 ;
int ITEM_PROPERTY_TRUE_SEEING                              = 71 ;
int ITEM_PROPERTY_ON_MONSTER_HIT                           = 72 ;
int ITEM_PROPERTY_TURN_RESISTANCE                          = 73 ;
int ITEM_PROPERTY_MASSIVE_CRITICALS                        = 74 ;
int ITEM_PROPERTY_FREEDOM_OF_MOVEMENT                      = 75 ;

// no longer working, poison is now a on_hit subtype
int ITEM_PROPERTY_POISON                                   = 76 ;

int ITEM_PROPERTY_MONSTER_DAMAGE                           = 77 ;
int ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL                 = 78 ;

int ITEM_PROPERTY_SPECIAL_WALK                             = 79;
int ITEM_PROPERTY_HEALERS_KIT                              = 80;
int ITEM_PROPERTY_WEIGHT_INCREASE                          = 81;
int ITEM_PROPERTY_ONHITCASTSPELL                           = 82;
int ITEM_PROPERTY_VISUALEFFECT                             = 83;
int ITEM_PROPERTY_ARCANE_SPELL_FAILURE                     = 84;
// JLR-OEI 04/03/06: This version is replacing the above DEPRECATED one (#22).
int ITEM_PROPERTY_DAMAGE_REDUCTION                         = 90;


int BASE_ITEM_SHORTSWORD            = 0;
int BASE_ITEM_LONGSWORD             = 1;
int BASE_ITEM_BATTLEAXE             = 2;
int BASE_ITEM_BASTARDSWORD          = 3;
int BASE_ITEM_LIGHTFLAIL            = 4;
int BASE_ITEM_WARHAMMER             = 5;
int BASE_ITEM_HEAVYCROSSBOW         = 6;
int BASE_ITEM_LIGHTCROSSBOW         = 7;
int BASE_ITEM_LONGBOW               = 8;
int BASE_ITEM_LIGHTMACE             = 9;
int BASE_ITEM_HALBERD               = 10;
int BASE_ITEM_SHORTBOW              = 11;
int BASE_ITEM_TWOBLADEDSWORD        = 12;
int BASE_ITEM_GREATSWORD            = 13;
int BASE_ITEM_SMALLSHIELD           = 14;
int BASE_ITEM_TORCH                 = 15;
int BASE_ITEM_ARMOR                 = 16;
int BASE_ITEM_HELMET                = 17;
int BASE_ITEM_GREATAXE              = 18;
int BASE_ITEM_AMULET                = 19;
int BASE_ITEM_ARROW                 = 20;
int BASE_ITEM_BELT                  = 21;
int BASE_ITEM_DAGGER                = 22;
int BASE_ITEM_MISCSMALL             = 24;
int BASE_ITEM_BOLT                  = 25;
int BASE_ITEM_BOOTS                 = 26;
int BASE_ITEM_BULLET                = 27;
int BASE_ITEM_CLUB                  = 28;
int BASE_ITEM_MISCMEDIUM            = 29;
int BASE_ITEM_DART                  = 31;
int BASE_ITEM_DIREMACE              = 32;
int BASE_ITEM_DOUBLEAXE             = 33;
int BASE_ITEM_MISCLARGE             = 34;
int BASE_ITEM_HEAVYFLAIL            = 35;
int BASE_ITEM_GLOVES                = 36;
int BASE_ITEM_LIGHTHAMMER           = 37;
int BASE_ITEM_HANDAXE               = 38;
int BASE_ITEM_HEALERSKIT            = 39;
int BASE_ITEM_KAMA                  = 40;
int BASE_ITEM_KATANA                = 41;
int BASE_ITEM_KUKRI                 = 42;
int BASE_ITEM_MISCTALL              = 43;
int BASE_ITEM_MAGICROD              = 44;
int BASE_ITEM_MAGICSTAFF            = 45;
int BASE_ITEM_MAGICWAND             = 46;
int BASE_ITEM_MORNINGSTAR           = 47;


int BASE_ITEM_POTIONS               = 49;
int BASE_ITEM_QUARTERSTAFF          = 50;
int BASE_ITEM_RAPIER                = 51;
int BASE_ITEM_RING                  = 52;
int BASE_ITEM_SCIMITAR              = 53;
int BASE_ITEM_SCROLL                = 54;
int BASE_ITEM_SCYTHE                = 55;
int BASE_ITEM_LARGESHIELD           = 56;
int BASE_ITEM_TOWERSHIELD           = 57;
int BASE_ITEM_SHORTSPEAR            = 58;
int BASE_ITEM_SHURIKEN              = 59;
int BASE_ITEM_SICKLE                = 60;
int BASE_ITEM_SLING                 = 61;
int BASE_ITEM_THIEVESTOOLS          = 62;
int BASE_ITEM_THROWINGAXE           = 63;
int BASE_ITEM_TRAPKIT               = 64;
int BASE_ITEM_KEY                   = 65;
int BASE_ITEM_LARGEBOX              = 66;
int BASE_ITEM_MISCWIDE              = 68;
int BASE_ITEM_CSLASHWEAPON          = 69;
int BASE_ITEM_CPIERCWEAPON          = 70;
int BASE_ITEM_CBLUDGWEAPON          = 71;
int BASE_ITEM_CSLSHPRCWEAP          = 72;
int BASE_ITEM_CREATUREITEM          = 73;
int BASE_ITEM_BOOK                  = 74;
int BASE_ITEM_SPELLSCROLL           = 75;
int BASE_ITEM_GOLD                  = 76;
int BASE_ITEM_GEM                   = 77;
int BASE_ITEM_BRACER                = 78;
int BASE_ITEM_MISCTHIN              = 79;
int BASE_ITEM_CLOAK                 = 80;
int BASE_ITEM_GRENADE               = 81;

int BASE_ITEM_BLANK_POTION          = 101;
int BASE_ITEM_BLANK_SCROLL          = 102;
int BASE_ITEM_BLANK_WAND            = 103;

int BASE_ITEM_ENCHANTED_POTION      = 104;
int BASE_ITEM_ENCHANTED_SCROLL      = 105;
int BASE_ITEM_ENCHANTED_WAND        = 106;

int BASE_ITEM_DWARVENWARAXE         = 108;
int BASE_ITEM_CRAFTMATERIALMED      = 109;
int BASE_ITEM_CRAFTMATERIALSML      = 110;
int BASE_ITEM_WHIP                  = 111;
int BASE_ITEM_MACE                  = 113;
int BASE_ITEM_FALCHION              = 114;
int BASE_ITEM_FLAIL                 = 116;
int BASE_ITEM_SPEAR                 = 119;
int BASE_ITEM_GREATCLUB             = 120;
int BASE_ITEM_TRAINING_CLUB         = 124;
int BASE_ITEM_WARMACE               = 126;

int BASE_ITEM_DRUM                  = 128;
int BASE_ITEM_FLUTE                 = 129;
int BASE_ITEM_MANDOLIN              = 132;
int BASE_ITEM_CGIANT_SWORD          = 140;
int BASE_ITEM_CGIANT_AXE            = 141;
int BASE_ITEM_ALLUSE_SWORD          = 142;


int BASE_ITEM_INVALID               = 256;

int VFX_NONE                        = -1;
int VFX_DUR_BLUR                    = 0;
int VFX_DUR_DARKNESS                = 1;
int VFX_DUR_ENTANGLE                = 2;
int VFX_DUR_FREEDOM_OF_MOVEMENT     = 3;
int VFX_DUR_GLOBE_INVULNERABILITY   = 4;
//int VFX_DUR_BLACKOUT                = 5;  // AFW-OEI 07/14/2007: Deprecated
int VFX_DUR_INVISIBILITY            = 6;
int VFX_DUR_MIND_AFFECTING_NEGATIVE = 7;
int VFX_DUR_MIND_AFFECTING_POSITIVE = 8;
int VFX_DUR_GHOSTLY_VISAGE          = 9;
int VFX_DUR_ETHEREAL_VISAGE         = 10;
int VFX_DUR_PROT_BARKSKIN           = 11;
int VFX_DUR_PROT_GREATER_STONESKIN  = 12;
int VFX_DUR_PROT_PREMONITION        = 13;
int VFX_DUR_PROT_SHADOW_ARMOR       = 14;
int VFX_DUR_PROT_STONESKIN          = 15;
int VFX_DUR_SANCTUARY               = 16;
int VFX_DUR_WEB                     = 17;
//int VFX_FNF_BLINDDEAF               = 18; // AFW-OEI 07/14/2007: Deprecated
int VFX_FNF_DISPEL                  = 19;
int VFX_FNF_DISPEL_DISJUNCTION      = 20;
int VFX_FNF_DISPEL_GREATER          = 21 ;
int VFX_FNF_FIREBALL                = 22 ;
int VFX_FNF_FIRESTORM               = 23 ;
int VFX_FNF_IMPLOSION               = 24 ;
//int VFX_FNF_MASS_HASTE = 25 ;
int VFX_FNF_MASS_HEAL               = 26 ;
int VFX_FNF_MASS_MIND_AFFECTING     = 27 ;
int VFX_FNF_METEOR_SWARM            = 28 ;
int VFX_FNF_NATURES_BALANCE         = 29 ;
//int VFX_FNF_PWKILL                  = 30 ;    // AFW-OEI 07/14/2007: Deprecated
int VFX_FNF_PWSTUN                  = 31 ;
int VFX_FNF_SUMMON_GATE             = 32 ;
int VFX_FNF_SUMMON_MONSTER_1        = 33 ;
int VFX_FNF_SUMMON_MONSTER_2        = 34 ;
int VFX_FNF_SUMMON_MONSTER_3        = 35 ;
int VFX_FNF_SUMMON_UNDEAD           = 36 ;
int VFX_FNF_SUNBEAM                 = 37 ;
int VFX_FNF_TIME_STOP               = 38 ;
//int VFX_FNF_WAIL_O_BANSHEES         = 39 ;    // AFW-OEI 07/14/2007: Deprecated
int VFX_FNF_WEIRD                   = 40 ;
int VFX_FNF_WORD                    = 41 ;
int VFX_IMP_AC_BONUS                = 42 ;
int VFX_IMP_ACID_L                  = 43 ;
int VFX_IMP_ACID_S                  = 44 ;
//int VFX_IMP_ALTER_WEAPON = 45 ;
int VFX_IMP_BLIND_DEAF_M            = 46 ;
int VFX_IMP_BREACH                  = 47 ;
int VFX_IMP_CONFUSION_S             = 48 ;
int VFX_IMP_DAZED_S                 = 49 ;
int VFX_IMP_DEATH                   = 50 ;
int VFX_IMP_DISEASE_S               = 51 ;
int VFX_IMP_DISPEL                  = 52 ;
int VFX_IMP_DISPEL_DISJUNCTION      = 53 ;
int VFX_IMP_DIVINE_STRIKE_FIRE      = 54 ;
int VFX_IMP_DIVINE_STRIKE_HOLY      = 55 ;
int VFX_IMP_DOMINATE_S              = 56 ;
int VFX_IMP_DOOM                    = 57 ;
int VFX_IMP_FEAR_S                  = 58 ;
//int VFX_IMP_FLAME_L = 59 ;
int VFX_IMP_FLAME_M                 = 60 ;
int VFX_IMP_FLAME_S                 = 61 ;
int VFX_IMP_FROST_L                 = 62 ;
int VFX_IMP_FROST_S                 = 63 ;
int VFX_IMP_GREASE                  = 64 ;
int VFX_IMP_HASTE                   = 65 ;
int VFX_IMP_HEALING_G               = 66 ;
int VFX_IMP_HEALING_L               = 67 ;
int VFX_IMP_HEALING_M               = 68 ;
int VFX_IMP_HEALING_S               = 69 ;
int VFX_IMP_HEALING_X               = 70 ;
int VFX_IMP_HOLY_AID                = 71 ;
int VFX_IMP_KNOCK                   = 72 ;
//int VFX_BEAM_LIGHTNING              = 73 ;
int VFX_IMP_LIGHTNING_M             = 74 ;
int VFX_IMP_LIGHTNING_S             = 75 ;
int VFX_IMP_MAGBLUE                 = 76 ;
//int VFX_IMP_MAGBLUE2 = 77 ;
//int VFX_IMP_MAGBLUE3 = 78 ;
//int VFX_IMP_MAGBLUE4 = 79 ;
//int VFX_IMP_MAGBLUE5 = 80 ;
int VFX_IMP_NEGATIVE_ENERGY         = 81 ;
int VFX_DUR_PARALYZE_HOLD           = 82 ;
int VFX_IMP_POISON_L                = 83 ;
int VFX_IMP_POISON_S                = 84 ;
int VFX_IMP_POLYMORPH               = 85 ;
int VFX_IMP_PULSE_COLD              = 86 ;
int VFX_IMP_PULSE_FIRE              = 87 ;
int VFX_IMP_PULSE_HOLY              = 88 ;
int VFX_IMP_PULSE_NEGATIVE          = 89 ;
int VFX_IMP_RAISE_DEAD              = 90 ;
int VFX_IMP_REDUCE_ABILITY_SCORE    = 91 ;
int VFX_IMP_REMOVE_CONDITION        = 92 ;
int VFX_IMP_SILENCE                 = 93 ;
int VFX_IMP_SLEEP                   = 94 ;
int VFX_IMP_SLOW                    = 95 ;
int VFX_IMP_SONIC                   = 96 ;
int VFX_IMP_STUN                    = 97 ;
int VFX_IMP_SUNSTRIKE               = 98 ;
int VFX_IMP_UNSUMMON                = 99 ;
int VFX_COM_SPECIAL_BLUE_RED        = 100 ;
int VFX_COM_SPECIAL_PINK_ORANGE     = 101 ;
int VFX_COM_SPECIAL_RED_WHITE       = 102 ;
int VFX_COM_SPECIAL_RED_ORANGE      = 103 ;
int VFX_COM_SPECIAL_WHITE_BLUE      = 104 ;
int VFX_COM_SPECIAL_WHITE_ORANGE    = 105 ;
int VFX_COM_BLOOD_REG_WIMP          = 106 ;
int VFX_COM_BLOOD_LRG_WIMP          = 107 ;
int VFX_COM_BLOOD_CRT_WIMP          = 108 ;
int VFX_COM_BLOOD_REG_RED           = 109 ;
int VFX_COM_BLOOD_REG_GREEN         = 110 ;
int VFX_COM_BLOOD_REG_YELLOW        = 111 ;
int VFX_COM_BLOOD_LRG_RED           = 112 ;
int VFX_COM_BLOOD_LRG_GREEN         = 113 ;
int VFX_COM_BLOOD_LRG_YELLOW        = 114 ;
int VFX_COM_BLOOD_CRT_RED           = 115 ;
int VFX_COM_BLOOD_CRT_GREEN         = 116 ;
int VFX_COM_BLOOD_CRT_YELLOW        = 117 ;
int VFX_COM_SPARKS_PARRY            = 118 ;
//int VFX_COM_GIB = 119 ;
int VFX_COM_UNLOAD_MODEL            = 120 ;
int VFX_COM_CHUNK_RED_SMALL         = 121 ;
int VFX_COM_CHUNK_RED_MEDIUM        = 122 ;
int VFX_COM_CHUNK_GREEN_SMALL       = 123 ;
int VFX_COM_CHUNK_GREEN_MEDIUM      = 124 ;
int VFX_COM_CHUNK_YELLOW_SMALL      = 125 ;
int VFX_COM_CHUNK_YELLOW_MEDIUM     = 126 ;
//int VFX_ITM_ACID = 127 ;
//int VFX_ITM_FIRE = 128 ;
//int VFX_ITM_FROST = 129 ;
//int VFX_ITM_ILLUMINATED_BLUE = 130 ;
//int VFX_ITM_ILLUMINATED_PURPLE = 131 ;
//int VFX_ITM_ILLUMINATED_RED = 132 ;
//int VFX_ITM_LIGHTNING = 133 ;
//int VFX_ITM_PULSING_BLUE = 134 ;
//int VFX_ITM_PULSING_PURPLE = 135 ;
//int VFX_ITM_PULSING_RED = 136 ;
//int VFX_ITM_SMOKING = 137 ;
int VFX_DUR_SPELLTURNING            = 138;
int VFX_IMP_IMPROVE_ABILITY_SCORE   = 139;
int VFX_IMP_CHARM                   = 140;
int VFX_IMP_MAGICAL_VISION          = 141;
//int VFX_IMP_LAW_HELP = 142;
//int VFX_IMP_CHAOS_HELP = 143;
int VFX_IMP_EVIL_HELP               = 144;
int VFX_IMP_GOOD_HELP               = 145;
int VFX_IMP_DEATH_WARD              = 146;
int VFX_DUR_ELEMENTAL_SHIELD        = 147;
int VFX_DUR_LIGHT                   = 148;
int VFX_IMP_MAGIC_PROTECTION        = 149;
int VFX_IMP_SUPER_HEROISM           = 150;
int VFX_FNF_STORM                   = 151;
int VFX_IMP_ELEMENTAL_PROTECTION    = 152;
int VFX_DUR_LIGHT_BLUE_5            = 153;
int VFX_DUR_LIGHT_BLUE_10           = 154;
int VFX_DUR_LIGHT_BLUE_15           = 155;
int VFX_DUR_LIGHT_BLUE_20           = 156;
int VFX_DUR_LIGHT_YELLOW_5          = 157;
int VFX_DUR_LIGHT_YELLOW_10         = 158;
int VFX_DUR_LIGHT_YELLOW_15         = 159;
int VFX_DUR_LIGHT_YELLOW_20         = 160;
int VFX_DUR_LIGHT_PURPLE_5          = 161;
int VFX_DUR_LIGHT_PURPLE_10         = 162;
int VFX_DUR_LIGHT_PURPLE_15         = 163;
int VFX_DUR_LIGHT_PURPLE_20         = 164;
int VFX_DUR_LIGHT_RED_5             = 165;
int VFX_DUR_LIGHT_RED_10            = 166;
int VFX_DUR_LIGHT_RED_15            = 167;
int VFX_DUR_LIGHT_RED_20            = 168;
int VFX_DUR_LIGHT_ORANGE_5          = 169;
int VFX_DUR_LIGHT_ORANGE_10         = 170;
int VFX_DUR_LIGHT_ORANGE_15         = 171;
int VFX_DUR_LIGHT_ORANGE_20         = 172;
int VFX_DUR_LIGHT_WHITE_5           = 173;
int VFX_DUR_LIGHT_WHITE_10          = 174;
int VFX_DUR_LIGHT_WHITE_15          = 175;
int VFX_DUR_LIGHT_WHITE_20          = 176;
int VFX_DUR_LIGHT_GREY_5            = 177;
int VFX_DUR_LIGHT_GREY_10           = 178;
int VFX_DUR_LIGHT_GREY_15           = 179;
int VFX_DUR_LIGHT_GREY_20           = 180;
int VFX_IMP_MIRV                    = 181;
int VFX_DUR_DARKVISION              = 182;
int VFX_FNF_SOUND_BURST             = 183;
int VFX_FNF_STRIKE_HOLY             = 184;
int VFX_FNF_LOS_EVIL_10             = 185;
int VFX_FNF_LOS_EVIL_20             = 186;
int VFX_FNF_LOS_EVIL_30             = 187;
int VFX_FNF_LOS_HOLY_10             = 188;
int VFX_FNF_LOS_HOLY_20             = 189;
int VFX_FNF_LOS_HOLY_30             = 190;
int VFX_FNF_LOS_NORMAL_10           = 191;
int VFX_FNF_LOS_NORMAL_20           = 192;
int VFX_FNF_LOS_NORMAL_30           = 193;
int VFX_IMP_HEAD_ACID               = 194;
int VFX_IMP_HEAD_FIRE               = 195;
int VFX_IMP_HEAD_SONIC              = 196;
int VFX_IMP_HEAD_ELECTRICITY        = 197;
int VFX_IMP_HEAD_COLD               = 198;
int VFX_IMP_HEAD_HOLY               = 199;
int VFX_IMP_HEAD_NATURE             = 200;
int VFX_IMP_HEAD_HEAL               = 201;
int VFX_IMP_HEAD_MIND               = 202;
int VFX_IMP_HEAD_EVIL               = 203;
int VFX_IMP_HEAD_ODD                = 204;
int VFX_DUR_CESSATE_NEUTRAL         = 205;
int VFX_DUR_CESSATE_POSITIVE        = 206;
int VFX_DUR_CESSATE_NEGATIVE        = 207;
int VFX_DUR_MIND_AFFECTING_DISABLED = 208;
int VFX_DUR_MIND_AFFECTING_DOMINATED= 209;
//int VFX_BEAM_FIRE                   = 210;
int VFX_BEAM_COLD                   = 211;
//int VFX_BEAM_HOLY                   = 212;
int VFX_BEAM_MIND                   = 213;
//int VFX_BEAM_EVIL                   = 214;
int VFX_BEAM_ODD                    = 215;
int VFX_BEAM_FIRE_LASH              = 216;
int VFX_IMP_DEATH_L                 = 217;
int VFX_DUR_MIND_AFFECTING_FEAR     = 218;
int VFX_FNF_SUMMON_CELESTIAL        = 219;
int VFX_DUR_GLOBE_MINOR             = 220;
int VFX_IMP_RESTORATION_LESSER      = 221;
int VFX_IMP_RESTORATION             = 222;
int VFX_IMP_RESTORATION_GREATER     = 223;
int VFX_DUR_PROTECTION_ELEMENTS     = 224;
int VFX_DUR_PROTECTION_GOOD_MINOR   = 225;
int VFX_DUR_PROTECTION_GOOD_MAJOR   = 226;
int VFX_DUR_PROTECTION_EVIL_MINOR   = 227;
int VFX_DUR_PROTECTION_EVIL_MAJOR   = 228;
int VFX_DUR_MAGICAL_SIGHT           = 229;
int VFX_DUR_WEB_MASS                = 230;
int VFX_FNF_ICESTORM                = 231;
int VFX_DUR_PARALYZED               = 232;
int VFX_IMP_MIRV_FLAME              = 233;
int VFX_IMP_DESTRUCTION             = 234;
int VFX_COM_CHUNK_RED_LARGE         = 235;
int VFX_COM_CHUNK_BONE_MEDIUM       = 236;
int VFX_COM_BLOOD_SPARK_SMALL       = 237;
int VFX_COM_BLOOD_SPARK_MEDIUM      = 238;
int VFX_COM_BLOOD_SPARK_LARGE       = 239;
int VFX_DUR_GHOSTLY_PULSE           = 240;
int VFX_FNF_HORRID_WILTING          = 241;
int VFX_DUR_BLINDVISION             = 242;
int VFX_DUR_LOWLIGHTVISION          = 243;
int VFX_DUR_ULTRAVISION             = 244;
int VFX_DUR_MIRV_ACID               = 245;
int VFX_IMP_HARM                    = 246;
int VFX_DUR_BLIND                   = 247;
int VFX_DUR_ANTI_LIGHT_10           = 248;
int VFX_DUR_MAGIC_RESISTANCE        = 249;
int VFX_IMP_MAGIC_RESISTANCE_USE    = 250;
int VFX_IMP_GLOBE_USE                  = 251;
int VFX_IMP_WILL_SAVING_THROW_USE      = 252;
int VFX_IMP_SPIKE_TRAP                 = 253;
int VFX_IMP_SPELL_MANTLE_USE           = 254;
int VFX_IMP_FORTITUDE_SAVING_THROW_USE = 255;
int VFX_IMP_REFLEX_SAVE_THROW_USE      = 256;
int VFX_FNF_GAS_EXPLOSION_ACID         = 257;
int VFX_FNF_GAS_EXPLOSION_EVIL         = 258;
int VFX_FNF_GAS_EXPLOSION_NATURE       = 259;
int VFX_FNF_GAS_EXPLOSION_FIRE         = 260;
int VFX_FNF_GAS_EXPLOSION_GREASE       = 261;
int VFX_FNF_GAS_EXPLOSION_MIND         = 262;
int VFX_FNF_SMOKE_PUFF                 = 263;
int VFX_IMP_PULSE_WATER                = 264;
int VFX_IMP_PULSE_WIND                 = 265;
int VFX_IMP_PULSE_NATURE               = 266;
int VFX_DUR_AURA_COLD                  = 267;
int VFX_DUR_AURA_FIRE                  = 268;
int VFX_DUR_AURA_POISON                = 269;
int VFX_DUR_AURA_DISEASE               = 270;
int VFX_DUR_AURA_ODD                   = 271;
int VFX_DUR_AURA_SILENCE               = 272;
int VFX_IMP_AURA_HOLY                  = 273;
int VFX_IMP_AURA_UNEARTHLY             = 274;
int VFX_IMP_AURA_FEAR                  = 275;
int VFX_IMP_AURA_NEGATIVE_ENERGY       = 276;
int VFX_DUR_BARD_SONG                  = 277;
int VFX_FNF_HOWL_MIND                  = 278;
int VFX_FNF_HOWL_ODD                   = 279;
int VFX_COM_HIT_FIRE                   = 280;
int VFX_COM_HIT_FROST                  = 281;
int VFX_COM_HIT_ELECTRICAL             = 282;
int VFX_COM_HIT_ACID                   = 283;
int VFX_COM_HIT_SONIC                  = 284;
int VFX_FNF_HOWL_WAR_CRY               = 285;
int VFX_FNF_SCREEN_SHAKE               = 286;
int VFX_FNF_SCREEN_BUMP                = 287;
int VFX_COM_HIT_NEGATIVE               = 288;
int VFX_COM_HIT_DIVINE                 = 289;
int VFX_FNF_HOWL_WAR_CRY_FEMALE        = 290;
int VFX_DUR_AURA_DRAGON_FEAR           = 291;
int VFX_DUR_FLAG_RED                   = 303;
int VFX_DUR_FLAG_BLUE                  = 304;
int VFX_DUR_FLAG_GOLD                  = 305;
int VFX_DUR_FLAG_PURPLE                = 306;
int VFX_DUR_TENTACLE                   = 346;
int VFX_DUR_PETRIFY                    = 351;
int VFX_DUR_FREEZE_ANIMATION           = 352;

int VFX_COM_CHUNK_STONE_SMALL          = 353;
int VFX_COM_CHUNK_STONE_MEDIUM         = 354;

int VFX_BEAM_SILENT_LIGHTNING          = 307;
int VFX_BEAM_SILENT_FIRE               = 308;
int VFX_BEAM_SILENT_COLD               = 309;
int VFX_BEAM_SILENT_HOLY               = 310;
int VFX_BEAM_SILENT_MIND               = 311;
int VFX_BEAM_SILENT_EVIL               = 312;
int VFX_BEAM_SILENT_ODD                = 313;
int VFX_DUR_BIGBYS_INTERPOSING_HAND    = 314;
int VFX_IMP_BIGBYS_FORCEFUL_HAND       = 315;
int VFX_DUR_BIGBYS_CLENCHED_FIST       = 316;
int VFX_DUR_BIGBYS_CRUSHING_HAND       = 317;
int VFX_DUR_BIGBYS_GRASPING_HAND       = 318;

int VFX_DUR_CALTROPS                   = 319;
int VFX_DUR_SMOKE                      = 320;
int VFX_DUR_PIXIEDUST                  = 321;
int VFX_FNF_DECK                       = 322;
int VFX_DUR_CUTSCENE_INVISIBILITY      = 355;
int VFX_DUR_IOUNSTONE                  = 403;
int VFX_IMP_TORNADO                    = 407;
int VFX_DUR_GLOW_LIGHT_BLUE            = 408;
int VFX_DUR_GLOW_PURPLE                = 409;
int VFX_DUR_GLOW_BLUE                  = 410;
int VFX_DUR_GLOW_RED                   = 411;
int VFX_DUR_GLOW_LIGHT_RED             = 412;
int VFX_DUR_GLOW_YELLOW                = 413;
int VFX_DUR_GLOW_LIGHT_YELLOW          = 414;
int VFX_DUR_GLOW_GREEN                 = 415;
int VFX_DUR_GLOW_LIGHT_GREEN           = 416;
int VFX_DUR_GLOW_ORANGE                = 417;
int VFX_DUR_GLOW_LIGHT_ORANGE          = 418;
int VFX_DUR_GLOW_BROWN                 = 419;
int VFX_DUR_GLOW_LIGHT_BROWN           = 420;
int VFX_DUR_GLOW_GREY                  = 421;
int VFX_DUR_GLOW_WHITE                 = 422;
int VFX_DUR_GLOW_LIGHT_PURPLE          = 423;
int VFX_DUR_GHOST_TRANSPARENT          = 424;
int VFX_DUR_GHOST_SMOKE                = 425;
int VFX_DUR_GLYPH_OF_WARDING           = 445;
int VFX_FNF_SOUND_BURST_SILENT         = 446;
int VFX_FNF_ELECTRIC_EXPLOSION         = 459;
int VFX_IMP_DUST_EXPLOSION             = 460;
int VFX_IMP_PULSE_HOLY_SILENT          = 461;
int VFX_DUR_DEATH_ARMOR                = 463;
int VFX_HIT_HELLBALL_AOE           = 464;   // AFW-OEI 05/04/2007
int VFX_DUR_ICESKIN                    = 465;
int VFX_FNF_SWINGING_BLADE             = 473;
int VFX_DUR_INFERNO                    = 474;
int VFX_FNF_DEMON_HAND                 = 475;
int VFX_DUR_STONEHOLD                  = 476;
int VFX_FNF_MYSTICAL_EXPLOSION         = 477;
int VFX_DUR_GHOSTLY_VISAGE_NO_SOUND    = 478;
int VFX_DUR_GHOST_SMOKE_2              = 479;
int VFX_DUR_FLIES                      = 480;
int VFX_FNF_SUMMONDRAGON               = 481;
int VFX_BEAM_FIRE_W                    = 482;
int VFX_BEAM_FIRE_W_SILENT             = 483;
int VFX_BEAM_CHAIN                     = 484;
int VFX_BEAM_BLACK                     = 485;
int VFX_IMP_WALLSPIKE                  = 486;
int VFX_FNF_GREATER_RUIN               = 487;
int VFX_FNF_UNDEAD_DRAGON              = 488;
int VFX_DUR_PROT_EPIC_ARMOR            = 495;
int VFX_FNF_SUMMON_EPIC_UNDEAD         = 496;
int VFX_DUR_PROT_EPIC_ARMOR_2          = 497;
int VFX_DUR_INFERNO_CHEST              = 498;
int VFX_DUR_IOUNSTONE_RED              = 499;
int VFX_DUR_IOUNSTONE_BLUE             = 500;
int VFX_DUR_IOUNSTONE_YELLOW           = 501;
int VFX_DUR_IOUNSTONE_GREEN            = 502;
int VFX_IMP_MIRV_ELECTRIC              = 503;
int VFX_COM_CHUNK_RED_BALLISTA         = 504;
int VFX_DUR_INFERNO_NO_SOUND           = 505;


// New spell VFX
int VFX_DUR_SPELL_SHIELD                               = 512;
int VFX_DUR_SPELL_SHIELD_OF_FAITH                      = 513;
int VFX_DUR_SPELL_SANCTUARY                            = 514;
int VFX_DUR_SPELL_CHARM_PERSON                         = 515;
int VFX_DUR_SPELL_CHARM_MONSTER                        = 516;
int VFX_DUR_SPELL_BURNING_HANDS                        = 517;
int VFX_BEAM_SHOCKING_GRASP                            = 518;
int VFX_DUR_SPELL_BLIND_DEAF                           = 519;
int VFX_DUR_SPELL_FALSE_LIFE                           = 520;
int VFX_BEAM_ABJURATION                                = 521;
int VFX_BEAM_CONJURATION                               = 522;
int VFX_BEAM_CURES                                     = 523;
int VFX_BEAM_DIVINATION                                = 524;
int VFX_BEAM_ENCHANTMENT                               = 525;
int VFX_BEAM_EVOCATION                                 = 526;
int VFX_BEAM_ILLUSION                                  = 527;
int VFX_BEAM_NECROMANCY                                = 528;
int VFX_BEAM_TRANSMUTATION                             = 529;
int VFX_HIT_SPELL_ABJURATION                           = 530;
int VFX_HIT_SPELL_CONJURATION                          = 531;
int VFX_HIT_SPELL_DIVINATION                           = 532;
int VFX_HIT_SPELL_ENCHANTMENT                          = 533;
int VFX_HIT_SPELL_EVOCATION                            = 534;
int VFX_HIT_SPELL_ILLUSION                             = 535;
int VFX_HIT_SPELL_NECROMANCY                           = 536;
int VFX_HIT_SPELL_TRANSMUTATION                        = 537;
int VFX_DUR_SPELL_ACIDFOG                              = 538;
int VFX_DUR_SPELL_BLESS                                = 539;
int VFX_DUR_SPELL_DOM_ANIMAL                           = 540;
int VFX_DUR_SPELL_DOM_MONSTER                          = 541;
int VFX_DUR_SPELL_DOM_PERSON                           = 542;
int VFX_DUR_SPELL_FEEBLEMIND                           = 543;
int VFX_DUR_SPELL_PRAYER                               = 544;
int VFX_BEAM_PRISMATIC_SPRAY                           = 545;
int VFX_DUR_SPELL_PRISMATIC_SPRAY                      = 546;
int VFX_HIT_SPELL_SEARING_LIGHT                        = 547;
int VFX_HIT_SPELL_DISPLACEMENT                         = 548;
int VFX_DUR_SPELL_CAUSE_FEAR                           = 549;
int VFX_HIT_SPELL_FINGER_OF_DEATH                      = 550;
int VFX_HIT_SPELL_POISON                               = 551;
int VFX_HIT_AOE_ABJURATION                             = 552;
int VFX_HIT_AOE_CONJURATION                            = 553;
int VFX_HIT_AOE_DIVINATION                             = 554;
int VFX_HIT_AOE_ENCHANTMENT                            = 555;
int VFX_HIT_AOE_EVOCATION                              = 556;
int VFX_HIT_AOE_ILLUSION                               = 557;
int VFX_HIT_AOE_NECROMANCY                             = 558;
int VFX_HIT_AOE_TRANSMUTATION                          = 559;
int VFX_HIT_AOE_ACID                                   = 560;
int VFX_HIT_AOE_ELDRITCH                               = 561;
int VFX_HIT_AOE_EVIL                                   = 562;
int VFX_HIT_AOE_FIRE                                   = 563;
int VFX_HIT_AOE_HOLY                                   = 564;
int VFX_HIT_AOE_ICE                                    = 565;
int VFX_HIT_AOE_LIGHTNING                              = 566;
int VFX_HIT_AOE_MAGIC                                  = 567;
int VFX_HIT_AOE_POISON                                 = 568;
int VFX_HIT_AOE_SONIC                                  = 569;
int VFX_DUR_CONE_ACID                                  = 570;
int VFX_DUR_CONE_ELDRITCH                              = 571;
int VFX_DUR_CONE_EVIL                                  = 572;
int VFX_DUR_CONE_FIRE                                  = 573;
int VFX_DUR_CONE_HOLY                                  = 574;
int VFX_DUR_CONE_ICE                                   = 575;
int VFX_DUR_CONE_LIGHTNING                             = 576;
int VFX_DUR_CONE_MAGIC                                 = 577;
int VFX_DUR_CONE_POISON                                = 578;
int VFX_DUR_CONE_SONIC                                 = 579;
int VFX_HIT_SPELL_ACID                                 = 580;
int VFX_HIT_SPELL_ELDRITCH                             = 581;
int VFX_HIT_SPELL_EVIL                                 = 582;
int VFX_HIT_SPELL_FIRE                                 = 583;
int VFX_HIT_SPELL_HOLY                                 = 584;
int VFX_HIT_SPELL_ICE                                  = 585;
int VFX_HIT_SPELL_LIGHTNING                            = 586;
int VFX_HIT_SPELL_MAGIC                                = 587;
int VFX_HIT_SPELL_SONIC                                = 588;
int VFX_BEAM_ACID                                      = 589;
int VFX_BEAM_ELDRITCH                                  = 590;
int VFX_BEAM_EVIL                                      = 591;
int VFX_BEAM_FIRE                                      = 592;
int VFX_BEAM_HOLY                                      = 593;
int VFX_BEAM_ICE                                       = 594;
int VFX_BEAM_LIGHTNING                                 = 595;
int VFX_BEAM_MAGIC                                     = 596;
int VFX_BEAM_POISON                                    = 597;
int VFX_BEAM_SONIC                                     = 598;
int VFX_DUR_SPELL_BEAR_ENDURANCE                       = 599;
int VFX_DUR_SPELL_BULL_STRENGTH                        = 600;
int VFX_DUR_SPELL_CAT_GRACE                            = 601;
int VFX_DUR_SPELL_EAGLE_SPLENDOR                       = 602;
int VFX_DUR_SPELL_FOX_CUNNING                          = 603;
int VFX_DUR_SPELL_OWL_WISDOM                           = 604;
int VFX_DUR_SPELL_ENTROPIC_SHIELD                      = 605;
int VFX_HIT_SPELL_SUMMON_CREATURE                      = 606;
int VFX_DUR_CONE_COLORSPRAY                            = 607;
int VFX_DUR_SPELL_MAGE_ARMOR                           = 608;
int VFX_DUR_SPELL_AID                                  = 609;
int VFX_DUR_SPELL_DIVINE_FAVOR                         = 610;
int VFX_DUR_SPELL_VIRTUE                               = 611;
int VFX_HIT_SPELL_INFLICT_1                            = 612;
int VFX_HIT_SPELL_INFLICT_2                            = 613;
int VFX_HIT_SPELL_INFLICT_3                            = 614;
int VFX_HIT_SPELL_INFLICT_4                            = 615;
int VFX_HIT_SPELL_INFLICT_5                            = 616;
int VFX_HIT_SPELL_INFLICT_6                            = 617;
int VFX_DUR_SPELL_BANE                                 = 618;
int VFX_HIT_SPELL_ENLARGE_PERSON                       = 619;
int VFX_DUR_SPELL_GLOBE_INV_GREAT                      = 620;
int VFX_DUR_SPELL_GLOBE_INV_LESS                       = 621;
int VFX_DUR_SPELL_PROT_ARROWS                          = 622;
int VFX_DUR_SPELL_PROT_ALIGN                           = 623;
int VFX_DUR_SPELL_PROT_ENERGY                          = 624;
int VFX_DUR_SPELL_MIND_FOG                             = 625;
int VFX_HIT_SPELL_FLAMESTRIKE                          = 626;
int VFX_DUR_WINTER_WOLF_BREATH                         = 627;
int VFX_DUR_SPELL_RESISTANCE                           = 628;
int VFX_DUR_SPELL_AMPLIFY                              = 629;
int VFX_DUR_SPELL_BLESS_WEAPON                         = 630;
int VFX_DUR_SPELL_CAMOFLAGE                            = 631;
int VFX_DUR_SPELL_DEATHWATCH                           = 632;
int VFX_DUR_SPELL_DETECT_UNDEAD                        = 633;
int VFX_DUR_SPELL_ENDURE_ELEMENTS                      = 634;
int VFX_DUR_SPELL_EXPEDITIOUS_RETREAT                  = 635;
int VFX_DUR_SPELL_IDENTIFY                             = 636;
int VFX_DUR_SPELL_LOWLIGHT_VISION                      = 637;
int VFX_DUR_SPELL_MAGIC_FANG                           = 638;
int VFX_DUR_SPELL_MAGIC_WEAPON                         = 639;
int VFX_DUR_SPELL_RESIST_ENERGY                        = 640;
int VFX_DUR_SPELL_ULTRAVISION                          = 641;
int VFX_DUR_SPELL_AURA_OF_GLORY                        = 642;
int VFX_DUR_SPELL_BARKSKIN                             = 643;
int VFX_DUR_SPELL_BLINDSIGHT                           = 644;
int VFX_DUR_SPELL_CLARITY                              = 645;
int VFX_DUR_SPELL_DEATH_KNELL                          = 646;
int VFX_DUR_SPELL_FIND_TRAPS                           = 647;
int VFX_DUR_SPELL_FLAME_WEAPON                         = 648;
int VFX_DUR_SPELL_GHOSTLY_VISAGE                       = 649;
int VFX_DUR_SPELL_HEROISM                              = 650;
int VFX_DUR_SPELL_RAGE                                 = 651;
int VFX_DUR_SPELL_SEE_INVISIBILITY                     = 652;
int VFX_DUR_SPELL_CLAIRAUD                             = 653;
int VFX_DUR_SPELL_HASTE                                = 654;
int VFX_DUR_SPELL_KEEN_EDGE                            = 655;
int VFX_DUR_SPELL_GOOD_CIRCLE                          = 656;
int VFX_DUR_SPELL_EVIL_CIRCLE                          = 657;
int VFX_DUR_SPELL_GREATER_MAGIC_FANG                   = 658;
int VFX_DUR_SPELL_MAGIC_VESTMENT                       = 659;
int VFX_DUR_SPELL_GREATER_MAGIC_WEAPON                 = 660;
int VFX_DUR_SPELL_SPIDERSKIN                           = 661;
int VFX_DUR_SPELL_WEAPON_OF_IMPACT                     = 662;
int VFX_DUR_SPELL_ASSAY_RESISTANCE                     = 663;
int VFX_DUR_SPELL_DEATH_WARD                           = 664;
int VFX_DUR_SPELL_DIVINE_POWER                         = 665;
int VFX_DUR_SPELL_HOLY_SWORD                           = 666;
int VFX_DUR_SPELL_LEGEND_LORE                          = 667;
int VFX_DUR_SPELL_SPELL_IMMUNITY                       = 668;
int VFX_DUR_SPELL_STONESKIN                            = 669;
int VFX_DUR_SPELL_WAR_CRY                              = 670;
int VFX_DUR_SPELL_AWAKEN                               = 671;
int VFX_DUR_SPELL_ENERGY_BUFFER                        = 672;
int VFX_DUR_SPELL_ETHEREAL_VISAGE                      = 673;
int VFX_DUR_SPELL_GREATER_HEROISM                      = 674;
int VFX_DUR_SPELL_LESSER_MIND_BLANK                    = 675;
int VFX_DUR_SPELL_OWL_INSIGHT                          = 676;
int VFX_DUR_SPELL_LESSER_SPELL_MANTLE                  = 677;
int VFX_DUR_SPELL_SPELL_RESISTANCE                     = 678;
int VFX_DUR_SPELL_TRUE_SEEING                          = 679;
int VFX_DUR_SPELL_CONTROL_UNDEAD                       = 680;
int VFX_DUR_SPELL_ENERGY_IMMUNITY                      = 681;
int VFX_DUR_SPELL_STONEBODY                            = 682;
int VFX_DUR_SPELL_GREATER_STONESKIN                    = 683;
int VFX_DUR_SPELL_TENSERS_TRANSFORM                    = 684;
int VFX_DUR_SPELL_AURA_OF_VITALITY                     = 685;
int VFX_DUR_SPELL_SPELL_MANTLE                         = 686;
int VFX_DUR_SPELL_BLACKSTAFF                           = 687;
int VFX_DUR_SPELL_IRON_BODY                            = 688;
int VFX_DUR_SPELL_MIND_BLANK                           = 689;
int VFX_DUR_SPELL_PREMONITION                          = 690;
int VFX_DUR_SPELL_PROTECTION_FROM_SPELLS               = 691;
int VFX_DUR_SPELL_GREATER_SPELL_IMMUNITY               = 692;
int VFX_DUR_SPELL_ETHEREALNESS                         = 693;
int VFX_DUR_SPELL_GREATER_SPELL_MANTLE                 = 694;
int VFX_DUR_SPELL_UNDEATH_ETERNAL_FOE                  = 695;
int VFX_DUR_SPELL_GOOD_AURA                            = 696;
int VFX_DUR_SPELL_EVIL_AURA                            = 697;
int VFX_DUR_SPELL_DISPLACEMENT                         = 698;
int VFX_DUR_SPELL_VAMPIRIC_TOUCH                       = 699;
int VFX_DUR_SPELL_BATTLETIDE                           = 700;
int VFX_DUR_SPELL_VAMPIRIC_TOUCH_VICTIM                = 701;
int VFX_DUR_SPELL_BATTLETIDE_VICTIM                    = 702;
int VFX_DUR_SPELL_DAZE                                 = 703;
int VFX_DUR_SPELL_DOOM                                 = 704;
int VFX_DUR_SPELL_RAY_ENFEEBLE                         = 705;
int VFX_DUR_SPELL_TASHA_LAUGHTER                       = 706;
int VFX_DUR_SPELL_HOLD_ANIMAL                          = 707;
int VFX_DUR_SPELL_HOLD_PERSON                          = 708;
int VFX_DUR_SPELL_SILENCE                              = 709;
int VFX_DUR_SPELL_BESTOW_CURSE                         = 710;
int VFX_DUR_SPELL_CONFUSION                            = 711;
int VFX_DUR_SPELL_CRUSHING_DESP                        = 712;
int VFX_DUR_SPELL_FEAR                                 = 713;
int VFX_DUR_SPELL_MAGGOT_INFESTATION                   = 714;
int VFX_DUR_SPELL_INVISIBILITY_PURGE                   = 715;
int VFX_DUR_SPELL_SLOW                                 = 716;
int VFX_DUR_SPELL_HOLD_MONSTER                         = 717;
int VFX_DUR_SPELL_LESSER_SPELL_BREACH                  = 718;
int VFX_DUR_SPELL_MIND_FOG_VIC                         = 719;
int VFX_DUR_SPELL_SONG_OF_DISCORD                      = 720;
int VFX_DUR_SPELL_FLESH_TO_STONE                       = 721;
int VFX_DUR_SPELL_REPULSION                            = 722;
int VFX_DUR_SPELL_GREATER_SPELL_BREACH                 = 723;
int VFX_DUR_SPELL_WORD_OF_FAITH                        = 724;
int VFX_DUR_SPELL_ENERGY_DRAIN                         = 725;
int VFX_DUR_SPELL_CONTAGION                            = 726;
int VFX_DUR_SPELL_GLYPH_WARDING                        = 727;
int VFX_DUR_SPELL_MAGIC_CIRCLE                         = 728;
int VFX_DUR_SPELL_CLOUDKILL                            = 729;
int VFX_DUR_SPELL_INCENDIARY_CLOUD                     = 730;
int VFX_DUR_SPELL_STINKING_CLOUD                       = 731;
int VFX_DUR_SPELL_WEB                                  = 732;
int VFX_DUR_SPELL_CLOUD_BEWILDERMENT                   = 733;
int VFX_DUR_SPELL_PRAYER_VIC                           = 734;
int VFX_HIT_SPELL_METEOR_SWARM_SML                     = 735;
int VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE                  = 736;
int VFX_SPELL_SHADES_DELAYED_FIREBALL                  = 737;
int VFX_SPELL_SHADES_BUFF                              = 738;
int VFX_SPELL_SHADES_SUMMON_CREATURE                   = 739;
int VFX_FEAT_TURN_UNDEAD                               = 740;
//int VFX_INVOCATION_BESHADOW_BLAST                     = 741;
//int VFX_INVOCATION_BEWITCH_BLAST                                  =742;
//int VFX_INVOCATION_BRIMESTONE_BLAST                               =743;
//int VFX_INVOCATION_DRAINING_BLAST                                 =744;
//int VFX_INVOCATION_FRIGHTFUL_BLAST                                    =745;
//int   VFX_INVOCATION_HELLRIME_BLAST                                   =746;
//int VFX_INVOCATION_NOXIOUS_BLAST                                  =747;
//int VFX_INVOCATION_UTTERDARK_BLAST                                    =748;
//int VFX_INVOCATION_VITRIOLIC_BLAST                                    =749;
int VFX_INVOCATION_BESHADOWED_BLOW                                  =750;
int VFX_INVOCATION_BESHADOWED_CHAIN                             =751;
int VFX_INVOCATION_BESHADOWED_CHAIN2                                =752;
int VFX_INVOCATION_BESHADOWED_HIT                                   =753;
int VFX_INVOCATION_BESHADOWED_RAY                                   =754;
int VFX_INVOCATION_BEWITCHING_BLOW                                  =755;
int VFX_INVOCATION_BEWITCHING_CHAIN                             =756;
int VFX_INVOCATION_BEWITCHING_CHAIN2                                =757;
int VFX_INVOCATION_BEWITCHING_CONE                                  =758;
int VFX_INVOCATION_BEWITCHING_DOOM                                  =759;
int VFX_INVOCATION_BESHADOWED_CONE                                  =760;
int VFX_INVOCATION_BESHADOWED_DOOM                                  =761;
int VFX_INVOCATION_BEWITCHING_HIT                                   =762;
int VFX_INVOCATION_BEWITCHING_RAY                                   =763;
int VFX_INVOCATION_BRIMSTONE_BLOW                                   =764;
int VFX_INVOCATION_BRIMSTONE_CHAIN                                  =765;
int VFX_INVOCATION_BRIMSTONE_CHAIN2                             =766;
int VFX_INVOCATION_BRIMSTONE_CONE                                   =767;
int VFX_INVOCATION_BRIMSTONE_DOOM                                   =768;
int VFX_INVOCATION_BRIMSTONE_HIT                                    =769;
int VFX_INVOCATION_BRIMSTONE_RAY                                    =770;
int VFX_INVOCATION_DRAINING_BLOW                                    =771;
int VFX_INVOCATION_DRAINING_CHAIN                                   =772;
int VFX_INVOCATION_DRAINING_CHAIN2                                  =773;
int VFX_INVOCATION_DRAINING_CONE                                    =774;
int VFX_INVOCATION_DRAINING_DOOM                                    =775;
int VFX_INVOCATION_DRAINING_HIT                                 =776;
int VFX_INVOCATION_DRAINING_RAY                                 =777;
int VFX_INVOCATION_ELDRITCH_AOE                 =778;
int VFX_INVOCATION_ELDRITCH_CHAIN               =779;
int VFX_INVOCATION_ELDRITCH_CHAIN2              =780;
int VFX_INVOCATION_ELDRITCH_CONE                =781;
int VFX_INVOCATION_ELDRITCH_HIT                 =782;
int VFX_INVOCATION_ELDRITCH_RAY                 =783;
int VFX_INVOCATION_ELDRITCH_TRAVEL              =784;
int VFX_INVOCATION_FRIGHTFUL_BLOW               =785;
int VFX_INVOCATION_FRIGHTFUL_CHAIN              =786;
int VFX_INVOCATION_FRIGHTFUL_CHAIN2             =787;
int VFX_INVOCATION_FRIGHTFUL_CONE               =788;
int VFX_INVOCATION_FRIGHTFUL_DOOM               =789;
int VFX_INVOCATION_FRIGHTFUL_HIT                =790;
int VFX_INVOCATION_FRIGHTFUL_RAY                =791;
int VFX_INVOCATION_HELLRIME_BLOW                =792;
int VFX_INVOCATION_HELLRIME_CHAIN               =793;
int VFX_INVOCATION_HELLRIME_CHAIN2              =794;
int VFX_INVOCATION_HELLRIME_CONE                =795;
int VFX_INVOCATION_HELLRIME_DOOM                =796;
int VFX_INVOCATION_HELLRIME_HIT                 =797;
int VFX_INVOCATION_HELLRIME_RAY                 =798;
int VFX_INVOCATION_HIDEOUS_BLOW                 =799;
int VFX_INVOCATION_HIDEOUS_CHAIN                =800;
int VFX_INVOCATION_HIDEOUS_CHAIN2               =801;
int VFX_INVOCATION_HIDEOUS_CONE                 =803;
int VFX_INVOCATION_HIDEOUS_DOOM                 =804;
int VFX_INVOCATION_HIDEOUS_HIT                  =805;
int VFX_INVOCATION_HIDEOUS_RAY                  =806;
int VFX_INVOCATION_NOXIOUS_BLOW                 =807;
int VFX_INVOCATION_NOXIOUS_CHAIN                =808;
int VFX_INVOCATION_NOXIOUS_CHAIN2               =809;
int VFX_INVOCATION_NOXIOUS_CONE                 =810;
int VFX_INVOCATION_NOXIOUS_DOOM                 =811;
int VFX_INVOCATION_NOXIOUS_HIT                  =812;
int VFX_INVOCATION_NOXIOUS_RAY                  =813;
int VFX_INVOCATION_UTTERDARK_BLOW               =814;
int VFX_INVOCATION_UTTERDARK_CHAIN              =815;
int VFX_INVOCATION_UTTERDARK_CHAIN2             =816;
int VFX_INVOCATION_UTTERDARK_CONE               =817;
int VFX_INVOCATION_UTTERDARK_DOOM               =818;
int VFX_INVOCATION_UTTERDARK_HIT                =819;
int VFX_INVOCATION_UTTERDARK_RAY                =820;
int VFX_INVOCATION_VITRIOLIC_BLOW               =821;
int VFX_INVOCATION_VITRIOLIC_CHAIN              =822;
int VFX_INVOCATION_VITRIOLIC_CHAIN2             =823;
int VFX_INVOCATION_VITRIOLIC_CONE               =824;
int VFX_INVOCATION_VITRIOLIC_DOOM               =825;
int VFX_INVOCATION_VITRIOLIC_HIT                =826;
int VFX_INVOCATION_VITRIOLIC_RAY                =827;
int VFX_DUR_GREASE                              =828;
int VFX_DUR_STUN                                =829;
int VFX_COM_BLOOD_REG_BLACK                     = 830;
int VFX_COM_BLOOD_REG_DUST                      = 831;
int VFX_HIT_SPELL_BALAGARN_IRON_HORN            = 832;
int VFX_INVOCATION_WORD_OF_CHANGING             = 833;
int VFX_DUR_AOE_CREEPING_DOOM                   = 834;
int VFX_DUR_POLYMORPH                           = 835;
//836
//837
int VFX_HIT_CURE_AOE                            = 838;
int VFX_HIT_TURN_UNDEAD                         = 839;
int VFX_PER_AOE_TENACIOUS                       = 840;
int VFX_DUR_GATE                                = 841;
int VFX_CAST_BARD_INS                           = 842;
int VFX_CAST_BARD_SONG                          = 843;
int VFX_HIT_BARD_COUNTERSONG                    = 844;
int VFX_HIT_BARD_HAVEN_SONG                     = 845;
int VFX_HIT_BARD_INS_COMPETENCE                 = 846;
int VFX_HIT_BARD_INS_COURAGE                    = 847;
int VFX_HIT_BARD_INS_DEFENSE                    = 848;
int VFX_HIT_BARD_INS_HEROICS                    = 849;
int VFX_HIT_BARD_INS_JARRING                    = 850;
int VFX_HIT_BARD_INS_LEGION                     = 851;
int VFX_HIT_BARD_INS_REGENERATION               = 852;
int VFX_HIT_BARD_INS_SLOWING                    = 853;
int VFX_HIT_BARD_INS_TOUGHNESS                  = 854;
int VFX_DUR_BARD_SONG_IRONSKIN                  = 855;
int VFX_HIT_BARD_SONG_FREEDOM                   = 856;
int VFX_DUR_INVOCATION_DARKONESLUCK             = 857;
int VFX_DUR_INVOCATION_LEAPS_BOUNDS             = 858;
int VFX_DUR_INVOCATION_BEGUILE_INFLUENCE        = 859;
int VFX_HIT_SPELL_METEOR_SWARM_LRG              = 860;
int VFX_DUR_INVOCATION_RETRIBUTIVE_INVISIBILITY = 861;
int VFX_DUR_TAUNT                               = 862;
int VFX_DUR_NAUSEA                              = 863;
int VFX_DUR_SICKENED                            = 864;
int VFX_DUR_CURSESONG                           = 865;
int VFX_DUR_SLEEP                               = 866;
int VFX_HIT_BARD_CLOUDMIND                      = 867;
int VFX_HIT_DROWN                               = 869;
int VFX_BEAM_GREEN_DRAGON_ACID                  = 870;
int VFX_CONE_RED_DRAGON_FIRE                    = 871;
int VFX_DUR_SPELL_MIRROR_IMAGE_1                = 872;
int VFX_CONE_ACID_BREATH                        = 873;
int VFX_AURA_BLADE_BARRIER                      = 874;
int VFX_SPELL_HIT_EARTHQUAKE                    = 875;
int VFX_DUR_SPELL_MIRROR_IMAGE_SELF             = 876;
int VFX_DUR_SPELL_CREEPING_DOOM                 = 877;
int VFX_DUR_INVOCATION_TENACIOUS_PLAGUE         = 878;
int VFX_DUR_SPELL_INVISIBILITY_SPHERE           = 879;
int VFX_DUR_ITEM_CHOKING_POWDER                 = 880;
int VFX_DUR_CREATURE_AIR_ELEMENTAL              = 881;
int VFX_DUR_RUBUKE_UNDEAD                       = 882;
int VFX_DUR_REGENERATE                          = 883;
int VFX_AOE_WEB_OF_PURITY                       = 884;
int VFX_HIT_CRADLE_OF_RIME                      = 885;
int VFX_AOE_CRADLE_OF_RIME                      = 886;
int VFX_DUR_SHADOW_CLOAK                        = 887;
int VFX_AOE_SHADOW_PLAGUE                       = 888;
int VFX_DUR_SHADOW_PLAGUE                       = 889;
int VFX_HIT_AURORA_CHAIN                        = 890;
int VFX_DUR_AURORA_CHAIN                        = 891;
int VFX_HIT_CLEANSING_NOVA                      = 892;
int VFX_DUR_SHINING_SHIELD                      = 893;
int VFX_DUR_FIRE                                = 894;
int VFX_CREATURE_ABILITY_DUR_MINDFLAYER         = 895;
int VFX_FNF_CRAFT_SELF                          = 896;
int VFX_FNF_CRAFT_ALCHEMY                       = 897;
int VFX_FNF_CRAFT_BLACKSMITH                    = 898;
int VFX_FNF_CRAFT_MAGIC                         = 899;
int VFX_BEAM_WEB_OF_PURITY                      = 900;
int VFX_DUR_FIREBALL                            = 901;
int VFX_DUR_WAUKEEN_HALO                        = 902;
int VFX_DUR_SOOTHING_LIGHT                      = 903;
int VFX_DUR_SPELL_MELFS_ACID_ARROW              = 904;
int VFX_HIT_SPELL_METEOR_SWARM                  = 905;
int VFX_DUR_FEAT_SACRED_VENGEANCE               = 906;
int VFX_DUR_FEAT_DIVINE_RESISTANCE              = 907;
int VFX_SOUND_WEB                               = 908;
int VFX_SOUND_BLADE                             = 909;
int VFX_SOUND_ENTANGLE                          = 910;
int VFX_SOUND_FIRE                              = 911;
int VFX_SOUND_SPIKE                             = 912;
int VFX_SOUND_TENTACLE                          = 913;
int VFX_DUR_FEAT_FIENDISH_RES                   = 914;
int VFX_SPELL_DUR_CALL_LIGHTNING                = 915;
int VFX_SPELL_HIT_CALL_LIGHTNING                = 916;
int VFX_SPELL_HIT_SWAMP_LUNG                    = 917;
int VFX_SPELL_DUR_TORT_SHELL                    = 918;
int VFX_SPELL_DUR_COCOON                        = 919;
int VFX_SPELL_DUR_FOUND_STONE                   = 920;
int VFX_SPELL_BEAM_MOON_BOLT                    = 921;
int VFX_SPELL_DUR_JAGGED_TOOTH                  = 922;
int VFX_SPELL_DUR_NATURE_AVATAR                 = 923;
int VFX_SPELL_DUR_BODY_SUN                      = 924;
int VFX_SPELL_DUR_STORM_AVATAR                  = 925;

// AFW-OEI 02/28/2007: Ioun Stone VFX
int VFX_DUR_IOUN_STONE_STR                  = 926;
int VFX_DUR_IOUN_STONE_DEX                  = 927;
int VFX_DUR_IOUN_STONE_CON                  = 928;
int VFX_DUR_IOUN_STONE_INT                  = 929;
int VFX_DUR_IOUN_STONE_WIS                  = 930;
int VFX_DUR_IOUN_STONE_CHA                  = 931;

int VFX_HIT_HELLBALL                        = 941;  // AFW-OEI 05/04/2007

// AFW-OEI 05/08/2007: New Warlock Eldritch Essences
int VFX_INVOCATION_HINDERING_BLOW               =942;
int VFX_INVOCATION_HINDERING_CHAIN              =943;
int VFX_INVOCATION_HINDERING_CHAIN2             =944;
int VFX_INVOCATION_HINDERING_CONE               =945;
int VFX_INVOCATION_HINDERING_DOOM               =946;
int VFX_INVOCATION_HINDERING_HIT                =947;
int VFX_INVOCATION_HINDERING_RAY                =948;
int VFX_INVOCATION_BINDING_BLOW                 =949;
int VFX_INVOCATION_BINDING_CHAIN                =950;
int VFX_INVOCATION_BINDING_CHAIN2               =951;
int VFX_INVOCATION_BINDING_CONE                 =952;
int VFX_INVOCATION_BINDING_DOOM                 =953;
int VFX_INVOCATION_BINDING_HIT                  =954;
int VFX_INVOCATION_BINDING_RAY                  =955;

// AFW-OEI 06/21/2007: New Spells & Spirit Shamans
int VFX_DUR_SPELL_LIONHEART                 = 965;
int VFX_DUR_SPELL_DETECT_SPIRITS                = 966;
int VFX_DUR_SPELL_SPIRIT_FORM                   = 967;
int VFX_DUR_SPELL_SPIRIT_JOURNEY                = 968;
int VFX_DUR_SPELL_LESSER_VIGOR                  = 969;
int VFX_DUR_SPELL_VIGOR                     = 970;
int VFX_DUR_SPELL_MASS_LESSER_VIGOR             = 971;
int VFX_DUR_SPELL_VIGOROUS_CYCLE                = 972;
int VFX_DUR_SPELL_SUPERIOR_RESISTANCE               = 973;
int VFX_DUR_SPELL_RECITATION                    = 974;

int VFX_DUR_SPELL_LAST_STAND                    = 975;  // AFW-OEI 06/27/2007
int VFX_HIT_SPELL_CURSE_OF_IMPENDING_BLADES         = 976;  // AFW-OEI 06/27/2007
int VFX_DUR_SACRED_FLAMES                   = 977;  // AFW-OEI 06/28/2007
int VFX_DUR_SPELL_LESSER_VISAGE                 = 978;  // AFW-OEI 06/28/2007
int VFX_DUR_SPELL_VISAGE_GOOD                   = 979;  // AFW-OEI 06/28/2007
int VFX_DUR_SPELL_VISAGE_NEUTRAL                = 980;  // AFW-OEI 06/28/2007
int VFX_DUR_SPELL_VISAGE_EVIL                   = 981;  // AFW-OEI 06/28/2007
int VFX_HIT_SPELL_DISINTEGRATE                  = 982;  // AFW-OEI 07/02/2007
int VFX_DUR_SPELL_SHADOW_SIMULACRUM             = 983;  // AFW-OEI 07/02/2007
int VFX_DUR_SPELL_SHROUDING_FOG                 = 985;  // AFW-OEI 07/09/2007

// AFW-OEI 07/10/2007: Big NX1 VFX update
int VFX_DUR_SPELL_POWER_WORD_WEAKEN             = 986;
int VFX_DUR_SPELL_POWER_WORD_PETRIFY                = 987;
int VFX_DUR_SPELL_POWER_WORD_MALADROIT              = 988;
int VFX_DUR_SPELL_POWER_WORD_BLIND              = 989;
int VFX_DUR_SPELL_TOUCH_OF_IDIOCY               = 990;
int VFX_HIT_SPELL_AVASCULATE                    = 991;
int VFX_DUR_SPELL_GLACIAL_WRATH                 = 992;
int VFX_DUR_SPELL_CREEPING_COLD                 = 993;
int VFX_DUR_SPELL_MASS_CURSE_OF_BLADES              = 996;
int VFX_DUR_SPELL_HISS_OF_SLEEP                 = 997;
int VFX_HIT_SPELL_MASS_FOWL                 = 998;
int VFX_HIT_SPELL_WALL_OF_DISPEL                = 999;
int VFX_HIT_SPELL_ENTROPIC_HUSK                 = 1000;
int VFX_DUR_SPELL_CURSE_OF_BLADES               = 1001;
int VFX_DUR_INNER_ARMOR                     = 1002;
int VFX_DUR_SPELL_GLASS_DOPPELGANGER                = 1003;
int VFX_HIT_SPELL_VAMPIRIC_FEAST                = 1004;
int VFX_DUR_SPELL_GREATER_RESISTANCE                = 1005;
int VFX_DUR_SPELL_SOLIPSISM                 = 1006;
int VFX_HIT_SPELL_TOUCH_OF_FATIGUE              = 1007;
int VFX_HIT_SPELL_SHOUT                     = 1008;
int VFX_HIT_SPELL_GREATER_SHOUT                 = 1009;
int VFX_DUR_SPELL_EPIC_GATE                 = 1010;
int VFX_DUR_BLAZING_AURA                    = 1011;
int VFX_HIT_CHASTISE_SPIRITS                    = 1012;
int VFX_HIT_WEAKEN_SPIRITS                  = 1013;
int VFX_DUR_RESCUER                     = 1014;
int VFX_BEAM_RESCUEE                        = 1015;
int VFX_CAST_SPELL_SPIRIT_EMERGE                = 1016;
int VFX_CAST_SPELL_SPIRIT_EMERGE_GOOD               = 1017;
int VFX_HIT_BARD_REQUIEM                    = 1018;

int VFX_HIT_SPELL_BLADEWEAVE                    = 1020;
int VFX_HIT_SPELL_BLOOD_TO_WATER                    = 1021;
int VFX_AOE_SPELL_BLOOD_TO_WATER                    = 1022;
int VFX_HIT_SPELL_BODAKS_GLARE                  = 1023;
int VFX_SUMMON_SPELL_BODAKS_GLARE                   = 1024;
int VFX_HIT_SPELL_CASTIGATE                 = 1025;
int VFX_AOE_SPELL_CASTIGATE                 = 1026;
int VFX_HIT_SPELL_CONVICTION                    = 1027;
int VFX_HIT_SPELL_DEHYDRATION                   = 1028;
int VFX_DUR_SPELL_ANIMALISTIC_POWER                 = 1029;
int VFX_HIT_SPELL_LIVING_UNDEATH                    = 1030;
int VFX_HIT_SPELL_HEALING_STING                 = 1031;
int VFX_HEAL_SPELL_HEALING_STING                    = 1032;
int VFX_DUR_SPELL_NIGHTSHIELD                   = 1033;
int VFX_DUR_SPELL_LIVING_UNDEATH                    = 1034;
int VFX_DUR_SPELL_SYMBOL_OF_DEATH                   = 1035;
int VFX_DUR_SPELL_SYMBOL_OF_FEAR                    = 1036;
int VFX_DUR_SPELL_SYMBOL_OF_PAIN                    = 1037;
int VFX_DUR_SPELL_SYMBOL_OF_PERSUASION                  = 1038;
int VFX_DUR_SPELL_SYMBOL_OF_SLEEP                   = 1039;
int VFX_DUR_SPELL_SYMBOL_OF_STUNNING                    = 1040;
int VFX_DUR_SPELL_SYMBOL_OF_WEAKNESS                    = 1041;
int VFX_AOE_SYMBOL_SPELL                    = 1042;
int VFX_AURA_HELLFIRE_BLAST                 = 1043;
int VFX_AURA_HELLFIRE_SHIELD                = 1044;
int VFX_AOE_ETHEREAL_PURGE                  = 1045;
int VFX_DUR_BOND_OF_FATAL_TOUCH             = 1046;
int VFX_HIT_SPELL_REDUCE_PERSON             = 1047;
int VFX_HIT_SPELL_SNAKESSWIFTNESS           = 1048;


int AOE_PER_FOGACID                = 0;
int AOE_PER_FOGFIRE                = 1;
int AOE_PER_FOGSTINK               = 2;
int AOE_PER_FOGKILL                = 3;
int AOE_PER_FOGMIND                = 4;
int AOE_PER_WALLFIRE               = 5;
int AOE_PER_WALLWIND               = 6;
int AOE_PER_WALLBLADE              = 7;
int AOE_PER_WEB                    = 8;
int AOE_PER_ENTANGLE               = 9;
//int AOE_PER_CHAOS = 10;
int AOE_PER_DARKNESS               = 11;
int AOE_MOB_CIRCEVIL               = 12;
int AOE_MOB_CIRCGOOD               = 13;
int AOE_MOB_CIRCLAW                = 14;
int AOE_MOB_CIRCCHAOS              = 15;
int AOE_MOB_FEAR                   = 16;
int AOE_MOB_BLINDING               = 17;
int AOE_MOB_UNEARTHLY              = 18;
int AOE_MOB_MENACE                 = 19;
int AOE_MOB_UNNATURAL              = 20;
int AOE_MOB_STUN                   = 21;
int AOE_MOB_PROTECTION             = 22;
int AOE_MOB_FIRE                   = 23;
int AOE_MOB_FROST                  = 24;
int AOE_MOB_ELECTRICAL             = 25;
int AOE_PER_FOGGHOUL               = 26;
int AOE_MOB_TYRANT_FOG             = 27;
int AOE_PER_STORM                  = 28;
int AOE_PER_INVIS_SPHERE           = 29;
int AOE_MOB_SILENCE                = 30;
int AOE_PER_DELAY_BLAST_FIREBALL   = 31;
int AOE_PER_GREASE                 = 32;
int AOE_PER_CREEPING_DOOM          = 33;
int AOE_PER_EVARDS_BLACK_TENTACLES = 34;
int AOE_MOB_INVISIBILITY_PURGE     = 35;
int AOE_MOB_DRAGON_FEAR            = 36;
int AOE_PER_CUSTOM_AOE             = 37;
int AOE_PER_GLYPH_OF_WARDING       = 38;
int AOE_PER_FOG_OF_BEWILDERMENT    = 39;
int AOE_PER_VINE_MINE_CAMOUFLAGE   = 40;
int AOE_MOB_TIDE_OF_BATTLE         = 41;
int AOE_PER_STONEHOLD              = 42;
int AOE_PER_VFX_OVERMIND       = 43;
int AOE_PER_CHILLING_TENTACLES     = 44;
int AOE_PER_WALL_PERILOUS_FLAME    = 45;
int AOE_PER_TENACIOUS_PLAGUE       = 46;
int AOE_PER_SPIKE_GROWTH           = 47;
int AOE_PER_CHOKE_POWDER           = 48;
int AOE_PER_CLEANSING_NOVA     = 49;
int AOE_PER_PROTECTIVE_AURA    = 50;
int AOE_PER_PROTECTIVE_AURA_II     = 51;
int AOE_PER_WAR_GLORY          = 52;
int AOE_PER_AURA_OF_COURAGE    = 53;
int AOE_PER_AURA_OF_DESPAIR    = 54;
int AOE_MOB_HEZROU_STENCH       = 55;
int AOE_MOB_GHAST_STENCH        = 56;
int AOE_MOB_BLADE_BARRIER       = 57;
int AOE_MOB_SHADOW_PLAGUE       = 58;
int AOE_MOB_SHARD_BARRIER       = 59;
int AOE_MOB_BODY_SUN            = 60;
int AOE_MOB_REACH_TO_THE_BLAZE      = 63;
int AOE_PER_SHROUDING_FOG       = 64;
int AOE_MOB_DROWNED_AURA        = 66;
int AOE_PER_KELEMVORS_GRACE     = 67; // JWR-OEI 05/28/2008
int AOE_PER_HELLFIRE_SHIELD     = 68; // JWR-OEI 06.17.2008






int SPELL_ALL_SPELLS                        = -1;  // used for spell immunity.
int SPELL_ACID_FOG                          = 0;
int SPELL_AID                               = 1;
int SPELL_ANIMATE_DEAD                      = 2;
int SPELL_BARKSKIN                          = 3;
int SPELL_BESTOW_CURSE                      = 4;
int SPELL_BLADE_BARRIER                     = 5;
int SPELL_BLESS                             = 6;
int SPELL_BLESS_WEAPON                      = 537;
int SPELL_BLINDNESS_AND_DEAFNESS            = 8;
int SPELL_BULLS_STRENGTH                    = 9;
int SPELL_BURNING_HANDS                     = 10;
int SPELL_CALL_LIGHTNING                    = 11;
//int SPELL_CALM_EMOTIONS = 12;
int SPELL_CATS_GRACE                        = 13;
int SPELL_CHAIN_LIGHTNING                   = 14;
int SPELL_CHARM_MONSTER                     = 15;
int SPELL_CHARM_PERSON                      = 16;
int SPELL_CHARM_PERSON_OR_ANIMAL            = 17;
int SPELL_CIRCLE_OF_DEATH                   = 18;
//int SPELL_CIRCLE_OF_DOOM                    = 19;
int SPELL_MASS_INFLICT_LIGHT_WOUNDS         = 19;    // JLR - OEI 08/23/05 -- Renamed for 3.5
int SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE    = 20;
int SPELL_CLARITY                           = 21;
int SPELL_CLOAK_OF_CHAOS                    = 22;
int SPELL_CLOUDKILL                         = 23;
int SPELL_COLOR_SPRAY                       = 24;
int SPELL_CONE_OF_COLD                      = 25;
int SPELL_CONFUSION                         = 26;
int SPELL_CONTAGION                         = 27;
int SPELL_CONTROL_UNDEAD                    = 28;
int SPELL_CREATE_GREATER_UNDEAD             = 29;
int SPELL_CREATE_UNDEAD                     = 30;
int SPELL_CURE_CRITICAL_WOUNDS              = 31;
int SPELL_CURE_LIGHT_WOUNDS                 = 32;
int SPELL_CURE_MINOR_WOUNDS                 = 33;
int SPELL_CURE_MODERATE_WOUNDS              = 34;
int SPELL_CURE_SERIOUS_WOUNDS               = 35;
int SPELL_DARKNESS                          = 36;
int SPELL_DAZE                              = 37;
int SPELL_DEATH_WARD                        = 38;
int SPELL_DELAYED_BLAST_FIREBALL            = 39;
int SPELL_DISMISSAL                         = 40;
int SPELL_DISPEL_MAGIC                      = 41;
int SPELL_DIVINE_POWER                      = 42;
int SPELL_DOMINATE_ANIMAL                   = 43;
int SPELL_DOMINATE_MONSTER                  = 44;
int SPELL_DOMINATE_PERSON                   = 45;
int SPELL_DOOM                              = 46;
int SPELL_ELEMENTAL_SHIELD                  = 47;
int SPELL_ELEMENTAL_SWARM                   = 48;
int SPELL_BEARS_ENDURANCE                   = 49;   // JLR - OEI 07/11/05 -- Name changed from "Endurance"
int SPELL_ENDURE_ELEMENTS                   = 50;
int SPELL_ENERGY_DRAIN                      = 51;
int SPELL_ENERVATION                        = 52;
int SPELL_ENTANGLE                          = 53;
int SPELL_FEAR                              = 54;
int SPELL_FEEBLEMIND                        = 55;
int SPELL_FINGER_OF_DEATH                   = 56;
int SPELL_FIRE_STORM                        = 57;
int SPELL_FIREBALL                          = 58;
int SPELL_FLAME_ARROW                       = 59;
int SPELL_FLAME_LASH                        = 60;
int SPELL_FLAME_STRIKE                      = 61;
int SPELL_FREEDOM_OF_MOVEMENT               = 62;
int SPELL_GATE                              = 63;
int SPELL_GHOUL_TOUCH                       = 64;
int SPELL_GLOBE_OF_INVULNERABILITY          = 65;
int SPELL_GREASE                            = 66;
int SPELL_GREATER_DISPELLING                = 67;
//int SPELL_GREATER_MAGIC_WEAPON              = 68;
int SPELL_GREATER_PLANAR_BINDING            = 69;
int SPELL_GREATER_RESTORATION               = 70;
//int SPELL_GREATER_SHADOW_CONJURATION = 71;
int SPELL_GREATER_SPELL_BREACH              = 72;
int SPELL_GREATER_SPELL_MANTLE              = 73;
int SPELL_GREATER_STONESKIN                 = 74;
int SPELL_GUST_OF_WIND = 75;
int SPELL_HAMMER_OF_THE_GODS                = 76;
int SPELL_HARM                              = 77;
int SPELL_HASTE                             = 78;
int SPELL_HEAL                              = 79;
//int SPELL_HEALING_CIRCLE                    = 80;
int SPELL_MASS_CURE_LIGHT_WOUNDS            = 80;    // JLR - OEI 08/23/05 -- Renamed for 3.5
int SPELL_HOLD_ANIMAL                       = 81;
int SPELL_HOLD_MONSTER                      = 82;
int SPELL_HOLD_PERSON                       = 83;
int SPELL_HOLY_AURA                         = 84;
int SPELL_HOLY_SWORD                        = 538;
int SPELL_IDENTIFY                          = 86;
int SPELL_IMPLOSION                         = 87;
int SPELL_GREATER_INVISIBILITY              = 88;   // JLR - OEI 07/11/05 -- Name changed from "Improved Invis."
int SPELL_INCENDIARY_CLOUD                  = 89;
int SPELL_INVISIBILITY                      = 90;
int SPELL_INVISIBILITY_PURGE                = 91;
int SPELL_INVISIBILITY_SPHERE               = 92;
int SPELL_KNOCK                             = 93;
int SPELL_LESSER_DISPEL                     = 94;
int SPELL_LESSER_MIND_BLANK                 = 95;
int SPELL_LESSER_PLANAR_BINDING             = 96;
int SPELL_LESSER_RESTORATION                = 97;
int SPELL_LESSER_SPELL_BREACH               = 98;
int SPELL_LESSER_SPELL_MANTLE               = 99;
int SPELL_LIGHT                             = 100;
int SPELL_LIGHTNING_BOLT                    = 101;
int SPELL_MAGE_ARMOR                        = 102;
int SPELL_MAGIC_CIRCLE_AGAINST_CHAOS        = 103;
int SPELL_MAGIC_CIRCLE_AGAINST_EVIL         = 104;
int SPELL_MAGIC_CIRCLE_AGAINST_GOOD         = 105;
int SPELL_MAGIC_CIRCLE_AGAINST_LAW          = 106;
int SPELL_MAGIC_MISSILE                     = 107;
int SPELL_MAGIC_VESTMENT                    = 546;
//int SPELL_MAGIC_WEAPON                      = 109;
int SPELL_MASS_BLINDNESS_AND_DEAFNESS       = 110;
int SPELL_MASS_CHARM                        = 111;
// int SPELL_MASS_DOMINATION = 112;
int SPELL_MASS_HASTE                        = 113;
int SPELL_MASS_HEAL                         = 114;
int SPELL_MELFS_ACID_ARROW                  = 115;
int SPELL_METEOR_SWARM                      = 116;
int SPELL_MIND_BLANK                        = 117;
int SPELL_MIND_FOG                          = 118;
int SPELL_LESSER_GLOBE_OF_INVULNERABILITY   = 119;  // JLR - OEI 07/11/05 -- Name changed from "Minor ..."
int SPELL_GHOSTLY_VISAGE                    = 120;
int SPELL_ETHEREAL_VISAGE                   = 121;
int SPELL_MORDENKAINENS_DISJUNCTION         = 122;
int SPELL_MORDENKAINENS_SWORD               = 123;
int SPELL_NATURES_BALANCE                   = 124;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_NEGATIVE_ENERGY_PROTECTION        = 125;  // JLR - OEI 07/16/05 -- REMOVED
int SPELL_NEUTRALIZE_POISON                 = 126;
int SPELL_PHANTASMAL_KILLER                 = 127;
int SPELL_PLANAR_BINDING                    = 128;
int SPELL_POISON                            = 129;
int SPELL_POLYMORPH_SELF                    = 130;
int SPELL_POWER_WORD_KILL                   = 131;
int SPELL_POWER_WORD_STUN                   = 132;
int SPELL_PRAYER                            = 133;
int SPELL_PREMONITION                       = 134;
int SPELL_PRISMATIC_SPRAY                   = 135;
int SPELL_PROTECTION_FROM_CHAOS             = 136;  // RWT-OEI 03/19/07 - Removed the extra _ mark from this name
int SPELL_PROTECTION_FROM_ENERGY            = 137;  // JLR - OEI 07/11/05 -- Name changed from "Prot. from Elements"
int SPELL_PROTECTION_FROM_EVIL              = 138;
int SPELL_PROTECTION_FROM_GOOD              = 139;
int SPELL_PROTECTION_FROM_LAW               = 140;
int SPELL_PROTECTION_FROM_SPELLS            = 141;
int SPELL_RAISE_DEAD                        = 142;
int SPELL_RAY_OF_ENFEEBLEMENT               = 143;
int SPELL_RAY_OF_FROST                      = 144;
int SPELL_REMOVE_BLINDNESS_AND_DEAFNESS     = 145;
int SPELL_REMOVE_CURSE                      = 146;
int SPELL_REMOVE_DISEASE                    = 147;
int SPELL_REMOVE_FEAR                       = 148;
int SPELL_REMOVE_PARALYSIS                  = 149;
int SPELL_RESIST_ENERGY                     = 150;  // JLR - OEI 07/11/05 -- Name changed from "Resist Elements"
int SPELL_RESISTANCE                        = 151;
int SPELL_RESTORATION                       = 152;
int SPELL_RESURRECTION                      = 153;
int SPELL_SANCTUARY                         = 154;
int SPELL_CAUSE_FEAR                        = 155;  // JLR - OEI 07/11/05 -- Name changed from "Scare"
int SPELL_SEARING_LIGHT                     = 156;
int SPELL_SEE_INVISIBILITY                  = 157;
//int SPELL_SHADES = 158;
//int SPELL_SHADOW_CONJURATION = 159;
int SPELL_SHADOW_SHIELD                     = 160;
int SPELL_SHAPECHANGE                       = 161;
int SPELL_SHIELD_OF_LAW                     = 162;
int SPELL_SILENCE                           = 163;
int SPELL_SLAY_LIVING                       = 164;
int SPELL_SLEEP                             = 165;
int SPELL_SLOW                              = 166;
int SPELL_SOUND_BURST                       = 167;
int SPELL_SPELL_RESISTANCE                  = 168;
int SPELL_SPELL_MANTLE                      = 169;
int SPELL_SPHERE_OF_CHAOS                   = 170;
int SPELL_STINKING_CLOUD                    = 171;
int SPELL_STONESKIN                         = 172;
int SPELL_STORM_OF_VENGEANCE                = 173;
int SPELL_SUMMON_CREATURE_I                 = 174;
int SPELL_SUMMON_CREATURE_II                = 175;
int SPELL_SUMMON_CREATURE_III               = 176;
int SPELL_SUMMON_CREATURE_IV                = 177;
int SPELL_SUMMON_CREATURE_IX                = 178;
int SPELL_SUMMON_CREATURE_V                 = 179;
int SPELL_SUMMON_CREATURE_VI                = 180;
int SPELL_SUMMON_CREATURE_VII               = 181;
int SPELL_SUMMON_CREATURE_VIII              = 182;
int SPELL_SUNBEAM                           = 183;
int SPELL_TENSERS_TRANSFORMATION            = 184;
int SPELL_TIME_STOP                         = 185;  // JLR - OEI 08/09/05 -- REMOVED
int SPELL_TRUE_SEEING                       = 186;
int SPELL_UNHOLY_AURA                       = 187;
int SPELL_VAMPIRIC_TOUCH                    = 188;
int SPELL_VIRTUE                            = 189;
int SPELL_WAIL_OF_THE_BANSHEE               = 190;
int SPELL_WALL_OF_FIRE                      = 191;
int SPELL_WEB                               = 192;
int SPELL_WEIRD                             = 193;
int SPELL_WORD_OF_FAITH                     = 194;
int SPELLABILITY_AURA_BLINDING              = 195;
int SPELLABILITY_AURA_COLD                  = 196;
int SPELLABILITY_AURA_ELECTRICITY           = 197;
int SPELLABILITY_AURA_FEAR                  = 198;
int SPELLABILITY_AURA_FIRE                  = 199;
int SPELLABILITY_AURA_MENACE                = 200;
int SPELLABILITY_AURA_PROTECTION            = 201;
int SPELLABILITY_AURA_STUN                  = 202;
int SPELLABILITY_AURA_UNEARTHLY_VISAGE      = 203;
int SPELLABILITY_AURA_UNNATURAL             = 204;
int SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA = 205;
int SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION = 206;
int SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY = 207;
int SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE = 208;
int SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH = 209;
int SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM  = 210;
int SPELLABILITY_BOLT_ACID                  = 211;
int SPELLABILITY_BOLT_CHARM                 = 212;
int SPELLABILITY_BOLT_COLD                  = 213;
int SPELLABILITY_BOLT_CONFUSE               = 214;
int SPELLABILITY_BOLT_DAZE                  = 215;
int SPELLABILITY_BOLT_DEATH                 = 216;
int SPELLABILITY_BOLT_DISEASE               = 217;
int SPELLABILITY_BOLT_DOMINATE              = 218;
int SPELLABILITY_BOLT_FIRE                  = 219;
int SPELLABILITY_BOLT_KNOCKDOWN             = 220;
int SPELLABILITY_BOLT_LEVEL_DRAIN           = 221;
int SPELLABILITY_BOLT_LIGHTNING             = 222;
int SPELLABILITY_BOLT_PARALYZE              = 223;
int SPELLABILITY_BOLT_POISON                = 224;
int SPELLABILITY_BOLT_SHARDS                = 225;
int SPELLABILITY_BOLT_SLOW                  = 226;
int SPELLABILITY_BOLT_STUN                  = 227;
int SPELLABILITY_BOLT_WEB                   = 228;
int SPELLABILITY_CONE_ACID                  = 229;
int SPELLABILITY_CONE_COLD                  = 230;
int SPELLABILITY_CONE_DISEASE               = 231;
int SPELLABILITY_CONE_FIRE                  = 232;
int SPELLABILITY_CONE_LIGHTNING             = 233;
int SPELLABILITY_CONE_POISON                = 234;
int SPELLABILITY_CONE_SONIC                 = 235;
int SPELLABILITY_DRAGON_BREATH_ACID         = 236;
int SPELLABILITY_DRAGON_BREATH_COLD         = 237;
int SPELLABILITY_DRAGON_BREATH_FEAR         = 238;
int SPELLABILITY_DRAGON_BREATH_FIRE         = 239;
int SPELLABILITY_DRAGON_BREATH_GAS          = 240;
int SPELLABILITY_DRAGON_BREATH_LIGHTNING    = 241;
int SPELLABILITY_DRAGON_BREATH_PARALYZE     = 242;
int SPELLABILITY_DRAGON_BREATH_SLEEP        = 243;
int SPELLABILITY_DRAGON_BREATH_SLOW         = 244;
int SPELLABILITY_DRAGON_BREATH_WEAKEN       = 245;
int SPELLABILITY_DRAGON_WING_BUFFET         = 246;
int SPELLABILITY_FEROCITY_1                 = 247;
int SPELLABILITY_FEROCITY_2                 = 248;
int SPELLABILITY_FEROCITY_3                 = 249;
int SPELLABILITY_GAZE_CHARM                 = 250;
int SPELLABILITY_GAZE_CONFUSION             = 251;
int SPELLABILITY_GAZE_DAZE                  = 252;
int SPELLABILITY_GAZE_DEATH                 = 253;
int SPELLABILITY_GAZE_DESTROY_CHAOS         = 254;
int SPELLABILITY_GAZE_DESTROY_EVIL          = 255;
int SPELLABILITY_GAZE_DESTROY_GOOD          = 256;
int SPELLABILITY_GAZE_DESTROY_LAW           = 257;
int SPELLABILITY_GAZE_DOMINATE              = 258;
int SPELLABILITY_GAZE_DOOM                  = 259;
int SPELLABILITY_GAZE_FEAR                  = 260;
int SPELLABILITY_GAZE_PARALYSIS             = 261;
int SPELLABILITY_GAZE_STUNNED               = 262;
int SPELLABILITY_GOLEM_BREATH_GAS           = 263;
int SPELLABILITY_HELL_HOUND_FIREBREATH      = 264;
int SPELLABILITY_HOWL_CONFUSE               = 265;
int SPELLABILITY_HOWL_DAZE                  = 266;
int SPELLABILITY_HOWL_DEATH                 = 267;
int SPELLABILITY_HOWL_DOOM                  = 268;
int SPELLABILITY_HOWL_FEAR                  = 269;
int SPELLABILITY_HOWL_PARALYSIS             = 270;
int SPELLABILITY_HOWL_SONIC                 = 271;
int SPELLABILITY_HOWL_STUN                  = 272;
int SPELLABILITY_INTENSITY_1                = 273;
int SPELLABILITY_INTENSITY_2                = 274;
int SPELLABILITY_INTENSITY_3                = 275;
int SPELLABILITY_KRENSHAR_SCARE             = 276;
int SPELLABILITY_LESSER_BODY_ADJUSTMENT     = 277;
int SPELLABILITY_MEPHIT_SALT_BREATH         = 278;
int SPELLABILITY_MEPHIT_STEAM_BREATH        = 279;
int SPELLABILITY_MUMMY_BOLSTER_UNDEAD       = 280;
int SPELLABILITY_PULSE_DROWN                = 281;
int SPELLABILITY_PULSE_SPORES               = 282;
int SPELLABILITY_PULSE_WHIRLWIND            = 283;
int SPELLABILITY_PULSE_FIRE                 = 284;
int SPELLABILITY_PULSE_LIGHTNING            = 285;
int SPELLABILITY_PULSE_COLD                 = 286;
int SPELLABILITY_PULSE_NEGATIVE             = 287;
int SPELLABILITY_PULSE_HOLY                 = 288;
int SPELLABILITY_PULSE_DEATH                = 289;
int SPELLABILITY_PULSE_LEVEL_DRAIN          = 290;
int SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE = 291;
int SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA = 292;
int SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION = 293;
int SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY = 294;
int SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH = 295;
int SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM = 296;
int SPELLABILITY_PULSE_POISON               = 297;
int SPELLABILITY_PULSE_DISEASE              = 298;
int SPELLABILITY_RAGE_3                     = 299;
int SPELLABILITY_RAGE_4                     = 300;
int SPELLABILITY_RAGE_5                     = 301;
int SPELLABILITY_SMOKE_CLAW                 = 302;
int SPELLABILITY_SUMMON_SLAAD               = 303;
int SPELLABILITY_SUMMON_TANARRI             = 304;
int SPELLABILITY_TRUMPET_BLAST              = 305;
int SPELLABILITY_TYRANT_FOG_MIST            = 306;
int SPELLABILITY_BARBARIAN_RAGE             = 307;
int SPELLABILITY_TURN_UNDEAD                = 308;
int SPELLABILITY_WHOLENESS_OF_BODY          = 309;
int SPELLABILITY_QUIVERING_PALM             = 310;
int SPELLABILITY_EMPTY_BODY                 = 311;
int SPELLABILITY_DETECT_EVIL                = 312;
int SPELLABILITY_LAY_ON_HANDS               = 313;
int SPELLABILITY_AURA_OF_COURAGE            = 314;
int SPELLABILITY_SMITE_EVIL                 = 315;
int SPELLABILITY_REMOVE_DISEASE             = 316;
int SPELLABILITY_SUMMON_ANIMAL_COMPANION    = 317;
int SPELLABILITY_SUMMON_FAMILIAR            = 318;
int SPELLABILITY_ELEMENTAL_SHAPE            = 319;
int SPELLABILITY_WILD_SHAPE                 = 320;
//int SPELL_PROTECTION_FROM_ALIGNMENT = 321;
//int SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT = 322;
//int SPELL_AURA_VERSUS_ALIGNMENT = 323;
int SPELL_SHADES_SUMMON_SHADOW              = 324;
int SPELL_DROWNED_AURA = 325;
//int SPELL_PROTECTION_FROM_ELEMENTS_FIRE = 326;
//int SPELL_PROTECTION_FROM_ELEMENTS_ACID = 327;
//int SPELL_PROTECTION_FROM_ELEMENTS_SONIC = 328;
//int SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY = 329;
//int SPELL_ENDURE_ELEMENTS_COLD = 330;
//int SPELL_ENDURE_ELEMENTS_FIRE = 331;
//int SPELL_ENDURE_ELEMENTS_ACID = 332;
//int SPELL_ENDURE_ELEMENTS_SONIC = 333;
//int SPELL_ENDURE_ELEMENTS_ELECTRICITY = 334;
//int SPELL_RESIST_ELEMENTS_COLD = 335;
//int SPELL_RESIST_ELEMENTS_FIRE = 336;
//int SPELL_RESIST_ELEMENTS_ACID = 337;
//int SPELL_RESIST_ELEMENTS_SONIC = 338;
//int SPELL_RESIST_ELEMENTS_ELECTRICITY = 339;
int SPELL_SHADES_CONE_OF_COLD               = 340;
int SPELL_SHADES_FIREBALL                   = 341;
int SPELL_SHADES_STONESKIN                  = 342;
int SPELL_SHADES_WALL_OF_FIRE               = 343;
int SPELL_SHADOW_CONJURATION_SUMMON_SHADOW  = 344;
int SPELL_SHADOW_CONJURATION_DARKNESS       = 345;
int SPELL_SHADOW_CONJURATION_INIVSIBILITY   = 346;
int SPELL_SHADOW_CONJURATION_MAGE_ARMOR     = 347;
int SPELL_SHADOW_CONJURATION_MAGIC_MISSILE  = 348;
int SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW = 349;
int SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW = 350;
int SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE = 351;
int SPELL_GREATER_SHADOW_CONJURATION_WEB    = 352;
int SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE = 353;
int SPELL_EAGLES_SPLENDOR                   = 354;
int SPELL_OWLS_WISDOM                       = 355;
int SPELL_FOXS_CUNNING                      = 356;
int SPELL_GREATER_EAGLE_SPLENDOR            = 357;
int SPELL_GREATER_OWLS_WISDOM               = 358;
int SPELL_GREATER_FOXS_CUNNING              = 359;
int SPELL_GREATER_BULLS_STRENGTH            = 360;
int SPELL_GREATER_CATS_GRACE                = 361;
int SPELL_GREATER_BEARS_ENDURANCE           = 362;  // JLR - OEI 07/11/05 -- Name Changed
int SPELL_AWAKEN                            = 363;
int SPELL_CREEPING_DOOM                     = 364;
int SPELL_DARKVISION                        = 365;
int SPELL_DESTRUCTION                       = 366;
int SPELL_HORRID_WILTING                    = 367;
int SPELL_ICE_STORM                         = 368;
int SPELL_ENERGY_BUFFER                     = 369;
int SPELL_NEGATIVE_ENERGY_BURST             = 370;  // JLR - OEI 07/11/05 -- REMOVED, but left in for traps/etc.
int SPELL_NEGATIVE_ENERGY_RAY               = 371;  // JLR - OEI 07/11/05 -- REMOVED, but left in for traps/etc.
int SPELL_AURA_OF_VITALITY                  = 372;
int SPELL_WAR_CRY                           = 373;
int SPELL_REGENERATE                        = 374;
int SPELL_EVARDS_BLACK_TENTACLES            = 375;
int SPELL_LEGEND_LORE                       = 376;
int SPELL_FIND_TRAPS                        = 377;
int SPELLABILITY_SUMMON_MEPHIT              = 378;

int SPELLABILITY_SUMMON_CELESTIAL           = 379;
int SPELLABILITY_BATTLE_MASTERY             = 380;
int SPELLABILITY_DIVINE_STRENGTH            = 381;
int SPELLABILITY_DIVINE_PROTECTION          = 382;
int SPELLABILITY_NEGATIVE_PLANE_AVATAR      = 383;
int SPELLABILITY_DIVINE_TRICKERY            = 384;
int SPELLABILITY_ROGUES_CUNNING             = 385;
int SPELLABILITY_ACTIVATE_ITEM              = 386;

// AFW-OEI 06/07/2006
int SPELLABILITY_WILD_SHAPE_BROWN_BEAR      = 401;
int SPELLABILITY_WILD_SHAPE_PANTHER     = 402;
int SPELLABILITY_WILD_SHAPE_WOLF        = 403;
int SPELLABILITY_WILD_SHAPE_BOAR        = 404;
int SPELLABILITY_WILD_SHAPE_BADGER      = 405;

int SPELLABILITY_DRAGON_FEAR                = 412;

int SPELL_DIVINE_FAVOR                      = 414;
int SPELL_TRUE_STRIKE                       = 415;
int SPELL_FLARE                             = 416;
int SPELL_SHIELD                            = 417;
int SPELL_ENTROPIC_SHIELD                   = 418;
int SPELL_CONTINUAL_FLAME                   = 419;
int SPELL_ONE_WITH_THE_LAND                 = 420;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_CAMOFLAGE                         = 421;
int SPELL_BLOOD_FRENZY                      = 422;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_BOMBARDMENT                       = 423;
int SPELL_ACID_SPLASH                       = 424;
int SPELL_QUILLFIRE                         = 425;
int SPELL_EARTHQUAKE                        = 426;
int SPELL_SUNBURST                          = 427;
int SPELL_ACTIVATE_ITEM_SELF2               = 428;
int SPELL_AURAOFGLORY                       = 429;
int SPELL_BANISHMENT                        = 430;
int SPELL_INFLICT_MINOR_WOUNDS              = 431;
int SPELL_INFLICT_LIGHT_WOUNDS              = 432;
int SPELL_INFLICT_MODERATE_WOUNDS           = 433;
int SPELL_INFLICT_SERIOUS_WOUNDS            = 434;
int SPELL_INFLICT_CRITICAL_WOUNDS           = 435;
int SPELL_BALAGARNSIRONHORN                 = 436;
int SPELL_DROWN                             = 437;
int SPELL_ELECTRIC_JOLT                     = 439;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_FIREBRAND                         = 440;
int SPELL_WOUNDING_WHISPERS                 = 441;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_AMPLIFY                           = 442;
int SPELL_ETHEREALNESS                      = 443;
int SPELL_UNDEATHS_ETERNAL_FOE              = 444;
int SPELL_DIRGE                             = 445;
int SPELL_INFERNO                           = 446;
int SPELL_ISAACS_LESSER_MISSILE_STORM       = 447;
int SPELL_ISAACS_GREATER_MISSILE_STORM      = 448;
int SPELL_BANE                              = 449;
int SPELL_SHIELD_OF_FAITH                   = 450;
int SPELL_PLANAR_ALLY                       = 451;
int SPELL_MAGIC_FANG                        = 452;
int SPELL_GREATER_MAGIC_FANG                = 453;
int SPELL_SPIKE_GROWTH                      = 454;
int SPELL_MASS_CAMOFLAGE                    = 455;
int SPELL_EXPEDITIOUS_RETREAT               = 456;
int SPELL_TASHAS_HIDEOUS_LAUGHTER           = 457;
int SPELL_DISPLACEMENT                      = 458;
int SPELL_BIGBYS_INTERPOSING_HAND           = 459;
int SPELL_BIGBYS_FORCEFUL_HAND              = 460;
int SPELL_BIGBYS_GRASPING_HAND              = 461;
int SPELL_BIGBYS_CLENCHED_FIST              = 462;
int SPELL_BIGBYS_CRUSHING_HAND              = 463;
int SPELL_GRENADE_FIRE                      = 464;
int SPELL_GRENADE_TANGLE                    = 465;
int SPELL_GRENADE_HOLY                      = 466;
int SPELL_GRENADE_CHOKING                   = 467;
int SPELL_GRENADE_THUNDERSTONE              = 468;
int SPELL_GRENADE_ACID                      = 469;
int SPELL_GRENADE_CHICKEN                   = 470;
int SPELL_GRENADE_CALTROPS                  = 471;
int SPELL_ACTIVATE_ITEM_PORTAL              = 472;
int SPELL_DIVINE_MIGHT                      = 473;
int SPELL_DIVINE_SHIELD                     = 474;
int SPELL_SHADOW_DAZE                       = 475;
int SPELL_SUMMON_SHADOW                     = 476;
int SPELL_SHADOW_EVADE                      = 477;
int SPELL_TYMORAS_SMILE                     = 478;
int SPELL_CRAFT_HARPER_ITEM                 = 479;
int SPELL_FLESH_TO_STONE                    = 485;
int SPELL_STONE_TO_FLESH                    = 486;
int SPELL_TRAP_ARROW                        = 487;
int SPELL_TRAP_BOLT                     = 488;
int SPELL_TRAP_DART                     = 493;
int SPELL_TRAP_SHURIKEN                     = 494;

int SPELLABILITY_BREATH_PETRIFY         = 495;
int SPELLABILITY_TOUCH_PETRIFY          = 496;
int SPELLABILITY_GAZE_PETRIFY           = 497;
int SPELLABILITY_MANTICORE_SPIKES       = 498;


int SPELL_ROD_OF_WONDER                 = 499;
int SPELL_DECK_OF_MANY_THINGS           = 500;
int SPELL_ELEMENTAL_SUMMONING_ITEM      = 502;
int SPELL_DECK_AVATAR                   = 503;
int SPELL_DECK_GEMSPRAY                 = 504;
int SPELL_DECK_BUTTERFLYSPRAY           = 505;

int SPELL_HEALINGKIT                    = 506;
int SPELL_POWERSTONE                    = 507;
int SPELL_SPELLSTAFF                    = 508;
int SPELL_CHARGER                       = 500;
int SPELL_DECHARGER                     = 510;

int SPELL_KOBOLD_JUMP                   = 511;
int SPELL_CRUMBLE                       = 512;
int SPELL_INFESTATION_OF_MAGGOTS        = 513;
int SPELL_HEALING_STING                 = 514;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_GREAT_THUNDERCLAP             = 515;
int SPELL_BALL_LIGHTNING                = 516;  // JLR - OEI 07/19/05 -- REMOVED
int SPELL_BATTLETIDE                    = 517;
int SPELL_COMBUST                       = 518;
int SPELL_DEATH_ARMOR                   = 519;
int SPELL_GEDLEES_ELECTRIC_LOOP         = 520;
int SPELL_HORIZIKAULS_BOOM              = 521;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_IRONGUTS                      = 522;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_MESTILS_ACID_BREATH           = 523;
int SPELL_MESTILS_ACID_SHEATH           = 524;
int SPELL_MONSTROUS_REGENERATION        = 525;  // JLR - OEI 08/09/05 -- REMOVED
int SPELL_SCINTILLATING_SPHERE          = 526;
int SPELL_STONE_BONES                   = 527;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_UNDEATH_TO_DEATH              = 528;
int SPELL_VINE_MINE                     = 529;
int SPELL_VINE_MINE_ENTANGLE            = 530;
int SPELL_VINE_MINE_HAMPER_MOVEMENT     = 531;
int SPELL_VINE_MINE_CAMOUFLAGE          = 532;
int SPELL_BLACK_BLADE_OF_DISASTER       = 533;  // JLR - OEI 08/09/05 -- REMOVED
int SPELL_SHELGARNS_PERSISTENT_BLADE    = 534;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_BLADE_THIRST                  = 535;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_DEAFENING_CLANG               = 356;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_CLOUD_OF_BEWILDERMENT         = 569;


int SPELL_KEEN_EDGE                     = 539;
int SPELL_BLACKSTAFF                    = 541;
int SPELL_FLAME_WEAPON                  = 542;
int SPELL_ICE_DAGGER                    = 543;  // JLR - OEI 07/11/05 -- REMOVED
int SPELL_MAGIC_WEAPON                  = 544;
int SPELL_GREATER_MAGIC_WEAPON          = 545;


int SPELL_STONEHOLD                     = 547;
int SPELL_DARKFIRE                      = 548;  // JLR - OEI 07/19/05 -- REMOVED
int SPELL_GLYPH_OF_WARDING              = 549;

int SPELLABILITY_MINDBLAST              = 551;
int SPELLABILITY_CHARMMONSTER           = 552;

int SPELL_IOUN_STONE_DUSTY_ROSE         = 554;
int SPELL_IOUN_STONE_PALE_BLUE          = 555;
int SPELL_IOUN_STONE_SCARLET_BLUE       = 556;
int SPELL_IOUN_STONE_BLUE               = 557;
int SPELL_IOUN_STONE_DEEP_RED           = 558;
int SPELL_IOUN_STONE_PINK               = 559;
int SPELL_IOUN_STONE_PINK_GREEN         = 560;

int SPELLABILITY_WHIRLWIND              = 561;

int SPELLABILITY_AA_IMBUE_ARROW            = 600;
int SPELLABILITY_AA_SEEKER_ARROW_1         = 601;
int SPELLABILITY_AA_SEEKER_ARROW_2         = 602;
int SPELLABILITY_AA_HAIL_OF_ARROWS         = 603;
int SPELLABILITY_AA_ARROW_OF_DEATH         = 604;

int SPELLABILITY_AS_GHOSTLY_VISAGE         = 605;
int SPELLABILITY_AS_DARKNESS               = 606;
int SPELLABILITY_AS_INVISIBILITY           = 607;
int SPELLABILITY_AS_GREATER_INVISIBLITY    = 608;   // JLR - OEI 07/11/05 -- Name Changed

int SPELLABILITY_BG_CREATEDEAD             = 609;
int SPELLABILITY_BG_FIENDISH_SERVANT       = 610;
int SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS = 611;
int SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS = 612;
int SPELLABILITY_BG_CONTAGION              = 613;
int SPELLABILITY_BG_BULLS_STRENGTH         = 614;

int SPELL_FLYING_DEBRIS                    = 620;

int SPELLABILITY_DC_DIVINE_WRATH           = 622;

int SPELLABILITY_PM_ANIMATE_DEAD           = 623;
int SPELLABILITY_PM_SUMMON_UNDEAD          = 624;
int SPELLABILITY_PM_UNDEAD_GRAFT_1         = 625;
int SPELLABILITY_PM_UNDEAD_GRAFT_2         = 626;
int SPELLABILITY_PM_SUMMON_GREATER_UNDEAD  = 627;
int SPELLABILITY_PM_DEATHLESS_MASTER_TOUCH = 628;

int SPELL_EPIC_HELLBALL                    = 636;
int SPELL_EPIC_MUMMY_DUST                  = 637;
int SPELL_EPIC_DRAGON_KNIGHT               = 638;
int SPELL_EPIC_MAGE_ARMOR                  = 639;
int SPELL_EPIC_RUIN                        = 640;

int SPELLABILITY_DW_DEFENSIVE_STANCE       = 641;

int SPELLABILITY_EPIC_MIGHTY_RAGE          = 642;
int SPELLABILITY_EPIC_CURSE_SONG           = 644;
int SPELLABILITY_EPIC_IMPROVED_WHIRLWIND   = 645;


int SPELLABILITY_EPIC_SHAPE_DRAGONKIN      = 646;
int SPELLABILITY_EPIC_SHAPE_DRAGON         = 647;

int SPELL_CRAFT_DYE_CLOTHCOLOR_1           = 648;
int SPELL_CRAFT_DYE_CLOTHCOLOR_2           = 649;
int SPELL_CRAFT_DYE_LEATHERCOLOR_1         = 650;
int SPELL_CRAFT_DYE_LEATHERCOLOR_2         = 651;
int SPELL_CRAFT_DYE_METALCOLOR_1           = 652;
int SPELL_CRAFT_DYE_METALCOLOR_2           = 653;

int SPELL_CRAFT_ADD_ITEM_PROPERTY          = 654;
int SPELL_CRAFT_POISON_WEAPON_OR_AMMO      = 655;

int SPELL_CRAFT_CRAFT_WEAPON_SKILL         = 656;
int SPELL_CRAFT_CRAFT_ARMOR_SKILL          = 657;
int SPELLABILITY_DRAGON_BREATH_NEGATIVE    = 658;

// NWN2 3.5 (Warlock Invocations)
int SPELL_I_BEGUILING_INFLUENCE            = 807;
int SPELL_I_BREATH_OF_NIGHT                = 808;
int SPELL_I_DARK_ONES_OWN_LUCK             = 809;
int SPELL_I_DARKNESS                       = 810;
int SPELL_I_DEVILS_SIGHT                   = 811;
int SPELL_I_DRAINING_BLAST                 = 812;
int SPELL_I_ELDRITCH_SPEAR                 = 813;
int SPELL_I_ENTROPIC_WARDING               = 814;
int SPELL_I_FRIGHTFUL_BLAST                = 815;
int SPELL_I_HIDEOUS_BLOW                   = 816;
int SPELL_I_LEAPS_AND_BOUNDS               = 817;
int SPELL_I_SEE_THE_UNSEEN                 = 818;
int SPELL_I_BESHADOWED_BLAST               = 819;
int SPELL_I_BRIMSTONE_BLAST                = 820;
int SPELL_I_CHARM                          = 821;
int SPELL_I_CURSE_OF_DESPAIR               = 822;
int SPELL_I_THE_DEAD_WALK                  = 823;
int SPELL_I_ELDRITCH_CHAIN                 = 824;
int SPELL_I_FLEE_THE_SCENE                 = 825;
int SPELL_I_HELLRIME_BLAST                 = 826;
int SPELL_I_VOIDSENSE                      = 827;
int SPELL_I_VORACIOUS_DISPELLING           = 828;
int SPELL_I_WALK_UNSEEN                    = 829;
int SPELL_I_BEWITCHING_BLAST               = 830;
int SPELL_I_CHILLING_TENTACLES             = 831;
int SPELL_I_DEVOUR_MAGIC                   = 832;
int SPELL_I_ELDRITCH_CONE                  = 833;
int SPELL_I_NOXIOUS_BLAST                  = 834;
int SPELL_I_TENACIOUS_PLAGUE               = 835;
int SPELL_I_VITRIOLIC_BLAST                = 836;
int SPELL_I_WALL_OF_PERILOUS_FLAME         = 837;
int SPELL_I_DARK_FORESIGHT                 = 838;
int SPELL_I_ELDRITCH_DOOM                  = 839;
int SPELL_I_PATH_OF_SHADOW                 = 840;
int SPELL_I_RETRIBUTIVE_INVISIBILITY       = 841;
int SPELL_I_UTTERDARK_BLAST                = 842;
int SPELL_I_WORD_OF_CHANGING               = 843;
int SPELLABILITY_I_ELDRITCH_BLAST          = 844;

// NWN2 3.5 (others)
int SPELL_DETECT_UNDEAD                    = 845;
int SPELL_ENLARGE_PERSON                   = 846;
int SPELL_SHOCKING_GRASP                   = 847;
int SPELL_LOW_LIGHT_VISION                 = 848;
int SPELL_BLINDSIGHT                       = 849;
int SPELL_FALSE_LIFE                       = 850;
int SPELL_FIREBURST                        = 851;
int SPELL_MIRROR_IMAGE                     = 852;
int SPELL_PROTECTION_FROM_ARROWS           = 853;
int SPELL_SCARE                            = 854;
int SPELL_DEEP_SLUMBER                     = 855;
int SPELL_ENHANCE_FAMILIAR                 = 856;
int SPELL_HEROISM                          = 857;
int SPELL_IMPROVED_MAGE_ARMOR              = 858;
int SPELL_RAGE                             = 859;
int SPELL_SPIDERSKIN                       = 860;
int SPELL_WEAPON_OF_IMPACT                 = 861;
int SPELL_ASSAY_RESISTANCE                 = 862;
int SPELL_CRUSHING_DESPAIR                 = 863;
int SPELL_JOYFUL_NOISE                     = 864;
int SPELL_DEATHWATCH                       = 865;
int SPELL_DEATH_KNELL                      = 866;
int SPELL_SHIELD_OTHER                     = 867;
int SPELL_SPELL_IMMUNITY                   = 868;

int SPELL_GREATER_FIREBURST                = 869;
int SPELL_PERMANENCY                       = 870;
int SPELL_SHROUD_OF_FLAME                  = 871;
int SPELL_TELEPORT                         = 872;
int SPELL_VITRIOLIC_SPHERE                 = 873;
int SPELL_CONTINGENCY                      = 874;
int SPELL_DISINTEGRATE                     = 875;
int SPELL_GREATER_HEROISM                  = 876;
int SPELL_REPULSION                        = 877;
int SPELL_STONE_BODY                       = 878;
int SPELL_ENERGY_IMMUNITY                  = 879;
int SPELL_LIMITED_WISH                     = 880;
int SPELL_MASS_HOLD_PERSON                 = 881;
int SPELL_MASS_INVISIBILITY                = 882;
int SPELL_SPELL_TURNING                    = 883;
int SPELL_GREATER_TELEPORT                 = 884;
int SPELL_IRON_BODY                        = 885;
int SPELL_POLAR_RAY                        = 886;
int SPELL_MASS_HOLD_MONSTER                = 887;
int SPELL_STALKING_SPELL                   = 888;
int SPELL_WISH                             = 889;
int SPELL_RIGHTEOUS_MIGHT                  = 890;
int SPELL_MASS_CURE_MODERATE_WOUNDS        = 891;
int SPELL_MASS_INFLICT_MODERATE_WOUNDS     = 892;
int SPELL_FORTUNATE_FATE                   = 893;
int SPELL_MASS_CURE_SERIOUS_WOUNDS         = 894;
int SPELL_MASS_INFLICT_SERIOUS_WOUNDS      = 895;
int SPELL_GREATER_SPELL_IMMUNITY           = 896;
int SPELL_MASS_CURE_CRITICAL_WOUNDS        = 897;
int SPELL_MASS_INFLICT_CRITICAL_WOUNDS     = 898;
int SPELL_MIRACLE                          = 899;
int SPELL_SONG_OF_DISCORD                  = 900;
int SPELLABILITY_FIENDISH_RESILIENCE       = 901;
int SPELLABILITY_FRENZY                    = 902;
int SPELLABILITY_INSPIRE_FRENZY            = 903;
int SPELLABILITY_ONHITFLAMEDAMAGE          = 904;
int SPELLABILITY_SONG_INSPIRE_COURAGE      = 905;
int SPELLABILITY_SONG_INSPIRE_COMPETENCE   = 906;
int SPELLABILITY_SONG_INSPIRE_DEFENSE      = 907;
int SPELLABILITY_SONG_INSPIRE_REGENERATION = 908;
int SPELLABILITY_SONG_INSPIRE_TOUGHNESS    = 909;
int SPELLABILITY_SONG_INSPIRE_SLOWING      = 910;
int SPELLABILITY_SONG_INSPIRE_JARRING      = 911;
int SPELLABILITY_SONG_COUNTERSONG          = 912;
int SPELLABILITY_SONG_FASCINATE            = 913;
int SPELLABILITY_SONG_HAVEN_SONG           = 914;
int SPELLABILITY_SONG_CLOUD_MIND           = 915;
int SPELLABILITY_SONG_IRONSKIN_CHANT       = 916;
int SPELLABILITY_SONG_OF_FREEDOM           = 917;
int SPELLABILITY_SONG_INSPIRE_HEROICS      = 918;
int SPELLABILITY_SONG_INSPIRE_LEGION       = 919;
int SPELLABILITY_SONG_LEAVETAKINGS         = 920;
int SPELLABILITY_SONG_THE_SPIRIT_OF_THE_WOOD = 921;
int SPELLABILITY_SONG_THE_FALL_OF_ZEEAIRE  = 922;
int SPELLABILITY_SONG_THE_BATTLE_OF_HIGHCLIFF = 923;
int SPELLABILITY_SONG_THE_SIEGE_OF_CROSSROAD_KEEP = 924;
int SPELLABILITY_SONG_A_TALE_OF_HEROES     = 925;
int SPELLABILITY_SONG_THE_TINKERS_SONG     = 926;
int SPELLABILITY_SONG_DIRGE_OF_ANCIENT_ILLEFARN = 927;
int SPELLABILITY_SONG_OF_AGES              = 928;
int SPELL_TRUE_NAME                        = 932;
int SPELLABILITY_IMPROVED_REACTION         = 933;
int SPELLABILITY_CLEANSING_NOVA            = 934;
int SPELLABILITY_SHINING_SHIELD            = 935;
int SPELLABILITY_SOOTHING_LIGHT            = 936;
int SPELLABILITY_AURORA_CHAIN              = 937;
int SPELLABILITY_KOS_DOT                   = 938;
int SPELLABILITY_KOS_PROTECTION            = 939;
int SPELLABILITY_KOS_NUKE                  = 940;
int SPELLABILITY_DARKNESS                  = 941;
int SPELLABILITY_LIGHT                     = 942;
int SPELLABILITY_ENTROPIC_SHIELD       = 945;   // AFW-OEI 08/07/2007
int SPELLABILITY_WEB_OF_PURITY             = 948;
int SPELLABILITY_PROTECTIVE_AURA       = 957;
int SPELLABILITY_FURIOUS_ASSAULT       = 958;
int SPELLABILITY_WAR_GLORY         = 959;
int SPELLABILITY_INFLAME           = 960;
int SPELLABILITY_WARPRIEST_FEAR_AURA       = 962;
int SPELLABILITY_WARPRIEST_HASTE       = 964;   // AFW-OEI 04/23/2007
int SPELLABILITY_IMPLACABLE_FOE        = 966;
int SPELL_LEAST_SPELL_MANTLE           = 967;
int SPELLABLILITY_AURA_OF_DESPAIR      = 968;
int SPELL_SHADES_TARGET_CASTER              = 969;
int SPELL_CATAPULT                          = 970;  // This is special-use for the wall battle, created by CGaw
int SPELL_SHADES_TARGET_CREATURE            = 971;
int SPELL_SHADES_TARGET_GROUND              = 972;
int SPELL_METEOR_SWARM_TARGET_SELF          = 973;
int SPELL_METEOR_SWARM_TARGET_LOCATION          = 974;
int SPELL_METEOR_SWARM_TARGET_CREATURE          = 975;
int SPELL_ENERGY_IMMUNITY_ACID              = 976;
int SPELL_ENERGY_IMMUNITY_COLD              = 977;
int SPELL_ENERGY_IMMUNITY_ELECTRICAL        = 978;
int SPELL_ENERGY_IMMUNITY_FIRE              = 979;
int SPELL_ENERGY_IMMUNITY_SONIC             = 980;
int SPELLABILITY_HEZROU_STENCH              = 981;
int SPELLABILITY_GHAST_STENCH               = 982;
int SPELLPOTION_LORE                        =983;
int SPELL_INFINITE_RANGE_FIREBALL       = 984;  // Special-use spell for wall battle. CGaw - 7/31/06
int SPELLABILITY_PILFER_MAGIC               = 985;
int SPELL_BLADE_BARRIER_WALL                = 986;
int SPELL_BLADE_BARRIER_SELF                = 987;
int SPELLABILITY_DRAGON_TAIL_SLAP           = 988;
int SPELL_TRUE_NAME_TWO                     = 989;
int SPELL_TRUE_NAME_THREE                   = 990;
//Don't use this one                        =991;
int SPELL_BLESSED_OF_WAUKEEN                = 992;
int SPELL_ARROW_NOFOG                       = 993; // Special-use spell for wall-battle.
int SPELL_ARROW_FIRE_NOFOG                  = 994; // Special-use spell for wall-battle.
int SPELL_SILVER_SWORD_ATTACK               = 995;
int SPELL_SHARD_SHIELD                      = 996;
int SPELL_SHARD_ATTACK                      = 997;
int SPELL_SILVER_SWORD_STOP_ABILITY         = 998;
int SPELL_SILVER_SWORD_RECHARGE             = 999;
int SPELL_FOUNDATION_OF_STONE               = 1000;
int SPELL_BODY_OF_THE_SUN                   = 1001;
int SPELL_JAGGED_TOOTH                      = 1002;
int SPELL_MOON_BOLT                         = 1003;
int SPELL_REJUVENATION_COCOON               = 1004;
int SPELL_TORTOISE_SHELL                    = 1005;
int SPELL_SWAMP_LUNG                        = 1006;
int SPELL_STORM_AVATAR                      = 1007;
int SPELL_NATURE_AVATAR                     = 1008;
int SPELL_POWORD_WEAKEN                     = 1009;
int SPELL_POWORD_MALADROIT                  = 1010;
int SPELL_POWORD_BLIND                      = 1011;
int SPELL_POWORD_PETRIFY                    = 1012;
int SPELL_GREATER_RESISTANCE                = 1013;
int SPELL_SUPERIOR_RESISTANCE               = 1014;
int SPELL_CALL_LIGHTNING_STORM              = 1015;
int SPELL_CACOPHONIC_BURST                  = 1016;
int SPELL_MASS_CONTAGION                    = 1017;
int SPELL_MASS_DEATH_WARD                   = 1018;
int SPELL_MASS_DROWN                        = 1019;
int SPELL_VIGOR                             = 1020;
int SPELL_LESSER_VIGOR                      = 1021;
int SPELL_MASS_LESSER_VIGOR                 = 1022;
int SPELL_VIGOROUS_CYCLE                    = 1023;
int SPELL_MASS_BEAR_ENDURANCE               = 1024;
int SPELL_MASS_BULL_STRENGTH                = 1025;
int SPELL_MASS_OWL_WISDOM                   = 1026;
int SPELL_MASS_CAT_GRACE                    = 1027;
int SPELL_MASS_EAGLE_SPLENDOR               = 1028;
int SPELL_MASS_FOX_CUNNING                  = 1029;
int SPELL_HEAL_ANIMAL_COMPANION             = 1030;
int SPELL_HYPOTHERMIA                       = 1031;
int SPELL_AVASCULATE                        = 1032;
int SPELL_WALL_DISPEL_MAGIC                 = 1033;
int SPELL_GREATER_WALL_DISPEL_MAGIC         = 1034;
int SPELL_CURSE_OF_BLADES                   = 1035;
int SPELL_GREATER_CURSE_OF_BLADES           = 1036;
int SPELL_SHOUT                             = 1037;
int SPELL_GREATER_SHOUT                     = 1038;
int SPELL_HISS_OF_SLEEP                     = 1039;
int SPELL_VISAGE_OF_THE_DEITY               = 1040;
int SPELL_GREATER_VISAGE_OF_THE_DEITY       = 1041;
int SPELL_CREEPING_COLD                     = 1042;
int SPELL_GREATER_CREEPING_COLD             = 1043;
int SPELL_TOUCH_OF_FATIGUE                  = 1044;
int SPELL_GLACIAL_WRATH                     = 1045;
int SPELL_POWER_WORD_DISABLE                = 1046;
int SPELLABILITY_SUMMON_GALE                = 1047;
int SPELLABILITY_MERGE_WITH_STONE           = 1048;
int SPELLABILITY_REACH_TO_THE_BLAZE         = 1049;
int SPELLABILITY_SHROUDING_FOG              = 1050;
int SPELLABILITY_BLAZING_AURA               = 1066; // AFW-OEI 02/19/2007
int SPELLABILITY_LAST_STAND             = 1067; // AFW-OEI 02/22/2007

int SPELL_ENTROPIC_HUSK                 = 1077; // AFW-OEI 04/16/2007

// AFW-OEI 02/28/2007: Ioun Stones
int SPELLABILITY_IOUN_STONE_STR             = 1082;
int SPELLABILITY_IOUN_STONE_DEX             = 1083;
int SPELLABILITY_IOUN_STONE_CON             = 1084;
int SPELLABILITY_IOUN_STONE_INT             = 1085;
int SPELLABILITY_IOUN_STONE_WIS             = 1086;
int SPELLABILITY_IOUN_STONE_CHA             = 1087;

// AFW-OEI 03/01/2007: Magical Beast Wild Shape
int SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE           = 1088;
int SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR    = 1089;
int SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_PHASE_SPIDER      = 1090;
int SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF       = 1091;

// AFW-OEI 03/15/2007: Spirit Shaman
int SPELLABILITY_BLESSING_OF_THE_SPIRITS            = 1096;
int SPELLABILITY_WARDING_OF_THE_SPIRITS             = 1101;

// AFW-OEI 03/22/2007: Stormlord
int SPELLABILITY_STORMLORD_SHOCK_WEAPON             = 1108;
int SPELLABILITY_STORMLORD_SONIC_WEAPON             = 1109;
int SPELLABILITY_STORMLORD_SHOCKING_BURST_WEAPON        = 1110;

//Spirit Eater spell abilities
int SPELLABILITY_DEVOUR_SPIRIT          =1068;
int SPELLABILITY_SPIRIT_GORGE               =1069;
int SPELLABILITY_RAVENOUS_INCARNATION       =1070;
int SPELLABILITY_BESTOW_LIFE_FORCE      =1071;
int SPELLABILITY_SUPPRESS                   =1072;
int SPELLABILITY_SATIATE                    =1073;
int SPELLABILITY_DEVOUR_SOUL                =1092;
int SPELLABILITY_ETERNAL_REST               =1093;
int SPELLABILITY_MOLD_SPIRIT                =1111;
int SPELLABILITY_MALLEATE_SPIRIT            =1112;
int SPELLABILITY_SPIRITUAL_EVISCERATION     =1125;
int SPELLABILITY_PROVOKE_SPIRITS            =1138;
int SPELLABILITY_AKACHI_DEVOUR              =1139;

// AFW-OEI 04/18/2007: Influence feats
int SPELLABILITY_INFLUENCE_OKKU_LOYAL           = 1113;
int SPELLABILITY_INFLUENCE_OKKU_DEVOTED         = 1114;
int SPELLABILITY_INFLUENCE_OKKU_DEVOTED_PLAYER      = 1115;
int SPELLABILITY_INFLUENCE_DOVE_DEVOTED         = 1116;
int SPELLABILITY_INFLUENCE_DOVE_DEVOTED_PLAYER      = 1117;
int SPELLABILITY_INFLUENCE_GANN_ROMANCE         = 1118;
int SPELLABILITY_INFLUENCE_GANN_ROMANCE_PLAYER      = 1119;
int SPELLABILITY_INFLUENCE_ONEOFMANY_LOYAL_PLAYER   = 1120;
int SPELLABILITY_INFLUENCE_ONEOFMANY_DEVOTED_PLAYER = 1121;

int SPELLABILITY_FAVORED_SOUL_HASTE         = 1122; // AFW-OEI 04/23/2007

// AFW-OEI 05/04/2007: Plant Wild Shape
int SPELLABILITY_PLANT_WILD_SHAPE           = 1126;
int SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND   = 1127;
int SPELLABILITY_PLANT_WILD_SHAPE_TREANT        = 1128;

int SPELLABILITY_ABYSSAL_BLAST      = 1134;

// AFW-OEI 05/22/2007: Half-Celestial spell-like abilities
int SPELLABILITY_WORD_OF_FAITH              = 1135;
int SPELLABILITY_MASS_CHARM_MONSTER             = 1136;
int SPELLABILITY_SUMMON_PLANETAR                = 1137;

int SPELL_ARC_OF_LIGHTNING                  = 1162;
int SPELL_BLADES_OF_FIRE                    = 1163;
int SPELL_BLADEWEAVE                        = 1164;
int SPELL_BLOOD_TO_WATER                    = 1165;
int SPELL_BODAKS_GLARE                      = 1166;
int SPELL_DEHYDRATE                         = 1167;
int SPELL_ANIMALISTIC_POWER                 = 1168;
int SPELL_LIVING_UNDEATH                    = 1170;
int SPELL_NIGHTSHIELD                       = 1171;
int SPELL_CONVICTION                        = 1172;
int SPELL_CASTIGATION                       = 1173;
int SPELL_SYMBOL_OF_DEATH                   = 1175;
int SPELL_SYMBOL_OF_FEAR                    = 1176;
int SPELL_SYMBOL_OF_PAIN                    = 1177;
int SPELL_SYMBOL_OF_PERSUASION              = 1178;
int SPELL_SYMBOL_OF_SLEEP                   = 1179;
int SPELL_SYMBOL_OF_STUNNING                = 1180;
int SPELL_SYMBOL_OF_WEAKNESS                = 1181;

// JWR-OEI 05/28/2008
int SPELL_DIVINE_VENGEANCE                  = 1182;
int SPELLABILITY_KELEMVORS_GRACE            = 1183;
int SPELLABILITY_ETHEREAL_PURGE             = 1184;
int SPELLABILITY_HELLFIRE_SHIELD            = 1187;
int SPELLABILITY_HELLFIRE_BLAST             = 1188;
int SPELL_SHAMAN_RES                        = 1189;
int SPELL_SUMMON_BAATEZU                    = 1190;
int SPELLABILITY_ANIMAL_TRANCE              = 1191;
int SPELL_GRENADE_HEAL                      = 1192;
int SPELL_GRENADE_BUFF_STR                  = 1193;
int SPELL_GRENADE_BUFF_DEX                  = 1194;
int SPELL_GRENADE_BUFF_CON                  = 1195;
int SPELLABILITY_DARKNESS_RACIAL            = 1196;
int SPELL_LESSER_ORB_OF_COLD                = 1197;
int SPELL_LESSER_ORB_OF_ELECTRICITY         = 1198;
int SPELL_LESSER_ORB_OF_FIRE                = 1199;
int SPELL_REDUCE_PERSON                     = 1200;
int SPELL_SNAKES_SWIFTNESS                  = 1201;
int SPELL_STABALIZE                         = 1202;
int SPELL_LESSER_ORB_OF_ACID                = 1203;
int SPELL_LESSER_ORB_OF_SOUND               = 1204;
int SPELL_ORB_OF_ACID                       = 1205;
int SPELL_ORB_OF_COLD                       = 1206;
int SPELL_ORB_OF_ELECTRICITY                = 1207;
int SPELL_ORB_OF_FIRE                       = 1208;
int SPELL_ORB_OF_SOUND                      = 1209;
int SPELL_REDUCE_ANIMAL                     = 1210;
int SPELL_REDUCE_PERSON_GREATER             = 1211;
int SPELL_REDUCE_PERSON_MASS                = 1212;
int SPELL_SNAKES_SWIFTNESS_MASS             = 1213;






// these constants must match those in poison.2da
int POISON_NIGHTSHADE                    = 0;
int POISON_SMALL_CENTIPEDE_POISON        = 1;
int POISON_BLADE_BANE                    = 2;
int POISON_GREENBLOOD_OIL                = 3;
int POISON_BLOODROOT                     = 4;
int POISON_PURPLE_WORM_POISON            = 5;
int POISON_LARGE_SCORPION_VENOM          = 6;
int POISON_WYVERN_POISON                 = 7;
int POISON_BLUE_WHINNIS                  = 8;
int POISON_GIANT_WASP_POISON             = 9;
int POISON_SHADOW_ESSENCE                = 10;
int POISON_BLACK_ADDER_VENOM             = 11;
int POISON_DEATHBLADE                    = 12;
int POISON_MALYSS_ROOT_PASTE             = 13;
int POISON_NITHARIT                      = 14;
int POISON_DRAGON_BILE                   = 15;
int POISON_SASSONE_LEAF_RESIDUE          = 16;
int POISON_TERINAV_ROOT                  = 17;
int POISON_CARRION_CRAWLER_BRAIN_JUICE   = 18;
int POISON_BLACK_LOTUS_EXTRACT           = 19;
int POISON_OIL_OF_TAGGIT                 = 20;
int POISON_ID_MOSS                       = 21;
int POISON_STRIPED_TOADSTOOL             = 22;
int POISON_ARSENIC                       = 23;
int POISON_LICH_DUST                     = 24;
int POISON_DARK_REAVER_POWDER            = 25;
int POISON_UNGOL_DUST                    = 26;
int POISON_BURNT_OTHUR_FUMES             = 27;
int POISON_CHAOS_MIST                    = 28;
int POISON_BEBILITH_VENOM                = 29;
int POISON_QUASIT_VENOM                  = 30;
int POISON_PIT_FIEND_ICHOR               = 31;
int POISON_ETTERCAP_VENOM                = 32;
int POISON_ARANEA_VENOM                  = 33;
int POISON_TINY_SPIDER_VENOM             = 34;
int POISON_SMALL_SPIDER_VENOM            = 35;
int POISON_MEDIUM_SPIDER_VENOM           = 36;
int POISON_LARGE_SPIDER_VENOM            = 37;
int POISON_HUGE_SPIDER_VENOM             = 38;
int POISON_GARGANTUAN_SPIDER_VENOM       = 39;
int POISON_COLOSSAL_SPIDER_VENOM         = 40;
int POISON_PHASE_SPIDER_VENOM            = 41;
int POISON_WRAITH_SPIDER_VENOM           = 42;
int POISON_IRON_GOLEM                    = 43;

// these constants match those in disease.2da
int DISEASE_BLINDING_SICKNESS            = 0;
int DISEASE_CACKLE_FEVER                 = 1;
int DISEASE_DEVIL_CHILLS                 = 2;
int DISEASE_DEMON_FEVER                  = 3;
int DISEASE_FILTH_FEVER                  = 4;
int DISEASE_MINDFIRE                     = 5;
int DISEASE_MUMMY_ROT                    = 6;
int DISEASE_RED_ACHE                     = 7;
int DISEASE_SHAKES                       = 8;
int DISEASE_SLIMY_DOOM                   = 9;
int DISEASE_RED_SLAAD_EGGS               = 10;
int DISEASE_GHOUL_ROT                    = 11;
int DISEASE_ZOMBIE_CREEP                 = 12;
int DISEASE_DREAD_BLISTERS               = 13;
int DISEASE_BURROW_MAGGOTS               = 14;
int DISEASE_SOLDIER_SHAKES               = 15;
int DISEASE_VERMIN_MADNESS               = 16;

// the thing after CREATURE_TYPE_ should refer to the
// actual "subtype" in the lists given above.
int CREATURE_TYPE_RACIAL_TYPE     = 0;
int CREATURE_TYPE_PLAYER_CHAR     = 1;
int CREATURE_TYPE_CLASS           = 2;
int CREATURE_TYPE_REPUTATION      = 3;
int CREATURE_TYPE_IS_ALIVE        = 4;
int CREATURE_TYPE_HAS_SPELL_EFFECT = 5;
int CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT = 6;
int CREATURE_TYPE_PERCEPTION                = 7;
int CREATURE_TYPE_SCRIPTHIDDEN    = 8;//RWT-OEI 03/04/06
//int CREATURE_TYPE_ALIGNMENT       = 2;

//RWT-OEI 03/04/06 - Scripters want to be able to search for both alive and
//dead nearest creatures sometimes. Use with the CREATURE_TYPE_IS_ALIVE category
int CREATURE_ALIVE_FALSE          = 0;
int CREATURE_ALIVE_TRUE           = 1;
int CREATURE_ALIVE_BOTH           = 2;

//RWT-OEI 03/04/06 - Parameters for the CREATURE_TYPE_SCRIPTHIDDEN category in GetNearestCreature
int CREATURE_SCRIPTHIDDEN_FALSE   = 0;
int CREATURE_SCRIPTHIDDEN_TRUE    = 1;
int CREATURE_SCRIPTHIDDEN_BOTH    = 2;

int REPUTATION_TYPE_FRIEND        = 0;
int REPUTATION_TYPE_ENEMY         = 1;
int REPUTATION_TYPE_NEUTRAL       = 2;

int PERCEPTION_SEEN_AND_HEARD           = 0;
int PERCEPTION_NOT_SEEN_AND_NOT_HEARD   = 1;
int PERCEPTION_HEARD_AND_NOT_SEEN       = 2;
int PERCEPTION_SEEN_AND_NOT_HEARD       = 3;
int PERCEPTION_NOT_HEARD                = 4;
int PERCEPTION_HEARD                    = 5;
int PERCEPTION_NOT_SEEN                 = 6;
int PERCEPTION_SEEN                     = 7;

int PLAYER_CHAR_NOT_PC            = 0;
int PLAYER_CHAR_IS_PC             = 1;
int PLAYER_CHAR_IS_CONTROLLED     = 2;

int CLASS_TYPE_BARBARIAN = 0;
int CLASS_TYPE_BARD      = 1;
int CLASS_TYPE_CLERIC    = 2;
int CLASS_TYPE_DRUID     = 3;
int CLASS_TYPE_FIGHTER   = 4;
int CLASS_TYPE_MONK      = 5;
int CLASS_TYPE_PALADIN   = 6;
int CLASS_TYPE_RANGER    = 7;
int CLASS_TYPE_ROGUE     = 8;
int CLASS_TYPE_SORCERER  = 9;
int CLASS_TYPE_WIZARD    = 10;
int CLASS_TYPE_ABERRATION = 11;
int CLASS_TYPE_ANIMAL    = 12;
int CLASS_TYPE_CONSTRUCT = 13;
int CLASS_TYPE_HUMANOID  = 14;
int CLASS_TYPE_MONSTROUS = 15;
int CLASS_TYPE_ELEMENTAL = 16;
int CLASS_TYPE_FEY       = 17;
int CLASS_TYPE_DRAGON    = 18;
int CLASS_TYPE_UNDEAD    = 19;
int CLASS_TYPE_COMMONER  = 20;
int CLASS_TYPE_BEAST     = 21;
int CLASS_TYPE_GIANT     = 22;
int CLASS_TYPE_MAGICAL_BEAST = 23;
int CLASS_TYPE_OUTSIDER  = 24;
int CLASS_TYPE_SHAPECHANGER = 25;
int CLASS_TYPE_VERMIN    = 26;
int CLASS_TYPE_SHADOWDANCER = 27;
int CLASS_TYPE_HARPER = 28;
int CLASS_TYPE_ARCANE_ARCHER = 29;
int CLASS_TYPE_ASSASSIN = 30;
int CLASS_TYPE_BLACKGUARD = 31;
int CLASS_TYPE_DIVINECHAMPION   = 32;
int CLASS_TYPE_WEAPON_MASTER           = 33;
int CLASS_TYPE_PALEMASTER       = 34;
int CLASS_TYPE_SHIFTER          = 35;
int CLASS_TYPE_DWARVENDEFENDER  = 36;
int CLASS_TYPE_DRAGONDISCIPLE   = 37;
int CLASS_TYPE_OOZE = 38;
int CLASS_TYPE_WARLOCK       = 39;
// New Prestige Classes
int CLASS_TYPE_ARCANETRICKSTER = 40;
//int CLASS_TYPE_CAVALIER    = 41;
//int CLASS_TYPE_CONTEMPLATIVE   = 42;
int CLASS_TYPE_FRENZIEDBERSERKER = 43;
//int CLASS_TYPE_MYSTICTHEURGE   = 44;
int CLASS_TYPE_SACREDFIST    = 45;
int CLASS_TYPE_SHADOWTHIEFOFAMN = 46;
int CLASS_NWNINE_WARDER     = 47;       // AFW-OEI 04/18/2006
//int CLASS_NWNINE_MAGUS    = 48;       // AFW-OEI 04/18/2006
//int CLASS_NWNINE_AGENT    = 49;       // AFW-OEI 04/18/2006
int CLASS_TYPE_DUELIST      = 50;       // AFW-OEI 04/18/2006
int CLASS_TYPE_WARPRIEST    = 51;       // AFW-OEI 05/20/2006
int CLASS_TYPE_ELDRITCH_KNIGHT  = 52;       // AFW-OEI 05/22/2006
int CLASS_TYPE_RED_WIZARD   = 53;       // AFW-OEI 03/13/2007
int CLASS_TYPE_ARCANE_SCHOLAR   = 54;       // AFW-OEI 03/13/2007
int CLASS_TYPE_SPIRIT_SHAMAN    = 55;       // AFW-OEI 03/13/2007
int CLASS_TYPE_STORMLORD    = 56;       // AFW-OEI 03/20/2007
int CLASS_TYPE_INVISIBLE_BLADE  = 57;       // AFW-OEI 04/24/2007
int CLASS_TYPE_FAVORED_SOUL = 58;       // AFW-OEI 04/24/2007
int CLASS_TYPE_SWASHBUCKLER = 59;       // JWR-OEI 05/19/2008
int CLASS_TYPE_DOOMGUIDE = 60;          // JWR-OEI 05/19/08
int CLASS_TYPE_HELLFIRE_WARLOCK = 61;       // JWR-OEI 06/13/08

int CLASS_TYPE_INVALID   = 255;

// These are for the LevelUpHenchman command.
int PACKAGE_BARBARIAN                    = 0;
int PACKAGE_BARD                         = 1;
int PACKAGE_CLERIC                       = 2;
int PACKAGE_DRUID                        = 3;
int PACKAGE_FIGHTER                      = 4;
int PACKAGE_MONK                         = 5;
int PACKAGE_PALADIN                      = 6;
int PACKAGE_RANGER                       = 7;
int PACKAGE_ROGUE                        = 8;
int PACKAGE_SORCERER                     = 9;
int PACKAGE_WIZARDGENERALIST             = 10;
int PACKAGE_DRUID_INTERLOPER             = 11;
int PACKAGE_DRUID_GRAY                   = 12;
int PACKAGE_DRUID_DEATH                  = 13;
int PACKAGE_DRUID_HAWKMASTER             = 14;
int PACKAGE_BARBARIAN_BRUTE              = 15;
int PACKAGE_BARBARIAN_SLAYER             = 16;
int PACKAGE_BARBARIAN_SAVAGE             = 17;
int PACKAGE_BARBARIAN_ORCBLOOD           = 18;
int PACKAGE_CLERIC_SHAMAN                = 19;
int PACKAGE_CLERIC_DEADWALKER            = 20;
int PACKAGE_CLERIC_ELEMENTALIST          = 21;
int PACKAGE_CLERIC_BATTLE_PRIEST         = 22;
int PACKAGE_FIGHTER_FINESSE              = 23;
int PACKAGE_FIGHTER_PIRATE               = 24;
int PACKAGE_FIGHTER_GLADIATOR            = 25;
int PACKAGE_FIGHTER_COMMANDER            = 26;
int PACKAGE_WIZARD_ABJURATION            = 27;
int PACKAGE_WIZARD_CONJURATION           = 28;
int PACKAGE_WIZARD_DIVINATION            = 29;
int PACKAGE_WIZARD_ENCHANTMENT           = 30;
int PACKAGE_WIZARD_EVOCATION             = 31;
int PACKAGE_WIZARD_ILLUSION              = 32;
int PACKAGE_WIZARD_NECROMANCY            = 33;
int PACKAGE_WIZARD_TRANSMUTATION         = 34;
int PACKAGE_SORCERER_ABJURATION          = 35;
int PACKAGE_SORCERER_CONJURATION         = 36;
int PACKAGE_SORCERER_DIVINATION          = 37;
int PACKAGE_SORCERER_ENCHANTMENT         = 38;
int PACKAGE_SORCERER_EVOCATION           = 39;
int PACKAGE_SORCERER_ILLUSION            = 40;
int PACKAGE_SORCERER_NECROMANCY          = 41;
int PACKAGE_SORCERER_TRANSMUTATION       = 42;
int PACKAGE_BARD_BLADE                   = 43;
int PACKAGE_BARD_GALLANT                 = 44;
int PACKAGE_BARD_JESTER                  = 45;
int PACKAGE_BARD_LOREMASTER              = 46;
int PACKAGE_MONK_SPIRIT                  = 47;
int PACKAGE_MONK_GIFTED                  = 48;
int PACKAGE_MONK_DEVOUT                  = 49;
int PACKAGE_MONK_PEASANT                 = 50;
int PACKAGE_PALADIN_ERRANT               = 51;
int PACKAGE_PALADIN_UNDEAD               = 52;
int PACKAGE_PALADIN_INQUISITOR           = 53;
int PACKAGE_PALADIN_CHAMPION             = 54;
int PACKAGE_RANGER_MARKSMAN              = 55;
int PACKAGE_RANGER_WARDEN                = 56;
int PACKAGE_RANGER_STALKER               = 57;
int PACKAGE_RANGER_GIANTKILLER           = 58;
int PACKAGE_ROGUE_GYPSY                  = 59;
int PACKAGE_ROGUE_BANDIT                 = 60;
int PACKAGE_ROGUE_SCOUT                  = 61;
int PACKAGE_ROGUE_SWASHBUCKLER           = 62;
int PACKAGE_SHADOWDANCER                 = 63;
int PACKAGE_HARPER                       = 64;
int PACKAGE_ARCANE_ARCHER                = 65;
int PACKAGE_ASSASSIN                     = 66;
int PACKAGE_BLACKGUARD                   = 67;
int PACKAGE_NPC_SORCERER                 = 70;
int PACKAGE_NPC_ROGUE                    = 71;
int PACKAGE_NPC_BARD                     = 72;
int PACKAGE_ABERRATION                   = 73;
int PACKAGE_ANIMAL                       = 74;
int PACKAGE_CONSTRUCT                    = 75;
int PACKAGE_HUMANOID                     = 76;
int PACKAGE_MONSTROUS                    = 77;
int PACKAGE_ELEMENTAL                    = 78;
int PACKAGE_FEY                          = 79;
int PACKAGE_DRAGON                       = 80;
int PACKAGE_UNDEAD                       = 81;
int PACKAGE_COMMONER                     = 82;
int PACKAGE_BEAST                        = 83;
int PACKAGE_GIANT                        = 84;
int PACKAGE_MAGICBEAST                   = 85;
int PACKAGE_OUTSIDER                     = 86;
int PACKAGE_SHAPECHANGER                 = 87;
int PACKAGE_VERMIN                       = 88;
int PACKAGE_DWARVEN_DEFENDER             = 89;
int PACKAGE_BARBARIAN_BLACKGUARD         = 90;
int PACKAGE_BARD_HARPER                  = 91;
int PACKAGE_CLERIC_DIVINE                = 92;
int PACKAGE_DRUID_SHIFTER                = 93;
int PACKAGE_FIGHTER_WEAPONMASTER         = 94;
int PACKAGE_MONK_ASSASSIN                = 95;
int PACKAGE_PALADIN_DIVINE               = 96;
int PACKAGE_RANGER_ARCANEARCHER          = 97;
int PACKAGE_ROGUE_SHADOWDANCER           = 98;
int PACKAGE_SORCERER_DRAGONDISCIPLE      = 99;
int PACKAGE_WIZARD_PALEMASTER            = 100;
int PACKAGE_NPC_WIZASSASSIN              = 101;
int PACKAGE_NPC_FT_WEAPONMASTER          = 102;
int PACKAGE_NPC_RG_SHADOWDANCER          = 103;
int PACKAGE_NPC_CLERIC_LINU              = 104;
int PACKAGE_NPC_BARBARIAN_DAELAN         = 105;
int PACKAGE_NPC_BARD_FIGHTER             = 106;
int PACKAGE_NPC_PALADIN_FALLING          = 107;
int PACKAGE_SHIFTER                      = 108;
int PACKAGE_DIVINE_CHAMPION              = 109;
int PACKAGE_PALE_MASTER                  = 110;
int PACKAGE_DRAGON_DISCIPLE              = 111;
int PACKAGE_WEAPONMASTER                 = 112;
int PACKAGE_WARLOCK                      = 131;

int PACKAGE_INVALID                      = 255;

// These are for GetFirstInPersistentObject() and GetNextInPersistentObject()
int PERSISTENT_ZONE_ACTIVE = 0;
int PERSISTENT_ZONE_FOLLOW = 1;

int STANDARD_FACTION_HOSTILE  = 0;
int STANDARD_FACTION_COMMONER = 1;
int STANDARD_FACTION_MERCHANT = 2;
int STANDARD_FACTION_DEFENDER = 3;

// Skill defines
//int SKILL_ANIMAL_EMPATHY   = 0;   // NWN2 3.5 Removed
int SKILL_CONCENTRATION    = 1;
int SKILL_DISABLE_TRAP     = 2;
int SKILL_DISCIPLINE       = 3;
int SKILL_HEAL             = 4;
int SKILL_HIDE             = 5;
int SKILL_LISTEN           = 6;
int SKILL_LORE             = 7;
int SKILL_MOVE_SILENTLY    = 8;
int SKILL_OPEN_LOCK        = 9;
int SKILL_PARRY            = 10;
int SKILL_PERFORM          = 11;
int SKILL_DIPLOMACY        = 12;    // NWN2 3.5 Changed from "PERSUADE"
int SKILL_SLEIGHT_OF_HAND  = 13;    // NWN2 3.5 Changed from "PICK_POCKET"
int SKILL_SEARCH           = 14;
int SKILL_SET_TRAP         = 15;
int SKILL_SPELLCRAFT       = 16;
int SKILL_SPOT             = 17;
int SKILL_TAUNT            = 18;
int SKILL_USE_MAGIC_DEVICE = 19;
int SKILL_APPRAISE         = 20;
int SKILL_TUMBLE           = 21;
int SKILL_CRAFT_TRAP       = 22;
int SKILL_BLUFF            = 23;
int SKILL_INTIMIDATE       = 24;
int SKILL_CRAFT_ARMOR      = 25;
int SKILL_CRAFT_WEAPON     = 26;
int SKILL_CRAFT_ALCHEMY    = 27;
int SKILL_RIDE             = 28;
int SKILL_SURVIVAL         = 29;

int SKILL_ALL_SKILLS       = 255;

int SUBSKILL_FLAGTRAP      = 100;
int SUBSKILL_RECOVERTRAP   = 101;
int SUBSKILL_EXAMINETRAP   = 102;

int FEAT_INVALID                        = 65535;
int FEAT_ALERTNESS                      = 0;
//int FEAT_AMBIDEXTERITY                  = 1;   // JLR - OEI 06/03/05 NWN2 3.5 -- Ambidexterity merged with Two-Weapon Fighting
int FEAT_ARMOR_PROFICIENCY_HEAVY        = 2;
int FEAT_ARMOR_PROFICIENCY_LIGHT        = 3;
int FEAT_ARMOR_PROFICIENCY_MEDIUM       = 4;
int FEAT_CALLED_SHOT                    = 5;
int FEAT_CLEAVE                         = 6;
int FEAT_COMBAT_CASTING                 = 7;
int FEAT_DEFLECT_ARROWS                 = 8;
int FEAT_DISARM                         = 9;
int FEAT_DODGE                          = 10;
int FEAT_EMPOWER_SPELL                  = 11;
int FEAT_EXTEND_SPELL                   = 12;
int FEAT_EXTRA_TURNING                  = 13;
int FEAT_GREAT_FORTITUDE                = 14;
int FEAT_IMPROVED_CRITICAL_CLUB         = 15;
int FEAT_IMPROVED_DISARM                = 16;
int FEAT_IMPROVED_KNOCKDOWN             = 17;
int FEAT_IMPROVED_PARRY                 = 18;
int FEAT_IMPROVED_POWER_ATTACK          = 19;
int FEAT_IMPROVED_TWO_WEAPON_FIGHTING   = 20;
int FEAT_IMPROVED_UNARMED_STRIKE        = 21;
int FEAT_IRON_WILL                      = 22;
int FEAT_KNOCKDOWN                      = 23;
int FEAT_LIGHTNING_REFLEXES             = 24;
int FEAT_MAXIMIZE_SPELL                 = 25;
int FEAT_MOBILITY                       = 26;
int FEAT_POINT_BLANK_SHOT               = 27;
int FEAT_POWER_ATTACK                   = 28;
int FEAT_QUICKEN_SPELL                  = 29;
int FEAT_RAPID_SHOT                     = 30;
int FEAT_SAP                            = 31;
int FEAT_SHIELD_PROFICIENCY             = 32;
int FEAT_SILENCE_SPELL                  = 33;
int FEAT_SKILL_FOCUS_ANIMAL_EMPATHY     = 34;
int FEAT_SPELL_FOCUS_ABJURATION         = 35;
int FEAT_SPELL_PENETRATION              = 36;
int FEAT_STILL_SPELL                    = 37;
int FEAT_STUNNING_FIST                  = 39;
int FEAT_TOUGHNESS                      = 40;
int FEAT_TWO_WEAPON_FIGHTING            = 41;
int FEAT_WEAPON_FINESSE                 = 42;
int FEAT_WEAPON_FOCUS_CLUB              = 43;
int FEAT_WEAPON_PROFICIENCY_EXOTIC      = 44;
int FEAT_WEAPON_PROFICIENCY_MARTIAL     = 45;
int FEAT_WEAPON_PROFICIENCY_SIMPLE      = 46;
int FEAT_WEAPON_SPECIALIZATION_CLUB     = 47;
int FEAT_WEAPON_PROFICIENCY_DRUID       = 48;
int FEAT_WEAPON_PROFICIENCY_MONK        = 49;
int FEAT_WEAPON_PROFICIENCY_ROGUE       = 50;
int FEAT_WEAPON_PROFICIENCY_WIZARD      = 51;
int FEAT_IMPROVED_CRITICAL_DAGGER       = 52;
int FEAT_IMPROVED_CRITICAL_DART         = 53;
int FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW = 54;
int FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW = 55;
int FEAT_IMPROVED_CRITICAL_LIGHT_MACE   = 56;
int FEAT_IMPROVED_CRITICAL_MORNING_STAR = 57;
int FEAT_IMPROVED_CRITICAL_STAFF        = 58;
int FEAT_IMPROVED_CRITICAL_SPEAR        = 59;
int FEAT_IMPROVED_CRITICAL_SICKLE       = 60;
int FEAT_IMPROVED_CRITICAL_SLING        = 61;
int FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE = 62;
int FEAT_IMPROVED_CRITICAL_LONGBOW      = 63;
int FEAT_IMPROVED_CRITICAL_SHORTBOW     = 64;
int FEAT_IMPROVED_CRITICAL_SHORT_SWORD  = 65;
int FEAT_IMPROVED_CRITICAL_RAPIER       = 66;
int FEAT_IMPROVED_CRITICAL_SCIMITAR     = 67;
int FEAT_IMPROVED_CRITICAL_LONG_SWORD   = 68;
int FEAT_IMPROVED_CRITICAL_GREAT_SWORD  = 69;
int FEAT_IMPROVED_CRITICAL_HAND_AXE     = 70;
int FEAT_IMPROVED_CRITICAL_THROWING_AXE = 71;
int FEAT_IMPROVED_CRITICAL_BATTLE_AXE   = 72;
int FEAT_IMPROVED_CRITICAL_GREAT_AXE    = 73;
int FEAT_IMPROVED_CRITICAL_HALBERD      = 74;
int FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER = 75;
int FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL  = 76;
int FEAT_IMPROVED_CRITICAL_WAR_HAMMER   = 77;
int FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL  = 78;
int FEAT_IMPROVED_CRITICAL_KAMA         = 79;
int FEAT_IMPROVED_CRITICAL_KUKRI        = 80;
//int FEAT_IMPROVED_CRITICAL_NUNCHAKU = 81;
int FEAT_IMPROVED_CRITICAL_SHURIKEN     = 82;
int FEAT_IMPROVED_CRITICAL_SCYTHE       = 83;
int FEAT_IMPROVED_CRITICAL_KATANA       = 84;
int FEAT_IMPROVED_CRITICAL_BASTARD_SWORD = 85;
int FEAT_IMPROVED_CRITICAL_DIRE_MACE    = 87;
int FEAT_IMPROVED_CRITICAL_DOUBLE_AXE   = 88;
int FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD = 89;
int FEAT_WEAPON_FOCUS_DAGGER            = 90;
int FEAT_WEAPON_FOCUS_DART              = 91;
int FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW    = 92;
int FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW    = 93;
int FEAT_WEAPON_FOCUS_LIGHT_MACE        = 94;
int FEAT_WEAPON_FOCUS_MORNING_STAR      = 95;
int FEAT_WEAPON_FOCUS_STAFF             = 96;
int FEAT_WEAPON_FOCUS_SPEAR             = 97;
int FEAT_WEAPON_FOCUS_SICKLE            = 98;
int FEAT_WEAPON_FOCUS_SLING             = 99;
int FEAT_WEAPON_FOCUS_UNARMED_STRIKE    = 100;
int FEAT_WEAPON_FOCUS_LONGBOW           = 101;
int FEAT_WEAPON_FOCUS_SHORTBOW          = 102;
int FEAT_WEAPON_FOCUS_SHORT_SWORD       = 103;
int FEAT_WEAPON_FOCUS_RAPIER            = 104;
int FEAT_WEAPON_FOCUS_SCIMITAR          = 105;
int FEAT_WEAPON_FOCUS_LONG_SWORD        = 106;
int FEAT_WEAPON_FOCUS_GREAT_SWORD       = 107;
int FEAT_WEAPON_FOCUS_HAND_AXE          = 108;
int FEAT_WEAPON_FOCUS_THROWING_AXE      = 109;
int FEAT_WEAPON_FOCUS_BATTLE_AXE        = 110;
int FEAT_WEAPON_FOCUS_GREAT_AXE         = 111;
int FEAT_WEAPON_FOCUS_HALBERD           = 112;
int FEAT_WEAPON_FOCUS_LIGHT_HAMMER      = 113;
int FEAT_WEAPON_FOCUS_LIGHT_FLAIL       = 114;
int FEAT_WEAPON_FOCUS_WAR_HAMMER        = 115;
int FEAT_WEAPON_FOCUS_HEAVY_FLAIL       = 116;
int FEAT_WEAPON_FOCUS_KAMA              = 117;
int FEAT_WEAPON_FOCUS_KUKRI             = 118;
//int FEAT_WEAPON_FOCUS_NUNCHAKU = 119;
int FEAT_WEAPON_FOCUS_SHURIKEN          = 120;
int FEAT_WEAPON_FOCUS_SCYTHE            = 121;
int FEAT_WEAPON_FOCUS_KATANA            = 122;
int FEAT_WEAPON_FOCUS_BASTARD_SWORD     = 123;
int FEAT_WEAPON_FOCUS_DIRE_MACE         = 125;
int FEAT_WEAPON_FOCUS_DOUBLE_AXE        = 126;
int FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD  = 127;
int FEAT_WEAPON_SPECIALIZATION_DAGGER   = 128;
int FEAT_WEAPON_SPECIALIZATION_DART     = 129;
int FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW = 130;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW = 131;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE = 132;
int FEAT_WEAPON_SPECIALIZATION_MORNING_STAR = 133;
int FEAT_WEAPON_SPECIALIZATION_STAFF    = 134;
int FEAT_WEAPON_SPECIALIZATION_SPEAR    = 135;
int FEAT_WEAPON_SPECIALIZATION_SICKLE   = 136;
int FEAT_WEAPON_SPECIALIZATION_SLING    = 137;
int FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE = 138;
int FEAT_WEAPON_SPECIALIZATION_LONGBOW  = 139;
int FEAT_WEAPON_SPECIALIZATION_SHORTBOW = 140;
int FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD = 141;
int FEAT_WEAPON_SPECIALIZATION_RAPIER   = 142;
int FEAT_WEAPON_SPECIALIZATION_SCIMITAR = 143;
int FEAT_WEAPON_SPECIALIZATION_LONG_SWORD = 144;
int FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD = 145;
int FEAT_WEAPON_SPECIALIZATION_HAND_AXE = 146;
int FEAT_WEAPON_SPECIALIZATION_THROWING_AXE = 147;
int FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE = 148;
int FEAT_WEAPON_SPECIALIZATION_GREAT_AXE = 149;
int FEAT_WEAPON_SPECIALIZATION_HALBERD  = 150;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER = 151;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL = 152;
int FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER = 153;
int FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL = 154;
int FEAT_WEAPON_SPECIALIZATION_KAMA     = 155;
int FEAT_WEAPON_SPECIALIZATION_KUKRI    = 156;
//int FEAT_WEAPON_SPECIALIZATION_NUNCHAKU = 157;
int FEAT_WEAPON_SPECIALIZATION_SHURIKEN = 158;
int FEAT_WEAPON_SPECIALIZATION_SCYTHE   = 159;
int FEAT_WEAPON_SPECIALIZATION_KATANA   = 160;
int FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD = 161;
int FEAT_WEAPON_SPECIALIZATION_DIRE_MACE = 163;
int FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE = 164;
int FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD = 165;
int FEAT_SPELL_FOCUS_CONJURATION        = 166;
int FEAT_SPELL_FOCUS_DIVINATION         = 167;
int FEAT_SPELL_FOCUS_ENCHANTMENT        = 168;
int FEAT_SPELL_FOCUS_EVOCATION          = 169;
int FEAT_SPELL_FOCUS_ILLUSION           = 170;
int FEAT_SPELL_FOCUS_NECROMANCY         = 171;
int FEAT_SPELL_FOCUS_TRANSMUTATION      = 172;
int FEAT_SKILL_FOCUS_CONCENTRATION      = 173;
int FEAT_SKILL_FOCUS_DISABLE_TRAP       = 174;
int FEAT_SKILL_FOCUS_DISCIPLINE         = 175;
int FEAT_SKILL_FOCUS_HEAL               = 177;
int FEAT_SKILL_FOCUS_HIDE               = 178;
int FEAT_SKILL_FOCUS_LISTEN             = 179;
int FEAT_SKILL_FOCUS_LORE               = 180;
int FEAT_SKILL_FOCUS_MOVE_SILENTLY      = 181;
int FEAT_SKILL_FOCUS_OPEN_LOCK          = 182;
int FEAT_SKILL_FOCUS_PARRY              = 183;
int FEAT_SKILL_FOCUS_PERFORM            = 184;
int FEAT_SKILL_FOCUS_DIPLOMACY          = 185;
int FEAT_SKILL_FOCUS_SLEIGHT_OF_HAND    = 186;
int FEAT_SKILL_FOCUS_SEARCH             = 187;
int FEAT_SKILL_FOCUS_SET_TRAP           = 188;
int FEAT_SKILL_FOCUS_SPELLCRAFT         = 189;
int FEAT_SKILL_FOCUS_SPOT               = 190;
int FEAT_SKILL_FOCUS_TAUNT              = 192;
int FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE   = 193;
int FEAT_BARBARIAN_ENDURANCE            = 194;
int FEAT_UNCANNY_DODGE                  = 195;
int FEAT_DAMAGE_REDUCTION               = 196;
int FEAT_BARDIC_KNOWLEDGE               = 197;
int FEAT_NATURE_SENSE                   = 198;
int FEAT_ANIMAL_COMPANION               = 199;
int FEAT_WOODLAND_STRIDE                = 200;
int FEAT_TRACKLESS_STEP                 = 201;
int FEAT_RESIST_NATURES_LURE            = 202;
int FEAT_VENOM_IMMUNITY                 = 203;
int FEAT_FLURRY_OF_BLOWS                = 204;
int FEAT_EVASION                        = 206;
int FEAT_MONK_ENDURANCE                 = 207;
int FEAT_STILL_MIND                     = 208;
int FEAT_PURITY_OF_BODY                 = 209;
int FEAT_WHOLENESS_OF_BODY              = 211;
int FEAT_IMPROVED_EVASION               = 212;
int FEAT_KI_STRIKE                      = 213;
int FEAT_DIAMOND_BODY                   = 214;
int FEAT_DIAMOND_SOUL                   = 215;
int FEAT_PERFECT_SELF                   = 216;
int FEAT_DIVINE_GRACE                   = 217;
int FEAT_DIVINE_HEALTH                  = 219;
int FEAT_SNEAK_ATTACK                   = 221;
int FEAT_CRIPPLING_STRIKE               = 222;
int FEAT_DEFENSIVE_ROLL                 = 223;
int FEAT_OPPORTUNIST                    = 224;
int FEAT_SKILL_MASTERY                  = 225;
int FEAT_UNCANNY_REFLEX                 = 226;
int FEAT_STONECUNNING                   = 227;
int FEAT_DARKVISION                     = 228;
int FEAT_HARDINESS_VERSUS_POISONS       = 229;
int FEAT_HARDINESS_VERSUS_SPELLS        = 230;
int FEAT_BATTLE_TRAINING_VERSUS_ORCS    = 231;
int FEAT_BATTLE_TRAINING_VERSUS_GOBLINS = 232;
int FEAT_BATTLE_TRAINING_VERSUS_GIANTS  = 233;
int FEAT_SKILL_AFFINITY_LORE            = 234;
int FEAT_IMMUNITY_TO_SLEEP              = 235;
int FEAT_HARDINESS_VERSUS_ENCHANTMENTS  = 236;
int FEAT_SKILL_AFFINITY_LISTEN          = 237;
int FEAT_SKILL_AFFINITY_SEARCH          = 238;
int FEAT_SKILL_AFFINITY_SPOT            = 239;
int FEAT_KEEN_SENSE                     = 240;
int FEAT_HARDINESS_VERSUS_ILLUSIONS     = 241;
int FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS = 242;
int FEAT_SKILL_AFFINITY_CONCENTRATION   = 243;
int FEAT_PARTIAL_SKILL_AFFINITY_LISTEN  = 244;
int FEAT_PARTIAL_SKILL_AFFINITY_SEARCH  = 245;
int FEAT_PARTIAL_SKILL_AFFINITY_SPOT    = 246;
int FEAT_SKILL_AFFINITY_MOVE_SILENTLY   = 247;
int FEAT_LUCKY                          = 248;
int FEAT_FEARLESS                       = 249;
int FEAT_GOOD_AIM                       = 250;
int FEAT_UNCANNY_DODGE_2                = 251;
int FEAT_UNCANNY_DODGE_3                = 252;
int FEAT_UNCANNY_DODGE_4                = 253;
int FEAT_UNCANNY_DODGE_5                = 254;
int FEAT_UNCANNY_DODGE_6                = 255;
int FEAT_WEAPON_PROFICIENCY_ELF         = 256;
int FEAT_BARD_SONGS                     = 257;
int FEAT_QUICK_TO_MASTER                = 258;
int FEAT_SLIPPERY_MIND                  = 259;
int FEAT_MONK_AC_BONUS                  = 260;
int FEAT_FAVORED_ENEMY_DWARF            = 261;
int FEAT_FAVORED_ENEMY_ELF              = 262;
int FEAT_FAVORED_ENEMY_GNOME            = 263;
int FEAT_FAVORED_ENEMY_HALFLING         = 264;
int FEAT_FAVORED_ENEMY_HALFELF          = 265;
int FEAT_FAVORED_ENEMY_HALFORC          = 266;
int FEAT_FAVORED_ENEMY_HUMAN            = 267;
int FEAT_FAVORED_ENEMY_ABERRATION       = 268;
int FEAT_FAVORED_ENEMY_ANIMAL           = 269;
int FEAT_FAVORED_ENEMY_BEAST            = 270;
int FEAT_FAVORED_ENEMY_CONSTRUCT        = 271;
int FEAT_FAVORED_ENEMY_DRAGON           = 272;
int FEAT_FAVORED_ENEMY_GOBLINOID        = 273;
int FEAT_FAVORED_ENEMY_MONSTROUS        = 274;
int FEAT_FAVORED_ENEMY_ORC              = 275;
int FEAT_FAVORED_ENEMY_REPTILIAN        = 276;
int FEAT_FAVORED_ENEMY_ELEMENTAL        = 277;
int FEAT_FAVORED_ENEMY_FEY              = 278;
int FEAT_FAVORED_ENEMY_GIANT            = 279;
int FEAT_FAVORED_ENEMY_MAGICAL_BEAST    = 280;
int FEAT_FAVORED_ENEMY_OUTSIDER         = 281;
int FEAT_FAVORED_ENEMY_SHAPECHANGER     = 284;
int FEAT_FAVORED_ENEMY_UNDEAD           = 285;
int FEAT_FAVORED_ENEMY_VERMIN           = 286;
int FEAT_WEAPON_PROFICIENCY_CREATURE    = 289;
int FEAT_WEAPON_SPECIALIZATION_CREATURE = 290;
int FEAT_WEAPON_FOCUS_CREATURE          = 291;
int FEAT_IMPROVED_CRITICAL_CREATURE     = 292;
int FEAT_BARBARIAN_RAGE                 = 293;
int FEAT_TURN_UNDEAD                    = 294;
int FEAT_QUIVERING_PALM                 = 296;
int FEAT_EMPTY_BODY                     = 297;
//int FEAT_DETECT_EVIL = 298;
int FEAT_LAY_ON_HANDS                   = 299;
int FEAT_AURA_OF_COURAGE                = 300;
int FEAT_SMITE_EVIL                     = 301;
int FEAT_REMOVE_DISEASE                 = 302;
int FEAT_SUMMON_FAMILIAR                = 303;
int FEAT_ELEMENTAL_SHAPE                = 304;
int FEAT_WILD_SHAPE                     = 305;
int FEAT_WAR_DOMAIN_POWER               = 306;
int FEAT_STRENGTH_DOMAIN_POWER          = 307;
int FEAT_PROTECTION_DOMAIN_POWER        = 308;
int FEAT_LUCK_DOMAIN_POWER              = 309;
int FEAT_DEATH_DOMAIN_POWER             = 310;
int FEAT_AIR_DOMAIN_POWER               = 311;
int FEAT_ANIMAL_DOMAIN_POWER            = 312;
int FEAT_DESTRUCTION_DOMAIN_POWER       = 313;
int FEAT_EARTH_DOMAIN_POWER             = 314;
int FEAT_EVIL_DOMAIN_POWER              = 315;
int FEAT_FIRE_DOMAIN_POWER              = 316;
int FEAT_GOOD_DOMAIN_POWER              = 317;
int FEAT_HEALING_DOMAIN_POWER           = 318;
int FEAT_KNOWLEDGE_DOMAIN_POWER         = 319;
int FEAT_MAGIC_DOMAIN_POWER             = 320;
int FEAT_PLANT_DOMAIN_POWER             = 321;
int FEAT_SUN_DOMAIN_POWER               = 322;
int FEAT_TRAVEL_DOMAIN_POWER            = 323;
int FEAT_TRICKERY_DOMAIN_POWER          = 324;
int FEAT_WATER_DOMAIN_POWER             = 325;
int FEAT_LOWLIGHTVISION                 = 354;
int FEAT_IMPROVED_INITIATIVE = 377;
int FEAT_ARTIST = 378;
int FEAT_BLOODED = 379;
int FEAT_BULLHEADED = 380;
int FEAT_COURTLY_MAGOCRACY = 381;
int FEAT_LUCK_OF_HEROES = 382;
int FEAT_RESIST_POISON = 383;
int FEAT_SILVER_PALM = 384;
int FEAT_SNAKEBLOOD = 386;
int FEAT_STEALTHY = 387;
int FEAT_STRONGSOUL = 388;
int FEAT_COMBAT_EXPERTISE = 389;
int FEAT_IMPROVED_COMBAT_EXPERTISE = 390;
int FEAT_GREAT_CLEAVE = 391;
int FEAT_SPRING_ATTACK = 392;
int FEAT_GREATER_SPELL_FOCUS_ABJURATION = 393;
int FEAT_GREATER_SPELL_FOCUS_CONJURATION = 394;
int FEAT_GREATER_SPELL_FOCUS_DIVINIATION = 395;
int FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT = 396;
int FEAT_GREATER_SPELL_FOCUS_EVOCATION = 397;
int FEAT_GREATER_SPELL_FOCUS_ILLUSION = 398;
int FEAT_GREATER_SPELL_FOCUS_NECROMANCY = 399;
int FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION = 400;
int FEAT_GREATER_SPELL_PENETRATION = 401;
int FEAT_THUG = 402;
int FEAT_SKILLFOCUS_APPRAISE = 404;
int FEAT_SKILL_FOCUS_TUMBLE = 406;
int FEAT_SKILL_FOCUS_CRAFT_TRAP = 407;
int FEAT_BLIND_FIGHT = 408;
int FEAT_CIRCLE_KICK = 409;
int FEAT_EXTRA_STUNNING_ATTACK = 410;
int FEAT_RAPID_RELOAD = 411;
int FEAT_ZEN_ARCHERY = 412;
int FEAT_DIVINE_MIGHT = 413;
int FEAT_DIVINE_SHIELD = 414;
int FEAT_ARCANE_DEFENSE_ABJURATION = 415;
int FEAT_ARCANE_DEFENSE_CONJURATION = 416;
int FEAT_ARCANE_DEFENSE_DIVINATION = 417;
int FEAT_ARCANE_DEFENSE_ENCHANTMENT = 418;
int FEAT_ARCANE_DEFENSE_EVOCATION = 419;
int FEAT_ARCANE_DEFENSE_ILLUSION = 420;
int FEAT_ARCANE_DEFENSE_NECROMANCY = 421;
int FEAT_ARCANE_DEFENSE_TRANSMUTATION = 422;
int FEAT_EXTRA_MUSIC = 423;
int FEAT_LINGERING_SONG = 424;
int FEAT_DIRTY_FIGHTING = 425;  // JLR - OEI 07/19/05 -- DIRTY FIGHTING REMOVED, as per Ferret's request
int FEAT_RESIST_DISEASE = 426;
int FEAT_RESIST_ENERGY_COLD = 427;
int FEAT_RESIST_ENERGY_ACID = 428;
int FEAT_RESIST_ENERGY_FIRE = 429;
int FEAT_RESIST_ENERGY_ELECTRICAL = 430;
int FEAT_RESIST_ENERGY_SONIC = 431;
int FEAT_HIDE_IN_PLAIN_SIGHT = 433;
int FEAT_SHADOW_DAZE = 434;
int FEAT_SUMMON_SHADOW = 435;
int FEAT_SHADOW_EVADE = 436;
int FEAT_DENEIRS_EYE = 437;
int FEAT_TYMORAS_SMILE = 438;
int FEAT_LLIIRAS_HEART = 439;
int FEAT_CRAFT_HARPER_ITEM = 440;
int FEAT_HARPER_SLEEP = 441;
int FEAT_HARPER_CATS_GRACE = 442;
int FEAT_HARPER_EAGLES_SPLENDOR = 443;
int FEAT_HARPER_INVISIBILITY = 444;

int FEAT_PRESTIGE_ENCHANT_ARROW_1     =  445;

int FEAT_PRESTIGE_ENCHANT_ARROW_2     =  446;
int FEAT_PRESTIGE_ENCHANT_ARROW_3     =  447;
int FEAT_PRESTIGE_ENCHANT_ARROW_4     =  448;
int FEAT_PRESTIGE_ENCHANT_ARROW_5     =  449;
int FEAT_PRESTIGE_IMBUE_ARROW     =  450;
int FEAT_PRESTIGE_SEEKER_ARROW_1     =  451;
int FEAT_PRESTIGE_SEEKER_ARROW_2     =  452;
int FEAT_PRESTIGE_HAIL_OF_ARROWS     =  453;
int FEAT_PRESTIGE_ARROW_OF_DEATH     =  454;


int FEAT_PRESTIGE_DEATH_ATTACK_1     =  455;
int FEAT_PRESTIGE_DEATH_ATTACK_2     =  456;
int FEAT_PRESTIGE_DEATH_ATTACK_3     =  457;
int FEAT_PRESTIGE_DEATH_ATTACK_4     =  458;
int FEAT_PRESTIGE_DEATH_ATTACK_5     =  459;

int FEAT_BLACKGUARD_SNEAK_ATTACK_1D6     =  460;
int FEAT_BLACKGUARD_SNEAK_ATTACK_2D6     =  461;
int FEAT_BLACKGUARD_SNEAK_ATTACK_3D6     =  462;

int FEAT_PRESTIGE_POISON_SAVE_1     =  463;
int FEAT_PRESTIGE_POISON_SAVE_2     =  464;
int FEAT_PRESTIGE_POISON_SAVE_3     =  465;
int FEAT_PRESTIGE_POISON_SAVE_4     =  466;
int FEAT_PRESTIGE_POISON_SAVE_5     =  467;

int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE     =  468;
int FEAT_PRESTIGE_DARKNESS     =  469;
int FEAT_PRESTIGE_INVISIBILITY_1     =  470;
int FEAT_PRESTIGE_INVISIBILITY_2     =  471;

int FEAT_SMITE_GOOD     =  472;

int FEAT_PRESTIGE_DARK_BLESSING     =  473;
int FEAT_INFLICT_LIGHT_WOUNDS     =  474;
int FEAT_INFLICT_MODERATE_WOUNDS     =  475;
int FEAT_INFLICT_SERIOUS_WOUNDS     =  476;
int FEAT_INFLICT_CRITICAL_WOUNDS     =  477;
int FEAT_BULLS_STRENGTH     =  478;
int FEAT_CONTAGION     =  479;
int FEAT_EPIC_ARMOR_SKIN     =  490;
int FEAT_EPIC_BLINDING_SPEED     =  491;
int FEAT_EPIC_DAMAGE_REDUCTION_3     =  492;
int FEAT_EPIC_DAMAGE_REDUCTION_6     =  493;
int FEAT_EPIC_DAMAGE_REDUCTION_9     =  494;
int FEAT_EPIC_DEVASTATING_CRITICAL_CLUB     =  495;
int FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER     =  496;
int FEAT_EPIC_DEVASTATING_CRITICAL_DART     =  497;
int FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW     =  498;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW     =  499;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE     =  500;
int FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR     =  501;
int FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF     =  502;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR     =  503;
int FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE     =  504;
int FEAT_EPIC_DEVASTATING_CRITICAL_SLING     =  505;
int FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED     =  506;
int FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW     =  507;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW     =  508;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD     =  509;
int FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER     =  510;
int FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR     =  511;
int FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD     =  512;
int FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD     =  513;
int FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE     =  514;
int FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE     =  515;
int FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE     =  516;
int FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE     =  517;
int FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD     =  518;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER     =  519;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL     =  520;
int FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER     =  521;
int FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL     =  522;
int FEAT_EPIC_DEVASTATING_CRITICAL_KAMA     =  523;
int FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI     =  524;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN     =  525;
int FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE     =  526;
int FEAT_EPIC_DEVASTATING_CRITICAL_KATANA     =  527;
int FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD     =  528;
int FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE     =  529;
int FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE     =  530;
int FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD     =  531;
int FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE     =  532;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_1     =  533;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_2     =  534;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_3     =  535;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_4     =  536;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_5     =  537;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_6     =  538;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_7     =  539;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_8     =  540;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_9     =  541;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_10     =  542;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_1     =  543;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_2     =  544;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_3     =  545;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_4     =  546;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_5     =  547;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_6     =  548;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_7     =  549;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_8     =  550;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_9     =  551;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_10     =  552;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1     =  553;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_2     =  554;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_3     =  555;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_4     =  556;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_5     =  557;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_6     =  558;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_7     =  559;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_8     =  560;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_9     =  561;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_10     =  562;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_1     =  563;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_2     =  564;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_3     =  565;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_4     =  566;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_5     =  567;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_6     =  568;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_7     =  569;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_8     =  570;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_9     =  571;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_10     =  572;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_1     =  573;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_2     =  574;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_3     =  575;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_4     =  576;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_5     =  577;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_6     =  578;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_7     =  579;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_8     =  580;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_9     =  581;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_10     =  582;

int FEAT_EPIC_FORTITUDE     =  583;
int FEAT_EPIC_PROWESS     =  584;
int FEAT_EPIC_REFLEXES     =  585;
int FEAT_EPIC_REPUTATION     =  586;
int FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY     =  587;
int FEAT_EPIC_SKILL_FOCUS_APPRAISE     =  588;
int FEAT_EPIC_SKILL_FOCUS_CONCENTRATION     =  589;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP     =  590;
int FEAT_EPIC_SKILL_FOCUS_DISABLETRAP     =  591;
int FEAT_EPIC_SKILL_FOCUS_DISCIPLINE     =  592;
int FEAT_EPIC_SKILL_FOCUS_HEAL     =  593;
int FEAT_EPIC_SKILL_FOCUS_HIDE     =  594;
int FEAT_EPIC_SKILL_FOCUS_LISTEN     =  595;
int FEAT_EPIC_SKILL_FOCUS_LORE     =  596;
int FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY     =  597;
int FEAT_EPIC_SKILL_FOCUS_OPENLOCK     =  598;
int FEAT_EPIC_SKILL_FOCUS_PARRY     =  599;
int FEAT_EPIC_SKILL_FOCUS_PERFORM     =  600;
int FEAT_EPIC_SKILL_FOCUS_DIPLOMACY    =  601;
int FEAT_EPIC_SKILL_FOCUS_SLEIGHT_OF_HAND     =  602;
int FEAT_EPIC_SKILL_FOCUS_SEARCH     =  603;
int FEAT_EPIC_SKILL_FOCUS_SETTRAP     =  604;
int FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT     =  605;
int FEAT_EPIC_SKILL_FOCUS_SPOT     =  606;
int FEAT_EPIC_SKILL_FOCUS_TAUNT     =  607;
int FEAT_EPIC_SKILL_FOCUS_TUMBLE     =  608;
int FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE     =  609;
int FEAT_EPIC_SPELL_FOCUS_ABJURATION     =  610;
int FEAT_EPIC_SPELL_FOCUS_CONJURATION     =  611;
int FEAT_EPIC_SPELL_FOCUS_DIVINATION     =  612;
int FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT     =  613;
int FEAT_EPIC_SPELL_FOCUS_EVOCATION     =  614;
int FEAT_EPIC_SPELL_FOCUS_ILLUSION     =  615;
int FEAT_EPIC_SPELL_FOCUS_NECROMANCY     =  616;
int FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION     =  617;
int FEAT_EPIC_SPELL_PENETRATION     =  618;
int FEAT_EPIC_WEAPON_FOCUS_CLUB     =  619;
int FEAT_EPIC_WEAPON_FOCUS_DAGGER     =  620;
int FEAT_EPIC_WEAPON_FOCUS_DART     =  621;
int FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW     =  622;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW     =  623;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE     =  624;
int FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR     =  625;
int FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF     =  626;
int FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR     =  627;
int FEAT_EPIC_WEAPON_FOCUS_SICKLE     =  628;
int FEAT_EPIC_WEAPON_FOCUS_SLING     =  629;
int FEAT_EPIC_WEAPON_FOCUS_UNARMED     =  630;
int FEAT_EPIC_WEAPON_FOCUS_LONGBOW     =  631;
int FEAT_EPIC_WEAPON_FOCUS_SHORTBOW     =  632;
int FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD     =  633;
int FEAT_EPIC_WEAPON_FOCUS_RAPIER     =  634;
int FEAT_EPIC_WEAPON_FOCUS_SCIMITAR     =  635;
int FEAT_EPIC_WEAPON_FOCUS_LONGSWORD     =  636;
int FEAT_EPIC_WEAPON_FOCUS_GREATSWORD     =  637;
int FEAT_EPIC_WEAPON_FOCUS_HANDAXE     =  638;
int FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE     =  639;
int FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE     =  640;
int FEAT_EPIC_WEAPON_FOCUS_GREATAXE     =  641;
int FEAT_EPIC_WEAPON_FOCUS_HALBERD     =  642;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER     =  643;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL     =  644;
int FEAT_EPIC_WEAPON_FOCUS_WARHAMMER     =  645;
int FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL     =  646;
int FEAT_EPIC_WEAPON_FOCUS_KAMA     =  647;
int FEAT_EPIC_WEAPON_FOCUS_KUKRI     =  648;
int FEAT_EPIC_WEAPON_FOCUS_SHURIKEN     =  649;
int FEAT_EPIC_WEAPON_FOCUS_SCYTHE     =  650;
int FEAT_EPIC_WEAPON_FOCUS_KATANA     =  651;
int FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD     =  652;
int FEAT_EPIC_WEAPON_FOCUS_DIREMACE     =  653;
int FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE     =  654;
int FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD     =  655;
int FEAT_EPIC_WEAPON_FOCUS_CREATURE     =  656;
int FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB     =  657;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER     =  658;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DART     =  659;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW     =  660;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW     =  661;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE     =  662;
int FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR     =  663;
int FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF     =  664;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR     =  665;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE     =  666;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SLING     =  667;
int FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED     =  668;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW     =  669;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW     =  670;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD     =  671;
int FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER     =  672;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR     =  673;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD     =  674;
int FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD     =  675;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE     =  676;
int FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE     =  677;
int FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE     =  678;
int FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE     =  679;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD     =  680;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER     =  681;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL     =  682;
int FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER     =  683;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL     =  684;
int FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA     =  685;
int FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI     =  686;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN     =  687;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE     =  688;
int FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA     =  689;
int FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD     =  690;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE     =  691;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE     =  692;
int FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD     =  693;
int FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE     =  694;

int FEAT_EPIC_WILL     =  695;
int FEAT_EPIC_IMPROVED_COMBAT_CASTING     =  696;
int FEAT_EPIC_IMPROVED_KI_STRIKE_4     =  697;
int FEAT_EPIC_IMPROVED_KI_STRIKE_5     =  698;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1     =  699;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_2     =  700;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_3     =  701;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_4     =  702;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_5     =  703;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_6     =  704;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_7     =  705;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_8     =  706;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_9     =  707;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_10     =  708;
int FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB     =  709;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER     =  710;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DART     =  711;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW     =  712;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW     =  713;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE     =  714;
int FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR     =  715;
int FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF     =  716;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR     =  717;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE     =  718;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SLING     =  719;
int FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED     =  720;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW     =  721;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW     =  722;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD     =  723;
int FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER     =  724;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR     =  725;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD     =  726;
int FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD     =  727;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE     =  728;
int FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE     =  729;
int FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE     =  730;
int FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE     =  731;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD     =  732;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER     =  733;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL     =  734;
int FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER     =  735;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL     =  736;
int FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA     =  737;
int FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI     =  738;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN     =  739;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE     =  740;
int FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA     =  741;
int FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD     =  742;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE     =  743;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE     =  744;
int FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD     =  745;
int FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE     =  746;
int FEAT_EPIC_PERFECT_HEALTH     =  747;
int FEAT_EPIC_SELF_CONCEALMENT_10     =  748;
int FEAT_EPIC_SELF_CONCEALMENT_20     =  749;
int FEAT_EPIC_SELF_CONCEALMENT_30     =  750;
int FEAT_EPIC_SELF_CONCEALMENT_40     =  751;
int FEAT_EPIC_SELF_CONCEALMENT_50     =  752;
int FEAT_EPIC_SUPERIOR_INITIATIVE     =  753;
int FEAT_EPIC_TOUGHNESS_1     =  754;
int FEAT_EPIC_TOUGHNESS_2     =  755;
int FEAT_EPIC_TOUGHNESS_3     =  756;
int FEAT_EPIC_TOUGHNESS_4     =  757;
int FEAT_EPIC_TOUGHNESS_5     =  758;
int FEAT_EPIC_TOUGHNESS_6     =  759;
int FEAT_EPIC_TOUGHNESS_7     =  760;
int FEAT_EPIC_TOUGHNESS_8     =  761;
int FEAT_EPIC_TOUGHNESS_9     =  762;
int FEAT_EPIC_TOUGHNESS_10     =  763;
int FEAT_EPIC_GREAT_CHARISMA_1     =  764;
int FEAT_EPIC_GREAT_CHARISMA_2     =  765;
int FEAT_EPIC_GREAT_CHARISMA_3     =  766;
int FEAT_EPIC_GREAT_CHARISMA_4     =  767;
int FEAT_EPIC_GREAT_CHARISMA_5     =  768;
int FEAT_EPIC_GREAT_CHARISMA_6     =  769;
int FEAT_EPIC_GREAT_CHARISMA_7     =  770;
int FEAT_EPIC_GREAT_CHARISMA_8     =  771;
int FEAT_EPIC_GREAT_CHARISMA_9     =  772;
int FEAT_EPIC_GREAT_CHARISMA_10     =  773;
int FEAT_EPIC_GREAT_CONSTITUTION_1     =  774;
int FEAT_EPIC_GREAT_CONSTITUTION_2     =  775;
int FEAT_EPIC_GREAT_CONSTITUTION_3     =  776;
int FEAT_EPIC_GREAT_CONSTITUTION_4     =  777;
int FEAT_EPIC_GREAT_CONSTITUTION_5     =  778;
int FEAT_EPIC_GREAT_CONSTITUTION_6     =  779;
int FEAT_EPIC_GREAT_CONSTITUTION_7     =  780;
int FEAT_EPIC_GREAT_CONSTITUTION_8     =  781;
int FEAT_EPIC_GREAT_CONSTITUTION_9     =  782;
int FEAT_EPIC_GREAT_CONSTITUTION_10     =  783;
int FEAT_EPIC_GREAT_DEXTERITY_1     =  784;
int FEAT_EPIC_GREAT_DEXTERITY_2     =  785;
int FEAT_EPIC_GREAT_DEXTERITY_3     =  786;
int FEAT_EPIC_GREAT_DEXTERITY_4     =  787;
int FEAT_EPIC_GREAT_DEXTERITY_5     =  788;
int FEAT_EPIC_GREAT_DEXTERITY_6     =  789;
int FEAT_EPIC_GREAT_DEXTERITY_7     =  790;
int FEAT_EPIC_GREAT_DEXTERITY_8     =  791;
int FEAT_EPIC_GREAT_DEXTERITY_9     =  792;
int FEAT_EPIC_GREAT_DEXTERITY_10     =  793;
int FEAT_EPIC_GREAT_INTELLIGENCE_1     =  794;
int FEAT_EPIC_GREAT_INTELLIGENCE_2     =  795;
int FEAT_EPIC_GREAT_INTELLIGENCE_3     =  796;
int FEAT_EPIC_GREAT_INTELLIGENCE_4     =  797;
int FEAT_EPIC_GREAT_INTELLIGENCE_5     =  798;
int FEAT_EPIC_GREAT_INTELLIGENCE_6     =  799;
int FEAT_EPIC_GREAT_INTELLIGENCE_7     =  800;
int FEAT_EPIC_GREAT_INTELLIGENCE_8     =  801;
int FEAT_EPIC_GREAT_INTELLIGENCE_9     =  802;
int FEAT_EPIC_GREAT_INTELLIGENCE_10     =  803;
int FEAT_EPIC_GREAT_WISDOM_1     =  804;
int FEAT_EPIC_GREAT_WISDOM_2     =  805;
int FEAT_EPIC_GREAT_WISDOM_3     =  806;
int FEAT_EPIC_GREAT_WISDOM_4     =  807;
int FEAT_EPIC_GREAT_WISDOM_5     =  808;
int FEAT_EPIC_GREAT_WISDOM_6     =  809;
int FEAT_EPIC_GREAT_WISDOM_7     =  810;
int FEAT_EPIC_GREAT_WISDOM_8     =  811;
int FEAT_EPIC_GREAT_WISDOM_9     =  812;
int FEAT_EPIC_GREAT_WISDOM_10     =  813;
int FEAT_EPIC_GREAT_STRENGTH_1     =  814;
int FEAT_EPIC_GREAT_STRENGTH_2     =  815;
int FEAT_EPIC_GREAT_STRENGTH_3     =  816;
int FEAT_EPIC_GREAT_STRENGTH_4     =  817;
int FEAT_EPIC_GREAT_STRENGTH_5     =  818;
int FEAT_EPIC_GREAT_STRENGTH_6     =  819;
int FEAT_EPIC_GREAT_STRENGTH_7     =  820;
int FEAT_EPIC_GREAT_STRENGTH_8     =  821;
int FEAT_EPIC_GREAT_STRENGTH_9     =  822;
int FEAT_EPIC_GREAT_STRENGTH_10     =  823;
int FEAT_EPIC_GREAT_SMITING_1     =  824;
int FEAT_EPIC_GREAT_SMITING_2     =  825;
int FEAT_EPIC_GREAT_SMITING_3     =  826;
int FEAT_EPIC_GREAT_SMITING_4     =  827;
int FEAT_EPIC_GREAT_SMITING_5     =  828;
int FEAT_EPIC_GREAT_SMITING_6     =  829;
int FEAT_EPIC_GREAT_SMITING_7     =  830;
int FEAT_EPIC_GREAT_SMITING_8     =  831;
int FEAT_EPIC_GREAT_SMITING_9     =  832;
int FEAT_EPIC_GREAT_SMITING_10     =  833;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1     =  834;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2     =  835;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3     =  836;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4     =  837;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5     =  838;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6     =  839;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7     =  840;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8     =  841;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9     =  842;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10     =  843;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_1     =  844;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_2     =  845;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_3     =  846;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_4     =  847;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_5     =  848;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_6     =  849;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_7     =  850;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_8     =  851;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_9     =  852;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_10     =  853;

int FEAT_EPIC_PLANAR_TURNING     =  854;    // AFW-OEI 02/08/2007: Re-enabled for NX1.
int FEAT_EPIC_BANE_OF_ENEMIES     =  855;
int FEAT_EPIC_DODGE     =  856;
int FEAT_EPIC_AUTOMATIC_QUICKEN_1     =  857;
int FEAT_EPIC_AUTOMATIC_QUICKEN_2     =  858;
int FEAT_EPIC_AUTOMATIC_QUICKEN_3     =  859;
int FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1   =  860;
int FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2   =  861;
int FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3   =  862;
int FEAT_EPIC_AUTOMATIC_STILL_SPELL_1    =  863;
int FEAT_EPIC_AUTOMATIC_STILL_SPELL_2    =  864;
int FEAT_EPIC_AUTOMATIC_STILL_SPELL_3    =  865;

int FEAT_WHIRLWIND_ATTACK     =  867;
int FEAT_IMPROVED_WHIRLWIND     =  868;
int FEAT_EPIC_BARBARIAN_RAGE     =  869;    // AFW-OEI 02/16/2007: ID recycled from 3.0 Mighty Rage
int FEAT_EPIC_LASTING_INSPIRATION     =  870;
int FEAT_CURSE_SONG     =  871;
int FEAT_EPIC_WILD_SHAPE_UNDEAD     =  872;
int FEAT_EPIC_WILD_SHAPE_DRAGON     =  873;
int FEAT_EPIC_SPELL_MUMMY_DUST     =  874;
int FEAT_EPIC_SPELL_DRAGON_KNIGHT     =  875;
int FEAT_EPIC_SPELL_HELLBALL     =  876;
int FEAT_EPIC_SPELL_MAGE_ARMOUR     =  877;
int FEAT_EPIC_SPELL_RUIN     =  878;
int FEAT_WEAPON_OF_CHOICE_SICKLE     =  879;
int FEAT_WEAPON_OF_CHOICE_KAMA     =  880;
int FEAT_WEAPON_OF_CHOICE_KUKRI     =  881;
int FEAT_KI_DAMAGE     =  882;
int FEAT_INCREASE_MULTIPLIER     =  883;
int FEAT_SUPERIOR_WEAPON_FOCUS     =  884;
int FEAT_KI_CRITICAL     =  885;
int FEAT_BONE_SKIN_2     =  886;
int FEAT_BONE_SKIN_4     =  887;
int FEAT_BONE_SKIN_6     =  888;
int FEAT_ANIMATE_DEAD     =  889;
int FEAT_SUMMON_UNDEAD     =  890;
int FEAT_DEATHLESS_VIGOR     =  891;
int FEAT_UNDEAD_GRAFT_1     =  892;
int FEAT_UNDEAD_GRAFT_2     =  893;
int FEAT_TOUGH_AS_BONE     =  894;
int FEAT_SUMMON_GREATER_UNDEAD     =  895;
int FEAT_DEATHLESS_MASTERY     =  896;
int FEAT_DEATHLESS_MASTER_TOUCH     =  897;
int FEAT_GREATER_WILDSHAPE_1     =  898;
int FEAT_GREATER_WILDSHAPE_2     =  900;
int FEAT_GREATER_WILDSHAPE_3     =  901;
int FEAT_HUMANOID_SHAPE     =  902;
int FEAT_GREATER_WILDSHAPE_4   =  903;
int FEAT_SACRED_DEFENSE_1     =  904;
int FEAT_SACRED_DEFENSE_2     =  905;
int FEAT_SACRED_DEFENSE_3     =  906;
int FEAT_SACRED_DEFENSE_4     =  907;
int FEAT_SACRED_DEFENSE_5     =  908;
int FEAT_DIVINE_WRATH     =  909;
int FEAT_EXTRA_SMITING     =  910;
int FEAT_SKILL_FOCUS_CRAFT_ARMOR     =  911;
int FEAT_SKILL_FOCUS_CRAFT_WEAPON     =  912;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR     =  913;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON     =  914;
int FEAT_SKILL_FOCUS_BLUFF     =  915;
int FEAT_SKILL_FOCUS_INTIMIDATE     =  916;
int FEAT_EPIC_SKILL_FOCUS_BLUFF     =  917;
int FEAT_EPIC_SKILL_FOCUS_INTIMIDATE     =  918;

int FEAT_WEAPON_OF_CHOICE_CLUB     =  919;
int FEAT_WEAPON_OF_CHOICE_DAGGER     =  920;
int FEAT_WEAPON_OF_CHOICE_LIGHTMACE     =  921;
int FEAT_WEAPON_OF_CHOICE_MORNINGSTAR     =  922;
int FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF     =  923;
int FEAT_WEAPON_OF_CHOICE_SHORTSPEAR     =  924;
int FEAT_WEAPON_OF_CHOICE_SHORTSWORD     =  925;
int FEAT_WEAPON_OF_CHOICE_RAPIER     =  926;
int FEAT_WEAPON_OF_CHOICE_SCIMITAR     =  927;
int FEAT_WEAPON_OF_CHOICE_LONGSWORD     =  928;
int FEAT_WEAPON_OF_CHOICE_GREATSWORD     =  929;
int FEAT_WEAPON_OF_CHOICE_HANDAXE     =  930;
int FEAT_WEAPON_OF_CHOICE_BATTLEAXE     =  931;
int FEAT_WEAPON_OF_CHOICE_GREATAXE     =  932;
int FEAT_WEAPON_OF_CHOICE_HALBERD     =  933;
int FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER     =  934;
int FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL     =  935;
int FEAT_WEAPON_OF_CHOICE_WARHAMMER     =  936;
int FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL     =  937;
int FEAT_WEAPON_OF_CHOICE_SCYTHE     =  938;
int FEAT_WEAPON_OF_CHOICE_KATANA     =  939;
int FEAT_WEAPON_OF_CHOICE_BASTARDSWORD     =  940;
int FEAT_WEAPON_OF_CHOICE_DIREMACE     =  941;
int FEAT_WEAPON_OF_CHOICE_DOUBLEAXE     =  942;
int FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD     =  943;

int FEAT_BREW_POTION     =  944;
int FEAT_SCRIBE_SCROLL     =  945;
int FEAT_CRAFT_WAND     =  946;

int FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE     =  947;
int FEAT_DAMAGE_REDUCTION_6     =  948;
int FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1     =  949;
int FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2     =  950;
int FEAT_PRESTIGE_DEFENSIVE_AWARENESS_3     =  951;
int FEAT_WEAPON_FOCUS_DWAXE     =  952;
int FEAT_WEAPON_SPECIALIZATION_DWAXE     =  953;
int FEAT_IMPROVED_CRITICAL_DWAXE     =  954;
int FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE     =  955;
int FEAT_EPIC_WEAPON_FOCUS_DWAXE     =  956;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE     =  957;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE     =  958;
int FEAT_WEAPON_OF_CHOICE_DWAXE     =  959;
int FEAT_USE_POISON     =  960;

int FEAT_DRAGON_ARMOR            = 961;
int FEAT_DRAGON_ABILITIES        = 962;
int FEAT_DRAGON_IMMUNE_PARALYSIS = 963;
int FEAT_DRAGON_IMMUNE_FIRE       = 964;
int FEAT_DRAGON_DIS_BREATH        = 965;
int FEAT_EPIC_FIGHTER             = 966;
int FEAT_EPIC_BARBARIAN           = 967;
int FEAT_EPIC_BARD             = 968;
int FEAT_EPIC_CLERIC           = 969;
int FEAT_EPIC_DRUID            = 970;
int FEAT_EPIC_MONK             = 971;
int FEAT_EPIC_PALADIN          = 972;
int FEAT_EPIC_RANGER           = 973;
int FEAT_EPIC_ROGUE            = 974;
int FEAT_EPIC_SORCERER         = 975;
int FEAT_EPIC_WIZARD           = 976;
int FEAT_EPIC_ARCANE_ARCHER    = 977;
int FEAT_EPIC_ASSASSIN         = 978;
int FEAT_EPIC_BLACKGUARD       = 979;
int FEAT_EPIC_SHADOWDANCER     = 980;
int FEAT_EPIC_HARPER_SCOUT     = 981;
int FEAT_EPIC_DIVINE_CHAMPION  = 982;
int FEAT_EPIC_WEAPON_MASTER    = 983;
int FEAT_EPIC_PALE_MASTER      = 984;
int FEAT_EPIC_DWARVEN_DEFENDER = 985;
int FEAT_EPIC_SHIFTER          = 986;
int FEAT_EPIC_RED_DRAGON_DISC  = 987;
int FEAT_EPIC_THUNDERING_RAGE  = 988;


// JLR - OEI 06/29/05 NWN2 3.5 -- New Feats (Some were old, just hadn't been updated here)


int FEAT_EPIC_TERRIFYING_RAGE                        = 989;
int FEAT_EPIC_SPELL_EPIC_WARDING                     = 990;
int FEAT_PRESTIGE_MASTER_CRAFTER                     = 991;
int FEAT_PRESTIGE_SCROUNGER                          = 992;
int FEAT_WEAPON_FOCUS_WHIP                           = 993;
int FEAT_WEAPON_SPECIALIZATION_WHIP                  = 994;
int FEAT_IMPROVED_CRITICAL_WHIP                      = 995;
int FEAT_EPIC_DEVASTATING_CRITICAL_WHIP              = 996;
int FEAT_EPIC_WEAPON_FOCUS_WHIP                      = 997;
int FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP             = 998;
int FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP             = 999;
int FEAT_WEAPON_OF_CHOICE_WHIP                       = 1000;
int FEAT_EPIC_CHARACTER                              = 1001;
int FEAT_EPIC_EPIC_SHADOWLORD                        = 1002;
int FEAT_EPIC_EPIC_FIEND                             = 1003;
int FEAT_PRESTIGE_DEATH_ATTACK_6                     = 1004;
int FEAT_PRESTIGE_DEATH_ATTACK_7                     = 1005;
int FEAT_PRESTIGE_DEATH_ATTACK_8                     = 1006;
int FEAT_BLACKGUARD_SNEAK_ATTACK_4D6                 = 1007;
int FEAT_BLACKGUARD_SNEAK_ATTACK_5D6                 = 1008;
int FEAT_BLACKGUARD_SNEAK_ATTACK_6D6                 = 1009;
int FEAT_BLACKGUARD_SNEAK_ATTACK_7D6                 = 1010;
int FEAT_BLACKGUARD_SNEAK_ATTACK_8D6                 = 1011;
int FEAT_BLACKGUARD_SNEAK_ATTACK_9D6                 = 1012;
int FEAT_BLACKGUARD_SNEAK_ATTACK_10D6                = 1013;
int FEAT_BLACKGUARD_SNEAK_ATTACK_11D6                = 1014;
int FEAT_BLACKGUARD_SNEAK_ATTACK_12D6                = 1015;
int FEAT_BLACKGUARD_SNEAK_ATTACK_13D6                = 1016;
int FEAT_BLACKGUARD_SNEAK_ATTACK_14D6                = 1017;
int FEAT_BLACKGUARD_SNEAK_ATTACK_15D6                = 1018;
int FEAT_PRESTIGE_DEATH_ATTACK_9                     = 1019;
int FEAT_PRESTIGE_DEATH_ATTACK_10                    = 1020;
int FEAT_PRESTIGE_DEATH_ATTACK_11                    = 1021;
int FEAT_PRESTIGE_DEATH_ATTACK_12                    = 1022;
int FEAT_PRESTIGE_DEATH_ATTACK_13                    = 1023;
int FEAT_PRESTIGE_DEATH_ATTACK_14                    = 1024;
int FEAT_PRESTIGE_DEATH_ATTACK_15                    = 1025;
int FEAT_PRESTIGE_DEATH_ATTACK_16                    = 1026;
int FEAT_PRESTIGE_DEATH_ATTACK_17                    = 1027;
int FEAT_PRESTIGE_DEATH_ATTACK_18                    = 1028;
int FEAT_PRESTIGE_DEATH_ATTACK_19                    = 1029;
int FEAT_PRESTIGE_DEATH_ATTACK_20                    = 1030;
int FEAT_BLANK                                       = 1031;
int FEAT_SNEAK_ATTACK_11                             = 1032;
int FEAT_SNEAK_ATTACK_12                             = 1033;
int FEAT_SNEAK_ATTACK_13                             = 1034;
int FEAT_SNEAK_ATTACK_14                             = 1035;
int FEAT_SNEAK_ATTACK_15                             = 1036;
int FEAT_SNEAK_ATTACK_16                             = 1037;
int FEAT_SNEAK_ATTACK_17                             = 1038;
int FEAT_SNEAK_ATTACK_18                             = 1039;
int FEAT_SNEAK_ATTACK_19                             = 1040;
int FEAT_SNEAK_ATTACK_20                             = 1041;
int FEAT_DRAGON_HDINCREASE_D6                        = 1042;
int FEAT_DRAGON_HDINCREASE_D8                        = 1043;
int FEAT_DRAGON_HDINCREASE_D10                       = 1044;
int FEAT_PRESTIGE_ENCHANT_ARROW_6                    = 1045;
int FEAT_PRESTIGE_ENCHANT_ARROW_7                    = 1046;
int FEAT_PRESTIGE_ENCHANT_ARROW_8                    = 1047;
int FEAT_PRESTIGE_ENCHANT_ARROW_9                    = 1048;
int FEAT_PRESTIGE_ENCHANT_ARROW_10                   = 1049;
int FEAT_PRESTIGE_ENCHANT_ARROW_11                   = 1050;
int FEAT_PRESTIGE_ENCHANT_ARROW_12                   = 1051;
int FEAT_PRESTIGE_ENCHANT_ARROW_13                   = 1052;
int FEAT_PRESTIGE_ENCHANT_ARROW_14                   = 1053;
int FEAT_PRESTIGE_ENCHANT_ARROW_15                   = 1054;
int FEAT_PRESTIGE_ENCHANT_ARROW_16                   = 1055;
int FEAT_PRESTIGE_ENCHANT_ARROW_17                   = 1056;
int FEAT_PRESTIGE_ENCHANT_ARROW_18                   = 1057;
int FEAT_PRESTIGE_ENCHANT_ARROW_19                   = 1058;
int FEAT_PRESTIGE_ENCHANT_ARROW_20                   = 1059;
int  FEAT_EPIC_OUTSIDER_SHAPE                        = 1060;
int  FEAT_EPIC_CONSTRUCT_SHAPE                       = 1061;
int  FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_1          = 1062;
int  FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_2          = 1063;
int  FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_3          = 1064;
int  FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_4          = 1065;
int  FEAT_EPIC_SHIFTER_INFINITE_HUMANOID_SHAPE       = 1066;
int FEAT_EPIC_BARBARIAN_DAMAGE_REDUCTION             = 1067;
int FEAT_EPIC_DRUID_INFINITE_WILDSHAPE               = 1068;
int FEAT_EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE         = 1069;
int FEAT_PRESTIGE_POISON_SAVE_EPIC                   = 1070;
int FEAT_EPIC_SUPERIOR_WEAPON_FOCUS                  = 1071;
// FAK - OEI new racial subtype feats
int FEAT_OFFENSIVE_TRAINING_ABERRATIONS              = 1072;
int FEAT_ENLARGE                             = 1073;
int FEAT_INVISIBILITY                        = 1074;
int FEAT_DROW_RESISTANCE                     = 1075;
int FEAT_DROW_DARKNESS                       = 1076;
int FEAT_DROW_FAERIE_FIRE                    = 1077;
int FEAT_SVIRFNEBLIN_RESISTANCE              = 1078;
int FEAT_SVIRFNEBLIN_BLIND                   = 1079;
int FEAT_SVIRFNEBLIN_BLUR                    = 1080;
int FEAT_SVIRFNEBLIN_CHANGE_SELF                   = 1081;
int FEAT_SVIRFNEBLIN_DODGE                   = 1082;
int FEAT_SVIRFNEBLIN_SAVE                    = 1083;
int FEAT_AASIMAR_SEARCH                      = 1084;
int FEAT_AASIMAR_RESISTANCE                  = 1085;
int FEAT_AASIMAR_LIGHT                       = 1086;
int FEAT_TIEFLING_HIDE                       = 1087;
int FEAT_TIEFLING_DARKNESS                   = 1088;
int FEAT_TIEFLING_RESISTANCE                     = 1089;
// JLR - OEI 05/23/05 NWN2 3.5 -- New Feats
int FEAT_AUGMENT_HEALING                    = 1090;
int FEAT_AUGMENT_SUMMONING                  = 1091;
int FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR             = 1092;
int FEAT_CRAFT_WONDROUS_ITEMS                   = 1093;
int FEAT_DIEHARD                            = 1094;
int FEAT_EXPERT_TACTICIAN                   = 1095;
int FEAT_SKILL_AFFINITY_DIPLOMACY               = 1096;
int FEAT_SKILL_AFFINITY_BLUFF                   = 1097;
int FEAT_FEINT                          = 1098;
int FEAT_GREATER_TWO_WEAPON_FIGHTING            = 1099;
int FEAT_IMPROVED_RAPID_SHOT                    = 1100;
int FEAT_IMPROVED_SHIELD_BASH                   = 1101;
int FEAT_IMPROVED_TWO_WEAPON_DEFENSE            = 1102;
int FEAT_MANYSHOT                           = 1103;
int FEAT_MIND_OVER_BODY                     = 1104;
int FEAT_MONKEY_GRIP                        = 1105;
int FEAT_MOUNTED_ARCHERY                    = 1106;
int FEAT_MOUNTED_COMBAT                     = 1107;
int FEAT_NATURAL_SPELL                      = 1108;
int FEAT_NEGOTIATOR                     = 1109;
int FEAT_NIMBLE_FINGERS                     = 1110;
int FEAT_OPEN_MINDED                        = 1111;
int FEAT_RIDE_BY_ATTACK                     = 1112;
int FEAT_SKILLED_OFFENSE                    = 1113;
int FEAT_SPELLCASTING_PRODIGY                   = 1114;
int FEAT_TOWER_SHIELD_PROFICIENCY               = 1115;
int FEAT_TRACK                          = 1116;
int FEAT_TWO_WEAPON_DEFENSE                 = 1117;
int FEAT_GREATER_WEAPON_FOCUS_CLUB              = 1118;
int FEAT_GREATER_WEAPON_FOCUS_DAGGER            = 1119;
int FEAT_GREATER_WEAPON_FOCUS_DART              = 1120;
int FEAT_GREATER_WEAPON_FOCUS_HEAVYCROSSBOW     = 1121;
int FEAT_GREATER_WEAPON_FOCUS_LIGHTCROSSBOW     = 1122;
int FEAT_GREATER_WEAPON_FOCUS_LIGHTMACE         = 1123;
int FEAT_GREATER_WEAPON_FOCUS_MORNINGSTAR           = 1124;
int FEAT_GREATER_WEAPON_FOCUS_QUARTERSTAFF      = 1125;
int FEAT_GREATER_WEAPON_FOCUS_SHORTSPEAR            = 1126;
int FEAT_GREATER_WEAPON_FOCUS_SICKLE            = 1127;
int FEAT_GREATER_WEAPON_FOCUS_SLING             = 1128;
int FEAT_GREATER_WEAPON_FOCUS_UNARMED           = 1129;
int FEAT_GREATER_WEAPON_FOCUS_LONGBOW           = 1130;
int FEAT_GREATER_WEAPON_FOCUS_SHORTBOW          = 1131;
int FEAT_GREATER_WEAPON_FOCUS_SHORTSWORD            = 1132;
int FEAT_GREATER_WEAPON_FOCUS_RAPIER            = 1133;
int FEAT_GREATER_WEAPON_FOCUS_SCIMITAR          = 1134;
int FEAT_GREATER_WEAPON_FOCUS_LONGSWORD         = 1135;
int FEAT_GREATER_WEAPON_FOCUS_GREATSWORD            = 1136;
int FEAT_GREATER_WEAPON_FOCUS_HANDAXE           = 1137;
int FEAT_GREATER_WEAPON_FOCUS_THROWINGAXE           = 1138;
int FEAT_GREATER_WEAPON_FOCUS_BATTLEAXE         = 1139;
int FEAT_GREATER_WEAPON_FOCUS_GREATAXE          = 1140;
int FEAT_GREATER_WEAPON_FOCUS_HALBERD           = 1141;
int FEAT_GREATER_WEAPON_FOCUS_LIGHTHAMMER           = 1142;
int FEAT_GREATER_WEAPON_FOCUS_LIGHTFLAIL            = 1143;
int FEAT_GREATER_WEAPON_FOCUS_WARHAMMER         = 1144;
int FEAT_GREATER_WEAPON_FOCUS_HEAVYFLAIL            = 1145;
int FEAT_GREATER_WEAPON_FOCUS_KAMA              = 1146;
int FEAT_GREATER_WEAPON_FOCUS_KUKRI             = 1147;
int FEAT_GREATER_WEAPON_FOCUS_SHURIKEN          = 1148;
int FEAT_GREATER_WEAPON_FOCUS_SCYTHE            = 1149;
int FEAT_GREATER_WEAPON_FOCUS_KATANA            = 1150;
int FEAT_GREATER_WEAPON_FOCUS_BASTARDSWORD      = 1151;
int FEAT_GREATER_WEAPON_FOCUS_DIREMACE          = 1152;
int FEAT_GREATER_WEAPON_FOCUS_DOUBLEAXE         = 1153;
int FEAT_GREATER_WEAPON_FOCUS_TWOBLADEDSWORD        = 1154;
int FEAT_GREATER_WEAPON_FOCUS_DWAXE             = 1155;
int FEAT_GREATER_WEAPON_FOCUS_WHIP              = 1156;
int FEAT_GREATER_WEAPON_FOCUS_CREATURE          = 1157;
int FEAT_GREATER_WEAPON_SPECIALIZATION_CLUB     = 1158;
int FEAT_GREATER_WEAPON_SPECIALIZATION_DAGGER       = 1159;
int FEAT_GREATER_WEAPON_SPECIALIZATION_DART     = 1160;
int FEAT_GREATER_WEAPON_SPECIALIZATION_HEAVYCROSSBOW    = 1161;
int FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTCROSSBOW    = 1162;
int FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTMACE        = 1163;
int FEAT_GREATER_WEAPON_SPECIALIZATION_MORNINGSTAR      = 1164;
int FEAT_GREATER_WEAPON_SPECIALIZATION_QUARTERSTAFF     = 1165;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTSPEAR       = 1166;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SICKLE           = 1167;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SLING            = 1168;
int FEAT_GREATER_WEAPON_SPECIALIZATION_UNARMED          = 1169;
int FEAT_GREATER_WEAPON_SPECIALIZATION_LONGBOW          = 1170;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTBOW         = 1171;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTSWORD       = 1172;
int FEAT_GREATER_WEAPON_SPECIALIZATION_RAPIER           = 1173;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SCIMITAR         = 1174;
int FEAT_GREATER_WEAPON_SPECIALIZATION_LONGSWORD        = 1175;
int FEAT_GREATER_WEAPON_SPECIALIZATION_GREATSWORD       = 1176;
int FEAT_GREATER_WEAPON_SPECIALIZATION_HANDAXE          = 1177;
int FEAT_GREATER_WEAPON_SPECIALIZATION_THROWINGAXE      = 1178;
int FEAT_GREATER_WEAPON_SPECIALIZATION_BATTLEAXE        = 1179;
int FEAT_GREATER_WEAPON_SPECIALIZATION_GREATAXE         = 1180;
int FEAT_GREATER_WEAPON_SPECIALIZATION_HALBERD          = 1181;
int FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTHAMMER      = 1182;
int FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTFLAIL       = 1183;
int FEAT_GREATER_WEAPON_SPECIALIZATION_WARHAMMER        = 1184;
int FEAT_GREATER_WEAPON_SPECIALIZATION_HEAVYFLAIL       = 1185;
int FEAT_GREATER_WEAPON_SPECIALIZATION_KAMA             = 1186;
int FEAT_GREATER_WEAPON_SPECIALIZATION_KUKRI            = 1187;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SHURIKEN         = 1188;
int FEAT_GREATER_WEAPON_SPECIALIZATION_SCYTHE           = 1189;
int FEAT_GREATER_WEAPON_SPECIALIZATION_KATANA           = 1190;
int FEAT_GREATER_WEAPON_SPECIALIZATION_BASTARDSWORD     = 1191;
int FEAT_GREATER_WEAPON_SPECIALIZATION_DIREMACE         = 1192;
int FEAT_GREATER_WEAPON_SPECIALIZATION_DOUBLEAXE        = 1193;
int FEAT_GREATER_WEAPON_SPECIALIZATION_TWOBLADEDSWORD   = 1194;
int FEAT_GREATER_WEAPON_SPECIALIZATION_DWAXE          = 1195;
int FEAT_GREATER_WEAPON_SPECIALIZATION_WHIP       = 1196;
int FEAT_GREATER_WEAPON_SPECIALIZATION_CREATURE       = 1197;
int FEAT_IMPROVED_FAVORED_ENEMY_DWARF             = 1198;
int FEAT_IMPROVED_FAVORED_ENEMY_ELF                     = 1199;
int FEAT_IMPROVED_FAVORED_ENEMY_GNOME                   = 1200;
int FEAT_IMPROVED_FAVORED_ENEMY_HALFLING                = 1201;
int FEAT_IMPROVED_FAVORED_ENEMY_HALFELF                 = 1202;
int FEAT_IMPROVED_FAVORED_ENEMY_HALFORC                 = 1203;
int FEAT_IMPROVED_FAVORED_ENEMY_HUMAN                   = 1204;
int FEAT_IMPROVED_FAVORED_ENEMY_ABERRATION              = 1205;
int FEAT_IMPROVED_FAVORED_ENEMY_ANIMAL                  = 1206;
int FEAT_IMPROVED_FAVORED_ENEMY_BEAST                   = 1207;
int FEAT_IMPROVED_FAVORED_ENEMY_CONSTRUCT               = 1208;
int FEAT_IMPROVED_FAVORED_ENEMY_DRAGON                  = 1209;
int FEAT_IMPROVED_FAVORED_ENEMY_GOBLINOID               = 1210;
int FEAT_IMPROVED_FAVORED_ENEMY_MONSTROUS               = 1211;
int FEAT_IMPROVED_FAVORED_ENEMY_ORC                     = 1212;
int FEAT_IMPROVED_FAVORED_ENEMY_REPTILIAN               = 1213;
int FEAT_IMPROVED_FAVORED_ENEMY_ELEMENTAL               = 1214;
int FEAT_IMPROVED_FAVORED_ENEMY_FEY                     = 1215;
int FEAT_IMPROVED_FAVORED_ENEMY_GIANT                   = 1216;
int FEAT_IMPROVED_FAVORED_ENEMY_MAGICAL_BEAST           = 1217;
int FEAT_IMPROVED_FAVORED_ENEMY_OUTSIDER                = 1218;
int FEAT_IMPROVED_FAVORED_ENEMY_SHAPECHANGER            = 1219;
int FEAT_IMPROVED_FAVORED_ENEMY_UNDEAD                  = 1220;
int FEAT_IMPROVED_FAVORED_ENEMY_VERMIN                  = 1221;
int FEAT_FAVORED_POWER_ATTACK_DWARF               = 1222;
int FEAT_FAVORED_POWER_ATTACK_GNOME             = 1223;
int FEAT_FAVORED_POWER_ATTACK_ELF               = 1224;
int FEAT_FAVORED_POWER_ATTACK_HALFLING          = 1225;
int FEAT_FAVORED_POWER_ATTACK_HALFELF           = 1226;
int FEAT_FAVORED_POWER_ATTACK_HALFORC           = 1227;
int FEAT_FAVORED_POWER_ATTACK_HUMAN             = 1228;
int FEAT_FAVORED_POWER_ATTACK_ABERRATION            = 1229;
int FEAT_FAVORED_POWER_ATTACK_ANIMAL            = 1230;
int FEAT_FAVORED_POWER_ATTACK_BEAST             = 1231;
int FEAT_FAVORED_POWER_ATTACK_CONSTRUCT         = 1232;
int FEAT_FAVORED_POWER_ATTACK_DRAGON            = 1233;
int FEAT_FAVORED_POWER_ATTACK_GOBLINOID         = 1234;
int FEAT_FAVORED_POWER_ATTACK_MONSTROUS         = 1235;
int FEAT_FAVORED_POWER_ATTACK_ORC               = 1236;
int FEAT_FAVORED_POWER_ATTACK_REPTILIAN         = 1237;
int FEAT_FAVORED_POWER_ATTACK_ELEMENTAL         = 1238;
int FEAT_FAVORED_POWER_ATTACK_FEY               = 1239;
int FEAT_FAVORED_POWER_ATTACK_GIANT             = 1240;
int FEAT_FAVORED_POWER_ATTACK_MAGICAL_BEAST     = 1241;
int FEAT_FAVORED_POWER_ATTACK_OUTSIDER          = 1242;
int FEAT_FAVORED_POWER_ATTACK_SHAPECHANGER      = 1243;
int FEAT_FAVORED_POWER_ATTACK_UNDEAD            = 1244;
int FEAT_FAVORED_POWER_ATTACK_VERMIN            = 1245;
int FEAT_PRACTICED_SPELLCASTER_BARD             = 1246;
int FEAT_PRACTICED_SPELLCASTER_CLERIC           = 1247;
int FEAT_PRACTICED_SPELLCASTER_DRUID            = 1248;
int FEAT_PRACTICED_SPELLCASTER_PALADIN          = 1249;
int FEAT_PRACTICED_SPELLCASTER_RANGER           = 1250;
int FEAT_PRACTICED_SPELLCASTER_SORCERER         = 1251;
int FEAT_PRACTICED_SPELLCASTER_WIZARD           = 1252;
int FEAT_GREATER_RESILIENCY                 = 1253;
int FEAT_COSMOPOLITAN_CONCENTRATION             = 1254;
int FEAT_COSMOPOLITAN_DISABLETRAP               = 1255;
int FEAT_COSMOPOLITAN_DISCIPLINE                = 1256;
int FEAT_COSMOPOLITAN_HEAL                  = 1257;
int FEAT_COSMOPOLITAN_HIDE                  = 1258;
int FEAT_COSMOPOLITAN_LISTEN                    = 1259;
int FEAT_COSMOPOLITAN_LORE                  = 1260;
int FEAT_COSMOPOLITAN_MOVESILENTLY              = 1261;
int FEAT_COSMOPOLITAN_OPENLOCK              = 1262;
int FEAT_COSMOPOLITAN_PARRY                 = 1263;
int FEAT_COSMOPOLITAN_PERFORM                   = 1264;
int FEAT_COSMOPOLITAN_DIPLOMACY             = 1265;
int FEAT_COSMOPOLITAN_SLEIGHT_OF_HAND           = 1266;
int FEAT_COSMOPOLITAN_SEARCH                    = 1267;
int FEAT_COSMOPOLITAN_SETTRAP                   = 1268;
int FEAT_COSMOPOLITAN_SPELLCRAFT                = 1269;
int FEAT_COSMOPOLITAN_SPOT                  = 1270;
int FEAT_COSMOPOLITAN_TAUNT                 = 1271;
int FEAT_COSMOPOLITAN_USEMAGICDEVICE            = 1272;
int FEAT_COSMOPOLITAN_APPRAISE              = 1273;
int FEAT_COSMOPOLITAN_TUMBLE                    = 1274;
int FEAT_COSMOPOLITAN_CRAFT_TRAP                = 1275;
int FEAT_COSMOPOLITAN_BLUFF                 = 1276;
int FEAT_COSMOPOLITAN_INTIMIDATE                = 1277;
int FEAT_COSMOPOLITAN_CRAFT_ARMOR               = 1278;
int FEAT_COSMOPOLITAN_CRAFT_WEAPON              = 1279;
int FEAT_COSMOPOLITAN_CRAFT_ALCHEMY             = 1280;
int FEAT_COSMOPOLITAN_RIDE                  = 1281;
int FEAT_COSMOPOLITAN_SURVIVAL              = 1282;
// Note that for the Extra Slot Feats, they go to (MaxLevel - 1)!
int FEAT_EXTRA_SLOT_BARD_LEVEL0             = 1283;
int FEAT_EXTRA_SLOT_BARD_LEVEL1             = 1284;
int FEAT_EXTRA_SLOT_BARD_LEVEL2             = 1285;
int FEAT_EXTRA_SLOT_BARD_LEVEL3             = 1286;
int FEAT_EXTRA_SLOT_BARD_LEVEL4             = 1287;
int FEAT_EXTRA_SLOT_BARD_LEVEL5             = 1288;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL0                       = 1289;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL1                       = 1290;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL2                       = 1291;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL3                       = 1292;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL4                       = 1293;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL5                       = 1294;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL6                       = 1295;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL7                       = 1296;
int FEAT_EXTRA_SLOT_CLERIC_LEVEL8                       = 1297;
int FEAT_EXTRA_SLOT_DRUID_LEVEL0                        = 1298;
int FEAT_EXTRA_SLOT_DRUID_LEVEL1                        = 1299;
int FEAT_EXTRA_SLOT_DRUID_LEVEL2                        = 1300;
int FEAT_EXTRA_SLOT_DRUID_LEVEL3                        = 1301;
int FEAT_EXTRA_SLOT_DRUID_LEVEL4                        = 1302;
int FEAT_EXTRA_SLOT_DRUID_LEVEL5                        = 1303;
int FEAT_EXTRA_SLOT_DRUID_LEVEL6                        = 1304;
int FEAT_EXTRA_SLOT_DRUID_LEVEL7                        = 1305;
int FEAT_EXTRA_SLOT_DRUID_LEVEL8                        = 1306;
int FEAT_EXTRA_SLOT_PALADIN_LEVEL1                      = 1307;
int FEAT_EXTRA_SLOT_PALADIN_LEVEL2                      = 1308;
int FEAT_EXTRA_SLOT_PALADIN_LEVEL3                      = 1309;
int FEAT_EXTRA_SLOT_RANGER_LEVEL1                       = 1310;
int FEAT_EXTRA_SLOT_RANGER_LEVEL2                       = 1311;
int FEAT_EXTRA_SLOT_RANGER_LEVEL3                       = 1312;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL0                     = 1313;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL1                     = 1314;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL2                     = 1315;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL3                     = 1316;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL4                     = 1317;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL5                     = 1318;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL6                     = 1319;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL7                     = 1320;
int FEAT_EXTRA_SLOT_SORCERER_LEVEL8                     = 1321;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL0                       = 1322;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL1                       = 1323;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL2                       = 1324;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL3                       = 1325;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL4                       = 1326;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL5                       = 1327;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL6                       = 1328;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL7                       = 1339;
int FEAT_EXTRA_SLOT_WIZARD_LEVEL8                       = 1330;
// For matching new 3.5 skills:
int FEAT_SKILL_FOCUS_CRAFT_ALCHEMY                      = 1331;
int FEAT_SKILL_FOCUS_RIDE                           = 1332;
int FEAT_SKILL_FOCUS_SURVIVAL                           = 1333;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_ALCHEMY                 = 1334;
int FEAT_EPIC_SKILL_FOCUS_RIDE                      = 1335;
int FEAT_EPIC_SKILL_FOCUS_SURVIVAL                      = 1336;
int FEAT_DASH                                   = 1337;
int FEAT_DIVINE_RESISTANCE                          = 1338;
int FEAT_ELEPHANTS_HIDE                             = 1339;
int FEAT_EXTEND_RAGE                                = 1340;
int FEAT_EXTRA_RAGE                             = 1341;
int FEAT_EXTRA_WILD_SHAPE                           = 1342;
int FEAT_OAKEN_RESILIENCE                           = 1343;
int FEAT_POWER_CRITICAL_CLUB                            = 1344;
int FEAT_POWER_CRITICAL_DAGGER                      = 1345;
int FEAT_POWER_CRITICAL_DART                            = 1346;
int FEAT_POWER_CRITICAL_HEAVYCROSSBOW                   = 1347;
int FEAT_POWER_CRITICAL_LIGHTCROSSBOW                   = 1348;
int FEAT_POWER_CRITICAL_LIGHTMACE                       = 1349;
int FEAT_POWER_CRITICAL_MORNINGSTAR                     = 1350;
int FEAT_POWER_CRITICAL_QUARTERSTAFF                    = 1351;
int FEAT_POWER_CRITICAL_SHORTSPEAR                      = 1352;
int FEAT_POWER_CRITICAL_SICKLE                      = 1353;
int FEAT_POWER_CRITICAL_SLING                           = 1354;
int FEAT_POWER_CRITICAL_UNARMED                     = 1355;
int FEAT_POWER_CRITICAL_LONGBOW                     = 1356;
int FEAT_POWER_CRITICAL_SHORTBOW                        = 1357;
int FEAT_POWER_CRITICAL_SHORTSWORD                      = 1358;
int FEAT_POWER_CRITICAL_RAPIER                      = 1359;
int FEAT_POWER_CRITICAL_SCIMITAR                        = 1360;
int FEAT_POWER_CRITICAL_LONGSWORD                       = 1361;
int FEAT_POWER_CRITICAL_GREATSWORD                      = 1362;
int FEAT_POWER_CRITICAL_HANDAXE                     = 1363;
int FEAT_POWER_CRITICAL_THROWINGAXE                     = 1364;
int FEAT_POWER_CRITICAL_BATTLEAXE                       = 1365;
int FEAT_POWER_CRITICAL_GREATAXE                        = 1366;
int FEAT_POWER_CRITICAL_HALBERD                     = 1367;
int FEAT_POWER_CRITICAL_LIGHTHAMMER                     = 1368;
int FEAT_POWER_CRITICAL_LIGHTFLAIL                      = 1369;
int FEAT_POWER_CRITICAL_WARHAMMER                       = 1370;
int FEAT_POWER_CRITICAL_HEAVYFLAIL                      = 1371;
int FEAT_POWER_CRITICAL_KAMA                            = 1372;
int FEAT_POWER_CRITICAL_KUKRI                           = 1373;
int FEAT_POWER_CRITICAL_SHURIKEN                        = 1374;
int FEAT_POWER_CRITICAL_SCYTHE                      = 1375;
int FEAT_POWER_CRITICAL_KATANA                      = 1376;
int FEAT_POWER_CRITICAL_BASTARDSWORD                    = 1377;
int FEAT_POWER_CRITICAL_DIREMACE                        = 1378;
int FEAT_POWER_CRITICAL_DOUBLEAXE                       = 1379;
int FEAT_POWER_CRITICAL_TWOBLADEDSWORD                  = 1380;
int FEAT_POWER_CRITICAL_DWAXE                           = 1381;
int FEAT_POWER_CRITICAL_WHIP                            = 1382;
int FEAT_POWER_CRITICAL_CREATURE                        = 1383;
int FEAT_SACRED_VENGEANCE                           = 1384;
int FEAT_SELF_SUFFICIENT                            = 1385;
// 3.5 Class Abilities
int FEAT_DAMAGE_REDUCTION5                          = 1386;
int FEAT_TRAP_SENSE_1                               = 1387;
int FEAT_TRAP_SENSE_2                               = 1388;
int FEAT_TRAP_SENSE_3                               = 1389;
int FEAT_TRAP_SENSE_4                               = 1390;
int FEAT_TRAP_SENSE_5                               = 1391;
int FEAT_TRAP_SENSE_6                               = 1392;
int FEAT_SWIFT_TRACKER                              = 1393;
int FEAT_IMPROVED_UNCANNY_DODGE                     = 1394;
int FEAT_HIDE_IN_PLAIN_SIGHT_OUTDOORS                   = 1395;
int FEAT_GREATER_RAGE                               = 1396;
int FEAT_SPECIAL_MOUNT                              = 1397;
int FEAT_INDOMITABLE_WILL                           = 1398;
int FEAT_WILD_EMPATHY                               = 1399;
int FEAT_SMITE_EVIL_2                               = 1400;
int FEAT_SMITE_EVIL_3                               = 1401;
int FEAT_SMITE_EVIL_4                               = 1402;
int FEAT_SMITE_EVIL_5                               = 1403;
int FEAT_REMOVE_DISEASE_2                           = 1404;
int FEAT_REMOVE_DISEASE_3                           = 1405;
int FEAT_REMOVE_DISEASE_4                           = 1406;
int FEAT_REMOVE_DISEASE_5                           = 1407;
//int FEAT_BKGD_FARMER                              = 1408;
//int FEAT_BKGD_TALE_TELLER                         = 1409;
//int FEAT_BKGD_NATURAL_LEADER                      = 1410;
int FEAT_ELDRITCH_BLAST_1                           = 1411;
int FEAT_ELDRITCH_BLAST_2                           = 1412;
int FEAT_ELDRITCH_BLAST_3                           = 1413;
int FEAT_ELDRITCH_BLAST_4                           = 1414;
int FEAT_ELDRITCH_BLAST_5                           = 1415;
int FEAT_ELDRITCH_BLAST_6                           = 1416;
int FEAT_ELDRITCH_BLAST_7                           = 1417;
int FEAT_ELDRITCH_BLAST_8                           = 1418;
int FEAT_ELDRITCH_BLAST_9                           = 1419;
int FEAT_DAMAGE_REDUCTION_COLD_IRON_1                   = 1420;
int FEAT_DAMAGE_REDUCTION_COLD_IRON_2                   = 1421;
int FEAT_DAMAGE_REDUCTION_COLD_IRON_3                   = 1422;
int FEAT_DAMAGE_REDUCTION_COLD_IRON_4                   = 1423;
int FEAT_DAMAGE_REDUCTION_COLD_IRON_5                   = 1424;
int FEAT_DETECT_MAGIC                               = 1425;
int FEAT_DECEIVE_ITEM                               = 1426;
int FEAT_FIENDISH_RESILIENCE_1                      = 1427;
int FEAT_FIENDISH_RESILIENCE_2                      = 1428;
int FEAT_FIENDISH_RESILIENCE_5                      = 1429;
int FEAT_IMBUE_ITEM                             = 1430;
int FEAT_ENHANCED_SPECIAL_MOUNT                     = 1431;
int FEAT_MOUNTED_WPN_BONUS_LANCE_1                      = 1432;
int FEAT_MOUNTED_WPN_BONUS_LANCE_2                      = 1433;
int FEAT_MOUNTED_WPN_BONUS_LANCE_3                      = 1434;
int FEAT_MOUNTED_WPN_BONUS_SWORD_1                      = 1435;
int FEAT_MOUNTED_WPN_BONUS_SWORD_2                      = 1436;
int FEAT_MOUNTED_WPN_BONUS_SWORD_3                      = 1437;
int FEAT_RIDE_BONUS_1                               = 1438;
int FEAT_RIDE_BONUS_2                               = 1439;
int FEAT_RIDE_BONUS_3                               = 1440;
int FEAT_RIDE_BONUS_4                               = 1441;
int FEAT_COURTLY_KNOWLEDGE                          = 1442;
int FEAT_DEADLY_CHARGE                              = 1443;
int FEAT_ENHANCED_MOUNT_SPEED                           = 1444;
int FEAT_FULL_MOUNTED_ATTACK                            = 1445;
int FEAT_UNSTOPPABLE_CHARGE                         = 1446;
int FEAT_FRENZY_1                                   = 1447;
int FEAT_FRENZY_2                                   = 1448;
int FEAT_FRENZY_3                                   = 1449;
int FEAT_FRENZY_4                                   = 1450;
int FEAT_FRENZY_5                                   = 1451;
int FEAT_FRENZY_6                                   = 1452;
int FEAT_FRENZY_7                                   = 1453;
int FEAT_FRENZY_8                                   = 1454;
int FEAT_FRENZY_9                                   = 1455;
int FEAT_FRENZY_10                              = 1456;
int FEAT_SUPREME_CLEAVE                             = 1457;
int FEAT_DEATHLESS_FRENZY                           = 1458;
int FEAT_ENHANCED_POWER_ATTACK                      = 1459;
int FEAT_INSPIRE_FRENZY_1                           = 1460;
int FEAT_INSPIRE_FRENZY_2                           = 1461;
int FEAT_INSPIRE_FRENZY_3                           = 1462;
int FEAT_GREATER_FRENZY                             = 1463;
int FEAT_SUPREME_POWER_ATTACK                           = 1464;
int FEAT_SWIFT_AND_SILENT                           = 1465;
int FEAT_BARDSONG_INSPIRE_COURAGE                       = 1466;
int FEAT_BARDSONG_INSPIRE_COMPETENCE                    = 1467;
int FEAT_BARDSONG_INSPIRE_DEFENSE                       = 1468;
int FEAT_BARDSONG_INSPIRE_REGENERATION                  = 1469;
int FEAT_BARDSONG_INSPIRE_TOUGHNESS                     = 1470;
int FEAT_BARDSONG_INSPIRE_SLOWING                       = 1471;
int FEAT_BARDSONG_INSPIRE_JARRING                       = 1472;
int FEAT_BARDSONG_COUNTERSONG                           = 1473;
int FEAT_BARDSONG_FASCINATE                         = 1474;
int FEAT_BARDSONG_HAVEN_SONG                            = 1475;
int FEAT_BARDSONG_CLOUD_MIND                            = 1476;
int FEAT_BARDSONG_IRONSKIN_CHANT                        = 1477;
int FEAT_BARDSONG_SONG_OF_FREEDOM                       = 1478;
int FEAT_BARDSONG_INSPIRE_HEROICS                       = 1479;
int FEAT_BARDSONG_INSPIRE_LEGION                        = 1480;
int FEAT_BARDSONG_LEAVETAKINGS                      = 1481;
int FEAT_BARDSONG_THE_SPIRIT_OF_THE_WOOD                    = 1482;
int FEAT_BARDSONG_THE_FALL_OF_ZEEAIRE                   = 1483;
int FEAT_BARDSONG_THE_BATTLE_OF_HIGHCLIFF                   = 1484;
int FEAT_BARDSONG_THE_SIEGE_OF_CROSSROAD_KEEP               = 1485;
int FEAT_BARDSONG_A_TALE_OF_HEROES                      = 1486;
int FEAT_BARDSONG_THE_TINKERS_SONG                      = 1487;
int FEAT_BARDSONG_DIRGE_OF_ANCIENT_ILLEFARN             = 1488;
int FEAT_BARDSONG_SONG_OF_AGES                          = 1489;

// AFW-OEI 04/18/2006: Neverwinter Nine Feats
int FEAT_EPITHET_NEVERWINTER_NINE               = 1760;

// AFW-OEI 04/18/2006: Shadow Thief of Amn Feats
int FEAT_EPITHET_SHADOWTHIEFAMN                 = 1771;

// Brock H. - OEI 01/19/06 -- Epithet Feats
int FEAT_EPITHET_AGENT_OF_THE_WOOD              = 1680;
int FEAT_EPITHET_BROTHER_OF_THE_WOOD            = 1681;
int FEAT_EPITHET_SISTER_OF_THE_WOOD             = 1682;
int FEAT_EPITHET_DREAD_LORD_OF_THE_KEEP         = 1683;
int FEAT_EPITHET_EXPLORER                       = 1684;
int FEAT_EPITHET_INFERNAL_BARGAINING            = 1685;
int FEAT_EPITHET_LAWBRINGER                     = 1686;
int FEAT_EPITHET_MASTER_OF_ELEMENTS             = 1687;
int FEAT_EPITHET_MASTER_OF_EARTH                = 1688;
int FEAT_EPITHET_MASTER_OF_AIR                  = 1689;
int FEAT_EPITHET_MASTER_OF_FIRE                 = 1690;
int FEAT_EPITHET_MASTER_OF_WATER                = 1691;
int FEAT_EPITHET_MASTER_OF_THE_SUN_SOUL_1       = 1692;
int FEAT_EPITHET_MASTER_OF_THE_SUN_SOUL_2       = 1693;
int FEAT_EPITHET_PATHSTALKER                    = 1694;
int FEAT_EPITHET_SECRET_OF_THE_WAY_OF_SWORDS    = 1695;
int FEAT_EPITHET_STUDENT_OF_THE_WAY_OF_SWORDS   = 1696;
int FEAT_EPITHET_WARDERN_OF_THE_KEEP            = 1697;
int FEAT_EPITHET_FIRESTARTER                    = 1698;
int FEAT_EPITHET_HARBORMAN                      = 1699;
int FEAT_EPITHET_KALACH_CHA_1                   = 1700;
int FEAT_EPITHET_ORC_SLAYER                     = 1701;
int FEAT_EPITHET_SHADOW_THIEF_RANK_GRUNT        = 1702;
int FEAT_EPITHET_SHADOW_THIEF_RANK_THUG         = 1703;
int FEAT_EPITHET_SHADOW_THIEF_RANK_OPERATIVE    = 1704;
int FEAT_EPITHET_WATCH_RANK_RECRUIT             = 1705;
int FEAT_EPITHET_WATCH_RANK_PATROLMAN           = 1706;
int FEAT_EPITHET_WATCH_RANK_SERGEANT            = 1707;
int FEAT_EPITHET_CAPTAIN_OF_CROSSROAD_KEEP      = 1708;
int FEAT_EPITHET_MASTER_ORATOR                  = 1709;
int FEAT_EPITHET_SQUIRE_OF_NEVERWINTER          = 1710;
int FEAT_EPITHET_BUTCHER_OF_EMBER               = 1711;
int FEAT_EPITHET_WRONGFULLY_ACCUSED             = 1712;
int FEAT_EPITHET_DEFENDER_OF_THE_KEEP           = 1713;
int FEAT_EPITHET_DRAGONSLAYER                   = 1714;
int FEAT_EPITHET_KNIGHT_OF_THE_REALM            = 1715;
int FEAT_EPITHET_MASTER_OF_THE_BROKEN_BLADE     = 1716;


// Brock H. - OEI 01/19/06 -- Character Background feats
// NOTE: Awarding or Removing these feats will NOT give the
// creature a new or different background!
int FEAT_BACKGROUND_BULLY                       = 1717;
int FEAT_BACKGROUND_COMPLEX                     = 1718;
int FEAT_BACKGROUND_DEVOUT                      = 1719;
int FEAT_BACKGROUND_FARMER                      = 1719;
int FEAT_BACKGROUND_LADYS_MAN                   = 1721;
int FEAT_BACKGROUND_THE_FLIRT                   = 1722;
int FEAT_BACKGROUND_MILITIA                     = 1723;
int FEAT_BACKGROUND_NATURAL_LEADER              = 1724;
int FEAT_BACKGROUND_TALE_TELLER                 = 1725;
int FEAT_BACKGROUND_TROUBLE_MAKER               = 1726;
int FEAT_BACKGROUND_WILD_CHILD                  = 1727;
int FEAT_BACKGROUND_WIZARDS_APPRENTICE          = 1728;

// Brock H. - OEI 01/19/06 -- Ranger Combat Style feats
int FEAT_COMBATSTYLE_RANGER_DUAL_WIELD                              = 1729;
int FEAT_COMBATSTYLE_RANGER_ARCHERY                                 = 1730;
int FEAT_COMBATSTYLE_RANGER_ARCHERY_RAPID_SHOT                      = 1731;
int FEAT_COMBATSTYLE_RANGER_ARCHERY_MANY_SHOT                       = 1732;
int FEAT_COMBATSTYLE_RANGER_ARCHERY_IMPROVED_RAPID_SHOT             = 1733;
int FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING          = 1734;
int FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_IMPROVED_TWO_WEAPON_FIGHTING = 1735;
int FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_GREATER_TWO_WEAPON_FIGHTING  = 1736;

// Brock H. - OEI 01/27/06 -- Dualist Prestige Class
int FEAT_CANNY_DEFENSE              = 1737;
int FEAT_ENHANCED_MOBILITY          = 1738;
int FEAT_GRACE                      = 1739;
int FEAT_PRECISE_STRIKE             = 1740;
int FEAT_FLOURISH                   = 1741;
int FEAT_ELABORATE_PARRY            = 1742;
int FEAT_IMPROVED_REACTION          = 1743;

// Brock H. - OEI 02/09/06 -- Ritual of Purification powers
int FEAT_CLEANSING_NOVA             = 1744;
int FEAT_SHINING_SHIELD             = 1745;
int FEAT_SOOTHING_LIGHT             = 1746;
int FEAT_AURORA_CHAIN               = 1747;
int FEAT_WEB_OF_PURITY              = 1775;

// AFW-OEI 04/07/2006: Add pre-order & special edition epithet feats
int FEAT_EPITHET_MERCHANTS_FRIEND       = 1764;
int FEAT_EPITHET_BLESSED_OF_WAUKEEN     = 1765;

// AFW-OEI 04/11/2006
int FEAT_BARBARIAN_RAGE4 = 328; // Greater Rage
int FEAT_BARBARIAN_RAGE7 = 331; // Mighty Rage
int FEAT_TIRELESS_RAGE  = 1769;

int FEAT_IMMUNITY_PHANTASMS = 1752; // AFW-OEI 04/20/2006


// Brock H. - OEI 05/24/06
int FEAT_EPITHET_KALACH_CHA_2   = 1823;
int FEAT_EPITHET_KALACH_CHA_3   = 1824;

int FEAT_TOUCH_OF_ILTKAZAR  = 1856; // AFW-OEI 08/16/2006

int FEAT_IMPROVED_EMPOWER_SPELL =1892;
int FEAT_IMPROVED_MAXIMIZE_SPELL=1893;
int FEAT_IMPROVED_QUICKEN_SPELL =1894;


int FEAT_EPIC_FIENDISH_RESILIENCE_25    = 1929; // AFW-OEI 02/08/2007
int FEAT_EPIC_DIVINE_MIGHT      = 1930; // AFW-OEI 02/08/2007

// AFW-OEI 02/15/2007
int FEAT_ELDRITCH_BLAST_10      = 1948;
int FEAT_ELDRITCH_BLAST_11      = 1949;
int FEAT_ELDRITCH_BLAST_12      = 1950;
int FEAT_ELDRITCH_BLAST_13      = 1951;
int FEAT_ELDRITCH_BLAST_14      = 1952;

int FEAT_EPIC_CHORUS_OF_HEROISM     = 1956; // AFW-OEI 02/20/2007

int FEAT_EPIC_ELDRITCH_MASTER       = 1958; // AFW-OEI 02/20/2007

// AFW-OEI 02/21/2007
int FEAT_EPIC_ELDRITCH_BLAST_1      = 1960;
int FEAT_EPIC_ELDRITCH_BLAST_2      = 1961;
int FEAT_EPIC_ELDRITCH_BLAST_3      = 1962;
int FEAT_EPIC_ELDRITCH_BLAST_4      = 1963;
int FEAT_EPIC_ELDRITCH_BLAST_5      = 1964;
int FEAT_EPIC_ELDRITCH_BLAST_6      = 1965;
int FEAT_EPIC_ELDRITCH_BLAST_7      = 1966;
int FEAT_EPIC_ELDRITCH_BLAST_8      = 1967;
int FEAT_EPIC_ELDRITCH_BLAST_9      = 1968;
int FEAT_EPIC_ELDRITCH_BLAST_10     = 1969;

int FEAT_EPIC_HYMN_OF_REQUIEM       = 1989; // AFW-OEI 02/23/2007

int FEAT_CHASTISE_SPIRITS       = 2017; // AFW-OEI 03/19/2007

// AFW-OEI 03/22/2007: Stormlord
int FEAT_STORMLORD_SHOCK_WEAPON         = 2046;
int FEAT_STORMLORD_SONIC_WEAPON         = 2047;
int FEAT_STORMLORD_SHOCKING_BURST_WEAPON    = 2048;

// ChazM 4/4/07 Spirit Eater Feats
int FEAT_DEVOUR_SPIRIT_1      =1976;
int FEAT_DEVOUR_SPIRIT_2      =1977;
int FEAT_DEVOUR_SPIRIT_3      =1978;
int FEAT_DEVOUR_SOUL          =1979;
int FEAT_SPIRIT_GORGE         =1980;
int FEAT_RAVENOUS_INCARNATION =1981;
int FEAT_BESTOW_LIFE_FORCE    =1982;
int FEAT_SUPPRESS             =1983;
int FEAT_ETERNAL_REST         =1984;
int FEAT_SATIATE              =1985;
int FEAT_MOLD_SPIRIT          =1986;

int FEAT_FAVORED_OF_THE_SPIRITS = 2029;     // AFW-OEI 07/16/2007

int FEAT_MALLEATE_SPIRIT      =2050;
int FEAT_SPIRITUAL_EVISCERATION =2104;
int FEAT_PROVOKE_SPIRITS        =2125;

int FEAT_ICE_TROLL_BERSERKER = 2127;    // AFW-OEI 06/25/2007

int FEAT_DREAM_HAUNTING         = 2134;     // AFW-OEI 07/14/2007
int FEAT_DROWNED_AURA           = 2136;


int FEAT_KELEMVORS_BOON         = 2152; // JWR-OEI 05/17/08
int FEAT_DIVINE_VENGEANCE       = 2153;
int FEAT_EMPOWER_TURNING        = 2154; // JWR-OEI 05/22/08
int FEAT_IMPROVED_TURNING       = 2155; // JWR-OEI 05/22/08
int FEAT_DOOMGUIDE_SAVE_1       = 2156;
int FEAT_DOOMGUIDE_SAVE_2       = 2157;
int FEAT_ETHEREAL_PURGE         = 2159;
int FEAT_KELEMVORS_GRACE        = 2158;
int FEAT_BOND_OF_FATAL_TOUCH    = 2160;
int FEAT_EXTRA_TURNING_2        = 2161;
int FEAT_EXTRA_TURNING_3        = 2162;
// JWR-OEI:: Hellfire Warlock Stuff 06.17.2008
int FEAT_HELLFIRE_RESIST_FIRE   = 2163;
int FEAT_HELLFIRE_WARLOCK_INVOKING = 2164;
int FEAT_HELLFIRE_SHIELD        = 2165;
int FEAT_HELLFIRE_BLAST         = 2166;
int FEAT_SUMMON_BAATEZU         = 2167;

int FEAT_DINOSAUR_COMPANION     = 2168;
int FEAT_INDOMITABLE_SOUL       = 2169;
int FEAT_STEADFAST_DETERMINATION= 2170;
int FEAT_SPELL_RESISTANCE       = 2171;
int FEAT_ANIMAL_TRANCE          = 2172;
int FEAT_CAUSE_FEAR             = 2173;
int FEAT_CHARM_PERSON           = 2174;
int FEAT_RACIAL_DARKNESS        = 2175;
int FEAT_RACIAL_ENTANGLE        = 2176;
int FEAT_WEAPON_PROFICIENCY_GRAYORC = 2177;
int FEAT_SCENT                  = 2178;

int FEAT_FEY_HERITAGE           = 2180;
int FEAT_FEY_LEGACY             = 2181;
int FEAT_FEY_POWER              = 2182;
int FEAT_FEY_PRESENCE           = 2183;
int FEAT_FEY_SKIN               = 2184;
int FEAT_FIENDISH_HERITAGE      = 2185;
int FEAT_FIENDISH_LEGACY        = 2186;
int FEAT_FIENDISH_POWER         = 2187;
int FEAT_FIENDISH_PRESENCE      = 2188;
int FEAT_FIENDISH_RESISTANCE    = 2189;

// TEAMWORK BENEFIT FEATS
int FEAT_TW_AWARENESS           = 2191;
int FEAT_TW_CAMP_ROUTINE        = 2192;
int FEAT_TW_IMPROVED_CAMP_ROUTINE = 2193;
int FEAT_TW_CIRCLE_OF_BLADES    = 2194;
int FEAT_TW_FEARSOME_ROSTER     = 2195;
int FEAT_TW_IMPROVED_FEARSOME_ROSTER = 2196;
int FEAT_TW_FOE_HUNTING         = 2197;
int FEAT_TW_GROUP_TRANCE        = 2198;
int FEAT_TW_MISSILE_VOLLEYS     = 2199;
int FEAT_TW_STEADFAST_RESOLVE   = 2200;
int FEAT_TW_SUPERIOR_FLANK      = 2201;
int FEAT_TW_TEAM_RUSH           = 2202;
int FEAT_LEADERSHIP                     =           2203;
int FEAT_EPITHET_NEGATIVE_AURA_LESSER   =           2204;
int FEAT_EPITHET_NEGATIVE_AURA          =           2205;
int FEAT_EPITHET_NEGATIVE_GREATER       =           2206;
int FEAT_DAYLIGHT_ADAPATION             =           2207;
int FEAT_EPITHET_RESEARCHER             =           2208;
int FEAT_EPITHET_MASTER_RESEARCHER      =           2209;
int FEAT_EPITHET_TOURIST                =           2210;
int FEAT_EPITHET_WANDERER               =           2211;
int FEAT_EPITHET_WAYFARER               =           2212;
int FEAT_EPITHET_PATHWALKER             =           2213;
int FEAT_EPITHET_TRAVELER               =           2214;
int FEAT_EPITHET_NOMAD                  =           2215;
int FEAT_EPITHET_JOURNEYMAN             =           2216;
int FEAT_EPITHET_MASTER_GUIDE           =           2217;
int FEAT_EPITHET_FAV_OF_THE_ROAD        =           2218;
int FEAT_EPITHET_BANE_OF_THE_BANITES    =           2219;
int FEAT_EPITHET_BANE_OF_THE_BATIRI     =           2220;
int FEAT_EPITHET_BREATH_FATED           =           2221;
int FEAT_EPITHET_DARK_KNIGHT            =           2222;
int FEAT_EPITHET_DEMON_OF_THE_ROADS     =           2223;
int FEAT_EPITHET_DRAGON_SLAYER          =           2224;
int FEAT_EPITHET_FORGOTTEN_LORD         =           2225;
int FEAT_EPITHET_FRIEND_OF_FRIENDS      =           2226;
int FEAT_EPITHET_GOLDENHANDS            =           2227;
int FEAT_EPITHET_HERO_HIDDEN_KNGDM      =           2228;
int FEAT_EPITHET_LAST_PORT_COMMAND      =           2229;
int FEAT_EPITHET_MASTER_INFILTRATOR     =           2230;
int FEAT_EPITHET_NEVERWINTER_PATRIOT    =           2231;
int FEAT_EPITHET_PROTECTOR              =           2232;
int FEAT_EPITHET_RENEGADE_HDDN_KNGDM    =           2233;
int FEAT_EPITHET_SERPENTS_BANE          =           2234;
int FEAT_EPITHET_SLAYER_OF_SHARRANS     =           2235;
int FEAT_EPITHET_SURVIVOR               =           2236;
int FEAT_EPITHET_VILLAIN_MERE           =           2237;
int FEAT_EPITHET_WANTED                 =           2238;
int FEAT_EPITHET_YELLOW_DRAGON          =           2239;
int FEAT_EPITHET_COBRA_COMMANDER        =           2240;
// JWR-OEI 08/20/2008
int FEAT_BACKGROUND_APPRAISER           =           2241;
int FEAT_BACKGROUND_CONFIDANT           =           2242;
int FEAT_BACKGROUND_FOREIGNER           =           2243;
int FEAT_BACKGROUND_SAVVY               =           2244;
int FEAT_BACKGROUND_SURVIVOR            =           2245;
int FEAT_BACKGROUND_TALENT              =           2246;
int FEAT_BACKGROUND_VETERAN             =           2247;





// Character Backgrounds
int BACKGROUND_NONE             = 0;
int BACKGROUND_BULLY            = 1;
int BACKGROUND_COMPLEX          = 2;
int BACKGROUND_DEVOUT           = 3;
int BACKGROUND_FARMER           = 4;
int BACKGROUND_LADYSMAN         = 5;
int BACKGROUND_THEFLIRT         = 6;
int BACKGROUND_MILITIA          = 7;
int BACKGROUND_NATURALLEADER    = 8;
int BACKGROUND_TALETELLER       = 9;
int BACKGROUND_TROUBLEMAKER     = 10;
int BACKGROUND_WILDCHILD        = 11;
int BACKGROUND_WIZARDSAPPRENTICE    = 12;



// Special Attack Defines
int SPECIAL_ATTACK_INVALID              =   0;
int SPECIAL_ATTACK_CALLED_SHOT_LEG      =   1;
int SPECIAL_ATTACK_CALLED_SHOT_ARM      =   2;
int SPECIAL_ATTACK_SAP                  =   3;
int SPECIAL_ATTACK_DISARM               =   4;
int SPECIAL_ATTACK_IMPROVED_DISARM      =   5;
int SPECIAL_ATTACK_KNOCKDOWN            =   6;
int SPECIAL_ATTACK_IMPROVED_KNOCKDOWN   =   7;
int SPECIAL_ATTACK_STUNNING_FIST        =   8;
int SPECIAL_ATTACK_FLURRY_OF_BLOWS      =   9;
int SPECIAL_ATTACK_RAPID_SHOT           =   10;

// Combat Mode Defines
int COMBAT_MODE_INVALID                 = 0;
int COMBAT_MODE_PARRY                   = 1;
int COMBAT_MODE_POWER_ATTACK            = 2;
int COMBAT_MODE_IMPROVED_POWER_ATTACK   = 3;
int COMBAT_MODE_FLURRY_OF_BLOWS         = 4;
int COMBAT_MODE_RAPID_SHOT              = 5;
int COMBAT_MODE_COMBAT_EXPERTISE               = 6;
int COMBAT_MODE_IMPROVED_COMBAT_EXPERTISE      = 7;
int COMBAT_MODE_DEFENSIVE_CASTING       = 8;
int COMBAT_MODE_DIRTY_FIGHTING          = 9;
int COMBAT_MODE_DEFENSIVE_STANCE        = 10;

// These represent the row in the difficulty 2da, rather than
// a difficulty value.
int ENCOUNTER_DIFFICULTY_VERY_EASY  = 0;
int ENCOUNTER_DIFFICULTY_EASY       = 1;
int ENCOUNTER_DIFFICULTY_NORMAL     = 2;
int ENCOUNTER_DIFFICULTY_HARD       = 3;
int ENCOUNTER_DIFFICULTY_IMPOSSIBLE = 4;

// Looping animation constants.
int ANIMATION_LOOPING_PAUSE                    = 0;
int ANIMATION_LOOPING_PAUSE2                   = 1;
int ANIMATION_LOOPING_LISTEN                   = 2;
int ANIMATION_LOOPING_MEDITATE                 = 3;
int ANIMATION_LOOPING_WORSHIP                  = 4;
int ANIMATION_LOOPING_LOOK_FAR                 = 5;
int ANIMATION_LOOPING_SIT_CHAIR                = 6;
int ANIMATION_LOOPING_SIT_CROSS                = 7;
int ANIMATION_LOOPING_TALK_NORMAL              = 8;
int ANIMATION_LOOPING_TALK_PLEADING            = 9;
int ANIMATION_LOOPING_TALK_FORCEFUL            = 10;
int ANIMATION_LOOPING_TALK_LAUGHING            = 11;
int ANIMATION_LOOPING_GET_LOW                  = 12;
int ANIMATION_LOOPING_GET_MID                  = 13;
int ANIMATION_LOOPING_PAUSE_TIRED              = 14;
int ANIMATION_LOOPING_PAUSE_DRUNK              = 15;
int ANIMATION_LOOPING_DEAD_FRONT               = 16;
int ANIMATION_LOOPING_DEAD_BACK                = 17;
int ANIMATION_LOOPING_CONJURE1                 = 18;
int ANIMATION_LOOPING_CONJURE2                 = 19;
int ANIMATION_LOOPING_SPASM                    = 20;
int ANIMATION_LOOPING_CUSTOM1                  = 21;
int ANIMATION_LOOPING_CUSTOM2                  = 22;
int ANIMATION_LOOPING_CAST1                    = 23;
// FAK - OEI added for NWN2
int ANIMATION_LOOPING_PRONE                    = 24;
int ANIMATION_LOOPING_KNEELIDLE                = 25;
int ANIMATION_LOOPING_DANCE01                  = 26;
int ANIMATION_LOOPING_DANCE02                  = 27;
int ANIMATION_LOOPING_DANCE03                  = 28;
int ANIMATION_LOOPING_GUITARPLAY               = 29;
int ANIMATION_LOOPING_GUITARIDLE               = 30;
int ANIMATION_LOOPING_FLUTEPLAY                = 31;
int ANIMATION_LOOPING_FLUTEIDLE                = 32;
int ANIMATION_LOOPING_DRUMPLAY                 = 33;
int ANIMATION_LOOPING_DRUMIDLE                 = 34;
int ANIMATION_LOOPING_COOK01                   = 35;
int ANIMATION_LOOPING_COOK02                   = 36;
int ANIMATION_LOOPING_CRAFT01                  = 37;
int ANIMATION_LOOPING_FORGE01                  = 38;
int ANIMATION_LOOPING_BOXCARRY                 = 39;
int ANIMATION_LOOPING_BOXIDLE                  = 40;
int ANIMATION_LOOPING_BOXHURRIED               = 41;
int ANIMATION_LOOPING_LOOKDOWN                 = 42;
int ANIMATION_LOOPING_LOOKUP                   = 43;
int ANIMATION_LOOPING_LOOKLEFT                 = 44;
int ANIMATION_LOOPING_LOOKRIGHT                = 45;
int ANIMATION_LOOPING_SHOVELING                = 46;
int ANIMATION_LOOPING_INJURED                  = 47;


// Fire and forget animation constants.
int ANIMATION_FIREFORGET_HEAD_TURN_LEFT        = 100;
int ANIMATION_FIREFORGET_HEAD_TURN_RIGHT       = 101;
int ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD    = 102;
int ANIMATION_FIREFORGET_PAUSE_BORED           = 103;
int ANIMATION_FIREFORGET_SALUTE                = 104;
int ANIMATION_FIREFORGET_BOW                   = 105;
int ANIMATION_FIREFORGET_STEAL                 = 106;
int ANIMATION_FIREFORGET_GREETING              = 107;
int ANIMATION_FIREFORGET_TAUNT                 = 108;
int ANIMATION_FIREFORGET_VICTORY1              = 109;
int ANIMATION_FIREFORGET_VICTORY2              = 110;
int ANIMATION_FIREFORGET_VICTORY3              = 111;
int ANIMATION_FIREFORGET_READ                  = 112;
int ANIMATION_FIREFORGET_DRINK                 = 113;
int ANIMATION_FIREFORGET_DODGE_SIDE            = 114;
int ANIMATION_FIREFORGET_DODGE_DUCK            = 115;
int ANIMATION_FIREFORGET_SPASM                 = 116;
// FAK - OEI NWN2 Specific Animations
int ANIMATION_FIREFORGET_COLLAPSE              = 117;
int ANIMATION_FIREFORGET_LAYDOWN               = 118;
int ANIMATION_FIREFORGET_STANDUP               = 119;
int ANIMATION_FIREFORGET_ACTIVATE              = 120;
int ANIMATION_FIREFORGET_USEITEM               = 121;
int ANIMATION_FIREFORGET_KNEELFIDGET           = 122;
int ANIMATION_FIREFORGET_KNEELTALK             = 123;
int ANIMATION_FIREFORGET_KNEELDAMAGE           = 124;
int ANIMATION_FIREFORGET_KNEELDEATH            = 125;
int ANIMATION_FIREFORGET_BARDSONG              = 126;
int ANIMATION_FIREFORGET_GUITARIDLEFIDGET      = 127;
int ANIMATION_FIREFORGET_FLUTEIDLEFIDGET       = 128;
int ANIMATION_FIREFORGET_DRUMIDLEFIDGET        = 129;
int ANIMATION_FIREFORGET_WILDSHAPE             = 130;
int ANIMATION_FIREFORGET_SEARCH                = 131;
int ANIMATION_FIREFORGET_INTIMIDATE            = 132;
int ANIMATION_FIREFORGET_CHUCKLE               = 133;

// Placeable animation constants
int ANIMATION_PLACEABLE_ACTIVATE               = 200;
int ANIMATION_PLACEABLE_DEACTIVATE             = 201;
int ANIMATION_PLACEABLE_OPEN                   = 202;
int ANIMATION_PLACEABLE_CLOSE                  = 203;

int TALENT_TYPE_SPELL      = 0;
int TALENT_TYPE_FEAT       = 1;
int TALENT_TYPE_SKILL      = 2;

// These must match the values in nwscreature.h and nwccreaturemenu.cpp
// Cannot use the value -1 because that is used to start a conversation
int ASSOCIATE_COMMAND_STANDGROUND             = -2;
int ASSOCIATE_COMMAND_ATTACKNEAREST           = -3;
int ASSOCIATE_COMMAND_HEALMASTER              = -4;
int ASSOCIATE_COMMAND_FOLLOWMASTER            = -5;
int ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK    = -6;
int ASSOCIATE_COMMAND_GUARDMASTER             = -7;
int ASSOCIATE_COMMAND_UNSUMMONFAMILIAR        = -8;
int ASSOCIATE_COMMAND_UNSUMMONANIMALCOMPANION = -9;
int ASSOCIATE_COMMAND_UNSUMMONSUMMONED        = -10;
int ASSOCIATE_COMMAND_MASTERUNDERATTACK       = -11;
int ASSOCIATE_COMMAND_RELEASEDOMINATION       = -12;
int ASSOCIATE_COMMAND_UNPOSSESSFAMILIAR       = -13;
int ASSOCIATE_COMMAND_MASTERSAWTRAP           = -14;
int ASSOCIATE_COMMAND_MASTERATTACKEDOTHER     = -15;
int ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED = -16;
int ASSOCIATE_COMMAND_LEAVEPARTY              = -17;
int ASSOCIATE_COMMAND_PICKLOCK                = -18;
int ASSOCIATE_COMMAND_INVENTORY               = -19;
int ASSOCIATE_COMMAND_DISARMTRAP              = -20;
int ASSOCIATE_COMMAND_TOGGLECASTING           = -21;
int ASSOCIATE_COMMAND_TOGGLESTEALTH           = -22;
int ASSOCIATE_COMMAND_TOGGLESEARCH            = -23;
int ASSOCIATE_COMMAND_MOVETOMASTER        = -24;

// These match the values in nwscreature.h
int ASSOCIATE_TYPE_NONE             = 0;
int ASSOCIATE_TYPE_HENCHMAN         = 1;
int ASSOCIATE_TYPE_ANIMALCOMPANION  = 2;
int ASSOCIATE_TYPE_FAMILIAR         = 3;
int ASSOCIATE_TYPE_SUMMONED         = 4;
int ASSOCIATE_TYPE_DOMINATED        = 5;

// These must match the list in nwscreaturestats.cpp
int TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT   = 1;
int TALENT_CATEGORY_HARMFUL_RANGED                    = 2;
int TALENT_CATEGORY_HARMFUL_TOUCH                     = 3;
int TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT     = 4;
int TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH          = 5;
int TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT = 6;
int TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE     = 7;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT = 8;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE     = 9;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF       = 10;
int TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT = 11;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF        = 12;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE      = 13;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT  = 14;
int TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES          = 15;
int TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT         = 16;
int TALENT_CATEGORY_BENEFICIAL_HEALING_POTION         = 17;
int TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION     = 18;
int TALENT_CATEGORY_DRAGONS_BREATH                    = 19;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION      = 20;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION     = 21;
int TALENT_CATEGORY_HARMFUL_MELEE                     = 22;
int TALENT_CATEGORY_DISPEL                            = 23;
int TALENT_CATEGORY_SPELLBREACH                       = 24;
int TALENT_CATEGORY_CANTRIP                           = 25;


int INVENTORY_DISTURB_TYPE_ADDED    = 0;
int INVENTORY_DISTURB_TYPE_REMOVED  = 1;
int INVENTORY_DISTURB_TYPE_STOLEN   = 2;

int GUI_PANEL_PLAYER_DEATH = 0;

int VOICE_CHAT_ATTACK           =   0;
int VOICE_CHAT_BATTLECRY1       =   1;
int VOICE_CHAT_BATTLECRY2       =   2;
int VOICE_CHAT_BATTLECRY3       =   3;
int VOICE_CHAT_HEALME           =   4;
int VOICE_CHAT_HELP             =   5;
int VOICE_CHAT_ENEMIES          =   6;
int VOICE_CHAT_FLEE             =   7;
int VOICE_CHAT_TAUNT            =   8;
int VOICE_CHAT_GUARDME          =   9;
int VOICE_CHAT_HOLD             =   10;
int VOICE_CHAT_GATTACK1         =   11;
int VOICE_CHAT_GATTACK2         =   12;
int VOICE_CHAT_GATTACK3         =   13;
int VOICE_CHAT_PAIN1            =   14;
int VOICE_CHAT_PAIN2            =   15;
int VOICE_CHAT_PAIN3            =   16;
int VOICE_CHAT_NEARDEATH        =   17;
int VOICE_CHAT_DEATH            =   18;
int VOICE_CHAT_POISONED         =   19;
int VOICE_CHAT_SPELLFAILED      =   20;
int VOICE_CHAT_WEAPONSUCKS      =   21;
int VOICE_CHAT_FOLLOWME         =   22;
int VOICE_CHAT_LOOKHERE         =   23;
int VOICE_CHAT_GROUP            =   24;
int VOICE_CHAT_MOVEOVER         =   25;
int VOICE_CHAT_PICKLOCK         =   26;
int VOICE_CHAT_SEARCH           =   27;
int VOICE_CHAT_HIDE             =   28;
int VOICE_CHAT_CANDO            =   29;
int VOICE_CHAT_CANTDO           =   30;
int VOICE_CHAT_TASKCOMPLETE     =   31;
int VOICE_CHAT_ENCUMBERED       =   32;
int VOICE_CHAT_SELECTED         =   33;
int VOICE_CHAT_HELLO            =   34;
int VOICE_CHAT_YES              =   35;
int VOICE_CHAT_NO               =   36;
int VOICE_CHAT_STOP             =   37;
int VOICE_CHAT_REST             =   38;
int VOICE_CHAT_BORED            =   39;
int VOICE_CHAT_GOODBYE          =   40;
int VOICE_CHAT_THANKS           =   41;
int VOICE_CHAT_LAUGH            =   42;
int VOICE_CHAT_CUSS             =   43;
int VOICE_CHAT_CHEER            =   44;
int VOICE_CHAT_TALKTOME         =   45;
int VOICE_CHAT_GOODIDEA         =   46;
int VOICE_CHAT_BADIDEA          =   47;
int VOICE_CHAT_THREATEN         =   48;

int POLYMORPH_TYPE_WEREWOLF              = 0;
int POLYMORPH_TYPE_WERERAT               = 1;
int POLYMORPH_TYPE_WERECAT               = 2;
int POLYMORPH_TYPE_GIANT_SPIDER          = 3;
int POLYMORPH_TYPE_TROLL                 = 4;
int POLYMORPH_TYPE_UMBER_HULK            = 5;
int POLYMORPH_TYPE_PIXIE                 = 6;
int POLYMORPH_TYPE_ZOMBIE                = 7;
int POLYMORPH_TYPE_RED_DRAGON            = 8;
int POLYMORPH_TYPE_FIRE_GIANT            = 9;
int POLYMORPH_TYPE_BALOR                 = 10;
int POLYMORPH_TYPE_DEATH_SLAAD           = 11;
int POLYMORPH_TYPE_IRON_GOLEM            = 12;
int POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL   = 13;
int POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL  = 14;
int POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL  = 15;
int POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL    = 16;
int POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL  = 17;
int POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL = 18;
int POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL = 19;
int POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL   = 20;
int POLYMORPH_TYPE_BROWN_BEAR            = 21;
int POLYMORPH_TYPE_PANTHER               = 22;
int POLYMORPH_TYPE_WOLF                  = 23;
int POLYMORPH_TYPE_BOAR                  = 24;
int POLYMORPH_TYPE_BADGER                = 25;
int POLYMORPH_TYPE_PENGUIN               = 26;
int POLYMORPH_TYPE_COW                   = 27;
int POLYMORPH_TYPE_DOOM_KNIGHT           = 28;
int POLYMORPH_TYPE_YUANTI                = 29;
int POLYMORPH_TYPE_IMP                   = 30;
int POLYMORPH_TYPE_QUASIT                = 31;
int POLYMORPH_TYPE_SUCCUBUS              = 32;
int POLYMORPH_TYPE_DIRE_BROWN_BEAR       = 33;
int POLYMORPH_TYPE_DIRE_PANTHER          = 34;
int POLYMORPH_TYPE_DIRE_WOLF             = 35;
int POLYMORPH_TYPE_DIRE_BOAR             = 36;
int POLYMORPH_TYPE_DIRE_BADGER           = 37;
int POLYMORPH_TYPE_CELESTIAL_AVENGER     = 38;
int POLYMORPH_TYPE_VROCK                 = 39;
int POLYMORPH_TYPE_CHICKEN               = 40;
int POLYMORPH_TYPE_FROST_GIANT_MALE      = 41;
int POLYMORPH_TYPE_FROST_GIANT_FEMALE    = 42;
int POLYMORPH_TYPE_HEURODIS              = 43;
int POLYMORPH_TYPE_JNAH_GIANT_MALE       = 44;
int POLYMORPH_TYPE_JNAH_GIANT_FEMAL      = 45;
int POLYMORPH_TYPE_CELESTIAL_LEOPARD     = 46;  // AFW-OEI 06/06/2007
int POLYMORPH_TYPE_WINTER_WOLF       = 47;  // AFW-OEI 06/06/2007
int POLYMORPH_TYPE_PHASE_SPIDER      = 48;  // AFW-OEI 06/06/2007
int POLYMORPH_TYPE_WYRMLING_WHITE        = 52;
int POLYMORPH_TYPE_WYRMLING_BLUE         = 53;
int POLYMORPH_TYPE_WYRMLING_RED          = 54;
int POLYMORPH_TYPE_WYRMLING_GREEN        = 55;
int POLYMORPH_TYPE_WYRMLING_BLACK        = 56;
int POLYMORPH_TYPE_GOLEM_AUTOMATON       = 57;
int POLYMORPH_TYPE_MANTICORE             = 58;
int POLYMORPH_TYPE_MALE_DROW             = 59;
int POLYMORPH_TYPE_HARPY             = 60;
int POLYMORPH_TYPE_BASILISK          = 61;
int POLYMORPH_TYPE_DRIDER            = 62;
int POLYMORPH_TYPE_BEHOLDER          = 63;
int POLYMORPH_TYPE_MEDUSA            = 64;
int POLYMORPH_TYPE_GARGOYLE          = 65;
int POLYMORPH_TYPE_MINOTAUR              = 66;
int POLYMORPH_TYPE_SUPER_CHICKEN         = 67;
int POLYMORPH_TYPE_MINDFLAYER            = 68;
int POLYMORPH_TYPE_DIRETIGER             = 69;
int POLYMORPH_TYPE_FEMALE_DROW           = 70;
int POLYMORPH_TYPE_ANCIENT_BLUE_DRAGON   = 71;
int POLYMORPH_TYPE_ANCIENT_RED_DRAGON    = 72;
int POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON  = 73;
int POLYMORPH_TYPE_VAMPIRE_MALE          = 74;
int POLYMORPH_TYPE_RISEN_LORD            = 75;
int POLYMORPH_TYPE_SPECTRE               = 76;
int POLYMORPH_TYPE_VAMPIRE_FEMALE        = 77;
int POLYMORPH_TYPE_NULL_HUMAN            = 78;
int POLYMORPH_TYPE_DIRE_RAT      = 107;
int POLYMORPH_TYPE_HORNED_DEVIL      = 108;
int POLYMORPH_TYPE_NIGHTWALKER       = 109;
int POLYMORPH_TYPE_SWORD_SPIDER      = 110;
int POLYMORPH_TYPE_RAVENOUS_INCARNATION  = 111; // AFW-OEI 05/04/2007
int POLYMORPH_TYPE_SHAMBLING_MOUND   = 112; // AFW-OEI 05/04/2007
int POLYMORPH_TYPE_TREANT        = 113; // AFW-OEI 05/04/2007
int POLYMORPH_TYPE_BLUE_DRAGON       = 114; // AFW-OEI 06/25/2007
int POLYMORPH_TYPE_BLACK_DRAGON      = 115; // AFW-OEI 06/25/2007

int INVISIBILITY_TYPE_NORMAL   = 1;
int INVISIBILITY_TYPE_DARKNESS = 2;
int INVISIBILITY_TYPE_IMPROVED = 4;

int CREATURE_SIZE_INVALID = 0;
int CREATURE_SIZE_TINY =    1;
int CREATURE_SIZE_SMALL =   2;
int CREATURE_SIZE_MEDIUM =  3;
int CREATURE_SIZE_LARGE =   4;
int CREATURE_SIZE_HUGE =    5;

int SPELL_SCHOOL_GENERAL        = 0;
int SPELL_SCHOOL_ABJURATION     = 1;
int SPELL_SCHOOL_CONJURATION    = 2;
int SPELL_SCHOOL_DIVINATION     = 3;
int SPELL_SCHOOL_ENCHANTMENT    = 4;
int SPELL_SCHOOL_EVOCATION      = 5;
int SPELL_SCHOOL_ILLUSION       = 6;
int SPELL_SCHOOL_NECROMANCY     = 7;
int SPELL_SCHOOL_TRANSMUTATION  = 8;

int ANIMAL_COMPANION_CREATURE_TYPE_BADGER   = 0;
int ANIMAL_COMPANION_CREATURE_TYPE_WOLF     = 1;
int ANIMAL_COMPANION_CREATURE_TYPE_BEAR     = 2;
int ANIMAL_COMPANION_CREATURE_TYPE_BOAR     = 3;
int ANIMAL_COMPANION_CREATURE_TYPE_HAWK     = 4;
int ANIMAL_COMPANION_CREATURE_TYPE_PANTHER  = 5;
int ANIMAL_COMPANION_CREATURE_TYPE_SPIDER   = 6;
int ANIMAL_COMPANION_CREATURE_TYPE_DIREWOLF = 7;
int ANIMAL_COMPANION_CREATURE_TYPE_DIRERAT  = 8;
int ANIMAL_COMPANION_CREATURE_TYPE_NONE     = 255;

int FAMILIAR_CREATURE_TYPE_BAT        = 0;
int FAMILIAR_CREATURE_TYPE_CRAGCAT    = 1;
int FAMILIAR_CREATURE_TYPE_HELLHOUND  = 2;
int FAMILIAR_CREATURE_TYPE_IMP        = 3;
int FAMILIAR_CREATURE_TYPE_FIREMEPHIT = 4;
int FAMILIAR_CREATURE_TYPE_ICEMEPHIT  = 5;
int FAMILIAR_CREATURE_TYPE_PIXIE      = 6;
int FAMILIAR_CREATURE_TYPE_RAVEN           = 7;
int FAMILIAR_CREATURE_TYPE_FAIRY_DRAGON    = 8;
int FAMILIAR_CREATURE_TYPE_PSEUDO_DRAGON    = 9;
int FAMILIAR_CREATURE_TYPE_EYEBALL          = 10;
int FAMILIAR_CREATURE_TYPE_NONE       = 255;

int CAMERA_MODE_CHASE_CAMERA          = 0;
int CAMERA_MODE_TOP_DOWN              = 1;
int CAMERA_MODE_STIFF_CHASE_CAMERA    = 2;

// JAB-OEI - Changed WEATHER_* to WEATHER_TYPE_*
int WEATHER_TYPE_INVALID     = -1;
int WEATHER_TYPE_RAIN        = 0;
int WEATHER_TYPE_SNOW        = 1;
int WEATHER_TYPE_LIGHTNING   = 2;

// JAB-OEI - Added Weather Power Settings
int WEATHER_POWER_INVALID = -1;
int WEATHER_POWER_OFF    = 0;
int WEATHER_POWER_WEAK   = 1;
int WEATHER_POWER_LIGHT  = 2;
int WEATHER_POWER_MEDIUM = 3;
int WEATHER_POWER_HEAVY  = 4;
int WEATHER_POWER_STORMY = 5;
int WEATHER_POWER_USE_AREA_SETTINGS = -1;

// JAB-OEI Fog Settings. Obsolete.
int  FOG_TYPE_SUN       = 0;
int  FOG_TYPE_MOON      = 1;
int  FOG_TYPE_BOTH      = 2;

// OEI - ELN. New fog stages. Use these with SetNWN2Fog/ResetNWN2Fog.
int FOG_TYPE_NWN2_SUNRISE = 0;
int FOG_TYPE_NWN2_DAYTIME = 1;
int FOG_TYPE_NWN2_SUNSET = 2;
int FOG_TYPE_NWN2_MOONRISE = 3;
int FOG_TYPE_NWN2_NIGHTTIME = 4;
int FOG_TYPE_NWN2_MOONSET = 5;

int  FOG_COLOR_RED              = 16711680;
int  FOG_COLOR_RED_DARK         = 6684672;
int  FOG_COLOR_GREEN            = 65280;
int  FOG_COLOR_GREEN_DARK       = 23112;
int  FOG_COLOR_BLUE             = 255;
int  FOG_COLOR_BLUE_DARK        = 102;
int  FOG_COLOR_BLACK            = 0;
int  FOG_COLOR_WHITE            = 16777215;
int  FOG_COLOR_GREY             = 10066329;
int  FOG_COLOR_YELLOW           = 16776960;
int  FOG_COLOR_YELLOW_DARK      = 11184640;
int  FOG_COLOR_CYAN             = 65535;
int  FOG_COLOR_MAGENTA          = 16711935;
int  FOG_COLOR_ORANGE           = 16750848;
int  FOG_COLOR_ORANGE_DARK      = 13395456;
int  FOG_COLOR_BROWN            = 10053120;
int  FOG_COLOR_BROWN_DARK       = 6697728;

// EPF - OEI 1/24/06 -- adding these so people don't end up using
// fog color constants for things like fade colors.
int  COLOR_RED              = 16711680;
int  COLOR_RED_DARK         = 6684672;
int  COLOR_GREEN            = 65280;
int  COLOR_GREEN_DARK       = 23112;
int  COLOR_BLUE             = 255;
int  COLOR_BLUE_DARK        = 102;
int  COLOR_BLACK            = 0;
int  COLOR_WHITE            = 16777215;
int  COLOR_GREY             = 10066329;
int  COLOR_YELLOW           = 16776960;
int  COLOR_YELLOW_DARK      = 11184640;
int  COLOR_CYAN             = 65535;
int  COLOR_MAGENTA          = 16711935;
int  COLOR_ORANGE           = 16750848;
int  COLOR_ORANGE_DARK      = 13395456;
int  COLOR_BROWN            = 10053120;
int  COLOR_BROWN_DARK       = 6697728;

int REST_EVENTTYPE_REST_INVALID     = 0;
int REST_EVENTTYPE_REST_STARTED     = 1;
int REST_EVENTTYPE_REST_FINISHED    = 2;
int REST_EVENTTYPE_REST_CANCELLED   = 3;


                                                        // Spells 2DA "ProjType" column
int PROJECTILE_PATH_TYPE_DEFAULT                = 0;
int PROJECTILE_PATH_TYPE_HOMING                 = 1;    // homing
int PROJECTILE_PATH_TYPE_BALLISTIC              = 2;    // ballistic
int PROJECTILE_PATH_TYPE_HIGH_BALLISTIC         = 3;    // highballistic
int PROJECTILE_PATH_TYPE_BURST_UP               = 4;    // burstup
int PROJECTILE_PATH_TYPE_ACCELERATING           = 5;    // accelerating
int PROJECTILE_PATH_TYPE_SPIRAL                 = 6;    // spiral
int PROJECTILE_PATH_TYPE_LINKED                 = 7;    // linked
int PROJECTILE_PATH_TYPE_BOUNCE                 = 8;    // bounce
int PROJECTILE_PATH_TYPE_BURST                  = 9;    // burst
int PROJECTILE_PATH_TYPE_LINKED_BURST_UP        = 10;   // linked
int PROJECTILE_PATH_TYPE_TRIPLE_BALLISTIC_HIT   = 11;
int PROJECTILE_PATH_TYPE_TRIPLE_BALLISTIC_MISS  = 12;
int PROJECTILE_PATH_TYPE_DOUBLE_BALLISTIC       = 13;
int PROJECTILE_PATH_TYPE_HOMING_SPIRAL          = 14;   // homingspiral
int PROJECTILE_PATH_TYPE_LOW_ORBIT              = 15;   // loworbit
int PROJECTILE_PATH_TYPE_BALLISTIC_LAUNCHED     = 16;   // launchedballistic
int PROJECTILE_PATH_TYPE_BALLISTIC_THROWN       = 17;   // thrownballistic

int GAME_DIFFICULTY_VERY_EASY   = 0;
int GAME_DIFFICULTY_EASY        = 1;
int GAME_DIFFICULTY_NORMAL      = 2;
int GAME_DIFFICULTY_CORE_RULES  = 3;
int GAME_DIFFICULTY_DIFFICULT   = 4;

int TILE_MAIN_LIGHT_COLOR_BLACK             = 0;
int TILE_MAIN_LIGHT_COLOR_DIM_WHITE         = 1;
int TILE_MAIN_LIGHT_COLOR_WHITE             = 2;
int TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE      = 3;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW  = 4;
int TILE_MAIN_LIGHT_COLOR_DARK_YELLOW       = 5;
int TILE_MAIN_LIGHT_COLOR_PALE_YELLOW       = 6;
int TILE_MAIN_LIGHT_COLOR_YELLOW            = 7;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN   = 8;
int TILE_MAIN_LIGHT_COLOR_DARK_GREEN        = 9;
int TILE_MAIN_LIGHT_COLOR_PALE_GREEN        = 10;
int TILE_MAIN_LIGHT_COLOR_GREEN             = 11;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA    = 12;
int TILE_MAIN_LIGHT_COLOR_DARK_AQUA         = 13;
int TILE_MAIN_LIGHT_COLOR_PALE_AQUA         = 14;
int TILE_MAIN_LIGHT_COLOR_AQUA              = 15;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE    = 16;
int TILE_MAIN_LIGHT_COLOR_DARK_BLUE         = 17;
int TILE_MAIN_LIGHT_COLOR_PALE_BLUE         = 18;
int TILE_MAIN_LIGHT_COLOR_BLUE              = 19;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE  = 20;
int TILE_MAIN_LIGHT_COLOR_DARK_PURPLE       = 21;
int TILE_MAIN_LIGHT_COLOR_PALE_PURPLE       = 22;
int TILE_MAIN_LIGHT_COLOR_PURPLE            = 23;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED     = 24;
int TILE_MAIN_LIGHT_COLOR_DARK_RED          = 25;
int TILE_MAIN_LIGHT_COLOR_PALE_RED          = 26;
int TILE_MAIN_LIGHT_COLOR_RED               = 27;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE  = 28;
int TILE_MAIN_LIGHT_COLOR_DARK_ORANGE       = 29;
int TILE_MAIN_LIGHT_COLOR_PALE_ORANGE       = 30;
int TILE_MAIN_LIGHT_COLOR_ORANGE            = 31;

int TILE_SOURCE_LIGHT_COLOR_BLACK             = 0;
int TILE_SOURCE_LIGHT_COLOR_WHITE             = 1;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_YELLOW  = 2;
int TILE_SOURCE_LIGHT_COLOR_PALE_YELLOW       = 3;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN   = 4;
int TILE_SOURCE_LIGHT_COLOR_PALE_GREEN        = 5;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA    = 6;
int TILE_SOURCE_LIGHT_COLOR_PALE_AQUA         = 7;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_BLUE    = 8;
int TILE_SOURCE_LIGHT_COLOR_PALE_BLUE         = 9;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE  = 10;
int TILE_SOURCE_LIGHT_COLOR_PALE_PURPLE       = 11;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED     = 12;
int TILE_SOURCE_LIGHT_COLOR_PALE_RED          = 13;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE  = 14;
int TILE_SOURCE_LIGHT_COLOR_PALE_ORANGE       = 15;

int PANEL_BUTTON_MAP                  = 0;
int PANEL_BUTTON_INVENTORY            = 1;
int PANEL_BUTTON_JOURNAL              = 2;
int PANEL_BUTTON_CHARACTER            = 3;
int PANEL_BUTTON_OPTIONS              = 4;
int PANEL_BUTTON_SPELLS               = 5;
int PANEL_BUTTON_REST                 = 6;
int PANEL_BUTTON_PLAYER_VERSUS_PLAYER = 7;

int ACTION_MOVETOPOINT        = 0;
int ACTION_PICKUPITEM         = 1;
int ACTION_DROPITEM           = 2;
int ACTION_ATTACKOBJECT       = 3;
int ACTION_CASTSPELL          = 4;
int ACTION_OPENDOOR           = 5;
int ACTION_CLOSEDOOR          = 6;
int ACTION_DIALOGOBJECT       = 7;
int ACTION_DISABLETRAP        = 8;
int ACTION_RECOVERTRAP        = 9;
int ACTION_FLAGTRAP           = 10;
int ACTION_EXAMINETRAP        = 11;
int ACTION_SETTRAP            = 12;
int ACTION_OPENLOCK           = 13;
int ACTION_LOCK               = 14;
int ACTION_USEOBJECT          = 15;
int ACTION_ANIMALEMPATHY      = 16;
int ACTION_REST               = 17;
int ACTION_TAUNT              = 18;
int ACTION_ITEMCASTSPELL      = 19;
int ACTION_COUNTERSPELL       = 31;
int ACTION_HEAL               = 33;
int ACTION_PICKPOCKET         = 34;
int ACTION_FOLLOW             = 35;
int ACTION_WAIT               = 36;
int ACTION_SIT                = 37;
int ACTION_SMITEGOOD          = 40;
int ACTION_KIDAMAGE           = 41;
int ACTION_RANDOMWALK         = 42;

int ACTION_INVALID            = 65535;

int TRAP_BASE_TYPE_MINOR_SPIKE          = 0;
int TRAP_BASE_TYPE_AVERAGE_SPIKE        = 1;
int TRAP_BASE_TYPE_STRONG_SPIKE         = 2;
int TRAP_BASE_TYPE_DEADLY_SPIKE         = 3;
int TRAP_BASE_TYPE_MINOR_HOLY           = 4;
int TRAP_BASE_TYPE_AVERAGE_HOLY         = 5;
int TRAP_BASE_TYPE_STRONG_HOLY          = 6;
int TRAP_BASE_TYPE_DEADLY_HOLY          = 7;
int TRAP_BASE_TYPE_MINOR_TANGLE         = 8;
int TRAP_BASE_TYPE_AVERAGE_TANGLE       = 9;
int TRAP_BASE_TYPE_STRONG_TANGLE        = 10;
int TRAP_BASE_TYPE_DEADLY_TANGLE        = 11;
int TRAP_BASE_TYPE_MINOR_ACID           = 12;
int TRAP_BASE_TYPE_AVERAGE_ACID         = 13;
int TRAP_BASE_TYPE_STRONG_ACID          = 14;
int TRAP_BASE_TYPE_DEADLY_ACID          = 15;
int TRAP_BASE_TYPE_MINOR_FIRE           = 16;
int TRAP_BASE_TYPE_AVERAGE_FIRE         = 17;
int TRAP_BASE_TYPE_STRONG_FIRE          = 18;
int TRAP_BASE_TYPE_DEADLY_FIRE          = 19;
int TRAP_BASE_TYPE_MINOR_ELECTRICAL     = 20;
int TRAP_BASE_TYPE_AVERAGE_ELECTRICAL   = 21;
int TRAP_BASE_TYPE_STRONG_ELECTRICAL    = 22;
int TRAP_BASE_TYPE_DEADLY_ELECTRICAL    = 23;
int TRAP_BASE_TYPE_MINOR_GAS            = 24;
int TRAP_BASE_TYPE_AVERAGE_GAS          = 25;
int TRAP_BASE_TYPE_STRONG_GAS           = 26;
int TRAP_BASE_TYPE_DEADLY_GAS           = 27;
int TRAP_BASE_TYPE_MINOR_FROST          = 28;
int TRAP_BASE_TYPE_AVERAGE_FROST        = 29;
int TRAP_BASE_TYPE_STRONG_FROST         = 30;
int TRAP_BASE_TYPE_DEADLY_FROST         = 31;
int TRAP_BASE_TYPE_MINOR_NEGATIVE       = 32;
int TRAP_BASE_TYPE_AVERAGE_NEGATIVE     = 33;
int TRAP_BASE_TYPE_STRONG_NEGATIVE      = 34;
int TRAP_BASE_TYPE_DEADLY_NEGATIVE      = 35;
int TRAP_BASE_TYPE_MINOR_SONIC          = 36;
int TRAP_BASE_TYPE_AVERAGE_SONIC        = 37;
int TRAP_BASE_TYPE_STRONG_SONIC         = 38;
int TRAP_BASE_TYPE_DEADLY_SONIC         = 39;
int TRAP_BASE_TYPE_MINOR_ACID_SPLASH    = 40;
int TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH  = 41;
int TRAP_BASE_TYPE_STRONG_ACID_SPLASH   = 42;
int TRAP_BASE_TYPE_DEADLY_ACID_SPLASH   = 43;
int TRAP_BASE_TYPE_EPIC_ELECTRICAL      = 44;
int TRAP_BASE_TYPE_EPIC_FIRE            = 45;
int TRAP_BASE_TYPE_EPIC_FROST           = 46;
int TRAP_BASE_TYPE_EPIC_SONIC           = 47;


int TRACK_RURALDAY1         = 1;
int TRACK_RURALDAY2         = 2;
int TRACK_RURALNIGHT        = 3;
int TRACK_FORESTDAY1        = 4;
int TRACK_FORESTDAY2        = 5;
int TRACK_FORESTNIGHT       = 6;
int TRACK_DUNGEON1          = 7;
int TRACK_SEWER             = 8;
int TRACK_MINES1            = 9;
int TRACK_MINES2            = 10;
int TRACK_CRYPT1            = 11;
int TRACK_CRYPT2            = 12;
int TRACK_DESERT_DAY        = 58;
int TRACK_DESERT_NIGHT      = 61;
int TRACK_WINTER_DAY        = 59;
int TRACK_EVILDUNGEON1      = 13;
int TRACK_EVILDUNGEON2      = 14;
int TRACK_CITYSLUMDAY       = 15;
int TRACK_CITYSLUMNIGHT     = 16;
int TRACK_CITYDOCKDAY       = 17;
int TRACK_CITYDOCKNIGHT     = 18;
int TRACK_CITYWEALTHY       = 19;
int TRACK_CITYMARKET        = 20;
int TRACK_CITYNIGHT         = 21;
int TRACK_TAVERN1           = 22;
int TRACK_TAVERN2           = 23;
int TRACK_TAVERN3           = 24;
int TRACK_TAVERN4           = 56;
int TRACK_RICHHOUSE         = 25;
int TRACK_STORE             = 26;
int TRACK_TEMPLEGOOD        = 27;
int TRACK_TEMPLEGOOD2       = 49;
int TRACK_TEMPLEEVIL        = 28;
int TRACK_THEME_NWN         = 29;
int TRACK_THEME_CHAPTER1    = 30;
int TRACK_THEME_CHAPTER2    = 31;
int TRACK_THEME_CHAPTER3    = 32;
int TRACK_THEME_CHAPTER4    = 33;
int TRACK_BATTLE_RURAL1     = 34;
int TRACK_BATTLE_FOREST1    = 35;
int TRACK_BATTLE_FOREST2    = 36;
int TRACK_BATTLE_DUNGEON1   = 37;
int TRACK_BATTLE_DUNGEON2   = 38;
int TRACK_BATTLE_DUNGEON3   = 39;
int TRACK_BATTLE_CITY1      = 40;
int TRACK_BATTLE_CITY2      = 41;
int TRACK_BATTLE_CITY3      = 42;
int TRACK_BATTLE_CITYBOSS   = 43;
int TRACK_BATTLE_FORESTBOSS = 44;
int TRACK_BATTLE_LIZARDBOSS = 45;
int TRACK_BATTLE_DRAGON     = 46;
int TRACK_BATTLE_ARIBETH    = 47;
int TRACK_BATTLE_ENDBOSS    = 48;
int TRACK_BATTLE_DESERT     = 57;
int TRACK_BATTLE_WINTER     = 60;
int TRACK_CASTLE            = 50;
int TRACK_THEME_ARIBETH1    = 51;
int TRACK_THEME_ARIBETH2    = 52;
int TRACK_THEME_GEND        = 53;
int TRACK_THEME_MAUGRIM     = 54;
int TRACK_THEME_MORAG       = 55;
int TRACK_HOTU_THEME        = 62;
int TRACK_HOTU_WATERDEEP      = 63;
int TRACK_HOTU_UNDERMOUNTAIN  = 64;
int TRACK_HOTU_REBELCAMP      = 65;
int TRACK_HOTU_FIREPLANE      = 66;
int TRACK_HOTU_QUEEN          = 67;
int TRACK_HOTU_HELLFROZEOVER  = 68;
int TRACK_HOTU_DRACOLICH      = 69;
int TRACK_HOTU_BATTLE_SMALL   = 70;
int TRACK_HOTU_BATTLE_MED     = 71;
int TRACK_HOTU_BATTLE_LARGE   = 72;
int TRACK_HOTU_BATTLE_HELL    = 73;
int TRACK_HOTU_BATTLE_BOSS1   = 74;
int TRACK_HOTU_BATTLE_BOSS2   = 75;


int STEALTH_MODE_DISABLED   = 0;
int STEALTH_MODE_ACTIVATED  = 1;
int DETECT_MODE_PASSIVE     = 0;
int DETECT_MODE_ACTIVE      = 1;
int DEFENSIVE_CASTING_MODE_DISABLED = 0;
int DEFENSIVE_CASTING_MODE_ACTIVATED= 1;


int  APPEARANCE_TYPE_INVALID = -1;
int  APPEARANCE_TYPE_ALLIP = 186;
int  APPEARANCE_TYPE_ARANEA = 157;
int  APPEARANCE_TYPE_ARCH_TARGET = 200;
int  APPEARANCE_TYPE_ARIBETH = 190;
int  APPEARANCE_TYPE_ASABI_CHIEFTAIN = 353;
int  APPEARANCE_TYPE_ASABI_SHAMAN = 354;
int  APPEARANCE_TYPE_ASABI_WARRIOR = 355;
int  APPEARANCE_TYPE_BADGER = 8;
int  APPEARANCE_TYPE_BADGER_DIRE = 9;
int  APPEARANCE_TYPE_BALOR = 38;
int  APPEARANCE_TYPE_BARTENDER = 234;
int  APPEARANCE_TYPE_BASILISK = 369;
int  APPEARANCE_TYPE_BAT = 10;
int  APPEARANCE_TYPE_BAT_HORROR = 11;
int  APPEARANCE_TYPE_BEAR_BLACK = 12;
int  APPEARANCE_TYPE_BEAR_BROWN = 13;
int  APPEARANCE_TYPE_BEAR_DIRE = 15;
int  APPEARANCE_TYPE_BEAR_KODIAK = 204;
int  APPEARANCE_TYPE_BEAR_POLAR = 14;
int  APPEARANCE_TYPE_BEETLE_FIRE = 18;
int  APPEARANCE_TYPE_BEETLE_SLICER = 17;
int  APPEARANCE_TYPE_BEETLE_STAG = 19;
int  APPEARANCE_TYPE_BEETLE_STINK = 20;
int  APPEARANCE_TYPE_BEGGER = 220;
int  APPEARANCE_TYPE_BLOOD_SAILER = 221;
int  APPEARANCE_TYPE_BOAR = 21;
int  APPEARANCE_TYPE_BOAR_DIRE = 22;
int  APPEARANCE_TYPE_BODAK = 23;
int  APPEARANCE_TYPE_BUGBEAR_A = 29;
int  APPEARANCE_TYPE_BUGBEAR_B = 30;
int  APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_A = 25;
int  APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_B = 26;
int  APPEARANCE_TYPE_BUGBEAR_SHAMAN_A = 27;
int  APPEARANCE_TYPE_BUGBEAR_SHAMAN_B = 28;
int  APPEARANCE_TYPE_CAT_CAT_DIRE = 95;
int  APPEARANCE_TYPE_CAT_COUGAR = 203;
int  APPEARANCE_TYPE_CAT_CRAG_CAT = 94;
int  APPEARANCE_TYPE_CAT_JAGUAR = 98;
int  APPEARANCE_TYPE_CAT_KRENSHAR = 96;
int  APPEARANCE_TYPE_CAT_LEOPARD = 93;
int  APPEARANCE_TYPE_CAT_LION = 97;
int  APPEARANCE_TYPE_CAT_MPANTHER = 306;
int  APPEARANCE_TYPE_CAT_PANTHER = 202;
int  APPEARANCE_TYPE_CHICKEN = 31;
int  APPEARANCE_TYPE_COCKATRICE = 368;
int  APPEARANCE_TYPE_COMBAT_DUMMY = 201;
int  APPEARANCE_TYPE_CONVICT = 238;
int  APPEARANCE_TYPE_COW = 34;
int  APPEARANCE_TYPE_CULT_MEMBER = 212;
int  APPEARANCE_TYPE_DEER = 35;
int  APPEARANCE_TYPE_DEER_STAG = 37;
int  APPEARANCE_TYPE_DEVIL = 392;
int  APPEARANCE_TYPE_DOG = 176;
int  APPEARANCE_TYPE_DOG_BLINKDOG = 174;
int  APPEARANCE_TYPE_DOG_DIRE_WOLF = 175;
int  APPEARANCE_TYPE_DOG_FENHOUND = 177;
int  APPEARANCE_TYPE_DOG_HELL_HOUND = 179;
int  APPEARANCE_TYPE_DOG_SHADOW_MASTIF = 180;
int  APPEARANCE_TYPE_DOG_WINTER_WOLF = 184;
int  APPEARANCE_TYPE_DOG_WOLF = 181;
int  APPEARANCE_TYPE_DOG_WORG = 185;
int  APPEARANCE_TYPE_DOOM_KNIGHT = 40;
int  APPEARANCE_TYPE_DRAGON_BLACK = 41;
int  APPEARANCE_TYPE_DRAGON_BLUE = 47;
int  APPEARANCE_TYPE_DRAGON_BRASS = 42;
int  APPEARANCE_TYPE_DRAGON_BRONZE = 45;
int  APPEARANCE_TYPE_DRAGON_COPPER = 43;
int  APPEARANCE_TYPE_DRAGON_GOLD = 46;
int  APPEARANCE_TYPE_DRAGON_GREEN = 48;
int  APPEARANCE_TYPE_DRAGON_RED = 49;
int  APPEARANCE_TYPE_DRAGON_SILVER = 44;
int  APPEARANCE_TYPE_DRAGON_WHITE = 50;
int  APPEARANCE_TYPE_DROW_CLERIC = 215;
int  APPEARANCE_TYPE_DROW_FIGHTER = 216;
int  APPEARANCE_TYPE_DRUEGAR_CLERIC = 218;
int  APPEARANCE_TYPE_DRUEGAR_FIGHTER = 217;
int  APPEARANCE_TYPE_DRYAD = 51;
int  APPEARANCE_TYPE_DWARF = 0;
int  APPEARANCE_TYPE_DWARF_NPC_FEMALE = 248;
int  APPEARANCE_TYPE_DWARF_NPC_MALE = 249;
int  APPEARANCE_TYPE_ELEMENTAL_AIR = 52;
int  APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER = 53;
int  APPEARANCE_TYPE_ELEMENTAL_EARTH = 56;
int  APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER = 57;
int  APPEARANCE_TYPE_ELEMENTAL_FIRE = 60;
int  APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER = 61;
int  APPEARANCE_TYPE_ELEMENTAL_WATER = 69;
int  APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER = 68;
int  APPEARANCE_TYPE_ELF = 1;
int  APPEARANCE_TYPE_ELF_NPC_FEMALE = 245;
int  APPEARANCE_TYPE_ELF_NPC_MALE_01 = 246;
int  APPEARANCE_TYPE_ELF_NPC_MALE_02 = 247;
int  APPEARANCE_TYPE_ETTERCAP = 166;
int  APPEARANCE_TYPE_ETTIN = 72;
int  APPEARANCE_TYPE_FAERIE_DRAGON = 374;
int  APPEARANCE_TYPE_FAIRY = 55;
int  APPEARANCE_TYPE_FALCON = 144;
int  APPEARANCE_TYPE_FEMALE_01 = 222;
int  APPEARANCE_TYPE_FEMALE_02 = 223;
int  APPEARANCE_TYPE_FEMALE_03 = 224;
int  APPEARANCE_TYPE_FEMALE_04 = 225;
int  APPEARANCE_TYPE_FORMIAN_MYRMARCH = 362;
int  APPEARANCE_TYPE_FORMIAN_QUEEN = 363;
int  APPEARANCE_TYPE_FORMIAN_WARRIOR = 361;
int  APPEARANCE_TYPE_FORMIAN_WORKER = 360;
int  APPEARANCE_TYPE_GARGOYLE = 73;
int  APPEARANCE_TYPE_GHAST = 74;
int  APPEARANCE_TYPE_GHOUL = 76;
int  APPEARANCE_TYPE_GHOUL_LORD = 77;
int  APPEARANCE_TYPE_GIANT_FIRE = 80;
int  APPEARANCE_TYPE_GIANT_FIRE_FEMALE = 351;
int  APPEARANCE_TYPE_GIANT_FROST = 81;
int  APPEARANCE_TYPE_GIANT_FROST_FEMALE = 350;
int  APPEARANCE_TYPE_GIANT_HILL = 78;
int  APPEARANCE_TYPE_GIANT_MOUNTAIN = 79;
int  APPEARANCE_TYPE_GNOLL_WARRIOR = 388;
int  APPEARANCE_TYPE_GNOLL_WIZ = 389;
int  APPEARANCE_TYPE_GNOME = 2;
int  APPEARANCE_TYPE_GNOME_NPC_FEMALE = 243;
int  APPEARANCE_TYPE_GNOME_NPC_MALE = 244;
int  APPEARANCE_TYPE_GOBLIN_A = 86;
int  APPEARANCE_TYPE_GOBLIN_B = 87;
int  APPEARANCE_TYPE_GOBLIN_CHIEF_A = 82;
int  APPEARANCE_TYPE_GOBLIN_CHIEF_B = 83;
int  APPEARANCE_TYPE_GOBLIN_SHAMAN_A = 84;
int  APPEARANCE_TYPE_GOBLIN_SHAMAN_B = 85;
int  APPEARANCE_TYPE_GOLEM_BONE = 24;
int  APPEARANCE_TYPE_GOLEM_CLAY = 91;
int  APPEARANCE_TYPE_GOLEM_FLESH = 88;
int  APPEARANCE_TYPE_GOLEM_IRON = 89;
int  APPEARANCE_TYPE_GOLEM_STONE = 92;
int  APPEARANCE_TYPE_GORGON = 367;
int  APPEARANCE_TYPE_GREY_RENDER = 205;
int  APPEARANCE_TYPE_GYNOSPHINX = 365;
int  APPEARANCE_TYPE_HALFLING = 3;
int  APPEARANCE_TYPE_HALFLING_NPC_FEMALE = 250;
int  APPEARANCE_TYPE_HALFLING_NPC_MALE = 251;
int  APPEARANCE_TYPE_HALF_ELF = 4;
int  APPEARANCE_TYPE_HALF_ORC = 5;
int  APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE = 252;
int  APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01 = 253;
int  APPEARANCE_TYPE_HALF_ORC_NPC_MALE_02 = 254;
int  APPEARANCE_TYPE_HELMED_HORROR = 100;
int  APPEARANCE_TYPE_HEURODIS_LICH = 370;
int  APPEARANCE_TYPE_HOBGOBLIN_WARRIOR = 390;
int  APPEARANCE_TYPE_HOBGOBLIN_WIZARD = 391;
int  APPEARANCE_TYPE_HOOK_HORROR = 102;
int  APPEARANCE_TYPE_HOUSE_GUARD = 219;
int  APPEARANCE_TYPE_HUMAN = 6;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_01 = 255;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02 = 256;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_03 = 257;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_04 = 258;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_05 = 259;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_06 = 260;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_07 = 261;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_08 = 262;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_09 = 263;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_10 = 264;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_11 = 265;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_12 = 266;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_01 = 267;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_02 = 268;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_03 = 269;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_04 = 270;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_05 = 271;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_06 = 272;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_07 = 273;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_08 = 274;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_09 = 275;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_10 = 276;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_11 = 277;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_12 = 278;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_13 = 279;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_14 = 280;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_15 = 281;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_16 = 282;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_17 = 283;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_18 = 284;
int  APPEARANCE_TYPE_IMP = 105;
int  APPEARANCE_TYPE_INN_KEEPER = 233;
int  APPEARANCE_TYPE_INTELLECT_DEVOURER = 117;
int  APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE = 298;
int  APPEARANCE_TYPE_INVISIBLE_STALKER = 64;
int  APPEARANCE_TYPE_KID_FEMALE = 242;
int  APPEARANCE_TYPE_KID_MALE = 241;
int  APPEARANCE_TYPE_KOBOLD_A = 302;
int  APPEARANCE_TYPE_KOBOLD_B = 305;
int  APPEARANCE_TYPE_KOBOLD_CHIEF_A = 300;
int  APPEARANCE_TYPE_KOBOLD_CHIEF_B = 303;
int  APPEARANCE_TYPE_KOBOLD_SHAMAN_A = 301;
int  APPEARANCE_TYPE_KOBOLD_SHAMAN_B = 304;
int  APPEARANCE_TYPE_LANTERN_ARCHON = 103;
int  APPEARANCE_TYPE_LICH = 39;
int  APPEARANCE_TYPE_LIZARDFOLK_A = 134;
int  APPEARANCE_TYPE_LIZARDFOLK_B = 135;
int  APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_A = 132;
int  APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_B = 133;
int  APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_A = 130;
int  APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_B = 131;
int  APPEARANCE_TYPE_LUSKAN_GUARD = 211;
int  APPEARANCE_TYPE_MALE_01 = 226;
int  APPEARANCE_TYPE_MALE_02 = 227;
int  APPEARANCE_TYPE_MALE_03 = 228;
int  APPEARANCE_TYPE_MALE_04 = 229;
int  APPEARANCE_TYPE_MALE_05 = 230;
int  APPEARANCE_TYPE_MANTICORE = 366;
int  APPEARANCE_TYPE_MEDUSA = 352;
int  APPEARANCE_TYPE_MEPHIT_AIR = 106;
int  APPEARANCE_TYPE_MEPHIT_DUST = 107;
int  APPEARANCE_TYPE_MEPHIT_EARTH = 108;
int  APPEARANCE_TYPE_MEPHIT_FIRE = 109;
int  APPEARANCE_TYPE_MEPHIT_ICE = 110;
int  APPEARANCE_TYPE_MEPHIT_MAGMA = 114;
int  APPEARANCE_TYPE_MEPHIT_OOZE = 112;
int  APPEARANCE_TYPE_MEPHIT_SALT = 111;
int  APPEARANCE_TYPE_MEPHIT_STEAM = 113;
int  APPEARANCE_TYPE_MEPHIT_WATER = 115;
int  APPEARANCE_TYPE_MINOGON = 119;
int  APPEARANCE_TYPE_MINOTAUR = 120;
int  APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN = 121;
int  APPEARANCE_TYPE_MINOTAUR_SHAMAN = 122;
int  APPEARANCE_TYPE_MOHRG = 123;
int  APPEARANCE_TYPE_MUMMY_COMMON = 58;
int  APPEARANCE_TYPE_MUMMY_FIGHTER_2 = 59;
int  APPEARANCE_TYPE_MUMMY_GREATER = 124;
int  APPEARANCE_TYPE_MUMMY_WARRIOR = 125;
int  APPEARANCE_TYPE_NWN_AARIN = 188;
int  APPEARANCE_TYPE_NWN_ARIBETH_EVIL = 189;
int  APPEARANCE_TYPE_NWN_HAEDRALINE = 191;
int  APPEARANCE_TYPE_NWN_MAUGRIM = 193;
int  APPEARANCE_TYPE_NWN_MORAG = 192;
int  APPEARANCE_TYPE_NWN_NASHER = 296;
int  APPEARANCE_TYPE_NWN_SEDOS = 297;
int  APPEARANCE_TYPE_NW_MILITIA_MEMBER = 210;
int  APPEARANCE_TYPE_NYMPH = 126;
int  APPEARANCE_TYPE_OGRE = 127;
int  APPEARANCE_TYPE_OGREB = 207;
int  APPEARANCE_TYPE_OGRE_CHIEFTAIN = 128;
int  APPEARANCE_TYPE_OGRE_CHIEFTAINB = 208;
int  APPEARANCE_TYPE_OGRE_MAGE = 129;
int  APPEARANCE_TYPE_OGRE_MAGEB = 209;
int  APPEARANCE_TYPE_OLD_MAN = 239;
int  APPEARANCE_TYPE_OLD_WOMAN = 240;
int  APPEARANCE_TYPE_ORC_A = 140;
int  APPEARANCE_TYPE_ORC_B = 141;
int  APPEARANCE_TYPE_ORC_CHIEFTAIN_A = 136;
int  APPEARANCE_TYPE_ORC_CHIEFTAIN_B = 137;
int  APPEARANCE_TYPE_ORC_SHAMAN_A = 138;
int  APPEARANCE_TYPE_ORC_SHAMAN_B = 139;
int  APPEARANCE_TYPE_OX = 142;
int  APPEARANCE_TYPE_PENGUIN = 206;
int  APPEARANCE_TYPE_PLAGUE_VICTIM = 231;
int  APPEARANCE_TYPE_PROSTITUTE_01 = 236;
int  APPEARANCE_TYPE_PROSTITUTE_02 = 237;
int  APPEARANCE_TYPE_PSEUDODRAGON = 375;
int  APPEARANCE_TYPE_QUASIT = 104;
int  APPEARANCE_TYPE_RAKSHASA_BEAR_MALE = 294;
int  APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE = 290;
int  APPEARANCE_TYPE_RAKSHASA_TIGER_MALE = 293;
int  APPEARANCE_TYPE_RAKSHASA_WOLF_MALE = 295;
int  APPEARANCE_TYPE_RAT = 386;
int  APPEARANCE_TYPE_RAT_DIRE = 387;
int  APPEARANCE_TYPE_RAVEN = 145;
int  APPEARANCE_TYPE_SHADOW = 146;
int  APPEARANCE_TYPE_SHADOW_FIEND = 147;
int  APPEARANCE_TYPE_SHADOW_REAVER = 500;
int  APPEARANCE_TYPE_SHIELD_GUARDIAN = 90;
int  APPEARANCE_TYPE_SHOP_KEEPER = 232;
int  APPEARANCE_TYPE_SKELETAL_DEVOURER = 36;
int  APPEARANCE_TYPE_SKELETON_CHIEFTAIN = 182;
int  APPEARANCE_TYPE_SKELETON_COMMON = 63;
int  APPEARANCE_TYPE_SKELETON_MAGE = 148;
int  APPEARANCE_TYPE_SKELETON_PRIEST = 62;
int  APPEARANCE_TYPE_SKELETON_WARRIOR = 150;
int  APPEARANCE_TYPE_SKELETON_WARRIOR_1 = 70;
int  APPEARANCE_TYPE_SKELETON_WARRIOR_2 = 71;
int  APPEARANCE_TYPE_SLAAD_BLUE = 151;
int  APPEARANCE_TYPE_SLAAD_DEATH = 152;
int  APPEARANCE_TYPE_SLAAD_GRAY = 153;
int  APPEARANCE_TYPE_SLAAD_GREEN = 154;
int  APPEARANCE_TYPE_SLAAD_RED = 155;
int  APPEARANCE_TYPE_SPECTRE = 156;
int  APPEARANCE_TYPE_SPHINX = 364;
int  APPEARANCE_TYPE_SPIDER_DIRE = 158;
int  APPEARANCE_TYPE_SPIDER_GIANT = 159;
int  APPEARANCE_TYPE_SPIDER_PHASE = 160;
int  APPEARANCE_TYPE_SPIDER_SWORD = 161;
int  APPEARANCE_TYPE_SPIDER_WRAITH = 162;
int  APPEARANCE_TYPE_STINGER = 356;
int  APPEARANCE_TYPE_STINGER_CHIEFTAIN = 358;
int  APPEARANCE_TYPE_STINGER_MAGE = 359;
int  APPEARANCE_TYPE_STINGER_WARRIOR = 357;
int  APPEARANCE_TYPE_SUCCUBUS = 163;
int  APPEARANCE_TYPE_TROLL = 167;
int  APPEARANCE_TYPE_TROLL_CHIEFTAIN = 164;
int  APPEARANCE_TYPE_TROLL_SHAMAN = 165;
int  APPEARANCE_TYPE_UMBERHULK = 168;
int  APPEARANCE_TYPE_UTHGARD_ELK_TRIBE = 213;
int  APPEARANCE_TYPE_UTHGARD_TIGER_TRIBE = 214;
int  APPEARANCE_TYPE_VAMPIRE_FEMALE = 288;
int  APPEARANCE_TYPE_VAMPIRE_MALE = 289;
int  APPEARANCE_TYPE_VROCK = 101;
int  APPEARANCE_TYPE_WAITRESS = 235;
int  APPEARANCE_TYPE_WAR_DEVOURER = 54;
int  APPEARANCE_TYPE_WERECAT = 99;
int  APPEARANCE_TYPE_WERERAT = 170;
int  APPEARANCE_TYPE_WEREWOLF = 171;
int  APPEARANCE_TYPE_WIGHT = 172;
int  APPEARANCE_TYPE_WILL_O_WISP = 116;
int  APPEARANCE_TYPE_WRAITH = 187;
int  APPEARANCE_TYPE_WYRMLING_BLACK = 378;
int  APPEARANCE_TYPE_WYRMLING_BLUE = 377;
int  APPEARANCE_TYPE_WYRMLING_BRASS = 381;
int  APPEARANCE_TYPE_WYRMLING_BRONZE = 383;
int  APPEARANCE_TYPE_WYRMLING_COPPER = 382;
int  APPEARANCE_TYPE_WYRMLING_GOLD = 385;
int  APPEARANCE_TYPE_WYRMLING_GREEN = 379;
int  APPEARANCE_TYPE_WYRMLING_RED = 376;
int  APPEARANCE_TYPE_WYRMLING_SILVER = 384;
int  APPEARANCE_TYPE_WYRMLING_WHITE = 380;
int  APPEARANCE_TYPE_YUAN_TI = 285;
int  APPEARANCE_TYPE_YUAN_TI_CHIEFTEN = 286;
int  APPEARANCE_TYPE_YUAN_TI_WIZARD = 287;
int  APPEARANCE_TYPE_ZOMBIE = 198;
int  APPEARANCE_TYPE_ZOMBIE_ROTTING = 195;
int  APPEARANCE_TYPE_ZOMBIE_TYRANT_FOG = 199;
int  APPEARANCE_TYPE_ZOMBIE_WARRIOR_1 = 196;
int  APPEARANCE_TYPE_ZOMBIE_WARRIOR_2 = 197;


int CAMERA_TRANSITION_TYPE_SNAP = 0;
int CAMERA_TRANSITION_TYPE_CRAWL = 2;
int CAMERA_TRANSITION_TYPE_VERY_SLOW = 5;
int CAMERA_TRANSITION_TYPE_SLOW = 20;
int CAMERA_TRANSITION_TYPE_MEDIUM = 40;
int CAMERA_TRANSITION_TYPE_FAST = 70;
int CAMERA_TRANSITION_TYPE_VERY_FAST = 100;

// these are now specified in seconds.
float FADE_SPEED_SLOWEST = 3.0; //0.003;
float FADE_SPEED_SLOW = 2.0;    //0.005;
float FADE_SPEED_MEDIUM = 1.5;  //0.01;
float FADE_SPEED_FAST = 1.0;    //0.017;
float FADE_SPEED_FASTEST = 0.5; //0.25;

// User-Defined script events
int EVENT_HEARTBEAT =  1001;
int EVENT_PERCEIVE = 1002;
int EVENT_END_COMBAT_ROUND = 1003;
int EVENT_DIALOGUE = 1004;
int EVENT_ATTACKED = 1005;
int EVENT_DAMAGED = 1006;
int EVENT_DISTURBED = 1008;
int EVENT_SPELL_CAST_AT = 1011;

// Event IDs in the range 2000-2999 are broadcast from engine events
int EVENT_MASTER_TOGGLEMODE_NONE                    = 2000;
int EVENT_MASTER_TOGGLEMODE_PARRY                   = 2001;
int EVENT_MASTER_TOGGLEMODE_POWER_ATTACK            = 2002;
int EVENT_MASTER_TOGGLEMODE_IMPROVED_POWER_ATTACK   = 2003;
int EVENT_MASTER_TOGGLEMODE_COUNTERSPELL            = 2004;
int EVENT_MASTER_TOGGLEMODE_FLURRY_OF_BLOWS         = 2005;
int EVENT_MASTER_TOGGLEMODE_RAPID_SHOT              = 2006;
int EVENT_MASTER_TOGGLEMODE_COMBAT_EXPERTISE        = 2007;
int EVENT_MASTER_TOGGLEMODE_IMPROVED_COMBAT_EXPERTISE = 2008;
int EVENT_MASTER_TOGGLEMODE_DEFENSIVE_CASTING       = 2009;
int EVENT_MASTER_TOGGLEMODE_DIRTY_FIGHTING          = 2010;
int EVENT_MASTER_TOGGLEMODE_DEFENSIVE_STANCE        = 2011;
int EVENT_MASTER_TOGGLEMODE_TAUNT                   = 2012;

int EVENT_SAW_TRAP                                  = 2050; // Brock H. - OEI 05/24/06 - call GetLastTrapDetected to get the trap associated with this event
int EVENT_ROSTER_SPAWN_IN                           = 2051; // BMA-OEI 7/14/06 - signals on roster member spawned in from script or GUI callback
int EVENT_PLAYER_CONTROL_CHANGED                    = 2052; // Brock H. - OEI 05/24/06 - called when this creature has become controlled, or is no longer controlled, by a player
int EVENT_PLAYER_CAN_LEVEL_UP                       = 2053; // AFW-OEI 06/21/2007 - called when a creature gains enough XP to level up (one or more levels).
int EVENT_PARTY_MEMBER_ADDED                        = 2054;
int EVENT_PARTY_MEMBER_REMOVED                      = 2055;
int EVENT_TRANSFER_PARTY_LEADER                     =2056;
int EVENT_ACTION_ATTACK_FAILED_NO_PATH              = 2100;


int AI_LEVEL_INVALID = -1;
int AI_LEVEL_DEFAULT = -1;
int AI_LEVEL_VERY_LOW = 0;
int AI_LEVEL_LOW = 1;
int AI_LEVEL_NORMAL = 2;
int AI_LEVEL_HIGH = 3;
int AI_LEVEL_VERY_HIGH = 4;

int AREA_INVALID = -1;
int AREA_NATURAL = 1;
int AREA_ARTIFICIAL = 0;
int AREA_ABOVEGROUND = 1;
int AREA_UNDERGROUND = 0;




// The following is all the item property constants...
int IP_CONST_ABILITY_STR                        = 0;
int IP_CONST_ABILITY_DEX                        = 1;
int IP_CONST_ABILITY_CON                        = 2;
int IP_CONST_ABILITY_INT                        = 3;
int IP_CONST_ABILITY_WIS                        = 4;
int IP_CONST_ABILITY_CHA                        = 5;
int IP_CONST_ACMODIFIERTYPE_DODGE               = 0;
int IP_CONST_ACMODIFIERTYPE_NATURAL             = 1;
int IP_CONST_ACMODIFIERTYPE_ARMOR               = 2;
int IP_CONST_ACMODIFIERTYPE_SHIELD              = 3;
int IP_CONST_ACMODIFIERTYPE_DEFLECTION          = 4;
int IP_CONST_ALIGNMENTGROUP_ALL                 = 0;
int IP_CONST_ALIGNMENTGROUP_NEUTRAL             = 1;
int IP_CONST_ALIGNMENTGROUP_LAWFUL              = 2;
int IP_CONST_ALIGNMENTGROUP_CHAOTIC             = 3;
int IP_CONST_ALIGNMENTGROUP_GOOD                = 4;
int IP_CONST_ALIGNMENTGROUP_EVIL                = 5;
int IP_CONST_ALIGNMENT_LG                       = 0;
int IP_CONST_ALIGNMENT_LN                       = 1;
int IP_CONST_ALIGNMENT_LE                       = 2;
int IP_CONST_ALIGNMENT_NG                       = 3;
int IP_CONST_ALIGNMENT_TN                       = 4;
int IP_CONST_ALIGNMENT_NE                       = 5;
int IP_CONST_ALIGNMENT_CG                       = 6;
int IP_CONST_ALIGNMENT_CN                       = 7;
int IP_CONST_ALIGNMENT_CE                       = 8;
int IP_CONST_RACIALTYPE_DWARF                   = 0;
int IP_CONST_RACIALTYPE_ELF                     = 1;
int IP_CONST_RACIALTYPE_GNOME                   = 2;
int IP_CONST_RACIALTYPE_HALFLING                = 3;
int IP_CONST_RACIALTYPE_HALFELF                 = 4;
int IP_CONST_RACIALTYPE_HALFORC                 = 5;
int IP_CONST_RACIALTYPE_HUMAN                   = 6;
int IP_CONST_RACIALTYPE_ABERRATION              = 7;
int IP_CONST_RACIALTYPE_ANIMAL                  = 8;
int IP_CONST_RACIALTYPE_BEAST                   = 9;
int IP_CONST_RACIALTYPE_CONSTRUCT               = 10;
int IP_CONST_RACIALTYPE_DRAGON                  = 11;
int IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID      = 12;
int IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS      = 13;
int IP_CONST_RACIALTYPE_HUMANOID_ORC            = 14;
int IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN      = 15;
int IP_CONST_RACIALTYPE_ELEMENTAL               = 16;
int IP_CONST_RACIALTYPE_FEY                     = 17;
int IP_CONST_RACIALTYPE_GIANT                   = 18;
int IP_CONST_RACIALTYPE_MAGICAL_BEAST           = 19;
int IP_CONST_RACIALTYPE_OUTSIDER                = 20;
int IP_CONST_RACIALTYPE_SHAPECHANGER            = 23;
int IP_CONST_RACIALTYPE_UNDEAD                  = 24;
int IP_CONST_RACIALTYPE_VERMIN                  = 25;
int IP_CONST_UNLIMITEDAMMO_BASIC                = 1;
int IP_CONST_UNLIMITEDAMMO_1D6FIRE              = 2;
int IP_CONST_UNLIMITEDAMMO_1D6COLD              = 3;
int IP_CONST_UNLIMITEDAMMO_1D6LIGHT             = 4;
int IP_CONST_UNLIMITEDAMMO_NATURES_RAGE         = 5;
int IP_CONST_UNLIMITEDAMMO_PLUS1                = 11;
int IP_CONST_UNLIMITEDAMMO_PLUS2                = 12;
int IP_CONST_UNLIMITEDAMMO_PLUS3                = 13;
int IP_CONST_UNLIMITEDAMMO_PLUS4                = 14;
int IP_CONST_UNLIMITEDAMMO_PLUS5                = 15;
int IP_CONST_AMMOTYPE_ARROW                     = 0;
int IP_CONST_AMMOTYPE_BOLT                      = 1;
int IP_CONST_AMMOTYPE_BULLET                    = 2;
int IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE           = 1;
int IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE    = 2;
int IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE    = 3;
int IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE    = 4;
int IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE    = 5;
int IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE     = 6;
int IP_CONST_CASTSPELL_NUMUSES_0_CHARGES_PER_USE    = 7;
int IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY        = 8;
int IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY       = 9;
int IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY       = 10;
int IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY       = 11;
int IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY       = 12;
int IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE        = 13;
int IP_CONST_DAMAGEBONUS_1                      = 1;
int IP_CONST_DAMAGEBONUS_2                      = 2;
int IP_CONST_DAMAGEBONUS_3                      = 3;
int IP_CONST_DAMAGEBONUS_4                      = 4;
int IP_CONST_DAMAGEBONUS_5                      = 5;
int IP_CONST_DAMAGEBONUS_1d4                    = 6;
int IP_CONST_DAMAGEBONUS_1d6                    = 7;
int IP_CONST_DAMAGEBONUS_1d8                    = 8;
int IP_CONST_DAMAGEBONUS_1d10                   = 9;
int IP_CONST_DAMAGEBONUS_2d6                    = 10;
int IP_CONST_DAMAGEBONUS_2d8                = 11;
int IP_CONST_DAMAGEBONUS_2d4                = 12;
int IP_CONST_DAMAGEBONUS_2d10               = 13;
int IP_CONST_DAMAGEBONUS_1d12               = 14;
int IP_CONST_DAMAGEBONUS_2d12               = 15;
int IP_CONST_DAMAGEBONUS_6                  = 16;
int IP_CONST_DAMAGEBONUS_7                  = 17;
int IP_CONST_DAMAGEBONUS_8                  = 18;
int IP_CONST_DAMAGEBONUS_9                  = 19;
int IP_CONST_DAMAGEBONUS_10                 = 20;
int IP_CONST_DAMAGEBONUS_3d10           = 51;
int IP_CONST_DAMAGEBONUS_3d12           = 52;
int IP_CONST_DAMAGEBONUS_4d6            = 53;
int IP_CONST_DAMAGEBONUS_4d8            = 54;
int IP_CONST_DAMAGEBONUS_4d10           = 55;
int IP_CONST_DAMAGEBONUS_4d12           = 56;
int IP_CONST_DAMAGEBONUS_5d6            = 57;
int IP_CONST_DAMAGEBONUS_5d12           = 58;
int IP_CONST_DAMAGEBONUS_6d12           = 59;
int IP_CONST_DAMAGEBONUS_3d6            = 60;
int IP_CONST_DAMAGEBONUS_6d6            = 61;
int IP_CONST_DAMAGETYPE_BLUDGEONING             = 0;
int IP_CONST_DAMAGETYPE_PIERCING                = 1;
int IP_CONST_DAMAGETYPE_SLASHING                = 2;
int IP_CONST_DAMAGETYPE_SUBDUAL                 = 3;
int IP_CONST_DAMAGETYPE_PHYSICAL                = 4;
int IP_CONST_DAMAGETYPE_MAGICAL                 = 5;
int IP_CONST_DAMAGETYPE_ACID                    = 6;
int IP_CONST_DAMAGETYPE_COLD                    = 7;
int IP_CONST_DAMAGETYPE_DIVINE                  = 8;
int IP_CONST_DAMAGETYPE_ELECTRICAL              = 9;
int IP_CONST_DAMAGETYPE_FIRE                    = 10;
int IP_CONST_DAMAGETYPE_NEGATIVE                = 11;
int IP_CONST_DAMAGETYPE_POSITIVE                = 12;
int IP_CONST_DAMAGETYPE_SONIC                   = 13;
int IP_CONST_DAMAGEIMMUNITY_5_PERCENT           = 1;
int IP_CONST_DAMAGEIMMUNITY_10_PERCENT          = 2;
int IP_CONST_DAMAGEIMMUNITY_25_PERCENT          = 3;
int IP_CONST_DAMAGEIMMUNITY_50_PERCENT          = 4;
int IP_CONST_DAMAGEIMMUNITY_75_PERCENT          = 5;
int IP_CONST_DAMAGEIMMUNITY_90_PERCENT          = 6;
int IP_CONST_DAMAGEIMMUNITY_100_PERCENT         = 7;
int IP_CONST_DAMAGEVULNERABILITY_5_PERCENT      = 1;
int IP_CONST_DAMAGEVULNERABILITY_10_PERCENT     = 2;
int IP_CONST_DAMAGEVULNERABILITY_25_PERCENT     = 3;
int IP_CONST_DAMAGEVULNERABILITY_50_PERCENT     = 4;
int IP_CONST_DAMAGEVULNERABILITY_75_PERCENT     = 5;
int IP_CONST_DAMAGEVULNERABILITY_90_PERCENT     = 6;
int IP_CONST_DAMAGEVULNERABILITY_100_PERCENT    = 7;
int IP_CONST_FEAT_ALERTNESS                     = 0;
int IP_CONST_FEAT_AMBIDEXTROUS                  = 1;
int IP_CONST_FEAT_CLEAVE                        = 2;
int IP_CONST_FEAT_COMBAT_CASTING                = 3;
int IP_CONST_FEAT_DODGE                         = 4;
int IP_CONST_FEAT_EXTRA_TURNING                 = 5;
int IP_CONST_FEAT_KNOCKDOWN                     = 6;
int IP_CONST_FEAT_POINTBLANK                    = 7;
int IP_CONST_FEAT_SPELLFOCUSABJ                 = 8;
int IP_CONST_FEAT_SPELLFOCUSCON                 = 9;
int IP_CONST_FEAT_SPELLFOCUSDIV                 = 10;
int IP_CONST_FEAT_SPELLFOCUSENC                 = 11;
int IP_CONST_FEAT_SPELLFOCUSEVO                 = 12;
int IP_CONST_FEAT_SPELLFOCUSILL                 = 13;
int IP_CONST_FEAT_SPELLFOCUSNEC                 = 14;
int IP_CONST_FEAT_SPELLPENETRATION              = 15;
int IP_CONST_FEAT_POWERATTACK                   = 16;
int IP_CONST_FEAT_TWO_WEAPON_FIGHTING           = 17;
int IP_CONST_FEAT_WEAPSPEUNARM                  = 18;
int IP_CONST_FEAT_WEAPFINESSE                   = 19;
int IP_CONST_FEAT_IMPCRITUNARM                  = 20;
int IP_CONST_FEAT_WEAPON_PROF_EXOTIC            = 21;
int IP_CONST_FEAT_WEAPON_PROF_SIMPLE            = 22;
int IP_CONST_FEAT_WEAPON_PROF_MARTIAL           = 23;
int IP_CONST_FEAT_ARMOR_PROF_HEAVY              = 24;
int IP_CONST_FEAT_ARMOR_PROF_LIGHT              = 25;
int IP_CONST_FEAT_ARMOR_PROF_MEDIUM             = 26;

int IP_CONST_FEAT_DEFLECT_ARROWS                = 40;

int IP_CONST_FEAT_EXTRA_SMITING                 = 134;
int IP_CONST_FEAT_EXTRA_MUSIC                   = 169;
int IP_CONST_FEAT_EXTRA_STUNNING_ATTACK         = 170;
int IP_CONST_FEAT_EXTENDED_RAGE                 = 199;
int IP_CONST_FEAT_EXTRA_RAGE                    = 200;
int IP_CONST_FEAT_EXTRA_WILD_SHAPE              = 201;

int IP_CONST_IMMUNITYMISC_BACKSTAB              = 0;
int IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN      = 1;
int IP_CONST_IMMUNITYMISC_MINDSPELLS            = 2;
int IP_CONST_IMMUNITYMISC_POISON                = 3;
int IP_CONST_IMMUNITYMISC_DISEASE               = 4;
int IP_CONST_IMMUNITYMISC_FEAR                  = 5;
int IP_CONST_IMMUNITYMISC_KNOCKDOWN             = 6;
int IP_CONST_IMMUNITYMISC_PARALYSIS             = 7;
int IP_CONST_IMMUNITYMISC_CRITICAL_HITS         = 8;
int IP_CONST_IMMUNITYMISC_DEATH_MAGIC           = 9;
int IP_CONST_LIGHTBRIGHTNESS_DIM                = 1;
int IP_CONST_LIGHTBRIGHTNESS_LOW                = 2;
int IP_CONST_LIGHTBRIGHTNESS_NORMAL             = 3;
int IP_CONST_LIGHTBRIGHTNESS_BRIGHT             = 4;
int IP_CONST_LIGHTCOLOR_BLUE                    = 0;
int IP_CONST_LIGHTCOLOR_YELLOW                  = 1;
int IP_CONST_LIGHTCOLOR_PURPLE                  = 2;
int IP_CONST_LIGHTCOLOR_RED                     = 3;
int IP_CONST_LIGHTCOLOR_GREEN                   = 4;
int IP_CONST_LIGHTCOLOR_ORANGE                  = 5;
int IP_CONST_LIGHTCOLOR_WHITE                   = 6;
int IP_CONST_MONSTERDAMAGE_1d2                  = 1;
int IP_CONST_MONSTERDAMAGE_1d3                  = 2;
int IP_CONST_MONSTERDAMAGE_1d4                  = 3;
int IP_CONST_MONSTERDAMAGE_2d4                  = 4;
int IP_CONST_MONSTERDAMAGE_3d4                  = 5;
int IP_CONST_MONSTERDAMAGE_4d4                  = 6;
int IP_CONST_MONSTERDAMAGE_5d4                  = 7;
int IP_CONST_MONSTERDAMAGE_1d6                  = 8;
int IP_CONST_MONSTERDAMAGE_2d6                  = 9;
int IP_CONST_MONSTERDAMAGE_3d6                  = 10;
int IP_CONST_MONSTERDAMAGE_4d6                  = 11;
int IP_CONST_MONSTERDAMAGE_5d6                  = 12;
int IP_CONST_MONSTERDAMAGE_6d6                  = 13;
int IP_CONST_MONSTERDAMAGE_7d6                  = 14;
int IP_CONST_MONSTERDAMAGE_8d6                  = 15;
int IP_CONST_MONSTERDAMAGE_9d6                  = 16;
int IP_CONST_MONSTERDAMAGE_10d6                 = 17;
int IP_CONST_MONSTERDAMAGE_1d8                  = 18;
int IP_CONST_MONSTERDAMAGE_2d8                  = 19;
int IP_CONST_MONSTERDAMAGE_3d8                  = 20;
int IP_CONST_MONSTERDAMAGE_4d8                  = 21;
int IP_CONST_MONSTERDAMAGE_5d8                  = 22;
int IP_CONST_MONSTERDAMAGE_6d8                  = 23;
int IP_CONST_MONSTERDAMAGE_7d8                  = 24;
int IP_CONST_MONSTERDAMAGE_8d8                  = 25;
int IP_CONST_MONSTERDAMAGE_9d8                  = 26;
int IP_CONST_MONSTERDAMAGE_10d8                 = 27;
int IP_CONST_MONSTERDAMAGE_1d10                 = 28;
int IP_CONST_MONSTERDAMAGE_2d10                 = 29;
int IP_CONST_MONSTERDAMAGE_3d10                 = 30;
int IP_CONST_MONSTERDAMAGE_4d10                 = 31;
int IP_CONST_MONSTERDAMAGE_5d10                 = 32;
int IP_CONST_MONSTERDAMAGE_6d10                 = 33;
int IP_CONST_MONSTERDAMAGE_7d10                 = 34;
int IP_CONST_MONSTERDAMAGE_8d10                 = 35;
int IP_CONST_MONSTERDAMAGE_9d10                 = 36;
int IP_CONST_MONSTERDAMAGE_10d10                = 37;
int IP_CONST_MONSTERDAMAGE_1d12                 = 38;
int IP_CONST_MONSTERDAMAGE_2d12                 = 39;
int IP_CONST_MONSTERDAMAGE_3d12                 = 40;
int IP_CONST_MONSTERDAMAGE_4d12                 = 41;
int IP_CONST_MONSTERDAMAGE_5d12                 = 42;
int IP_CONST_MONSTERDAMAGE_6d12                 = 43;
int IP_CONST_MONSTERDAMAGE_7d12                 = 44;
int IP_CONST_MONSTERDAMAGE_8d12                 = 45;
int IP_CONST_MONSTERDAMAGE_9d12                 = 46;
int IP_CONST_MONSTERDAMAGE_10d12                = 47;
int IP_CONST_MONSTERDAMAGE_1d20                 = 48;
int IP_CONST_MONSTERDAMAGE_2d20                 = 49;
int IP_CONST_MONSTERDAMAGE_3d20                 = 50;
int IP_CONST_MONSTERDAMAGE_4d20                 = 51;
int IP_CONST_MONSTERDAMAGE_5d20                 = 52;
int IP_CONST_MONSTERDAMAGE_6d20                 = 53;
int IP_CONST_MONSTERDAMAGE_7d20                 = 54;
int IP_CONST_MONSTERDAMAGE_8d20                 = 55;
int IP_CONST_MONSTERDAMAGE_9d20                 = 56;
int IP_CONST_MONSTERDAMAGE_10d20                = 57;
int IP_CONST_ONMONSTERHIT_ABILITYDRAIN          = 0;
int IP_CONST_ONMONSTERHIT_CONFUSION             = 1;
int IP_CONST_ONMONSTERHIT_DISEASE               = 2;
int IP_CONST_ONMONSTERHIT_DOOM                  = 3;
int IP_CONST_ONMONSTERHIT_FEAR                  = 4;
int IP_CONST_ONMONSTERHIT_LEVELDRAIN            = 5;
int IP_CONST_ONMONSTERHIT_POISON                = 6;
int IP_CONST_ONMONSTERHIT_SLOW                  = 7;
int IP_CONST_ONMONSTERHIT_STUN                  = 8;
int IP_CONST_ONMONSTERHIT_WOUNDING              = 9;
int IP_CONST_ONHIT_SLEEP                        = 0;
int IP_CONST_ONHIT_STUN                         = 1;
int IP_CONST_ONHIT_HOLD                         = 2;
int IP_CONST_ONHIT_CONFUSION                    = 3;
int IP_CONST_ONHIT_DAZE                         = 5;
int IP_CONST_ONHIT_DOOM                         = 6;
int IP_CONST_ONHIT_FEAR                         = 7;
int IP_CONST_ONHIT_KNOCK                        = 8;
int IP_CONST_ONHIT_SLOW                         = 9;
int IP_CONST_ONHIT_LESSERDISPEL                 = 10;
int IP_CONST_ONHIT_DISPELMAGIC                  = 11;
int IP_CONST_ONHIT_GREATERDISPEL                = 12;
int IP_CONST_ONHIT_MORDSDISJUNCTION             = 13;
int IP_CONST_ONHIT_SILENCE                      = 14;
int IP_CONST_ONHIT_DEAFNESS                     = 15;
int IP_CONST_ONHIT_BLINDNESS                    = 16;
int IP_CONST_ONHIT_LEVELDRAIN                   = 17;
int IP_CONST_ONHIT_ABILITYDRAIN                 = 18;
int IP_CONST_ONHIT_ITEMPOISON                   = 19;
int IP_CONST_ONHIT_DISEASE                      = 20;
int IP_CONST_ONHIT_SLAYRACE                     = 21;
int IP_CONST_ONHIT_SLAYALIGNMENTGROUP           = 22;
int IP_CONST_ONHIT_SLAYALIGNMENT                = 23;
int IP_CONST_ONHIT_VORPAL                       = 24;
int IP_CONST_ONHIT_WOUNDING                     = 25;
int IP_CONST_ONHIT_SAVEDC_14                    = 0;
int IP_CONST_ONHIT_SAVEDC_16                    = 1;
int IP_CONST_ONHIT_SAVEDC_18                    = 2;
int IP_CONST_ONHIT_SAVEDC_20                    = 3;
int IP_CONST_ONHIT_SAVEDC_22                    = 4;
int IP_CONST_ONHIT_SAVEDC_24                    = 5;
int IP_CONST_ONHIT_SAVEDC_26                    = 6;
int IP_CONST_ONHIT_SAVEDC_28                    = 7;
int IP_CONST_ONHIT_SAVEDC_30                    = 8;
int IP_CONST_ONHIT_SAVEDC_32                    = 9;
int IP_CONST_ONHIT_SAVEDC_34                    = 10;
int IP_CONST_ONHIT_SAVEDC_36                    = 11;
int IP_CONST_ONHIT_SAVEDC_38                    = 12;
int IP_CONST_ONHIT_SAVEDC_40                    = 13;
int IP_CONST_ONHIT_DURATION_5_PERCENT_5_ROUNDS  = 0;
int IP_CONST_ONHIT_DURATION_10_PERCENT_4_ROUNDS = 1;
int IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS = 2;
int IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS = 3;
int IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND  = 4;
int IP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS  = 5;
int IP_CONST_ONHIT_DURATION_5_PERCENT_2_ROUNDS  = 6;
int IP_CONST_ONHIT_DURATION_5_PERCENT_3_ROUNDS  = 7;
int IP_CONST_ONHIT_DURATION_5_PERCENT_4_ROUNDS  = 8;
int IP_CONST_ONHIT_DURATION_10_PERCENT_1_ROUNDS = 9;
int IP_CONST_ONHIT_DURATION_10_PERCENT_2_ROUNDS = 10;
int IP_CONST_ONHIT_DURATION_10_PERCENT_3_ROUNDS = 11;
int IP_CONST_ONHIT_DURATION_10_PERCENT_5_ROUNDS = 12;
int IP_CONST_ONHIT_DURATION_25_PERCENT_1_ROUNDS = 13;
int IP_CONST_ONHIT_DURATION_25_PERCENT_2_ROUNDS = 14;
int IP_CONST_ONHIT_DURATION_25_PERCENT_4_ROUNDS = 15;
int IP_CONST_ONHIT_DURATION_25_PERCENT_5_ROUNDS = 16;
int IP_CONST_ONHIT_DURATION_33_PERCENT_1_ROUNDS = 17;
int IP_CONST_ONHIT_DURATION_33_PERCENT_2_ROUNDS = 18;
int IP_CONST_ONHIT_DURATION_33_PERCENT_3_ROUNDS = 19;
int IP_CONST_ONHIT_DURATION_33_PERCENT_4_ROUNDS = 20;
int IP_CONST_ONHIT_DURATION_33_PERCENT_5_ROUNDS = 21;
int IP_CONST_ONHIT_DURATION_50_PERCENT_1_ROUNDS = 22;
int IP_CONST_ONHIT_DURATION_50_PERCENT_3_ROUNDS = 23;
int IP_CONST_ONHIT_DURATION_50_PERCENT_4_ROUNDS = 24;
int IP_CONST_ONHIT_DURATION_50_PERCENT_5_ROUNDS = 25;
int IP_CONST_ONHIT_DURATION_66_PERCENT_1_ROUNDS = 26;
int IP_CONST_ONHIT_DURATION_66_PERCENT_2_ROUNDS = 27;
int IP_CONST_ONHIT_DURATION_66_PERCENT_3_ROUNDS = 28;
int IP_CONST_ONHIT_DURATION_66_PERCENT_4_ROUNDS = 29;
int IP_CONST_ONHIT_DURATION_66_PERCENT_5_ROUNDS = 30;
int IP_CONST_ONHIT_DURATION_75_PERCENT_2_ROUND  = 31;
int IP_CONST_ONHIT_DURATION_75_PERCENT_3_ROUND  = 32;
int IP_CONST_ONHIT_DURATION_75_PERCENT_4_ROUND  = 33;
int IP_CONST_ONHIT_DURATION_75_PERCENT_5_ROUND  = 34;
int IP_CONST_ONHIT_DURATION_100_PERCENT_1_ROUND  = 35;
int IP_CONST_ONHIT_DURATION_100_PERCENT_2_ROUND  = 36;
int IP_CONST_ONHIT_DURATION_100_PERCENT_3_ROUND  = 37;
int IP_CONST_ONHIT_DURATION_100_PERCENT_4_ROUND  = 38;
int IP_CONST_ONHIT_DURATION_100_PERCENT_5_ROUND  = 39;


int IP_CONST_ONHIT_CASTSPELL_ACID_FOG                           = 0;
int IP_CONST_ONHIT_CASTSPELL_BESTOW_CURSE                       = 1;
int IP_CONST_ONHIT_CASTSPELL_BLADE_BARRIER                      = 2;
int IP_CONST_ONHIT_CASTSPELL_BLINDNESS_AND_DEAFNESS             = 3;
int IP_CONST_ONHIT_CASTSPELL_CALL_LIGHTNING                     = 4;
int IP_CONST_ONHIT_CASTSPELL_CHAIN_LIGHTNING                    = 5;
int IP_CONST_ONHIT_CASTSPELL_CLOUDKILL                          = 6;
int IP_CONST_ONHIT_CASTSPELL_CONFUSION                          = 7;
int IP_CONST_ONHIT_CASTSPELL_CONTAGION                          = 8;
int IP_CONST_ONHIT_CASTSPELL_DARKNESS                           = 9;
int IP_CONST_ONHIT_CASTSPELL_DAZE                               = 10;
int IP_CONST_ONHIT_CASTSPELL_DELAYED_BLAST_FIREBALL             = 11;
int IP_CONST_ONHIT_CASTSPELL_DISMISSAL                          = 12;
int IP_CONST_ONHIT_CASTSPELL_DISPEL_MAGIC                       = 13;
int IP_CONST_ONHIT_CASTSPELL_DOOM                               = 14;
int IP_CONST_ONHIT_CASTSPELL_ENERGY_DRAIN                       = 15;
int IP_CONST_ONHIT_CASTSPELL_ENERVATION                         = 16;
int IP_CONST_ONHIT_CASTSPELL_ENTANGLE                           = 17;
int IP_CONST_ONHIT_CASTSPELL_FEAR                               = 18;
int IP_CONST_ONHIT_CASTSPELL_FEEBLEMIND                         = 19;
int IP_CONST_ONHIT_CASTSPELL_FIRE_STORM                         = 20;
int IP_CONST_ONHIT_CASTSPELL_FIREBALL                           = 21;
int IP_CONST_ONHIT_CASTSPELL_FLAME_LASH                         = 22;
int IP_CONST_ONHIT_CASTSPELL_FLAME_STRIKE                       = 23;
int IP_CONST_ONHIT_CASTSPELL_GHOUL_TOUCH                        = 24;
int IP_CONST_ONHIT_CASTSPELL_GREASE                             = 25;
int IP_CONST_ONHIT_CASTSPELL_GREATER_DISPELLING                 = 26;
int IP_CONST_ONHIT_CASTSPELL_GREATER_SPELL_BREACH               = 27;
int IP_CONST_ONHIT_CASTSPELL_GUST_OF_WIND                       = 28;
int IP_CONST_ONHIT_CASTSPELL_HAMMER_OF_THE_GODS                 = 29;
int IP_CONST_ONHIT_CASTSPELL_HARM                               = 30;
int IP_CONST_ONHIT_CASTSPELL_HOLD_ANIMAL                        = 31;
int IP_CONST_ONHIT_CASTSPELL_HOLD_MONSTER                       = 32;
int IP_CONST_ONHIT_CASTSPELL_HOLD_PERSON                        = 33;
int IP_CONST_ONHIT_CASTSPELL_IMPLOSION                          = 34;
int IP_CONST_ONHIT_CASTSPELL_INCENDIARY_CLOUD                   = 35;
int IP_CONST_ONHIT_CASTSPELL_LESSER_DISPEL                      = 36;
int IP_CONST_ONHIT_CASTSPELL_LESSER_SPELL_BREACH                = 38;
int IP_CONST_ONHIT_CASTSPELL_LIGHT                              = 40;
int IP_CONST_ONHIT_CASTSPELL_LIGHTNING_BOLT                     = 41;
int IP_CONST_ONHIT_CASTSPELL_MAGIC_MISSILE                      = 42;
int IP_CONST_ONHIT_CASTSPELL_MASS_BLINDNESS_AND_DEAFNESS        = 43;
int IP_CONST_ONHIT_CASTSPELL_MASS_CHARM                         = 44;
int IP_CONST_ONHIT_CASTSPELL_MELFS_ACID_ARROW                   = 45;
int IP_CONST_ONHIT_CASTSPELL_METEOR_SWARM                       = 46;
int IP_CONST_ONHIT_CASTSPELL_MIND_FOG                           = 47;
int IP_CONST_ONHIT_CASTSPELL_PHANTASMAL_KILLER                  = 49;
int IP_CONST_ONHIT_CASTSPELL_POISON                             = 50;
int IP_CONST_ONHIT_CASTSPELL_POWER_WORD_KILL                    = 51;
int IP_CONST_ONHIT_CASTSPELL_POWER_WORD_STUN                    = 52;

int IP_CONST_ONHIT_CASTSPELL_CAUSE_FEAR                         = 54;   // JLR - OEI 07/11/05 -- Name changed from "Scare"
int IP_CONST_ONHIT_CASTSPELL_SEARING_LIGHT                      = 55;
int IP_CONST_ONHIT_CASTSPELL_SILENCE                            = 56;
int IP_CONST_ONHIT_CASTSPELL_SLAY_LIVING                        = 57;
int IP_CONST_ONHIT_CASTSPELL_SLEEP                              = 58;
int IP_CONST_ONHIT_CASTSPELL_SLOW                               = 59;
int IP_CONST_ONHIT_CASTSPELL_SOUND_BURST                        = 60;
int IP_CONST_ONHIT_CASTSPELL_STINKING_CLOUD                     = 61;

int IP_CONST_ONHIT_CASTSPELL_STORM_OF_VENGEANCE                 = 63;
int IP_CONST_ONHIT_CASTSPELL_SUNBEAM                            = 64;
int IP_CONST_ONHIT_CASTSPELL_VAMPIRIC_TOUCH                     = 65;
int IP_CONST_ONHIT_CASTSPELL_WAIL_OF_THE_BANSHEE                = 66;
int IP_CONST_ONHIT_CASTSPELL_WALL_OF_FIRE                       = 67;
int IP_CONST_ONHIT_CASTSPELL_WEB                                = 68;
int IP_CONST_ONHIT_CASTSPELL_WEIRD                              = 69;
int IP_CONST_ONHIT_CASTSPELL_WORD_OF_FAITH                      = 70;

int IP_CONST_ONHIT_CASTSPELL_CREEPING_DOOM                      = 72;
int IP_CONST_ONHIT_CASTSPELL_DESTRUCTION                        = 73;
int IP_CONST_ONHIT_CASTSPELL_HORRID_WILTING                     = 74;
int IP_CONST_ONHIT_CASTSPELL_ICE_STORM                          = 75;
int IP_CONST_ONHIT_CASTSPELL_NEGATIVE_ENERGY_BURST              = 76;
int IP_CONST_ONHIT_CASTSPELL_EVARDS_BLACK_TENTACLES             = 77;
int IP_CONST_ONHIT_CASTSPELL_ACTIVATE_ITEM                      = 78;
int IP_CONST_ONHIT_CASTSPELL_FLARE                              = 79;
int IP_CONST_ONHIT_CASTSPELL_BOMBARDMENT                        = 80;
int IP_CONST_ONHIT_CASTSPELL_ACID_SPLASH                        = 81;
int IP_CONST_ONHIT_CASTSPELL_QUILLFIRE                          = 82;
int IP_CONST_ONHIT_CASTSPELL_EARTHQUAKE                         = 83;
int IP_CONST_ONHIT_CASTSPELL_SUNBURST                           = 84;
int IP_CONST_ONHIT_CASTSPELL_BANISHMENT                         = 85;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_MINOR_WOUNDS               = 86;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_LIGHT_WOUNDS               = 87;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_MODERATE_WOUNDS            = 88;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_SERIOUS_WOUNDS             = 89;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_CRITICAL_WOUNDS            = 90;
int IP_CONST_ONHIT_CASTSPELL_BALAGARNSIRONHORN                  = 91;
int IP_CONST_ONHIT_CASTSPELL_DROWN                              = 92;
int IP_CONST_ONHIT_CASTSPELL_ELECTRIC_JOLT                      = 93;
int IP_CONST_ONHIT_CASTSPELL_FIREBRAND                          = 94;
int IP_CONST_ONHIT_CASTSPELL_WOUNDING_WHISPERS                  = 95;
int IP_CONST_ONHIT_CASTSPELL_UNDEATHS_ETERNAL_FOE               = 96;
int IP_CONST_ONHIT_CASTSPELL_INFERNO                            = 97;
int IP_CONST_ONHIT_CASTSPELL_ISAACS_LESSER_MISSILE_STORM        = 98;
int IP_CONST_ONHIT_CASTSPELL_ISAACS_GREATER_MISSILE_STORM       = 99;
int IP_CONST_ONHIT_CASTSPELL_BANE                               = 100;
int IP_CONST_ONHIT_CASTSPELL_SPIKE_GROWTH                       = 101;
int IP_CONST_ONHIT_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER            = 102;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_INTERPOSING_HAND            = 103;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_FORCEFUL_HAND               = 104;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_GRASPING_HAND               = 105;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_CLENCHED_FIST               = 106;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_CRUSHING_HAND               = 107;
int IP_CONST_ONHIT_CASTSPELL_FLESH_TO_STONE                     = 108;
int IP_CONST_ONHIT_CASTSPELL_STONE_TO_FLESH                     = 109;
int IP_CONST_ONHIT_CASTSPELL_CRUMBLE                            = 110;
int IP_CONST_ONHIT_CASTSPELL_INFESTATION_OF_MAGGOTS             = 111;
int IP_CONST_ONHIT_CASTSPELL_GREAT_THUNDERCLAP                  = 112;
int IP_CONST_ONHIT_CASTSPELL_BALL_LIGHTNING                     = 113;
int IP_CONST_ONHIT_CASTSPELL_GEDLEES_ELECTRIC_LOOP              = 114;
int IP_CONST_ONHIT_CASTSPELL_HORIZIKAULS_BOOM                   = 115;
int IP_CONST_ONHIT_CASTSPELL_MESTILS_ACID_BREATH                = 116;
int IP_CONST_ONHIT_CASTSPELL_SCINTILLATING_SPHERE               = 117;
int IP_CONST_ONHIT_CASTSPELL_UNDEATH_TO_DEATH                   = 118;
int IP_CONST_ONHIT_CASTSPELL_STONEHOLD                          = 119;

int IP_CONST_ONHIT_CASTSPELL_EVIL_BLIGHT                        = 121;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_TELEPORT                     = 122;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_SLAYRAKSHASA                 = 123;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE                   = 124;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER                  = 125;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_PLANARRIFT                   = 126;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE                     = 127;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_EXTRACTBRAIN                 = 128;
int IP_CONST_ONHIT_CASTSPELL_ONHITFLAMINGSKIN                   = 129;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_CHAOSSHIELD                  = 130;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_CONSTRICTWEAPON              = 131;
int IP_CONST_ONHIT_CASTSPELL_ONHITRUINARMORBEBILITH             = 132;
int IP_CONST_ONHIT_CASTSPELL_ONHITDEMILICHTOUCH                 = 133;
int IP_CONST_ONHIT_CASTSPELL_ONHITDRACOLICHTOUCH                = 134;
int IP_CONST_ONHIT_CASTSPELL_INTELLIGENT_WEAPON_ONHIT           = 135;
int IP_CONST_ONHIT_CASTSPELL_PARALYZE_2                         = 136;
int IP_CONST_ONHIT_CASTSPELL_DEAFENING_CLNG                     = 137;
int IP_CONST_ONHIT_CASTSPELL_KNOCKDOWN                          = 138;
int IP_CONST_ONHIT_CASTSPELL_FREEZE                             = 139;
int IP_CONST_ONHIT_CASTSPELL_COMBUST                            = 140;

int IP_CONST_POISON_1D2_STRDAMAGE               = 0;
int IP_CONST_POISON_1D2_DEXDAMAGE               = 1;
int IP_CONST_POISON_1D2_CONDAMAGE               = 2;
int IP_CONST_POISON_1D2_INTDAMAGE               = 3;
int IP_CONST_POISON_1D2_WISDAMAGE               = 4;
int IP_CONST_POISON_1D2_CHADAMAGE               = 5;
int IP_CONST_CONTAINERWEIGHTRED_20_PERCENT      = 1;
int IP_CONST_CONTAINERWEIGHTRED_40_PERCENT      = 2;
int IP_CONST_CONTAINERWEIGHTRED_60_PERCENT      = 3;
int IP_CONST_CONTAINERWEIGHTRED_80_PERCENT      = 4;
int IP_CONST_CONTAINERWEIGHTRED_100_PERCENT     = 5;
int IP_CONST_DAMAGERESIST_5                     = 1;
int IP_CONST_DAMAGERESIST_10                    = 2;
int IP_CONST_DAMAGERESIST_15                    = 3;
int IP_CONST_DAMAGERESIST_20                    = 4;
int IP_CONST_DAMAGERESIST_25                    = 5;
int IP_CONST_DAMAGERESIST_30                    = 6;
int IP_CONST_DAMAGERESIST_35                    = 7;
int IP_CONST_DAMAGERESIST_40                    = 8;
int IP_CONST_DAMAGERESIST_45                    = 9;
int IP_CONST_DAMAGERESIST_50                    = 10;
int IP_CONST_SAVEVS_ACID                        = 1;
int IP_CONST_SAVEVS_COLD                        = 3;
int IP_CONST_SAVEVS_DEATH                       = 4;
int IP_CONST_SAVEVS_DISEASE                     = 5;
int IP_CONST_SAVEVS_DIVINE                      = 6;
int IP_CONST_SAVEVS_ELECTRICAL                  = 7;
int IP_CONST_SAVEVS_FEAR                        = 8;
int IP_CONST_SAVEVS_FIRE                        = 9;
int IP_CONST_SAVEVS_MINDAFFECTING               = 11;
int IP_CONST_SAVEVS_NEGATIVE                    = 12;
int IP_CONST_SAVEVS_POISON                      = 13;
int IP_CONST_SAVEVS_POSITIVE                    = 14;
int IP_CONST_SAVEVS_SONIC                       = 15;
int IP_CONST_SAVEVS_UNIVERSAL                   = 0;
int IP_CONST_SAVEBASETYPE_ALL           = 0;    // AFW-OEI 05/02/2007
int IP_CONST_SAVEBASETYPE_FORTITUDE             = 1;
int IP_CONST_SAVEBASETYPE_WILL                  = 2;
int IP_CONST_SAVEBASETYPE_REFLEX                = 3;
int IP_CONST_DAMAGESOAK_5_HP                    = 1;
int IP_CONST_DAMAGESOAK_10_HP                   = 2;
int IP_CONST_DAMAGESOAK_15_HP                   = 3;
int IP_CONST_DAMAGESOAK_20_HP                   = 4;
int IP_CONST_DAMAGESOAK_25_HP                   = 5;
int IP_CONST_DAMAGESOAK_30_HP                   = 6;
int IP_CONST_DAMAGESOAK_35_HP                   = 7;
int IP_CONST_DAMAGESOAK_40_HP                   = 8;
int IP_CONST_DAMAGESOAK_45_HP                   = 9;
int IP_CONST_DAMAGESOAK_50_HP                   = 10;
int IP_CONST_DAMAGEREDUCTION_1                  = 0;
int IP_CONST_DAMAGEREDUCTION_2                  = 1;
int IP_CONST_DAMAGEREDUCTION_3                  = 2;
int IP_CONST_DAMAGEREDUCTION_4                  = 3;
int IP_CONST_DAMAGEREDUCTION_5                  = 4;
int IP_CONST_DAMAGEREDUCTION_6                  = 5;
int IP_CONST_DAMAGEREDUCTION_7                  = 6;
int IP_CONST_DAMAGEREDUCTION_8                  = 7;
int IP_CONST_DAMAGEREDUCTION_9                  = 8;
int IP_CONST_DAMAGEREDUCTION_10                 = 9;
int IP_CONST_DAMAGEREDUCTION_11                 = 10;
int IP_CONST_DAMAGEREDUCTION_12                 = 11;
int IP_CONST_DAMAGEREDUCTION_13                 = 12;
int IP_CONST_DAMAGEREDUCTION_14                 = 13;
int IP_CONST_DAMAGEREDUCTION_15                 = 14;
int IP_CONST_DAMAGEREDUCTION_16                 = 15;
int IP_CONST_DAMAGEREDUCTION_17                 = 16;
int IP_CONST_DAMAGEREDUCTION_18                 = 17;
int IP_CONST_DAMAGEREDUCTION_19                 = 18;
int IP_CONST_DAMAGEREDUCTION_20                 = 19;

int IP_CONST_IMMUNITYSPELL_ACID_FOG                       = 0;
int IP_CONST_IMMUNITYSPELL_AID                            = 1;
int IP_CONST_IMMUNITYSPELL_BARKSKIN                       = 2;
int IP_CONST_IMMUNITYSPELL_BESTOW_CURSE                   = 3;
int IP_CONST_IMMUNITYSPELL_BLINDNESS_AND_DEAFNESS         = 6;
int IP_CONST_IMMUNITYSPELL_BURNING_HANDS                  = 8;
int IP_CONST_IMMUNITYSPELL_CALL_LIGHTNING                 = 9;
int IP_CONST_IMMUNITYSPELL_CHAIN_LIGHTNING                = 12;
int IP_CONST_IMMUNITYSPELL_CHARM_MONSTER                  = 13;
int IP_CONST_IMMUNITYSPELL_CHARM_PERSON                   = 14;
int IP_CONST_IMMUNITYSPELL_CHARM_PERSON_OR_ANIMAL         = 15;
int IP_CONST_IMMUNITYSPELL_CIRCLE_OF_DEATH                = 16;
int IP_CONST_IMMUNITYSPELL_CIRCLE_OF_DOOM                 = 17;
int IP_CONST_IMMUNITYSPELL_CLOUDKILL                      = 21;
int IP_CONST_IMMUNITYSPELL_COLOR_SPRAY                    = 22;
int IP_CONST_IMMUNITYSPELL_CONE_OF_COLD                   = 23;
int IP_CONST_IMMUNITYSPELL_CONFUSION                      = 24;
int IP_CONST_IMMUNITYSPELL_CONTAGION                      = 25;
int IP_CONST_IMMUNITYSPELL_CONTROL_UNDEAD                 = 26;
int IP_CONST_IMMUNITYSPELL_CURE_CRITICAL_WOUNDS           = 27;
int IP_CONST_IMMUNITYSPELL_CURE_LIGHT_WOUNDS              = 28;
int IP_CONST_IMMUNITYSPELL_CURE_MINOR_WOUNDS              = 29;
int IP_CONST_IMMUNITYSPELL_CURE_MODERATE_WOUNDS           = 30;
int IP_CONST_IMMUNITYSPELL_CURE_SERIOUS_WOUNDS            = 31;
int IP_CONST_IMMUNITYSPELL_DARKNESS                       = 32;
int IP_CONST_IMMUNITYSPELL_DAZE                           = 33;
int IP_CONST_IMMUNITYSPELL_DEATH_WARD                     = 34;
int IP_CONST_IMMUNITYSPELL_DELAYED_BLAST_FIREBALL         = 35;
int IP_CONST_IMMUNITYSPELL_DISMISSAL                      = 36;
int IP_CONST_IMMUNITYSPELL_DISPEL_MAGIC                   = 37;
int IP_CONST_IMMUNITYSPELL_DOMINATE_ANIMAL                = 39;
int IP_CONST_IMMUNITYSPELL_DOMINATE_MONSTER               = 40;
int IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON                = 41;
int IP_CONST_IMMUNITYSPELL_DOOM                           = 42;
int IP_CONST_IMMUNITYSPELL_ENERGY_DRAIN                   = 46;
int IP_CONST_IMMUNITYSPELL_ENERVATION                     = 47;
int IP_CONST_IMMUNITYSPELL_ENTANGLE                       = 48;
int IP_CONST_IMMUNITYSPELL_FEAR                           = 49;
int IP_CONST_IMMUNITYSPELL_FEEBLEMIND                     = 50;
int IP_CONST_IMMUNITYSPELL_FINGER_OF_DEATH                = 51;
int IP_CONST_IMMUNITYSPELL_FIRE_STORM                     = 52;
int IP_CONST_IMMUNITYSPELL_FIREBALL                       = 53;
int IP_CONST_IMMUNITYSPELL_FLAME_ARROW                    = 54;
int IP_CONST_IMMUNITYSPELL_FLAME_LASH                     = 55;
int IP_CONST_IMMUNITYSPELL_FLAME_STRIKE                   = 56;
int IP_CONST_IMMUNITYSPELL_FREEDOM_OF_MOVEMENT            = 57;
int IP_CONST_IMMUNITYSPELL_GREASE                         = 59;
int IP_CONST_IMMUNITYSPELL_GREATER_DISPELLING             = 60;
int IP_CONST_IMMUNITYSPELL_GREATER_PLANAR_BINDING         = 62;
int IP_CONST_IMMUNITYSPELL_GREATER_SHADOW_CONJURATION     = 64;
int IP_CONST_IMMUNITYSPELL_GREATER_SPELL_BREACH           = 65;
int IP_CONST_IMMUNITYSPELL_HAMMER_OF_THE_GODS             = 68;
int IP_CONST_IMMUNITYSPELL_HARM                           = 69;
int IP_CONST_IMMUNITYSPELL_HEAL                           = 71;
int IP_CONST_IMMUNITYSPELL_HEALING_CIRCLE                 = 72;
int IP_CONST_IMMUNITYSPELL_HOLD_ANIMAL                    = 73;
int IP_CONST_IMMUNITYSPELL_HOLD_MONSTER                   = 74;
int IP_CONST_IMMUNITYSPELL_HOLD_PERSON                    = 75;
int IP_CONST_IMMUNITYSPELL_IMPLOSION                      = 78;
int IP_CONST_IMMUNITYSPELL_GREATER_INVISIBILITY           = 79; // JLR - OEI 07/11/05 -- Name changed from "Improved"
int IP_CONST_IMMUNITYSPELL_INCENDIARY_CLOUD               = 80;
int IP_CONST_IMMUNITYSPELL_INVISIBILITY_PURGE             = 82;
int IP_CONST_IMMUNITYSPELL_LESSER_DISPEL                  = 84;
int IP_CONST_IMMUNITYSPELL_LESSER_PLANAR_BINDING          = 86;
int IP_CONST_IMMUNITYSPELL_LESSER_SPELL_BREACH            = 88;
int IP_CONST_IMMUNITYSPELL_LIGHTNING_BOLT                 = 91;
int IP_CONST_IMMUNITYSPELL_MAGIC_MISSILE                  = 97;
int IP_CONST_IMMUNITYSPELL_MASS_BLINDNESS_AND_DEAFNESS    = 100;
int IP_CONST_IMMUNITYSPELL_MASS_CHARM                     = 101;
int IP_CONST_IMMUNITYSPELL_MASS_HEAL                      = 104;
int IP_CONST_IMMUNITYSPELL_MELFS_ACID_ARROW               = 105;
int IP_CONST_IMMUNITYSPELL_METEOR_SWARM                   = 106;
int IP_CONST_IMMUNITYSPELL_MIND_FOG                       = 108;
int IP_CONST_IMMUNITYSPELL_MORDENKAINENS_DISJUNCTION      = 112;
int IP_CONST_IMMUNITYSPELL_PHANTASMAL_KILLER              = 116;
int IP_CONST_IMMUNITYSPELL_PLANAR_BINDING                 = 117;
int IP_CONST_IMMUNITYSPELL_POISON                         = 118;
int IP_CONST_IMMUNITYSPELL_POWER_WORD_KILL                = 120;
int IP_CONST_IMMUNITYSPELL_POWER_WORD_STUN                = 121;
int IP_CONST_IMMUNITYSPELL_PRISMATIC_SPRAY                = 124;
int IP_CONST_IMMUNITYSPELL_RAY_OF_ENFEEBLEMENT            = 131;
int IP_CONST_IMMUNITYSPELL_RAY_OF_FROST                   = 132;
int IP_CONST_IMMUNITYSPELL_CAUSE_FEAR                     = 142;    // JLR - OEI 07/11/05 -- Name changed from "Scare"
int IP_CONST_IMMUNITYSPELL_SEARING_LIGHT                  = 143;
int IP_CONST_IMMUNITYSPELL_SHADES                         = 145;
int IP_CONST_IMMUNITYSPELL_SHADOW_CONJURATION             = 146;
int IP_CONST_IMMUNITYSPELL_SILENCE                        = 150;
int IP_CONST_IMMUNITYSPELL_SLAY_LIVING                    = 151;
int IP_CONST_IMMUNITYSPELL_SLEEP                          = 152;
int IP_CONST_IMMUNITYSPELL_SLOW                           = 153;
int IP_CONST_IMMUNITYSPELL_SOUND_BURST                    = 154;
int IP_CONST_IMMUNITYSPELL_STINKING_CLOUD                 = 158;
int IP_CONST_IMMUNITYSPELL_STONESKIN                      = 159;
int IP_CONST_IMMUNITYSPELL_STORM_OF_VENGEANCE             = 160;
int IP_CONST_IMMUNITYSPELL_SUNBEAM                        = 161;
int IP_CONST_IMMUNITYSPELL_VIRTUE                         = 165;
int IP_CONST_IMMUNITYSPELL_WAIL_OF_THE_BANSHEE            = 166;
int IP_CONST_IMMUNITYSPELL_WEB                            = 167;
int IP_CONST_IMMUNITYSPELL_WEIRD                          = 168;
int IP_CONST_IMMUNITYSPELL_WORD_OF_FAITH                  = 169;
int IP_CONST_IMMUNITYSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT = 171;
int IP_CONST_IMMUNITYSPELL_EAGLE_SPLEDOR                  = 173;
int IP_CONST_IMMUNITYSPELL_OWLS_WISDOM                    = 174;
int IP_CONST_IMMUNITYSPELL_FOXS_CUNNING                   = 175;
int IP_CONST_IMMUNITYSPELL_GREATER_EAGLES_SPLENDOR        = 176;
int IP_CONST_IMMUNITYSPELL_GREATER_OWLS_WISDOM            = 177;
int IP_CONST_IMMUNITYSPELL_GREATER_FOXS_CUNNING           = 178;
int IP_CONST_IMMUNITYSPELL_GREATER_BULLS_STRENGTH         = 179;
int IP_CONST_IMMUNITYSPELL_GREATER_CATS_GRACE             = 180;
int IP_CONST_IMMUNITYSPELL_GREATER_BEARS_ENDURANCE        = 181;    // JLR - OEI 07/11/05 -- Name Changed
int IP_CONST_IMMUNITYSPELL_AURA_OF_VITALITY               = 182;
int IP_CONST_IMMUNITYSPELL_WAR_CRY                        = 183;
int IP_CONST_IMMUNITYSPELL_REGENERATE                     = 184;
int IP_CONST_IMMUNITYSPELL_EVARDS_BLACK_TENTACLES         = 185;
int IP_CONST_IMMUNITYSPELL_LEGEND_LORE                    = 186;
int IP_CONST_IMMUNITYSPELL_FIND_TRAPS                     = 187;
int IP_CONST_SPELLLEVEL_0                       = 0; // hmm are these necessary?
int IP_CONST_SPELLLEVEL_1                       = 1;
int IP_CONST_SPELLLEVEL_2                       = 2;
int IP_CONST_SPELLLEVEL_3                       = 3;
int IP_CONST_SPELLLEVEL_4                       = 4;
int IP_CONST_SPELLLEVEL_5                       = 5;
int IP_CONST_SPELLLEVEL_6                       = 6;
int IP_CONST_SPELLLEVEL_7                       = 7;
int IP_CONST_SPELLLEVEL_8                       = 8;
int IP_CONST_SPELLLEVEL_9                       = 9;
int IP_CONST_CASTSPELL_ACID_FOG_11                      = 0;
int IP_CONST_CASTSPELL_ACID_SPLASH_1                    = 355;
int IP_CONST_CASTSPELL_ACTIVATE_ITEM                    = 359;
int IP_CONST_CASTSPELL_AID_3                            = 1;
int IP_CONST_CASTSPELL_AMPLIFY_5                        = 373;
int IP_CONST_CASTSPELL_ANIMATE_DEAD_10                  = 3;
int IP_CONST_CASTSPELL_ANIMATE_DEAD_15                  = 4;
int IP_CONST_CASTSPELL_ANIMATE_DEAD_5                   = 2;
int IP_CONST_CASTSPELL_ANTIMAGIC_EDGE                   = 704;
int IP_CONST_CASTSPELL_ASSAY_RESISTANCE_7       = 541; // CG OEI 07/13/05 -- Added
int IP_CONST_CASTSPELL_AURA_OF_VITALITY_13              = 321;
int IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15         = 287;
int IP_CONST_CASTSPELL_AURAOFGLORY_7                    = 360;
int IP_CONST_CASTSPELL_AWAKEN_9                         = 303;
int IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7              = 367;
int IP_CONST_CASTSPELL_BANE_5                           = 380;
int IP_CONST_CASTSPELL_BANISHMENT_15                    = 361;
int IP_CONST_CASTSPELL_BARKSKIN_12                      = 7;
int IP_CONST_CASTSPELL_BARKSKIN_3                       = 5;
int IP_CONST_CASTSPELL_BARKSKIN_6                       = 6;
int IP_CONST_CASTSPELL_BESTOW_CURSE_5                   = 8;
int IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20          = 393;
int IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20          = 394;
int IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15          = 391;
int IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17          = 392;
int IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15       = 390;
int IP_CONST_CASTSPELL_BLADE_BARRIER_11                 = 9;
int IP_CONST_CASTSPELL_BLADE_BARRIER_15                 = 10;
int IP_CONST_CASTSPELL_BLESS_2                          = 11;
int IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3             = 14;
int IP_CONST_CASTSPELL_BLOOD_FRENZY_7                   = 353;
int IP_CONST_CASTSPELL_BOMBARDMENT_20                   = 354;
int IP_CONST_CASTSPELL_BULLS_STRENGTH_10                = 16;
int IP_CONST_CASTSPELL_BULLS_STRENGTH_15                = 17;
int IP_CONST_CASTSPELL_BULLS_STRENGTH_3                 = 15;
int IP_CONST_CASTSPELL_BURNING_HANDS_2                  = 18;
int IP_CONST_CASTSPELL_BURNING_HANDS_5                  = 19;
int IP_CONST_CASTSPELL_CALL_LIGHTNING_10                = 21;
int IP_CONST_CASTSPELL_CALL_LIGHTNING_5                 = 20;
int IP_CONST_CASTSPELL_CAMOFLAGE_5                      = 352;
int IP_CONST_CASTSPELL_CATS_GRACE_10                    = 26;
int IP_CONST_CASTSPELL_CATS_GRACE_15                    = 27;
int IP_CONST_CASTSPELL_CATS_GRACE_3                     = 25;
int IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11               = 28;
int IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15               = 29;
int IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20               = 30;
int IP_CONST_CASTSPELL_CHARM_MONSTER_10                 = 32;
int IP_CONST_CASTSPELL_CHARM_MONSTER_5                  = 31;
int IP_CONST_CASTSPELL_CHARM_PERSON_10                  = 34;
int IP_CONST_CASTSPELL_CHARM_PERSON_2                   = 33;
int IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10        = 36;
int IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3         = 35;
int IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11               = 37;
int IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15               = 38;
int IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20               = 39;
int IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_15                = 41;
int IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_20                = 42;
int IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_9                 = 40;
int IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10    = 44;
int IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15    = 45;
int IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5     = 43;
int IP_CONST_CASTSPELL_CLARITY_3                        = 46;
int IP_CONST_CASTSPELL_CLOUDKILL_9                      = 48;
int IP_CONST_CASTSPELL_COLOR_SPRAY_2                    = 49;
int IP_CONST_CASTSPELL_CONE_OF_COLD_15                  = 51;
int IP_CONST_CASTSPELL_CONE_OF_COLD_9                   = 50;
int IP_CONST_CASTSPELL_CONFUSION_10                     = 53;
int IP_CONST_CASTSPELL_CONFUSION_5                      = 52;
int IP_CONST_CASTSPELL_CONTAGION_5                      = 54;
int IP_CONST_CASTSPELL_CONTINUAL_FLAME_7                = 350;
int IP_CONST_CASTSPELL_CONTROL_UNDEAD_13                = 55;
int IP_CONST_CASTSPELL_CONTROL_UNDEAD_20                = 56;
int IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15         = 57;
int IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16         = 58;
int IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18         = 59;
int IP_CONST_CASTSPELL_CREATE_UNDEAD_11                 = 60;
int IP_CONST_CASTSPELL_CREATE_UNDEAD_14                 = 61;
int IP_CONST_CASTSPELL_CREATE_UNDEAD_16                 = 62;
int IP_CONST_CASTSPELL_CREEPING_DOOM_13                 = 304;
int IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12          = 64;
int IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15          = 65;
int IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7           = 63;
int IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2              = 66;
int IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5              = 67;
int IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1              = 68;
int IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10          = 71;
int IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3           = 69;
int IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6           = 70;
int IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10           = 73;
int IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5            = 72;
int IP_CONST_CASTSPELL_DARKNESS_3                       = 75;
int IP_CONST_CASTSPELL_DARKVISION_3                     = 305;
int IP_CONST_CASTSPELL_DARKVISION_6                     = 306;
int IP_CONST_CASTSPELL_DAZE_1                           = 76;
int IP_CONST_CASTSPELL_DEATH_WARD_7                     = 77;
int IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13        = 78;
int IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15        = 79;
int IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20        = 80;
int IP_CONST_CASTSPELL_DESTRUCTION_13                   = 307;
int IP_CONST_CASTSPELL_DIRGE_15                         = 376;
int IP_CONST_CASTSPELL_DISMISSAL_12                     = 82;
int IP_CONST_CASTSPELL_DISMISSAL_18                     = 83;
int IP_CONST_CASTSPELL_DISMISSAL_7                      = 81;
int IP_CONST_CASTSPELL_DISPEL_MAGIC_10                  = 85;
int IP_CONST_CASTSPELL_DISPEL_MAGIC_5                   = 84;
int IP_CONST_CASTSPELL_DISPLACEMENT_9                   = 389;
int IP_CONST_CASTSPELL_DIVINE_FAVOR_5                   = 345;
int IP_CONST_CASTSPELL_DIVINE_MIGHT_5                   = 395;
int IP_CONST_CASTSPELL_DIVINE_POWER_7                   = 86;
int IP_CONST_CASTSPELL_DIVINE_SHIELD_5                  = 396;
int IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5                = 87;
int IP_CONST_CASTSPELL_DOMINATE_MONSTER_17              = 88;
int IP_CONST_CASTSPELL_DOMINATE_PERSON_7                = 89;
int IP_CONST_CASTSPELL_DOOM_2                           = 90;
int IP_CONST_CASTSPELL_DOOM_5                           = 91;
int IP_CONST_CASTSPELL_DRAGON_BREATH_ACID_10            = 400;
int IP_CONST_CASTSPELL_DRAGON_BREATH_COLD_10            = 401;
int IP_CONST_CASTSPELL_DRAGON_BREATH_FEAR_10            = 402;
int IP_CONST_CASTSPELL_DRAGON_BREATH_FIRE_10            = 403;
int IP_CONST_CASTSPELL_DRAGON_BREATH_GAS_10             = 404;
int IP_CONST_CASTSPELL_DRAGON_BREATH_LIGHTNING_10       = 405;
int IP_CONST_CASTSPELL_DRAGON_BREATH_PARALYZE_10        = 406;
int IP_CONST_CASTSPELL_DRAGON_BREATH_SLEEP_10           = 407;
int IP_CONST_CASTSPELL_DRAGON_BREATH_SLOW_10            = 408;
int IP_CONST_CASTSPELL_DRAGON_BREATH_WEAKEN_10          = 409;
int IP_CONST_CASTSPELL_DROWN_15                         = 368;
int IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10                 = 289;
int IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15                 = 290;
int IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3                  = 288;
int IP_CONST_CASTSPELL_EARTHQUAKE_20                    = 357;
int IP_CONST_CASTSPELL_ELECTRIC_JOLT_1                  = 370;
int IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12              = 93;
int IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7               = 92;
int IP_CONST_CASTSPELL_ELEMENTAL_SWARM_17               = 94;
int IP_CONST_CASTSPELL_ENDURANCE_10                     = 96;
int IP_CONST_CASTSPELL_ENDURANCE_15                     = 97;
int IP_CONST_CASTSPELL_ENDURANCE_3                      = 95;
int IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2                = 98;
int IP_CONST_CASTSPELL_ENERGY_BUFFER_11                 = 311;
int IP_CONST_CASTSPELL_ENERGY_BUFFER_15                 = 312;
int IP_CONST_CASTSPELL_ENERGY_BUFFER_20                 = 313;
int IP_CONST_CASTSPELL_ENERGY_DRAIN_17                  = 99;
int IP_CONST_CASTSPELL_ENERVATION_7                     = 100;
int IP_CONST_CASTSPELL_ENTANGLE_2                       = 101;
int IP_CONST_CASTSPELL_ENTANGLE_5                       = 102;
int IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5                = 349;
int IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15               = 196;
int IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9                = 195;
int IP_CONST_CASTSPELL_ETHEREALNESS_18                  = 374;
int IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15        = 325;
int IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7         = 324;
int IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5            = 387;
int IP_CONST_CASTSPELL_FEAR_5                           = 103;
int IP_CONST_CASTSPELL_FEEBLEMIND_9                     = 104;
int IP_CONST_CASTSPELL_FIND_TRAPS_3                     = 327;
int IP_CONST_CASTSPELL_FINGER_OF_DEATH_13               = 105;
int IP_CONST_CASTSPELL_FIRE_STORM_13                    = 106;
int IP_CONST_CASTSPELL_FIRE_STORM_18                    = 107;
int IP_CONST_CASTSPELL_FIREBALL_10                      = 109;
int IP_CONST_CASTSPELL_FIREBALL_5                       = 108;
int IP_CONST_CASTSPELL_FIREBRAND_15                     = 371;
int IP_CONST_CASTSPELL_FLAME_ARROW_12                   = 111;
int IP_CONST_CASTSPELL_FLAME_ARROW_18                   = 112;
int IP_CONST_CASTSPELL_FLAME_ARROW_5                    = 110;
int IP_CONST_CASTSPELL_FLAME_LASH_10                    = 114;
int IP_CONST_CASTSPELL_FLAME_LASH_3                     = 113;
int IP_CONST_CASTSPELL_FLAME_STRIKE_12                  = 116;
int IP_CONST_CASTSPELL_FLAME_STRIKE_18                  = 117;
int IP_CONST_CASTSPELL_FLAME_STRIKE_7                   = 115;
int IP_CONST_CASTSPELL_FLARE_1                          = 347;
int IP_CONST_CASTSPELL_FLESH_TO_STONE_5                 = 398;
int IP_CONST_CASTSPELL_FOXS_CUNNING_10                  = 295;
int IP_CONST_CASTSPELL_FOXS_CUNNING_15                  = 296;
int IP_CONST_CASTSPELL_FOXS_CUNNING_3                   = 294;
int IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7            = 118;
int IP_CONST_CASTSPELL_GATE_17                          = 119;
int IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15                = 194;
int IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3                 = 192;
int IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9                 = 193;
int IP_CONST_CASTSPELL_GHOUL_TOUCH_3                    = 120;
int IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11      = 121;
int IP_CONST_CASTSPELL_GREASE_2                         = 122;
int IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11        = 300;
int IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11            = 301;
int IP_CONST_CASTSPELL_GREATER_DISPELLING_15            = 124;
int IP_CONST_CASTSPELL_GREATER_DISPELLING_7             = 123;
int IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11       = 297;
int IP_CONST_CASTSPELL_GREATER_ENDURANCE_11             = 302;
int IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11          = 299;
int IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9             = 384;
int IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11           = 298;
int IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15        = 126;
int IP_CONST_CASTSPELL_GREATER_RESTORATION_13           = 127;
int IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9     = 128;
int IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11          = 129;
int IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17          = 130;
int IP_CONST_CASTSPELL_GREATER_STONESKIN_11             = 131;
int IP_CONST_CASTSPELL_GRENADE_ACID_1                   = 341;
int IP_CONST_CASTSPELL_GRENADE_CALTROPS_1               = 343;
int IP_CONST_CASTSPELL_GRENADE_CHICKEN_1                = 342;
int IP_CONST_CASTSPELL_GRENADE_CHOKING_1                = 339;
int IP_CONST_CASTSPELL_GRENADE_FIRE_1                   = 336;
int IP_CONST_CASTSPELL_GRENADE_HOLY_1                   = 338;
int IP_CONST_CASTSPELL_GRENADE_TANGLE_1                 = 337;
int IP_CONST_CASTSPELL_GRENADE_THUNDERSTONE_1           = 340;
int IP_CONST_CASTSPELL_GUST_OF_WIND_10                  = 410;
int IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12            = 134;
int IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7             = 133;
int IP_CONST_CASTSPELL_HARM_11                          = 136;
int IP_CONST_CASTSPELL_HASTE_10                         = 138;
int IP_CONST_CASTSPELL_HASTE_5                          = 137;
int IP_CONST_CASTSPELL_HEAL_11                          = 139;
int IP_CONST_CASTSPELL_HEALING_CIRCLE_16                = 141;
int IP_CONST_CASTSPELL_HEALING_CIRCLE_9                 = 140;
int IP_CONST_CASTSPELL_HOLD_ANIMAL_3                    = 142;
int IP_CONST_CASTSPELL_HOLD_MONSTER_7                   = 143;
int IP_CONST_CASTSPELL_HOLD_PERSON_3                    = 144;
int IP_CONST_CASTSPELL_HORRID_WILTING_15                = 308;
int IP_CONST_CASTSPELL_HORRID_WILTING_20                = 309;
int IP_CONST_CASTSPELL_ICE_STORM_9                      = 310;
int IP_CONST_CASTSPELL_IDENTIFY_3                       = 147;
int IP_CONST_CASTSPELL_IMPLOSION_17                     = 148;
int IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7          = 149;
int IP_CONST_CASTSPELL_IMPROVED_MAGE_ARMOR_10       = 594; // CG OEI 07/13/05 -- Added
int IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15              = 150;
int IP_CONST_CASTSPELL_INFERNO_15                       = 377;
int IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12       = 366;
int IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5           = 363;
int IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1           = 362;
int IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7        = 364;
int IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9         = 365;
int IP_CONST_CASTSPELL_INVISIBILITY_3                   = 151;
int IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5             = 152;
int IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5            = 153;
int IP_CONST_CASTSPELL_IRON_BODY_15                 = 586;
int IP_CONST_CASTSPELL_IRON_BODY_20         = 587;
int IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15  = 586;
int IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13   = 587;
int IP_CONST_CASTSPELL_KNOCK_3                          = 154;
int IP_CONST_CASTSPELL_LEGEND_LORE_5                    = 326;
int IP_CONST_CASTSPELL_LESSER_DISPEL_3                  = 155;
int IP_CONST_CASTSPELL_LESSER_DISPEL_5                  = 156;
int IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9              = 157;
int IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9          = 158;
int IP_CONST_CASTSPELL_LESSER_RESTORATION_3             = 159;
int IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7            = 160;
int IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9            = 161;
int IP_CONST_CASTSPELL_LIGHT_1                          = 162;
int IP_CONST_CASTSPELL_LIGHT_5                          = 163;
int IP_CONST_CASTSPELL_LIGHTNING_BOLT_10                = 165;
int IP_CONST_CASTSPELL_LIGHTNING_BOLT_5                 = 164;
int IP_CONST_CASTSPELL_MAGE_ARMOR_2                     = 167;
int IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5 = 286;
int IP_CONST_CASTSPELL_MAGIC_FANG_5                     = 383;
int IP_CONST_CASTSPELL_MAGIC_MISSILE_3                  = 172;
int IP_CONST_CASTSPELL_MAGIC_MISSILE_5                  = 173;
int IP_CONST_CASTSPELL_MAGIC_MISSILE_9                  = 174;
int IP_CONST_CASTSPELL_MANIPULATE_PORTAL_STONE          = 344;
int IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15       = 179;
int IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13                = 386;
int IP_CONST_CASTSPELL_MASS_CHARM_15                    = 180;
int IP_CONST_CASTSPELL_MASS_HASTE_11                    = 182;
int IP_CONST_CASTSPELL_MASS_HEAL_15                     = 183;
int IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3               = 184;
int IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6               = 185;
int IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9               = 186;
int IP_CONST_CASTSPELL_METEOR_SWARM_17                  = 187;
int IP_CONST_CASTSPELL_MIND_BLANK_15                    = 188;
int IP_CONST_CASTSPELL_MIND_FOG_9                       = 189;
int IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_15 = 191;    // JLR - OEI 07/11/05 -- Name Changed
int IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_7 = 190; // JLR - OEI 07/11/05 -- Name Changed
int IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17     = 197;
int IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_13           = 198;
int IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_18           = 199;
int IP_CONST_CASTSPELL_NATURES_BALANCE_15               = 200;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10         = 315;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_5          = 314;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_10    = 202;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15    = 203;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_5     = 201;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1            = 316;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_3            = 317;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_5            = 318;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_7            = 319;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9            = 320;
int IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5              = 204;
int IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7              = 351;
int IP_CONST_CASTSPELL_OWLS_INSIGHT_15                  = 369;
int IP_CONST_CASTSPELL_OWLS_WISDOM_10                   = 292;
int IP_CONST_CASTSPELL_OWLS_WISDOM_15                   = 293;
int IP_CONST_CASTSPELL_OWLS_WISDOM_3                    = 291;
int IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7              = 205;
int IP_CONST_CASTSPELL_PLANAR_ALLY_15                   = 382;
int IP_CONST_CASTSPELL_PLANAR_BINDING_11                = 206;
int IP_CONST_CASTSPELL_POISON_5                         = 207;
int IP_CONST_CASTSPELL_POLYMORPH_SELF_7                 = 208;
int IP_CONST_CASTSPELL_POWER_WORD_KILL_17               = 209;
int IP_CONST_CASTSPELL_POWER_WORD_STUN_13               = 210;
int IP_CONST_CASTSPELL_PRAYER_5                         = 211;
int IP_CONST_CASTSPELL_PREMONITION_15                   = 212;
int IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13               = 213;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2      = 284;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5      = 285;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10      = 217;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3       = 216;
int IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1       = 218; // CG OEI 07/13/05 -- Added
int IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13        = 224;
int IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20        = 225;
int IP_CONST_CASTSPELL_QUILLFIRE_8                      = 356;
int IP_CONST_CASTSPELL_RAISE_DEAD_9                     = 226;
int IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2            = 227;
int IP_CONST_CASTSPELL_RAY_OF_FROST_1                   = 228;
int IP_CONST_CASTSPELL_REGENERATE_13                    = 323;
int IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5      = 229;
int IP_CONST_CASTSPELL_REMOVE_CURSE_5                   = 230;
int IP_CONST_CASTSPELL_REMOVE_DISEASE_5                 = 231;
int IP_CONST_CASTSPELL_REMOVE_FEAR_2                    = 232;
int IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3               = 233;
int IP_CONST_CASTSPELL_RESIST_ELEMENTS_10               = 235;
int IP_CONST_CASTSPELL_RESIST_ELEMENTS_3                = 234;
int IP_CONST_CASTSPELL_RESISTANCE_2                     = 236;
int IP_CONST_CASTSPELL_RESISTANCE_5                     = 237;
int IP_CONST_CASTSPELL_RESTORATION_7                    = 238;
int IP_CONST_CASTSPELL_RESURRECTION_13                  = 239;
int IP_CONST_CASTSPELL_ROGUES_CUNNING_3                 = 328;
int IP_CONST_CASTSPELL_SANCTUARY_2                      = 240;
int IP_CONST_CASTSPELL_SCARE_2                          = 241;
int IP_CONST_CASTSPELL_SCINTILLATING_SPHERE_5       = 464; // CG OEI 07/13/05 -- Added
int IP_CONST_CASTSPELL_SEARING_LIGHT_5                  = 242;
int IP_CONST_CASTSPELL_SEE_INVISIBILITY_3               = 243;
int IP_CONST_CASTSPELL_SHADES_11                        = 244;
int IP_CONST_CASTSPELL_SHADOW_CONJURATION_7             = 245;
int IP_CONST_CASTSPELL_SHADOW_SHIELD_13                 = 246;
int IP_CONST_CASTSPELL_SHAPECHANGE_17                   = 247;
int IP_CONST_CASTSPELL_SHIELD_5                         = 348;
int IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5                = 381;
int IP_CONST_CASTSPELL_SILENCE_3                        = 249;
int IP_CONST_CASTSPELL_SLAY_LIVING_9                    = 250;
int IP_CONST_CASTSPELL_SLEEP_2                          = 251;
int IP_CONST_CASTSPELL_SLEEP_5                          = 252;
int IP_CONST_CASTSPELL_SLOW_5                           = 253;
int IP_CONST_CASTSPELL_SOUND_BURST_3                    = 254;
int IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_BEER             = 330;
int IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_SPIRITS          = 332;
int IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_WINE             = 331;
int IP_CONST_CASTSPELL_SPECIAL_HERB_BELLADONNA          = 333;
int IP_CONST_CASTSPELL_SPECIAL_HERB_GARLIC              = 334;
int IP_CONST_CASTSPELL_SPELL_MANTLE_13                  = 257;
int IP_CONST_CASTSPELL_SPELL_RESISTANCE_15              = 256;
int IP_CONST_CASTSPELL_SPELL_RESISTANCE_9               = 255;
int IP_CONST_CASTSPELL_SPIKE_GROWTH_9                   = 385;
int IP_CONST_CASTSPELL_SS_DEFENSIVE_EDGE                = 706;
int IP_CONST_CASTSPELL_SS_DESPAIR_OF_THE_DIVIDED        = 708;
int IP_CONST_CASTSPELL_SS_GREATER_RESTORATION           = 702;
int IP_CONST_CASTSPELL_SS_GREATER_SHOUT                 = 699;
int IP_CONST_CASTSPELL_SS_PENETRATING_EDGE              = 703;
int IP_CONST_CASTSPELL_SS_POLAR_RAY                     = 698;
int IP_CONST_CASTSPELL_SS_PREMONITION                   = 701;
int IP_CONST_CASTSPELL_SS_SPELLLIKE_ABILITIES           = 697;
int IP_CONST_CASTSPELL_SS_SPELL_MANTLE                  = 700;
int IP_CONST_CASTSPELL_SS_SWORD_FORMS                   = 696;
int IP_CONST_CASTSPELL_SS_UNITY_OF_WILL                 = 707;
int IP_CONST_CASTSPELL_SS_VORPAL_EDGE                   = 705;
int IP_CONST_CASTSPELL_STINKING_CLOUD_5                 = 259;
int IP_CONST_CASTSPELL_STONE_TO_FLESH_5                 = 399;
int IP_CONST_CASTSPELL_STONESKIN_7                      = 260;
int IP_CONST_CASTSPELL_STORM_OF_VENGEANCE_17            = 261;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2              = 262;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5              = 263;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3             = 264;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5            = 265;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7             = 266;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17            = 267;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9              = 268;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11            = 269;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13           = 270;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15          = 271;
int IP_CONST_CASTSPELL_SUNBEAM_13                       = 272;
int IP_CONST_CASTSPELL_SUNBURST_20                      = 358;
int IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7        = 388;
int IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11        = 273;
int IP_CONST_CASTSPELL_TIME_STOP_17                     = 274;
int IP_CONST_CASTSPELL_TRUE_SEEING_9                    = 275;
int IP_CONST_CASTSPELL_TRUE_STRIKE_5                    = 346;
int IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20          = 375;
int IP_CONST_CASTSPELL_UNIQUE_POWER                     = 329;
int IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY           = 335;
int IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5                 = 277;
int IP_CONST_CASTSPELL_VIRTUE_1                         = 278;
int IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17           = 279;
int IP_CONST_CASTSPELL_WALL_OF_FIRE_9                   = 280;
int IP_CONST_CASTSPELL_WAR_CRY_7                        = 322;
int IP_CONST_CASTSPELL_WEB_3                            = 281;
int IP_CONST_CASTSPELL_WEIRD_17                         = 282;
int IP_CONST_CASTSPELL_WORD_OF_FAITH_13                 = 283;
int IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9              = 372;
int IP_CONST_SPELLSCHOOL_ABJURATION                     = 0;
int IP_CONST_SPELLSCHOOL_CONJURATION                    = 1;
int IP_CONST_SPELLSCHOOL_DIVINATION                     = 2;
int IP_CONST_SPELLSCHOOL_ENCHANTMENT                    = 3;
int IP_CONST_SPELLSCHOOL_EVOCATION                      = 4;
int IP_CONST_SPELLSCHOOL_ILLUSION                       = 5;
int IP_CONST_SPELLSCHOOL_NECROMANCY                     = 6;
int IP_CONST_SPELLSCHOOL_TRANSMUTATION                  = 7;
int IP_CONST_SPELLRESISTANCEBONUS_10                    = 0;
int IP_CONST_SPELLRESISTANCEBONUS_12                    = 1;
int IP_CONST_SPELLRESISTANCEBONUS_14                    = 2;
int IP_CONST_SPELLRESISTANCEBONUS_16                    = 3;
int IP_CONST_SPELLRESISTANCEBONUS_18                    = 4;
int IP_CONST_SPELLRESISTANCEBONUS_20                    = 5;
int IP_CONST_SPELLRESISTANCEBONUS_22                    = 6;
int IP_CONST_SPELLRESISTANCEBONUS_24                    = 7;
int IP_CONST_SPELLRESISTANCEBONUS_26                    = 8;
int IP_CONST_SPELLRESISTANCEBONUS_28                    = 9;
int IP_CONST_SPELLRESISTANCEBONUS_30                    = 10;
int IP_CONST_SPELLRESISTANCEBONUS_32                    = 11;
int IP_CONST_TRAPTYPE_SPIKE                             = 1;
int IP_CONST_TRAPTYPE_HOLY                              = 2;
int IP_CONST_TRAPTYPE_TANGLE                            = 3;
int IP_CONST_TRAPTYPE_BLOBOFACID                        = 4;
int IP_CONST_TRAPTYPE_FIRE                              = 5;
int IP_CONST_TRAPTYPE_ELECTRICAL                        = 6;
int IP_CONST_TRAPTYPE_GAS                               = 7;
int IP_CONST_TRAPTYPE_FROST                             = 8;
int IP_CONST_TRAPTYPE_ACID_SPLASH                       = 9;
int IP_CONST_TRAPTYPE_SONIC                             = 10;
int IP_CONST_TRAPTYPE_NEGATIVE                          = 11;
int IP_CONST_TRAPSTRENGTH_MINOR                         = 0;
int IP_CONST_TRAPSTRENGTH_AVERAGE                       = 1;
int IP_CONST_TRAPSTRENGTH_STRONG                        = 2;
int IP_CONST_TRAPSTRENGTH_DEADLY                        = 3;
int IP_CONST_REDUCEDWEIGHT_80_PERCENT                   = 1;
int IP_CONST_REDUCEDWEIGHT_60_PERCENT                   = 2;
int IP_CONST_REDUCEDWEIGHT_40_PERCENT                   = 3;
int IP_CONST_REDUCEDWEIGHT_20_PERCENT                   = 4;
int IP_CONST_REDUCEDWEIGHT_10_PERCENT                   = 5;
int IP_CONST_REDUCEDWEIGHT_50_PERCENT                   = 6;
int IP_CONST_REDUCEDWEIGHT_30_PERCENT                   = 7;
int IP_CONST_REDUCEDWEIGHT_01_PERCENT                   = 8;
int IP_CONST_REDUCEDWEIGHT_70_PERCENT                   = 9;
int IP_CONST_WEIGHTINCREASE_5_LBS                       = 0;
int IP_CONST_WEIGHTINCREASE_10_LBS                      = 1;
int IP_CONST_WEIGHTINCREASE_15_LBS                      = 2;
int IP_CONST_WEIGHTINCREASE_30_LBS                      = 3;
int IP_CONST_WEIGHTINCREASE_50_LBS                      = 4;
int IP_CONST_WEIGHTINCREASE_100_LBS                     = 5;
int IP_CONST_CLASS_BARBARIAN                            = 0;
int IP_CONST_CLASS_BARD                                 = 1;
int IP_CONST_CLASS_CLERIC                               = 2;
int IP_CONST_CLASS_DRUID                                = 3;
int IP_CONST_CLASS_FIGHTER                              = 4;
int IP_CONST_CLASS_MONK                                 = 5;
int IP_CONST_CLASS_PALADIN                              = 6;
int IP_CONST_CLASS_RANGER                               = 7;
int IP_CONST_CLASS_ROGUE                                = 8;
int IP_CONST_CLASS_SORCERER                             = 9;
int IP_CONST_CLASS_WIZARD                               = 10;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT       = 0;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT       = 1;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT       = 2;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT       = 3;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT       = 4;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT       = 5;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT       = 6;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT       = 7;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT       = 8;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT        = 9;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_5_PERCENT       = 10;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_10_PERCENT      = 11;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_15_PERCENT      = 12;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_20_PERCENT      = 13;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_25_PERCENT      = 14;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_30_PERCENT      = 15;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_35_PERCENT      = 16;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_40_PERCENT      = 17;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_45_PERCENT      = 18;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT      = 19;

int ACTION_MODE_DETECT                  = 0;
int ACTION_MODE_STEALTH                 = 1;
int ACTION_MODE_PARRY                   = 2;
int ACTION_MODE_POWER_ATTACK            = 3;
int ACTION_MODE_IMPROVED_POWER_ATTACK   = 4;
int ACTION_MODE_COUNTERSPELL            = 5;
int ACTION_MODE_FLURRY_OF_BLOWS         = 6;
int ACTION_MODE_RAPID_SHOT              = 7;
int ACTION_MODE_COMBAT_EXPERTISE               = 8;
int ACTION_MODE_IMPROVED_COMBAT_EXPERTISE      = 9;
int ACTION_MODE_DEFENSIVE_CAST          = 10;
int ACTION_MODE_DIRTY_FIGHTING          = 11;
int ACTION_MODE_HELLFIRE_BLAST          = 25;
int ACTION_MODE_HELLFIRE_SHIELD         = 26;

int ITEM_VISUAL_ACID            = 0;
int ITEM_VISUAL_COLD            = 1;
int ITEM_VISUAL_ELECTRICAL      = 2;
int ITEM_VISUAL_FIRE            = 3;
int ITEM_VISUAL_SONIC           = 4;
int ITEM_VISUAL_HOLY            = 5;
int ITEM_VISUAL_EVIL            = 6;


// Brock H. - OEI - 08/16/05
// These are the return values for
// TouchAttackMelee / TouchAttackRanged
int TOUCH_ATTACK_RESULT_MISS       = 0;
int TOUCH_ATTACK_RESULT_HIT        = 1;
int TOUCH_ATTACK_RESULT_CRITICAL   = 2;

// Brock H. - OEI - 09/09/05
// Return values from ResistSpell()
// These need to stay in sync with NWRules.h
int SPELL_RESISTANCE_INVALID            = -1;
int SPELL_RESISTANCE_FAILURE            = 0;
int SPELL_RESISTANCE_SPELL_RESISTED     = 1;
int SPELL_RESISTANCE_MAGIC_IMMUNITY     = 2;
int SPELL_RESISTANCE_SPELL_ABSORBED     = 3;
int SPELL_RESISTANCE_COUNTERSONG        = 4;

// Brock H. - OEI 09/16/05
// these flags define what can break a
// mesmerization effect on a creature,
// see EffectMesmerize() below
// These need to stay in sync with NWRules.h
int MESMERIZE_BREAK_ON_ATTACKED         = 1; // ( 1 << 0 )
int MESMERIZE_BREAK_ON_NEARBY_COMBAT    = 2; // ( 1 << 1 )


/* Brock H. - OEI 02/123/06 -- This feature has been impemented in a different fashion
// Brock H. - OEI 09/19/05
// These are return values from GetFactionLastShoutCommand
// These need to stay in sync with NWRules.h
int SHOUT_NONE                      = 0; // Cancels previous shouts
int SHOUT_HEAL                      = 1; // The party healers set about healing anyone who is damaged in the party, starting on the most injured person first. The healers work on getting everyone healed to acceptable shape then go back to their default behaviors.
int SHOUT_ATTACK_MY_TARGET          = 2; // The party combines their forces attacking your currently selected target.
int SHOUT_FORM_ON_ME                = 3; // This causes all party members to get out of combat and form on the party leader. Sometimes the AI will drift from fight to fight winding up somewhere distant on the map. This reforms the core group quickly. Once the party members are centered on the PC they go back to their default AI.
int SHOUT_RETREAT                   = 4; // This shout gets everyone to get out of combat and form on you. The party members will avoid attacking, casting spells, or anything until the shout is given again, toggling the retreat state off. The purpose of this is to allow the player to quickly get out of dodge one step ahead of the enemy.
int SHOUT_OFFENSIVE_SPELL           = 5; // This orders the spell-casters to release their most potent offensive spells. By default the big guns are used by spell-caster party AI only as a last resort, the intention being that the player should direct when the best spells are called out.
int SHOUT_DEFEND_TARGET             = 6; // This makes it so the party tries and defends the selected target. If the selected target is a party member it also fights defensively until it is no longer being attacked. For the other party members they get close to what they are defending and try to kill anything attacking it.
int SHOUT_LONG_TERM_BUFFS           = 7; // This calls out for all spell-caster to buff the party and your avatar specifically with long-term buffs (1 turn/level duration or better). If this is called out in combat, spell casters only spend one combat round casting buffs. Out of combat, they cast all available buffs.
int SHOUT_SORT_TERM_BUFFS           = 8; // This calls out for all spell-caster to buff the party and your avatar specifically with short-term buffs (less than 1 turn/level duration). This is intended to be called out in combat or right before combat, spell-casters only spend one round casting buffs.
int SHOUT_DEFEND_YOUR_POSITION      = 9; // By default companions follow their player. This shout tells the companions to stop following the player and stand in place, this is essentially going into Solo Mode. When in this mode, the companions will still defend themselves from threats – but barring external stimuli they just stand in place (playing some of their idle and ready animations).
*/

// Brock H. - OEI 03/26/06 These are the script event types
// Supported by SetEventHandler() / GetEventHandler
int CREATURE_SCRIPT_ON_HEARTBEAT              = 0;
int CREATURE_SCRIPT_ON_NOTICE                 = 1;
int CREATURE_SCRIPT_ON_SPELLCASTAT            = 2;
int CREATURE_SCRIPT_ON_MELEE_ATTACKED         = 3;
int CREATURE_SCRIPT_ON_DAMAGED                = 4;
int CREATURE_SCRIPT_ON_DISTURBED              = 5;
int CREATURE_SCRIPT_ON_END_COMBATROUND        = 6;
int CREATURE_SCRIPT_ON_DIALOGUE               = 7;
int CREATURE_SCRIPT_ON_SPAWN_IN               = 8;
int CREATURE_SCRIPT_ON_RESTED                 = 9;
int CREATURE_SCRIPT_ON_DEATH                  = 10;
int CREATURE_SCRIPT_ON_USER_DEFINED_EVENT     = 11;
int CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR        = 12;
// Trigger
int SCRIPT_TRIGGER_ON_HEARTBEAT          = 0;
int SCRIPT_TRIGGER_ON_OBJECT_ENTER       = 1;
int SCRIPT_TRIGGER_ON_OBJECT_EXIT        = 2;
int SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT = 3;
int SCRIPT_TRIGGER_ON_TRAPTRIGGERED      = 4;
int SCRIPT_TRIGGER_ON_DISARMED           = 5;
int SCRIPT_TRIGGER_ON_CLICKED            = 6;
// Area
int SCRIPT_AREA_ON_HEARTBEAT            = 0;
int SCRIPT_AREA_ON_USER_DEFINED_EVENT   = 1;
int SCRIPT_AREA_ON_ENTER                = 2;
int SCRIPT_AREA_ON_EXIT                 = 3;
int SCRIPT_AREA_ON_CLIENT_ENTER         = 4;
// Door
int SCRIPT_DOOR_ON_OPEN            = 0;
int SCRIPT_DOOR_ON_CLOSE           = 1;
int SCRIPT_DOOR_ON_DAMAGE          = 2;
int SCRIPT_DOOR_ON_DEATH           = 3;
int SCRIPT_DOOR_ON_DISARM          = 4;
int SCRIPT_DOOR_ON_HEARTBEAT       = 5;
int SCRIPT_DOOR_ON_LOCK            = 6;
int SCRIPT_DOOR_ON_MELEE_ATTACKED  = 7;
int SCRIPT_DOOR_ON_SPELLCASTAT     = 8;
int SCRIPT_DOOR_ON_TRAPTRIGGERED   = 9;
int SCRIPT_DOOR_ON_UNLOCK          = 10;
int SCRIPT_DOOR_ON_USERDEFINED     = 11;
int SCRIPT_DOOR_ON_CLICKED         = 12;
int SCRIPT_DOOR_ON_DIALOGUE        = 13;
int SCRIPT_DOOR_ON_FAIL_TO_OPEN    = 14;
// Encounter
int SCRIPT_ENCOUNTER_ON_OBJECT_ENTER        = 0;
int SCRIPT_ENCOUNTER_ON_OBJECT_EXIT         = 1;
int SCRIPT_ENCOUNTER_ON_HEARTBEAT           = 2;
int SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED = 3;
int SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT  = 4;
// Module
int SCRIPT_MODULE_ON_HEARTBEAT              = 0;
int SCRIPT_MODULE_ON_USER_DEFINED_EVENT     = 1;
int SCRIPT_MODULE_ON_MODULE_LOAD            = 2;
int SCRIPT_MODULE_ON_MODULE_START           = 3;
int SCRIPT_MODULE_ON_CLIENT_ENTER           = 4;
int SCRIPT_MODULE_ON_CLIENT_EXIT            = 5;
int SCRIPT_MODULE_ON_ACTIVATE_ITEM          = 6;
int SCRIPT_MODULE_ON_ACQUIRE_ITEM           = 7;
int SCRIPT_MODULE_ON_LOSE_ITEM              = 8;
int SCRIPT_MODULE_ON_PLAYER_DEATH           = 9;
int SCRIPT_MODULE_ON_PLAYER_DYING           = 10;
int SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED = 11;
int SCRIPT_MODULE_ON_PLAYER_REST            = 12;
int SCRIPT_MODULE_ON_PLAYER_LEVEL_UP        = 13;
int SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE = 14;
int SCRIPT_MODULE_ON_EQUIP_ITEM             = 15;
int SCRIPT_MODULE_ON_UNEQUIP_ITEM           = 16;
// Placeable
int SCRIPT_PLACEABLE_ON_CLOSED              = 0;
int SCRIPT_PLACEABLE_ON_DAMAGED             = 1;
int SCRIPT_PLACEABLE_ON_DEATH               = 2;
int SCRIPT_PLACEABLE_ON_DISARM              = 3;
int SCRIPT_PLACEABLE_ON_HEARTBEAT           = 4;
int SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED  = 5;
int SCRIPT_PLACEABLE_ON_LOCK                = 6;
int SCRIPT_PLACEABLE_ON_MELEEATTACKED       = 7;
int SCRIPT_PLACEABLE_ON_OPEN                = 8;
int SCRIPT_PLACEABLE_ON_SPELLCASTAT         = 9;
int SCRIPT_PLACEABLE_ON_TRAPTRIGGERED       = 10;
int SCRIPT_PLACEABLE_ON_UNLOCK              = 11;
int SCRIPT_PLACEABLE_ON_USED                = 12;
int SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT  = 13;
int SCRIPT_PLACEABLE_ON_DIALOGUE            = 14;
// AOE
int SCRIPT_AOE_ON_HEARTBEAT            = 0;
int SCRIPT_AOE_ON_USER_DEFINED_EVENT   = 1;
int SCRIPT_AOE_ON_OBJECT_ENTER         = 2;
int SCRIPT_AOE_ON_OBJECT_EXIT          = 3;
// Store
int SCRIPT_STORE_ON_OPEN              = 0;
int SCRIPT_STORE_ON_CLOSE             = 1;



// Brock H. - OEI 03/28/06 -- These must match the values in NWN2_ScriptSets.2da
int SCRIPTSET_INVALID               = -1;
int SCRIPTSET_NOAI                  = 0;
int SCRIPTSET_PCDOMINATE            = 1;
int SCRIPTSET_DMPOSSESSED           = 2;
int SCRIPTSET_PLAYER_DEFAULT        = 3; // These are the default scripts that are loaded onto the player character
int SCRIPTSET_COMPANION_POSSESSED   = 4; // The scripts that are applied on the player when he is controlled by
int SCRIPTSET_NPC_DEFAULT           = 9; // The default scripts for generic NPCs
int SCRIPTSET_NPC_ASSOCIATES        = 10; // The default scripts for NPC associates (summoned creatures, henchmen, etc)


// ChazM - OEI 11/22/05
// These are allowed values for the iCRFlag parameter of the TriggerEncounter() function
// These are enumerated types in CNWSEncounter
int ENCOUNTER_CALC_FROM_CR          = 0;    // Use the CR value passed in determining the spawn pool
int ENCOUNTER_CALC_FROM_FACTION     = 1;    // Calculate the encounter based on normal encounter processing (based on a radius around the triggering object)

int OVERRIDE_ATTACK_RESULT_DEFAULT          = 0;
int OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL   = 1;
int OVERRIDE_ATTACK_RESULT_PARRIED          = 2;
int OVERRIDE_ATTACK_RESULT_CRITICAL_HIT     = 3;
int OVERRIDE_ATTACK_RESULT_MISS             = 4;

int BUMPSTATE_DEFAULT = 0;
int BUMPSTATE_BUMPABLE = 1;
int BUMPSTATE_UNBUMPABLE = 2;

int TALENT_EXCLUDE_ITEM     = 1;
int TALENT_EXCLUDE_ABILITY  = 2;
int TALENT_EXCLUDE_SPELL    = 4;

// AFW-OEI 10/24/2006
int ARMOR_RANK_NONE = 0;
int ARMOR_RANK_LIGHT    = 1;
int ARMOR_RANK_MEDIUM   = 2;
int ARMOR_RANK_HEAVY    = 3;

// AFW-OEI 10/24/2006
int WEAPON_TYPE_NONE            = 0;
int WEAPON_TYPE_PIERCING        = 1;
int WEAPON_TYPE_BLUDGEONING     = 2;
int WEAPON_TYPE_SLASHING        = 3;
int WEAPON_TYPE_PIERCING_AND_SLASHING   = 4;

// Brock H. - OEI 11/03/06
int ENCUMBRANCE_STATE_INVALID = -1;
int ENCUMBRANCE_STATE_NORMAL = 0;
int ENCUMBRANCE_STATE_HEAVY = 1;
int ENCUMBRANCE_STATE_OVERLOADED = 2;

int AREA_HEIGHT = 0;//For use with the GetAreaSize function
int AREA_WIDTH  = 1;//For use with the GetAreaSize function

int SCALE_X     = 0;//For use with the GetScale function
int SCALE_Y     = 1;//For use with the GetScale function
int SCALE_Z     = 2;//For use with the GetScale function

int VARIABLE_TYPE_NONE = -1;
int VARIABLE_TYPE_INT = 1;
int VARIABLE_TYPE_FLOAT = 2;
int VARIABLE_TYPE_STRING = 3;
int VARIABLE_TYPE_DWORD = 4;
int VARIABLE_TYPE_LOCATION = 5;

//RWT-OEI 09/18/08 - Constants to be used with the GetTalkTableLanguage()
//script function
int LANGUAGE_ENGLISH    =   0;
int LANGUAGE_FRENCH     =   1;
int LANGUAGE_GERMAN     =   2;
int LANGUAGE_ITALIAN    =   3;
int LANGUAGE_SPANISH    =   4;
int LANGUAGE_POLISH     =   5;
int LANGUAGE_RUSSIAN    =   6;

// MAP 03/06/2009 - These values are returned as a mask from GetSurfaceMaterialsAtLocation
int SM_TYPE_WALKABLE = 1;
int SM_TYPE_DIRT     = 8;
int SM_TYPE_GRASS    = 16;
int SM_TYPE_STONE    = 32;
int SM_TYPE_WOOD     = 64;
int SM_TYPE_CARPET   = 128;
int SM_TYPE_METAL    = 256;
int SM_TYPE_SWAMP    = 512;
int SM_TYPE_MUD      = 1024;
int SM_TYPE_LEAVES   = 2048;
int SM_TYPE_WATER    = 4096;
int SM_TYPE_PUDDLES  = 8192;

// MAP 03/06/2009 - These are used in Get/SetItemTint to indicate which colorset to modify/retrieve.
int ITEM_COLOR_1 = 0;
int ITEM_COLOR_2 = 1;
int ITEM_COLOR_3 = 2;

// MAP 03/06/2009 - These are used in Get/SetItemModel to indicate which weapon part to modify/retrieve
int WEAPON_MODEL_PART_1 = 0;
int WEAPON_MODEL_PART_2 = 1;
int WEAPON_MODEL_PART_3 = 2;

// MAP 03/06/2009
// These are used in Get/SetItemModel to indicate which armor part to modify/retrieve
// Not all parts may be in use.
int ARMOR_MODEL_PIECE_BODY             = 10;
int ARMOR_MODEL_PIECE_LEFT_SHOULDER    = 11;
int ARMOR_MODEL_PIECE_RIGHT_SHOULDER   = 12;
int ARMOR_MODEL_PIECE_LEFT_BRACER      = 13;
int ARMOR_MODEL_PIECE_RIGHT_BRACER     = 14;
int ARMOR_MODEL_PIECE_LEFT_ELBOW       = 15;
int ARMOR_MODEL_PIECE_RIGHT_ELBOW      = 16;
int ARMOR_MODEL_PIECE_LEFT_ARM         = 17;
int ARMOR_MODEL_PIECE_RIGHT_ARM        = 18;
int ARMOR_MODEL_PIECE_LEFT_HIP         = 19;
int ARMOR_MODEL_PIECE_RIGHT_HIP        = 20;
int ARMOR_MODEL_PIECE_FRONT_HIP        = 21;
int ARMOR_MODEL_PIECE_BACK_HIP         = 22;
int ARMOR_MODEL_PIECE_LEFT_LEG         = 23;
int ARMOR_MODEL_PIECE_RIGHT_LEG        = 24;
int ARMOR_MODEL_PIECE_LEFT_SHIN        = 25;
int ARMOR_MODEL_PIECE_RIGHT_SHIN       = 26;
int ARMOR_MODEL_PIECE_LEFT_KNEE        = 27;
int ARMOR_MODEL_PIECE_RIGHT_KNEE       = 28;
int ARMOR_MODEL_PIECE_LEFT_FOOT        = 29;
int ARMOR_MODEL_PIECE_RIGHT_FOOT       = 30;
int ARMOR_MODEL_PIECE_LEFT_ANKLE       = 31;
int ARMOR_MODEL_PIECE_RIGHT_ANKLE      = 32;

// MAP 03/06/2009
// These are used in Get/SetItemModel to indicate which weapon part to modify/retrieve.
// These will only work if the appropriate armor part is enabled (example: armor has 'helm' enabled),
// or for base item types
int ARMOR_MODEL_PART_HELM             = 0;
int ARMOR_MODEL_PART_GLOVES           = 1;
int ARMOR_MODEL_PART_BOOTS            = 2;
int ARMOR_MODEL_PART_BELT             = 3;
int ARMOR_MODEL_PART_CLOAK            = 4;


// MAP 3/22/2009
// These are for use in the chat module callback conditional and in
// the function SendChatMessage.
int CHAT_MODE_TALK                      = 1;
int CHAT_MODE_SHOUT                     = 2;
int CHAT_MODE_WHISPER                   = 3;
int CHAT_MODE_TELL                      = 4;
int CHAT_MODE_SERVER                    = 5;
int CHAT_MODE_PARTY                     = 6;
int CHAT_MODE_SILENT_SHOUT              = 14;


string sLanguage = "nwscript";

// Get an integer between 0 and nMaxInteger-1.
// Return value on error: 0
int Random(int nMaxInteger);

// Output sString to the log file.
// For all the Print* functions, output is controlled by ini setting: nwnplayer.ini - [Server Options]Scripts Print To Log
void PrintString(string sString);

// Output a formatted float to the log file.
// - nWidth should be a value from 0 to 18 inclusive.
// - nDecimals should be a value from 0 to 9 inclusive.
void PrintFloat(float fFloat, int nWidth=18, int nDecimals=9);

// Convert fFloat into a string.
// - nWidth should be a value from 0 to 18 inclusive.
// - nDecimals should be a value from 0 to 9 inclusive.
string FloatToString(float fFloat, int nWidth=18, int nDecimals=9);

// Output nInteger to the log file.
void PrintInteger(int nInteger);

// Output oObject's ID to the log file.
void PrintObject(object oObject);

// Assign aActionToAssign to oActionSubject.
// * No return value, but if an error occurs, the log file will contain
//   "AssignCommand failed."
//   (If the object doesn't exist, nothing happens.)
void AssignCommand(object oActionSubject,action aActionToAssign);

// Delay aActionToDelay by fSeconds.
// * No return value, but if an error occurs, the log file will contain
//   "DelayCommand failed.".
// It is suggested that functions which create effects should not be used
// as parameters to delayed actions.  Instead, the effect should be created in the
// script and then passed into the action.  For example:
// effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
// DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
void DelayCommand(float fSeconds, action aActionToDelay);

// Make oTarget run sScript and then return execution to the calling script.
// If sScript does not specify a compiled script, nothing happens.
void ExecuteScript(string sScript, object oTarget);

// Clear all the actions of the caller.
// * No return value, but if an error occurs, the log file will contain
//   "ClearAllActions failed.".
// - nClearCombatState: if true, this will immediately clear the combat state
//   on a creature, which will stop the combat music and allow them to rest,
//   engage in dialog, or other actions that they would normally have to wait for.
void ClearAllActions(int nClearCombatState=FALSE);

// Cause the caller to face fDirection.
// - fDirection is expressed as anticlockwise degrees from Due East.
//   DIRECTION_EAST, DIRECTION_NORTH, DIRECTION_WEST and DIRECTION_SOUTH are
//   predefined. (0.0f=East, 90.0f=North, 180.0f=West, 270.0f=South)
//RWT-OEI 12/20/04 - If the last parameter is passed as TRUE, then the dialog
//manager will not go trying to adjust the caller for the remainder of the
//dialog. This lock is only in effect for the currently active dialog.
void SetFacing(float fDirection, int bLockToThisOrientation = FALSE);

// Set the calendar to the specified date.
// - nYear should be from 0 to 32000 inclusive
// - nMonth should be from 1 to 12 inclusive
// - nDay should be from 1 to 28 inclusive
// 1) Time can only be advanced forwards; attempting to set the time backwards
//    will result in no change to the calendar.
// 2) If values larger than the month or day are specified, they will be wrapped
//    around and the overflow will be used to advance the next field.
//    e.g. Specifying a year of 1350, month of 33 and day of 10 will result in
//    the calender being set to a year of 1352, a month of 9 and a day of 10.
void SetCalendar(int nYear,int nMonth, int nDay);

// Set the time to the time specified.
// - nHour should be from 0 to 23 inclusive
// - nMinute should be from 0 to 59 inclusive
// - nSecond should be from 0 to 59 inclusive
// - nMillisecond should be from 0 to 999 inclusive
// 1) Time can only be advanced forwards; attempting to set the time backwards
//    will result in the day advancing and then the time being set to that
//    specified, e.g. if the current hour is 15 and then the hour is set to 3,
//    the day will be advanced by 1 and the hour will be set to 3.
// 2) If values larger than the max hour, minute, second or millisecond are
//    specified, they will be wrapped around and the overflow will be used to
//    advance the next field, e.g. specifying 62 hours, 250 minutes, 10 seconds
//    and 10 milliseconds will result in the calendar day being advanced by 2
//    and the time being set to 18 hours, 10 minutes, 10 milliseconds.
void SetTime(int nHour,int nMinute,int nSecond,int nMillisecond);

// Get the current calendar year.
int GetCalendarYear();

// Get the current calendar month.
int GetCalendarMonth();

// Get the current calendar day.
int GetCalendarDay();

// Get the current hour.
int GetTimeHour();

// Get the current minute
int GetTimeMinute();

// Get the current second
int GetTimeSecond();

// Get the current millisecond
int GetTimeMillisecond();

// The action subject will generate a random location near its current location
// and pathfind to it.  ActionRandomwalk never ends, which means it is neccessary
// to call ClearAllActions in order to allow a creature to perform any other action
// once ActionRandomWalk has been called.
// * No return value, but if an error occurs the log file will contain
//   "ActionRandomWalk failed."
void ActionRandomWalk();

// The action subject will move to lDestination.
// - lDestination: The object will move to this location.  If the location is
//   invalid or a path cannot be found to it, the command does nothing.
// - bRun: If this is TRUE, the action subject will run rather than walk
// * No return value, but if an error occurs the log file will contain
//   "MoveToPoint failed."
void ActionMoveToLocation(location lDestination, int bRun=FALSE);

// Cause the action subject to move to a certain distance from oMoveTo.
// If there is no path to oMoveTo, this command will do nothing.
// - oMoveTo: This is the object we wish the action subject to move to
// - bRun: If this is TRUE, the action subject will run rather than walk
// - fRange: This is the desired distance between the action subject and oMoveTo
// * No return value, but if an error occurs the log file will contain
//   "ActionMoveToObject failed."
void ActionMoveToObject(object oMoveTo, int bRun=FALSE, float fRange=1.0f);

// Cause the action subject to move to a certain distance away from oFleeFrom.
// - oFleeFrom: This is the object we wish the action subject to move away from.
//   If oFleeFrom is not in the same area as the action subject, nothing will
//   happen.
// - bRun: If this is TRUE, the action subject will run rather than walk
// - fMoveAwayRange: This is the distance we wish the action subject to put
//   between themselves and oFleeFrom
// * No return value, but if an error occurs the log file will contain
//   "ActionMoveAwayFromObject failed."
void ActionMoveAwayFromObject(object oFleeFrom, int bRun=FALSE, float fMoveAwayRange=40.0f);

// Get the area that oTarget is currently in
// * Return value on error: OBJECT_INVALID
object GetArea(object oTarget);

// The value returned by this function depends on the object type of the caller:
// 1) If the caller is a door it returns the object that last
//    triggered it.
// 2) If the caller is a trigger, area of effect, module, area or encounter it
//    returns the object that last entered it.
// * Return value on error: OBJECT_INVALID
//  When used for doors, this should only be called from the OnAreaTransitionClick
//  event.  Otherwise, it should only be called in OnEnter scripts.
object GetEnteringObject();

// Get the object that last left the caller.  This function works on triggers,
// areas of effect, modules, areas and encounters.
// * Return value on error: OBJECT_INVALID
// Should only be called in OnExit scripts.
object GetExitingObject();

// Get the position of oTarget
// * Return value on error: vector (0.0f, 0.0f, 0.0f)
vector GetPosition(object oTarget);

// Get the direction in which oTarget is facing, expressed as a float between
// 0.0f and 360.0f
// * Return value on error: -1.0f
float GetFacing(object oTarget);

// Get the possessor of oItem
// * Return value on error: OBJECT_INVALID
object GetItemPossessor(object oItem);

// Get the object possessed by oCreature with the tag sItemTag
// * Return value on error: OBJECT_INVALID
object GetItemPossessedBy(object oCreature, string sItemTag);

// Create an item with the template sItemTemplate in oTarget's inventory.
// - nStackSize: This is the stack size of the item to be created
// * Return value: The object that has been created.  On error, this returns
//   OBJECT_INVALID.
// - RWT-OEI 03/13/07 If sNewTag is not left empty, it will set the tag of the newly created object.
// - RWT-OEI 08/14/07 If bDisplayFeedback is changed to false, no feedback will be given to the player.
object CreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="", int bDisplayFeedback=1);

// Equip oItem into nInventorySlot.
// - nInventorySlot: INVENTORY_SLOT_*
// * No return value, but if an error occurs the log file will contain
//   "ActionEquipItem failed."
void ActionEquipItem(object oItem, int nInventorySlot);

// Unequip oItem from whatever slot it is currently in.
void ActionUnequipItem(object oItem);

// Pick up oItem from the ground.
// * No return value, but if an error occurs the log file will contain
//   "ActionPickUpItem failed."
void ActionPickUpItem(object oItem);

// Put down oItem on the ground.
// * No return value, but if an error occurs the log file will contain
//   "ActionPutDownItem failed."
void ActionPutDownItem(object oItem);

// Get the last attacker of oAttackee.  This should only be used ONLY in the
// OnAttacked events for creatures, placeables and doors.
// * Return value on error: OBJECT_INVALID
object GetLastAttacker(object oAttackee=OBJECT_SELF);

// Attack oAttackee.
// - bPassive: If this is TRUE, attack is in passive mode.
void ActionAttack(object oAttackee, int bPassive=FALSE);

// Get the creature nearest to oTarget, subject to all the criteria specified.
// - nFirstCriteriaType: CREATURE_TYPE_*
// - nFirstCriteriaValue:
//   -> CLASS_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_CLASS
//   -> SPELL_* if nFirstCriteriaType was CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT
//      or CREATURE_TYPE_HAS_SPELL_EFFECT
//   -> CREATURE_ALIVE_TRUE or CREATURE_ALIVE_FALSE if nFirstCriteriaType was CREATURE_TYPE_IS_ALIVE
//      Or use CREATURE_ALIVE_BOTH to search both DEAD or ALIVE
//      Default search considers creatures that are alive ONLY!
//   -> PERCEPTION_* if nFirstCriteriaType was CREATURE_TYPE_PERCEPTION
//   -> PLAYER_CHAR_IS_PC or PLAYER_CHAR_NOT_PC if nFirstCriteriaType was
//      CREATURE_TYPE_PLAYER_CHAR.  If you want the character that a PC is
//      controlling even if they are not a Player Owned character, use
//      PLAYER_CHAR_IS_CONTROLLED instead.
//   -> RACIAL_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_RACIAL_TYPE
//   -> REPUTATION_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_REPUTATION
//   -> CREATURE_SCRIPTHIDDEN_* if nFirstCriteriaType was CREATURE_TYPE_SCRIPTHIDDEN
//   For example, to get the nearest PC, use:
//   (CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC)
// - oTarget: We're trying to find the creature of the specified type that is
//   nearest to oTarget
// - nNth: We don't have to find the first nearest: we can find the Nth nearest...
// - nSecondCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nSecondCriteriaValue: This is used in the same way as nFirstCriteriaValue
//   to further specify the type of creature that we are looking for.
// - nThirdCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nThirdCriteriaValue: This is used in the same way as nFirstCriteriaValue to
//   further specify the type of creature that we are looking for.
// * Return value on error: OBJECT_INVALID
object GetNearestCreature(int nFirstCriteriaType, int nFirstCriteriaValue, object oTarget=OBJECT_SELF, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1 );

// Add a speak action to the action subject.
// - sStringToSpeak: String to be spoken
// - nTalkVolume: TALKVOLUME_*
void ActionSpeakString(string sStringToSpeak, int nTalkVolume=TALKVOLUME_TALK);

// Cause the action subject to play an animation
// - nAnimation: ANIMATION_*
// - fSpeed: Speed of the animation
// - fDurationSeconds: Duration of the animation (this is not used for Fire and
//   Forget animations)
void ActionPlayAnimation(int nAnimation, float fSpeed=1.0, float fDurationSeconds=0.0);

// Get the distance from the caller to oObject in metres.
// * Return value on error: -1.0f
float GetDistanceToObject(object oObject);

// * Returns TRUE if oObject is a valid object.
int GetIsObjectValid(object oObject);

// Cause the action subject to open oDoor
void ActionOpenDoor(object oDoor);

// Cause the action subject to close oDoor
void ActionCloseDoor(object oDoor);

// Change the direction in which the camera is facing
// - fDirection is expressed as anticlockwise degrees from Due East.
//   (0.0f=East, 90.0f=North, 180.0f=West, 270.0f=South)
// A value of -1.0f for any parameter will be ignored and instead it will
// use the current camera value.
// This can be used to change the way the camera is facing after the player
// emerges from an area transition.
// - nTransitionType: CAMERA_TRANSITION_TYPE_*  SNAP will immediately move the
//   camera to the new position, while the other types will result in the camera moving gradually into position
// Pitch and distance are limited to valid values for the current camera mode:
// Top Down: Distance = 5-20, Pitch = 1-50
// Driving camera: Distance = 6 (can't be changed), Pitch = 1-62
// Chase: Distance = 5-20, Pitch = 1-50
// *** NOTE *** In NWN:Hordes of the Underdark the camera limits have been relaxed to the following:
// Distance 1-25
// Pitch 1-89
void SetCameraFacing(float fDirection, float fDistance = -1.0f, float fPitch = -1.0, int nTransitionType=CAMERA_TRANSITION_TYPE_SNAP);

// Play sSoundName
// - sSoundName: TBD - SS
// This will play a mono sound from the location of the object running the command.
// RWT-OEI 09/05/08 - Added bPlayAs2D parameter. If true, will play the sound
// as a 2D sound.
void PlaySound(string sSoundName, int bPlayAs2D=FALSE);

// Get the object at which the caller last cast a spell
// * Return value on error: OBJECT_INVALID
object GetSpellTargetObject();

// This action casts a spell at oTarget.
// - nSpell: SPELL_*
// - oTarget: Target for the spell
// - nMetamagic: METAMAGIC_*
// - bCheat: If this is TRUE, then the executor of the action doesn't have to be
//   able to cast the spell.
// - nDomainLevel: TBD - SS
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
// - bInstantSpell: If this is TRUE, the spell is cast immediately. This allows
//   the end-user to simulate a high-level magic-user having lots of advance
//   warning of impending trouble
void ActionCastSpellAtObject(int nSpell, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);

// Get the current hitpoints of oObject
// * Return value on error: 0
int GetCurrentHitPoints(object oObject=OBJECT_SELF);

// Get the maximum hitpoints of oObject
// * Return value on error: 0
int GetMaxHitPoints(object oObject=OBJECT_SELF);

// Get oObject's local integer variable sVarName
// * Return value on error: 0
int GetLocalInt(object oObject, string sVarName);

// Get oObject's local float variable sVarName
// * Return value on error: 0.0f
float GetLocalFloat(object oObject, string sVarName);

// Get oObject's local string variable sVarName
// * Return value on error: ""
string GetLocalString(object oObject, string sVarName);

// Get oObject's local object variable sVarName
// * Return value on error: OBJECT_INVALID
object GetLocalObject(object oObject, string sVarName);

// Set oObject's local integer variable sVarName to nValue
void SetLocalInt(object oObject, string sVarName, int nValue);

// Set oObject's local float variable sVarName to nValue
void SetLocalFloat(object oObject, string sVarName, float fValue);

// Set oObject's local string variable sVarName to nValue
void SetLocalString(object oObject, string sVarName, string sValue);

// Set oObject's local object variable sVarName to nValue
void SetLocalObject(object oObject, string sVarName, object oValue);

// Get the length of sString
// * Return value on error: -1
int GetStringLength(string sString);

// Convert sString into upper case
// * Return value on error: ""
string GetStringUpperCase(string sString);

// Convert sString into lower case
// * Return value on error: ""
string GetStringLowerCase(string sString);

// Get nCount characters from the right end of sString
// * Return value on error: ""
string GetStringRight(string sString, int nCount);

// Get nCounter characters from the left end of sString
// * Return value on error: ""
string GetStringLeft(string sString, int nCount);

// Insert sString into sDestination at nPosition
// * Return value on error: ""
string InsertString(string sDestination, string sString, int nPosition);

// Get nCount characters from sString, starting at nStart
// * Return value on error: ""
string GetSubString(string sString, int nStart, int nCount);

// Find the position of sSubstring inside sString
// starting at index nStart.
// * Return value on error: -1
int FindSubString(string sString, string sSubString, int nStart = 0);

// math operations

// Maths operation: absolute value of fValue
float fabs(float fValue);

// Maths operation: cosine of fValue
float cos(float fValue);

// Maths operation: sine of fValue
float sin(float fValue);

// Maths operation: tan of fValue
float tan(float fValue);

// Maths operation: arccosine of fValue
// * Returns zero if fValue > 1 or fValue < -1
float acos(float fValue);

// Maths operation: arcsine of fValue
// * Returns zero if fValue >1 or fValue < -1
float asin(float fValue);

// Maths operation: arctan of fValue
float atan(float fValue);

// Maths operation: log of fValue
// * Returns zero if fValue <= zero
float log(float fValue);

// Maths operation: fValue is raised to the power of fExponent
// * Returns zero if fValue ==0 and fExponent <0
float pow(float fValue, float fExponent);

// Maths operation: square root of fValue
// * Returns zero if fValue <0
float sqrt(float fValue);

// Maths operation: integer absolute value of nValue
// * Return value on error: 0
int abs(int nValue);

// Create a Heal effect. This should be applied as an instantaneous effect.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nDamageToHeal < 0.
// RWT-OEI 03/13/07 - This will now 'heal' doors and placeables.
effect EffectHeal(int nDamageToHeal);

// Create a Damage effect
// - nDamageAmount: amount of damage to be dealt. This should be applied as an
//   instantaneous effect.
// - nDamageType: DAMAGE_TYPE_*
// - nDamagePower: DAMAGE_POWER_*
// - nIgnoreResistances: FALSE will use damage immunity, damage reduction, and damage resistance.  TRUE will skip all of these.
effect EffectDamage(int nDamageAmount, int nDamageType=DAMAGE_TYPE_MAGICAL, int nDamagePower=DAMAGE_POWER_NORMAL, int nIgnoreResistances=FALSE);

// Create an Ability Increase effect
// - bAbilityToIncrease: ABILITY_*
effect EffectAbilityIncrease(int nAbilityToIncrease, int nModifyBy);

// Create a Damage Resistance effect that removes the first nAmount points of
// damage of type nDamageType, up to nLimit (or infinite if nLimit is 0)
// - nDamageType: DAMAGE_TYPE_*
// - nAmount
// - nLimit
effect EffectDamageResistance(int nDamageType, int nAmount, int nLimit=0);

// Create a Resurrection effect. This should be applied as an instantaneous effect.
effect EffectResurrection();

// Create a Summon Creature effect.  The creature is created and placed into the
// caller's party/faction.
// - sCreatureResref: Identifies the creature to be summoned
// - nVisualEffectId: VFX_*
// - fDelaySeconds: There can be delay between the visual effect being played, and the
//   creature being added to the area
// - nUseAppearAnimation: should this creature play it's "appear" animation when it is
//   summoned. If zero, it will just fade in somewhere near the target.  If the value is 1
//   it will use the appear animation, and if it's 2 it will use appear2 (which doesn't exist for most creatures)
effect EffectSummonCreature(string sCreatureResref, int nVisualEffectId=VFX_NONE, float fDelaySeconds=0.0f, int nUseAppearAnimation=0);

// Get the level at which this creature cast it's last spell (or spell-like ability)
// * Return value on error, or if oCreature has not yet cast a spell: 0;
int GetCasterLevel(object oCreature);

// Get the first in-game effect on oCreature.
effect GetFirstEffect(object oCreature);

// Get the next in-game effect on oCreature.
effect GetNextEffect(object oCreature);

// Remove eEffect from oCreature.
// * No return value
void RemoveEffect(object oCreature, effect eEffect);

// * Returns TRUE if eEffect is a valid effect. The effect must have been applied to
// * an object or else it will return FALSE
int GetIsEffectValid(effect eEffect);

// Get the duration type (DURATION_TYPE_*) of eEffect.
// * Return value if eEffect is not valid: -1
int GetEffectDurationType(effect eEffect);

// Get the subtype (SUBTYPE_*) of eEffect.
// * Return value on error: 0
int GetEffectSubType(effect eEffect);

// Get the object that created eEffect.
// * Returns OBJECT_INVALID if eEffect is not a valid effect.
object GetEffectCreator(effect eEffect);

// Convert nInteger into a string.
// * Return value on error: ""
string IntToString(int nInteger);

// Get the first object in oArea.
// If no valid area is specified, it will use the caller's area.
// * Return value on error: OBJECT_INVALID
object GetFirstObjectInArea(object oArea=OBJECT_INVALID);

// Get the next object in oArea.
// If no valid area is specified, it will use the caller's area.
// * Return value on error: OBJECT_INVALID
object GetNextObjectInArea(object oArea=OBJECT_INVALID);

// Get the total from rolling (nNumDice x d2 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d2(int nNumDice=1);

// Get the total from rolling (nNumDice x d3 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d3(int nNumDice=1);

// Get the total from rolling (nNumDice x d4 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d4(int nNumDice=1);

// Get the total from rolling (nNumDice x d6 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d6(int nNumDice=1);

// Get the total from rolling (nNumDice x d8 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d8(int nNumDice=1);

// Get the total from rolling (nNumDice x d10 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d10(int nNumDice=1);

// Get the total from rolling (nNumDice x d12 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d12(int nNumDice=1);

// Get the total from rolling (nNumDice x d20 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d20(int nNumDice=1);

// Get the total from rolling (nNumDice x d100 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d100(int nNumDice=1);

// Get the magnitude of vVector; this can be used to determine the
// distance between two points.
// * Return value on error: 0.0f
float VectorMagnitude(vector vVector);

// Get the metamagic type (METAMAGIC_*) of the last spell cast by the caller
// * Return value if the caster is not a valid object: -1
int GetMetaMagicFeat();

// Get the object type (OBJECT_TYPE_*) of oTarget
// * Return value if oTarget is not a valid object: -1
int GetObjectType(object oTarget);

// Get the racial type (RACIAL_TYPE_*) of oCreature
// * Return value if oCreature is not a valid creature: RACIAL_TYPE_INVALID
int GetRacialType(object oCreature);

// Do a Fortitude Save check for the given DC
// - oCreature
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
// Returns: SAVING_THROW_CHECK_FAILED, or 0 if the saving throw roll failed
// Returns: SAVING_THROW_CHECK_SUCCEEDED, or 1, if the saving throw roll succeeded
// Returns: SAVING_THROW_CHECK_IMMUNE, or 2, if the target was immune to the save type specified
// Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
// GetAreaOfEffectCreator() into oSaveVersus!!
int FortitudeSave(object oCreature, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Does a Reflex Save check for the given DC
// - oCreature
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
// Returns: SAVING_THROW_CHECK_FAILED, or 0 if the saving throw roll failed
// Returns: SAVING_THROW_CHECK_SUCCEEDED, or 1, if the saving throw roll succeeded
// Returns: SAVING_THROW_CHECK_IMMUNE, or 2, if the target was immune to the save type specified
// Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
// GetAreaOfEffectCreator() into oSaveVersus!!
int ReflexSave(object oCreature, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Does a Will Save check for the given DC
// - oCreature
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
// Returns: SAVING_THROW_CHECK_FAILED, or 0 if the saving throw roll failed
// Returns: SAVING_THROW_SUCCEEDED, or 1, if the saving throw roll succeeded
// Returns: SAVING_THROW_CHECK_IMMUNE, or 2, if the target was immune to the save type specified
// Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
// GetAreaOfEffectCreator() into oSaveVersus!!
int WillSave(object oCreature, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Get the DC to save against for a spell (10 + spell level + relevant ability
// bonus).  This can be called by a creature or by an Area of Effect object.
int GetSpellSaveDC();

// Set the subtype of eEffect to Magical and return eEffect.
// (Effects default to magical if the subtype is not set)
// Magical effects are removed by resting, and by dispel magic
effect MagicalEffect(effect eEffect);

// Set the subtype of eEffect to Supernatural and return eEffect.
// (Effects default to magical if the subtype is not set)
// Permanent supernatural effects are not removed by resting
effect SupernaturalEffect(effect eEffect);

// Set the subtype of eEffect to Extraordinary and return eEffect.
// (Effects default to magical if the subtype is not set)
// Extraordinary effects are removed by resting, but not by dispel magic
effect ExtraordinaryEffect(effect eEffect);

// Create an AC Increase effect
// - nValue: size of AC increase
// - nModifyType: AC_*_BONUS
// - nDamageType: DAMAGE_TYPE_*
// - bVsSpiritsOnly: If TRUE, the AC bonus is vs. spirits only; otherwise it applies to everything.
//   * Default value for nDamageType should only ever be used in this function prototype.
effect EffectACIncrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL, int bVsSpiritsOnly=FALSE);

// If oObject is a creature, this will return that creature's armour class
// If oObject is an item, door or placeable, this will return zero.
// - nForFutureUse: this parameter is not currently used
// * Return value if oObject is not a creature, item, door or placeable: -1
int GetAC(object oObject, int nForFutureUse=0);

// Create a Saving Throw increase effect
// - nSave: SAVING_THROW_* (not SAVING_THROW_TYPE_*)
// - nValue: size of the Saving Throw Increase
// - nSaveType: SAVING_THROW_TYPE_*
// - bVsSpiritsOnly: If TRUE, the save bonus is vs. spirits only; otherwise it applies to everything.
effect EffectSavingThrowIncrease(int nSave, int nValue, int nSaveType=SAVING_THROW_TYPE_ALL, int bVsSpiritsOnly=FALSE);

// Create an Attack Increase effect
// - nBonus: size of attack bonus
// - nModifierType: ATTACK_BONUS_*
effect EffectAttackIncrease(int nBonus, int nModifierType=ATTACK_BONUS_MISC);

// Create a Damage Reduction effect
// - nAmount: amount of damage reduction
// - nDmgBonus: (dependent on the nDRType)
//      - DR_TYPE_NONE:       ()
//      - DR_TYPE_DMGTYPE:    DAMAGE_TYPE_*
//      - DR_TYPE_MAGICBONUS: (DAMAGE_POWER_*)
//      - DR_TYPE_EPIC:       ()
//      - DR_TYPE_GMATERIAL:  GMATERIAL_*
//      - DR_TYPE_ALIGNMENT:  ALIGNMENT_*
//      - DR_TYPE_NON_RANGED: ()
// - nLimit: How much damage the effect can absorb before disappearing.
//   Set to zero for infinite
// - nDRType: DR_TYPE_*
//effect EffectDamageReduction(int nAmount, int nDamagePower, int nLimit=0);
// JLR - OEI 07/21/05 NWN2 3.5 -- New Damage Reduction Rules
//effect EffectDamageReduction(int nAmount, int nDmgBonus=DAMAGE_POWER_NORMAL, int nLimit=0, int nDmgCat=DAMAGE_TYPE_ALL, int nMatType=MATERIAL_NONSPECIFIC, int nIsRanged=FALSE, int nIsOREffect=FALSE);
// JLR-OEI 02/14/05 NWN2 3.5 -- New Damage Reduction Rules
effect EffectDamageReduction(int nAmount, int nDRSubType=DAMAGE_POWER_NORMAL, int nLimit=0, int nDRType=DR_TYPE_MAGICBONUS);


// Create a Damage Increase effect
// - nBonus: DAMAGE_BONUS_*
// - nDamageType: DAMAGE_TYPE_*
// NOTE! You *must* use the DAMAGE_BONUS_* constants! Using other values may
//       result in odd behaviour.
effect EffectDamageIncrease(int nBonus, int nDamageType=DAMAGE_TYPE_MAGICAL, int nVersusRace=-1);

// Convert nRounds into a number of seconds
// A round is always 6.0 seconds
float RoundsToSeconds(int nRounds);

// Convert nHours into a number of seconds
// The result will depend on how many minutes there are per hour (game-time)
float HoursToSeconds(int nHours);

// Convert nTurns into a number of seconds
// A turn is always 60.0 seconds
float TurnsToSeconds(int nTurns);

// Get an integer between 0 and 100 (inclusive) to represent oCreature's
// Law/Chaos alignment
// (100=law, 0=chaos)
// * Return value if oCreature is not a valid creature: -1
int GetLawChaosValue(object oCreature);

// Get an integer between 0 and 100 (inclusive) to represent oCreature's
// Good/Evil alignment
// (100=good, 0=evil)
// * Return value if oCreature is not a valid creature: -1
int GetGoodEvilValue(object oCreature);

// Return an ALIGNMENT_* constant to represent oCreature's law/chaos alignment
// * Return value if oCreature is not a valid creature: -1
int GetAlignmentLawChaos(object oCreature);

// Return an ALIGNMENT_* constant to represent oCreature's good/evil alignment
// * Return value if oCreature is not a valid creature: -1
int GetAlignmentGoodEvil(object oCreature);

// Get the first object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. Line of sight check is done from origin to target object
//   at a height 1m above the ground
//   (This can be used to ensure that spell effects do not go through walls.)
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or".
//   For example, to return only creatures and doors, the value for this
//   parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the
//   origin of the effect(normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetFirstObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Get the next object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. (This can be used to ensure that spell effects do not go
//   through walls.) Line of sight check is done from origin to target object
//   at a height 1m above the ground
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or". For example, to return only creatures and doors, the value for
//   this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the origin
//   of the effect (normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetNextObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Create an Entangle effect
// When applied, this effect will restrict the creature's movement and apply a
// (-2) to all attacks and a -4 to AC.
effect EffectEntangle();

// Cause oObject to run evToRun
void SignalEvent(object oObject, event evToRun);

// Create an event of the type nUserDefinedEventNumber
event EventUserDefined(int nUserDefinedEventNumber);

// Create a Death effect
// - nSpectacularDeath: if this is TRUE, the creature to which this effect is
//   applied will die in an extraordinary fashion
// - nDisplayFeedback
// - nIgnoreDeathImmunity: if TRUE, this Death effect ignores any Death Immunity.
// - bPurgeEffects: Normally TRUE. If changed to FALSE, then the creature will not
//                  have their effects purged when they die. This might result
//                  in weird situations where a creature won't die (Due to a
//                  bonus HP effect, or somesuch), so should only be used in
//                  specific situations, such as wanting to preserve a visual
//                  effect on the dead body.
effect EffectDeath(int nSpectacularDeath=FALSE, int nDisplayFeedback=TRUE, int nIgnoreDeathImmunity=FALSE, int bPurgeEffects=TRUE);

// Create a Knockdown effect
// This effect knocks creatures off their feet, they will sit until the effect
// is removed. This should be applied as a temporary effect with a 3 second
// duration minimum (1 second to fall, 1 second sitting, 1 second to get up).
effect EffectKnockdown();

// Give oItem to oGiveTo
// If oItem is not a valid item, or oGiveTo is not a valid object, nothing will
// happen.
void ActionGiveItem(object oItem, object oGiveTo, int bDisplayFeedback=TRUE);

// Take oItem from oTakeFrom
// If oItem is not a valid item, or oTakeFrom is not a valid object, nothing
// will happen.
void ActionTakeItem(object oItem, object oTakeFrom, int bDisplayFeedback=TRUE);

// Normalize vVector
vector VectorNormalize(vector vVector);

// Create a Curse effect.
// - nStrMod: strength modifier
// - nDexMod: dexterity modifier
// - nConMod: constitution modifier
// - nIntMod: intelligence modifier
// - nWisMod: wisdom modifier
// - nChaMod: charisma modifier
effect EffectCurse(int nStrMod=1, int nDexMod=1, int nConMod=1, int nIntMod=1, int nWisMod=1, int nChaMod=1);

// Get the ability score of type nAbility for a creature (otherwise 0)
// - oCreature: the creature whose ability score we wish to find out
// - nAbilityType: ABILITY_*
// - RWT-OEI 03/13/07 - If nBaseAbilityScore is TRUE, then the value returned will be
//   the base attribute score, ignoring any bonuses, racial or otherwise.
// Return value on error: 0
int GetAbilityScore(object oCreature, int nAbilityType, int nBaseAttribute=FALSE);

// * Returns TRUE if oCreature is a dead NPC, dead PC or a dying PC.
int GetIsDead(object oCreature, int bIgnoreDying=FALSE);

// Output vVector to the logfile.
// - vVector
// - bPrepend: if this is TRUE, the message will be prefixed with "PRINTVECTOR:"
void PrintVector(vector vVector, int bPrepend);

// Create a vector with the specified values for x, y and z
vector Vector(float x=0.0f, float y=0.0f, float z=0.0f);

// Cause the caller to face vTarget
//RWT-OEI 12/20/04 - If the 2nd parameter is passed as TRUE, then the dialog
//manager will not go trying to adjust the caller for the remainder of the
//dialog. This lock is only in effect for the currently active dialog.
void SetFacingPoint(vector vTarget, int bLockToThisOrientation = FALSE);

// Convert fAngle to a vector
vector AngleToVector(float fAngle);

// Convert vVector to an angle
float VectorToAngle(vector vVector);

// The caller will perform a Melee Touch Attack on oTarget
// This is not an action, and it assumes the caller is already within range of
// oTarget
// * nBonus is an additonal bonus to the attack roll.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
// * UPDATE - Brock H - 08/16/05 -
// * These return TOUCH_ATTACK_RESULT_MISS, TOUCH_ATTACK_RESULT_HIT, or TOUCH_ATTACK_RESULT_CRITICAL
int TouchAttackMelee(object oTarget, int bDisplayFeedback=TRUE, int nBonus=0);

// The caller will perform a Ranged Touch Attack on oTarget
// * nBonus is an additonal bonus to the attack roll.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
// * UPDATE - Brock H - 08/16/05 -
// * These return TOUCH_ATTACK_RESULT_MISS, TOUCH_ATTACK_RESULT_HIT, or TOUCH_ATTACK_RESULT_CRITICAL
int TouchAttackRanged(object oTarget, int bDisplayFeedback=TRUE, int nBonus=0);

// Create a Paralyze effect
// In 3.5 paralysis effects allow a save every round to break out.  Due to the vagaries of spell
// DC calculations, you need to pass in a save DC for this round-by-round save.  If you pass in -1
// the code will try to extrapolate the save DC, but it is very, very likely to be wrong.
// - nSaveDC: the round-by-round save to break out of paralysis.
// - nSave: SAVING_THROW_*.  Must be WILL, FORT, or REFLEX
// - bSaveEveryRound: If TRUE, the paralysis effect gives the target a save every round, if FALSE,
//  the paralysis effect lasts for the duration with no save.
effect EffectParalyze(int nSaveDC=-1, int nSave=SAVING_THROW_WILL, int bSaveEveryRound = TRUE);

// Create a Spell Immunity effect.
// There is a known bug with this function. There *must* be a parameter specified
// when this is called (even if the desired parameter is SPELL_ALL_SPELLS),
// otherwise an effect of type EFFECT_TYPE_INVALIDEFFECT will be returned.
// - nImmunityToSpell: SPELL_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nImmunityToSpell is
//   invalid.
effect EffectSpellImmunity(int nImmunityToSpell=SPELL_ALL_SPELLS);

// Create a Deaf effect
effect EffectDeaf();

// Get the distance in metres between oObjectA and oObjectB.
// * Return value if either object is invalid: 0.0f
float GetDistanceBetween(object oObjectA, object oObjectB);

// Set oObject's local location variable sVarname to lValue
void SetLocalLocation(object oObject, string sVarName, location lValue);

// Get oObject's local location variable sVarname
location GetLocalLocation(object oObject, string sVarName);

// Create a Sleep effect
effect EffectSleep();

// Get the object which is in oCreature's specified inventory slot
// - nInventorySlot: INVENTORY_SLOT_*
// - oCreature
// * Returns OBJECT_INVALID if oCreature is not a valid creature or there is no
//   item in nInventorySlot.
object GetItemInSlot(int nInventorySlot, object oCreature=OBJECT_SELF);

// Create a Charm effect
effect EffectCharmed();

// Create a Confuse effect
effect EffectConfused();

// Create a Frighten effect
effect EffectFrightened();

// Create a Dominate effect
effect EffectDominated();

// Create a Daze effect
effect EffectDazed();

// Create a Stun effect
effect EffectStunned();

// Set whether oTarget's action stack can be modified
void SetCommandable(int bCommandable, object oTarget=OBJECT_SELF);

// Determine whether oTarget's action stack can be modified.
int GetCommandable(object oTarget=OBJECT_SELF);

// Create a Regenerate effect.
// - nAmount: amount of damage to be regenerated per time interval
// - fIntervalSeconds: length of interval in seconds
effect EffectRegenerate(int nAmount, float fIntervalSeconds);

// Create a Movement Speed Increase effect.
// - nPercentChange - range 0 through 99
// eg.
//    0 = no change in speed
//   50 = 50% faster
//   99 = almost twice as fast
effect EffectMovementSpeedIncrease(int nPercentChange);

// Get the number of hitdice for oCreature.
// * Return value if oCreature is not a valid creature: 0
int GetHitDice(object oCreature);

// The action subject will follow oFollow until a ClearAllActions() is called.
// - oFollow: this is the object to be followed
// - fFollowDistance: follow distance in metres
// - iFollowPosition: the offset position behind the oFollow object to run to
// * No return value
// Note that the minimum follow distance is 0.5. Any number lower than that will be
// set to 0.5
void ActionForceFollowObject(object oFollow, float fFollowDistance=0.5f, int iFollowPosition = 0);

// Get the Tag of oObject
// * Return value if oObject is not a valid object: ""
string GetTag(object oObject);

// Do a Spell Resistance check between oCaster and oTarget, returning TRUE if
// the spell was resisted.
// * Return value if oCaster or oTarget is an invalid object: 0
// * Return value if spell cast is not a player spell: - 1
// * Return value if spell resisted: 1
// * Return value if spell resisted via magic immunity: 2
// * Return value if spell resisted via spell absorption: 3
int ResistSpell(object oCaster, object oTarget);

// Get the effect type (EFFECT_TYPE_*) of eEffect.
// * Return value if eEffect is invalid: EFFECT_INVALIDEFFECT
int GetEffectType(effect eEffect);

// Create an Area Of Effect effect in the area of the creature it is applied to.
// If the scripts are not specified, default ones will be used.
// You can also specify a tag for the effect object that will be created when
// the effect is applied.
// Brock H. - OEI 04/21/06 -- Added sEffectTag - this is a tag which will
// be set on the spawned AoE object, so that it can be accessed later.
effect EffectAreaOfEffect(int nAreaEffectId, string sOnEnterScript="", string sHeartbeatScript="", string sOnExitScript="", string sEffectTag="" );

// * Returns TRUE if the Faction Ids of the two objects are the same
int GetFactionEqual(object oFirstObject, object oSecondObject=OBJECT_SELF);

// Make oObjectToChangeFaction join the faction of oMemberOfFactionToJoin.
// NB. ** This will only work for two NPCs **
void ChangeFaction(object oObjectToChangeFaction, object oMemberOfFactionToJoin);

// * Returns TRUE if oObject is listening for something
int GetIsListening(object oObject);

// Set whether oObject is listening.
void SetListening(object oObject, int bValue);

// Set the string for oObject to listen for.
// Note: this does not set oObject to be listening.
void SetListenPattern(object oObject, string sPattern, int nNumber=0);

// * Returns TRUE if sStringToTest matches sPattern.
int TestStringAgainstPattern(string sPattern, string sStringToTest);

// Get the appropriate matched string (this should only be used in
// OnConversation scripts).
// * Returns the appropriate matched string, otherwise returns ""
string GetMatchedSubstring(int nString);

// Get the number of string parameters available.
// * Returns -1 if no string matched (this could be because of a dialogue event)
int GetMatchedSubstringsCount();

// * Create a Visual Effect that can be applied to an object.
// - nVisualEffectId
// - nMissEffect: if this is TRUE, a random vector near or past the target will
//   be generated, on which to play the effect
effect EffectVisualEffect(int nVisualEffectId, int nMissEffect=FALSE);

// Get the weakest member of oFactionMember's faction.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionWeakestMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the strongest member of oFactionMember's faction.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionStrongestMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the member of oFactionMember's faction that has taken the most hit points
// of damage.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionMostDamagedMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the member of oFactionMember's faction that has taken the fewest hit
// points of damage.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionLeastDamagedMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the amount of gold held by oFactionMember's faction.
// * Returns -1 if oFactionMember's faction is invalid.
int GetFactionGold(object oFactionMember);

// Get an integer between 0 and 100 (inclusive) that represents how
// oSourceFactionMember's faction feels about oTarget.
// * Return value on error: -1
int GetFactionAverageReputation(object oSourceFactionMember, object oTarget);

// Get an integer between 0 and 100 (inclusive) that represents the average
// good/evil alignment of oFactionMember's faction.
// * Return value on error: -1
int GetFactionAverageGoodEvilAlignment(object oFactionMember);

// Get an integer between 0 and 100 (inclusive) that represents the average
// law/chaos alignment of oFactionMember's faction.
// * Return value on error: -1
int GetFactionAverageLawChaosAlignment(object oFactionMember);

// Get the average level of the members of the faction.
// * Return value on error: -1
int GetFactionAverageLevel(object oFactionMember);

// Get the average XP of the members of the faction.
// * Return value on error: -1
int GetFactionAverageXP(object oFactionMember);

// Get the most frequent class in the faction - this can be compared with the
// constants CLASS_TYPE_*.
// * Return value on error: -1
int GetFactionMostFrequentClass(object oFactionMember);

// Get the object faction member with the lowest armour class.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionWorstAC(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the object faction member with the highest armour class.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionBestAC(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Sit in oChair.
// Note: not all creatures will be able to sit.
void ActionSit(object oChair);

// In an onConversation script this gets the number of the string pattern
// matched (the one that triggered the script).
// * Returns -1 if no string matched
int GetListenPatternNumber();

// Jump to an object ID, or as near to it as possible.
void ActionJumpToObject(object oToJumpTo, int bWalkStraightLineToPoint=TRUE);

// Get the first waypoint with the specified tag.
// * Returns OBJECT_INVALID if the waypoint cannot be found.
object GetWaypointByTag(string sWaypointTag);

// Get the destination (a waypoint or a door) for a trigger or a door.
// * Returns OBJECT_INVALID if oTransition is not a valid trigger or door.
object GetTransitionTarget(object oTransition);

// Link the two supplied effects, returning eChildEffect as a child of
// eParentEffect.
// Note: When applying linked effects if the target is immune to all valid
// effects all other effects will be removed as well. This means that if you
// apply a visual effect and a silence effect (in a link) and the target is
// immune to the silence effect that the visual effect will get removed as well.
// Visual Effects are not considered "valid" effects for the purposes of
// determining if an effect will be removed or not and as such should never be
// packaged *only* with other visual effects in a link.
effect EffectLinkEffects(effect eChildEffect, effect eParentEffect );

// Get the nNth object with the specified tag.
// - sTag
// - nNth: the nth object with this tag may be requested
// * Returns OBJECT_INVALID if the object cannot be found.
// Note: The module cannot be retrieved by GetObjectByTag(), use GetModule() instead.
object GetObjectByTag(string sTag, int nNth=0);

// Adjust the alignment of oSubject.
// - oSubject
// - nAlignment:
//   -> ALIGNMENT_LAWFUL/ALIGNMENT_CHAOTIC/ALIGNMENT_GOOD/ALIGNMENT_EVIL: oSubject's
//      alignment will be shifted in the direction specified
//   -> ALIGNMENT_ALL: nShift will be added to oSubject's law/chaos and
//      good/evil alignment values
//   -> ALIGNMENT_NEUTRAL: nShift is applied to oSubject's law/chaos and
//      good/evil alignment values in the direction which is towards neutrality.
//     e.g. If oSubject has a law/chaos value of 10 (i.e. chaotic) and a
//          good/evil value of 80 (i.e. good) then if nShift is 15, the
//          law/chaos value will become (10+15)=25 and the good/evil value will
//          become (80-25)=55
//     Furthermore, the shift will at most take the alignment value to 50 and
//     not beyond.
//     e.g. If oSubject has a law/chaos value of 40 and a good/evil value of 70,
//          then if nShift is 15, the law/chaos value will become 50 and the
//          good/evil value will become 55
// - nShift: this is the desired shift in alignment
// * No return value
void AdjustAlignment(object oSubject, int nAlignment, int nShift);

// Do nothing for fSeconds seconds.
void ActionWait(float fSeconds);

// Set the transition bitmap of a player; this should only be called in area
// transition scripts. This action should be run by the person "clicking" the
// area transition via AssignCommand.
// - nPredefinedAreaTransition:
//   -> To use a predefined area transition bitmap, use one of AREA_TRANSITION_*
//   -> To use a custom, user-defined area transition bitmap, use
//      AREA_TRANSITION_USER_DEFINED and specify the filename in the second
//      parameter
// - sCustomAreaTransitionBMP: this is the filename of a custom, user-defined
//   area transition bitmap
void SetAreaTransitionBMP(int nPredefinedAreaTransition, string sCustomAreaTransitionBMP="");

// Starts a conversation with oObjectToConverseWith - this will cause their
// OnDialog event to fire.
// - oObjectToConverseWith
// - sDialogResRef: If this is blank, the creature's own dialogue file will be used
// - bPrivateConversation
// Turn off bPlayHello if you don't want the initial greeting to play
void ActionStartConversation(object oObjectToConverseWith, string sDialogResRef="", int bPrivateConversation=FALSE, int bPlayHello=TRUE, int bIgnoreStartDistance=FALSE, int bDisableCutsceneBars=FALSE);

// Pause the current conversation.
void ActionPauseConversation();

// Resume a conversation after it has been paused.
void ActionResumeConversation();

// Create a Beam effect.
// - nBeamVisualEffect: VFX_BEAM_*
// - oEffector: the beam is emitted from this creature
// - nBodyPart: BODY_NODE_*
// - bMissEffect: If this is TRUE, the beam will fire to a random vector near or
//   past the target
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nBeamVisualEffect is
//   not valid.
effect EffectBeam(int nBeamVisualEffect, object oEffector, int nBodyPart, int bMissEffect=FALSE);

// Get an integer between 0 and 100 (inclusive) that represents how oSource
// feels about oTarget.
// -> 0-10 means oSource is hostile to oTarget
// -> 11-89 means oSource is neutral to oTarget
// -> 90-100 means oSource is friendly to oTarget
// * Returns -1 if oSource or oTarget does not identify a valid object
int GetReputation(object oSource, object oTarget);

// Adjust how oSourceFactionMember's faction feels about oTarget by the
// specified amount.
// Note: This adjusts Faction Reputation, how the entire faction that
// oSourceFactionMember is in, feels about oTarget.
// * No return value
void AdjustReputation(object oTarget, object oSourceFactionMember, int nAdjustment);

// Get the creature that is currently sitting on the specified object.
// - oChair
// * Returns OBJECT_INVALID if oChair is not a valid placeable.
object GetSittingCreature(object oChair);

// Get the creature that is going to attack oTarget.
// Note: This value is cleared out at the end of every combat round and should
// not be used in any case except when getting a "going to be attacked" shout
// from the master creature (and this creature is a henchman)
// * Returns OBJECT_INVALID if oTarget is not a valid creature.
object GetGoingToBeAttackedBy(object oTarget);

// Create a Spell Resistance Increase effect.
// - nValue: size of spell resistance increase
// - nUses: the number of times this effect can be used in spell
//          resistance checks before it is removed. -1 is "infinite"
effect EffectSpellResistanceIncrease(int nValue, int nUses = -1 );

// Get the location of oObject.
location GetLocation(object oObject);

// The subject will jump to lLocation instantly (even between areas).
// If lLocation is invalid, nothing will happen.
void ActionJumpToLocation(location lLocation);

// Create a location.
location Location(object oArea, vector vPosition, float fOrientation);

// Apply eEffect at lLocation.
void ApplyEffectAtLocation(int nDurationType, effect eEffect, location lLocation, float fDuration=0.0f);

// * Returns TRUE if oCreature is a Player Controlled character.
// NOTE: If the passed in creature is owned by the player, but the player is
//       currently controlling another creature, this will return FALSE
//       To check for ownership, see GetIsOwnedByPlayer()
int GetIsPC(object oCreature);

// Convert fFeet into a number of meters.
float FeetToMeters(float fFeet);

// Convert fYards into a number of meters.
float YardsToMeters(float fYards);

// Apply eEffect to oTarget.
void ApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f);

// The caller will immediately speak sStringToSpeak (this is different from
// ActionSpeakString)
// - sStringToSpeak
// - nTalkVolume: TALKVOLUME_*
void SpeakString(string sStringToSpeak, int nTalkVolume=TALKVOLUME_TALK);

// Get the location of the caller's last spell target.
location GetSpellTargetLocation();

// Get the position vector from lLocation.
vector GetPositionFromLocation(location lLocation);

// Get the area's object ID from lLocation.
object GetAreaFromLocation(location lLocation);

// Get the orientation value from lLocation.
float GetFacingFromLocation(location lLocation);

// Get the creature nearest to lLocation, subject to all the criteria specified.
// - nFirstCriteriaType: CREATURE_TYPE_*
// - nFirstCriteriaValue:
//   -> CLASS_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_CLASS
//   -> SPELL_* if nFirstCriteriaType was CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT
//      or CREATURE_TYPE_HAS_SPELL_EFFECT
//   -> CREATURE_ALIVE_TRUE or CREATURE_ALIVE_FALSE if nFirstCriteriaType was CREATURE_TYPE_IS_ALIVE
//      Or use CREATURE_ALIVE_BOTH to search both DEAD or ALIVE
//      Default search considers creatures that are alive ONLY!
//   -> PERCEPTION_* if nFirstCriteriaType was CREATURE_TYPE_PERCEPTION
//   -> PLAYER_CHAR_IS_PC or PLAYER_CHAR_NOT_PC if nFirstCriteriaType was
//      CREATURE_TYPE_PLAYER_CHAR
//   -> RACIAL_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_RACIAL_TYPE
//   -> REPUTATION_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_REPUTATION
//   -> CREATURE_SCRIPTHIDDEN_* if nFirstCriteriaType was CREATURE_TYPE_SCRIPTHIDDEN
//   For example, to get the nearest PC, use
//   (CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC)
// - lLocation: We're trying to find the creature of the specified type that is
//   nearest to lLocation
// - nNth: We don't have to find the first nearest: we can find the Nth nearest....
// - nSecondCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nSecondCriteriaValue: This is used in the same way as nFirstCriteriaValue
//   to further specify the type of creature that we are looking for.
// - nThirdCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nThirdCriteriaValue: This is used in the same way as nFirstCriteriaValue to
//   further specify the type of creature that we are looking for.
// * Return value on error: OBJECT_INVALID
object GetNearestCreatureToLocation(int nFirstCriteriaType, int nFirstCriteriaValue,  location lLocation, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1 );

// Get the Nth object nearest to oTarget that is of the specified type.
// - nObjectType: OBJECT_TYPE_*
// - oTarget
// - nNth
// * Return value on error: OBJECT_INVALID
object GetNearestObject(int nObjectType=OBJECT_TYPE_ALL, object oTarget=OBJECT_SELF, int nNth=1);

// Get the nNth object nearest to lLocation that is of the specified type.
// - nObjectType: OBJECT_TYPE_*
// - lLocation
// - nNth
// * Return value on error: OBJECT_INVALID
object GetNearestObjectToLocation(int nObjectType, location lLocation, int nNth=1);

// Get the nth Object nearest to oTarget that has sTag as its tag.
// * Return value on error: OBJECT_INVALID
object GetNearestObjectByTag(string sTag, object oTarget=OBJECT_SELF, int nNth=1);

// Convert nInteger into a floating point number.
float IntToFloat(int nInteger);

// Convert fFloat into the nearest integer.
int FloatToInt(float fFloat);

// Convert sNumber into an integer.
int StringToInt(string sNumber);

// Convert sNumber into a floating point number.
float StringToFloat(string sNumber);

// Cast spell nSpell at lTargetLocation.
// - nSpell: SPELL_*
// - lTargetLocation
// - nMetaMagic: METAMAGIC_*
// - bCheat: If this is TRUE, then the executor of the action doesn't have to be
//   able to cast the spell.
// - nDomainLevel: TBD - SS
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
// - bInstantSpell: If this is TRUE, the spell is cast immediately; this allows
//   the end-user to simulate
//   a high-level magic user having lots of advance warning of impending trouble.
void   ActionCastSpellAtLocation(int nSpell, location lTargetLocation, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int nDomainLevel=0);

// * Returns TRUE if oSource considers oTarget as an enemy.
int GetIsEnemy(object oTarget, object oSource=OBJECT_SELF);

// * Returns TRUE if oSource considers oTarget as a friend.
int GetIsFriend(object oTarget, object oSource=OBJECT_SELF);

// * Returns TRUE if oSource considers oTarget as neutral.
int GetIsNeutral(object oTarget, object oSource=OBJECT_SELF);

// Get the PC that is involved in the conversation.
// * Returns OBJECT_INVALID on error.
object GetPCSpeaker();

// Get a string from the talk table using nStrRef.
string GetStringByStrRef(int nStrRef, int nGender=GENDER_MALE);

// Causes the creature to speak a translated string.
// - nStrRef: Reference of the string in the talk table
// - nTalkVolume: TALKVOLUME_*
void ActionSpeakStringByStrRef(int nStrRef, int nTalkVolume=TALKVOLUME_TALK);

// Destroy oObject (irrevocably).
// This will not work on modules and areas.
// RWT-OEI 08/15/07 - If nDisplayFeedback is false, and the object being
//  destroyed is an item from a player's inventory, the player will not
//  be notified of the item being destroyed.
void DestroyObject(object oDestroy, float fDelay=0.0f, int nDisplayFeedback=TRUE);

// Get the module.
// * Return value on error: OBJECT_INVALID
object GetModule();

// Create an object of the specified type at lLocation.
// - nObjectType: OBJECT_TYPE_ITEM, OBJECT_TYPE_CREATURE, OBJECT_TYPE_PLACEABLE,
//   OBJECT_TYPE_STORE, OBJECT_TYPE_WAYPOINT
// - sTemplate
// - lLocation
// - bUseAppearAnimation
// - sNewTag - if this string is not empty, it will replace the default tag from the template
object CreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="");

// Create an event which triggers the "SpellCastAt" script
event EventSpellCastAt(object oCaster, int nSpell, int bHarmful=TRUE);

// This is for use in a "Spell Cast" script, it gets who cast the spell.
// The spell could have been cast by a creature, placeable or door.
// * Returns OBJECT_INVALID if the caller is not a creature, placeable or door.
object GetLastSpellCaster();

// This is for use in a "Spell Cast" script, it gets the ID of the spell that
// was cast.
int GetLastSpell();

// This is for use in a user-defined script, it gets the event number.
int GetUserDefinedEventNumber();

// This is for use in a Spell script, it gets the ID of the spell that is being
// cast (SPELL_*).
int GetSpellId();

// Generate a random name.
string RandomName();

// Create a Poison effect.
// - nPoisonType: POISON_*
effect EffectPoison(int nPoisonType);

// Create a Disease effect.
// - nDiseaseType: DISEASE_*
effect EffectDisease(int nDiseaseType);

// Create a Silence effect.
effect EffectSilence();

// Get the name of oObject.
string GetName(object oObject);

// Use this in a conversation script to get the person with whom you are conversing.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetLastSpeaker();

// Use this in an OnDialog script to start up the dialog tree.
// - sResRef: if this is not specified, the default dialog file will be used
// - oObjectToDialog: if this is not specified the person that triggered the
//   event will be used
// - bPreventHello - If TRUE, keeps speaker from using their Hello greeting
int BeginConversation(string sResRef="", object oObjectToDialog=OBJECT_INVALID, int bPreventHello=FALSE);

// Use this in an OnPerception script to get the object that was perceived.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetLastPerceived();

// Use this in an OnPerception script to determine whether the object that was
// perceived was heard.
int GetLastPerceptionHeard();

// Use this in an OnPerception script to determine whether the object that was
// perceived has become inaudible.
int GetLastPerceptionInaudible();

// Use this in an OnPerception script to determine whether the object that was
// perceived was seen.
int GetLastPerceptionSeen();

// Use this in an OnClosed script to get the object that closed the door or placeable.
// * Returns OBJECT_INVALID if the caller is not a valid door or placeable.
object GetLastClosedBy();

// Use this in an OnPerception script to determine whether the object that was
// perceived has vanished.
int GetLastPerceptionVanished();

// Get the first object within oPersistentObject.
// - oPersistentObject
// - nResidentObjectType: OBJECT_TYPE_*
// - nPersistentZone: PERSISTENT_ZONE_ACTIVE. [This could also take the value
//   PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
// * Returns OBJECT_INVALID if no object is found.
object GetFirstInPersistentObject(object oPersistentObject=OBJECT_SELF, int nResidentObjectType=OBJECT_TYPE_CREATURE, int nPersistentZone=PERSISTENT_ZONE_ACTIVE);

// Get the next object within oPersistentObject.
// - oPersistentObject
// - nResidentObjectType: OBJECT_TYPE_*
// - nPersistentZone: PERSISTENT_ZONE_ACTIVE. [This could also take the value
//   PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
// * Returns OBJECT_INVALID if no object is found.
object GetNextInPersistentObject(object oPersistentObject=OBJECT_SELF, int nResidentObjectType=OBJECT_TYPE_CREATURE, int nPersistentZone=PERSISTENT_ZONE_ACTIVE);

// This returns the creator of oAreaOfEffectObject.
// * Returns OBJECT_INVALID if oAreaOfEffectObject is not a valid Area of Effect object.
object GetAreaOfEffectCreator(object oAreaOfEffectObject=OBJECT_SELF);

// Delete oObject's local integer variable sVarName
void DeleteLocalInt(object oObject, string sVarName);

// Delete oObject's local float variable sVarName
void DeleteLocalFloat(object oObject, string sVarName);

// Delete oObject's local string variable sVarName
void DeleteLocalString(object oObject, string sVarName);

// Delete oObject's local object variable sVarName
void DeleteLocalObject(object oObject, string sVarName);

// Delete oObject's local location variable sVarName
void DeleteLocalLocation(object oObject, string sVarName);

// Create a Haste effect.
effect EffectHaste();

// Create a Slow effect.
effect EffectSlow();

// Convert oObject into a hexadecimal string.
string ObjectToString(object oObject);

// Create an Immunity effect.
// - nImmunityType: IMMUNITY_TYPE_*
effect EffectImmunity(int nImmunityType);

// - oCreature
// - nImmunityType: IMMUNITY_TYPE_*
// - oVersus: if this is specified, then we also check for the race and
//   alignment of oVersus
// * Returns TRUE if oCreature has immunity of type nImmunity versus oVersus.
int GetIsImmune(object oCreature, int nImmunityType, object oVersus=OBJECT_INVALID);

// Creates a Damage Immunity Increase effect.
// - nDamageType: DAMAGE_TYPE_*
// - nPercentImmunity
effect EffectDamageImmunityIncrease(int nDamageType, int nPercentImmunity);

// Determine whether oEncounter is active.
int  GetEncounterActive(object oEncounter=OBJECT_SELF);

// Set oEncounter's active state to nNewValue.
// - nNewValue: TRUE/FALSE
// - oEncounter
void SetEncounterActive(int nNewValue, object oEncounter=OBJECT_SELF);

// Get the maximum number of times that oEncounter will spawn.
int GetEncounterSpawnsMax(object oEncounter=OBJECT_SELF);

// Set the maximum number of times that oEncounter can spawn
void SetEncounterSpawnsMax(int nNewValue, object oEncounter=OBJECT_SELF);

// Get the number of times that oEncounter has spawned so far
int  GetEncounterSpawnsCurrent(object oEncounter=OBJECT_SELF);

// Set the number of times that oEncounter has spawned so far
void SetEncounterSpawnsCurrent(int nNewValue, object oEncounter=OBJECT_SELF);

// Use this in an OnItemAcquired script to get the item that was acquired.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemAcquired();

// Use this in an OnItemAcquired script to get the creatre that previously
// possessed the item.
// * Returns OBJECT_INVALID if the item was picked up from the ground.
object GetModuleItemAcquiredFrom();

// Set the value for a custom token.
void SetCustomToken(int nCustomTokenNumber, string sTokenValue);

// Determine whether oCreature has nFeat, and nFeat is useable.
// - nFeat: FEAT_*
// - oCreature
// JLR - OEI 08/25/05 -- added param
// -- nIgnoreUses -- if true, ignores whether there are uses left for this Feat
int GetHasFeat(int nFeat, object oCreature=OBJECT_SELF, int nIgnoreUses=FALSE);

// Determine whether oCreature has nSkill, and nSkill is useable.
// - nSkill: SKILL_*
// - oCreature
int GetHasSkill(int nSkill, object oCreature=OBJECT_SELF);

// Use nFeat on oTarget.
// - nFeat: FEAT_*
// - oTarget
void ActionUseFeat(int nFeat, object oTarget);

// Runs the action "UseSkill" on the current creature
// Use nSkill on oTarget.
// - nSkill: SKILL_*
// - oTarget
// - nSubSkill: SUBSKILL_*
// - oItemUsed: Item to use in conjunction with the skill
// Brock H. - OEI 07/10/06 - Added return value, to indicate whether or not the
// action was successfully queued. Note that the action may still fail during execution.
int ActionUseSkill(int nSkill, object oTarget, int nSubSkill=0, object oItemUsed=OBJECT_INVALID );

// Determine whether oSource sees oTarget.
// NOTE: This *only* works on creatures, as visibility lists are not
//       maintained for non-creature objects.
int GetObjectSeen(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource hears oTarget.
// NOTE: This *only* works on creatures, as visibility lists are not
//       maintained for non-creature objects.
int GetObjectHeard(object oTarget, object oSource=OBJECT_SELF);

// Use this in an OnPlayerDeath module script to get the last player that died.
object GetLastPlayerDied();

// Use this in an OnItemLost script to get the item that was lost/dropped.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemLost();

// Use this in an OnItemLost script to get the creature that lost the item.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemLostBy();

// Do aActionToDo.
void ActionDoCommand(action aActionToDo);

// Conversation event.
event EventConversation();

// Set the difficulty level of oEncounter.
// - nEncounterDifficulty: ENCOUNTER_DIFFICULTY_*
// - oEncounter
void SetEncounterDifficulty(int nEncounterDifficulty, object oEncounter=OBJECT_SELF);

// Get the difficulty level of oEncounter.
int GetEncounterDifficulty(object oEncounter=OBJECT_SELF);

// Get the distance between lLocationA and lLocationB.
float GetDistanceBetweenLocations(location lLocationA, location lLocationB);

// Use this in spell scripts to get nDamage adjusted by oTarget's reflex and
// evasion saves.
// - nDamage
// - oTarget
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
int GetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Play nAnimation immediately.
// - nAnimation: ANIMATION_*
// - fSpeed
// - fSeconds
void PlayAnimation(int nAnimation, float fSpeed=1.0, float fSeconds=0.0);

// Create a Spell Talent.
// - nSpell: SPELL_*
talent TalentSpell(int nSpell);

// Create a Feat Talent.
// - nFeat: FEAT_*
talent TalentFeat(int nFeat);

// Create a Skill Talent.
// - nSkill: SKILL_*
talent TalentSkill(int nSkill);

// Determines whether oObject has any effects applied by nSpell
// - nSpell: SPELL_*
// - oObject
// * The spell id on effects is only valid if the effect is created
//   when the spell script runs. If it is created in a delayed command
//   then the spell id on the effect will be invalid.
int GetHasSpellEffect(int nSpell, object oObject=OBJECT_SELF);

// Get the spell (SPELL_*) that applied eSpellEffect.
// * Returns -1 if eSpellEffect was applied outside a spell script.
int GetEffectSpellId(effect eSpellEffect);

// Determine whether oCreature has tTalent.
int GetCreatureHasTalent(talent tTalent, object oCreature=OBJECT_SELF);

// Get a random talent of oCreature, within nCategory.
// - nCategory: TALENT_CATEGORY_*
// - oCreature
// - iExcludedTalentsFlag: TALENT_EXCLUDE_*
talent GetCreatureTalentRandom(int nCategory, object oCreature=OBJECT_SELF, int iExcludedTalentsFlag = 0);

// Get the best talent (i.e. closest to nCRMax without going over) of oCreature,
// within nCategory.
// - nCategory: TALENT_CATEGORY_*
// - nCRMax: Challenge Rating of the talent
// - oCreature
// - iExcludedTalentsFlag: TALENT_EXCLUDE_*
talent GetCreatureTalentBest(int nCategory, int nCRMax, object oCreature=OBJECT_SELF, int iExcludedTalentsFlag = 0);

// Use tChosenTalent on oTarget.
void ActionUseTalentOnObject(talent tChosenTalent, object oTarget);

// Use tChosenTalent at lTargetLocation.
void ActionUseTalentAtLocation(talent tChosenTalent, location lTargetLocation);

// Get the gold piece value of oItem.
// * Returns 0 if oItem is not a valid item.
int GetGoldPieceValue(object oItem);

// * Returns TRUE if oCreature is of a playable racial type.
int GetIsPlayableRacialType(object oCreature);

// Jump to lDestination.  The action is added to the TOP of the action queue.
void JumpToLocation(location lDestination);

// Create a Temporary Hitpoints effect.
// - nHitPoints: a positive integer
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nHitPoints < 0.
effect EffectTemporaryHitpoints(int nHitPoints);

// Get the number of ranks that oTarget has in nSkill.
// - nSkill: SKILL_*
// - oTarget
// - bBaseOnly: If TRUE, returns base skill ranks only, otherwise adds in all modifiers.
// * Returns -1 if oTarget doesn't have nSkill.
// * Returns 0 if nSkill is untrained.
int GetSkillRank(int nSkill, object oTarget=OBJECT_SELF, int bBaseOnly=FALSE );

// Get the attack target of oCreature.
// This only works when oCreature is in combat.
object GetAttackTarget(object oCreature=OBJECT_SELF);

// Get the attack type (SPECIAL_ATTACK_*) of oCreature's last attack.
// This only works when oCreature is in combat.
int GetLastAttackType(object oCreature=OBJECT_SELF);

// Get the attack mode (COMBAT_MODE_*) of oCreature's last attack.
// This only works when oCreature is in combat.
int GetLastAttackMode(object oCreature=OBJECT_SELF);

// Get the master of oAssociate.
object GetMaster(object oAssociate=OBJECT_SELF);

// * Returns TRUE if oCreature is in combat.
int GetIsInCombat(object oCreature=OBJECT_SELF);

// Get the last command (ASSOCIATE_COMMAND_*) issued to oAssociate.
int GetLastAssociateCommand(object oAssociate=OBJECT_SELF);

// Give nGP gold to oCreature.
// bDisplayFeedback - if set to FALSE, will not display the feedback string
//  in the player's chatlog.
void GiveGoldToCreature(object oCreature, int nGP, int bDisplayFeedback=TRUE );

// Set the destroyable status of the caller.
// - bDestroyable: If this is FALSE, the caller does not fade out on death, but
//   sticks around as a corpse.
// - bRaiseable: If this is TRUE, the caller can be raised via resurrection.
// - bSelectableWhenDead: If this is TRUE, the caller is selectable after death.
void SetIsDestroyable(int bDestroyable, int bRaiseable=TRUE, int bSelectableWhenDead=FALSE);

// Set the locked state of oTarget, which can be a door or a placeable object.
void SetLocked(object oTarget, int bLocked);

// Get the locked state of oTarget, which can be a door or a placeable object.
int GetLocked(object oTarget);

// Use this in a trigger's OnClick event script to get the object that last
// clicked on it.
// This is identical to GetEnteringObject.
object GetClickingObject();

// Initialise oTarget to listen for the standard Associates commands.
// * Defined in gb_setassociatelistenpatterns.nss
void SetAssociateListenPatterns( object oTarget=OBJECT_SELF );

// Get the last weapon that oCreature used in an attack.
// * Returns OBJECT_INVALID if oCreature did not attack, or has no weapon equipped.
object GetLastWeaponUsed(object oCreature);

// Use oPlaceable.
void ActionInteractObject(object oPlaceable);

// Get the last object that used the placeable object that is calling this function.
// * Returns OBJECT_INVALID if it is called by something other than a placeable or
//   a door.
object GetLastUsedBy();

// Returns the ability modifier for the specified ability
// Get oCreature's ability modifier for nAbility.
// - nAbility: ABILITY_*
// - oCreature
int GetAbilityModifier(int nAbility, object oCreature=OBJECT_SELF);

// Determined whether oItem has been identified.
int GetIdentified(object oItem);

// Set whether oItem has been identified.
void SetIdentified(object oItem, int bIdentified);

// Summon an Animal Companion
// oMaster - the animal companion owner. If owner does not have the appropriate feat, nothing will happen.
// sResRef - resref of creature to summon.  Character choice will be used if blank.
// MAP 3/24/09 - modified to allow caller to specify an override for the companion
void SummonAnimalCompanion(object oMaster=OBJECT_SELF, string sResRef = "");

// Summon a Familiar
// oMaster - the familiar  owner. If owner does not have the appropriate feat, nothing will happen.
// sResRef - resref of creature to summon.  Character choice will be used if blank.
// MAP 3/24/09 - modified to allow caller to specify an override for the familiar.
void SummonFamiliar(object oMaster=OBJECT_SELF, string sResRef = "");

// Get the last blocking door encountered by the caller of this function.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetBlockingDoor();

// - oTargetDoor
// - nDoorAction: DOOR_ACTION_*
// * Returns TRUE if nDoorAction can be performed on oTargetDoor.
int GetIsDoorActionPossible(object oTargetDoor, int nDoorAction);

// Perform nDoorAction on oTargetDoor.
void DoDoorAction(object oTargetDoor, int nDoorAction);

// Get the first item in oTarget's inventory (start to cycle through oTarget's
// inventory).
// * Returns OBJECT_INVALID if the caller is not a creature, item, placeable or store,
//   or if no item is found.
object GetFirstItemInInventory(object oTarget=OBJECT_SELF);

// Get the next item in oTarget's inventory (continue to cycle through oTarget's
// inventory).
// * Returns OBJECT_INVALID if the caller is not a creature, item, placeable or store,
//   or if no item is found.
object GetNextItemInInventory(object oTarget=OBJECT_SELF);

// A creature can have up to three classes.  This function determines the
// creature's class (CLASS_TYPE_*) based on nClassPosition.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns CLASS_TYPE_INVALID if the oCreature does not have a class in
//   nClassPosition (i.e. a single-class creature will only have a value in
//   nClassLocation=1) or if oCreature is not a valid creature.
int GetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF);

// A creature can have up to three classes.  This function determines the
// creature's class level based on nClass Position.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns 0 if oCreature does not have a class in nClassPosition
//   (i.e. a single-class creature will only have a value in nClassLocation=1)
//   or if oCreature is not a valid creature.
int GetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF);

// Determine the levels that oCreature holds in nClassType.
// - nClassType: CLASS_TYPE_*
// - oCreature
int GetLevelByClass(int nClassType, object oCreature=OBJECT_SELF);

// Get the amount of damage of type nDamageType that has been dealt to the caller.
// - nDamageType: DAMAGE_TYPE_*
int GetDamageDealtByType(int nDamageType);

// Get the total amount of damage that has been dealt to the caller.
int GetTotalDamageDealt();

// Get the last object that damaged oObject
// * Returns OBJECT_INVALID if the passed in object is not a valid object.
object GetLastDamager(object oObject=OBJECT_SELF);

// Get the last object that disarmed the trap on the caller.
// * Returns OBJECT_INVALID if the caller is not a valid placeable, trigger or
//   door.
object GetLastDisarmed();

// Get the last object that disturbed the inventory of the caller.
// * Returns OBJECT_INVALID if the caller is not a valid creature or placeable.
object GetLastDisturbed();

// Get the last object that locked the caller.
// * Returns OBJECT_INVALID if the caller is not a valid door or placeable.
object GetLastLocked();

// Get the last object that unlocked the caller.
// * Returns OBJECT_INVALID if the caller is not a valid door or placeable.
object GetLastUnlocked();

// Create a Skill Increase effect.
// - nSkill: SKILL_*
// - nValue
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nSkill is invalid.
effect EffectSkillIncrease(int nSkill, int nValue);

// Get the type of disturbance (INVENTORY_DISTURB_*) that caused the caller's
// OnInventoryDisturbed script to fire.  This will only work for creatures and
// placeables.
int GetInventoryDisturbType();

// get the item that caused the caller's OnInventoryDisturbed script to fire.
// * Returns OBJECT_INVALID if the caller is not a valid object.
object GetInventoryDisturbItem();

// Get the henchman belonging to oMaster.
// * Return OBJECT_INVALID if oMaster does not have a henchman.
// -nNth: Which henchman to return.
object GetHenchman(object oMaster=OBJECT_SELF,int nNth=1);

// Set eEffect to be versus a specific alignment.
// - eEffect
// - nLawChaos: ALIGNMENT_LAWFUL/ALIGNMENT_CHAOTIC/ALIGNMENT_ALL
// - nGoodEvil: ALIGNMENT_GOOD/ALIGNMENT_EVIL/ALIGNMENT_ALL
/*
    The following is a list of the effect types that can be modified by this constructor:
    Attack Increase
    Attack Decrease
    Damage Increase
    Damage Decrease
    Sanctuary
    Invisibility
    Concealment
    Damage Resistance
    Damage Reduction (NWN1)
    Immunity Increase
    Immunity Decrease
    Immunity
    AC Increase
    AC Decrease
    Spell Resistance Incease
    Spell Resistance Decrease
    Saving Throw Increase
    Saving Throw Decrease
    Skill Incease
    Skill Decrease

    Be advised that this is the COMPREHENSIVE list!  Other effect types will not
    be modified, even if you pass a valid effect as the first parameter!

*/
effect VersusAlignmentEffect(effect eEffect, int nLawChaos=ALIGNMENT_ALL, int nGoodEvil=ALIGNMENT_ALL);

// Set eEffect to be versus nRacialType.
// - eEffect
// - nRacialType: RACIAL_TYPE_*
effect VersusRacialTypeEffect(effect eEffect, int nRacialType);

// Set eEffect to be versus traps.
effect VersusTrapEffect(effect eEffect);

// Get the gender of oCreature.
int GetGender(object oCreature);

// * Returns TRUE if tTalent is valid.
int GetIsTalentValid(talent tTalent);

// Causes the action subject to move away from lMoveAwayFrom.
void ActionMoveAwayFromLocation(location lMoveAwayFrom, int bRun=FALSE, float fMoveAwayRange=40.0f);

// Get the target that the caller attempted to attack - this should be used in
// conjunction with GetAttackTarget(). This value is set every time an attack is
// made, and is reset at the end of combat.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetAttemptedAttackTarget();

// Get the type (TALENT_TYPE_*) of tTalent.
int GetTypeFromTalent(talent tTalent);

// Get the ID of tTalent.  This could be a SPELL_*, FEAT_* or SKILL_*.
int GetIdFromTalent(talent tTalent);

// Get the associate of type nAssociateType belonging to oMaster.
// - nAssociateType: ASSOCIATE_TYPE_*
// - nMaster
// - nTh: Which associate of the specified type to return
// * Returns OBJECT_INVALID if no such associate exists.
object GetAssociate(int nAssociateType, object oMaster=OBJECT_SELF, int nTh=1);

// Add oHenchman as a henchman to oMaster
// If oHenchman is either a DM or a player character, this will have no effect.
void AddHenchman(object oMaster, object oHenchman=OBJECT_SELF);

// Remove oHenchman from the service of oMaster, returning them to their original faction.
void RemoveHenchman(object oMaster, object oHenchman=OBJECT_SELF);

// Add a journal quest entry to oCreature.
// - szPlotID: the plot identifier used in the toolset's Journal Editor
// - nState: the state of the plot as seen in the toolset's Journal Editor
// - oCreature
// - bAllPartyMembers: If this is TRUE, the entry will show up in the journal of
//   everyone in the party
// - bAllPlayers: If this is TRUE, the entry will show up in the journal of
//   everyone in the world
// - bAllowOverrideHigher: If this is TRUE, you can set the state to a lower
//   number than the one it is currently on
void AddJournalQuestEntry(string szPlotID, int nState, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE);

// Remove a journal quest entry from oCreature.
// - szPlotID: the plot identifier used in the toolset's Journal Editor
// - oCreature
// - bAllPartyMembers: If this is TRUE, the entry will be removed from the
//   journal of everyone in the party
// - bAllPlayers: If this is TRUE, the entry will be removed from the journal of
//   everyone in the world
void RemoveJournalQuestEntry(string szPlotID, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE);

// Get the public part of the CD Key that oPlayer used when logging in.
string GetPCPublicCDKey(object oPlayer);

// Get the IP address from which oPlayer has connected.
string GetPCIPAddress(object oPlayer);

// Get the name of oPlayer.
string GetPCPlayerName(object oPlayer);

// Sets oPlayer and oTarget to like each other.
void SetPCLike(object oPlayer, object oTarget);

// Sets oPlayer and oTarget to dislike each other.
void SetPCDislike(object oPlayer, object oTarget);

// Send a server message (szMessage) to the oPlayer.
void SendMessageToPC(object oPlayer, string szMessage);

// Get the target at which the caller attempted to cast a spell.
// This value is set every time a spell is cast and is reset at the end of
// combat.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetAttemptedSpellTarget();

// Get the last creature that opened the caller.
// * Returns OBJECT_INVALID if the caller is not a valid door, placeable or store.
object GetLastOpenedBy();

// Determines the number of times that oCreature has nSpell memorised.
// - nSpell: SPELL_*
// - oCreature
int GetHasSpell(int nSpell, object oCreature=OBJECT_SELF);

// Open oStore for oPC.
// - nBonusMarkUp is added to the stores default mark up percentage on items sold (-100 to 100)
// - nBonusMarkDown is added to the stores default mark down percentage on items bought (-100 to 100)
void OpenStore(object oStore, object oPC, int nBonusMarkUp=0, int nBonusMarkDown=0);

// Create a Turned effect.
effect EffectTurned();

// Get the first member of oMemberOfFaction's faction (start to cycle through
// oMemberOfFaction's faction).
// * Returns OBJECT_INVALID if oMemberOfFaction's faction is invalid.
object GetFirstFactionMember(object oMemberOfFaction, int bPCOnly=TRUE);

// Get the next member of oMemberOfFaction's faction (continue to cycle through
// oMemberOfFaction's faction).
// * Returns OBJECT_INVALID if oMemberOfFaction's faction is invalid.
object GetNextFactionMember(object oMemberOfFaction, int bPCOnly=TRUE);

// Force the action subject to move to lDestination.
void ActionForceMoveToLocation(location lDestination, int bRun=FALSE, float fTimeout=30.0f);

// Force the action subject to move to oMoveTo.
void ActionForceMoveToObject(object oMoveTo, int bRun=FALSE, float fRange=1.0f, float fTimeout=30.0f);

// Get the experience assigned in the journal editor for szPlotID.
int GetJournalQuestExperience(string szPlotID);

// Jump to oToJumpTo (the action is added to the top of the action queue).
void JumpToObject(object oToJumpTo, int nWalkStraightLineToPoint=1);

// Set whether oMapPin is enabled.
// - oMapPin
// - nEnabled: 0=Off, 1=On
void SetMapPinEnabled(object oMapPin, int nEnabled);

// Create a Hit Point Change When Dying effect.
// - fHitPointChangePerRound: this can be positive or negative, but not zero.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if fHitPointChangePerRound is 0.
effect EffectHitPointChangeWhenDying(float fHitPointChangePerRound);

// Spawn a GUI panel for the client that controls oPC.
// - oPC
// - nGUIPanel: GUI_PANEL_*
// * Nothing happens if oPC is not a player character or if an invalid value is
//   used for nGUIPanel.
void PopUpGUIPanel(object oPC, int nGUIPanel);

// Clear all personal feelings that oSource has about oTarget.
void ClearPersonalReputation(object oTarget, object oSource=OBJECT_SELF);

// oSource will temporarily be friends towards oTarget.
// bDecays determines whether the personal reputation value decays over time
// fDurationInSeconds is the length of time that the temporary friendship lasts

// Make oSource into a temporary friend of oTarget using personal reputation.
// - oTarget
// - oSource
// - bDecays: If this is TRUE, the friendship decays over fDurationInSeconds;
//   otherwise it is indefinite.
// - fDurationInSeconds: This is only used if bDecays is TRUE, it is how long
//   the friendship lasts.
// Note: If bDecays is TRUE, the personal reputation amount decreases in size
// over fDurationInSeconds. Friendship will only be in effect as long as
// (faction reputation + total personal reputation) >= REPUTATION_TYPE_FRIEND.
void SetIsTemporaryFriend(object oTarget, object oSource=OBJECT_SELF, int bDecays=FALSE, float fDurationInSeconds=180.0f);

// Make oSource into a temporary enemy of oTarget using personal reputation.
// - oTarget
// - oSource
// - bDecays: If this is TRUE, the enmity decays over fDurationInSeconds;
//   otherwise it is indefinite.
// - fDurationInSeconds: This is only used if bDecays is TRUE, it is how long
//   the enmity lasts.
// Note: If bDecays is TRUE, the personal reputation amount decreases in size
// over fDurationInSeconds. Enmity will only be in effect as long as
// (faction reputation + total personal reputation) <= REPUTATION_TYPE_ENEMY.
void SetIsTemporaryEnemy(object oTarget, object oSource=OBJECT_SELF, int bDecays=FALSE, float fDurationInSeconds=180.0f);

// Make oSource temporarily neutral to oTarget using personal reputation.
// - oTarget
// - oSource
// - bDecays: If this is TRUE, the neutrality decays over fDurationInSeconds;
//   otherwise it is indefinite.
// - fDurationInSeconds: This is only used if bDecays is TRUE, it is how long
//   the neutrality lasts.
// Note: If bDecays is TRUE, the personal reputation amount decreases in size
// over fDurationInSeconds. Neutrality will only be in effect as long as
// (faction reputation + total personal reputation) > REPUTATION_TYPE_ENEMY and
// (faction reputation + total personal reputation) < REPUTATION_TYPE_FRIEND.
void SetIsTemporaryNeutral(object oTarget, object oSource=OBJECT_SELF, int bDecays=FALSE, float fDurationInSeconds=180.0f);

// Gives nXpAmount to oCreature.
void GiveXPToCreature(object oCreature, int nXpAmount);

// Sets oCreature's experience to nXpAmount.
void SetXP(object oCreature, int nXpAmount);

// Get oCreature's experience.
int GetXP(object oCreature);

// Convert nInteger to hex, returning the hex value as a string.
// * Return value has the format "0x????????" where each ? will be a hex digit
//   (8 digits in total).
string IntToHexString(int nInteger);

// Get the base item type (BASE_ITEM_*) of oItem.
// * Returns BASE_ITEM_INVALID if oItem is an invalid item.
int GetBaseItemType(object oItem);

// Determines whether oItem has nProperty.
// - oItem
// - nProperty: ITEM_PROPERTY_*
// * Returns FALSE if oItem is not a valid item, or if oItem does not have
//   nProperty.
int GetItemHasItemProperty(object oItem, int nProperty);

// The creature will equip the melee weapon in its possession that can do the
// most damage. If no valid melee weapon is found, it will equip the most
// damaging range weapon. This function should only ever be called in the
// EndOfCombatRound scripts, because otherwise it would have to stop the combat
// round to run simulation.
// - oVersus: You can try to get the most damaging weapon against oVersus
// - bOffHand
void ActionEquipMostDamagingMelee(object oVersus=OBJECT_INVALID, int bOffHand=FALSE);

// The creature will equip the range weapon in its possession that can do the
// most damage.
// If no valid range weapon can be found, it will equip the most damaging melee
// weapon.
// - oVersus: You can try to get the most damaging weapon against oVersus
void ActionEquipMostDamagingRanged(object oVersus=OBJECT_INVALID);

// Get the Armour Class of oItem.
// * Return 0 if the oItem is not a valid item, or if oItem has no armour value.
int GetItemACValue(object oItem);

// The creature will rest.
//If bIgnoreNoRestFlag is true, the creature will rest even if the area is flagged
//to not allow rest. The creature will also rest even if hostiles are nearby.
//The flag will not force the creature to rest if the creature is in combat, however.
void ActionRest(int bIgnoreNoRestFlag=0);

// Expose the entire map of oArea to oPlayer.
// RWT-OEI 03/28/07 - Added parameter
// nExplored - If FALSE, it will unexplore the area for the player.
void ExploreAreaForPlayer(object oArea, object oPlayer, int nExplored=TRUE);

// The creature will equip the armour in its possession that has the highest
// armour class.
void ActionEquipMostEffectiveArmor();

// * Returns TRUE if it is currently day.
int GetIsDay();

// * Returns TRUE if it is currently night.
int GetIsNight();

// * Returns TRUE if it is currently dawn.
int GetIsDawn();

// * Returns TRUE if it is currently dusk.
int GetIsDusk();

// * Returns TRUE if oCreature was spawned from an encounter.
int GetIsEncounterCreature(object oCreature=OBJECT_SELF);

// Use this in an OnPlayerDying module script to get the last player who is dying.
object GetLastPlayerDying();

// Get the starting location of the module.
location GetStartingLocation();

// Make oCreatureToChange join one of the standard factions.
// ** This will only work on an NPC **
// - nStandardFaction: STANDARD_FACTION_*
void ChangeToStandardFaction(object oCreatureToChange, int nStandardFaction);

// Play oSound.
void SoundObjectPlay(object oSound);

// Stop playing oSound.
void SoundObjectStop(object oSound);

// Set the volume of oSound.
// - oSound
// - nVolume: 0-127
void SoundObjectSetVolume(object oSound, int nVolume);

// Set the position of oSound.
void SoundObjectSetPosition(object oSound, vector vPosition);

// Immediately speak a conversation one-liner.
// - sDialogResRef
// - oTokenTarget: This must be specified if there are creature-specific tokens
//   in the string.
// RWT-OEI 03/29/07 - Added volume parameter, uses TALKVOLUME_* - Only handles
//                    TALKVOLUME_TALK, _WHISPER, _SHOUT
void SpeakOneLinerConversation(string sDialogResRef="", object oTokenTarget=OBJECT_INVALID, int nTalkVolume=TALKVOLUME_TALK);

// Get the amount of gold possessed by oTarget.
int GetGold(object oTarget=OBJECT_SELF);

// Use this in an OnRespawnButtonPressed module script to get the object id of
// the player who last pressed the respawn button.
object GetLastRespawnButtonPresser();

// * Returns TRUE if oCreature is the Dungeon Master.
// Note: This will return FALSE if oCreature is a DM Possessed creature.
// To determine if oCreature is a DM Possessed creature, use GetIsDMPossessed()
int GetIsDM(object oCreature);

// Play a voice chat.
// - nVoiceChatID: VOICE_CHAT_*
// - oTarget
void PlayVoiceChat(int nVoiceChatID, object oTarget=OBJECT_SELF);

// * Returns TRUE if the weapon equipped is capable of damaging oVersus.
int GetIsWeaponEffective(object oVersus=OBJECT_INVALID, int bOffHand=FALSE);

// Use this in a SpellCast script to determine whether the spell was considered
// harmful.
// * Returns TRUE if the last spell cast was harmful.
int GetLastSpellHarmful();

// Activate oItem.
event EventActivateItem(object oItem, location lTarget, object oTarget=OBJECT_INVALID);

// Play the background music for oArea.
void MusicBackgroundPlay(object oArea);

// Stop the background music for oArea.
void MusicBackgroundStop(object oArea);

// Set the delay for the background music for oArea.
// - oArea
// - nDelay: delay in milliseconds
void MusicBackgroundSetDelay(object oArea, int nDelay);

// Change the background day track for oArea to nTrack.
// - oArea
// - nTrack
void MusicBackgroundChangeDay(object oArea, int nTrack);

// Change the background night track for oArea to nTrack.
// - oArea
// - nTrack
void MusicBackgroundChangeNight(object oArea, int nTrack);

// Play the battle music for oArea.
void MusicBattlePlay(object oArea);

// Stop the battle music for oArea.
void MusicBattleStop(object oArea);

// Change the battle track for oArea.
// - oArea
// - nTrack
void MusicBattleChange(object oArea, int nTrack);

// Play the ambient sound for oArea.
void AmbientSoundPlay(object oArea);

// Stop the ambient sound for oArea.
void AmbientSoundStop(object oArea);

// Change the ambient day track for oArea to nTrack.
// - oArea
// - nTrack
void AmbientSoundChangeDay(object oArea, int nTrack);

// Change the ambient night track for oArea to nTrack.
// - oArea
// - nTrack
void AmbientSoundChangeNight(object oArea, int nTrack);

// Get the object that killed the caller.
object GetLastKiller();

// Use this in a spell script to get the item used to cast the spell.
object GetSpellCastItem();

// Use this in an OnItemActivated module script to get the item that was activated.
object GetItemActivated();

// Use this in an OnItemActivated module script to get the creature that
// activated the item.
object GetItemActivator();

// Use this in an OnItemActivated module script to get the location of the item's
// target.
location GetItemActivatedTargetLocation();

// Use this in an OnItemActivated module script to get the item's target.
object GetItemActivatedTarget();

// * Returns TRUE if oObject (which is a placeable or a door) is currently open.
int GetIsOpen(object oObject);

// Take nAmount of gold from oCreatureToTakeFrom.
// - nAmount
// - oCreatureToTakeFrom: If this is not a valid creature, nothing will happen.
// - bDestroy: If this is TRUE, the caller will not get the gold.  Instead, the
//   gold will be destroyed and will vanish from the game.
// - bDisplayFeedback: If set to FALSE, none of the normal chat messages will be sent.
void TakeGoldFromCreature(int nAmount, object oCreatureToTakeFrom, int bDestroy=FALSE, int bDisplayFeedback=TRUE);

// Determine whether oObject is in conversation.
int IsInConversation(object oObject);

// Create an Ability Decrease effect.
// - nAbility: ABILITY_*
// - nModifyBy: This is the amount by which to decrement the ability
effect EffectAbilityDecrease(int nAbility, int nModifyBy);

// Create an Attack Decrease effect.
// - nPenalty
// - nModifierType: ATTACK_BONUS_*
effect EffectAttackDecrease(int nPenalty, int nModifierType=ATTACK_BONUS_MISC);

// Create a Damage Decrease effect.
// - nPenalty
// - nDamageType: DAMAGE_TYPE_*
effect EffectDamageDecrease(int nPenalty, int nDamageType=DAMAGE_TYPE_MAGICAL);

// Create a Damage Immunity Decrease effect.
// - nDamageType: DAMAGE_TYPE_*
// - nPercentImmunity
effect EffectDamageImmunityDecrease(int nDamageType, int nPercentImmunity);

// Create an AC Decrease effect.
// - nValue
// - nModifyType: AC_*
// - nDamageType: DAMAGE_TYPE_*
//   * Default value for nDamageType should only ever be used in this function prototype.
effect EffectACDecrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL);

// Create a Movement Speed Decrease effect.
// - nPercentChange - range 0 through 99
// eg.
//    0 = no change in speed
//   50 = 50% slower
//   99 = almost immobile
effect EffectMovementSpeedDecrease(int nPercentChange);

// Create a Saving Throw Decrease effect.
// - nSave
// - nValue
// - nSaveType: SAVING_THROW_TYPE_*
effect EffectSavingThrowDecrease(int nSave, int nValue, int nSaveType=SAVING_THROW_TYPE_ALL);

// Create a Skill Decrease effect.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nSkill is invalid.
effect EffectSkillDecrease(int nSkill, int nValue);

// Create a Spell Resistance Decrease effect.
effect EffectSpellResistanceDecrease(int nValue);

// Determine whether oTarget is a plot object.
int GetPlotFlag(object oTarget=OBJECT_SELF);

// Set oTarget's plot object status.
void SetPlotFlag(object oTarget, int nPlotFlag);

// Create an Invisibility effect.
// - nInvisibilityType: INVISIBILITY_TYPE_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nInvisibilityType
//   is invalid.
effect EffectInvisibility(int nInvisibilityType);

// Create a Concealment effect.
// - nPercentage: 1-100 inclusive
// - nMissChanceType: MISS_CHANCE_TYPE_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nPercentage < 1 or
//   nPercentage > 100.
effect EffectConcealment(int nPercentage, int nMissType=MISS_CHANCE_TYPE_NORMAL);

// Create a Darkness effect.
effect EffectDarkness();

// Create a Dispel Magic All effect.
// aOnDispelEffect will be called ONCE if ANY effects are removed
effect EffectDispelMagicAll(int nCasterLevel, action aOnDispelEffect );

// Create an Ultravision effect.
effect EffectUltravision();

// Create a Negative Level effect.
// - nNumLevels: the number of negative levels to apply.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nNumLevels > 100.
effect EffectNegativeLevel(int nNumLevels, int bHPBonus=FALSE);

// Create a Polymorph effect.
// AFW-OEI 11/27/2006: Add a boolean to say whether this polymorph effect is a wildshape effect or not.
effect EffectPolymorph(int nPolymorphSelection, int nLocked=FALSE, int bWildshape=FALSE);

// Create a Sanctuary effect.
// - nDifficultyClass: must be a non-zero, positive number
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nDifficultyClass <= 0.
effect EffectSanctuary(int nDifficultyClass);

// Create a True Seeing effect.
effect EffectTrueSeeing();

// Create a See Invisible effect.
effect EffectSeeInvisible();

// Create a Time Stop effect.
effect EffectTimeStop();

// Create a Blindness effect.
effect EffectBlindness();

// Determine whether oSource has a friendly reaction towards oTarget, depending
// on the reputation, PVP setting and (if both oSource and oTarget are PCs),
// oSource's Like/Dislike setting for oTarget.
// Note: If you just want to know how two objects feel about each other in terms
// of faction and personal reputation, use GetIsFriend() instead.
// * Returns TRUE if oSource has a friendly reaction towards oTarget
int GetIsReactionTypeFriendly(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource has a neutral reaction towards oTarget, depending
// on the reputation, PVP setting and (if both oSource and oTarget are PCs),
// oSource's Like/Dislike setting for oTarget.
// Note: If you just want to know how two objects feel about each other in terms
// of faction and personal reputation, use GetIsNeutral() instead.
// * Returns TRUE if oSource has a neutral reaction towards oTarget
int GetIsReactionTypeNeutral(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource has a Hostile reaction towards oTarget, depending
// on the reputation, PVP setting and (if both oSource and oTarget are PCs),
// oSource's Like/Dislike setting for oTarget.
// Note: If you just want to know how two objects feel about each other in terms
// of faction and personal reputation, use GetIsEnemy() instead.
// * Returns TRUE if oSource has a hostile reaction towards oTarget
int GetIsReactionTypeHostile(object oTarget, object oSource=OBJECT_SELF);

// Create a Spell Level Absorption effect.
// - nMaxSpellLevelAbsorbed: maximum spell level that will be absorbed by the
//   effect
// - nTotalSpellLevelsAbsorbed: maximum number of spell levels that will be
//   absorbed by the effect
// - nSpellSchool: SPELL_SCHOOL_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if:
//   nMaxSpellLevelAbsorbed is not between -1 and 9 inclusive, or nSpellSchool
//   is invalid.
effect EffectSpellLevelAbsorption(int nMaxSpellLevelAbsorbed, int nTotalSpellLevelsAbsorbed=0, int nSpellSchool=SPELL_SCHOOL_GENERAL );

// Create a Dispel Magic Best effect.
// aOnDispelEffect will be called ONCE if ANY effects are removed
effect EffectDispelMagicBest(int nCasterLevel, action aOnDispelEffect );

// Try to send oTarget to a new server defined by sIPaddress.
// - oTarget
// - sIPaddress: this can be numerical "192.168.0.84" or alphanumeric
//   "www.bioware.com". It can also contain a port "192.168.0.84:5121" or
//   "www.bioware.com:5121"; if the port is not specified, it will default to
//   5121.
// - sPassword: login password for the destination server
// - sWaypointTag: if this is set, after portalling the character will be moved
//   to this waypoint if it exists
// - bSeamless: if this is set, the client wil not be prompted with the
//   information window telling them about the server, and they will not be
//   allowed to save a copy of their character if they are using a local vault
//   character.
void ActivatePortal(object oTarget, string sIPaddress="", string sPassword="", string sWaypointTag="", int bSeemless=FALSE);

// Get the number of stacked items that oItem comprises.
int GetNumStackedItems(object oItem);

// Use this on an NPC to cause all creatures within a 10-metre radius to stop
// what they are doing and sets the NPC's enemies within this range to be
// neutral towards the NPC for roughly 3 minutes. If this command is run on a PC
// or an object that is not a creature, nothing will happen.
void SurrenderToEnemies();

// Create a Miss Chance effect.
// - nPercentage: 1-100 inclusive
// - nMissChanceType: MISS_CHANCE_TYPE_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nPercentage < 1 or
//   nPercentage > 100.
effect EffectMissChance(int nPercentage, int nMissChanceType=MISS_CHANCE_TYPE_NORMAL);

// Get the number of Hitdice worth of Turn Resistance that oUndead may have.
// This will only work on undead creatures.
int GetTurnResistanceHD(object oUndead=OBJECT_SELF);

// Get the size (CREATURE_SIZE_*) of oCreature.
int GetCreatureSize(object oCreature);

// Create a Disappear/Appear effect.
// The object will "fly away" for the duration of the effect and will reappear
// at lLocation.
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
effect EffectDisappearAppear(location lLocation, int nAnimation=1);

// Create a Disappear effect to make the object "fly away" and then destroy
// itself.
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
effect EffectDisappear(int nAnimation=1);

// Create an Appear effect to make the object "fly in".
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
effect EffectAppear(int nAnimation=1);

// The action subject will unlock oTarget, which can be a door or a placeable
// object.
void ActionUnlockObject(object oTarget);

// The action subject will lock oTarget, which can be a door or a placeable
// object.
void ActionLockObject(object oTarget);

// Create a Modify Attacks effect to add attacks.
// - nAttacks: maximum is 5, even with the effect stacked
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nAttacks > 5.
effect EffectModifyAttacks(int nAttacks);

// Get the last trap detected by oTarget.
// * Return value on error: OBJECT_INVALID
object GetLastTrapDetected(object oTarget=OBJECT_SELF);

// Create a Damage Shield effect which does (nDamageAmount + nRandomAmount)
// damage to any melee attacker on a successful attack of damage type nDamageType.
// - nDamageAmount: an integer value
// - nRandomAmount: DAMAGE_BONUS_*
// - nDamageType: DAMAGE_TYPE_*
// NOTE! You *must* use the DAMAGE_BONUS_* constants! Using other values may
//       result in odd behaviour.
effect EffectDamageShield(int nDamageAmount, int nRandomAmount, int nDamageType);

// Get the trap nearest to oTarget.
// Note : "trap objects" are actually any trigger, placeable or door that is
// trapped in oTarget's area.
// - oTarget
// - nTrapDetected: if this is TRUE, the trap returned has to have been detected
//   by oTarget.
object GetNearestTrapToObject(object oTarget=OBJECT_SELF, int nTrapDetected=TRUE);

// Get the name of oCreature's deity.
// * Returns "" if oCreature is invalid (or if the deity name is blank for
//   oCreature).
string GetDeity(object oCreature);

// Get the name of oCreature's sub race.
// * Returns a constant for the creature's SUBRACE of type RACIAL_SUBTYPE
int GetSubRace(object oTarget);

// Get oTarget's base fortitude saving throw value (this will only work for
// creatures, doors, and placeables).
// * Returns 0 if oTarget is invalid.
int GetFortitudeSavingThrow(object oTarget);

// Get oTarget's base will saving throw value (this will only work for creatures,
// doors, and placeables).
// * Returns 0 if oTarget is invalid.
int GetWillSavingThrow(object oTarget);

// Get oTarget's base reflex saving throw value (this will only work for
// creatures, doors, and placeables).
// * Returns 0 if oTarget is invalid.
int GetReflexSavingThrow(object oTarget);

// Get oCreature's challenge rating.
// * Returns 0.0 if oCreature is invalid.
float GetChallengeRating(object oCreature);

// Get oCreature's age.
// * Returns 0 if oCreature is invalid.
int GetAge(object oCreature);

// Get oCreature's movement rate.
// * Returns 0 if oCreature is invalid.
int GetMovementRate(object oCreature);

// Get oCreature's animal companion creature type
// (ANIMAL_COMPANION_CREATURE_TYPE_*).
// * Returns ANIMAL_COMPANION_CREATURE_TYPE_NONE if oCreature is invalid or does
//   not currently have an animal companion.
int GetAnimalCompanionCreatureType(object oCreature);

// Get oCreature's familiar creature type (FAMILIAR_CREATURE_TYPE_*).
// * Returns FAMILIAR_CREATURE_TYPE_NONE if oCreature is invalid or does not
//   currently have a familiar.
int GetFamiliarCreatureType(object oCreature);

// Get oCreature's animal companion's name.
// * Returns "" if oCreature is invalid, does not currently
// have an animal companion or if the animal companion's name is blank.
string GetAnimalCompanionName(object oTarget);

// Get oCreature's familiar's name.
// * Returns "" if oCreature is invalid, does not currently
// have a familiar or if the familiar's name is blank.
string GetFamiliarName(object oCreature);

// The action subject will fake casting a spell at oTarget; the conjure and cast
// animations and visuals will occur, nothing else.
// - nSpell
// - oTarget
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
void ActionCastFakeSpellAtObject(int nSpell, object oTarget, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT);

// The action subject will fake casting a spell at lLocation; the conjure and
// cast animations and visuals will occur, nothing else.
// - nSpell
// - lTarget
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
void ActionCastFakeSpellAtLocation(int nSpell, location lTarget, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT);

// Removes oAssociate from the service of oMaster, returning them to their
// original faction.
void RemoveSummonedAssociate(object oMaster, object oAssociate=OBJECT_SELF);

// Set the camera mode for oPlayer.
// - oPlayer
// - nCameraMode: CAMERA_MODE_*
// * If oPlayer is not player-controlled or nCameraMode is invalid, nothing
//   happens.
void SetCameraMode(object oPlayer, int nCameraMode);

// * Returns TRUE if oCreature is resting.
int GetIsResting(object oCreature=OBJECT_SELF);

// Get the last PC that has rested in the module.
object GetLastPCRested();

// Set the weather for oTarget.
// - oTarget: if this is GetModule(), all outdoor areas will be modified by the
//   weather constant. If it is an area, oTarget will play the weather only if
//   it is an outdoor area.
// - nWeather: WEATHER_TYPE*
//   -> WEATHER_TYPE_RAIN, WEATHER_TYPE_SNOW, WEATHER_TYPE_LIGHTNING are the weather
//   -> patterns you can set.
// - nPower: WEATHER_POWER_*
//   -> WEATHER_POWER_USE_AREA_SETTINGS will set the area back to use the area's weather pattern.
//   -> WEATHER_POWER_OFF, WEATHER_POWER_WEAK, WEATHER_POWER_LIGHT, WEATHER_POWER_MEDIUM,
//   -> WEATHER_POWER_HEAVY, WEATHER_POWER_STORMY are the different weather pattern settings.
// * Note that this function has changed in NWN2.
void SetWeather(object oTarget, int nWeatherType, int nPower = WEATHER_POWER_MEDIUM);

// Determine the type (REST_EVENTTYPE_REST_*) of the last rest event (as
// returned from the OnPCRested module event).
int GetLastRestEventType();

// Shut down the currently loaded module and start a new one (moving all
// currently-connected players to the starting point.
void StartNewModule(string sModuleName, string sWaypoint = "");

// Create a Swarm effect.
// - nLooping: If this is TRUE, for the duration of the effect when one creature
//   created by this effect dies, the next one in the list will be created.  If
//   the last creature in the list dies, we loop back to the beginning and
//   sCreatureTemplate1 will be created, and so on...
// - sCreatureTemplate1
// - sCreatureTemplate2
// - sCreatureTemplate3
// - sCreatureTemplate4
effect EffectSwarm(int nLooping, string sCreatureTemplate1, string sCreatureTemplate2="", string sCreatureTemplate3="", string sCreatureTemplate4="");

// * Returns TRUE if oItem is a ranged weapon.
int GetWeaponRanged(object oItem);

// Only if we are in a single player game, AutoSave the game.
void DoSinglePlayerAutoSave();

// Get the game difficulty (GAME_DIFFICULTY_*).
int GetGameDifficulty();

// Set the main light color on the tile at lTileLocation.
// - lTileLocation: the vector part of this is the tile grid (x,y) coordinate of
//   the tile.
// - nMainLight1Color: TILE_MAIN_LIGHT_COLOR_*
// - nMainLight2Color: TILE_MAIN_LIGHT_COLOR_*
void SetTileMainLightColor(location lTileLocation, int nMainLight1Color, int nMainLight2Color);

// Set the source light color on the tile at lTileLocation.
// - lTileLocation: the vector part of this is the tile grid (x,y) coordinate of
//   the tile.
// - nSourceLight1Color: TILE_SOURCE_LIGHT_COLOR_*
// - nSourceLight2Color: TILE_SOURCE_LIGHT_COLOR_*
void SetTileSourceLightColor(location lTileLocation, int nSourceLight1Color, int nSourceLight2Color);

// All clients in oArea will recompute the static lighting.
// This can be used to update the lighting after changing any tile lights or if
// placeables with lights have been added/deleted.
void RecomputeStaticLighting(object oArea);

// Get the color (TILE_MAIN_LIGHT_COLOR_*) for the main light 1 of the tile at
// lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the tile.
int GetTileMainLight1Color(location lTile);

// Get the color (TILE_MAIN_LIGHT_COLOR_*) for the main light 2 of the tile at
// lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the
//   tile.
int GetTileMainLight2Color(location lTile);

// Get the color (TILE_SOURCE_LIGHT_COLOR_*) for the source light 1 of the tile
// at lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the
//   tile.
int GetTileSourceLight1Color(location lTile);

// Get the color (TILE_SOURCE_LIGHT_COLOR_*) for the source light 2 of the tile
// at lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the
//   tile.
int GetTileSourceLight2Color(location lTile);

// Make the corresponding panel button on the player's client start or stop
// flashing.
// - oPlayer
// - nButton: PANEL_BUTTON_*
// - nEnableFlash: if this is TRUE nButton will start flashing.  It if is FALSE,
//   nButton will stop flashing.
void SetPanelButtonFlash(object oPlayer, int nButton, int nEnableFlash);

// Get the current action (ACTION_*) that oObject is executing.
int GetCurrentAction(object oObject=OBJECT_SELF);

// Set how nStandardFaction feels about oCreature.
// - nStandardFaction: STANDARD_FACTION_*
// - nNewReputation: 0-100 (inclusive)
// - oCreature
void SetStandardFactionReputation(int nStandardFaction, int nNewReputation, object oCreature=OBJECT_SELF);

// Find out how nStandardFaction feels about oCreature.
// - nStandardFaction: STANDARD_FACTION_*
// - oCreature
int GetStandardFactionReputation(int nStandardFaction, object oCreature=OBJECT_SELF);

// Display floaty text above the specified creature.
// The text will also appear in the chat buffer of each player that receives the
// floaty text.
// - nStrRefToDisplay: String ref (therefore text is translated)
// - oCreatureToFloatAbove
// - bBroadcastToFaction: If this is TRUE then only creatures in the same faction
//   as oCreatureToFloatAbove
//   will see the floaty text, and only if they are within range (30 metres).
void FloatingTextStrRefOnCreature(int nStrRefToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, float fDuration=5.0,
                                  int nStartColor=4294967295, int nEndColor=4294967295, float fSpeed=0.0, vector vDirection=[0.0,0.0,0.0]);

// Display floaty text above the specified creature.
// The text will also appear in the chat buffer of each player that receives the
// floaty text.
// - sStringToDisplay: String
// - oCreatureToFloatAbove
// - bBroadcastToFaction: If this is TRUE then only creatures in the same faction
//   as oCreatureToFloatAbove
//   will see the floaty text, and only if they are within range (30 metres).
void FloatingTextStringOnCreature(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, float fDuration=5.0,
                                  int nStartColor=4294967295, int nEndColor=4294967295, float fSpeed=0.0, vector vDirection=[0.0,0.0,0.0]);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is disarmable.
int GetTrapDisarmable(object oTrapObject);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is detectable.
int GetTrapDetectable(object oTrapObject);

// - oTrapObject: a placeable, door or trigger
// - oCreature
// * Returns TRUE if oCreature has detected oTrapObject
int GetTrapDetectedBy(object oTrapObject, object oCreature);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject has been flagged as visible to all creatures.
int GetTrapFlagged(object oTrapObject);

// Get the trap base type (TRAP_BASE_TYPE_*) of oTrapObject.
// - oTrapObject: a placeable, door or trigger
int GetTrapBaseType(object oTrapObject);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is one-shot (i.e. it does not reset itself
//   after firing.
int GetTrapOneShot(object oTrapObject);

// Get the creator of oTrapObject, the creature that set the trap.
// - oTrapObject: a placeable, door or trigger
// * Returns OBJECT_INVALID if oTrapObject was created in the toolset.
object GetTrapCreator(object oTrapObject);

// Get the tag of the key that will disarm oTrapObject.
// - oTrapObject: a placeable, door or trigger
string GetTrapKeyTag(object oTrapObject);

// Get the DC for disarming oTrapObject.
// - oTrapObject: a placeable, door or trigger
int GetTrapDisarmDC(object oTrapObject);

// Get the DC for detecting oTrapObject.
// - oTrapObject: a placeable, door or trigger
int GetTrapDetectDC(object oTrapObject);

// * Returns TRUE if a specific key is required to open the lock on oObject.
int GetLockKeyRequired(object oObject);

// Get the tag of the key that will open the lock on oObject.
string GetLockKeyTag(object oObject);

// * Returns TRUE if the lock on oObject is lockable.
int GetLockLockable(object oObject);

// Get the DC for unlocking oObject.
int GetLockUnlockDC(object oObject);

// Get the DC for locking oObject.
int GetLockLockDC(object oObject);

// Get the last PC that levelled up.
object GetPCLevellingUp();

// - nFeat: FEAT_*
// - oObject
// * Returns TRUE if oObject has effects on it originating from nFeat.
int GetHasFeatEffect(int nFeat, object oObject=OBJECT_SELF);

// Set the status of the illumination for oPlaceable.
// - oPlaceable
// - bIlluminate: if this is TRUE, oPlaceable's illumination will be turned on.
//   If this is FALSE, oPlaceable's illumination will be turned off.
// Note: You must call RecomputeStaticLighting() after calling this function in
// order for the changes to occur visually for the players.
// SetPlaceableIllumination() buffers the illumination changes, which are then
// sent out to the players once RecomputeStaticLighting() is called.  As such,
// it is best to call SetPlaceableIllumination() for all the placeables you wish
// to set the illumination on, and then call RecomputeStaticLighting() once after
// all the placeable illumination has been set.
// * If oPlaceable is not a placeable object, or oPlaceable is a placeable that
//   doesn't have a light, nothing will happen.
void SetPlaceableIllumination(object oPlaceable=OBJECT_SELF, int bIlluminate=TRUE);

// * Returns TRUE if the illumination for oPlaceable is on
int GetPlaceableIllumination(object oPlaceable=OBJECT_SELF);

// - oPlaceable
// - nPlaceableAction: PLACEABLE_ACTION_*
// * Returns TRUE if nPlacebleAction is valid for oPlaceable.
int GetIsPlaceableObjectActionPossible(object oPlaceable, int nPlaceableAction);

// The caller performs nPlaceableAction on oPlaceable.
// - oPlaceable
// - nPlaceableAction: PLACEABLE_ACTION_*
void DoPlaceableObjectAction(object oPlaceable, int nPlaceableAction);

// Get the first PC in the player list.
// This resets the position in the player list for GetNextPC().
//RWT-OEI 01/16/06
//bOwnedCharacter, if true, returns the first player's owned PC
//object. If false, returns the first player's currently controlled
//object.
object GetFirstPC(int bOwnedCharacter=TRUE);

// Get the next PC in the player list.
// This picks up where the last GetFirstPC() or GetNextPC() left off.
//RWT-OEI 01/16/06
//bOwnedCharacter, if true, returns the first player's owned PC
//object. If false, returns the first player's currently controlled
//object.
object GetNextPC(int bOwnedCharacter=TRUE);

// Set oDetector to have detected oTrap.
int SetTrapDetectedBy(object oTrap, object oDetector);

// Note: Only placeables, doors and triggers can be trapped.
// * Returns TRUE if oObject is trapped.
int GetIsTrapped(object oObject);

// Create a Turn Resistance Decrease effect.
// - nHitDice: a positive number representing the number of hit dice for the
///  decrease
effect EffectTurnResistanceDecrease(int nHitDice);

// Create a Turn Resistance Increase effect.
// - nHitDice: a positive number representing the number of hit dice for the
//   increase
effect EffectTurnResistanceIncrease(int nHitDice);

// Spawn in the Death GUI.
// The default (as defined by BioWare) can be spawned in by PopUpGUIPanel, but
// if you want to turn off the "Respawn" or "Wait for Help" buttons, this is the
// function to use.
// - oPC
// - bRespawnButtonEnabled: if this is TRUE, the "Respawn" button will be enabled
//   on the Death GUI.
// - bWaitForHelpButtonEnabled: if this is TRUE, the "Wait For Help" button will
//   be enabled on the Death GUI.
// - nHelpStringReference
// - sHelpString
void PopUpDeathGUIPanel(object oPC, int bRespawnButtonEnabled=TRUE, int bWaitForHelpButtonEnabled=TRUE, int nHelpStringReference=0, string sHelpString="");

// Disable oTrap.
// - oTrap: a placeable, door or trigger.
// This disarms a trap, which results in the trap being deleted completely (If it is a trigger)
// or being cleared from the door/chest (if oTrap is a door or chest)
// Will execute the 'OnDisarm' script for the trap.
void SetTrapDisabled(object oTrap);

// Get the last object that was sent as a GetLastAttacker(), GetLastDamager(),
// GetLastSpellCaster() (for a hostile spell), or GetLastDisturbed() (when a
// creature is pickpocketed).
// Note: Return values may only ever be:
// 1) A Creature
// 2) Plot Characters will never have this value set
// 3) Area of Effect Objects will return the AOE creator if they are registered
//    as this value, otherwise they will return INVALID_OBJECT_ID
// 4) Traps will not return the creature that set the trap.
// 5) This value will never be overwritten by another non-creature object.
// 6) This value will never be a dead/destroyed creature
object GetLastHostileActor(object oVictim=OBJECT_SELF);

// Force all the characters of the players who are currently in the game to
// be exported to their respective directories i.e. LocalVault/ServerVault/ etc.
void ExportAllCharacters();

// Get the Day Track for oArea.
int MusicBackgroundGetDayTrack(object oArea);

// Get the Night Track for oArea.
int MusicBackgroundGetNightTrack(object oArea);

// Write sLogEntry as a timestamped entry into the log file
void WriteTimestampedLogEntry(string sLogEntry);

// Get the module's name in the language of the server that's running it.
// * If there is no entry for the language of the server, it will return an
//   empty string
string GetModuleName();

// Get the leader of the faction of which oMemberOfFaction is a member.
// * Returns OBJECT_INVALID if oMemberOfFaction is not a valid creature.
object GetFactionLeader(object oMemberOfFaction);

// Sends szMessage to all the Dungeon Masters currently on the server.
void SendMessageToAllDMs(string szMessage);

// End the currently running game, play sEndMovie then return all players to the
// game's main menu.
void EndGame(string sEndMovie);

// Remove oPlayer from the server.
void BootPC(object oPlayer);

// Counterspell oCounterSpellTarget.
void ActionCounterSpell(object oCounterSpellTarget);

// Set the ambient day volume for oArea to nVolume.
// - oArea
// - nVolume: 0 - 100
void AmbientSoundSetDayVolume(object oArea, int nVolume);

// Set the ambient night volume for oArea to nVolume.
// - oArea
// - nVolume: 0 - 100
void AmbientSoundSetNightVolume(object oArea, int nVolume);

// Get the Battle Track for oArea.
int MusicBackgroundGetBattleTrack(object oArea);

// Determine whether oObject has an inventory.
// * Returns TRUE for creatures and stores, and checks to see if an item or placeable object is a container.
// * Returns FALSE for all other object types.
int GetHasInventory(object oObject);

// Get the duration (in seconds) of the sound attached to nStrRef
// * Returns 0.0f if no duration is stored or if no sound is attached
float GetStrRefSoundDuration(int nStrRef);

// Add oPC to oPartyLeader's party.  This will only work on two PCs.
// - oPC: player to add to a party
// - oPartyLeader: player already in the party
void AddToParty(object oPC, object oPartyLeader);

// Remove oPC from their current party. This will only work on a PC.
// - oPC: removes this player from whatever party they're currently in.
void RemoveFromParty(object oPC);

// Returns the stealth mode of the specified creature.
// - oCreature
// * Returns a constant STEALTH_MODE_*
int GetStealthMode(object oCreature);

// Returns the detection mode of the specified creature.
// - oCreature
// * Returns a constant DETECT_MODE_*
int GetDetectMode(object oCreature);

// Returns the defensive casting mode of the specified creature.
// - oCreature
// * Returns a constant DEFENSIVE_CASTING_MODE_*
int GetDefensiveCastingMode(object oCreature);

// returns the appearance type of the specified creature.
// * returns a constant APPEARANCE_TYPE_* for valid creatures
// * returns APPEARANCE_TYPE_INVALID for non creatures/invalid creatures
int GetAppearanceType(object oCreature);

// SpawnScriptDebugger() will cause the script debugger to be executed
// after this command is executed!  If the script file isn't
// compiled for debugging, this command will do nothing.
void SpawnScriptDebugger();

// in an onItemAcquired script, returns the size of the stack of the item
// that was just acquired.
// * returns the stack size of the item acquired
int GetModuleItemAcquiredStackSize();

// Decrement the remaining uses per day for this creature by one.
// - oCreature: creature to modify
// - nFeat: constant FEAT_*
void DecrementRemainingFeatUses(object oCreature, int nFeat);

// Decrement the remaining uses per day for this creature by one.
// - oCreature: creature to modify
// - nSpell: constant SPELL_*
void DecrementRemainingSpellUses(object oCreature, int nSpell);

// returns the template used to create this object (if appropriate)
// * returns an empty string when no template found
string GetResRef(object oObject);

// returns an effect that will petrify the target
// * currently applies EffectParalyze and the stoneskin visual effect.
effect EffectPetrify();

// duplicates the item and returns a new object
// oItem - item to copy
// oTargetInventory - create item in this object's inventory. If this parameter
//                    is not valid, the item will be created in oItem's location
// bCopyVars - copy the local variables from the old item to the new one
// * returns the new item
// * returns OBJECT_INVALID for non-items.
// * can only copy empty item containers. will return OBJECT_INVALID if oItem contains
//   other items.
// * if it is possible to merge this item with any others in the target location,
//   then it will do so and return the merged object.
object CopyItem(object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars=FALSE);

// returns an effect that is guaranteed to paralyze a creature.
// this effect is identical to EffectParalyze except that it cannot be resisted.
effect EffectCutsceneParalyze();

// returns TRUE if the item CAN be dropped
int GetDroppableFlag(object oItem);

// returns TRUE if the placeable object is usable
int GetUseableFlag(object oObject=OBJECT_SELF);

// returns TRUE if the item is stolen
int GetStolenFlag(object oStolen);

// This stores a float out to the specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignFloat(string sCampaignName, string sVarName, float flFloat, object oPlayer=OBJECT_INVALID);

// This stores an int out to the specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignInt(string sCampaignName, string sVarName, int nInt, object oPlayer=OBJECT_INVALID);

// This stores a vector out to the specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignVector(string sCampaignName, string sVarName, vector vVector, object oPlayer=OBJECT_INVALID);

// This stores a location out to the specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignLocation(string sCampaignName, string sVarName, location locLocation, object oPlayer=OBJECT_INVALID);

// This stores a string out to the specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignString(string sCampaignName, string sVarName, string sString, object oPlayer=OBJECT_INVALID);

// This will delete the entire campaign database if it exists.
void DestroyCampaignDatabase(string sCampaignName);

// This will read a float from the  specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
float GetCampaignFloat(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read an int from the  specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
int GetCampaignInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read a vector from the  specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
vector GetCampaignVector(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read a location from the  specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
location GetCampaignLocation(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read a string from the  specified campaign database
// The database name IS case sensitive and it must be the same for both set and get functions.
// The var name must be unique acrossed the entire database, regardless of the varible type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
string GetCampaignString(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Duplicates the object specified by oSource.
// ONLY creatures and items can be specified.
// If an owner is specified and the object is an item, it will be put into their inventory
// If the object is a creature, they will be created at the location.
// If a new tag is specified, it will be assigned to the new object.
object CopyObject(object oSource, location locLocation, object oOwner = OBJECT_INVALID, string sNewTag = "");

// This will remove ANY campaign variable. Regardless of type.
// Note that by normal database standards, deleting does not actually removed the entry from
// the database, but flags it as deleted. Do not expect the database files to shrink in size
// from this command. If you want to 'pack' the database, you will have to do it externally
// from the game.
void DeleteCampaignVariable(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Stores an object with the given id.
// NOTE: this command can only be used for storing Creatures and Items.
// Returns 0 if it failled, 1 if it worked.
int StoreCampaignObject(string sCampaignName, string sVarName, object oObject, object oPlayer=OBJECT_INVALID);

// Use RetrieveCampaign with the given id to restore it.
// If you specify an owner, the object will try to be created in their repository
// If the owner can't handle the item (or if it's a creature) it will be created on the ground.
object RetrieveCampaignObject(string sCampaignName, string sVarName, location locLocation, object oOwner = OBJECT_INVALID, object oPlayer=OBJECT_INVALID);

// Returns an effect that is guaranteed to dominate a creature
// Like EffectDominated but cannot be resisted
effect EffectCutsceneDominated();

// Returns stack size of an item
// - oItem: item to query
int GetItemStackSize(object oItem);

// Sets stack size of an item.
// - oItem: item to change
// - nSize: new size of stack.  Will be restricted to be between 1 and the
//   maximum stack size for the item type.  If a value less than 1 is passed it
//   will set the stack to 1.  If a value greater than the max is passed
//   then it will set the stack to the maximum size
// - bDisplayFeedback: Set to false to disable feedback being sent to the client. RWT-OEI 10/13/08
void SetItemStackSize(object oItem, int nSize, int bDisplayFeedback=TRUE);

// Returns charges left on an item
// - oItem: item to query
int GetItemCharges(object oItem);

// Sets charges left on an item.
// - oItem: item to change
// - nCharges: number of charges.  If value below 0 is passed, # charges will
//   be set to 0.  If value greater than maximum is passed, # charges will
//   be set to maximum.  If the # charges drops to 0 the item
//   will be destroyed.
void SetItemCharges(object oItem, int nCharges);

// ***********************  START OF ITEM PROPERTY FUNCTIONS  **********************

// adds an item property to the specified item
// Only temporary and permanent duration types are allowed.
void AddItemProperty(int nDurationType, itemproperty ipProperty, object oItem, float fDuration=0.0f);

// removes an item property from the specified item
void RemoveItemProperty(object oItem, itemproperty ipProperty);

// if the item property is valid this will return true
int GetIsItemPropertyValid(itemproperty ipProperty);

// Gets the first item property on an item
itemproperty GetFirstItemProperty(object oItem);

// Will keep retrieving the next and the next item property on an Item,
// will return an invalid item property when the list is empty.
itemproperty GetNextItemProperty(object oItem);

// will return the item property type (ie. holy avenger)
int GetItemPropertyType(itemproperty ip);

// will return the duration type of the item property
int GetItemPropertyDurationType(itemproperty ip);

// Returns Item property ability bonus.  You need to specify an
// ability constant(IP_CONST_ABILITY_*) and the bonus.  The bonus should
// be a positive integer between 1 and 12.
itemproperty ItemPropertyAbilityBonus(int nAbility, int nBonus);

// Returns Item property AC bonus.  You need to specify the bonus.
// The bonus should be a positive integer between 1 and 20. The modifier
// type depends on the item it is being applied to.
itemproperty ItemPropertyACBonus(int nBonus);

// Returns Item property AC bonus vs. alignment group.  An example of
// an alignment group is Chaotic, or Good.  You need to specify the
// alignment group constant(IP_CONST_ALIGNMENTGROUP_*) and the AC bonus.
// The AC bonus should be an integer between 1 and 20.  The modifier
// type depends on the item it is being applied to.
itemproperty ItemPropertyACBonusVsAlign(int nAlignGroup, int nACBonus);

// Returns Item property AC bonus vs. Damage type (ie. piercing).  You
// need to specify the damage type constant(IP_CONST_DAMAGETYPE_*) and the
// AC bonus.  The AC bonus should be an integer between 1 and 20.  The
// modifier type depends on the item it is being applied to.
// NOTE: Only the first 3 damage types may be used here, the 3 basic
//       physical types.
itemproperty ItemPropertyACBonusVsDmgType(int nDamageType, int nACBonus);

// Returns Item property AC bonus vs. Racial group.  You need to specify
// the racial group constant(IP_CONST_RACIALTYPE_*) and the AC bonus.  The AC
// bonus should be an integer between 1 and 20.  The modifier type depends
// on the item it is being applied to.
itemproperty ItemPropertyACBonusVsRace(int nRace, int nACBonus);

// Returns Item property AC bonus vs. Specific alignment.  You need to
// specify the specific alignment constant(IP_CONST_ALIGNMENT_*) and the AC
// bonus.  The AC bonus should be an integer between 1 and 20.  The
// modifier type depends on the item it is being applied to.
itemproperty ItemPropertyACBonusVsSAlign(int nAlign, int nACBonus);

// Returns Item property Enhancement bonus.  You need to specify the
// enhancement bonus.  The Enhancement bonus should be an integer between
// 1 and 20.
itemproperty ItemPropertyEnhancementBonus(int nEnhancementBonus);

// Returns Item property Enhancement bonus vs. an Alignment group.  You
// need to specify the alignment group constant(IP_CONST_ALIGNMENTGROUP_*)
// and the enhancement bonus.  The Enhancement bonus should be an integer
// between 1 and 20.
itemproperty ItemPropertyEnhancementBonusVsAlign(int nAlignGroup, int nBonus);

// Returns Item property Enhancement bonus vs. Racial group.  You need
// to specify the racial group constant(IP_CONST_RACIALTYPE_*) and the
// enhancement bonus.  The enhancement bonus should be an integer between
// 1 and 20.
itemproperty ItemPropertyEnhancementBonusVsRace(int nRace, int nBonus);

// Returns Item property Enhancement bonus vs. a specific alignment.  You
// need to specify the alignment constant(IP_CONST_ALIGNMENT_*) and the
// enhancement bonus.  The enhancement bonus should be an integer between
// 1 and 20.
itemproperty ItemPropertyEnhancementBonusVsSAlign(int nAlign, int nBonus);

// Returns Item property Enhancment penalty.  You need to specify the
// enhancement penalty.  The enhancement penalty should be a POSITIVE
// integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyEnhancementPenalty(int nPenalty);

// Returns Item property weight reduction.  You need to specify the weight
// reduction constant(IP_CONST_REDUCEDWEIGHT_*).
itemproperty ItemPropertyWeightReduction(int nReduction);

// Returns Item property Bonus Feat.  You need to specify the the feat
// constant(IP_CONST_FEAT_*).
itemproperty ItemPropertyBonusFeat(int nFeat);

// Returns Item property Bonus level spell (Bonus spell of level).  You must
// specify the class constant(IP_CONST_CLASS_*) of the bonus spell(MUST BE a
// spell casting class) and the level of the bonus spell.  The level of the
// bonus spell should be an integer between 0 and 9.
itemproperty ItemPropertyBonusLevelSpell(int nClass, int nSpellLevel);

// Returns Item property Cast spell.  You must specify the spell constant
// (IP_CONST_CASTSPELL_*) and the number of uses constant(IP_CONST_CASTSPELL_NUMUSES_*).
// NOTE: The number after the name of the spell in the constant is the level
//       at which the spell will be cast.  Sometimes there are multiple copies
//       of the same spell but they each are cast at a different level.  The higher
//       the level, the more cost will be added to the item.
// NOTE: The list of spells that can be applied to an item will depend on the
//       item type.  For instance there are spells that can be applied to a wand
//       that cannot be applied to a potion.  Below is a list of the types and the
//       spells that are allowed to be placed on them.  If you try to put a cast
//       spell effect on an item that is not allowed to have that effect it will
//       not work.
// NOTE: Even if spells have multiple versions of different levels they are only
//       listed below once.
//
// WANDS:
//          Acid_Splash
//          Activate_Item
//          Aid
//          Amplify
//          Animate_Dead
//          AuraOfGlory
//          BalagarnsIronHorn
//          Bane
//          Banishment
//          Barkskin
//          Bears_Endurance
//          Bestow_Curse
//          Bigbys_Clenched_Fist
//          Bigbys_Crushing_Hand
//          Bigbys_Forceful_Hand
//          Bigbys_Grasping_Hand
//          Bigbys_Interposing_Hand
//          Bless
//          Bless_Weapon
//          Blindness/Deafness
//          Blood_Frenzy
//          Bombardment
//          Bulls_Strength
//          Burning_Hands
//          Call_Lightning
//          Camoflage
//          Cats_Grace
//          Cause_Fear
//          Charm_Monster
//          Charm_Person
//          Charm_Person_or_Animal
//          Clairaudience/Clairvoyance
//          Clarity
//          Color_Spray
//          Confusion
//          Continual_Flame
//          Cure_Critical_Wounds
//          Cure_Light_Wounds
//          Cure_Minor_Wounds
//          Cure_Moderate_Wounds
//          Cure_Serious_Wounds
//          Darkness
//          Darkvision
//          Daze
//          Death_Ward
//          Dirge
//          Dismissal
//          Dispel_Magic
//          Displacement
//          Divine_Favor
//          Divine_Might
//          Divine_Power
//          Divine_Shield
//          Dominate_Animal
//          Dominate_Person
//          Doom
//          Dragon_Breath_Acid
//          Dragon_Breath_Cold
//          Dragon_Breath_Fear
//          Dragon_Breath_Fire
//          Dragon_Breath_Gas
//          Dragon_Breath_Lightning
//          Dragon_Breath_Paralyze
//          Dragon_Breath_Sleep
//          Dragon_Breath_Slow
//          Dragon_Breath_Weaken
//          Drown
//          Eagle_Spledor
//          Earthquake
//          Electric_Jolt
//          Elemental_Shield
//          Endure_Elements
//          Enervation
//          Entangle
//          Entropic_Shield
//          Etherealness
//          Expeditious_Retreat
//          Fear
//          Find_Traps
//          Fireball
//          Firebrand
//          Flame_Arrow
//          Flame_Lash
//          Flame_Strike
//          Flare
//          Foxs_Cunning
//          Freedom_of_Movement
//          Ghostly_Visage
//          Ghoul_Touch
//          Grease
//          Greater_Invisibility
//          Greater_Magic_Fang
//          Greater_Magic_Weapon
//          Grenade_Acid
//          Grenade_Caltrops
//          Grenade_Chicken
//          Grenade_Choking
//          Grenade_Fire
//          Grenade_Holy
//          Grenade_Tangle
//          Grenade_Thunderstone
//          Gust_of_wind
//          Hammer_of_the_Gods
//          Haste
//          Hold_Animal
//          Hold_Monster
//          Hold_Person
    //          Ice_Storm   // REMOVED
//          Identify
//          Inferno
//          Inflict_Critical_Wounds
//          Inflict_Light_Wounds
//          Inflict_Minor_Wounds
//          Inflict_Moderate_Wounds
//          Inflict_Serious_Wounds
//          Invisibility
//          Invisibility_Purge
//          Invisibility_Sphere
//          Isaacs_Greater_Missile_Storm
//          Isaacs_Lesser_Missile_Storm
//          Knock
//          Lesser_Dispel
//          Lesser_Restoration
//          Lesser_Spell_Breach
//          Light
//          Lightning_Bolt
//          Mage_Armor
//          Magic_Circle_against_Alignment
//          Magic_Fang
//          Magic_Missile
//          Manipulate_Portal_Stone
//          Mass_Camoflage
//          Melfs_Acid_Arrow
//          Meteor_Swarm
//          Mind_Blank
//          Mind_Fog
    //          Negative_Energy_Burst   // REMOVED
//          Negative_Energy_Protection
    //          Negative_Energy_Ray // REMOVED
//          Neutralize_Poison
    //          One_With_The_Land   // REMOVED
//          Owls_Insight
//          Owls_Wisdom
//          Phantasmal_Killer
//          Planar_Ally
//          Poison
//          Polymorph_Self
//          Prayer
//          Protection_from_Alignment
//          Protection_From_Energy
//          Quillfire
//          Ray_of_Enfeeblement
//          Ray_of_Frost
//          Remove_Blindness/Deafness
//          Remove_Curse
//          Remove_Disease
//          Remove_Fear
//          Remove_Paralysis
//          Resist_Energy
//          Resistance
//          Restoration
//          Sanctuary
//          Searing_Light
//          See_Invisibility
//          Shadow_Conjuration
//          Shield
//          Shield_of_Faith
//          Silence
//          Sleep
//          Slow
//          Sound_Burst
//          Spike_Growth
//          Stinking_Cloud
//          Stoneskin
//          Summon_Creature_I
//          Summon_Creature_I
//          Summon_Creature_II
//          Summon_Creature_III
//          Summon_Creature_IV
//          Sunburst
//          Tashas_Hideous_Laughter
//          True_Strike
//          Undeaths_Eternal_Foe
//          Unique_Power
//          Unique_Power_Self_Only
//          Vampiric_Touch
//          Virtue
//          Wall_of_Fire
//          Web
    //          Wounding_Whispers   // REMOVED
//
// POTIONS:
//          Activate_Item
//          Aid
//          Amplify
//          AuraOfGlory
//          Bane
//          Barkskin
//          Barkskin
//          Barkskin
//          Bless
//          Bless_Weapon
//          Bless_Weapon
//          Blood_Frenzy
//          Bulls_Strength
//          Bulls_Strength
//          Bulls_Strength
//          Camoflage
//          Cats_Grace
//          Cats_Grace
//          Cats_Grace
//          Clairaudience/Clairvoyance
//          Clairaudience/Clairvoyance
//          Clairaudience/Clairvoyance
//          Clarity
//          Continual_Flame
//          Cure_Critical_Wounds
//          Cure_Critical_Wounds
//          Cure_Critical_Wounds
//          Cure_Light_Wounds
//          Cure_Light_Wounds
//          Cure_Minor_Wounds
//          Cure_Moderate_Wounds
//          Cure_Moderate_Wounds
//          Cure_Moderate_Wounds
//          Cure_Serious_Wounds
//          Cure_Serious_Wounds
//          Cure_Serious_Wounds
//          Darkness
//          Darkvision
//          Darkvision
//          Death_Ward
//          Dispel_Magic
//          Dispel_Magic
//          Displacement
//          Divine_Favor
//          Divine_Might
//          Divine_Power
//          Divine_Shield
//          Dragon_Breath_Acid
//          Dragon_Breath_Cold
//          Dragon_Breath_Fear
//          Dragon_Breath_Fire
//          Dragon_Breath_Gas
//          Dragon_Breath_Lightning
//          Dragon_Breath_Paralyze
//          Dragon_Breath_Sleep
//          Dragon_Breath_Slow
//          Dragon_Breath_Weaken
//          Eagle_Spledor
//          Eagle_Spledor
//          Eagle_Spledor
//          Elemental_Shield
//          Elemental_Shield
//          Endurance
//          Endurance
//          Endurance
//          Endure_Elements
//          Entropic_Shield
//          Ethereal_Visage
//          Ethereal_Visage
//          Etherealness
//          Expeditious_Retreat
//          Find_Traps
//          Foxs_Cunning
//          Foxs_Cunning
//          Foxs_Cunning
//          Freedom_of_Movement
//          Ghostly_Visage
//          Ghostly_Visage
//          Ghostly_Visage
//          Globe_of_Invulnerability
//          Greater_Bulls_Strength
//          Greater_Cats_Grace
//          Greater_Dispelling
//          Greater_Dispelling
//          Greater_Eagles_Splendor
//          Greater_Endurance
//          Greater_Foxs_Cunning
//          Greater_Magic_Weapon
//          Greater_Owls_Wisdom
//          Greater_Restoration
//          Greater_Spell_Mantle
//          Greater_Stoneskin
//          Grenade_Acid
//          Grenade_Caltrops
//          Grenade_Chicken
//          Grenade_Choking
//          Grenade_Fire
//          Grenade_Holy
//          Grenade_Tangle
//          Grenade_Thunderstone
//          Haste
//          Haste
//          Heal
//          Hold_Animal
//          Hold_Monster
//          Hold_Person
//          Identify
//          Invisibility
//          Lesser_Dispel
//          Lesser_Dispel
//          Lesser_Mind_Blank
//          Lesser_Restoration
//          Lesser_Spell_Mantle
//          Light
//          Light
//          Mage_Armor
//          Manipulate_Portal_Stone
//          Mass_Camoflage
//          Mind_Blank
//          Lesser_Globe_of_Invulnerability
//          Lesser_Globe_of_Invulnerability
//          Mordenkainens_Disjunction
//          Negative_Energy_Protection
//          Negative_Energy_Protection
//          Negative_Energy_Protection
//          Neutralize_Poison
//          One_With_The_Land
//          Owls_Insight
//          Owls_Wisdom
//          Owls_Wisdom
//          Owls_Wisdom
//          Polymorph_Self
//          Prayer
//          Premonition
//          Protection_From_Energy
//          Protection_From_Energy
//          Protection_from_Spells
//          Protection_from_Spells
//          Raise_Dead
//          Remove_Blindness/Deafness
//          Remove_Curse
//          Remove_Disease
//          Remove_Fear
//          Remove_Paralysis
//          Resist_Energy
//          Resist_Energy
//          Resistance
//          Resistance
//          Restoration
//          Resurrection
//          Rogues_Cunning
//          See_Invisibility
//          Shadow_Shield
//          Shapechange
//          Shield
//          Shield_of_Faith
//          Special_Alcohol_Beer
//          Special_Alcohol_Spirits
//          Special_Alcohol_Wine
//          Special_Herb_Belladonna
//          Special_Herb_Garlic
//          Spell_Mantle
//          Spell_Resistance
//          Spell_Resistance
//          Stoneskin
//          Tensers_Transformation
//          True_Seeing
//          True_Strike
//          Unique_Power
//          Unique_Power_Self_Only
//          Virtue
//
// GENERAL USE (ie. everything else):
//          Just about every spell is useable by all the general use items so instead we
//          will only list the ones that are not allowed:
//          Special_Alcohol_Beer
//          Special_Alcohol_Spirits
//          Special_Alcohol_Wine
//
itemproperty ItemPropertyCastSpell(int nSpell, int nNumUses);

// Returns Item property damage bonus.  You must specify the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonus(int nDamageType, int nDamage);

// Returns Item property damage bonus vs. Alignment groups.  You must specify the
// alignment group constant(IP_CONST_ALIGNMENTGROUP_*) and the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonusVsAlign(int nAlignGroup, int nDamageType, int nDamage);

// Returns Item property damage bonus vs. specific race.  You must specify the
// racial group constant(IP_CONST_RACIALTYPE_*) and the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonusVsRace(int nRace, int nDamageType, int nDamage);

// Returns Item property damage bonus vs. specific alignment.  You must specify the
// specific alignment constant(IP_CONST_ALIGNMENT_*) and the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonusVsSAlign(int nAlign, int nDamageType, int nDamage);

// Returns Item property damage immunity.  You must specify the damage type constant
// (IP_CONST_DAMAGETYPE_*) that you want to be immune to and the immune bonus percentage
// constant(IP_CONST_DAMAGEIMMUNITY_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageImmunity(int nDamageType, int nImmuneBonus);

// Returns Item property damage penalty.  You must specify the damage penalty.
// The damage penalty should be a POSITIVE integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyDamagePenalty(int nPenalty);

// JLR-OEI 04/03/06: This version is REPLACING the old DEPRECATED one.
// Returns Item property damage reduction.  You must specify:
// - nAmount: amount of damage reduction
// - nDmgBonus: (dependent on the nDRType)
//      - DR_TYPE_NONE:       ()
//      - DR_TYPE_DMGTYPE:    DAMAGE_TYPE_*
//      - DR_TYPE_MAGICBONUS: (DAMAGE_POWER_*)
//      - DR_TYPE_EPIC:       ()
//      - DR_TYPE_GMATERIAL:  GMATERIAL_*
//      - DR_TYPE_ALIGNMENT:  ALIGNMENT_*
//      - DR_TYPE_NON_RANGED: ()
// - nLimit: How much damage the effect can absorb before disappearing.
//   Set to zero for infinite
// - nDRType: DR_TYPE_*
itemproperty ItemPropertyDamageReduction(int nAmount, int nDRSubType, int nLimit=0, int nDRType=DR_TYPE_MAGICBONUS);


// Returns Item property damage resistance.  You must specify the damage type
// constant(IP_CONST_DAMAGETYPE_*) and the amount of HP of damage constant
// (IP_CONST_DAMAGERESIST_*) that will be resisted against each round.
itemproperty ItemPropertyDamageResistance(int nDamageType, int nHPResist);

// Returns Item property damage vulnerability.  You must specify the damage type
// constant(IP_CONST_DAMAGETYPE_*) that you want the user to be extra vulnerable to
// and the percentage vulnerability constant(IP_CONST_DAMAGEVULNERABILITY_*).
itemproperty ItemPropertyDamageVulnerability(int nDamageType, int nVulnerability);

// Return Item property Darkvision.
itemproperty ItemPropertyDarkvision();

// Return Item property decrease ability score.  You must specify the ability
// constant(IP_CONST_ABILITY_*) and the modifier constant.  The modifier must be
// a POSITIVE integer between 1 and 10 (ie. 1 = -1).
itemproperty ItemPropertyDecreaseAbility(int nAbility, int nModifier);

// Returns Item property decrease Armor Class.  You must specify the armor
// modifier type constant(IP_CONST_ACMODIFIERTYPE_*) and the armor class penalty.
// The penalty must be a POSITIVE integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyDecreaseAC(int nModifierType, int nPenalty);

// Returns Item property decrease skill.  You must specify the constant for the
// skill to be decreased(SKILL_*) and the amount of the penalty.  The penalty
// must be a POSITIVE integer between 1 and 10 (ie. 1 = -1).
itemproperty ItemPropertyDecreaseSkill(int nSkill, int nPenalty);

// Returns Item property container reduced weight.  This is used for special
// containers that reduce the weight of the objects inside them.  You must
// specify the container weight reduction type constant(IP_CONST_CONTAINERWEIGHTRED_*).
itemproperty ItemPropertyContainerReducedWeight(int nContainerType);

// Returns Item property extra melee damage type.  You must specify the extra
// melee base damage type that you want applied.  It is a constant(IP_CONST_DAMAGETYPE_*).
// NOTE: only the first 3 base types (piercing, slashing, & bludgeoning are applicable
//       here.
// NOTE: It is also only applicable to melee weapons.
itemproperty ItemPropertyExtraMeleeDamageType(int nDamageType);

// Returns Item property extra ranged damage type.  You must specify the extra
// melee base damage type that you want applied.  It is a constant(IP_CONST_DAMAGETYPE_*).
// NOTE: only the first 3 base types (piercing, slashing, & bludgeoning are applicable
//       here.
// NOTE: It is also only applicable to ranged weapons.
itemproperty ItemPropertyExtraRangeDamageType(int nDamageType);

// Returns Item property haste.
itemproperty ItemPropertyHaste();

// Returns Item property Holy Avenger.
itemproperty ItemPropertyHolyAvenger();

// Returns Item property immunity to miscellaneous effects.  You must specify the
// effect to which the user is immune, it is a constant(IP_CONST_IMMUNITYMISC_*).
itemproperty ItemPropertyImmunityMisc(int nImmunityType);

// Returns Item property improved evasion.
itemproperty ItemPropertyImprovedEvasion();

// Returns Item property bonus spell resistance.  You must specify the bonus spell
// resistance constant(IP_CONST_SPELLRESISTANCEBONUS_*).
itemproperty ItemPropertyBonusSpellResistance(int nBonus);

// Returns Item property saving throw bonus vs. a specific effect or damage type.
// You must specify the save type constant(IP_CONST_SAVEVS_*) that the bonus is
// applied to and the bonus that is be applied.  The bonus must be an integer
// between 1 and 20.
itemproperty ItemPropertyBonusSavingThrowVsX(int nBonusType, int nBonus);

// Returns Item property saving throw bonus to the base type (ie. will, reflex,
// fortitude).  You must specify the base type constant(IP_CONST_SAVEBASETYPE_*)
// to which the user gets the bonus and the bonus that he/she will get.  The
// bonus must be an integer between 1 and 20.
itemproperty ItemPropertyBonusSavingThrow(int nBaseSaveType, int nBonus);

// Returns Item property keen.  This means a critical threat range of 19-20 on a
// weapon will be increased to 17-20 etc.
itemproperty ItemPropertyKeen();

// Returns Item property light.  You must specify the intesity constant of the
// light(IP_CONST_LIGHTBRIGHTNESS_*) and the color constant of the light
// (IP_CONST_LIGHTCOLOR_*).
itemproperty ItemPropertyLight(int nBrightness, int nColor);

// Returns Item property Max range strength modification (ie. mighty).  You must
// specify the maximum modifier for strength that is allowed on a ranged weapon.
// The modifier must be a positive integer between 1 and 20.
itemproperty ItemPropertyMaxRangeStrengthMod(int nModifier);

// Returns Item property no damage.  This means the weapon will do no damage in
// combat.
itemproperty ItemPropertyNoDamage();

// Returns Item property on hit -> do effect property.  You must specify the on
// hit property constant(IP_CONST_ONHIT_*) and the save DC constant(IP_CONST_ONHIT_SAVEDC_*).
// Some of the item properties require a special parameter as well.  If the
// property does not require one you may leave out the last one.  The list of
// the ones with 3 parameters and what they are are as follows:
//      ABILITYDRAIN      :nSpecial is the ability it is to drain.
//                         constant(IP_CONST_ABILITY_*)
//      BLINDNESS         :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      CONFUSION         :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      DAZE              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      DEAFNESS          :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      DISEASE           :nSpecial is the type of desease that will effect the victim.
//                         constant(DISEASE_*)
//      DOOM              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      FEAR              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      HOLD              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      ITEMPOISON        :nSpecial is the type of poison that will effect the victim.
//                         constant(IP_CONST_POISON_*)
//      SILENCE           :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      SLAYRACE          :nSpecial is the race that will be slain.
//                         constant(IP_CONST_RACIALTYPE_*)
//      SLAYALIGNMENTGROUP:nSpecial is the alignment group that will be slain(ie. chaotic).
//                         constant(IP_CONST_ALIGNMENTGROUP_*)
//      SLAYALIGNMENT     :nSpecial is the specific alignment that will be slain.
//                         constant(IP_CONST_ALIGNMENT_*)
//      SLEEP             :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      SLOW              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      STUN              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
itemproperty ItemPropertyOnHitProps(int nProperty, int nSaveDC, int nSpecial=0);

// Returns Item property reduced saving throw vs. an effect or damage type.  You must
// specify the constant to which the penalty applies(IP_CONST_SAVEVS_*) and the
// penalty to be applied.  The penalty must be a POSITIVE integer between 1 and 20
// (ie. 1 = -1).
itemproperty ItemPropertyReducedSavingThrowVsX(int nBaseSaveType, int nPenalty);

// Returns Item property reduced saving to base type.  You must specify the base
// type to which the penalty applies (ie. will, reflex, or fortitude) and the penalty
// to be applied.  The constant for the base type starts with (IP_CONST_SAVEBASETYPE_*).
// The penalty must be a POSITIVE integer between 1 and 20 (ie. 1 = -1).
itemproperty ItemPropertyReducedSavingThrow(int nBonusType, int nPenalty);

// Returns Item property regeneration.  You must specify the regeneration amount.
// The amount must be an integer between 1 and 20.
itemproperty ItemPropertyRegeneration(int nRegenAmount);

// Returns Item property skill bonus.  You must specify the skill to which the user
// will get a bonus(SKILL_*) and the amount of the bonus.  The bonus amount must
// be an integer between 1 and 50.
itemproperty ItemPropertySkillBonus(int nSkill, int nBonus);

// Returns Item property spell immunity vs. specific spell.  You must specify the
// spell to which the user will be immune(IP_CONST_IMMUNITYSPELL_*).
itemproperty ItemPropertySpellImmunitySpecific(int nSpell);

// Returns Item property spell immunity vs. spell school.  You must specify the
// school to which the user will be immune(IP_CONST_SPELLSCHOOL_*).
itemproperty ItemPropertySpellImmunitySchool(int nSchool);

// Returns Item property Thieves tools.  You must specify the modifier you wish
// the tools to have.  The modifier must be an integer between 1 and 12.
itemproperty ItemPropertyThievesTools(int nModifier);

// Returns Item property Attack bonus.  You must specify an attack bonus.  The bonus
// must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonus(int nBonus);

// Returns Item property Attack bonus vs. alignment group.  You must specify the
// alignment group constant(IP_CONST_ALIGNMENTGROUP_*) and the attack bonus.  The
// bonus must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonusVsAlign(int nAlignGroup, int nBonus);

// Returns Item property attack bonus vs. racial group.  You must specify the
// racial group constant(IP_CONST_RACIALTYPE_*) and the attack bonus.  The bonus
// must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonusVsRace(int nRace, int nBonus);

// Returns Item property attack bonus vs. a specific alignment.  You must specify
// the alignment you want the bonus to work against(IP_CONST_ALIGNMENT_*) and the
// attack bonus.  The bonus must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonusVsSAlign(int nAlignment, int nBonus);

// Returns Item property attack penalty.  You must specify the attack penalty.
// The penalty must be a POSITIVE integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyAttackPenalty(int nPenalty);

// Returns Item property unlimited ammo.  If you leave the parameter field blank
// it will be just a normal bolt, arrow, or bullet.  However you may specify that
// you want the ammunition to do special damage (ie. +1d6 Fire, or +1 enhancement
// bonus).  For this parmeter you use the constants beginning with:
//      (IP_CONST_UNLIMITEDAMMO_*).
itemproperty ItemPropertyUnlimitedAmmo(int nAmmoDamage=IP_CONST_UNLIMITEDAMMO_BASIC);

// Returns Item property limit use by alignment group.  You must specify the
// alignment group(s) that you want to be able to use this item(IP_CONST_ALIGNMENTGROUP_*).
itemproperty ItemPropertyLimitUseByAlign(int nAlignGroup);

// Returns Item property limit use by class.  You must specify the class(es) who
// are able to use this item(IP_CONST_CLASS_*).
itemproperty ItemPropertyLimitUseByClass(int nClass);

// Returns Item property limit use by race.  You must specify the race(s) who are
// allowed to use this item(IP_CONST_RACIALTYPE_*).
itemproperty ItemPropertyLimitUseByRace(int nRace);

// Returns Item property limit use by specific alignment.  You must specify the
// alignment(s) of those allowed to use the item(IP_CONST_ALIGNMENT_*).
itemproperty ItemPropertyLimitUseBySAlign(int nAlignment);

/*
// replace this function it does nothing.
itemproperty BadBadReplaceMeThisDoesNothing();
*/

// Brock H. - OEI 02/20/06 -- creates a "bonus hitpoints"
// itemproperty. Note that nBonusType refers to the row
// in iprp_bonushp.2da which has the bonus HP value, and
// is not nessisarily the amount of HPs added.
itemproperty ItemPropertyBonusHitpoints(int nBonusType);


// Returns Item property vampiric regeneration.  You must specify the amount of
// regeneration.  The regen amount must be an integer between 1 and 20.
itemproperty ItemPropertyVampiricRegeneration(int nRegenAmount);

// Returns Item property Trap.  You must specify the trap level constant
// (IP_CONST_TRAPSTRENGTH_*) and the trap type constant(IP_CONST_TRAPTYPE_*).
itemproperty ItemPropertyTrap(int nTrapLevel, int nTrapType);

// Returns Item property true seeing.
itemproperty ItemPropertyTrueSeeing();

// Returns Item property Monster on hit apply effect property.  You must specify
// the property that you want applied on hit.  There are some properties that
// require an additional special parameter to be specified.  The others that
// don't require any additional parameter you may just put in the one.  The
// special cases are as follows:
//      ABILITYDRAIN:nSpecial is the ability to drain.
//                   constant(IP_CONST_ABILITY_*)
//      DISEASE     :nSpecial is the disease that you want applied.
//                   constant(DISEASE_*)
//      LEVELDRAIN  :nSpecial is the number of levels that you want drained.
//                   integer between 1 and 5.
//      POISON      :nSpecial is the type of poison that will effect the victim.
//                   constant(IP_CONST_POISON_*)
//      WOUNDING    :nSpecial is the amount of wounding.
//                   integer between 1 and 5.
// NOTE: Any that do not appear in the above list do not require the second
//       parameter.
// NOTE: These can only be applied to monster NATURAL weapons (ie. bite, claw,
//       gore, and slam).  IT WILL NOT WORK ON NORMAL WEAPONS.
itemproperty ItemPropertyOnMonsterHitProperties(int nProperty, int nSpecial=0);

// Returns Item property turn resistance.  You must specify the resistance bonus.
// The bonus must be an integer between 1 and 50.
itemproperty ItemPropertyTurnResistance(int nModifier);

// Returns Item property Massive Critical.  You must specify the extra damage
// constant(IP_CONST_DAMAGEBONUS_*) of the criticals.
itemproperty ItemPropertyMassiveCritical(int nDamage);

// Returns Item property free action.
itemproperty ItemPropertyFreeAction();

// Returns Item property monster damage.  You must specify the amount of damage
// the monster's attack will do(IP_CONST_MONSTERDAMAGE_*).
// NOTE: These can only be applied to monster NATURAL weapons (ie. bite, claw,
//       gore, and slam).  IT WILL NOT WORK ON NORMAL WEAPONS.
itemproperty ItemPropertyMonsterDamage(int nDamage);

// Returns Item property immunity to spell level.  You must specify the level of
// which that and below the user will be immune.  The level must be an integer
// between 1 and 9.  By putting in a 3 it will mean the user is immune to all
// 3rd level and lower spells.
itemproperty ItemPropertyImmunityToSpellLevel(int nLevel);

// Returns Item property special walk.  If no parameters are specified it will
// automatically use the zombie walk.  This will apply the special walk animation
// to the user.
itemproperty ItemPropertySpecialWalk(int nWalkType=0);

// Returns Item property healers kit.  You must specify the level of the kit.
// The modifier must be an integer between 1 and 12.
itemproperty ItemPropertyHealersKit(int nModifier);

// Returns Item property weight increase.  You must specify the weight increase
// constant(IP_CONST_WEIGHTINCREASE_*).
itemproperty ItemPropertyWeightIncrease(int nWeight);

// ***********************  END OF ITEM PROPERTY FUNCTIONS  **************************

// Returns true if 1d20 roll + skill rank is greater than or equal to difficulty
// - oTarget: the creature using the skill
// - nSkill: the skill being used
// - nDifficulty: Difficulty class of skill
// - bDisplayFeedback: Set to false to prevent feedback from being sent to the player. //RWT-OWI 10/13/08
int GetIsSkillSuccessful(object oTarget, int nSkill, int nDifficulty, int bDisplayFeedback=TRUE);

// Creates an effect that inhibits spells
// Compare this with EffectArcaneSpellFailure, which stacks with armor/shield ASF,
// and is ignored by the same classes & abilities (e.g. divine casters).  EffectSpellFailure
// incurs another spell failure check after the ASF check and cannot be mitigated.
// - nPercent - percentage of failure
// - nSpellSchool - the school of spells affected.
effect EffectSpellFailure(int nPercent=100, int nSpellSchool=SPELL_SCHOOL_GENERAL);

// Causes the object to instantly speak a translated string.
// (not an action, not blocked when uncommandable)
// - nStrRef: Reference of the string in the talk table
// - nTalkVolume: TALKVOLUME_*
void SpeakStringByStrRef(int nStrRef, int nTalkVolume=TALKVOLUME_TALK);

// Sets the given creature into cutscene mode.  This prevents the player from
// using the GUI and camera controls.
// - oCreature: creature in a cutscene
// - nInCutscene: TRUE to move them into cutscene, FALSE to remove cutscene mode
void SetCutsceneMode(object oCreature, int nInCutscene=TRUE);

// Gets the last player character to cancel from a cutscene.
object GetLastPCToCancelCutscene();

// Gets the length of the specified wavefile, in seconds
// Only works for sounds used for dialog.
float GetDialogSoundLength(int nStrRef);

// Fades the screen for the given creature/player from black to regular screen
// - oCreature: creature controlled by player that should fade from black
// fSpeed is a float representing how many seconds the fade should
// take place over
void FadeFromBlack(object oCreature, float fSpeed=FADE_SPEED_MEDIUM);

// Fades the screen for the given creature/player from regular screen to black
// - oCreature: creature controlled by player that should fade to black
// fSpeed is a float representing how many seconds the fade should
// take place over
// RWT-OEI 08/09/05 - Added fFailsafe parameter. Indicates the number of seconds
// that should pass before the fade is removed unconditionally. If set to 0,
// then there will be no failsafe.
// RWT-OEI 01/20/06 - The new nColor parameter allows one to fade to colors other than
// black.
void FadeToBlack(object oCreature, float fSpeed=FADE_SPEED_MEDIUM, float fFailsafe=5.0, int nColor=0);

// Removes any fading or black screen.
// - oCreature: creature controlled by player that should be cleared
void StopFade(object oCreature);

// Sets the screen to black.  Can be used in preparation for a fade-in (FadeFromBlack)
// Can be cleared by either doing a FadeFromBlack, or by calling StopFade.
// - oCreature: creature controlled by player that should see black screen
// RWT-OEI 01/20/06 - New nColor parameter forces the screen to different colors.
void BlackScreen(object oCreature, int nColor=0);

// Returns the base attach bonus for the given creature.
int GetBaseAttackBonus(object oCreature);

// Set a creature's immortality flag.
// -oCreature: creature affected
// -bImmortal: TRUE = creature is immortal and cannot be killed (but still takes damage)
//             FALSE = creature is not immortal and is damaged normally.
void SetImmortal(object oCreature, int bImmortal);

// Open's this creature's inventory panel for this player
// - oCreature: creature to view
// - oPlayer: the owner of this creature will see the panel pop up
// * DM's can view any creature's inventory
// * Players can view their own inventory, or that of their henchman, familiar or animal companion
void OpenInventory(object oCreature, object oPlayer);

// Stores the current camera mode and position so that it can be restored (using
// RestoreCameraFacing())
void StoreCameraFacing();

// Restores the camera mode and position to what they were last time StoreCameraFacing
// was called.  RestoreCameraFacing can only be called once, and must correspond to a
// previous call to StoreCameraFacing.
void RestoreCameraFacing();

// Levels up a creature using default settings, regardless of how much XP the creature has.
// If successful, it returns the level the creature now is, or 0 if it fails.
// If you want to give them a different level (ie: Give a Fighter a level of Wizard)
//    you can specify that in the nClass.  If you do not use this argument, it will
//    level up the first class selected by the creature.
// If you turn on bReadyAllSpells, all memorized spells will be ready to cast without resting.
// If nPackage is PACKAGE_INVALID then it will use the starting package assigned to that class.
int LevelUpHenchman(object oCreature, int nClass = CLASS_TYPE_INVALID, int bReadyAllSpells = FALSE, int nPackage = PACKAGE_INVALID);

// Sets the droppable flag on an item
// - oItem: the item to change
// - bDroppable: TRUE or FALSE, whether the item should be droppable
void SetDroppableFlag(object oItem, int bDroppable);

// Gets the weight of an item, or the total carried weight of a creature in tenths
// of pounds (as per the baseitems.2da).
// - oTarget: the item or creature for which the weight is needed
int GetWeight(object oTarget=OBJECT_SELF);

// Gets the object that acquired the module item.  May be a creature, item, or placeable
object GetModuleItemAcquiredBy();

// Get the immortal flag on a creature
int GetImmortal(object oTarget=OBJECT_SELF);

// Does a single attack on every hostile creature within 10ft. of the attacker
// and determines damage accordingly.  If the attacker has a ranged weapon
// equipped, this will have no effect.
// ** NOTE ** This is meant to be called inside the spell script for whirlwind
// attack, it is not meant to be used to queue up a new whirlwind attack.  To do
// that you need to call ActionUseFeat(FEAT_WHIRLWIND_ATTACK, oEnemy)
// - int bDisplayFeedback: TRUE or FALSE, whether or not feedback should be
//   displayed
// - int bImproved: If TRUE, the improved version of whirlwind is used
void DoWhirlwindAttack(int bDisplayFeedback=TRUE, int bImproved=FALSE);

// Gets a value from a 2DA file on the server and returns it as a string
// avoid using this function in loops
// - s2DA: the name of the 2da file, 16 chars max
// - sColumn: the name of the column in the 2da
// - nRow: the row in the 2da
// * returns an empty string if file, row, or column not found
string Get2DAString(string s2DA, string sColumn, int nRow);

// Returns an effect of type EFFECT_TYPE_ETHEREAL which works just like EffectSanctuary
// except that the observers get no saving throw
effect EffectEthereal();

// Gets the current AI Level that the creature is running at.
// Returns one of the following:
// AI_LEVEL_INVALID, AI_LEVEL_VERY_LOW, AI_LEVEL_LOW, AI_LEVEL_NORMAL, AI_LEVEL_HIGH, AI_LEVEL_VERY_HIGH
int GetAILevel(object oTarget=OBJECT_SELF);

// Sets the current AI Level of the creature to the value specified. Does not work on Players.
// The game by default will choose an appropriate AI level for
// creatures based on the circumstances that the creature is in.
// Explicitly setting an AI level will over ride the game AI settings.
// The new setting will last until SetAILevel is called again with the argument AI_LEVEL_DEFAULT.
// AI_LEVEL_DEFAULT  - Default setting. The game will take over seting the appropriate AI level when required.
// AI_LEVEL_VERY_LOW - Very Low priority, very stupid, but low CPU usage for AI. Typically used when no players are in the area.
// AI_LEVEL_LOW      - Low priority, mildly stupid, but slightly more CPU usage for AI. Typically used when not in combat, but a player is in the area.
// AI_LEVEL_NORMAL   - Normal priority, average AI, but more CPU usage required for AI. Typically used when creature is in combat.
// AI_LEVEL_HIGH     - High priority, smartest AI, but extremely high CPU usage required for AI. Avoid using this. It is most likely only ever needed for cutscenes.
void SetAILevel(object oTarget, int nAILevel);

// This will return TRUE if the creature running the script is a familiar currently
// possessed by his master.
// returns FALSE if not or if the creature object is invalid
int GetIsPossessedFamiliar(object oCreature);

// This will cause a Player Creature to unpossess his/her familiar.  It will work if run
// on the player creature or the possessed familiar.  It does not work in conjunction with
// any DM possession.
void UnpossessFamiliar(object oCreature);

// This will return TRUE if the area is flagged as either interior or underground.
int GetIsAreaInterior( object oArea = OBJECT_INVALID );

// Send a server message (szMessage) to the oPlayer.
void SendMessageToPCByStrRef(object oPlayer, int nStrRef);

// Increment the remaining uses per day for this creature by one.
// Total number of feats per day can not exceed the maximum.
// - oCreature: creature to modify
// - nFeat: constant FEAT_*
void IncrementRemainingFeatUses(object oCreature, int nFeat);

// Force the character of the player specified to be exported to its respective directory
// i.e. LocalVault/ServerVault/ etc.
void ExportSingleCharacter(object oPlayer);

// This will play a sound that is associated with a stringRef, it will be a mono sound from the location of the object running the command.
// if nRunAsAction is off then the sound is forced to play intantly.
void PlaySoundByStrRef(int nStrRef, int nRunAsAction = TRUE );

// Set the name of oCreature's sub race to sSubRace.
void SetSubRace(object oCreature, string sSubRace);

// Set the name of oCreature's Deity to sDeity.
void SetDeity(object oCreature, string sDeity);

// Returns TRUE if the creature oCreature is currently possessed by a DM character.
// Returns FALSE otherwise.
// Note: GetIsDMPossessed() will return FALSE if oCreature is the DM character.
// To determine if oCreature is a DM character use GetIsDM()
int GetIsDMPossessed(object oCreature);

// Gets the current weather conditions for the area oArea.
//   - nWeatherType
//   -> WEATHER_TYPE_* is the weather pattern type we want the power setting for.
//   Returns: WEATHER_POWER_* or WEATHER_POWER_INVALID
//   Note: If called on an Interior area, this will always return WEATHER_CLEAR.
int GetWeather(object oArea, int nWeatherType);

// Returns AREA_NATURAL if the area oArea is natural, AREA_ARTIFICIAL otherwise.
// Returns AREA_INVALID, on an error.
int GetIsAreaNatural(object oArea);

// Returns AREA_ABOVEGROUND if the area oArea is above ground, AREA_UNDERGROUND otherwise.
// Returns AREA_INVALID, on an error.
int GetIsAreaAboveGround(object oArea);

// Use this to get the item last equipped by a player character in OnPlayerEquipItem..
object GetPCItemLastEquipped();

// Use this to get the player character who last equipped an item in OnPlayerEquipItem..
object GetPCItemLastEquippedBy();

// Use this to get the item last unequipped by a player character in OnPlayerEquipItem..
object GetPCItemLastUnequipped();

// Use this to get the player character who last unequipped an item in OnPlayerUnEquipItem..
object GetPCItemLastUnequippedBy();

// Creates a new copy of an item, while making a single change to the appearance of the item.
// Helmet models and simple items ignore iIndex.
// iType                            iIndex                      iNewValue
// ITEM_APPR_TYPE_SIMPLE_MODEL      [Ignored]                   Model #
// ITEM_APPR_TYPE_WEAPON_COLOR      ITEM_APPR_WEAPON_COLOR_*    1-4
// ITEM_APPR_TYPE_WEAPON_MODEL      ITEM_APPR_WEAPON_MODEL_*    Model #
// ITEM_APPR_TYPE_ARMOR_MODEL       ITEM_APPR_ARMOR_MODEL_*     Model #
// ITEM_APPR_TYPE_ARMOR_COLOR       ITEM_APPR_ARMOR_COLOR_*     0-63
object CopyItemAndModify(object oItem, int nType, int nIndex, int nNewValue, int bCopyVars=FALSE);

// Queries the current value of the appearance settings on an item. The parameters are
// identical to those of CopyItemAndModify().
int GetItemAppearance(object oItem, int nType, int nIndex);

// Creates an item property that (when applied to a weapon item) causes a spell to be cast
// when a successful strike is made, or (when applied to armor) is struck by an opponent.
// - nSpell uses the IP_CONST_ONHIT_CASTSPELL_* constants
itemproperty ItemPropertyOnHitCastSpell(int nSpell, int nLevel);

// Returns the SubType number of the item property. See the 2DA files for value definitions.
int GetItemPropertySubType(itemproperty iProperty);

// Gets the status of ACTION_MODE_* modes on a creature.
int GetActionMode(object oCreature, int nMode);

// Sets the status of modes ACTION_MODE_* on a creature.
void SetActionMode(object oCreature, int nMode, int nStatus);

// Returns the current arcane spell failure factor of a creature
int GetArcaneSpellFailure(object oCreature);

//Makes the player examine the object oExamine. This causes the examination window
// to appear for the object specified.
void ActionExamine(object oExamine);

// Creates a visual effect (ITEM_VISUAL_*) that may be applied to
// melee weapons only.
itemproperty ItemPropertyVisualEffect(int nEffect);

// Sets the lootable state of a *living* NPC creature.
// This function will *not* work on players or dead creatures.
void SetLootable( object oCreature, int bLootable );

// Returns the lootable state of a creature.
int GetLootable( object oCreature );

// Returns the current movement rate factor
// of the cutscene 'camera man'.
// NOTE: This will be a value between 0.1, 2.0 (10%-200%)
float GetCutsceneCameraMoveRate( object oCreature );

// Sets the current movement rate factor for the cutscene
// camera man.
// NOTE: You can only set values between 0.1, 2.0 (10%-200%)
void SetCutsceneCameraMoveRate( object oCreature, float fRate );

// Returns TRUE if the item is cursed and cannot be dropped
int GetItemCursedFlag(object oItem);

// When cursed, items cannot be dropped
void SetItemCursedFlag(object oItem, int nCursed);

// Sets the maximum number of henchmen
void SetMaxHenchmen( int nNumHenchmen );

// Gets the maximum number of henchmen
int GetMaxHenchmen();

// Returns the associate type of the specified creature.
// - Returns ASSOCIATE_TYPE_NONE if the creature is not the associate of anyone.
int GetAssociateType( object oAssociate );

// Returns the spell resistance of the specified creature.
// - Returns 0 if the creature has no spell resistance or an invalid
//   creature is passed in.
int GetSpellResistance( object oCreature );

// Changes the current Day/Night cycle for this player to night - Note: This only works for areas that don't use the DayNight Cycle
// - oPlayer: which player to change the sky for
// - fTransitionTime: how long the transition should take(not currently used)
void DayToNight(object oPlayer, float fTransitionTime=0.0f);

// Changes the current Day/Night cycle for this player to daylight - Note: This only works for areas that don't use the DayNight Cycle
// - oPlayer: which player to change the sky for
// - fTransitionTime: how long the transition should take (not currently used)
void NightToDay(object oPlayer, float fTransitionTime=0.0f);

// Returns whether or not there is a direct line of sight
// between the two objects. (Not blocked by any geometry).
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
int LineOfSightObject( object oSource, object oTarget );

// Returns whether or not there is a direct line of sight
// between the two vectors. (Not blocked by any geometry).
//
// This function must be run on a valid object in the area
// it will not work on the module or area.
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
int LineOfSightVector( vector vSource, vector vTarget );

// Returns the class that the spellcaster cast the
// spell as.
// - Returns CLASS_TYPE_INVALID if the caster has
//   no valid class (placeables, etc...)
int GetLastSpellCastClass();

// Sets the number of base attacks for the specified
// creatures. The range of values accepted are from
// 1 to 6
// Note: This function does not work on Player Characters
void SetBaseAttackBonus( int nBaseAttackBonus, object oCreature = OBJECT_SELF );

// Restores the number of base attacks back to it's
// original state.
void RestoreBaseAttackBonus( object oCreature = OBJECT_SELF );

// Creates a cutscene ghost effect, this will allow creatures
// to pathfind through other creatures without bumping into them
// for the duration of the effect.
effect EffectCutsceneGhost();

// Creates an item property that offsets the effect on arcane spell failure
// that a particular item has. Parameters come from the ITEM_PROP_ASF_* group.
itemproperty ItemPropertyArcaneSpellFailure(int nModLevel);

// Returns the amount of gold a store currently has. -1 indicates it is not using gold.
// -2 indicates the store could not be located.
int GetStoreGold(object oidStore);

// Sets the amount of gold a store has. -1 means the store does not use gold.
void SetStoreGold(object oidStore, int nGold);

// Gets the maximum amount a store will pay for any item. -1 means price unlimited.
// -2 indicates the store could not be located.
int GetStoreMaxBuyPrice(object oidStore);

// Gets the maximum amount a store will pay for any item. -1 means price unlimited.
void SetStoreMaxBuyPrice(object oidStore, int nMaxBuy);

// Gets the amount a store charges for identifying an item. Default is 100. -1 means
// the store will not identify items.
// -2 indicates the store could not be located.
int GetStoreIdentifyCost(object oidStore);

// Sets the amount a store charges for identifying an item. Default is 100. -1 means
// the store will not identify items.
void SetStoreIdentifyCost(object oidStore, int nCost);

// Sets the creature's appearance type to the value specified (uses the APPEARANCE_TYPE_XXX constants)
void SetCreatureAppearanceType(object oCreature, int nAppearanceType);

// Returns the default package selected for this creature to level up with
// - returns PACKAGE_INVALID if error occurs
int GetCreatureStartingPackage(object oCreature);

// Returns an effect that when applied will paralyze the target's legs, rendering
// them unable to walk but otherwise unpenalized. This effect cannot be resisted.
effect EffectCutsceneImmobilize();

// Is this creature in the given subarea? (trigger, area of effect object, etc..)
// This function will tell you if the creature has triggered an onEnter event,
// not if it is physically within the space of the subarea
int GetIsInSubArea(object oCreature, object oSubArea=OBJECT_SELF);

// Returns the Cost Table number of the item property. See the 2DA files for value definitions.
int GetItemPropertyCostTable(itemproperty iProp);

// Returns the Cost Table value (index of the cost table) of the item property.
// See the 2DA files for value definitions.
int GetItemPropertyCostTableValue(itemproperty iProp);

// Returns the Param1 number of the item property. See the 2DA files for value definitions.
int GetItemPropertyParam1(itemproperty iProp);

// Returns the Param1 value of the item property. See the 2DA files for value definitions.
int GetItemPropertyParam1Value(itemproperty iProp);

// Is this creature able to be disarmed? (checks disarm flag on creature, and if
// the creature actually has a weapon equipped in their right hand that is droppable)
int GetIsCreatureDisarmable(object oCreature);

// Sets whether this item is 'stolen' or not
void SetStolenFlag(object oItem, int nStolenFlag);

// Gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..)
void ForceRest(object oCreature);

// Forces this player's camera to be set to this height. Setting this value to zero will
// restore the camera to the racial default height.
void SetCameraHeight(object oPlayer, float fHeight=0.0f);

// Global Var stuff
// set a global int
int SetGlobalInt(string sName, int nValue);

int SetGlobalBool(string sName, int bValue);

int SetGlobalString(string sName, string sValue);

int SetGlobalFloat(string sName, float fValue);

//int SetGlobalLocation(string sName, location lValue);//AWD-OEI 01/04/2004 commented out

int GetGlobalInt(string sName);

int GetGlobalBool(string sName);

string GetGlobalString(string sName);

float GetGlobalFloat(string sName);

//location GetGlobalLocation(string sName);//AWD-OEI 01/04/2004 commented out

int SaveGlobalVariables(string sSaveName="");
int LoadGlobalVariables(string sLoadName="");

//AWD-OEI 01/04/2005
// object oMountingObject - The object to do the mounting
// object oObjectToMount - The object to be mounted
void MountObject(object oMountingObject, object oObjectToMount);

//AWD-OEI 01/04/2005
// object oDismountingObject - The object to do the mounting
// object oObjectToDismount - The object to be mounted
void DismountObject(object oDismountingObject, object oObjectToDismount);

//AWD-OEI 01/25/2005
// string szPlotID - the plot identifier
// object oObjectJournal - the object with the journal you want
int GetJournalEntry(string szPlotID, object oObjectJournal);

//RWT-OEI 05/11/05
//This function creates a 'Particle Effect' effect.
//It can then be applied to an object or location
effect EffectNWN2ParticleEffect();

//RWT-OEI 05/11/05
//This function returns an effect for a particle emitter with a given
//definition file. Since the file contains most of the parameters,
//fewer parameters are set in the function
effect EffectNWN2ParticleEffectFile( string sDefinitionFile );

//RWT-OEI 05/31/05
//This function creates a Special Effects File effect that can
//then be applied to an object or a location
//For effects that just need a single location (or source object),
//such as particle emitters, the source loc or object comes from
//using ApplyEffectToObject and ApplyEffectToLocation
//For Point-to-Point effects, like beams and lightning, oTarget
//is the target object for the other end of the effect. If oTarget
//is OBJECT_INVALID, then the position located in vTargetPosition
//is used instead.
effect EffectNWN2SpecialEffectFile( string sFileName, object oTarget=OBJECT_INVALID, vector vTargetPosition=[0.0,0.0,0.0]  );

// JLR - OEI 06/06/05 NWN2 3.5
// Returns the Spell Level of the spell being cast (use in Spell scripts)
int GetSpellLevel(int nSpellID);

//RWT-OEI 06/07/05
//This function removes 1 instance of a SEF from an object. Since
//an object can only have 1 instance of a specific SEF running on it
//at once, this should effectively remove 'all' instances of the
//specified SEF from the object
void RemoveSEFFromObject( object oObject, string sSEFName );

//RWT-OEI 06/15/05
//This pauses the conversation in progress just like ActionPauseConversation.
//However, in this case the conversation will automatically resume once
//at least one cutscene action has been asigned and there are no cutscene
//actions currently pending. The timeout passed in is the number of miliseconds
//before the cutscene should resume no matter what. When a cutscene resumes
//due to timing out, all pending cutscene actions will be cleared.
//If bPurgeCutsceneActionsOnTimeout is TRUE, then if the timeout is hit,
//all pending CutsceneActions will be cancelled.
void ActionPauseCutscene( int nTimeoutSecs, int bPurgeCutsceneActionsOnTimeout=FALSE );

//RWT-OEI 06/15/05
//This function assigns cutscene actions to the object passed in. Cutscene actions
//are normal script actions that carry a special 'Cutscene flag' when executed.
//Currently this does not affect the behavior of the action, but that could change
//down the line. If a dialog is paused via ActionPauseCutscene() then it will not
//resume if there are any Cutscene-flagged actions still being exected.
void AssignCutsceneActionToObject( object oObject, action aAction );


// JLR - OEI 06/29/05 NWN2 3.5
// Returns the Character Background (BACKGROUND_*) on a character, if any.
int GetCharBackground( object oCreature );

// RWT-OEI 06/30/05
//Traps are Active by default. Passing FALSE in for this function sets them
//to be not Active. When a trap is not Active, it will not fire when stepped
//onto. For now, this only works on Trigger based traps, not Door/Chest related
//traps.
//RWT-OEI 03/14/07 - Update: Now works on door and placeable traps as well.
void SetTrapActive( object oTrap, int bActive );

//RWT-OEI 07/06/05
//This function makes it so that a creature's orientation ( or facing ) won't
//be set automatically during a dialog. This prevents a creature from
//turning to face a speaker, or a speaker from facing a listener.
//Passing in 'TRUE' re-enables the default behavior where speaker and listener
//will face each other on each dialog node
//Right now only works on creatures. If it needs to work on placeables, let
//me know.
void SetOrientOnDialog( object oCreature, int bActive );

// JLR - OEI 07/12/05 NWN2 3.5
// Create a Detect Undead effect.  (Spell Scripts)
effect EffectDetectUndead();

// JLR - OEI 07/13/05 NWN2 3.5
// Create a Low Light Vision effect.  (Spell Scripts)
effect EffectLowLightVision();

// Create a Set Scale effect.  (Spell Scripts)
//RWT-OEI 04/04/07 - Added fScaleY, fScaleZ
// If fScaleY or fScaleZ are left at -1.0, fScaleX will be used
// for their value
effect EffectSetScale( float fScaleX, float fScaleY=-1.0, float fScaleZ=-1.0 );

// JLR - OEI 07/14/05 NWN2 3.5
// Create a Share Damage effect.  (Spell Scripts)
// nAmtShared is the % amount (1-100) of the damage dealt that the target will take.
// nAmtCasterShared is the % amount (1-100) of the damage dealt that the caster will take.
// The two numbers do not need to add up to 100; a sum of under 100 means some damage "disappears",
// a sum of over 100 means extra damage is "created".
effect EffectShareDamage( object oHelper, int nAmtShared=50, int nAmtCasterShared=50 );

// JLR - OEI 07/16/05 NWN2 3.5
// Create an effect to gain bonus vs. Spell Resistance for a specific target
effect EffectAssayResistance( object oTarget );

// Create an effect to see actual values of target's Hit Points
effect EffectSeeTrueHPs();

//RWT-OEI 07/20/05
//This function returns the number of cutscene actions currently pending.
//It can be used for debugging problems with cutscenepause not resuming
//when it was expected to.
int GetNumCutsceneActionsPending();

// Create a Damage Over Time (DOT) effect.
// - nAmount: amount of damage to be taken per time interval
// - fIntervalSeconds: length of interval in seconds
// - nDamageType: DAMAGE_TYPE_*
// - nIgnoreResistances: FALSE will use damage immunity, damage reduction, and damage resistance.  TRUE will skip all of these.
effect EffectDamageOverTime(int nAmount, float fIntervalSeconds, int nDamageType=DAMAGE_TYPE_MAGICAL, int nIgnoreResistances=FALSE);

// Create a Damage Absorbtion effect.
// - nACTest: AC to exceed to bypass DMG Absorbtion
effect EffectAbsorbDamage(int nACTest);

// Create a Hideous Blow effect.
// - nMetamagic: The Metamagic to apply when it triggers
effect EffectHideousBlow(int nMetamagic);

// Brock H. - OEI 09/16/05
// Create a mesmerization effect
// - nBreakFlags:   these flags define what sorts of events can disrupt
//                  the mesmerization effect for the creature.
//                  see MESMERIZE_BREAK_ON_* above
// - fBreakDist:    If the Bard moves more than this distance from the
//                  creature, or changes areas, then the effect is
//                  disrupted. NOTE: If the distance is not greater
//                  than zero, then the check is not run, and the area
//                  check is skipped as well.
effect EffectMesmerize( int nBreakFlags, float fBreakDist = 0.0f );

// This is for use in a Spell script, it gets the Feat ID of the spellability that is being
// cast (FEAT_*).  (The Feat that maps to this SpellAbility)
int GetSpellFeatId();

// Set the fog properties for oTarget.
// - oTarget: if this is GetModule(), all areas will be modified by the
//   fog settings. If it is an area, only that area will be modified.
// - nFogType: FOG_TYPE*
//   -> FOG_TYPE_SUN, FOG_TYPE_MOON, FOG_TYPE_BOTH
// - nColor: FOG_COLOR*
//   -> You can also pass in a hex RGB number that corresponds to the fog color.
// - fFogStart
//   -> The distance at which the fog starts.
// - fFogEnd
//   -> The distance at which the fog ends and is at its full color.
// - fFarClipPlaneDistance
//   -> The distance at which the world dissapears into the skybox.
// * Note that this function has changed in NWN2.
// * Note that you can use FOG_TYPE_BOTH for the nFogType parameters to set both the MOON and
//   SUN fog types.
void SetFog( object oTarget, int nFogType, int nColor, float fFogStart, float fFogEnd, float fFarClipPlaneDistance);

// JLR - OEI 08/04/05 NWN2 3.5
// Create a DarkVision effect.  (Spell Scripts)
effect EffectDarkVision();

//RWT-OEI 08/11/05
//Prints a debug string to the screen at the given location for the given duration in the given color.
//It gets displayed on the screen of the object passed in as oTarget
// output controlled by ini settings: nwn.ini - [Game Options]Debug Text & nwnplayer.ini - [Server Options]Scripts Print To Screen
void DebugPostString( object oTarget, string sMesg, int nX, int nY, float fDuration, int nColor=4294901760 );



///////////////////////////////////////////////////////////////////////////////
// GetHasAnySpellEffect
///////////////////////////////////////////////////////////////////////////////
//
// Created By: Brock Heinz
// Created On: 08/12/2005
// Description: This function returns whether or not the specified object
//              has any effects applied by a spell.
// Argument: oObject - the object to check for spell effects
// Returns: int - 1 if there are any spell effects applied to the object,
//          otherwise, 0.
//
///////////////////////////////////////////////////////////////////////////////
int GetHasAnySpellEffect( object oObject );


///////////////////////////////////////////////////////////////////////////////
// EffectArmorCheckPenaltyIncrease
///////////////////////////////////////////////////////////////////////////////
//
// Created By: Brock Heinz
// Created On: 08/16/2005
// Description: Increases the Armor Check Penalty for the targeted creature
//              For instance, wearing chain mail will incur a -5 armor check
//              penalty. To simulate this, pass in 5 as the penalty amount.
//              This penalty stacks with the creature's current armor and
//              shield penalty, and multiple instances of this effect can
//              be applied to a creature.
// Argument: oTarget - the object to add the penalty increase to
// Argument: nPenaltyAmt - The penalty to apply to the target
//              Note that this should be a *positive* number*
// Returns: effect - the newly created effect
//
///////////////////////////////////////////////////////////////////////////////
effect EffectArmorCheckPenaltyIncrease( object oTarget, int nPenaltyAmt );


///////////////////////////////////////////////////////////////////////////////
// EffectDisintegrate
///////////////////////////////////////////////////////////////////////////////
//
// Created By:  Brock Heinz
// Created On:  08/16/2005
// Description: This will run a special "Disintegrate" visual effect
//              on the target (which should be dead before calling this
//              function)
// Argument: oTarget - the target to add disintegrate effects to
// Returns: effect - the newly created disentegrate effect
//
///////////////////////////////////////////////////////////////////////////////
effect EffectDisintegrate( object oTarget );


///////////////////////////////////////////////////////////////////////////////
// EffectHealOnZeroHP
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz
// Created On:  09/02/2005
// Description: Creates a defered heal effect that is applied to the target
//              when it reaches or falls below zero hit points
// Argument: oTarget - the target to add disintegrate effects to
// Argument: nDamageToHeal - the amount of damage to heal on the target
// Returns: effect - the newly created effect
///////////////////////////////////////////////////////////////////////////////
effect EffectHealOnZeroHP( object oTarget, int nDmgToHeal );

///////////////////////////////////////////////////////////////////////////////
// EffectBreakEnchantment
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz
// Created On:  09/06/2005
// Description: Creates an effect which frees victims from enchantments,
//              transmutations, and curses.
// Argument: nLevel - the level of the caster
// Returns: effect - the newly created effect
///////////////////////////////////////////////////////////////////////////////
effect EffectBreakEnchantment( int nLevel );


//RWT-OEI 09/07/05
//This returns the first entering player object when called from an
//OnClientEnter script. Should never return INVALID_OBJECT unless
//called from a script other than an OnClientEnter script.
//To be used along with GetNextEnteringPC() to iterate over the
//list of entering PCs
object GetFirstEnteringPC();

//RWT-OEI 09/07/05
//This returns the next entering player object when called from an
//OnClientEnter script.  Will return INVALID_OBJECT when it has
//reached the end of the list. Intended to be used along with
//GetFirstEnteringPC() in order to iterate over the list of entering
//players.
object GetNextEnteringPC();

//RWT-OEI 09/12/05
//Adds a NPC to the global roster of NPCs available to be added to
//a player's party. Roster Name is a 10-character name used to reference
//that NPC in other Roster related functions.
//The template is the blueprint to use to create the NPC for the first
//time. The NPC will not appear in the game world, but will be in the
//Roster. Returns false on any error
int AddRosterMemberByTemplate( string sRosterName, string sTemplate );

//RWT-OEI 09/12/05
//Adds a NPC to the global roster of NPCs available to be added to
//a player's party. Roster Name is a 10-character name used to
//reference that NPC in other Roster related functions.
//The NPC will be left in the game world, but will now exist
//in the roster as well.
//Returns false on any error
int AddRosterMemberByCharacter( string sRosterName, object oCharacter );

//RWT-OEI 09/14/05
//Removes a NPC from the global roster of NPCs available to be added to
//a player's party.  Roster Name is the 'identifying name' that was given
//to this NPC when it was added to the Roster. Returns TRUE if the NPC
//was found and removed. False if the NPC was not found in the roster
int RemoveRosterMember( string sRosterName );

//RWT-OEI 09/14/05
//Returns TRUE if the member is available to be added to a party at this
//time. If the member is currently claimed by another party, it will
//not be available. If the member is set unselectable, it will
//not be available.
int GetIsRosterMemberAvailable( string sRosterName );

//RWT-OEI 09/14/05
//Returns TRUE if the member is selectable. This is different than
//available because it is possible for the NPC to -not- be in another
//party but still set to be not selectable (Due to plot reasons, etc.)
int GetIsRosterMemberSelectable( string sRosterName );

//RWT-OEI 09/14/05
//Sets the roster member as being selectable or not. Roster members
//that are not selectable cannot be changed via the Party Selection
//GUI on the client side, but can still be added/removed from a
//party via script. Note that if a roster member is set as non-selectable
//while they are currently in a party, they will remain in the party
//and cannot be removed via the Party Selection GUI.
//Returns FALSE if it was unable to locate the roster member
int SetIsRosterMemberSelectable( string sRosterName, int bSelectable );

//RWT-OEI 09/14/05
//Given a valid roster name, returns the OBJECT that that roster member
//is currently represented by in the world. If the roster name is not
//found or the creature is not currently loaded into the game, then
//the return value will be INVALID_OBJECT
object GetObjectFromRosterName( string sRosterName );

//RWT-OEI 09/14/05
//Given an object ID, returns the roster name that object has in the
//roster list, if that object is found in the roster list at all.
//If the object is not found, then the return value will be an empty
//string
string GetRosterNameFromObject( object oCreature );

//RWT-OEI 09/15/05
//Takes a roster name and script location and places an instance of the
//NPC there if possible.  If the NPC already exists somewhere in the
//module, it will move that NPC to the given location. If the NPC does
//not exist, it will spawn in a new instance of the NPC from the roster
//and place them at the given location. The return value is
//the object ID of the newly spawned NPC, or INVALID_OBJECT if there
//was some error encountered
object SpawnRosterMember( string sRosterName, location lLocation );

//RWT-OEI 09/15/05
//Despawn Roster Member
//This function removes the Roster Member from the game after saving them
//out so that any changes will be preserved.  This is the matching function
//to SpawnRosterMember() and in general should be the only script function
//used to remove Party Member NPCs from the game world.
int DespawnRosterMember( string sRosterName );

//RWT-OEI 09/15/05
//This function will add a Roster Member to the same party that the
//player character object passed in belongs to. Note that if the
//Roster Member is already in another party, this function will not
//work. They must be removed from the other party first. You can check
//for this condition with the GetIsRosterMemberAvailable() function.
//If the Roster Member is Available, then they can be added to the party.
//Also, if the RosterMember already exists somewhere in the module,
//the RosterMember will be warped to be near the player character. If
//the RosterMember does not exist yet, they will be loaded into the module
//exactly as they were when they were last saved out.
//Returns true on success
int AddRosterMemberToParty( string sRosterName, object oPC );

//RWT-OEI 09/19/05
//This function removes a roster member from the party. By default it
//will remove the NPC from the game world and save them out with their
//current state. If bDespawnNPC is FALSE, then the NPC will not be
//removed from the game world and their state will not be saved.
//Couple with DespawnRosterMember() if you need to remove the roster
//member from the area and save their current state
void RemoveRosterMemberFromParty( string sRosterName, object oPC, int bDespawnNPC=TRUE );

//RWT-OEI 09/19/05
//This gets the first roster member in the list. Roster members are
//sorted by the order that they were added to the roster.
//It is to be coupled with GetNextRosterMember() if one needs to
//iterate over the roster
//Returns an empty string if there are no roster members
//The string return value is the roster name of the first roster member.
string GetFirstRosterMember();

//RWT-OEI 09/19/05
//This gets the next roster member in the roster. Use GetFirstRosterMember()
//to reset the iterator. Returns an empty string if all the roster members
//have been retrieved via this function.
//The string value is the roster name of the first roster member, or
//an empty string.
string GetNextRosterMember();



// Brock H. - OEI 04/12/06
// Creates a projectile that uses effects values based on a spell.  This does not actually do damage or have any combat impact,
// it simply creates a visual effect.
// Use PROJECTILE_PATH_TYPE_DEFAULT to use the pathing values for that spell
void SpawnSpellProjectile( object oSource, object oTaget, location lSource, location lTarget, int nSpellID, int nProjectilePathType );


// Brock H. - OEI 04/12/06
// Creates a projectile that uses the models and effects for weapons. This does not actually do damage or have any combat impact,
// it simply creates a visual effect.
// Currently, the only damage type flags supported are Acid, Cold, Electrical, Fire, and Sonic.
// nBaseItemID - This is the row in the baseitemtypes.2DA that defines the launcher for this projectile. It is used to determine the ammunition type for the projectile
// nProjectilePathType - must be PROJECTILE_PATH_TYPE_* from above
// nAttackType - This must be OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, PARRIED, CRITICAL_HIT, or MISS
// nDamageTypeFlag - Used to attach a visual to the projectile. Supported types are DAMAGE_TYPE_ACID, COLD, ELECTRICAL, FIRE, DIVINE, SONIC
void SpawnItemProjectile( object oSource, object oTaget, location lSource, location lTarget, int nBaseItemID, int nProjectilePathType, int nAttackType, int nDamageTypeFlag );



///////////////////////////////////////////////////////////////////////////////
// GetIsOwnedByPlayer
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz - OEI
// Created On: 09/19/05
// Description: Checks to see if this creature is owned by a player
// Returns: TRUE if oCreature is owned by a player.
//          Note that if this creature is being controlled by the player, but is
//          not the player's original "owned" character, this will return
//          FALSE. You can check for control with GetIsPC()
///////////////////////////////////////////////////////////////////////////////
int GetIsOwnedByPlayer( object oCreature );

///////////////////////////////////////////////////////////////////////////////
// SetOwnersControlledCompanion
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  09/23/05
// Description: This will find the player controlling oCurrentCreature, and set
//              their currently controlled companion to oTargetCreature. If it
//              can’t find oTargetCreature, then the player is reassigned to
//              whoever their original, owned character is.
//
// Returns:     The object that is now being controlled. If oCurrentCreature
//              was not being controlled by a player, then this will return
//              OBJECT_INVALID
///////////////////////////////////////////////////////////////////////////////
object SetOwnersControlledCompanion( object oCurrentCreature, object oTargetCreature=OBJECT_INVALID );

///////////////////////////////////////////////////////////////////////////////
// SetCreatureScriptsToSet
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  09/23/05
// Modified:    12/19/05
// Description: Reassign all of the creature's scripts to a set specified by
//              the entry in the NWN2_ScriptSets.2DA file. If the creature
//              is not running his default scripts (for example, he is being
//              possessed by a DM), he won't start running the scripts from
//              the new set until he goes back to his default state
///////////////////////////////////////////////////////////////////////////////
void SetCreatureScriptsToSet( object oCreature, int nScriptSet );



// Brock H. - OEI 04/21/06
// This will calculate the length of time it will take for a projectile to
// to travel between the locations. If you specify PROJECTILE_PATH_TYPE_SPELL
// and a valid spell ID, it will look up the spell's projectile path type from
// the Spell 2DA
float GetProjectileTravelTime( location lSource, location lTarget, int nProjectilePathType, int nSpellID=-1 );


//RWT-OEI 09/29/05
//This command puts a limit on the number of Roster NPCS that can be
//added to a player's party via the Party Selection GUI.
//The default is always 3, unless changed via this script function
void SetRosterNPCPartyLimit( int nLimit );

//RWT-OEI 09/29/05
//This returns the current Roster NPC Party Limit. This limit is the
//number of Roster NPCs that can be added to a player's party via
//the Party Select screen. Note that AddRosterMemberToParty() is
//not limited by this value.
int GetRosterNPCPartyLimit();

//RWT-OEI 09/29/05
//This function flags a Roster Member as being a Campaign NPC
//Campaign NPCs are NPCs that are saved to the roster to make them
//persist across modules, but will not appear on the Roster Member
//Select Screen on clients as NPCs available for adding to the party.
//Note that scripts can still add and remove Campaign NPCs to the party,
//but the client will never be able to add them via the UI
//Returns false if it was unable to find the Roster Member to set them
//as a campaign NPC
int SetIsRosterMemberCampaignNPC( string sRosterName, int nCampaignNPC );

//RWT-OEI 09/29/05
//This function returns whether or not a valid roster member is set
//as a Campaign NPC.  See description of SetIsRosterMemberCampaignNPC
//for details on Campaign NPCs.
//Returns true or false, depending. False returned if unable to find the
//roster member
int GetIsRosterMemberCampaignNPC( string sRosterName );

//RWT-OEI 10/19/05
//This returns true if the object passed in is in fact a roster member.
//If they are a roster member, then they exist within the roster table
int GetIsRosterMember( object oMember );

//JAB-OEI 11/7/05
//This will pop-up the specified world map for the specified player.
//The tag argument is a string to specify what the current location is.
void ShowWorldMap( string sWorldMap, object oPlayer, string sTag);

//CMM-OEI 11/16/05
//Trigger an encounter
// - oObject: The object ID of the encounter to trigger.
// - oPlayer: The player to treat as the one who triggered the encounter.
// - iCRFlag: This parameter does nothing at this time (Wasn't fully implemented)
// - fCR: If this is -1.0, calculate the appropriate CR for the encounter based
//        on the players in the triggering faction that are nearby.
//        If anything other than -1.0, indicates the CR override that should
//        be used when triggering the encounter.
void TriggerEncounter(object oEncounter, object oPlayer, int iCRFlag, float fCR);

//CMM-OEI 11/28/05
//Simple pass through of GetIsSinglePlayer() call.
// returns true if this is a single player only game.
int GetIsSinglePlayer();

//RWT-OEI 12/08/05
//This function allows the script to display a GUI on the player's client.
//The first parameter is the object ID owned by the player you wish to
//display the GUI on.
//The second parameter is the name of the GUI screen to display. Note
//that only screens located in the [GuiScreen] section of ingamegui.ini
//will be accessible.
//The 3rd parameter indicates if the displayed GUI should be modal when
//it pops up.
//RWT-OEI 01/16/07 - Added 4th parameter. This defines the resource
//that should be used for this screen if the screenName is not already
//found in the ingamegui.ini or pregamegui.ini.  If left blank, then no
//gui will be loaded if the ScreenName doesn't already exist. If the
//sScreenName is *already* in use, then the 4th parameter will be ignored.
void DisplayGuiScreen( object oPlayer, string sScreenName, int bModal, string sFileName = "", int bOverrideOptions = FALSE);


// Brock H. - OEI 12/06/05
// If this is linked to another spell effect, and that spell
// gets removed from an EffectDispelMagic effect, then
// the aOnDispelEffect script will be called.
effect EffectOnDispel( float fDelay, action aOnDispelEffect );

// Shut down the currently loaded module and start a new one (moving all
// currently-connected players to the starting point. This one saves out the
// old module's state.
void LoadNewModule(string sModuleName, string sWaypoint = "");

//RWT-OEI 12/13/05
//This function sets a CREATURE as Script Hidden. Script Hidden creatures
//do not render, do not count for collision, and cannot be selected on
//the client side.  Removing this flag makes the creature render,
//selectable, collidable.
//If bHidden is TRUE, bDisableUI can be set to FALSE or TRUE to control
//whether or not the AI is disabled while the object is hidden.
//If bHidden is FALSE, bDisableUI doesn't do anything.
void SetScriptHidden( object oCreature, int bHidden, int bDisableUI=TRUE );



///////////////////////////////////////////////////////////////////////////////
// SetIsCompanionPossessionBlocked
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz - OEI
// Created On: 12/16/05
//
// Description: Sets a flag on the creature as to whether the player can possess it.
//  This can block the player from possessing the creature as a companion.
//  If the player is currently controlling this creature, he will be
//  forced to control his original, owned creature.
//  Note that this doesn't block out other types of possession (i.e. by a DM)
//  Also, you can't block the player from possing their owned creature.
//
// Arguments:
//  oCreature - The creature which you want to set the possession flag.
//              This creature doesn't need to currently be a companion,
//              but it CAN'T be a player owned character
//  bBlocked -  The state of the blocked flag (should be TRUE or FALSE)
///////////////////////////////////////////////////////////////////////////////
void SetIsCompanionPossessionBlocked( object oCreature, int bBlocked );


///////////////////////////////////////////////////////////////////////////////
// SetEventHandler
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz - OEI
// Created On: 12/20/05
//
// Description: These commands will allow you to bind any script to the
//              to an exisiting event for a given object.
// Arguments:
//  oObject -  The object to which you want to bind a new script
//  iEventID - The event ID which you are binding the script to.
//  sScriptName - The name of the script that you want to bind to the event.
//              Note that it is valid to pass "" to have this creature ignore
//              the event.
///////////////////////////////////////////////////////////////////////////////

void SetEventHandler( object oObject, int iEventID, string sScriptName );


///////////////////////////////////////////////////////////////////////////////
// GetEventHandler
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz - OEI
// Created On: 12/20/05
//
// Description: Retrieves the name of a script bound to a given event ID
// Arguments
//  oObject -  The object to which you want to bind a new script
//  iEventID - The event ID which you are binding the script to.
//
// Returns: Returns a string with the script name which the object has bound
//          to the event. This will be empty if the creature or event ID is
//          invalid.
///////////////////////////////////////////////////////////////////////////////
string GetEventHandler( object oObject, int iEventID );

//RWT-OEI 01/03/06
//This script function returns TRUE if the trigger object has the
//Party Transition flag set to TRUE.
int GetIsPartyTransition( object oObject );

//RWT-OEI 01/04/06
//This script function moves a party to an object in a new area.
//When a party is moved with this function, all players undergoing
//the area transition will remain on the loading screen until everyone
//changing area has finished loading the area on the client.
//The area's OnClientEnter event will fire once all of the party members
//have finished loading the new area
//NOTE: If the party is already in oDestination's area, the party will be
//jumped to oDestination without firing OnClientEnter. Party members that
//are uncommandable will still be jumped, but party members that are dead
//will not.
void JumpPartyToArea( object oPartyMember, object oDestination );

//RWT-OEI 01/04/06
//This script function returns the number of actions that are on the action
//queue of the object passed in
int GetNumActions( object oObject );

//RWT-OEI 01/05/06
//This script function displays a message box popup on the client of the
//player passed in as the first parameter.
//////
// oPC           - The player object of the player to show this message box to
// nMessageStrRef- The STRREF for the Message Box message.
// sMessage      - The text to display in the message box. Overrides anything
//               - indicated by the nMessageStrRef
// sOkCB         - The callback script to call if the user clicks OK, defaults
//               - to none. The script name MUST start with 'gui'
// sCancelCB     - The callback script to call if the user clicks Cancel, defaults
//               - to none. The script name MUST start with 'gui'
// bShowCancel   - If TRUE, Cancel Button will appear on the message box.
// sScreenName   - The GUI SCREEN NAME to use in place of the default message box.
//               - The default is SCREEN_MESSAGEBOX_DEFAULT
// nOkStrRef     - The STRREF to display in the OK button, defaults to OK
// sOkString     - The string to show in the OK button. Overrides anything that
//               - nOkStrRef indicates if it is not an empty string
// nCancelStrRef - The STRREF to dispaly in the Cancel button, defaults to Cancel.
// sCancelString - The string to display in the Cancel button. Overrides anything
//               - that nCancelStrRef indicates if it is anything besides empty string
void DisplayMessageBox( object oPC, int nMessageStrRef,
                        string sMessage, string sOkCB="",
                        string sCancelCB="", int bShowCancel=FALSE,
                        string sScreenName="",
                        int nOkStrRef=0, string sOkString="",
                        int nCancelStrRef=0, string sCancelString="" );

//RWT-OEI 01/06/06
//A simple C-Style string compare
//Returns 0 if the strings are the same
//Returns a negative value if string 1 is less than string 2
//Returns a positive value if string 1 is greater than string 2
int StringCompare( string sString1, string sString2, int nCaseSensitive=FALSE );

//RWT-OEI 01/06/06
//Takes the first character of sString and returns
//the numeric ASCII value for that character.
int CharToASCII( string sString );

//RWT-OEI 01/16/06
//Pass in the object id of an object being controlled by a player
//and this function will return that player's owned character,
//the character they connected to the game with. Otherwise
//returns OBJECT_INVALID
object GetOwnedCharacter( object oControlled );

//RWT-OEI 01/16/06
//Pass in the object id of an object and if that object is owned
//or actively controlled by a player, this function will return
//the object that the player is currently controlled. Otherwise,
//returns OBJECT_INVALID
object GetControlledCharacter( object oCreature );


///////////////////////////////////////////////////////////////////////////////
// FeatAdd
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  01/19/06
// Description: Adds a feat to the target creature. with an option to check or
//              bypass the feat's requirements
// Edited 09/30/2008 JWR-OEI
// Arguments:
//  oCreature           - The creature to which you want to add a feat
//  iFeatId             - The Feat ID which you want to add, from Feats.2DA
//  bCheckRequirements  - Whether or not the game should check to see if the
//                      creature meets the feat's prerequisites before adding
// bFeedback            - Whether or not to display feedback in chatlog
// bFeedback            - Whether or not to display "notice" text in center of
//                        the screen
// Returns: TRUE if the feat was added to the creature, otherwise, FALSE
///////////////////////////////////////////////////////////////////////////////
int FeatAdd( object oCreature, int iFeatId, int bCheckRequirements, int bFeedback=FALSE, int bNotice=FALSE );

///////////////////////////////////////////////////////////////////////////////
// FeatRemove
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz - OEI
// Created On: 01/19/06
// Description: Removes a feat from the target creature
// Arguments
//  oCreature   - The creature from which you want to remove the feat
//  iFeatId     - The Feat ID which you want to remove, from Feats.2DA
///////////////////////////////////////////////////////////////////////////////
void FeatRemove( object oCreature, int iFeatIds );

///////////////////////////////////////////////////////////////////////////////
// SetCanTalkToNonPlayerOwnedCreatures
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  01/25/06
// Description: Some objects have dialogs that are restricted to only
//              work with player OWNED creatures (aka player created
//              characters), while others may talk to any creature
// Arguments:
//  oObject           - The object (of any type) to which you want to set the flag
//  bCanTalk          - If TRUE, then they can talk to anybody.
//                      If FALSE, then they can only talk to players who are
//                      controlling their owned creature. If a player controlled,
//                      non-player owned creature tries to initiate dialog, he
//                      will be swapped to his owned creature. If a non-player
//                      controlled creature tries to initiate dialog, then
//                      the action fails
///////////////////////////////////////////////////////////////////////////////
void SetCanTalkToNonPlayerOwnedCreatures( object oObject, int bCanTalk );

///////////////////////////////////////////////////////////////////////////////
// GetCanTalkToNonPlayerOwnedCreatures
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  01/25/06
// Description: Some objects have dialogs that are restricted to only
//              work with player OWNED creatures (aka player created
//              characters), while others may talk to any creature
// Arguments:
//  oObject           - The object (of any type) to which you want to set the flag
// Returns:           - The state of the flag on this object. (See above)
///////////////////////////////////////////////////////////////////////////////
int GetCanTalkToNonPlayerOwnedCreatures( object oObject );


///////////////////////////////////////////////////////////////////////////////
// SetLevelUpPackage
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  01/31/06
// Description: Sets the Level-Up Package for this creature. It will
//              be used to determine what their recommended options are
//              during level-up.
// Arguments:
//  oCreature         - The creature to which you want to set the Level-Up
//                      package. Player OWNED creatures are not valid for
//                      this function
//  nPackage          - Corresponds to the row in the packages.2DA which should
//                      be used as the creature's new level-up package
///////////////////////////////////////////////////////////////////////////////
void SetLevelUpPackage( object oCreature, int nPackage );

///////////////////////////////////////////////////////////////////////////////
// GetLevelUpPackage
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  01/31/06
// Description: Retrives the Level-Up Package for this creature.
// Arguments:
//  oCreature         - The creature to which you want to set the Level-Up
//                      package.
// Returns:           - The row in the packages.2DA which corresponds to
//                      the creature's current level-up package
///////////////////////////////////////////////////////////////////////////////
int GetLevelUpPackage( object oCreature );


///////////////////////////////////////////////////////////////////////////////
// SetCombatOverrides / ClearCombatOverrides
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/02/06
// Description: This is a basic way to force a specific outcome during a
//              creature's combat round. This is primarily designed as a
//              cutscene aid, and is not intended for use on creatures
//              with whom the player can normally interact. Therefore, these
//              settings are not saved.
//              ClearCombatOverrides() should be called on the creature when
//              the cutscene is complete.
// Arguments:
// oCreature - The creature to set the overrides on.
// oTarget - This should be a creature, door, or placeable.
//      Passing in INVALID_OBJECT Will allow normal target selection to occur.
// nAttackResult - An attack can have one of many different outcomes.
//  You can force the attack results to be a specific outcome, or specify
//  "INVALID" to allow the normal attack rolls to occur.
// nOnHandAttacks, nOffHandAttacks
//  Creaturs must have a total of 1-6 attacks per round. Entering -1 for either of
//  these means that the default logic will be used to determine attacks per
//  round for that hand.
// nMinDamage, nMaxDamage
//  These are used to set the range for a random damage amount. For example,
//  (1,6) would mean that 1-6 points of damage would be done. These can be set
//  to the same value, and you can specify 0,0 for "no damage". Using -1 for
//  either of these means that the default damage calculations will be used.
// bSuppressBroadcastAOO -  If TRUE then this creature can potentially cause an
//  attack of opportunity from nearby creatures. If FALSE, this will be supressed
// bSuppressMakeAOO -  If TRUE then this creature will make attacks of
//  opportunity when they are available. If FALSE, this will be supressed
// bIgnoreTargetReaction -  Normally, ActionAttack() calls are rejected if they
//  are made on a hostile or neutral target. Setting this to TRUE
//  will bypass that check.
// bSuppressFeedbackText - If set to TRUE, this can be used to keep this
//  creature's combat round feedback from being displayed.
///////////////////////////////////////////////////////////////////////////////
void SetCombatOverrides( object oCreature, object oTarget, int nOnHandAttacks, int nOffHandAttacks, int nAttackResult, int nMinDamage, int nMaxDamage, int bSuppressBroadcastAOO, int bSuppressMakeAOO, int bIgnoreTargetReaction, int bSuppressFeedbackText );
void ClearCombatOverrides( object oCreature );


///////////////////////////////////////////////////////////////////////////////
// ResetCreatureLevelForXP
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  05/07/06
// Description: This command will set a creature back to level 0, and
//              award him experience the experience passed to the function.
//              s/he will then auto-level up to the highest level
//              allowed by the experience he has based on his current level-up
//              package.
// Arguments:
// oTargetCreature  - The creature to reset and auto-level
// nExperience      - The amount of experience to give the creature
// bUseXPMods       - If TRUE, then the creature's experience modifires will be
//                    applied before the experience is awarded.
///////////////////////////////////////////////////////////////////////////////
void ResetCreatureLevelForXP( object oTargetCreature, int nExperience, int bUseXPMods );


///////////////////////////////////////////////////////////////////////////////
// CalcPointAwayFromPoint
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/10/06
// Description: This will create a new point directly away from a starting
//              point
// Arguments:
//  lPoint              - The point you are starting from
//  lAwayFromPoint      - The point you want to generate a new location away from
//  fDistance           - How far away you want the new point to be. This can
//                          be a negative value. (i.e. to generate a point nearer
//                          or even past the away point
//  fAngularVariance    - This will add some randomness to the position of the
//                        new point. Values are in degrees, from 0 to 180
//  bComputeDistFromStart - If TRUE, then the new point is fDistance away from
//                          lPoint. If FALSE, then it is fDistance away from
//                          lAwayFromPoint.
// Returns: A location away from lAwayFromPoint based on the position of
//          lPoint. Note that if there is an error, lPoint is returned
///////////////////////////////////////////////////////////////////////////////
location CalcPointAwayFromPoint( location lPoint, location lAwayFromPoint, float fDistance, float fAngularVariance, int bComputeDistFromStart );


///////////////////////////////////////////////////////////////////////////////
// CalcSafeLocation
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/10/06
// Description: This will attempt to find a position that oCreature can stand in
// Arguments:
//  oCreature       - The creature to generate a safe location for
//  lTestPosition   - The position that you want to generate a safe location near
//  fSearchRadius   - How far away from lTestPosition to carry out the search
//  bWalkStraighLineRequired - If TRUE, then this will only return a position that
//                              can be pathed directly to by oCreature
//  bIgnoreTestPosition - If TRUE, then lTestPosition won't be considered
//                        as one of the possible nearby search locations
// Returns: A location that oCreature can stand in. If no location is found,
//          then it returns the creature's current location.
///////////////////////////////////////////////////////////////////////////////
location CalcSafeLocation( object oCreature, location lTestPosition, float fSearchRadius, int bWalkStraighLineRequired, int bIgnoreTestPosition );


///////////////////////////////////////////////////////////////////////////////
// GetTotalLevels
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/13/06
// Description: This will return the total level of the creature across all
//              classes. It returns 0 on error
///////////////////////////////////////////////////////////////////////////////
int GetTotalLevels( object oCreature, int bIncludeNegativeLevels );



///////////////////////////////////////////////////////////////////////////////
// GetTotalLevels
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/13/06
// Description: This will reset the cooldown time and/or the uses per day
//              of the given feat. Use FEAT_INVALID to reset all.
///////////////////////////////////////////////////////////////////////////////
void ResetFeatUses( object oCreature, int nFeatID, int bResetDailyUses, int bResetLastUseTime );

// Set the fog properties for oTarget.
// - oTarget: if this is GetModule(), all areas will be modified by the
//   fog settings. If it is an area, only that area will be modified.
// - nFogType: FOG_TYPE*
//   -> FOG_TYPE_SUN, FOG_TYPE_MOON, FOG_TYPE_BOTH
// - nColor: FOG_COLOR*
//   -> You can also pass in a hex RGB number that corresponds to the fog color.
// - fFogStart
//   -> The distance at which the fog starts.
// - fFogEnd
//   -> The distance at which the fog ends and is at its full color.
// - fFarClipPlaneDistance
//   -> The distance at which the world dissapears into the skybox.
// * Note that this function has changed in NWN2.
// * Note that you can use FOG_TYPE_BOTH for the nFogType parameters to set both the MOON and
//   SUN fog types.
void SetNWN2Fog( object oTarget, int nFogType, int nColor, float fFogStart, float fFogEnd);
void ResetNWN2Fog(object oTarget, int nFogType);


///////////////////////////////////////////////////////////////////////////////
// EffectBonusHitpoints
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/20/06
// Description: Creates an effect which increases the target's hitpoints.
//              Note that these are "permanent" (for the duration of the effect)
//              and can be healed back by all the normal means.
///////////////////////////////////////////////////////////////////////////////
effect EffectBonusHitpoints( int nHitpoints );

//RWT-OEI 02/23/06
//This function will set a GUI object as hidden or visible on a GUI panel on
//the client.
//The panel must be located within the [ScriptGUI] section of the ingamegui.ini
//in order to let this script function have any effect on it.
//Also, the panel must be in memory. Which means the panel should probably not have
//any idle expiration times set in the <UIScene> tag that would cause the panel to
//unload
void SetGUIObjectHidden( object oPlayer, string sScreenName, string sUIObjectName, int bHidden );

//RWT-OEI 02/23/06
//This function will close a specific GUI panel on the client.
//The panel must be located within the [ScriptGUI] section of the ingamegui.ini
//in order to let this script close it.
void CloseGUIScreen( object oPlayer, string sScreenName );

//RWT-OEI 02/23/06
//This function is for use in OnClientEnter scripts. It returns TRUE if the
//OnClientEnter script was fired because a party was moved into the area via
//the JumpPartyToArea script function.
//It returns false if OnClientEnter was fired from a single player being jumped
//into an area, a player logging into the area, or a normal, non-party transition.
//It is only valid during the execution of OnClientEnter, will return false
//at all other times.
int FiredFromPartyTransition();

//RWT-OEI 02/24/06
//This function returns TRUE if given a valid object ID that is script hidden
int GetScriptHidden( object oObject );

//RWT-OEI 02/25/06
//This script function returns the tag of the speaker for the actively evaluated
//dialog node.  It is only valid within CONDITIONAL scripts on dialog nodes
//within dialogs. It will return the tag of the speaker for that node if that node
//is going to be chosen. If it is a reply node (Player spoken node), the return
//value will be empty
string GetNodeSpeaker();

//RWT-OEI 03/28/06
//This function sets the string value of a local GUI variable on the client of
//the indicated player
void SetLocalGUIVariable( object oPlayer, string sScreenName, int nVarIndex, string sVarValue );



// Brock H. - OEI 03/29/06
void SetGUIObjectDisabled( object oPlayer, string sScreenName, string sUIObjectName, int bDisabled );


// Brock H. - OEI 03/29/06
// If StrRef is -1, then sText is used instead
// Passing in -1 and "" will clear the text
void SetGUIObjectText( object oPlayer, string sScreenName, string sUIObjectName, int nStrRef, string sText );



///////////////////////////////////////////////////////////////////////////////
// GetIsCompanionPossessionBlocked
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz - OEI
// Created On: 04/09/06
//  Returns the state of the possession blocked flag. See SetIsPossessionBlocked
//  for explanation.
///////////////////////////////////////////////////////////////////////////////
int GetIsCompanionPossessionBlocked( object oCreature );


// JLR-OEI 04/07/06
// Create a BardSong (Singing) effect
// - nSpellId:  The SpellId to match this song to
effect EffectBardSongSinging( int nSpellId );

// JLR-OEI 04/07/06
// Create a Jarring effect
effect EffectJarring();

// JLR-OEI 04/11/06
// Returns the value of the given integer in the given Effect
int GetEffectInteger( effect eTest, int nIdx );

// JLR-OEI 04/11/06
// Resets the durations for all effects from a given SpellId
void RefreshSpellEffectDurations( object oTarget, int nSpellId, float fDuration );

// JLR-OEI 04/11/06
// Sets the SpellId associated with a given effect and all effects chained to it
effect SetEffectSpellId( effect eTest, int nSpellId );

// JLR-OEI 04/12/06
// Creates a BaseAttackBonus Minimum effect
effect EffectBABMinimum( int nBABMin );

// JLR-OEI 04/12/06
// Returns the value of the given object's BaseAttackBonus (the Bonus, not the # of Attacks)
int GetTRUEBaseAttackBonus( object oTarget );

//Sets the first name of any valid target object
//valid objects are creatures, items, and placeables.
void SetFirstName(object oTarget, string sFirstName);

//Sets the last name of any valid target object
//valid objects are creatures, items, and placeables.
void SetLastName(object oTarget, string sLastName);

//Sets the description of any valid target object
//valid objects are creatures, items, and placeables.
void SetDescription(object oTarget, string sDescription);


//Gets the first name of any valid target object
//valid objects are creatures, items, and placeables.
string GetFirstName(object oTarget);
//Gets the last name of any valid target object
//valid objects are creatures, items, and placeables.
string GetLastName(object oTarget);
//Gets the description of any valid target object
//valid objects are creatures, items, and placeables.
string GetDescription(object oTarget);

//RWT-OEI 05/05/06
//Returns TRUE if the object passed in is in a conversation that
//is flagged as Multiplayer
int IsInMultiplayerConversation( object oObject );

// FAK - OEI 5/16/05
// Returns TRUE if it found an object to play a custom animation one
// oObject is the object to play the animation on
// sAnimationName is the name of the gr2 to play
// nLooping is 0 for one-off, 1 for loop
// fSpeed is the playback speed: 1.0 is default, < 0 is backwards
int PlayCustomAnimation( object oObject, string sAnimationName, int nLooping, float fSpeed = 1.0f );

// AFW-OEI 05/18/2006
// Create a Max Damage effect.  (Spell Scripts)
// The Max Damage effect has you roll maximum damage dice for all weapon-based attacks.
effect EffectMaxDamage();

//PEH-OEI 05/24/06
//This script function displays a text input box popup on the client of the
//player passed in as the first parameter.
//////
// oPC           - The player object of the player to show this message box to
// nMessageStrRef- The STRREF for the Message Box message.
// sMessage      - The text to display in the message box. Overrides anything
//               - indicated by the nMessageStrRef
// sOkCB         - The callback script to call if the user clicks OK, defaults
//               - to none. The script name MUST start with 'gui'
// sCancelCB     - The callback script to call if the user clicks Cancel, defaults
//               - to none. The script name MUST start with 'gui'
// bShowCancel   - If TRUE, Cancel Button will appear on the message box.
// sScreenName   - The GUI SCREEN NAME to use in place of the default message box.
//               - The default is SCREEN_STRINGINPUT_MESSAGEBOX
// nOkStrRef     - The STRREF to display in the OK button, defaults to OK
// sOkString     - The string to show in the OK button. Overrides anything that
//               - nOkStrRef indicates if it is not an empty string
// nCancelStrRef - The STRREF to dispaly in the Cancel button, defaults to Cancel.
// sCancelString - The string to display in the Cancel button. Overrides anything
//               - that nCancelStrRef indicates if it is anything besides empty string
// sDefaultString- The text that gets copied into the input area,
//               - used as a default answer
void DisplayInputBox( object oPC, int nMessageStrRef,
                        string sMessage, string sOkCB="",
                        string sCancelCB="", int bShowCancel=FALSE,
                        string sScreenName="",
                        int nOkStrRef=0, string sOkString="",
                        int nCancelStrRef=0, string sCancelString="",
                        string sDefaultString="", string sUnusedString="" );

// TWH - OEI 5/25/2006
// Returns TRUE if it found an object to set weapon visibilty on
// oObject is the object to set weapon visibility on
// nVisibile 0 for invisibile, 1 for visible, and 4 is default engine action
// nType is: 0 - weapon, 1 - helm, 2 - both
int SetWeaponVisibility( object oObject, int nVisibile, int nType=0 );


// TWH - OEI 6/28/2006
// This script function allows you to set a LookAt target via script -- it's
// mainly to fix cutscene lookat 'bugs', while it does add a nice bonus feature
// oObject is the object to set weapon visibility on
// vTarget is the place you want the creature object to look
// nType is reserved for future use
void SetLookAtTarget( object oObject, vector vTarget, int nType=0 );

//Retrieves the bump state of the specified creature (either BUMPSTATE_DEFAULT, BUMPSTATE_BUMPABLE, OR BUMPSTATE_UNBUMPABLE)
//oCreature - The creature you want to get the bumpstate of.
int GetBumpState(object oCreature);

//Sets the bump state of the specified creature (either BUMPSTATE_DEFAULT, BUMPSTATE_BUMPABLE, OR BUMPSTATE_UNBUMPABLE)
//oCreature - The creature you want to set the bumpstate of.
//int nBumpState - The new bumpstate of the creature
void SetBumpState(object oCreature, int nBumpState);

//RWT-OEI 08/24/06
//Returns TRUE if the game is running in OneParty mode.
int GetOnePartyMode();

//RWT-OEI 10/10/06
//Returns the object ID of the primary player. The primary player is the player who
//is hosting the game, i.e., they are running the client/server version of the game and
//participating in the game.
//This function will return invalid object if no primary player is found. It is possible
//to not have a primary player under many circumstances, such as:
//  hosting player is logged in as a DM - Will not be counted as a primary player
//  game is running on a dedicated server - No primary player possible
//  hosting player is still in character creation - Primary player not in the game yet
object GetPrimaryPlayer();

// AFW-OEI 10/19/2006
// Creates an effect that inhibits spells.  This modifies a character's Arcane Spell Failure,
// and stacks with armor/shield ASF.  It is ignored by classes & abilities (e.g. divine casters)
// that ignore ASF.
// Compare this with EffectSpellFailure, which incurs another spell failure check after the ASF check
// and cannot be mitigated.
// - nPercent - percent modifier to Arcane Spell Failure; is added (not multiplied) to existing ASF.
//      Total ASF (armor + shield + EffectArcaneSpellFailure) is clamped between 0 and 100.
//      This can be a negative number, which will reduce existing ASF.
effect EffectArcaneSpellFailure(int nPercent);

// Brock H. - OEI 10/19/06
// This will create a "blood" effect as if the creature has taken damage.
// oCreature -  The creature that the blood is spawned from. This will
//              creature's blood type will be looked up based on the
//              creature's appearance.
// bCritical -  This controls whether the blood being spawned is standard, or
//              mimics a "Critical Hit"
// oAttacker -  This represents the creature that would be damaging the target
//              creature, which may alter the trajectory of the particles.
//              OBJECT_INVALID can be used here.
void SpawnBloodHit( object oCreature, int bCriticalHit, object oAttacker );


// Brock H. - OEI 10/19/06
// GetFirstArea() is used to begin iterating over all of the objects in the module
object GetFirstArea();

// Brock H. - OEI 10/19/06
// GetNextArea() is used to iterate over successive areas in the module.
// It will return OBJECT_INVALID once it has passed the end of the list
object GetNextArea();

// AFW-OEI 10/24/2006:
// Returns the ARMOR_RANK_* (NONE, LIGHT, MEDIUM, HEAVY) of oItem.
// If the object is not an item, returns ARMOR_RANK_NONE.
int GetArmorRank(object oItem);

// AFW-OEI 10/24/2006:
// Returns the WEAPON_TYPE_* (NONE, PIERCING, BLUDGEONING, SLASHING, PIERCING_AND_SLASHING) of oItem.
// If the object is not an item, returns WEAPON_TYPE_NONE.
int GetWeaponType(object oItem);

// Brock H. - OEI 10/30/06
// If oCreature is controlled by a player, this will be the
// Object that the player has selected as their current target object.
// If the player has no target, or if oCreature is not player controlled,
// then the return value will be OBJECT_INVALID
object GetPlayerCurrentTarget( object oCreature );

// AFW-OEI 10/31/2006:
// Create a Wildshape effect.
// Right now the wildshape effect does nothing except note that the target is wildshaped;
// this is used for Natural Spell checking.  If you are creating a Druid polymorphing/wildshaping
// script, make sure you link this effect in so they can cast while in that form.
effect EffectWildshape();


// Brock H. - OEI 11/03/06
// Returns the current encumbrance state of the creature,
// as ENCUMBRANCE_STATE_* defined above.
// Will return ENCUMBRANCE_STATE_INVALID if oCreature
// is not a valid creature.
int GetEncumbranceState( object oCreature );

// Removes any records from a database that have been marked for deletion.
void PackCampaignDatabase(string sCampaignName);


// Brock H. - OEI 11/07/06
// This will permanantly unlink a door, so that it will no longer function as an area transition.
// This is nessisary if you wish to delete a door that is linked to another area.
void UnlinkDoor( object oDoor );


// Brock H. - OEI 11/07/06
// If oCreature is controlled by a player, this will be the
// creature that the player currently has up in the
// creature examine window.
// then the return value will be OBJECT_INVALID
object GetPlayerCreatureExamineTarget( object oCreature );

//RWT-OEI 01/29/07
//This function clears out the 2DA cache.  This means the next
//time a 2DA is queried, it will be loaded fresh from the disk.
//This only affects 2DAs that were cached because they were
//queried by script.
//RWT-OEI 02/19/07
//If the optional parameter is left empty, then all 2DAs will be cleared.
//Otherwise, the parameter can be used to specify which 2DA to clear.
void Clear2DACache(string s2DAName="");

//RWT-OEI 01/15/07
//The next 6 functions are for use by the NWN Extender by
//Ingmar Stieger (Papillon)
//If you are not using the NWN Extender, these script functions
//will do basically nothing.
int NWNXGetInt( string sPlugin, string sFunction, string sParam1, int nParam2 );
float NWNXGetFloat( string sPlugin, string sFunction, string sParam1, int nParam2 );
string NWNXGetString( string sPlugin, string sFunction, string sParam1, int nParam2 );
void NWNXSetInt( string sPlugin, string sFunction, string sParam1, int nParam2, int nValue );
void NWNXSetFloat( string sPlugin, string sFunction, string sParam1, int nParam2, float fValue );
void NWNXSetString( string sPlugin, string sFunction, string sParam1, int nParam2, string sValue );

// AFW-OEI 02/13/2007
// Returns an effect that adds an effect icon to a character portrait.
// * nEffectIconId comes from the effecticon.2da
effect EffectEffectIcon(int nEffectIconId);

//RWT-OEI 02/23/07
//This script function sets the position of a progress bar on a client's GUI.
//The progress can be a percentage between 0.0 and 1.0 (empty and full).
//In order for this script function to work, the UIScene that contains the
//progress bar must have a scriptloadable=true attribute in it.
void SetGUIProgressBarPosition( object oPlayer, string sScreenName, string sUIObjectName, float fPosition );

//RWT-OEI 02/23/07
//This script function sets the texture for a Icon, Button, or Frame.
//If the object is an icon, the texture is set as the icon's image.
//If the object is a frame, the texture is set as the frame's FILL texture
//If the object is a button that has a base frame, the texture is set
//as the BASE frame's FILL texture.
//If the object is a button that has no base frame, the texture is set
//as the UP state's FILL texture.
//Texture names should include the extention (*.tga for example).
//The UIScene that contains the UIObject must have a scriptloadable=true
//attribute in it.
void SetGUITexture( object oPlayer, string sScreenName, string sUIObjectName, string sTexture );

// AFW-OEI 02/26/2007
// Create a Rescue effect.  This is a placeholder effect so that the engine knows
// when you're in Rescue Mode.
// - nSpellId:  The SpellId to match Rescue effect to
effect EffectRescue( int nSpellId );

//RWT-OEI 03/02/07
//Convert a script integer to an 'object'
//Note that this doesn't guarentee that the 'object' is anything valid
object IntToObject( int nInt );

//RWT-OEI 03/02/07
//Convert an 'object' to an integer data type
int ObjectToInt( object oObj );

//RWT-OEI 03/12/07
//Convert a 'string' to an object data type.
//This does not guarentee that the 'object' is anything valid
object StringToObject( string sString );

// AFW-OEI 03/12/2007
// Returns whether or not a creature is a "spirit".  Defaults to FALSE if oCreature is not
// a valid creature object.  Returns TRUE if oCreature is a Fey or Elemental, or the
// SpiritOverride flag is set on the creature blueprint.  Fey and Elementals are always
// considered spirits, regardless of the state of the SpiritOverride flag.
// - oCreature: The creature object you are testing.
int GetIsSpirit( object oCreature );

// AFW-OEI 03/13/2007
// Create a Detect Spirits effect.
effect EffectDetectSpirits();

// AFW-OEI 03/19/2007
// Create an effect that forces all Damage Reduction on a creature to be ignored.
effect EffectDamageReductionNegated();

// AFW-OEI 03/19/2007
// Create an effect that forces all Concealment and Miss Chance effects on a creature to be ignored.
effect EffectConcealmentNegated();

//RWT-OEI 03/13/07
//Returns whether or not the item has the Infinite flag set to TRUE.  Items with the
//infinite flag set to TRUE will not run out when purchased at a store.
int GetInfiniteFlag( object oItem );

//RWT-OEI 03/14/07
//Returns the custom message shown by a door or placeable if a player tries to use
//the door or placeable without the appropriate key in their inventory
string GetKeyRequiredFeedbackMessage( object oObject );

//RWT-OEI 03/14/07
//Set the custom string to show if a player tries to use a door or placeable
//without the appropriate key in their inventory
// - oObject = The door or placeable to set the message on. If oObject is not a
//             door or placeable, nothing will happen
// - sFeedback = The feedback message to show.
void SetKeyRequiredFeedbackMessage( object oObject, string sFeedback );

//RWT-OEI 03/14/07
//This script function can be used to set the Infinite flag on items.
//If an item is flagged infinite, a store's supply of this item will not
//deplete as players purchase the item.
//If oItem is not an Item object, nothing will happen
void SetInfiniteFlag( object oItem, int bInfinite=TRUE );

//RWT-OEI 03/14/07
//This script function returns TRUE if the oItem is pickpocketable
//If oItem is not an Item or the flag is not set, returns FALSE.
int GetPickpocketableFlag( object oItem );

//RWT-OEI 03/14/07
//This can be used to set the Pickpocketable flag on an item.
//If oItem is not an Item, then nothing will happen
void SetPickpocketableFlag( object oItem, int bPickpocketable );

//RWT-OEI 03/14/07
//Returns true if oItem is a door, placeable, or trigger that is
//TRAPPED and the trap is ACTIVE.  If the object is trapped but
//the trap is in an inactive state (Via SetTrapActive) or if the
//object is not trapped at all, this will return FALSE
int GetTrapActive( object oObject );

//RWT-OEI 03/14/07
//Set the Will Saving Throw on a door or placeable. Doesn't work on
//any other game object type.
// - oObject: Door or Placeable to set the Will Saving throw for
// - nNewWillSave must be between 0 and 250
void SetWillSavingThrow( object oObject, int nNewWillSave );

//RWT-OEI 03/14/07
//Set the Reflex Saving Throw on a door or placeable. Doesn't work on
//any other game object type.
// - oObject: Door or Placeable to set the Reflex Saving throw for
// - nNewReflexSave must be between 0 and 250
void SetReflexSavingThrow( object oObject, int nNewReflexSave );

//RWT-OEI 03/14/07
//Set the Fortitude Saving Throw on a door or placeable. Doesn't work on
//any other game object type.
// - oObject: Door or Placeable to set the reflex saving throw for
// - nNewFortSave must be between 0 and 250
void SetFortitudeSavingThrow( object oObject, int nNewFortSave );

//RWT-OEI 03/14/07
//When set, the object cannot be opened unless the opener possesses the
//required key.  The key tag required can be set in the toolset or
//by the SetLockKeyTag() script function.
// - oObject = door or placeable
// - nKeyRequired = TRUE or FALSE
void SetLockKeyRequired( object oObject, int nKeyRequired=TRUE );

//RWT-OEI 03/14/07
//Set the key tag required to open the object. This is to be used
//on doors or placeables that have been set to require a key either
//in the toolset or via the SetLockKeyRequired() function.
// - oObject = Object to set the key tag on, door or placeable.
// - sNewKeyTag = Key tag required to open the locked object
void SetLockKeyTag( object oObject, string sKeyTag );

//RWT-OEI 03/14/07
//Set the Lock DC on the door or placeable
// - oObject = Door or Placeable object
// - nNewLockDC = Must be between 0 and 250
void SetLockLockDC( object oObject, int nNewLockDC );

//RWT-OEI 03/14/07
//Set the Unlock DC on the door or placeable
// - oObject = Door or Placeable object
// - nNewUnlockDC = Must be between 0 and 250
void SetLockUnlockDC( object oObject, int nNewLockDC );

//RWT-OEI 03/14/07
//Sets whether o rnot the door or placeable can be locked
// - oObject: Door or Placeable
// - nLockable: TRUE/FALSE
void SetLockLockable( object oObject, int nLockable=TRUE );

//RWT-OEI 03/14/07
//Set the hardness of a door or placeable object
// - nHardness: must be between 0 and 250.
// - oObject: Must be a door or placeable object
void SetHardness( int nHardness, object oObject );

//RWT-OEI 03/14/07
//Retrieve the hardness value for a door or placeable
//Returns 0 if the door or placeable has no hardness value,
//or if the oObject is not a door or placeable
int GetHardness( object oObject );

//RWT-OEI 03/14/07
//Get the XP scale set on this module
int GetModuleXPScale();

//RWT-OEI 03/14/07
//Set a new XP scale on this module. This change will persist through
//saves.
// nXPScale: The new scale must be between 0 and 200. The toolset default
//           is 10.
void SetModuleXPScale( int nXPScale );

//RWT-OEI 03/15/07
//Sets whether or not a trapped object can be detected.
// - oTrap: Must be placeable, trigger, or door.
// - nDetectable: TRUE/FALSE
// Note that setting a trapped object to be non-detectable
// will not make it disappear if it has already been
// detected.
void SetTrapDetectable( object oTrap, int nDetectable=TRUE );

//RWT-OEI 03/15/07
//Set the DC for detecting the trap on an object
// - oTrap: Must be a placeable, trigger, or door.
// - nDetectDC: must be between 0 and 250
void SetTrapDetectDC( object oTrap, int nDetectDC );

//RWT-OEI 03/15/07
//Set whether or not the trap within an object can be disarmed
// - oTrap: Must be a placeable, trigger, or door.
// - nDisarmable: TRUE/FALSE
void SetTrapDisarmable( object oTrap, int nDisarmable=TRUE );

//RWT-OEI 03/15/07
//Set the disarm DC for a trapped object
// - oTrap: Must be a placeable, trigger, or door.
// - nDisarmable: Must be between 0 and 250
void SetTrapDisarmDC( object oTrap, int nDisarmDC );

//RWT-OEI 03/15/07
//Set the tag of the key that will disarm the trapped object
// - oTrap: Must be a placeable, trigger, or door.
// - sKeyTag: Tag of the key that will disarm the trap
void SetTrapKeyTag( object oTrap, string sKeyTag );

//RWT-OEI 03/15/07
//Set whether or not the trap is a one-shot trap.
//If it is not one-shot, it will reset itself
//after firing
// - oTrap: Must be a placeable, trigger, or door.
// - nOneShot: TRUE/FALSE
void SetTrapOneShot( object oTrap, int nOneShot=TRUE );

//RWT-OEI 03/16/07
//Creates a square trap at the location specified.
// - nTrapType: The base type of trap (TRAP_BASE_TYPE_*)
// - lLocation: The location and orientation that the trap will be created at
// - fSize: The size of the trap, minimum of 1.0f
// - sTag: The tag of the trap being created
// - nFaction: The faction of the trap ( STANDARD_FACTION_* )
// - sOnDisarmScript: The OnDisarm scrip that will fire when the trap is disarmed
// -                  If empty, then no script will fire
// - sOnTrapTriggered: The OnTrapTriggered script that will fire when the trap is triggered
//                    If empty, the default script will fire for this type of trap
// - Returns the ID of the newly created trap if successful
object CreateTrapAtLocation( int nTrapType, location lLocation, float fSize=2.0f,
                             string sTag="", int nFaction=STANDARD_FACTION_HOSTILE,
                             string sOnDisarmScript="", string sOnTrapTriggeredScript="" );

//RWT-OEI 03/16/07
//Creates a trap on the Door or Placeable passed in.  The door or placeable must not
//already be trapped or this will do nothing
// - nTrapType: The base type of trap (TRAP_BASE_TYPE_*)
// - oObject: The object that the trap will be created on, must be door or placeable
// - nFaction: The faction of the trap ( STANDARD_FACTION_* )
// - sOnDisarmScript: The OnDisarm scrip that will fire when the trap is disarmed
// -                  If empty, then no script will fire
// - sOnTrapTriggered: The OnTrapTriggered script that will fire when the trap is triggered
//                    If empty, the default script will fire for this type of trap
void CreateTrapOnObject( int nTrapType, object oObject, int nFaction=STANDARD_FACTION_HOSTILE,
                         string sOnDisarmScript="",string sOnTrapTriggeredScript="" );

//RWT-OEI 03/26/07
//Gets the size of an area.
// - nAreaDimension: The dimension you are querying.
//   AREA_HEIGHT or AREA_WIDTH
// - oArea: The area you wish to get the size of. If
//          a non-area is passed in, will get the size
//          of the area that the object is in. If
//          no object is specified, will use the calling
//          object to look up the area
// Returns the number of the tiles that the area is wide/height
//      If it is unable to find the area, returns 0.
int GetAreaSize( int nAreaDimension, object oArea=OBJECT_INVALID );

//RWT-OEI 03/27/07
//Get if the recoverable flag is set on a trap. If it is FALSE,
//players will not be able to attempt to recover the trap
// - oTrap: Must be a door, placeable, or trigger.
// Returns: 1 if the recoverable flag is set. Returns 0 if the flag
//   is set, or the oTrap is not a valid trapped object.
int GetTrapRecoverable( object oTrap );

//RWT-OEI 03/27/07
//Set the Recoverable flag on a trap. If the recoverable flag is set
//to false, players will not be able to attempt to recover the trap.
// oTrap: Must be a door, placeable, or trigger
// nRecoverable = Whether or not the trap is recoverable by players.
//                Defaults to TRUE
void SetTrapRecoverable( object oTrap, int nRecoverable=TRUE );

//RWT-OEI 03/27/07
//Set a placeable as being useable, i.e., something the player can
//click on to interact with.
// oPlaceable: The placeable object to change the flag on. Does not
//             work on static placeables.
// nUseableFlag: Whether or not the placeable should be useable
void SetUseableFlag( object oPlaceable, int nUseableFlag );

//RWT-OEI 03/27/07
//Only valid when used within the OnClick event script for a
//placeable.
// returns the object of the player that clicked on the placeable
object GetPlaceableLastClickedBy();

//RWT-OEI 04/03/07
//Toggle whether or not water is being rendered in the specified
//area
// - oArea: The area to toggle the setting in
// - bRender: Whether or not to render the water in that area
void SetRenderWaterInArea( object oArea, int bRender );

// AFW-OEI 04/16/2007
// Create an Insanity effect; creatures with this effect on them
// will attack the nearest creature, friend or foe.
effect EffectInsane();

//RWT-OEI 04/19/07
// This script function will turn off a player's GUI, except for
// the FADE screen. Floating text will still be rendered.
// oPlayer - object ID of the player to turn off the GUI for
// bHide   - If TRUE, turns off the player's GUI, of false, shows
//           the player's GUI.
// Note that if the player hits ESC, their GUI will come back up.
void SetPlayerGUIHidden( object oPlayer, int bHidden );

//RWT-OEI 04/26/07
// This function returns the 'tag' of a map point. It is only
// valid from the SelectScript or ActionScripts or ConditionalScripts associated
// with various map points.
string GetSelectedMapPointTag();

//RWT-OEI 04/30/07
// This sends a text string to the player that will appear
// on the player's screen inside their Notice Window GUI.
// A notice window can be any text field that has
// the UIText_OnUpdate_DisplayNoticeText() callback running
// on it.
// oPlayer - The player to send the notice message to.
// sMessage - The text to display. Cannot be an empty
//            string.
void SetNoticeText( object oPlayer, string sText );

//RWT-OEI 05/09/07
//Turn a light on and off
// oLight - Object ID of the light to toggle
// bActive - Whether or not the light is active
void SetLightActive( object oLight, int bActive );

// Create a Summon Copy effect.  The creature is copied and placed into the
// caller's party/faction.  Plot, immortal, and DM creatures cannot be be copied.
// All spells per day/memorized spells are cleared.
// - oSource: Source creature to be copied.
// - nVisualEffectId: VFX_*
// - fDelaySeconds: There can be delay between the visual effect being played, and the
//   creature being added to the area.
// - sNewTag: If you are copying a creature (nCopyCreature = TRUE), you can assign it a new tag, otherwise
//   it is assigned the same tag as the source creature.  This argument has no effect for a regular, non-copy
//   summon.
// - nNewHP: The starting HP of the creature you're copying.  Has no effect if you're not copying a creature.
//   If less than or equal to 0, then the copy will have as many HP as the target.
// - sScript: name of a script to be executed by the new copy; this allows you to buff the copy as it appears.
effect EffectSummonCopy(object oSource, int nVisualEffectId=VFX_NONE, float fDelaySeconds=0.0f, string sNewTag="", int nNewHP=0, string sScript="");

//AFW-OEI 07/12/2007
//Get if the polymorph locked flag is set on a creature.
// - oCreature: Must be a creature.
// Returns: 1 if the polymorph locked flag is set. Returns 0 if the flag
//   is not set, or the oCreature is not a valid creature object.
int GetPolymorphLocked(object oCreature);

//RWT-OEI 07/12/07
//Change the soundset for a creature
// - oCreature: Must be a creature
// - nSoundSet: row from the soundset 2DA for this creature to use
void SetSoundSet( object oCreature, int nSoundSet );

//RWT-OEI 01/14/08
//Change the scale of an object. This doesn't apply a scale effect like
//the EffectSetScale function is used for, but rather changes the base
//scale of the target. If the target object has any SetScale effects
//on it, the end result is likely to be different than the values set
//with this.
// - oObject - Must be creature or placeable.
// - fX, fY, fZ - The 3 scales to set
void SetScale( object oObject, float fX, float fY, float fZ );

//RWT-OEI 01/14/08
//Get the scale of the object based on which axis is looked up.
//Does not take into account any EffectSetScale effects that might
//be altering the scale of the object.
// - oObject - Must be creature or placeable
// - nAxis: Use SCALE_X, SCALE_Y, SCALE_Z
float GetScale( object oObject, int nAxis );

//RWT-OEI 01/18/08
//Return the # of rows in a 2DA. Returns -1 if the 2DA couldn't be found.
//This function will result in the 2DA being cached if it wasn't already
// s2DAName - The name of the 2DA
int GetNum2DARows( string s2DAName );

//RWT-OEI 01/18/08
//Return the # of columns in a 2DA. Returns -1 if the 2DA couldn't be found.
//This function will result in the 2DA being cahced if it wasn't already.
int GetNum2DAColumns( string s2DAName );

//RWT-OEI 02/27/08
//Sets a custom heartbeat interval on a creature or placeable.
//Note that speeding up the heartbeat rate on a lot of objects will impact
//performance. Also, in the case of creatures, there is still a random
//modifier of up to 1 second added to the heartbeat interval, so it
//won't be a precise interval.
// oTarget - creature or placeable
// nMSeconds - Number of milliseconds. 1000 = 1 second
void SetCustomHeartbeat( object oTarget, int nMSeconds );

//RWT-OEI 02/27/08
//Retrieve the custom heartbeat rate that was set via SetCustomHeartbeat.
//By default, is 0.
// oTarget - creature or placeable
// nMSeconds - Number of milliseconds. 1000 = 1 second
int GetCustomHeartbeat( object oTarget );

//RWT-OEI 03/06/08
//Sets the scroll bar ranges on a specified scrollbar on a specified
//screen. Passing -1 will cause that attribute to be left as-is rather
//than being changed.
//In order to work, the screen that contains the scroll bar must have
//the ScriptLoadable=true attribute in the <UIScene> tag.
// oPlayer - Player who's GUI needs to be modified.
// sScreenName - GUI Name of the scene that contains the scroll bar
// sScrollBarName - Name of the scroll bar to change the parameters for
// nMinSize, nMaxSize - These control how many 'ticks' there are in the
//                      scroll bar. Leave -1 to not change.
// nMinValue, nMaxValue - These control what the percentages of the
//                        scroll bar actually represent in terms of
//                        value.
void SetScrollBarRanges( object oPlayer, string sScreenName, string sScrollBarName, int nMinSize, int nMaxSize, int nMinValue, int nMaxValue );

//RWT-OEI 03/11/08
//Clear a listbox on the client's GUI.
// oPlayer - Player Object to send the clear message to.
// sScreenName - Name of the screen that contains the listbox.
// sListBox - Name of the listbox to clear
//As with other GUI modifying script functions, the GUI must be scriptloadable.
void ClearListBox( object oPlayer, string sScreenName, string sListBox );

//RWT-OEI 03/11/08
//Add a row to a listbox on a client's GUI
// oPlayer - Player Object to send the new row to
// sScreenName - Name of the screen that contains the listbox
// sListBox - Name of the listbox to add the row to
// sRowName - Name to give the new row
// sTextFields - List of text fields and text values to populate the row
// sTextures - List of texture objects and texture names to populate the row
// sVariables - List of variable indexes and variable values
// sHideUnHide - List of objects to hide or set unhidden
//The syntax for the text fields, textures, variables, and hide/unhide list is:
//<name of UI Object>=<value>, except in the case of variables where it is <index>=<value>
//Multiple entries are seperated by ; marks.
//And in order to affect the root level of the row itself, simply make an entry that starts with the = sign.
//For example, for setting text field contents, some options might be:
//  sTextFields = "textfield1=Row One Text1;textfield2=Row One Text2";//This will make it so the text field named 'textfield1'
//                will say 'Row One Text1' and the text field in that row named 'textfield2' will say 'Row One Text2'.
//  sTextFields = "=Row Text" will make the row itself (assuming it can display text) say 'Row Text'.
void AddListBoxRow( object oPlayer, string sScreenName, string sListBox, string sRowName, string sTextFields, string sTextures, string sVariables, string sHideUnhide );

//RWT-OEI 03/12/08
//Remove a row from a listbox by its name
// oPlayer - Player object to send the message to
// sScreenName - Name of the screen to find the listbox on
// sListBox - Name of the listbox to remove the row from
// sRowName - Name of the row to lookup and remove
void RemoveListBoxRow( object oPlayer, string sScreenName, string sListBox, string sRowName );

//RWT-OEI 03/26/08
//Retrieve the ItemPropActivationPreference on an item.
// oItem - Must be the object ID of an item
// The return value is 0, 1, or 2, corresponding to:
//     0 - Equipped Only
//     1 - Repository Only
//     2 - Equipped or Repository
int GetItemPropActivation( object oItem );

//RWT-OEI 03/26/08
//Set the ItemPropActivationPreference on an item.
// oItem - Must be the object ID of an item
// nPref - Must be 0, 1, or 2. See GetItemPropActivation for notes on which values correspond to which setting.
void SetItemPropActivation( object oItem, int nPref );

//RWT-OEI 04/09/08
//Modify a row in a listbox on a client's GUI
// oPlayer - Player Object to send the new row to
// sScreenName - Name of the screen that contains the listbox
// sListBox - Name of the listbox to find the row in
// sRowName - Name of the row to modify
// sTextFields - List of text fields and text values to populate the row
// sTextures - List of texture objects and texture names to populate the row
// sVariables - List of variable indexes and variable values
// sHideUnHide - List of objects to hide or set unhidden
//The syntax for the text fields, textures, variables, and hide/unhide list is:
//<name of UI Object>=<value>, except in the case of variables where it is <index>=<value>
//Multiple entries are seperated by ; marks.
//And in order to affect the root level of the row itself, simply make an entry that starts with the = sign.
//For example, for setting text field contents, some options might be:
//  sTextFields = "textfield1=Row One Text1;textfield2=Row One Text2";//This will make it so the text field named 'textfield1'
//                will say 'Row One Text1' and the text field in that row named 'textfield2' will say 'Row One Text2'.
//  sTextFields = "=Row Text" will make the row itself (assuming it can display text) say 'Row Text'.
void ModifyListBoxRow( object oPlayer, string sScreenName, string sListBox, string sRowName, string sTextFields, string sTextures, string sVariables, string sHideUnhide );

//RWT-OEI 04/17/08
//Set the leader of a faction or party.
//Note that the object because the leader of whatever faction they are in.
// oNewLeader - Must be a creature.
void SetFactionLeader( object oNewLeader );


//RWT-OEI 04/17/08
//Given an area ID and a position in that area, returns the first sub-area that is found at that position.
//SubAreas are triggers, AoEEffectObjects, and Encounters.
//Use with GetNextSubArea() to iterate over all the sub-areas at this position.
// oArea = The area to search
// vPosition = The position to evaluate for sub areas.
object GetFirstSubArea( object oArea, vector vPosition );

//RWT-OEI 04/17/08
//Given an area ID, returns the next subarea to be found at the position specified when GetFirstSubArea()
//was called. It is necessary to call GetFirstSubArea() before calling this function in order to get
//any results back.
// oArea = The area to return the next SubArea from.
object GetNextSubArea( object oArea );

//RWT-OEI 04/22/08
//Given a valid creature object ID, returns the movementratefactor on this creature.
//The movementratefactor is applied to the creature's movement speeds. It is modified by things
//such as effects, encumberance, etc.
float GetMovementRateFactor( object oCreature );

//RWT-OEI 04/22/08
//Given a valid creature ID and a new movement factor, sets the creature's movement factor to
//that value. This movement factor is also modified by effects, encumberance, etc.
void SetMovementRateFactor( object oCreature, float fFactor );

//JWR-OEI 4/22/08
// Returns the BIC filename for player characters.
// Used for servervault characters only.
string GetBicFileName( object oPC );

// JWR-OEI 04/28/08
// returns the collision boolean for an object
int GetCollision(object oTarget);

//JWR-OEI 04/28/08
// sets the collision boolean for an object
// only works for creature type objects
void SetCollision(object oTarget, int bCollision);

// JWR-OEI 05/01/08
// Returns an item's IconRef
// as an int (2da row number)
int GetItemIcon(object oTarget);

// JWR-OEI 05/01/08
// Returns a Local Variable's name from an object
// at position nPosition. Empty string is returned
// if points to an invalid variable
string GetVariableName(object oTarget, int nPosition);

// JWR-OEI 05/01/08
// Returns a Local Variable's type from an object
// at position nPosition. -1 is returned if points to invalid
// variable
// the returned value is one of the VARIABLE_TYPE_* values.
int GetVariableType(object oTarget, int nPosition);

// JWR-OEI
// Return duration type for the AOE Object
int GetAreaOfEffectDuration( object oAreaOfEffectObject=OBJECT_SELF );

//RWT-OEI 07/08/08
// Characters created through the party creation mechanics
// are stored in the Roster system but are flagged as
// PlayerCreated to distinguish them from normal Roster
// contained NPCs. Note that if the character is not
// in the roster /at all/, this function returns false.
// This script function can query that flag.
// oCreature - object id of a creature to check
int GetIsPlayerCreated( object oCreature );


//AWD-OEI
//returns the party name
string GetPartyName();

//AWD-OEI
//returns the party motto
string GetPartyMotto();

//AWD-OEI
//returns non zero if the passed in area is a overland map
int GetIsOverlandMap(object oArea);

//AWD-OEI
//calling this function on a Creature will allow that creature
//to level up without restrictions set in it's package.
int SetUnrestrictedLevelUp(object oCreature);

//RWT-OEI 09/03/08
//Returns the duration of a sound file in milliseconds
// sSound - Name of the sound file. No extention.
//Returns 0 if the sound file was not found
int GetSoundFileDuration( string sSoundFile );

//AWD-OEI
//Returns the campaign flag PartyMembersDying
int GetPartyMembersDyingFlag();

//RWT-OEI 09/18/08
//Sets the indicated listbox row as being selected.
// oPlayer - Player Object to send the new row to
// sScreenName - Name of the screen that contains the listbox
// sListBox - Name of the listbox to find the row in
// sRowName - Name of the row to select
void SetListBoxRowSelected( object oPlayer, string sScreenName, string sListBox, string sRowName );

//RWT-OEI 09/18/08
//Returns a constant that represents the language that the talk table being used is in.
//The constants are LANGUAGE_*
int GetTalkTableLanguage();

//RWT-OEI 10/06/08
//Sets the scroll bar value on a specified scrollbar on a specified
//screen.
//In order to work, the screen that contains the scroll bar must have
//the ScriptLoadable=true attribute in the <UIScene> tag.
// oPlayer - Player who's GUI needs to be modified.
// sScreenName - GUI Name of the scene that contains the scroll bar
// sScrollBarName - Name of the scroll bar to change the parameters for
// nValue - The value to set the scrollbar to.
void SetScrollBarValue( object oPlayer, string sScreenName, string sScrollBarName, int nValue );

//RWT-OEI 10/06/08
//Set the pause state for the game
//Note that clients can toggle this state if the server is set to allow players to pause th game.
// bState = TRUE to pause, FALSE to unpause
void SetPause( int bState );

//RWT-OEI 10/06/08
//Returns the current pause state of the server. True if the game is paused, false otherwise.
int GetPause();

// JWR-OEI 10/15/2008
// Gets the SpellID responsible for the AOE Object
int GetAreaOfEffectSpellId( object oAreaOfEffectObject=OBJECT_SELF );

// MAP 8/08/2008
// Sets global GUI variable, available to all UI screens as global:x
// This can also be used to work with the new UI callback
// UIRadialNode_OnInit_TestGlobalVar, which allows you to display/hide radial nodes
// based on global variable values.
//
// oPlayer - player whose GUI will have the variable
// nVarIndex - variable index, from 100 - 400 (values outside of this range will be ignored)
// sVarValue - the value to set.
void SetGlobalGUIVariable( object oPlayer, int nVarIndex, string sVarValue );


// MAP 2/14/2009
// EXPERIMENTAL
// Creates a new area based on an existing area.  The new area is loaded from
// disk (so created/destroyed contetns in the original area will not be duplicated)
// however the walkmesh is shared with the existing area to reduce
// lag during load time, as well as to keep memory consumption lower.
object CreateInstancedAreaFromSource(object oArea);


// MAP 3/05/2009
// Get the value of a local int stored at the index provided.  0 if no var is present.
int GetVariableValueInt(object oObject, int nIndex);

// MAP 3/05/2009
// Get the value of a local string stored at the index provided.
// Empty string if no var is present there.
string GetVariableValueString(object oObject, int nIndex);

// MAP 3/05/2009
// Get the value of a local float stored at the index provided.
// 0.00 if no var is present there.
float  GetVariableValueFloat(object oObject, int nIndex);

// MAP 3/05/2009
// Get the value of a local location stored at the index provided.
// Invalid location  no var is present there.
location GetVariableValueLocation(object oObject, int nIndex);

// MAP 3/05/2009
// Get the value of a local object stored at the index provided.
// OBJECT_INVALID if no var is present there.
object GetVariableValueObject(object oObject, int nIndex);

// MAP 3/05/2009
// Get the number of local variables stored on this object.
int GetVariableCount(object oObject);

// MAP 3/15/2009
// !EXPERIMENTAL
// Note that any changes to skill rank will NOT be lost if the character is de-leveled.
// IMPORTANT: Most usages of this will cause characters to fail 'enforce legal character' restrictions.
void SetBaseAbilityScore(object oCreature, int nAbilityType, int nScore);

// MAP 3/15/2009
// !EXPERIMENTAL
// set bTrackWithLevel = TRUE if you wish for the skill change to be associated with
// the character's level.  In other words, should the character lose the skill change
// if they lose their current level?
// IMPORTANT: Most usages of this will cause characters to fail 'enforce legal character' restrictions.
void SetBaseSkillRank(object oCreature, int nSkill, int nRank, int bTrackWithLevel = TRUE);

// MAP 3/15/2009
// This function is used to send a chat message, as if spoken by a PC or by the server.
// Except for 'CHAT_MODE_SERVER', oSender must be a PC or nothing will occur.
// oSpeaker - the PC who will speak, OBJECT_INVALID if channel is CHAT_MODE_SERVER. This must be a valid PC object for CHAT_MODE_PARTY to work.
// oReceiver - if nChannel is CHAT_MODE_TELL or CHAT_MODE_SERVER, then this must be the PC who will be receiving the message.
// nMode - CHAT_MODE const indicating the type of message to be sent. Only the CHAT_MODE_* values provided are accepted.
// sMessage - actual message text
// bInvokeCallback = the module's OnChat script will be invoked to filter this message, if this is TRUE.
//   WARNING: use extreme caution if setting bInvokeCallback to TRUE  from within the OnChat handler itself --
//            this could lead to an infinite loop and hang your module!
void SendChatMessage(object oSender, object oReceiver, int nChannel, string sMessage, int bInvokeCallback = FALSE);

// MAP 3/24/2009
// Returns TRUE if the location is a valid, walkable location.
int GetIsLocationValid(location lLocation);

// MAP 3/24/2009
// Returns a bitmask composed of 0 or more SM_* values.
int GetSurfaceMaterialsAtLocation(location lLocation);

// MAP 3/24/2009
// Returns if the spell is known to this creature under any class or level.
int GetSpellKnown(object oCreature, int nSpell) ;

// MAP 3/24/2009
// returns the prp_materials.2da row index for the  base material type of the item specified.
int GetItemBaseMaterialType(object oItem);

// MAP 3/24/2009
// Set the base material type of oItem to nmaterialType, which must refer to a valid
// iprp_materials.2da row.
void SetItemBaseMaterialType(object oItem, int nMaterialType);


// MAP 3/24/2009
// EXPERIMENTAL- USE AT YOUR OWN RISK!   This one can break a character pretty badly if mis-used.
// This function sets whether a given spell is known or not by a creature
// Spells cannot be added in excess of spellgain rules for classes that have spell gain restrictions.
// oCreature - spellcasting creature
// nClassPosition - which class (0-3)? If creature does not have a class in that position, this function does nothing.
// nSpell - which spell?
// bKnown - if TRUE the spell is added to the class specified; if FALSE it is removed if it is in the class  specified,
//          assuming that the class is not one which knows all spells by default (cleric, et al)
// bTrackWithLevel - attach the spell gain/loss to the character's currnet level.  If the level is removed, the change is undone.
// NOTES
// IMPORTANT: Most usages of this will cause characters to fail 'enforce legal character' restrictions.
void SetSpellKnown(object oCreature, int nClassPosition, int nSpell, int bKnown = TRUE, int bTrackWithLevel = TRUE);


// MAP 3/27/2009
// returns the number of creatures in limbo. Not all creatures are
// guaranteed to be valid objects.
int GetLimboCreatureCount();

// MAP 3/27/2009
// Get a creature from limbo by 0-based position .  Check the results of this function
// with GetIsObjectValid; do not use a comparison to OBJECT_INVALID.
// Note that if an invalid creature is returned in any position, that
// does not mean that there are no more creatures, only that the creature in the position
// provided is not valid.
// To remove a creature from limbo, use ActionJumpToLocation on the returned object.
// Note that this will not change the number of creatures in limbo until after
// script execution completed.
// Finally, note that at this time creatures cannot be recalled from Limbo via scripting
object GetCreatureInLimbo(int nTh = 0);

// MAP 3/27/2009
// Sends oCreature to limbo.  Only works on creatures.  Effective after the script execution completes,
// the creature can be considered "Limboed".  Will not work on PCs, DMs,  or familiars.

void SendCreatureToLimbo(object oCreature);

// MAP 3/27/2009
// Add an int parameter to be used in ExecuteScriptEnhanced; this can used to execute
// parameterized scripts.
void AddScriptParameterInt(int nParam);

// MAP 3/27/2009
// Add astring  parameter to be used in ExecuteScriptEnhanced; this can used to execute
// parameterized scripts.
void AddScriptParameterString(string sParam);

// MAP 3/27/2009
// Add a float parameter to be used in ExecuteScriptEnhanced; this can used to execute
// parameterized scripts.
void AddScriptParameterFloat(float fParam);

// MAP 3/27/2009
// Add an object parameter to be used in ExecuteScriptEnhanced; this can used to execute
// parameterized scripts.
void AddScriptParameterObject(object oParam);

// MAP 3/27/2009
// Make oTarget run sScript and then return execution to the calling script.
// This function supports adding script parameters with
// the AddScriptParameter* functions, as well as execution of conditional scripts.
// If script execution fails for any reason, this returns -1
// If executing a non-conditional script, this returns 1 on successful execution.
// If executing a conditional script, this returns the return value of the conditional.
// If bClearParams is true, any script params previously added with AddScriptParameter*
// will be removed.
int  ExecuteScriptEnhanced(string sScript, object oTarget, int bClearParams = TRUE);

// MAP 3/27/2009
// Script parameters added with the  AddScriptParameter* functions will be kept until:
//  - This function (ClearScriptPArams) is invoked
//  - ExecuteScriptEx is invoked
//  - The module / server is restarted.
void  ClearScriptParams();

// MAP 3/27/2009
// Sets the number of rermaining skill points that
// a PC has available at next level up.
// CAUTION:
// if you give too many, you can prevent a PC from leveling up
// if they are not able to 'spend' all of them legally.
void SetSkillPointsRemaining(object oPC, int nPoints);

// MAP 3/27/2009
// Gets the number of remaining skill points
// that a PC has available at next level up.
int GetSkillPointsRemaining(object oPC);

// MAP 3/27/2009
// Returns SPELL_SCHOOL const for an arcane caster.
int GetCasterClassSpellSchool(object oPC, int nClassPos);

// MAP 3/27/2009
// Change a creature's gender.  Note that if this is a PC, they must exit the module
// and re-enter to see the change. If this is an NPC, they must leave and re-enter the area.
// nGender - GENDER_MALE or GENDER_FEMALE.  Other values will have unknown effect.
void SetGender(object oCreature, int nGender);

// MAP 3/28/2009
// Changes or sets the creatures tag. Tag must be non-blank but
// can contain any alphanumeric value. Works on PCs.
// Maximum tag length of 64.
void SetTag(object oObject, string sNewTag);

// MAP 3/28/2009
// Returns the armorrulesstats.2da row used by this armor.
// oItem is not armor, or is invalid, returns 0.
int GetArmorRulesType(object oItem);

// MAP 3/28/2009
// Sets the armorrulesstats.2da row used by this armor.
// oItem is not armor, or is invalid nothing happens.
// Note that ht echaracter sheet/inventory sheet will not be updated
// with changed info until the armor is unequipped and re-equipped.
void SetArmorRulesType(object oItem, int nType);

// MAP 3/28/2009
// Sets the item icon to specified itemicon 2da row.
// Nothing happens if oItem is not valid.  To see the change,
// you may have to wait until changing areas.
// Results undefined if nIcon is not a valid icon row.
// Note that players will not see the changed icon until they transition areas
// if the item is in their inventory.
void SetItemIcon(object oItem, int nIcon);

// MAP 3/28/2009
// Efficient search for finding an object of a given tag and type combination.
// nObjectType must be a proper OBJECT_TYPE const.
// Returns OBJECT_INVALID if no match is found.
object GetObjectByTagAndType(string sTag, int nObjectType, int nTh);


// MAP 6/1/2009
// Recall a creature from Limbo. Creature must be in limbo,
// and must be a creature.
void RecallCreatureFromLimboToLocation(object oCreature, location loc);


