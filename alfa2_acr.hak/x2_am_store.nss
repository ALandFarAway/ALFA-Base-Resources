// * Looks for the nearest store and opens it
#include "nw_i0_plot"

void main()
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore) == TRUE)
    {
	OpenStore(oStore, oPC, 0, 0);
    }
    else
        PlayVoiceChat(VOICE_CHAT_CUSS);
}
