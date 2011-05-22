// ga_global_string
/*
    This script changes a local string variable's value
        sScript     = This is the name of the variable being changed
        sChange     = This is what the local string is set to.
*/
// FAB 10/7

void main(string sScript, string sChange)
{

    float fChange;

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

    // Debug Message - comment or take care of in final
    //SendMessageToPC( oPC, sTagOver + "'s variable " + sScript + " is now set to " + sChange );

    SetGlobalString( sScript, sChange );

}
