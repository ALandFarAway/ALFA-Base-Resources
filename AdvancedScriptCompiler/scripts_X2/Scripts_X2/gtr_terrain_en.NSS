/* On Enter script for a terrain trigger:  
	- Adjusts party movement rate (if necessary).
	- Changes ambient sound to appropriate wilderness.
	- Sets terrain type for encounter table purposes. */

#include "ginc_cutscene"
#include "x0_i0_petrify"
#include "ginc_debug"
#include "ginc_overland"

void main()
{
	object oEnter 		= GetEnteringObject();
					
	//RemoveEffectOfType(oEnter,EFFECT_TYPE_MOVEMENT_SPEED_DECREASE);
	
	int nTerrain = GetTerrainType(OBJECT_SELF);
	
	if(GetIsPC(oEnter))
	{
		// if terrain change
		if(GetCurrentPCTerrain() != nTerrain)
		{
			object oArea = GetArea(OBJECT_SELF);
			int nTerrainBGM = GetLocalInt(OBJECT_SELF, "nTerrainBGM");

			if (nTerrainBGM == 0)
				nTerrainBGM = GetTerrainBGM(nTerrain);
				
			if( GetCurrentPCTerrain() == 0)
			{
				MusicBackgroundStop(oArea);
				
				if(GetIsDay())
					MusicBackgroundChangeDay(oArea, nTerrainBGM);
				else
					MusicBackgroundChangeNight(oArea, nTerrainBGM);

				MusicBackgroundSetDelay(oArea, 100000);
			}

			else if( (GetIsDay() && MusicBackgroundGetDayTrack(oArea) != nTerrainBGM) || 
					 (GetIsNight() && MusicBackgroundGetNightTrack(oArea) != nTerrainBGM) )
			{
				MusicBackgroundStop(oArea);

				if(GetIsDay())
					MusicBackgroundChangeDay(oArea, nTerrainBGM);
				else
					MusicBackgroundChangeNight(oArea, nTerrainBGM);
				
				MusicBackgroundSetDelay(oArea, 100000);
			}
			
			object oOldSound = GetLocalObject(GetModule(),"oLastSound");
			if(GetIsObjectValid(oOldSound))
			{
				SoundObjectStop(oOldSound);
			}
			object oNewSound = GetObjectByTag(GetTerrainAudioTrack(nTerrain));
			SoundObjectPlay(oNewSound);
			SetLocalObject(GetModule(),"oLastSound",oNewSound);
		}
		SetCurrentPCTerrain(nTerrain);
	}

	float fNewRate = GetTerrainModifiedRate(oEnter, nTerrain);
	SetMovementRateFactor(oEnter, fNewRate);
}