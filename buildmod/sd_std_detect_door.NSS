//DESC: Makes a placeable usable if a nearby creature detects it.

int CheckIfDetected(object oSearcher, int SearchDC )
{
	int nSkill = GetSkillRank(SKILL_SEARCH,oSearcher);
	int nDetectMode = GetActionMode(oSearcher,ACTION_MODE_DETECT);
	if (GetRacialType(oSearcher)==RACIAL_TYPE_ELF) nDetectMode=1;
	int nRoll;
	
	if (nDetectMode){
		nRoll=20;
	} else {
		nRoll=d20();
	}
	
	//THE CHECK!
	if (nSkill+nRoll>=SearchDC)
	{
		PlayVoiceChat(VOICE_CHAT_LOOKHERE, oSearcher);	//I found something!
		return 1;
	}
	return 0;
}


void main()
{
	//import parameters
	
	int done_yet = GetLocalInt( OBJECT_SELF, "done" );
	
	if( done_yet  == 1 )  return;
	
	float radius = GetLocalFloat( OBJECT_SELF, "VisibilityRadius");
	int searchDC = GetLocalInt( OBJECT_SELF, "SearchDC");
	string sTag  = GetLocalString( OBJECT_SELF, "TargetTag");
	
	object oTarget = GetNearestObjectByTag( sTag );
	
	  object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
	  int count_creature = 1; 
	  
	  while( oCreature != OBJECT_INVALID )
	  {
	  		float fDistance = GetDistanceBetween(OBJECT_SELF,oCreature);
	  	
			// check if creature is close enough to see
			if( fDistance < radius ){
				
				//if check LOS and roll
				 if ( LineOfSightObject(OBJECT_SELF, oCreature) == TRUE ){
				
				 	if  ( CheckIfDetected( oCreature, searchDC ) ){
					
						SetUseableFlag( oTarget, 1);
						SetLocalInt( OBJECT_SELF, "done", 1 );
						
						return;
					} 
			 	}//LOS
				
			}//distance
	  
			//next
			count_creature++;
			GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, count_creature );
	  }  
	

}	