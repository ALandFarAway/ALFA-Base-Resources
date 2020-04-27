////////////////////////////////////////////////////////////////////////////////
// shinn_sava_config_inc
// Original Scripter:  Shinn      Design: Shinn
// Last modified : 20/06/2012 by Shinn
//------------------------------------------------------------------------------
// Main configuration and localisation file for sava chess minigame
////////////////////////////////////////////////////////////////////////////////

//CONFIG

const int DICE_SIZE = 8;

const int SAVE_ALLOWED = TRUE;

const int SPIDER_ALLOWED = TRUE;

const string SAVE_RESREF = "sava_sgame";

const string BACKGROUND = "sava_main_screen_art_rev3.tga";

//TRANSLATION
//const string KILLER_SPIDER = Moved to sava_spiderkiller.2da

const string DICES = "Throw dices";

const string GAME_LOG = "Game log";

const string KILLS = "Pieces taken:";

const string LOSTS = "Pieces lost:";

const string NEW_GAME = "New game";

const string LOAD_GAME = "Load game";

const string CLOSE = "Close";

const string CANCEL = "Cancel";

const string WAITING = "Waiting for player...";

const string STARTS_GAME = " starts game";

const string CONT_GAME = " continues game";

const string AT = " to ";

const string CAPTURES = " beats ";

const string LOOSE_TEXT = "DEFEATED!";

const string EXIT_GAME = "End game";

const string SAVE_GAME = "Save game";

const string RETURN_TO_GAME = "Return to game";

const string WIN_TEXT = "VICTORY!";

const string DESTROYED = "destroyed!";

const string DISCONNECTED = "Other player disconnected";

const string SPIDER_USED = "Ability already used";

const string OPTIONS = "Options";

const string SAVE_AS = "Save as:";

const string SAVED = "<c=lightblue>Saved!</c>";

const string TURN = "<c=FireBrick>!!! Your move !!!</c>";

const string VAR_ERROR = "SAVA: variable not found, check game objects!";

const string OBJ_ERROR = "SAVA: game object not found, check area!";

	void SetLanguageVars(object oPC)
	{
	
	SetLocalGUIVariable(oPC,"SAVA_MAIN",1,DICES);
	SetGUITexture(oPC,"SAVA_MAIN","SAVA_BACKGROUND_IMAGE",BACKGROUND);
	
	SetGUIObjectText(oPC,"SAVA_MAIN","Close1",-1,CLOSE);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Close2",-1,OPTIONS);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Close3",-1,CLOSE);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Close4",-1,CLOSE);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Cancel",-1,CANCEL);
	
	SetGUIObjectText(oPC,"SAVA_MAIN","Exit_Game",-1,EXIT_GAME);
	SetGUIObjectText(oPC,"SAVA_MAIN","Save_Game1",-1,SAVE_GAME);
	SetGUIObjectText(oPC,"SAVA_MAIN","Back_To_Game1",-1,RETURN_TO_GAME);
	SetGUIObjectText(oPC,"SAVA_MAIN","Back_To_Game2",-1,RETURN_TO_GAME);
		
	SetGUIObjectText(oPC,"SAVA_MAIN","Exit_Game2",-1,EXIT_GAME);
	SetGUIObjectText(oPC,"SAVA_MAIN","Save_Game2",-1,SAVE_GAME);
	SetGUIObjectText(oPC,"SAVA_MAIN","Save_Game_Exe",-1,SAVE_GAME);
				
	SetGUIObjectText(oPC,"SAVA_MAIN","Start_Game",-1,NEW_GAME);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Load_Game",-1,LOAD_GAME);
	SetGUIObjectText(oPC,"SAVA_MAIN","Save_As",-1,SAVE_AS);
		
	SetGUIObjectText(oPC,"SAVA_MAIN","Player_1_BoxA",-1,WAITING);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Player_1_BoxB",-1,WAITING);
	SetGUIObjectText(oPC,"SAVA_MAIN","Player_2_BoxA",-1,WAITING);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Player_2_BoxB",-1,WAITING);	
	
	SetGUIObjectText(oPC,"SAVA_MAIN","Game_Log_Name",-1,GAME_LOG);
	SetGUIObjectText(oPC,"SAVA_MAIN","Kills",-1,KILLS);	
	SetGUIObjectText(oPC,"SAVA_MAIN","Losts",-1,LOSTS);
	
	SetGUIObjectText(oPC,"SAVA_MAIN","LOOSE_TEXT",-1,"<c=red>"+LOOSE_TEXT+"</c>");	
	SetGUIObjectText(oPC,"SAVA_MAIN","WIN_TEXT",-1,"<c=lightblue>"+WIN_TEXT+"</c>");		
	SetGUIObjectText(oPC,"SAVA_MAIN","DISCONNECT_TEXT",-1,DISCONNECTED);
	
	}