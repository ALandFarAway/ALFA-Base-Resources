// ga_set_gflag
/*
    Set GlobalFlagName as a global int w/ value 1.
*/
// ChazM 7/21/05

void main()
{
	string sGlobalFlagName = GetLocalString(OBJECT_SELF, "GlobalFlagName");
	if (sGlobalFlagName != "")
		SetGlobalInt(sGlobalFlagName, 1);
}	