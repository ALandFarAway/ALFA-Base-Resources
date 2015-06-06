//*/////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------ 
// gui_color_tls - Elechos - Script de GUI : Calcule une couleur RGB grace 
//								aux valeurs envoyé en TLS
// Scripteur:  Tyrnis
// Dernière Modification : 08 / 12 / 2007
//------------------------------------------------------------------------------
//*/////////////////////////////////////////////////////////////////////////////


#include "nwnx_craft_system"
#include "acr_vanity_i"
#include "acr_items_i"

void main (int iTeinte, int iLuminosite, int iSaturation)
{	
	object oPC = OBJECT_SELF;
	int iRed,iGreen,iBlue,iAlpha,iNewColorValue,nType;
	float T,L,S;
	float R,G,B, q1,q2;

	//XPCraft_Debug(OBJECT_SELF,"TLS : \n T = " + IntToString(iTeinte) + "\n L = " + IntToString(iLuminosite) + "\n S = " + IntToString(iSaturation));
	
	T = IntToFloat(iTeinte);
	L = IntToFloat(iLuminosite) / 100.0;
	S = IntToFloat(iSaturation) / 100.0;
	
	//XPCraft_Debug(OBJECT_SELF,"T = " + FloatToString(T) + "\n L = " + FloatToString(L) + "\n T = " + FloatToString(T));
	
	if (L <= 0.5)
		q2 = L * (1.0 + S);
	else
		q2 = L + S - (L * S);
	
	q1 = (2 * L) - q2;
	
	//XPCraft_Debug(OBJECT_SELF,"q1 = " + FloatToString(q1) + "\n q2 = " + FloatToString(q2) + "\n L = " + FloatToString(L));
	
	if(S == 0.0) {
		R = L;
		G = L;
		B = L;
	}
	else {
		R = XPCraft_QqhToRgb(q1,q2,T+120.0);
		G = XPCraft_QqhToRgb(q1,q2,T);
		B = XPCraft_QqhToRgb(q1,q2,T-120.0);
	}
	
	//XPCraft_Debug(OBJECT_SELF,"R = " + FloatToString(R) + "\n G = " + FloatToString(G) + "\n B = " + FloatToString(B));

	iRed = FloatToInt(R*255.0);
	iGreen = FloatToInt(G*255.0);
	iBlue = FloatToInt(B*255.0);
	iAlpha = 255;
	
	iNewColorValue = XPCraft_RGBAToInt(iRed,iGreen,iBlue,iAlpha);
	
	//DisplayMessageBox(oPC, 1, "Red: "+IntToString(iRed) + "\nGreen: "+IntToString(iGreen)+"\nBlue: "+IntToString(iBlue)+"\nCol:"+IntToString(iNewColorValue));
	
	// handle appearance stuff
	if (GetLocalInt(oPC, "ACR_APP_TYPE")) {
		SetLocalInt(oPC, "ACR_APP_TINT_R", iRed);
		SetLocalInt(oPC, "ACR_APP_TINT_G", iGreen);
		SetLocalInt(oPC, "ACR_APP_TINT_B", iBlue);
		SetLocalInt(oPC, "ACR_APP_TINT_A", iAlpha);

		ApplyTintToType(oPC);
		return;
	}

	if (GetLocalInt(oPC, "XC_CRAFT_DELAY"))
		return;

	SetLocalInt(oPC, "XC_CRAFT_DELAY", 1);
	DelayCommand(XP_CRAFT_TALK_DELAY, DeleteLocalInt(oPC, "XC_CRAFT_DELAY"));

	/*
	if (GetLocalInt(oPC, "XC_ITEM_COLOR_CRAFTED")) {
		DisplayMessageBox(oPC, 1, "Exit the dialog and select tint area to modify color again.");
		return;
	}
	*/
	if(GetLocalInt(oPC, "ACR_ITEM_COMMAND")) 
	{
    iNewColorValue = ((iRed & 255)<<16) + ((iGreen & 255)<<8) + (iBlue & 255);
    object oItem = GetItemInSlot(GetLocalInt(oPC, "ACR_ITEM_INV_SLOT"), oPC);
    if(!GetIsObjectValid(oItem)) return;
	
    ClearScriptParams();
    AddScriptParameterObject(oItem);
    AddScriptParameterInt(GetLocalInt(oPC, "ACR_ITEM_COMMAND"));
    
    if(GetLocalInt(oPC, "ACR_ITEM_PARAM_1") == -101)
    {
      AddScriptParameterInt(iNewColorValue);
      AddScriptParameterInt(GetLocalInt(oPC, "ACR_ITEM_COLOR_ACCENT"));
      SetLocalInt(oPC, "ACR_ITEM_COLOR_BASE", iNewColorValue);
    }
    else if(GetLocalInt(oPC, "ACR_ITEM_PARAM_1") == -102)
    {
      AddScriptParameterInt(GetLocalInt(oPC, "ACR_ITEM_COLOR_BASE"));
      AddScriptParameterInt(iNewColorValue);
      SetLocalInt(oPC, "ACR_ITEM_COLOR_ACCENT", iNewColorValue);
    }
    else
    {
      AddScriptParameterInt(GetLocalInt(oPC, "ACR_ITEM_PARAM_1"));
      AddScriptParameterInt(iNewColorValue);
    }
    int ret = ExecuteScriptEnhanced("ACR_Items", oPC, TRUE);
    if(ret > 0) AssignCommand(oPC, ActionEquipItem(IntToObject(ret), GetLocalInt(oPC, "ACR_ITEM_INV_SLOT")));
	}
	else
	{
    SetLocalObject(oPC, "XC_ITEM_TO_CRAFT", XPCraft_ActionChangeColor(oPC, iNewColorValue));
  }
	
	//SetLocalInt(oPC, "XC_ITEM_COLOR_CRAFTED",1);
		
}
