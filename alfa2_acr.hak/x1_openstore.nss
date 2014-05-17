// * Looks for the nearest store and opens it
#include "nw_i0_plot"

void main()
{
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore) == TRUE)
    {
		OpenStore( oStore, GetPCSpeaker(), 0, 0 );
    }
    else
        PlayVoiceChat(VOICE_CHAT_CUSS);
}


