// ga_rest
/*
	Do a rest action for speaker
	This is essentially the same as the player hitting the rest button.
	
*/
// ChazM 11/30/06

void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	SetGlobalInt("DoRestingNow", TRUE);
	AssignCommand(oPC, ActionRest());	
}