////////////////////////////////////////////////////////////////////////////////
// Wand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// HOTBAR
const string WAND_VFX 				= "Gestione VFX";
const string WAND_AMB_SOUDS 		= "Gestione Suoni Ambientali";
const string WAND_LOC_SOUDS 		= "Gestione Suoni Localizzati";
const string WAND_MUSICS 			= "Gestione Musiche";
const string WAND_DICE 				= "Dadi";
const string WAND_VOICE_WIDGET 		= "Strumento Voce";
const string WAND_FOLLOW 			= "Segui";
const string WAND_INVENTORY_MANAGER = "Gestione Inventario";
const string WAND_LOC_VAR_MANAGER 	= "Gestione Variabili Locali";

// LOCAL_VAR_REPOSITORY
//const string LANG_UNABLE_SUBJECT 	= "Il personaggio non è in grado di eseguire questa azione.";
const string WAND_NO_SPAM 			= "Non sei autorizzato ad effettuare questa operazione.";
const string WAND_WRONG_VALUES 		= "I dati inseriti non sono corretti!";
const string WAND_ALREADY_EXISTING	= "La variabile inserita è già presente!";
const string WAND_NEW_VAR_NAME		= "<Nome Variabile>";
const string WAND_UI_LV_TITLE		= "Variabili Locali"; 
const string WAND_UI_LV_ACCEPT		= "OK";
const string WAND_UI_LV_CANCEL		= "Annulla";
const string WAND_UI_LV_DELETE		= "Elimina";
const string WAND_UI_LV_NEW			= "Nuova";
const string WAND_UI_LV_X			= "X:";
const string WAND_UI_LV_Y			= "Y:";
const string WAND_UI_LV_Z			= "Z:";
const string WAND_UI_LV_AREA		= "Area:";
const string WAND_UI_LV_ORIENT		= "Ang.:";
const string WAND_UI_LV_TT_OBJ_ID	= "Rappresenta l'ID numerico dell'oggetto bersaglio.\nInserire il valore <i>-1</i> per referenziare <i>OBJECT_INVALID</i>";
const string WAND_UI_LV_TT_NEW_VAR	= "Crea una nuova variabile";
const string WAND_UI_LV_TT_SAVE		= "Salva le modifiche";
const string WAND_UI_LV_TT_DELETE	= "Elimina la variabile";
const string WAND_UI_LV_TT_CANCEL	= "Annulla le modifiche";
const string WAND_UI_LV_TT_INTEGER	= "Integer";
const string WAND_UI_LV_TT_FLOAT	= "Float";
const string WAND_UI_LV_TT_STRING	= "String";
const string WAND_UI_LV_TT_LOCATION	= "Location";
const string WAND_UI_LV_TT_OBJECT	= "Object";
const string WAND_UI_LV_TT_CLICK	= "Clicka sull'oggetto target";
const string WAND_UI_LV_TT_OBJ_NAME	= "Nome dell'oggetto";


// PC_INVENTORY
const string WAND_RADIAL_EXAMINE 				= "Esamina";
const string WAND_RADIAL_TAKE 					= "Prendi";
const string WAND_RADIAL_EQUIP_1				= "Indossa Slot 1";
const string WAND_RADIAL_EQUIP_2				= "Indossa Slot 2";
const string WAND_RADIAL_EQUIP_3				= "Indossa Slot 3";
const string WAND_RADIAL_LOC_VAR				= "Edita Var. Locali";
const string WAND_RADIAL_IDENTIFIED				= "Identificato ON/OFF";
const string WAND_RADIAL_PLOT 					= "Trama ON/OFF";
const string WAND_RADIAL_CURSED 				= "Maledetto ON/OFF";
const string WAND_RADIAL_STOLEN					= "Rubato ON/OFF";
const string WAND_RADIAL_DROPPABLE				= "Rilasciabile ON/OFF";
const string WAND_RADIAL_UNEQUIP 				= "Sfila";
const string WAND_PIM_EQUIP_INVALID_OWNER		= "Non è possibile far equipaggiare un oggetto che non è presente nell'inventario del bersaglio!";
const string WAND_PIM_EQUIP_LEVEL_RESTRICTED	= "Le restrizioni di livello non consentono di far indossare l'oggetto selezionato!";
const string WAND_PIM_EQUIP_UNIDENTIFIED		= "Non è possibile far equipaggiare un oggetto non identificato!";
const string WAND_PIM_EQUIP_VALUE				= "<i>Valore</i>: ";
const string WAND_PIM_EQUIP_CURSED				= "<i>Maledetto</i>: ";
const string WAND_PIM_EQUIP_STOLEN				= "<i>Rubato</i>: ";
const string WAND_PIM_EQUIP_DROPPABLE			= "<i>Rilasciabile</i>: ";
const string WAND_PIM_EQUIP_PLOT				= "<i>Trama</i>: ";
const string WAND_PIM_TOT_VALUE					= "<b>Valore Inventario Totale</b>";
const string WAND_PIM_EQUIPMENT_VALUE			= "<i>Equipaggiamento</i>: ";
const string WAND_PIM_INV_VALUE					= "<i>Zaino</i>: ";
const string WAND_PIM_GOLD						= "Monete";
const string WAND_PIM_ENCUMBRANCE				= "Ingombro";
const string WAND_PIM_EQUIPPING_ERROR			= "Si è verificato un errore nell'equipaggiamento dell'oggetto.\nE' possibile che il bersaglio non abbia i requisiti necessari per indossare l'oggetto selezionato.";

const string WAND_YES					= "SI'";
const string WAND_NO					= "NO";