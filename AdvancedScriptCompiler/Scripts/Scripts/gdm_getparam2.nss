// gdm_getparam2
/*
    Stops DM from listening for param.

    This script for use in normal conversation
*/
// ChazM 11/13/05


void main()
{
     SetListening(OBJECT_SELF, FALSE);
     SetCustomToken(99, GetLocalString(GetPCSpeaker(), "dm_param"));
}
