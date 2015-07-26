////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_command - DM Friendly Initiative - Code for .Commands
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious          2/2/7	Qk 10/07/07
//						AcadiusLost		   7/12/2009  Undercommon bug fix
//						Wynna			   8/6/2009 Travel Map Followoff functions
//						FoamBats4All	   4/9/2012	Restricted travel map paralysis to 2.0 seconds.
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "dmfi_inc_tool"
#include "dmfi_inc_inc_com"
#include "dmfi_inc_initial"
#include "dmfi_inc_langexe"
#include "dmfi_inc_lang"
#include "acr_travelmap_i"
#include "acr_db_persist_i"

int DMFI_RunCommandCode(object oTool, object oPC, string sOriginal)
{
// ***************************** COMMAND CODE **********************************
  int nTest;
  int nLength;
  int nNum;
  int n;
  int nLastVFX;
  int nItemProp;
  int nEffect;
  int bNumber;
  int nMusic;
  int nAbility = -1;
  int nWeather;

  string sHeard;
  string sTest;
  string sTool;
  string sCommandParam1Param2;
  string sCommand;
  string sParam1;
  string sParam2;
  string sRemains;
  string sLang;
  string sSkill;
  string sDice;
  string sVFXLabel;
  string sName;
  string sMessage;
  string sRef;
  string sPage;
  string sName1;
  string sName2;
  string sName3;
  string sName4;
  string sUParam1;
  string sSound;
  string sSoundName;
  string sConvertUsing;
  string sUTool;
  string sUCommand;
  string sLabel;
  string sDelay;
  string sLoc;

  object oSpeaker;
  object oTarget;
  object oItemTarget;
  object oTest;
  object oFollowTarget;
  object oName1;
  object oName2;
  object oName3;
  object oName4;
  object oEffectTarget;
  object oArea;
  object oStorage;
  object oSound;
  object oPossess;
  object oTargetTool;
  object oRef;

  float fNum;
  float fTime;
  location lTargetLoc;
  effect eEffect;
  effect eVFX;
  vector vTarget;
  itemproperty ipProp;

  sHeard = GetStringLowerCase(sOriginal);
  oTarget = GetLocalObject(oTool, DMFI_TARGET);
  lTargetLoc = GetLocalLocation(oTool, DMFI_TARGET_LOC);
  //oItemTarget = GetLocalObject(oTool, DMFI_ITEM_TARGET);
  oItemTarget = oTarget;
  oSpeaker = GetLocalObject(oTool, DMFI_SPEAKER);
    
  sTool = GetLocalString(oPC, DMFI_sTool);
  sCommand = GetLocalString(oPC, DMFI_sCommand);
  sParam1 = GetLocalString(oPC, DMFI_sParam1);
  sParam2 = GetLocalString(oPC, DMFI_sParam2);

//***************************************************************************
// Format Note: .set target right here
//
//              sTool = .set
//              sCommand = target
//              sParam1 = right
//              sParam2 = here


// *****************************************************************************
// PLAYER CAPABLE COMMANDS
// *****************************************************************************
    
	if (sTool==PRM_UI)
	{
		if (!DMFI_GetIsDM(oPC))
		{  // PC side
			if (GetLocalInt(oPC, DMFI_PC_UI_STATE))
			{
				CloseGUIScreen(oPC, SCREEN_DMFI_PLAYER);
				DeleteLocalInt(oPC, DMFI_PC_UI_STATE);
			}	
			else
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_PLAYER, FALSE, "dmfiplayerui.xml");
				SetLocalInt(oPC, DMFI_PC_UI_STATE, TRUE);
			}
		}
		else
		{ // DM Side
			if (GetLocalInt(oPC, DMFI_PC_UI_STATE)==1)
			{
				CloseGUIScreen(oPC, SCREEN_DMFI_DM);
				CloseGUIScreen(oPC, SCREEN_DMFI_BATTLE);
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 2);
			}	
			else if (GetLocalInt(oPC, DMFI_PC_UI_STATE)==0)
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_DM, FALSE, "dmfidmui.xml");
				//DisplayGuiScreen(oPC, SCREEN_DMFI_BATTLE, FALSE, "dmfibattle.xml");
				DisplayGuiScreen(oPC, SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 1);
			}
			else if (GetLocalInt(oPC, DMFI_PC_UI_STATE)==2)
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_DM, FALSE, "dmfidmui.xml");
				CloseGUIScreen(oPC, SCREEN_DMFI_TRGTOOL);	
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 3);
			}
			else
			{
				DisplayGuiScreen(oPC, SCREEN_DMFI_TRGTOOL, FALSE, "dmfitrgtool.xml");
				CloseGUIScreen(oPC, SCREEN_DMFI_DM);
				SetLocalInt(oPC, DMFI_PC_UI_STATE, 0);
			}	
							
		}
	}			
    else if (sHeard== PRM_FOLLOW + PRM_ + PRM_ON)
    {  
        ACR_IncrementStatistic("DMFI_FOLLOW");
        if (DMFI_FOLLOWOFF)
        {
            if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (oTarget!=oPC) && (GetIsPC(GetControlledCharacter(oTarget)) == TRUE))
            {
                SetLocalObject(oTool, DMFI_FOLLOW, oTarget);
                DMFI_Follow(oPC);
                SendText(oPC, TXT_FOLLOW_ON + GetName(oTarget), TRUE, COLOR_GREEN);
                DisplayGuiScreen(oPC, SCREEN_DMFI_FOLLOWOFF, FALSE, "dmfifollowoff.xml");
            }
            else
            {
                SendText(oPC, TXT_CREATURE_PC_ONLY, TRUE, COLOR_RED);
            }
        }	
        else
        {
            if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (oTarget!=oPC) && (GetIsPC(GetControlledCharacter(oTarget)) == TRUE))
            {
                AssignCommand(oPC, ClearAllActions(TRUE));
                AssignCommand(oPC, ActionForceMoveToObject(oTarget, TRUE, 1.5));
                SendText(oPC, TXT_FOLLOW_ON + GetName(oTarget), TRUE, COLOR_GREEN);	
            }
            else 
                SendText(oPC, TXT_CREATURE_PC_ONLY, TRUE, COLOR_RED);
        }	
    }
    else if (sHeard== PRM_FOLLOW + PRM_ + PRM_OFF)
    {
	 	object oMyArea = GetArea(oPC);
        DeleteLocalObject(oTool, DMFI_FOLLOW);
        AssignCommand(oPC, ClearAllActions(TRUE));
		CloseGUIScreen(oPC, SCREEN_DMFI_FOLLOWOFF);
        SendText(oPC, TXT_FOLLOW_OFF, TRUE, COLOR_GREEN);
		if (TravelMap_IsTravelMapArea(oMyArea))
		{
          ACR_IncrementStatistic("TRAVEL_MAP_REST_STOP");
          SendText(oPC, "You signal your party to step off the road.", TRUE, COLOR_GREEN);
			 object oPartyLeader = GetFactionLeader(oPC);
			 object oPCDestination = GetLocalObject(oPC, "oPCDestination");
			 DelayCommand(10.0, JumpPartyToArea(oPartyLeader, oPCDestination));
			 object oPartyMember = GetFirstFactionMember(oPartyLeader, TRUE);
			 effect eFreeze = EffectParalyze(50, SAVING_THROW_WILL, FALSE);

			 while (oPartyMember != OBJECT_INVALID)
			 {
				if(oPartyMember != oPC)
				{
					SendText(oPartyMember, "A member of your party signals a wish to step off the road.", TRUE, COLOR_GREEN);
					AssignCommand(oMyArea, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oPartyMember,2.0f));
				}

				oPartyMember = GetNextFactionMember(oPartyLeader, TRUE);
			 }
		}
    }
    else if (sTool==PRM_LANGUAGE)
    {
        if (sCommand==PRM_OFF)
        {
			DMFI_LanguageOff(oPC);
		}	
        else
        {
            if ((!DMFI_PCLANGUAGES_ENABLED) && (!DMFI_GetIsDM(oPC)))
			{
				SendText(oPC, TXT_PC_LANG_DISABLED, TRUE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}	
		
			bNumber = DMFI_IsNumber(sCommand);
            if (bNumber)
                sCommand = GetLocalString(oTool, DMFI_STRING_LANGUAGE + sCommand);
			
            sConvertUsing = DMFI_NewLanguage(sCommand);
            nTest = DMFI_IsLanguageKnown(oPC, sCommand);
            ACR_IncrementStatistic("DMFI_LANGUAGE_UI");
				
            if (DMFI_GetIsDM(oPC) || nTest)
            { // valid language and can speak it.
				SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, sCommand);
				DisplayGuiScreen(oPC, SCREEN_DMFI_TEXT, FALSE, "dmfitext.xml");				
				SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "Language", -1, DMFI_CapitalizeWord(sCommand) + ":");
				
			} // valid language and can speak it.
        }
    }
    else if (sTool== PRM_ROLL)
    { //.roll
        sSkill = DMFI_FindPartialSkill(sCommand);
		//SendText(oPC, "DEBUG: sTool / sSkill: " + sTool + " :: " + sCommand);
		if (DMFI_GetIsDM(oPC))
		{//DM Code
			if (oSpeaker!=oPC)
				oTest = oSpeaker;
			else 
				oTest = oTarget;
			if (!GetIsObjectValid(oTest))
			{
				oTest=oPC;
				SendText(oPC, TXT_TARGET_TEMP);
			}			
			if (sSkill!="")
			{
				SetLocalString(oTool, DMFI_LAST_ROLL, sSkill);			
				SetLocalObject(oTool, DMFI_LAST_ROLLER, oTest);
                DMFI_RollCheck(oTest, sSkill, TRUE, oPC, oTool);
			}
			else
				DMFI_RollBones(oPC, oTest, sCommand);	
		}
		else
		{// PC Code
			if (sSkill!="")
			{
				SetLocalString(oTool, DMFI_LAST_ROLL, sSkill);	
				SetLocalObject(oTool, DMFI_LAST_ROLLER, oSpeaker);
                DMFI_RollCheck(oSpeaker, sSkill, FALSE, OBJECT_INVALID, oTool);
				
			}
			else
				DMFI_RollBones(oSpeaker, oTarget, sCommand);
		}			
	}//close .roll	
   
    else if (sTool==PRM_RENAME)
    {// Set Original Case Sensitive Name
       	DMFI_RenameObject(oPC, oTarget);
	}// Set Original Case Sensitive Name
	
	else if (sTool==PRM_GRANT)
    {
        if (!DMFI_GetIsDM(oPC))
		{
			n = GetLocalInt(oPC, DMFI_CHOOSE);
			if (n>0)
			{
				SetLocalInt(oPC, DMFI_CHOOSE, n-1);
				DMFI_GrantLanguage(oPC, sCommand);
				
				if (n>1)	
					SetGUIObjectText(oPC, SCREEN_DMFI_CHOOSE, "DMListTitle", -1, CV_PROMPT_CHOOSE + IntToString(n-1));
				else
					CloseGUIScreen(oPC, SCREEN_DMFI_CHOOSE);	
			}	
			else
				SendText(oPC, "DMFI ERROR", FALSE, COLOR_RED);
		}		
		else
		{
			if (!GetIsPC(oTarget))
			{
				SendText(oPC, TXT_PC_REQ, FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		
		    DMFI_GrantLanguage(oTarget, sCommand);
	        SendText(oPC, TXT_LANGUAGE + DMFI_CapitalizeWord(sCommand) + PRM_ + TXT_TARGET + GetName(oTarget), TRUE, COLOR_GREEN);
	    }	
    }
	
	

// *****************************************************************************
// DM ONLY CODE BEGINS
// *****************************************************************************

  else
  {
    if (!DMFI_GetIsDM(oPC)) return DMFI_STATE_SUCCESS;
	
	if (sTool==PRM_VOICE)
	{
		sTest = GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
		if (sTest=="") sTest = LNG_COMMON;
		SetGUIObjectText(oPC, SCREEN_DMFI_TEXT, "Language", -1, DMFI_CapitalizeWord(sTest) + ":");
		DisplayGuiScreen(oPC, SCREEN_DMFI_TEXT, FALSE, "dmfitext.xml");
      ACR_IncrementStatistic("DMFI_DM_LANGUAGE_UI");
	}
	
    else if (sTool ==  PRM_INITIALIZE)
    {
        if (FindSubString(sHeard, PRM_LANGUAGE)!=-1)
        {
			// NOTE:  Only place in the code right now where we transfer
			// the targets tool.
			CloseGUIScreen(oTarget, SCREEN_DMFI_TEXT);
			oTargetTool=DMFI_GetTool(oTarget);
			DeleteLocalInt(oTargetTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
			SendText(oTarget, TXT_LANGUAGES_RESET, TRUE, COLOR_GREY);
			SendText(oPC, TXT_LANGUAGES_DMRESET, TRUE, COLOR_GREY); 
			DelayCommand(2.0, DMFI_InitializeLanguage(oTarget, oTargetTool, oPC));
        }	
	    else if (sCommand == PRM_PLUGINS)
        	DMFI_InitializePlugins(oPC);
        else if (sCommand == PRM_SERVER)
            DMFI_InitializeTool(oPC, oTool);
    }
    else if ((sTool==PRM_LIST) && (sCommand==PRM_LANGUAGE))
    {
		if (!GetIsPC(oTarget))
			{
				SendText(oPC, TXT_PC_REQ, FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		 
	  	DMFI_ListLanguages(oPC, oTarget);
	}
    else if (sTool==PRM_COPY)
    {
        if (sCommand==PRM_PC)
        {
            SetLocalObject(oTool, DMFI_STORE + IntToString(1), oTarget);
            SendText(oPC, TXT_STORE_PC, TRUE, COLOR_GREEN);
        }
        else if (sCommand==PRM_PARTY)
        {
            if (!GetIsPC(oTarget))
			{
				SendText(oPC, TXT_PC_REQ, FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		
			n=0;
            oName1 = GetFirstFactionMember(oTarget, TRUE);
            while (oName1!=OBJECT_INVALID)
            {
                n++;
                SetLocalObject(oTool, DMFI_STORE + IntToString(n), oName1);
                oName1 = GetNextFactionMember(oTarget, TRUE);
            }
            SendText(oPC, TXT_STORE_PARTY, TRUE, COLOR_GREEN);
        }
        else
            SendText(oPC, TXT_PC_PARTY, FALSE, COLOR_RED);
    }
    else if (sTool==PRM_PASTE)
    {
       	n=1;
        oTest = GetLocalObject(oTool, DMFI_STORE + IntToString(n));
        if (GetIsObjectValid(oTest))
		{
			while (oTest!=OBJECT_INVALID)
	        {
	           // oName1 = CopyObject(oTest, GetLocation(oPC));
	           // n++;
	           // oTest = GetLocalObject(oTool, DMFI_STORE + IntToString(n));
			   // Qk: Fix for NWN2 v1.10 thx to Dragonsbane
               string sTag = "some_random_tag_" + IntToString(Random(65536)); 
          	   CopyObject(oTest, GetLocation(oPC), OBJECT_INVALID, sTag); 
               oName1 = GetNearestObjectByTag(sTag, oPC); 
               // End Update  
               n++; 
               oTest = GetLocalObject(oTool, DMFI_STORE + IntToString(n)); 
	        }
	        SendText(oPC, TXT_RECALL, TRUE, COLOR_GREEN);
		}
		else
			SendText(oPC, TXT_CLIPBOARD_EMPTY, FALSE, COLOR_RED);	
    }
    else if (sTool==PRM_BOOT)
    {
        if ((!GetIsPC(oTarget)) || (DMFI_GetIsDM(oTarget)))
		{
			SendText(oPC, TXT_PC_REQ, FALSE, COLOR_RED);
			return DMFI_STATE_ERROR;
		}
		
		BootPC(oTarget);
        SendText(oPC, TXT_BOOTED + GetName(oTarget), TRUE, COLOR_RED);
        WriteTimestampedLogEntry(TXT_DM_ACTION + GetName(oPC) + TXT_BOOTED + GetName(oTarget));
    }
    else if (sHeard== PRM_RELOAD)
    {
        StartNewModule(MOD_NAME);
        return DMFI_STATE_SUCCESS;
    }
    
// REPEAT COMMANDS
    else if (sTool== PRM_REPEAT)
    {
       if (sCommand==PRM_ROLL)
       {
            sSkill = GetLocalString(oTool, DMFI_LAST_ROLL);
            oTest = GetLocalObject(oTool, DMFI_LAST_ROLLER);

            if (!DMFI_GetIsDM(oPC))
                DMFI_RollCheck(oTest, sSkill);
            else
                DMFI_RollCheck(oTarget, sSkill, TRUE, oPC, oTool);  // editted to use target
       }
       else if (sCommand==PRM_VFX)
       {
       		if (DMFI_IsNumber(sParam1) && (StringToInt(sParam1)<11))
			{
				nLastVFX = GetLocalInt(oTool, DMFI_VFX_RECENT + sParam1);
				sVFXLabel = Get2DAString(DMFI_2DA_VFX, DMFI_2DA_COLUMN, nLastVFX);
				DMFI_CreateVFX(oTool, oSpeaker, sVFXLabel, IntToString(nLastVFX));
				SendText(oPC, TXT_VFX_PLAYED + IntToString(nLastVFX) + TXT_VFX_LABEL + sVFXLabel, TRUE, COLOR_GREEN);
			}	   
	        else
			{
				nLastVFX = GetLocalInt(oTool, DMFI_VFX_LAST);
	            sVFXLabel = Get2DAString(DMFI_2DA_VFX, DMFI_2DA_COLUMN, nLastVFX);
	            DMFI_CreateVFX(oTool, oSpeaker, sVFXLabel, IntToString(nLastVFX));
				SendText(oPC, TXT_VFX_PLAYED + IntToString(nLastVFX) + TXT_VFX_LABEL + sVFXLabel, TRUE, COLOR_GREEN);
			}
       }
	   else if (sCommand==PRM_SOUND)
	   {
	   		sCommand = GetLocalString(oTool, DMFI_SOUND_LAST);
			sParam1 = GetLocalString(oTool, DMFI_SOUND_LAST_PRM);		
	   		DMFI_CreateSound(oTool, oPC, oTarget, oSpeaker, lTargetLoc, sCommand, sParam1);
	   }	

    }
// REPORT COMMANDS
    else if (sTool==PRM_REPORT)
    {
        if ((sCommand==PRM_GOLD) || (sCommand==PRM_NETWORTH) || (sCommand==PRM_XP))
            DMFI_Report(oPC, oTool, sCommand);
        else if (sCommand==PRM_INFORMATION)
        {
            if (GetIsPC(oTarget))
            {
                SendText(oPC, TXT_TARGET + GetName(oTarget));
                SendText(oPC, TXT_PLAYERNAME + GetPCPlayerName(oTarget));
                SendText(oPC, TXT_CDKEY + GetPCPublicCDKey(oTarget));
                SendText(oPC, TXT_IPADRESS + GetPCIPAddress(oTarget));
                PrintString(TXT_TARGET + GetName(oTarget) +
                            TXT_PLAYERNAME + GetPCPlayerName(oTarget) +
                            TXT_CDKEY + GetPCPublicCDKey(oTarget) +
                            TXT_IPADRESS + GetPCIPAddress(oTarget));

            }
            else
                SendText(oPC, TXT_PC_REQ, FALSE, COLOR_RED);
        }
        else
            SendText(oPC, TXT_GOLD_NETWORTH_XP_INFO, FALSE, COLOR_RED);

    }
// INVENTORY COMMANDS
    else if (sTool== PRM_INVENTORY)
    {
        if (sCommand==PRM_IDENTIFY)
        {
            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
                DMFI_IdentifyInventory(oTarget, oPC);

            else
                SendText(oPC, TXT_CREATURE, FALSE, COLOR_RED);
        }
        else if (sCommand==PRM_STRIP)
        {
            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
                DMFI_StripInventory(oTarget, oPC);

            else
                SendText(oPC, TXT_CREATURE, FALSE, COLOR_RED);
        }
        else if (sCommand==PRM_UBER)
        {
            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
            {
                bNumber = DMFI_IsNumber(sParam1);
                if (bNumber)
                    DMFI_RemoveUber(oPC, oTarget, sParam1);
				else
					DMFI_RemoveUber(oPC, oTarget, IntToString(GetHitDice(oTarget)));	
            }
            else
                SendText(oPC, TXT_CREATURE, FALSE, COLOR_RED);
        }
		else if (sCommand==PRM_MANAGE)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
			   {
			    if (oTarget != oPC) //QK: Manage inventory to yourself caused an infinite loop
                	DMFI_ManageInventory(oTarget, oPC);
				else
					SendText(oPC,TXT_NOTDMEQUAL, FALSE, COLOR_RED);
				}
            else
                SendText(oPC, TXT_CREATURE, FALSE, COLOR_RED);
		}		

    }

// ********************* REMOVE EFFECTS / ITEM PROPERTIES **********************

    else if (sTool == PRM_REMOVE)
    {
        if (sCommand == PRM_ITEMPROP)
        {
            if (GetObjectType(oItemTarget)==OBJECT_TYPE_ITEM)
            {
                sPage = PG_TARGET_ITEMPROP;
                nItemProp = GetIntElement(StringToInt(sParam2), sPage, oTool);
                ipProp = GetFirstItemProperty(oTarget);
                while (GetIsItemPropertyValid(ipProp))
                {
                    nTest = GetItemPropertyType(ipProp);
                    if (nTest==nItemProp)
                    {
                        RemoveItemProperty(oTarget, ipProp);
                        SendText(oPC, TXT_ITEMPROP_REMOVED, TRUE, COLOR_GREEN);
                        break;
                    }
                    ipProp = GetNextItemProperty(oTarget);
                }
            }
            else
            {
                SendText(oPC, TXT_PARAM_MISSING + TXT_ITEM, FALSE, COLOR_BLUE);
                return DMFI_STATE_ERROR;
            }
        }
        else if (sCommand == PRM_EFFECT)
        {
            oEffectTarget = oTarget;
            if (oEffectTarget!=OBJECT_INVALID)
            {
                sPage = PG_TARGET_EFFECT;
                nEffect = GetIntElement(StringToInt(sParam1), sPage, oTool);
                eEffect = GetFirstEffect(oEffectTarget);
                while (GetIsEffectValid(eEffect))
                {
                    nTest = GetEffectType(eEffect);
                    if (nTest==nEffect)
                    {
                        RemoveEffect(oTarget, eEffect);
                        SendText(oPC, TXT_EFFECT_REMOVED, TRUE, COLOR_GREEN);
                        break;
                    }
                    eEffect = GetNextEffect(oTarget);
                }
            }
        }
        else if (sCommand==PRM_LANGUAGE)
        {
            if (!GetIsPC(oTarget))
			{
				SendText(oPC, TXT_PC_REQ, FALSE, COLOR_RED);
				return DMFI_STATE_ERROR;
			}		
			DMFI_RemoveLanguage(oTarget, sParam1);
            SendText(oPC, TXT_LANGUAGE_REMOVED + sCommand + PRM_ + TXT_TARGET + GetName(oTarget), TRUE, COLOR_GREEN);
        }
    }

// SET COMMANDS
    else if (sTool== PRM_SET)
    {

// SET DICEBAG PREFERENCES
        if (sCommand==PRM_DC)
        {// SET DC for Dicebag
            bNumber = DMFI_IsNumber(sParam1);
            if (bNumber)
            {
                DMFI_UpdateNumberToken(oTool, PRM_DC, sParam1);
            }
            else
            {
                SetLocalString( oPC, DLG_PAGE_ID, PG_LIST_50);
                StartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return DMFI_STATE_ERROR;
            }
        }// SET DC for Dicebag
// SET MUSIC
        else if (FindSubString(sHeard, PRM_MUSIC)!=-1)
        {
            bNumber = DMFI_IsNumber(sParam2);
            if (bNumber)
            {// sParam is an INT
                DMFI_InitializeAreaMusic(oPC);
                oArea = GetArea(oPC);

                sSound = Get2DAString(DMFI_2DA_MUSIC, DMFI_2DA_COL_DESCRIPT, StringToInt(sParam2));
                sSoundName = GetStringByStrRef(StringToInt(sSound));

                if (FindSubString(sHeard, PRM_DAY)!=-1)
                {
                    MusicBackgroundChangeDay(oArea, StringToInt(sParam2));
					MusicBackgroundStop(oArea);
                    SendText(oPC, TXT_SET_MUSIC_DAY + sSoundName, TRUE, COLOR_GREEN);
                }
                else if (FindSubString(sHeard, PRM_NIGHT)!=-1)
                {
                   	MusicBackgroundChangeNight(oArea, StringToInt(sParam2));
					MusicBackgroundStop(oArea);
                    SendText(oPC, TXT_SET_MUSIC_NIGHT + sSoundName, TRUE, COLOR_GREEN);
                }
                else if (FindSubString(sHeard, PRM_BOTH)!=-1)
                {
                   	MusicBackgroundChangeDay(oArea, StringToInt(sParam2));
                    MusicBackgroundChangeNight(oArea, StringToInt(sParam2));
					MusicBackgroundStop(oArea);
                    SendText(oPC, TXT_SET_MUSIC_BOTH + sSoundName, TRUE, COLOR_GREEN);
                }
                else if (FindSubString(sHeard, PRM_BATTLE)!=-1)
                {
                    MusicBattleChange(oArea, StringToInt(sParam2));
					SendText(oPC, TXT_SET_MUSIC_BATTLE + sSoundName, TRUE, COLOR_GREEN);
                }
            }// sParam2 is an INT
            else if (sParam2=="")
            {// No valid sParam2
                if ((sParam1!=PRM_DAY) && (sParam1!=PRM_NIGHT) && (sParam1!=PRM_BOTH) &&(sParam1!=PRM_BATTLE))
                {
                    SendText(oPC, TXT_PARAM_MISSING + TXT_DAY_NIGHT_BATTLE, FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                }
                SetLocalString( oPC, DLG_PAGE_ID, PG_MUSIC_CATEGORY);
                StartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return DMFI_STATE_SUCCESS;
            }
            
        }// CONFIGURE MUSIC SETTINGS
// SET AMBIENT
        else if (FindSubString(sHeard, PRM_AMBIENT)!=-1)
        {
            bNumber = DMFI_IsNumber(sParam2);
            if (bNumber)
            { // int valid
            	if (FindSubString(sHeard, PRM_VOL)!=-1)
				{
					if (StringToInt(sParam2)>100)
						sParam2="100";
					AmbientSoundSetDayVolume(GetArea(oPC), StringToInt(sParam2));
					AmbientSoundSetNightVolume(GetArea(oPC), StringToInt(sParam2));
					SetLocalString(oTool, DMFI_AMBIENT_VOLUME, sParam2);
					SendText(oPC, TXT_SET_AMBIENT_VOLUME + sParam2, TRUE, COLOR_GREEN);
					//SetGUIObjectText(oPC, SCREEN_DMFI_AMBTOOL, "ambvol", -1, sParam2);
				}
				else
				{			
				    oArea = GetArea(oPC);
	                sSound = Get2DAString(DMFI_2DA_AMBIENT, DMFI_2DA_COL_DESCRIPT, StringToInt(sParam2));
	                sSoundName = GetStringByStrRef(StringToInt(sSound));
	                if (FindSubString(sHeard, PRM_DAY)!=-1)
	                {
	                    AmbientSoundStop(oArea);
	                    AmbientSoundChangeDay(oArea, StringToInt(sParam2));
						nNum = StringToInt(GetLocalString(oTool, DMFI_AMBIENT_VOLUME));
						AmbientSoundSetDayVolume(oArea, nNum);
	                    DelayCommand(2.0, AmbientSoundPlay(oArea));
	                    SendText(oPC, TXT_SET_AMBIENT_DAY + sSoundName, TRUE, COLOR_GREEN);
	                }
	                else if (FindSubString(sHeard, PRM_NIGHT)!=-1)
	                {
	                    AmbientSoundStop(oArea);
	                    AmbientSoundChangeNight(oArea, StringToInt(sParam2));
						nNum = StringToInt(GetLocalString(oTool, DMFI_AMBIENT_VOLUME));
						AmbientSoundSetNightVolume(oArea, nNum);
	                    DelayCommand(2.0, AmbientSoundPlay(oArea));
	                    SendText(oPC, TXT_SET_AMBIENT_NIGHT + sSoundName, TRUE, COLOR_GREEN);
	                }
				}	
            } // int valid
            else if (sParam2=="")
            {
                if ((sParam1!=PRM_DAY) && (sParam1!=PRM_NIGHT))
                { // return if sParam1 not valid
                    SendText(oPC, TXT_PARAM_MISSING + TXT_DAY_NIGHT, FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                } // return if sParam1 not valid
                SetLocalString( oPC, DLG_PAGE_ID, PG_AMBIENT_CATEGORY);
                StartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return DMFI_STATE_SUCCESS;
            }
        }
// SET SOUND
        else if (FindSubString(sHeard, PRM_SOUND)!=-1)
        {
            if (FindSubString(sHeard, PRM_DELAY)!=-1)
            { // DELAY
                if (DMFI_IsNumber(sParam2))
                {// valid command            
                    SetLocalString(oTool, DMFI_SOUND_DELAY, sParam2);
                    SendText(oPC, TXT_SET_SOUND_DELAY + sParam2, TRUE, COLOR_GREEN);
					//SetGUIObjectText(oPC, SCREEN_DMFI_SNDTOOL, "sounddelay", -1, sParam2);
                }
                else
                {
                    SendText(oPC, TXT_PARAM_MISSING + TXT_INT, FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                }
            } // DELAY
           
        }
// SET VFX
        else if (FindSubString(sHeard, PRM_VFX)!=-1)
        {
            if (FindSubString(sHeard, PRM_DUR)!=-1)
            { // DURATION
                if (DMFI_IsNumber(sParam2))
                {// valid command            {
                    SetLocalString(oTool, DMFI_VFX_DURATION, sParam2);
                    SendText(oPC, TXT_SET_VFX_DURATION + sParam2, TRUE, COLOR_GREEN);
					//SetGUIObjectText(oPC, SCREEN_DMFI_VFXTOOL, "changedur", -1, sParam2);
					//CloseGUIScreen(oPC, SCREEN_DMFI_DMLIST);
                }
                else
                {
                    SendText(oPC, TXT_PARAM_MISSING + TXT_INT, FALSE, COLOR_BLUE);
                    return DMFI_STATE_ERROR;
                }
            } // DURATION
        }
    	else if (sCommand==PRM_DESCRIPTION)
		{ // SetDescription not functioning properly
			SetDescription(oTarget, sParam1 + " " + sParam2);
			SendText(oPC, TXT_SET_DESCRIPTION + sParam1 + " " + sParam2, TRUE, COLOR_GREEN);
			//SendText(oPC, "DEBUG: Description: " + GetDescription(oTarget));
		}	
	}//CLOSE .set
	
// TOGGLE PREFERENCES

    else if (sTool== PRM_TOGGLE)
    {
       DMFI_TogglePreferences(oTool, sCommand);
    }

// TIME
    else if (sTool== PRM_TIME)
    {
            bNumber = DMFI_IsNumber(sCommand);
            if (bNumber)
            {
                nNum = GetTimeHour() + (StringToInt(sCommand) - GetTimeHour());
                SetTime(nNum, 0 , 0 , 0);
                if (nNum<0) nNum = nNum + 24;
                SendText(oPC, TXT_TIME + IntToString(nNum), TRUE, COLOR_GREEN);
            }
            else
            {
                SetLocalString( oPC, DLG_PAGE_ID, PG_LIST_50);
                StartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
                return DMFI_STATE_SUCCESS;
            }
    }

// WEATHER COMMANDS
  else if (sTool== PRM_WEATHER)
    {
			object oArea = GetArea(oPC);
            SetWeather(GetArea(oPC), WEATHER_TYPE_RAIN,-1);
            SendText(oPC, TXT_WEATHER_CLEAR, FALSE, COLOR_GREEN);
			SetLocalInt(oArea,"DMFI_WEATHER",-1);
    }
  else if (sTool == PRM_RAIN)
  	{
		object oArea = GetArea(oPC);
		nWeather = GetLocalInt(oArea,"DMFI_WEATHER");
		if (nWeather<0) nWeather=0;
		nWeather=nWeather+1;
		if (nWeather>5) nWeather=5;
		    SetWeather(oArea, WEATHER_TYPE_RAIN,nWeather);
            SendText(oPC, TXT_WEATHER_RAIN, FALSE, COLOR_GREEN);
			SetLocalInt(oArea,"DMFI_WEATHER",nWeather);
		
	}
	
   else if (sTool == PRM_NORAIN)
  	{ 
		object oArea = GetArea(oPC);
		nWeather = GetLocalInt(oArea,"DMFI_WEATHER");
		nWeather=nWeather-1;
    	if (nWeather<0) nWeather=0;
		    SetWeather(oArea, WEATHER_TYPE_RAIN,nWeather);
            SendText(oPC, TXT_WEATHER_CLEAR, FALSE, COLOR_GREEN);
		    SetLocalInt(oArea,"DMFI_WEATHER",nWeather);
	}

// MUSIC COMMANDS
    else if (sTool== PRM_MUSIC)
    {
        if (FindSubString(sHeard, PRM_PLAY)!=-1)
        {
            //MusicBattleStop(GetArea(oPC));
			MusicBackgroundSetDelay(GetArea(oPC), 999999);
			MusicBackgroundPlay(GetArea(oPC));
            SendText(oPC, TXT_MUSIC_BACKGROUND, TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, PRM_BATTLE)!=-1)
        {
            MusicBackgroundStop(GetArea(oPC));
			MusicBattlePlay(GetArea(oPC));
            SendText(oPC, TXT_MUSIC_BATTLE, TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, PRM_STOP)!=-1)
        {
            object oMyArea = GetArea(oPC);
						
			MusicBackgroundStop(oMyArea);
            MusicBattleStop(oMyArea);
			SendText(oPC, TXT_MUSIC_STOP, TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, PRM_RESTORE)!=-1)
        {
            oArea = GetArea(oPC);

            MusicBackgroundStop(oArea);
            MusicBattleStop(oArea);
            nMusic = GetLocalInt(oArea, DMFI_MUSIC_BATTLE);
            MusicBattleChange(oArea, nMusic);
            nMusic = GetLocalInt(oArea, DMFI_MUSIC_DAY);
            MusicBackgroundChangeDay(oArea, nMusic);
            nMusic = GetLocalInt(oArea, DMFI_MUSIC_NIGHT);
            MusicBackgroundChangeNight(oArea, nMusic);

            MusicBattleStop(oArea);
            MusicBackgroundStop(oArea);
            SendText(oPC, TXT_MUSIC_RESTORE, TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, PRM_DEFAULT)!=-1)
        {
            DeleteLocalInt(GetArea(oPC), DMFI_MUSIC_INITIALIZED);
            DMFI_InitializeAreaMusic(oPC);
            SendText(oPC, TXT_MUSIC_DEFAULT, TRUE, COLOR_GREEN);
        }
        else  SendText(oPC, TXT_PARAM_MISSING + TXT_BACK_BATTLE_STOP, FALSE, COLOR_BLUE);
    }
// AMBIENT COMMANDS
    else if (sTool== PRM_AMBIENT)
    {
        if (FindSubString(sHeard, PRM_PLAY)!=-1)
        {
            sTest = GetLocalString(oTool, DMFI_AMBIENT_VOLUME);
			AmbientSoundSetDayVolume(GetArea(oPC), StringToInt(sTest));
			AmbientSoundSetNightVolume(GetArea(oPC), StringToInt(sTest));
			AmbientSoundSetDayVolume(GetArea(oPC),100);
			AmbientSoundSetNightVolume(GetArea(oPC), 100);
			
			//AmbientSoundPlay(GetArea(oPC));
            SendText(oPC, TXT_AMBIENT_PLAY, TRUE, COLOR_GREEN);
        }
        else if (FindSubString(sHeard, PRM_STOP)!=-1)
        {
            //AmbientSoundStop(GetArea(oPC));
			AmbientSoundSetDayVolume(GetArea(oPC), 0);
			AmbientSoundSetNightVolume(GetArea(oPC), 0);
            SendText(oPC, TXT_AMBIENT_STOP, TRUE, COLOR_GREEN);
        }
    }

// VFX COMMANDS
     else if (sTool== PRM_VFX)
     {
        bNumber = DMFI_IsNumber(sCommand);
        if (bNumber)
        {
            sVFXLabel = Get2DAString(DMFI_2DA_VFX, DMFI_2DA_COLUMN, StringToInt(sCommand));
            DMFI_CreateVFX(oTool, oSpeaker, sVFXLabel, sCommand);

            SendText(oPC, TXT_VFX_PLAYED + sCommand + TXT_VFX_LABEL + sVFXLabel, TRUE, COLOR_GREEN);
            SetLocalInt(oTool, DMFI_VFX_LAST, StringToInt(sCommand));
			
			// Build list of recently used vfxs
			nNum = GetLocalInt(oTool, DMFI_VFX_RECENT);
			SetLocalInt(oTool, DMFI_VFX_RECENT + IntToString(nNum), StringToInt(sCommand));
			nNum++;
			if (nNum>29) nNum = 1;
			SetLocalInt(oTool, DMFI_VFX_RECENT, nNum);
		}
        else
        {
            SetLocalString(oPC, DLG_PAGE_ID,PG_VFX);
            StartDlg(oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return DMFI_STATE_SUCCESS;
        }
     }

// EFFECT ADDING COMMANDS
    else if (sTool== PRM_EFFECT)
    {
        if (FindSubString(sCommand, PRM_ABILITY_STRENGTH))
            nAbility = ABILITY_STRENGTH;
        else if (FindSubString(sCommand, PRM_ABILITY_DEXTERITY))
            nAbility = ABILITY_DEXTERITY;
        else if (FindSubString(sCommand, PRM_ABILITY_CONSTITUTION))
            nAbility = ABILITY_CONSTITUTION;
        else if (FindSubString(sCommand, PRM_ABILITY_INTELLIGENCE))
            nAbility = ABILITY_INTELLIGENCE;
        else if (FindSubString(sCommand, PRM_ABILITY_WISDOM))
            nAbility = ABILITY_WISDOM;
        else if (FindSubString(sCommand, PRM_ABILITY_CHARISMA))
            nAbility = ABILITY_CHARISMA;
        if (nAbility!=-1)
        {
            if (StringToInt(sParam1)<0)
                eEffect = EffectAbilityDecrease(nAbility, StringToInt(sParam1));
            else
                eEffect = EffectAbilityIncrease(nAbility, StringToInt(sParam1));
            if (GetIsEffectValid(eEffect))
            {
                bNumber = DMFI_IsNumber(sParam1);
                if (bNumber)
                    fTime = StringToFloat(sParam1);
                else
                    fTime = 30.0;

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fTime);
                SendText(oPC, TXT_EFFECT_APPLIED + sCommand, TRUE, COLOR_GREEN);
            }
            else
                SendText(oPC, TXT_EFFECT_ERROR, FALSE, COLOR_RED);
        }
        else if (sCommand!="")
        {
            if (FindSubString(sCommand, PRM_AC))
            {// AC EFFECT code block
                if (StringToInt(sParam1)<0)
                    eEffect = EffectACDecrease(StringToInt(sParam1));
                else
                    eEffect = EffectACIncrease(StringToInt(sParam1));
                if (GetIsEffectValid(eEffect))
                {
                    bNumber = DMFI_IsNumber(sParam1);
                    if (bNumber)
                        fTime = StringToFloat(sParam1);
                    else
                        fTime = 30.0;
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fTime);
                    SendText(oPC, TXT_EFFECT_APPLIED + sCommand, TRUE, COLOR_GREEN);
                }
                else
                    SendText(oPC, TXT_EFFECT_ERROR, FALSE, COLOR_RED);
            }// AC EFFECT code block
            else
                DMFI_CreateEffect(sCommand, sParam1, oPC, oTarget);
        }
    }
    else if (sTool== PRM_DISEASE)
    {
        bNumber = DMFI_IsNumber(sCommand);
        if (bNumber)
        {
            sLabel = Get2DAString(DMFI_2DA_DISEASE, DMFI_2DA_COLUMN, StringToInt(sCommand));
            eEffect = EffectDisease(StringToInt(sCommand));
            if (GetIsEffectValid(eEffect))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
                SendText(oPC, TXT_EFFECT_APPLIED + sLabel, TRUE, COLOR_GREEN);
            }
            else
                SendText(oPC, TXT_EFFECT_ERROR, FALSE, COLOR_RED);
        }
        else
        {
            SetLocalString(oPC, DLG_PAGE_ID,PG_LIST_DISEASE);
            StartDlg(oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return DMFI_STATE_SUCCESS;
        }
    }
    else if (sTool== PRM_POISON)
    {
        bNumber = DMFI_IsNumber(sCommand);
        if (bNumber)
        {
            sLabel = Get2DAString(DMFI_2DA_POISON, DMFI_2DA_COLUMN, StringToInt(sCommand));
            eEffect = EffectPoison(StringToInt(sCommand));
            if (GetIsEffectValid(eEffect))
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
                SendText(oPC, TXT_EFFECT_APPLIED + sLabel, TRUE, COLOR_GREEN);
            }
            else
                SendText(oPC, TXT_EFFECT_ERROR, FALSE, COLOR_RED);
        }
        else
        {
            SetLocalString(oPC, DLG_PAGE_ID,PG_LIST_DISEASE);
            StartDlg(oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return DMFI_STATE_SUCCESS;
        }
    }

// SOUND COMMANDS
	else if (sTool== PRM_SOUND)
    {
        bNumber = DMFI_IsNumber(sParam1);
        if (bNumber)
        {
            DMFI_CreateSound(oTool, oPC, oTarget, oSpeaker, lTargetLoc, sCommand, sParam1);
		    SetLocalString(oTool, DMFI_SOUND_LAST, sCommand);
			SetLocalString(oTool, DMFI_SOUND_LAST_PRM, sParam1);
        }
        else
        {
            SetLocalString( oPC, DLG_PAGE_ID, PG_LIST_SOUND);
            StartDlg( oPC, oTool, DMFI_EXE_CONV, TRUE, FALSE, FALSE );
            return DMFI_STATE_SUCCESS;
        }
     }

// MISC COMMANDS	 
	else if (sTool==PRM_FREEZE)
	{
		if ((GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) && (!DMFI_GetIsDM(oTarget)))
		{	
			eEffect = EffectCutsceneImmobilize();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0);
			eEffect = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0);
			SendText(oTarget, TXT_DM_FROZEN, TRUE, COLOR_RED);
			SendText(oPC, TXT_FROZEN, TRUE, COLOR_GREEN);
		}
		else
			SendText(oPC, TXT_CREATURE, FALSE, COLOR_RED);
	}
	else if (sTool==PRM_SCALE)
	{
		if (GetIsPC(oTarget))
		{
			SendText(oPC, TXT_NON_PC, FALSE, COLOR_RED);			
			return DMFI_STATE_ERROR;
		}
		if (DMFI_IsNumber(sCommand))
		{
			fNum = StringToFloat(sCommand);
			fNum = fNum/100.0;
			eEffect = EffectSetScale(fNum);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
			SendText(oPC, TXT_SCALE + sCommand, TRUE, COLOR_GREEN);
		}				 
	 }
	 else if (sTool==PRM_ITEM)
	 {
	  	if (GetIsObjectValid(oItemTarget))
		{
			if (sCommand==PRM_TOGGLE)
			{
				DMFI_ToggleItemPrefs(sHeard, oPC, oTarget);
				oRef = GetLocalObject(oTarget, DMFI_INVENTORY_TARGET);
				if (GetIsObjectValid(oRef) && DMFI_UPDATE_INVENTORY)
				{
					oTarget = GetItemPossessor(oRef);
					DelayCommand(1.0, DMFI_ManageInventory(oTarget, oPC));
				}	
			}
			else if (sCommand==PRM_IDENTIFY)
			{
				oRef = GetLocalObject(oItemTarget, DMFI_INVENTORY_TARGET);
				sTest = GetName(oItemTarget);
				SetIdentified(oItemTarget, TRUE);
				SetIdentified(oRef, TRUE);
				SendText(oPC, TXT_ITEM_IDENTIFIED + sTest, TRUE, COLOR_GREEN);	
				
				if (GetIsObjectValid(oRef) && DMFI_UPDATE_INVENTORY)
				{
					oTarget = GetItemPossessor(oRef);
					DelayCommand(1.0, DMFI_ManageInventory(oTarget, oPC));
				}	
				
			}
			else if (sCommand==PRM_TAKE)
			{
				if (GetItemPossessor(oItemTarget)!=oPC)
				{
					SendText(oPC, TXT_INVENTORY_ONLY, FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}			
				oRef = GetLocalObject(oItemTarget, DMFI_INVENTORY_TARGET);
				oTarget = GetItemPossessor(oRef);
				
				if ((!GetIsObjectValid(oRef)) || (!GetIsObjectValid(oTarget)))
				{
					SendText(oPC, TXT_INVENTORY_TARGET_INVALID, FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}
				sTest = GetName(oItemTarget);
				CopyItem(oItemTarget, oPC, TRUE);
				SetPlotFlag(oItemTarget, FALSE);
				DestroyObject(oItemTarget);
				SetPlotFlag(oRef, FALSE);
				DestroyObject(oRef);
				
				if (DMFI_UPDATE_INVENTORY)
					DelayCommand(1.0, DMFI_ManageInventory(oTarget, oPC));
					
				SendText(oPC, TXT_ITEM_TAKEN + sTest, TRUE, COLOR_GREEN);
    		}
			else if (sCommand==PRM_GIVE)
			{
				oTarget = GetLocalObject(oPC, DMFI_INVENTORY_TARGET);
				if (GetItemPossessor(oItemTarget)!=oPC)
				{
					SendText(oPC, TXT_INVENTORY_ONLY, FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}
				if (!GetIsObjectValid(oTarget))
				{
					SendText(oPC, TXT_INVENTORY_TARGET_INVALID, FALSE, COLOR_RED);
					return DMFI_STATE_ERROR;
				}
				if (!GetHasInventory(oItemTarget))				
					CopyItem(oItemTarget, oTarget, TRUE);
				else
				{
					oTest =	GetFirstItemInInventory(oItemTarget);
					if (!GetIsObjectValid(oTest))
					{
						SendText(oPC, TXT_ITEM_CONTAINER_ERROR, FALSE, COLOR_RED);
						return DMFI_STATE_ERROR;
					}
					
					while (GetIsObjectValid(oTest))
					{
						CopyItem(oTest, oTarget, TRUE);	
						oTest = GetNextItemInInventory(oItemTarget);
					}	
				}
				if (DMFI_UPDATE_INVENTORY)
					DMFI_ManageInventory(oTarget, oPC);
					
				SendText(oPC, TXT_ITEM_GIVE + GetName(oItemTarget), TRUE, COLOR_GREEN);
			}	
		}	
	}	  
	else if (sTool==PRM_FACTION)
	{
		if (GetIsPC(oTarget))
		{
			SendText(oPC, TXT_NON_PC, FALSE, COLOR_RED);			
			return DMFI_STATE_ERROR;
		}
		
		if (sCommand==PRM_HOSTILE)
			nTest = 0;
		else if (sCommand==PRM_COMMONER)
			nTest = 1;
		else if (sCommand==PRM_DEFENDER)
			nTest = 3;
		else if (sCommand==PRM_MERCHANT)
			nTest = 2;
		else 
		{
			SendText(oPC, TXT_DEFAULT_FACTION_REQ, FALSE, COLOR_RED);			
			return DMFI_STATE_ERROR;
		}
		AssignCommand(oTarget, ClearAllActions(TRUE));
		ChangeToStandardFaction(oTarget, nTest);
	
		SendText(oPC, TXT_FACTION_SET + sCommand, TRUE, COLOR_GREEN);
	}
	else if (sTool==PRM_BATTLE)
	{
		oArea = GetArea( oPC );
		if (sCommand==PRM_ON)
		{
			object oTarget = GetFirstObjectInArea( oArea );

			for ( oTarget = GetFirstObjectInArea( oArea ); GetIsObjectValid( oTarget ); oTarget = GetNextObjectInArea( oArea ) ) {
				// Is it something we want to make hostile?
				if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) continue;
				if ( GetIsPC( oTarget ) ) continue;
				if ( GetIsOwnedByPlayer( oTarget ) ) continue;
				if ( GetIsPlayerCreated( oTarget ) ) continue;
				
				// Set to hostile.
				AssignCommand( oTarget, ClearAllActions( TRUE ) );
				ChangeToStandardFaction( oTarget, STANDARD_FACTION_HOSTILE );
			}
			SendText( oPC, TXT_FACTION_HOSTILE, TRUE, COLOR_GREEN );
		}
		else 
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_COMMONER);
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			SendText(oPC, TXT_FACTION_COMMONER, TRUE, COLOR_GREEN);
		}	
	}	
	else if (sTool==PRM_FACING)
	{
		fNum = GetFacing(oPC);
		AssignCommand(oTarget, SetFacing(fNum));
	}
	else if (sTool==PRM_APPEARANCE)
	{
		if (sCommand=="-1")
			SetCreatureAppearanceType(oTarget, GetLocalInt(oTarget, DMFI_DEF_APP));
		else			
		{
			if (GetLocalInt(oTarget, DMFI_DEF_APP)==0)
				SetLocalInt(oTarget, DMFI_DEF_APP, GetAppearanceType(oTarget));
			
			SetCreatureAppearanceType(oTarget, StringToInt(sCommand));
			eVFX = EffectVisualEffect(896, FALSE);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oTarget));
		}
		SendText(oPC, TXT_APPEARANCE_SET + sCommand);
	}				  						
//Qk Addons 10/07
	else if (sTool==PRM_PLOTP)
	{
		if (GetObjectType(oTarget)!= OBJECT_TYPE_PLACEABLE)
			{
			SendText(oPC, TXT_NO_ASSOCIATE, FALSE, COLOR_RED);
			return DMFI_STATE_ERROR;
			}
		int bPlot = GetPlotFlag(oTarget);
		if (bPlot ==TRUE)
			{
			SetPlotFlag(oTarget,FALSE);
			SendText(oPC, TXT_PLOT+": False",FALSE,COLOR_GREEN);
			}
		else
			{
			SetPlotFlag(oTarget,TRUE);
			SendText(oPC, TXT_PLOT+": TRUE",FALSE,COLOR_GREEN);
			}
		
	}


// ALL .COMMAND CODE HAS RUN - IF NOTHING THEN GIVE ERROR MSG
  else SendText(oPC, TXT_COMMAND_NOT_FOUND, FALSE, COLOR_RED);
  }

  return DMFI_STATE_SUCCESS;         // Do not process emotes or languages
}// .COMMANDS
//void main(){}
