// gr_instrument
/*
    Gives player the instrument of death.

    This script for use with the dm_runscript console command
*/

// ChazM 11/23/05
void AddSuperSpellItemProp(object oItem, int iSpell)
{
    itemproperty ipAdd = ItemPropertyCastSpell(iSpell, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oItem);
}

// create an item and add super abilities to it.
void MakeInstrument()
{
    object oItem = CreateItemOnObject("nw_it_novel002");
    AddSuperSpellItemProp(oItem, IP_CONST_CASTSPELL_POWER_WORD_KILL_17);
    AddSuperSpellItemProp(oItem, IP_CONST_CASTSPELL_WEIRD_17);
    AddSuperSpellItemProp(oItem, IP_CONST_CASTSPELL_DOMINATE_MONSTER_17);
    AddSuperSpellItemProp(oItem, IP_CONST_CASTSPELL_METEOR_SWARM_17);
    AddSuperSpellItemProp(oItem, IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17);
    AddSuperSpellItemProp(oItem, IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17);
}

void main()
{
    object oItem = CreateItemOnObject("instodeath");
    //MakeInstrument();
}
