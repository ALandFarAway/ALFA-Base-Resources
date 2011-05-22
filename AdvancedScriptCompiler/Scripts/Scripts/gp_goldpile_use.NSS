
//gp_goldpile_use

// Global script for on use of a gold pile. (Gives player X amount of gold, destroys goldpile placeable)

// DBR 8/15/06


//To use - put this script on the "onUsed" event of a goldpile placeable, make sure the placeable is Usable and non-static. Also make sure the HP of the placeable is not zero.

//To override the maximum and minimum ranges, put integer variables "nGoldRangeMax" and "nGoldRangeMin" on the placeable with the new value.

string sGOLDRANGE_MAX = "nGoldRangeMax";	//Defaults to 300, 0 is not a valid entry.
string sGOLDRANGE_MIN = "nGoldRangeMin";	//Defaults to 100, if MAX is specified it will default to 1/3 of that, 0 is not a valid entry.
string sUSES_LEFT = "nUsesLeft";			//Defaults to 1, 0 is not a valid entry.



void main()
{
	int nUsesLeft = GetLocalInt(OBJECT_SELF,sUSES_LEFT);	//if zero, assume the value is uninitialized.
		SetLocalInt(OBJECT_SELF,sUSES_LEFT,nUsesLeft-1);
	
	if (nUsesLeft>=0)
	{
			
		int nGoldRangeMax = GetLocalInt(OBJECT_SELF,sGOLDRANGE_MAX);
		int nGoldRangeMin = GetLocalInt(OBJECT_SELF,sGOLDRANGE_MIN);
	
		if (nGoldRangeMax == 0)
			nGoldRangeMax = 300;
		if (nGoldRangeMin == 0)
			nGoldRangeMin = nGoldRangeMax/3;
			
		int nGP = Random(nGoldRangeMax-nGoldRangeMin)+nGoldRangeMin;
	
		object oPC = GetLastUsedBy();		
		GiveGoldToCreature(oPC,nGP);
	
	}
	if (nUsesLeft<=1)
	{
		AssignCommand(OBJECT_SELF,DestroyObject(OBJECT_SELF));	
	}
}