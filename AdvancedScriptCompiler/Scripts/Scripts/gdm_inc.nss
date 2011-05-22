// gdm_inc
/*
    include file for dm convo.
*/
// ChazM 11/13/05

int GetIntParam()
{
    int iParam = StringToInt(GetLocalString(GetPCSpeaker(), "dm_param"));
    return (iParam);
}

string GetStringParam()
{
    string sParam = GetLocalString(GetPCSpeaker(), "dm_param");
    return (sParam);
}

