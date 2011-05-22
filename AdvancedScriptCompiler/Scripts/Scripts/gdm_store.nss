// gdm_store
/*
    open store - attempt to create one if not found.

    This script for use in normal conversation
*/
// ChazM 11/13/05

#include "gdm_inc"

void main()
{
    string sStore = GetStringParam();
    object oPC = GetPCSpeaker();

    object oStore = GetObjectByTag(sStore);

    if (!GetIsObjectValid(oStore))
    {
        oStore = CreateObject(OBJECT_TYPE_STORE, sStore, GetLocation(OBJECT_SELF));
    }
    OpenStore(oStore, oPC);
}
