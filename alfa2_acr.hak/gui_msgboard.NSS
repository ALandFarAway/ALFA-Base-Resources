#include "acr_db_persist_i"

/**************************************************************
DMFI MESSAGE BOARD - Dungeon Master Friendly Initiative Plugin
por Qkrch http://www.neverwinteros.com

Esto lo tendría que haber hecho Lagarto....en fin...
*******************Constants******************************************/


const string SCREEN_NEWTOPIC = "SCREEN_INPUTNEWTOPIC";
const string NEWTOPIC_XML = "inputnewtopic.xml";

const string SCREEN_MSGBOARD = "SCREEN_MSGBRD"; 
const string MSGBOARD_XML = "msgboard.xml";
const string SLOT = "MSGB_HOL_";
const string BOARD_OBJECT = "DMFI_BulletinBoard";
/************************Text************************************/
const string TXT_INSERT_TITLE = "Please insert a title to the message";
const string TXT_INSERT_BODY = "Please type a message to deliver";
const string TXT_NO_REPLY = "Select a topic to reply";

				string HELP_MSG = "This is a Bulletin Board Ingame that can store your messages"+
                         " to show them later to other people who reads this board. The board "+
						 "displays the last 15 messages that have been written.\n\nTo display "+
						 "the message click on any scroll painting and read.\n\nTo insert a new "+
						 "message click on New Topic, write the title and the body of the message "+
						 "and select a category. When you're ready click OK to deliver the message.\n\n"+
						 "To reply in a message simply click on the desired scroll and then press Reply Topic,"+
						 " fill again the title and body -no needed category- and press Ok.\n\n"+
						 "The Delete Topic function is available to DMs only.";



/**********************************************************/

string WhatCategory(int nKat)
{
	string sMsg="On ";
	if (nKat==1) {sMsg = sMsg+"General";}
	if (nKat==2) {sMsg = sMsg+"Quests";}
	if (nKat==3) {sMsg = sMsg+"Guilds";}
	if (nKat==4) {sMsg = sMsg+"Shows";}
	if (nKat==5) {sMsg = sMsg+"Trade";}
	if (nKat==6) {sMsg = sMsg+"Announcements";}
	
	return sMsg;
	//else return "General";
}

int GetCurrentDBID(object oPC, object oBoard)
{
	return GetLocalInt(oBoard, "dbid_"+IntToString(GetLocalInt(oPC,"BBOARD_VIEWING")));
}

void DeleteDatabase(int nIndex, object oPC)
{
	ACR_SQLQuery(
		"DELETE FROM `bulletin_board` "+
		"WHERE " +
			"ID = " + IntToString(nIndex) + " OR Parent = " + IntToString(nIndex)
	);

	CloseGUIScreen(oPC,SCREEN_MSGBOARD);
	SendMessageToPC(oPC,"Succesfully deleted");
}

void WriteDatabase(string sTitle, string sBody, int iCat, int iBID, object oPC)
{
	int iCID = ACR_GetCharacterID(oPC);

	iCat = (iCat > 0 ? iCat : 1);

	ACR_SQLQuery(
			"INSERT INTO `bulletin_board` "+
		       		"(`Category`, `Title`, `Message`, `CharacterID`, `BoardID`) "+
			"VALUES " +
				"(" + IntToString(iCat) + ", '" + ACR_SQLEncodeSpecialChars(sTitle) + "', '" + ACR_SQLEncodeSpecialChars(sBody) + "', " + IntToString(iCID) + ", " + IntToString(iBID) + ")"
			);
	
	SendMessageToPC(oPC,"Sucessfully posted");
}

void ReplyDatabase(string sTitle, string sBody, int iCat, int iBID, int iDBID, object oPC)
{
	int iCID = ACR_GetCharacterID(oPC);

	ACR_SQLQuery(
			"INSERT INTO `bulletin_board` "+
		       		"(`Category`, `Title`, `Message`, `CharacterID`, `Parent`, `BoardID`) "+
			"VALUES " +
				"(0, '" + ACR_SQLEncodeSpecialChars(sTitle) + "', '" + ACR_SQLEncodeSpecialChars(sBody) + "', " + IntToString(iCID) + ", " + IntToString(iDBID) + ", " + IntToString(iBID) + ")"
			);


	SendMessageToPC(oPC,"Sucessfully replied");
}

void ReadDatabase(int b_index, object oBoard, object oPC)
{
	int i, max = 16, cat, id, f_cat, f_id, num_used;
	string title,msg,name,gsid,f_title,f_msg,f_name,f_gsid,s_index;

	ACR_SQLQuery(
			"SELECT " +
				" b2.`ID`, b2.`Category`, b2.`Title`, b2.`Message`, c.`Name`, p.`Name`, b2.`BoardID` "+
			"FROM " +
				"`bulletin_board` b1, `bulletin_board` b2, `players` p, `characters` c "+
			"WHERE " +
				"p.id = c.playerid AND " +
				"b2.boardID = " + IntToString(b_index) + " AND " +
				"c.id = b2.characterid AND " +
				"(b1.id = b2.id OR " +
					"(b2.category = 0 AND " +
					"b2.parent = b1.id)) " +
			"ORDER BY " + 
				"b1.id desc, b2.id asc"
			);

	// iterate through max postings to fill screen
	for (i=0; i <= max; ) {
		if (ACR_SQLFetch() != SQL_SUCCESS) {
			num_used = i;
			break;
		}

		id = StringToInt(ACR_SQLGetData(0));
		cat = StringToInt(ACR_SQLGetData(1));
		title = ACR_SQLGetData(2);
		msg = ACR_SQLGetData(3);
		name = ACR_SQLGetData(4);
		gsid = ACR_SQLGetData(5);

		// this is a root msg
		if (cat > 0) {
			f_title = title;
			f_msg = msg;
			f_name = name;
			f_gsid = gsid;
			f_cat = cat;
			f_id = id;

			++i;
		}
		// this is a reply, tack on msg
		else
		{
			f_msg = f_msg + "\n\nReply:  <b>"+title+"</b>\n" + "    "+name + " (<i>" + gsid + "</i>)\n\n<i>" + msg + "</i>";
		}

		s_index = IntToString(i);

		SetLocalString(oBoard,"Title_"+s_index,f_title);
		SetLocalString(oBoard,"Body_"+s_index,f_msg);
		SetLocalString(oBoard,"Name_"+s_index, f_name);
		SetLocalString(oBoard,"Player_"+s_index, f_gsid);
		SetLocalInt(oBoard,"Category_"+s_index,f_cat);
		SetLocalInt(oBoard,"dbid_"+s_index,f_id);
	}

	
	for (i=0; i <= num_used; ++i) {
		s_index = IntToString(i);

		cat = GetLocalInt(oBoard,"Category_"+s_index);
		title = GetLocalString(oBoard,"Title_"+s_index);

		SetGUIObjectText(oPC,SCREEN_MSGBOARD,SLOT+s_index, -1,title);
		SetGUITexture(oPC,SCREEN_MSGBOARD,SLOT+s_index,"board_cat_"+IntToString(cat)+".tga");
	}

	for (i=num_used+1; i <= max; ++i) {
		s_index = IntToString(i);

		cat = GetLocalInt(oBoard,"Category_"+s_index);

		SetGUIObjectText(oPC,SCREEN_MSGBOARD,SLOT+s_index, -1,"");
		SetGUITexture(oPC,SCREEN_MSGBOARD,SLOT+s_index,"");



		DeleteLocalString(oBoard,"Title_"+s_index);
		DeleteLocalString(oBoard,"Body_"+s_index);
		DeleteLocalString(oBoard,"Name_"+s_index);
		DeleteLocalString(oBoard,"Player_"+s_index);
		DeleteLocalInt(oBoard,"Category_"+s_index);
		DeleteLocalInt(oBoard,"dbid_"+s_index);
	}
}

void AddPost(object oPC, object oBoard, string title, string msg, int iDBID, int iBID)
{
	int iCat = GetLocalInt(oPC,"DMFI_NUM_MSG_CAT");

	if (title=="") {
		DisplayMessageBox(oPC,0,TXT_INSERT_TITLE,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
		return;
	}

	if (msg=="") {
		DisplayMessageBox(oPC,0,TXT_INSERT_BODY,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
		return;
	}
					
	if (GetLocalInt(oPC,"DMFI_BBOARD_REPLY")==TRUE) {
		if (iDBID == 0) {
			DisplayMessageBox(oPC,0,TXT_NO_REPLY,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
			return;
		}
		ReplyDatabase(title,msg,iCat,iBID,iDBID,oPC);
	}
	else {
		WriteDatabase(title,msg,iCat,iBID,oPC);
	}

	CloseGUIScreen(oPC,SCREEN_NEWTOPIC);
	CloseGUIScreen(oPC,SCREEN_MSGBOARD);
	//ReadDatabase(iBID, oBoard, oPC);
}

void ShowPost(object oPC, object oBoard, int nSlot)
{
	string sMsg = "No Message";
	string slot = IntToString(nSlot);
					
	SetLocalInt(oPC,"BBOARD_VIEWING",nSlot);
	SetLocalInt(oPC,"ACR_BOARD_ID", GetLocalInt(oBoard, "ACR_BOARD_ID"));
	string sBody = GetLocalString(oBoard,"Body_"+slot);
	string sName = GetLocalString(oBoard,"Name_"+slot);
	string sTitle = GetLocalString(oBoard,"Title_"+slot);
	string sPlayer = GetLocalString(oBoard,"Player_"+slot);
	int iCat = GetLocalInt(oBoard,"Category_"+slot);
	string sCat = WhatCategory(iCat);

	if (iCat != 0)
		sMsg = sCat+"\n\n<Color=Black><b>"+sTitle+"</b> \n    "+sName+" (<i>"+sPlayer+"</i>)\n\n<i>"+sBody+"</i></color>";
					
	SetGUIObjectText(oPC,SCREEN_MSGBOARD,"FULL_MESSAGE",-1,sMsg);
}

void RemovePost(object oPC, object oBoard, int iDBID)
{
	DeleteDatabase(iDBID, oPC);
}

void main(int N1, int N2, string sVar, string sVar2)
{
	object oPC = GetPCSpeaker();

	if (!GetIsObjectValid(oPC))
		oPC = OBJECT_SELF;
		
	object oBoard = GetNearestObjectByTag(BOARD_OBJECT,oPC);
	int iBID = GetLocalInt(oBoard, "ACR_BOARD_ID");
	int iDBID = GetCurrentDBID(oPC, oBoard);
	 	
	switch (N1) {
		case 0: 
			switch(N2) {
			// Board display
			case 1:
				DisplayGuiScreen(oPC,SCREEN_MSGBOARD, FALSE, MSGBOARD_XML);
							
				if (!GetIsDM(oPC))
					SetGUIObjectDisabled(oPC,SCREEN_MSGBOARD,"MSGB_DELTOPIC",TRUE);

				break;
			// Board add
                        case 2:
				ReadDatabase(iBID, oBoard, oPC);
				break;
			// Board remove
			case 3:
				DeleteLocalInt(oPC,"DMFI_BBOARD_REPLY");
				DeleteLocalInt(oPC,"BBOARD_VIEWING");
				DeleteLocalInt(oPC,"ACR_BOARD_ID");
				break;    
			// Board create
			case 4:
				break;    
			}
			break;

		// New topic buttons
		case 1:
			switch(N2) {
				// New thread
				case 0:
					SetLocalInt(oPC,"DMFI_BBOARD_REPLY",FALSE);
						
					DisplayGuiScreen(oPC,SCREEN_NEWTOPIC, FALSE, NEWTOPIC_XML);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_1_BUTTON",FALSE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_2_BUTTON",FALSE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_3_BUTTON",FALSE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_4_BUTTON",FALSE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_5_BUTTON",FALSE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_6_BUTTON",FALSE);
					SetGUIObjectText(oPC,SCREEN_NEWTOPIC,"messagetextNT",-1,"New Topic");
					break;
				// Reply thread
     				case 1:
					SetLocalInt(oPC,"DMFI_BBOARD_REPLY",TRUE);

					DisplayGuiScreen(oPC,SCREEN_NEWTOPIC, FALSE, NEWTOPIC_XML);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_1_BUTTON",TRUE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_2_BUTTON",TRUE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_3_BUTTON",TRUE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_4_BUTTON",TRUE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_5_BUTTON",TRUE);
					SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_6_BUTTON",TRUE);
					SetGUIObjectText(oPC,SCREEN_NEWTOPIC,"messagetextNT",-1,"Reply Topic");
					break;
				// Delete thread
				case 2:
					if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
						RemovePost(oPC, oBoard, iDBID);
					break;
			}
			break;
		
		// Add post
		// title->svar2 and body->svar
		case 2: 
			AddPost(oPC, oBoard, sVar2, sVar, iDBID, iBID);

			break;	

		// Read topic button
		case 3: 
			ShowPost(oPC, oBoard, N2);

			break;

		// Category radio button
		case 4:
			SetLocalInt(oPC,"DMFI_NUM_MSG_CAT",N2);
			break;

		// Help button
		case 5:
			DisplayMessageBox(oPC,0,HELP_MSG,"","",FALSE,"SCREEN_MESSAGEBOX_REPORT",0,"",0,"");
			break;	

	}
}
