// ga_destroy_party_henchmen
/*
	Destroy all henchmen in the entire party
*/
// ChazM 12/5/05
// ChazM 1/26/05 - Bug fix	
// ChazM 3/8/06 - funcs moved to ginc_henchman

#include "ginc_henchman"
#include "ginc_debug"	
/*	
int GetNumHenchmen(object oMaster=OBJECT_SELF)
{
	int i = 1;
	object oHenchman = GetHenchman(oMaster, i);

	while (GetIsObjectValid(oHenchman))
	{
		i++;
		//PrettyDebug ("GetNumHenchmen() - found: " + GetName(oHenchman));
		oHenchman = GetHenchman(oMaster, i);
	}
	i = i-1;

	//PrettyDebug ("GetNumHenchmen() - Total found = " + IntToString(i));
	return (i);
}

// Destroy a henchman
// Note: won't be destroyed if has been set as undestroyable
void DestroyHenchman(object oHenchman)
{
		//PrettyDebug ("Removing " + GetName(oHenchman));
		RemoveHenchman(GetMaster(oHenchman), oHenchman);	
		SetPlotFlag(oHenchman, FALSE);
		DestroyObject(oHenchman);
}

// Destroy all the henchmen of this master	
void DestroyAllHenchmen(object oMaster=OBJECT_SELF)
{
	int i;
	object oHenchman;

	// destroy them backwards to avoid problems w/ removeing henchmen causing re-indexing
	int iNumHenchmen = GetNumHenchmen(oMaster);
	
	for (i = iNumHenchmen; i>=1; i--)
	{
		oHenchman = GetHenchman(oMaster, i);
		//PrettyDebug ("Removing " + GetName(oHenchman));
		//RemoveHenchman(oMaster, oHenchman);	
		//SetPlotFlag(oHenchman, FALSE);
		DelayCommand(0.5f, DestroyHenchman(oHenchman));	// delay destructions so we have time to iterate through party properly
	}
}		

// Destroy every henchman in the entire party	 
void DestroyAllHenchmenInParty(object oPartyMember)	
{
	object oFM = GetFirstFactionMember(oPartyMember, FALSE);
	while(GetIsObjectValid(oFM))
	{
		//PrettyDebug ("Examining " + GetName(oFM) + " for henchmen.");
		DestroyAllHenchmen(oFM);
		oFM = GetNextFactionMember(oPartyMember, FALSE);
	}
}		
*/
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	DestroyAllHenchmenInParty(oPC);
}
		