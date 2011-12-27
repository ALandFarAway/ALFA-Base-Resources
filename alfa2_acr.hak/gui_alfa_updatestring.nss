////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR GUI Script
//     Filename : gui_alfa_updatestring
//    $Revision:: 307        $ current version of the file
//        $Date:: 2008-09-05#$ date the file was created or modified
//       Author : Bartleby
//
//    Var Prefix:
//  Dependencies:
//
//  Description
//  This script is called from a custom PC tools button.  It calls a GUI element
//  in order to gather new text for the Description field.
//
//  Revision History
//  2008-09-05  Bartleby  Inception
//////////////////////////////////////////////
void main(string NewPlayerDescription)
{
	object  oPC = OBJECT_SELF;

	SetLocalString(oPC, "PlayerDescription1" , NewPlayerDescription);
	SetDescription(oPC, NewPlayerDescription);
	SetLocalInt(oPC,"PlayerDescriptionDoOnce",1);
	

}