// ga_notice_text(string sText, int nStrRef)
/*
	Description:
	Appends sText and nStrRef together and sends resulting string to the PC Speaker.  
	It will appear on the player's screen inside their Notice Window GUI.
	A notice window can be any text field that has the UIText_OnUpdate_DisplayNoticeText() 
	callback running on it.
	
	Parameters:
 		string sText	- Text to display
		int nStrRef 	- string ref to append, 0 for no string ref.

*/
// ChazM 5/9/07

void main(string sText, int nStrRef)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	string sStringRef = "";
	if (nStrRef > 0)
		sStringRef = GetStringByStrRef(nStrRef, GetGender(oPC));
	sText = sText + sStringRef;
	SetNoticeText( oPC, sText );		
}