// gr_lostitems
/*
    Opens up the LostItems store for the player.  If no lost items store is found,
    one is created.
    Plot items aren't added to this store if it doesn't exist, so this command
    be run once at the beginning of the module to make sure one is created.

    This script for use with the dm_runscript console command
*/
// ChazM 11/6/05
const string TAG_LOST_ITEMS = "LostItems";
const string RR_LOST_ITEMS = "nw_lostitems";


void main()
{
    object oStore = GetObjectByTag(TAG_LOST_ITEMS);

    if (!GetIsObjectValid(oStore))
    {
        PrintString ("Creating Lost Items store");
        oStore = CreateObject(OBJECT_TYPE_STORE, RR_LOST_ITEMS, GetLocation(OBJECT_SELF));
        SetStoreMaxBuyPrice(oStore, 0);
    }
    OpenStore(oStore, OBJECT_SELF, -100);
}
