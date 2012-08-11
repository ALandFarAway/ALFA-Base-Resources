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
const string DATABASE = "DMFI_DB_BULLETIN";
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
	if (nKat==3) {sMsg = sMsg+"Guild/Factions";}
	if (nKat==4) {sMsg = sMsg+"Shows";}
	if (nKat==5) {sMsg = sMsg+"Sells";}
	if (nKat==6) {sMsg = sMsg+"Announcements";}
	
	return sMsg;
	//else return "General";
}

void WriteDatabase(string sTitle, string sBody, object oPC)
{
	int iIndex = GetCampaignInt(DATABASE,"Index");
	int iCat = GetLocalInt(oPC,"DMFI_NUM_MSG_CAT");
	if (iCat <1) iCat =1;
	string sName = GetName(oPC);
	string sPlayer = GetPCPlayerName(oPC);
	iIndex = iIndex+1;
	string sIndex = IntToString(iIndex);
	
	SetCampaignInt(DATABASE,"Index",iIndex);
	SetCampaignString(DATABASE,"Title_"+sIndex,sTitle);
	SetCampaignInt(DATABASE,"Category_"+sIndex,iCat);
	SetCampaignString(DATABASE,"Body_"+sIndex,sBody);
	SetCampaignString(DATABASE,"Name_"+sIndex,sName);
	SetCampaignString(DATABASE,"Player_"+sIndex,sPlayer);
	
	SendMessageToPC(oPC,"Sucessfully added");
}

void ReplyDatabase(string sTitle, string sBody, object oPC)
{
	object oBoard = GetNearestObjectByTag(BOARD_OBJECT,oPC);
	int iIndex = GetCampaignInt(DATABASE,"Index");
    string sName = GetName(oPC);
	string sPlayer = GetPCPlayerName(oPC);
	int iMsg = GetLocalInt(oPC,"BBOARD_VIEWING");
	int iRes = (iIndex+1)-iMsg;
	
	string sMsg = GetLocalString(oBoard,"Body_"+IntToString(iMsg));
	sMsg = sMsg+"\n\n<i>Reply from "+sName+" - "+sPlayer+"\n"+sTitle+"\n     "+sBody+".</i>";
	SetCampaignString(DATABASE,"Body_"+IntToString(iRes),sMsg);
	
	SendMessageToPC(oPC,"Sucessfully replied");
}

void ReadDatabase(object oPC)
{
    object oBoard = GetNearestObjectByTag(BOARD_OBJECT,oPC);
    int iIndex = GetCampaignInt(DATABASE,"Index");

	if (iIndex == 0) iIndex=1;
	
	int j;
	string sTitle, sBody, sName, sPlayer;
	int Z = 1;
	for (j=iIndex; j>=iIndex-15 ; j--)
		{
		if (j==0) return;
		
		string sZ = IntToString(Z);
		string sJ = IntToString(j);
		sTitle = GetCampaignString(DATABASE,"Title_"+sJ);
		sBody = GetCampaignString(DATABASE,"Body_"+sJ);
		sName = GetCampaignString(DATABASE,"Name_"+sJ);
		sPlayer = GetCampaignString(DATABASE,"Player_"+sJ);
		
		int iCatz = GetCampaignInt(DATABASE,"Category_"+sJ);
		
		SetLocalString(oBoard,"Title_"+sZ,sTitle);
		SetLocalString(oBoard,"Body_"+sZ,sBody);
		SetLocalString(oBoard,"Name_"+sZ, sName);
		SetLocalString(oBoard,"Player_"+sZ, sPlayer);
		SetLocalInt(oBoard,"Category_"+sZ,iCatz);
		
		SetGUIObjectText(oPC,SCREEN_MSGBOARD,SLOT+sZ , -1,sTitle);
		SetGUITexture(oPC,SCREEN_MSGBOARD,SLOT+sZ,"board_cat_"+IntToString(iCatz)+".tga");
		//SendMessageToPC(oPC,"T"+sTitle);
		Z=Z+1;
		}
		//SendMessageToPC(oPC,"Sucessfully read");
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
							int iMsg = GetLocalInt(oPC,"BBOARD_VIEWING");
							int iIndex = GetCampaignInt(DATABASE,"Index");
							int iRes = (iIndex+1)-iMsg;
							SetCampaignString(DATABASE,"Body_"+IntToString(iRes),TXT_INQUISITION);
							SetCampaignString(DATABASE,"Title_"+IntToString(iRes),TXT_INQUISITION);
							CloseGUIScreen(oPC,SCREEN_MSGBOARD);
							SendMessageToPC(oPC,"Succesfully censored");
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
					
					sFin = sCat+"\n\n<Color=Black><b>"+sTitle+"</b> \n    by "+sName+" - "+sPlayer+".\n\n <i>"+sBody+".</i></color>";
					
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