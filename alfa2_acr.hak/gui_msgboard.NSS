#include "acr_db_persist_i"

/**************************************************************
DMFI MESSAGE BOARD - Dungeon Master Friendly Initiative Plugin
por Qkrch http://www.neverwinteros.com

Esto lo tendría que haber hecho Lagarto....en fin...
*******************Constants******************************************/


const string PENCIL_TAG = "dmfi_it_pencil";
const string SCREEN_NEWTOPIC = "SCREEN_INPUTNEWTOPIC";
const string NEWTOPIC_XML = "inputnewtopic.xml";

const string SCREEN_MSGBOARD = "SCREEN_MSGBRD"; 
const string MSGBOARD_XML = "msgboard.xml";
const string SLOT = "MSGB_HOL_";
const string BOARD_OBJECT = "DMFI_BulletinBoard";
/************************Text************************************/
const string TXT_INSERT_TITLE = "Please insert a title to the message";
const string TXT_INSERT_BODY = "Please type a message to deliver";
const string TXT_INQUISITION = "Deleted by local Inquisition"; 
const string PENCIL_MSG = "You need a pencil to write and insert this message!";

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
	if (nKat==1) {sMsg = sMsg+"General Message";}
	if (nKat==2) {sMsg = sMsg+"Quests";}
	if (nKat==3) {sMsg = sMsg+"Guild";}
	if (nKat==4) {sMsg = sMsg+"Shows";}
	if (nKat==5) {sMsg = sMsg+"Sells";}
	if (nKat==6) {sMsg = sMsg+"Announcements";}
	
	return sMsg;
	//else return "General";
}

void WriteDatabase(string sTitle, string sBody, object oPC)
{
	int iCat = GetLocalInt(oPC,"DMFI_NUM_MSG_CAT");
	int iCID = ACR_GetCharacterID(oPC);

	iCat = (iCat > 0 ? iCat : 1);

	ACR_AsyncSQLQueryEx(
			"INSERT INTO `bulletin_board` "+
		       		"(`Category`, `Title`, `Message`, `CharacterID`) "+
			"VALUES " +
				"(" + IntToString(iCat) + ", '" + ACR_SQLEncodeSpecialChars(sTitle) + "', '" + ACR_SQLEncodeSpecialChars(sBody) + "', " + IntToString(iCID) + ")",
			GetModule(),
			ACR_QUERY_LOW_PRIORITY
			);
	
	SendMessageToPC(oPC,"Sucessfully added");
}

void ReplyDatabase(string sTitle, string sBody, object oPC)
{
	int iCID = ACR_GetCharacterID(oPC);
	int iMsg = GetLocalInt(oPC,"BBOARD_VIEWING");

	ACR_AsyncSQLQueryEx(
			"INSERT INTO `bulletin_board` "+
		       		"(`Category`, `Title`, `Message`, `CharacterID`, `Parent`) "+
			"VALUES " +
				"(0, '" + ACR_SQLEncodeSpecialChars(sTitle) + "', '" + ACR_SQLEncodeSpecialChars(sBody) + "', " + IntToString(iCID) + ", " + IntToString(iMsg) + ")",
			GetModule(),
			ACR_QUERY_LOW_PRIORITY
			);


	SendMessageToPC(oPC,"Sucessfully replied");
}

void ReadDatabase(object oPC)
{
	object oBoard = GetNearestObjectByTag(BOARD_OBJECT,oPC);
	int i, max = 16, cat, id, f_cat;
	string title,msg,name,gsid,f_title,f_msg,f_name,f_gsid,s_index;

	ACR_SQLQuery(
			"SELECT " +
				" b2.`ID`, b2.`Category`, b2.`Title`, b2.`Message`, c.`Name`, p.`Name` "+
			"FROM " +
				"`bulletin_board` b1, `bulletin_board` b2, `players` p, `characters` c "+
			"WHERE " +
				"p.id = c.playerid AND " +
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
			max = i;
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

			++i;
		}
		// this is a reply, tack on msg
		else
		{
			f_msg = f_msg + "\n\nReply by <b>" + name + "</b> (<i>" + gsid + "</i>):\n"+title+"\n" + msg;
		}

		s_index = IntToString(i);

		SetLocalString(oBoard,"Title_"+s_index,f_title);
		SetLocalString(oBoard,"Body_"+s_index,f_msg);
		SetLocalString(oBoard,"Name_"+s_index, f_name);
		SetLocalString(oBoard,"Player_"+s_index, f_gsid);
		SetLocalInt(oBoard,"Category_"+s_index,f_cat);
	}
	
	for (i=0; i < max; ++i) {
		s_index = IntToString(i);

		cat = GetLocalInt(oBoard,"Category_"+s_index);
		title = GetLocalString(oBoard,"Title_"+s_index);

		SetGUIObjectText(oPC,SCREEN_MSGBOARD,SLOT+s_index, -1,title);
		SetGUITexture(oPC,SCREEN_MSGBOARD,SLOT+s_index,"board_cat_"+IntToString(cat)+".tga");
	}
}

void main(int N1, int N2, string sVar, string sVar2)
{
     object oPC = GetPCSpeaker();
     if (!GetIsObjectValid(oPC))
        oPC = OBJECT_SELF;
		
	 object oBoard = GetNearestObjectByTag(BOARD_OBJECT,oPC);
	 	
	 switch (N1)
        {
            case 0: //relacionado con tabla
                {
					switch(N2)
                    {
						case 1:
						{         	
                            DisplayGuiScreen(oPC,SCREEN_MSGBOARD, FALSE, MSGBOARD_XML);
							
							if (!GetIsDM(oPC))
								SetGUIObjectDisabled(oPC,SCREEN_MSGBOARD,"MSGB_DELTOPIC",TRUE);
								else
								SetGUIObjectDisabled(oPC,SCREEN_MSGBOARD,"MSGB_DELTOPIC",FALSE);
		                    break;
						}
                        case 2:
						{
                           // SendMessageToPC(oPC,"Adding");
							ReadDatabase(oPC);
                            break;
							}
                        case 3:
						{
							DeleteLocalInt(oPC,"DMFI_BBOARD_REPLY");
							DeleteLocalInt(oPC,"BBOARD_VIEWING");
                            //SendMessageToPC(oPC,"Removing");
                            break;    
							}
						case 4:
						{
                            //SendMessageToPC(oPC,"Creating");
							//ReadDatabase(oPC);
                            break;    
							}	
							
					}
				}break;
			case 1: //new topic
				{   switch(N2)
					{
						case 0:
						{
							SetLocalInt(oPC,"DMFI_BBOARD_REPLY",FALSE);
						
							DisplayGuiScreen(oPC,SCREEN_NEWTOPIC, FALSE, NEWTOPIC_XML);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_1_BUTTON",FALSE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_2_BUTTON",FALSE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_3_BUTTON",FALSE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_4_BUTTON",FALSE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_5_BUTTON",FALSE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_6_BUTTON",FALSE);
							SetGUIObjectText(oPC,SCREEN_NEWTOPIC,"messagetextNT",-1,"New Topic");
						}break;
     					case 1: //reply
						{
							SetLocalInt(oPC,"DMFI_BBOARD_REPLY",TRUE);
							DisplayGuiScreen(oPC,SCREEN_NEWTOPIC, FALSE, NEWTOPIC_XML);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_1_BUTTON",TRUE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_2_BUTTON",TRUE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_3_BUTTON",TRUE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_4_BUTTON",TRUE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_5_BUTTON",TRUE);
							SetGUIObjectDisabled(oPC,SCREEN_NEWTOPIC,"RADIO_6_BUTTON",TRUE);
							SetGUIObjectText(oPC,SCREEN_NEWTOPIC,"messagetextNT",-1,"Reply Topic");
						}break;
						case 2: //delete persistent
						{
							/*
							int iMsg = GetLocalInt(oPC,"BBOARD_VIEWING");
							int iIndex = GetCampaignInt(DATABASE,"Index");
							int iRes = (iIndex+1)-iMsg;
							SetCampaignString(DATABASE,"Body_"+IntToString(iRes),TXT_INQUISITION);
							SetCampaignString(DATABASE,"Title_"+IntToString(iRes),TXT_INQUISITION);
							CloseGUIScreen(oPC,SCREEN_MSGBOARD);
							SendMessageToPC(oPC,"Succesfully censored");
							*/
						}break;
						
						
							
					}
					
					 	
				}break;
	
		
			case 2: //title->svar2 and body->svar
				{
					if(sVar2==""){ DisplayMessageBox(oPC,0,TXT_INSERT_TITLE,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,""); return;}
					if(sVar==""){ DisplayMessageBox(oPC,0,TXT_INSERT_BODY,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,""); return;}
					
					int PENCIL_NEED = GetLocalInt(oBoard,"PENCIL_NEED");
					
					if (PENCIL_NEED==FALSE)
					{
					if (GetLocalInt(oPC,"DMFI_BBOARD_REPLY")==TRUE)
					   ReplyDatabase(sVar2,sVar,oPC);
					else   
					   WriteDatabase(sVar2,sVar,oPC);
					}
					else
					{
						object oPencil = GetItemPossessedBy(oPC,PENCIL_TAG);
						if (oPencil == OBJECT_INVALID)
							{
								DisplayMessageBox(oPC,0,PENCIL_MSG,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
							}
						else
							{
							if (GetLocalInt(oPC,"DMFI_BBOARD_REPLY")==TRUE)
					   			ReplyDatabase(sVar2,sVar,oPC);
							else   
					   			WriteDatabase(sVar2,sVar,oPC);
								
							DestroyObject(oPencil,0.1,TRUE);	
							}
					}   
					CloseGUIScreen(oPC,SCREEN_NEWTOPIC);
					CloseGUIScreen(oPC,SCREEN_MSGBOARD);
				}
				break;	
			case 3:
				{
					string sFin;
					string sN = IntToString(N2);
					
					SetLocalInt(oPC,"BBOARD_VIEWING",N2);
					string sBody = GetLocalString(oBoard,"Body_"+sN);
					string sName = GetLocalString(oBoard,"Name_"+sN);
					string sTitle = GetLocalString(oBoard,"Title_"+sN);
					string sPlayer = GetLocalString(oBoard,"Player_"+sN);
					int iCat = GetLocalInt(oBoard,"Category_"+sN);
					//SendMessageToPC(oPC,"iCat="+IntToString(iCat));
					string sCat = WhatCategory(iCat);
					
					sFin = sCat+"\n\n<Color=Black><b>"+sTitle+"</b> \n    <b>"+sName+"</b> (<i>"+sPlayer+"</i>)\n\n "+sBody+"</color>";
					
					SetGUIObjectText(oPC,SCREEN_MSGBOARD,"FULL_MESSAGE",-1,sFin);
				}
				break;
			case 4: //categories button
				{
				    SetLocalInt(oPC,"DMFI_NUM_MSG_CAT",N2);
					
				}
				break;
			case 5: //help
				{

						 
				DisplayMessageBox(oPC,0,HELP_MSG,"","",FALSE,"SCREEN_MESSAGEBOX_REPORT",0,"",0,"");
				}
				break;	

		}
}
