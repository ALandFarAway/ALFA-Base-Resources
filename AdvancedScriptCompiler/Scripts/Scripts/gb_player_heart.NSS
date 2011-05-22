// gb_player_heart
/*	
	Script that runs when a player controls a companion
*/
// MDiekmann 8/7/07

void main()
{
	//option for a custom hb script
	string sHBScript=GetLocalString(OBJECT_SELF,"hb_script");
	if (sHBScript!="")
		ExecuteScript(sHBScript,OBJECT_SELF);
}