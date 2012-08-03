using System;
using System.Collections.Generic;
using System.Text;

using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Templates;

namespace ABM_creator
{
    class ConsumableCreator
    {

        ushort storeResourceType = OEIShared.Utils.BWResourceTypes.GetResourceType("UTM");
        CraftingStore potionStore = new CraftingStore("Potion Crafting", "acr_craft_potion");
        CraftingStore wandStore = new CraftingStore("Wand Crafting", "acr_craft_wand");
        CraftingStore scrollStore = new CraftingStore("Scroll Crafting", "acr_craft_scroll");
        static public HashSet<string> ipHash = new HashSet<string>();
        
        NWN2Toolset.NWN2.Data.Blueprints.NWN2ItemBlueprint addClassRestrictions(NWN2Toolset.NWN2.Data.Blueprints.NWN2ItemBlueprint item, int bardLevel, int clericLevel, int druidLevel, int paladinLevel, int rangerLevel, int wizardLevel)
        {
            if (wizardLevel != 255)
            {
                item.Properties.Add(ALFAItemProperty.WizardOnlyItemProperty());
                item.Properties.Add(ALFAItemProperty.SorcererOnlyItemProperty());
            }
            if (bardLevel != 255)
                item.Properties.Add(ALFAItemProperty.BardOnlyItemProperty());
            if (clericLevel != 255)
            {
                item.Properties.Add(ALFAItemProperty.ClericOnlyItemProperty());
                item.Properties.Add(ALFAItemProperty.FavoredSoulOnlyItemProperty());
            }
            if (druidLevel != 255)
            {
                item.Properties.Add(ALFAItemProperty.DruidOnlyItemProperty());
                item.Properties.Add(ALFAItemProperty.SpiritShamanOnlyItemProperty());
            }
            if (rangerLevel != 255)
                item.Properties.Add(ALFAItemProperty.RangerOnlyItemProperty());
            if (paladinLevel != 255)
                item.Properties.Add(ALFAItemProperty.PaladinOnlyItemProperty());

            return item;
        }

        public void NotfyIconsNotFoundFor(string consumableName, Dictionary<int, string> missingIcons) {
            DebugWindow.PrintDebugMessage(consumableName + " icons not found for spells:");
            foreach (int spellId in missingIcons.Keys)
            {
                DebugWindow.PrintDebugMessage(spellId.ToString() + ", " + missingIcons[spellId]);
            }
        }

        public bool nonpotion(int spellid)
        {
            if (spellid >= 174 && spellid <= 182 || spellid == 2)
                return true;
            else return false;
        }

        public void Run()
        {
            System.Collections.ArrayList tradeScrollList = new System.Collections.ArrayList();

            for (int ip = 0; ip < Globals.iprp_spells2da.RowCount; ip++)
            {
                //DebugWindow.PrintDebugMessage("Looking at iprp_spells.2da row: " + ip);
                string tdaSpellId = Globals.iprp_spells2da["SpellIndex"][ip];
                string tdaCasterLevel = Globals.iprp_spells2da["CasterLvl"][ip];
                string icon = Globals.iprp_spells2da["Icon"][ip];
                bool formatOK = true;
                int spellId = -1;
                int casterLevel = -1;
                try
                {
                    spellId = Convert.ToInt32(tdaSpellId);
                    casterLevel = Convert.ToInt32(tdaCasterLevel);
                    DebugWindow.PrintDebugMessage("Creating consumables for spell id " + spellId + ", caster level " + casterLevel + " and scroll icon " + icon + ".");
                }
                catch
                {
                    DebugWindow.PrintDebugMessage("2da format error for iprp_spells.2da line " + ip + ", spell id " + tdaSpellId + ", caster level " + tdaCasterLevel + ".");
                    formatOK = false;
                }

                if (formatOK && !ipHash.Contains(tdaSpellId.ToString() + "_" + tdaCasterLevel.ToString()))
                {

                    NWN2Toolset.NWN2.Rules.CNWSpell spell = Globals.spells.GetSpell(spellId);
                    ipHash.Add(tdaSpellId.ToString() + "_" + tdaCasterLevel.ToString());

                    if (spell != null && spell.IsValid() == 1 && spell.GetSpellMasterSpell() == spellId)
                    {
                        int targets = spell.GetSpellTargetType();
                        int wizardLevel = spell.GetSpellWizardLevel();
                        int clericLevel = spell.GetSpellClericLevel();
                        int druidLevel = spell.GetSpellDruidLevel();
                        int rangerLevel = spell.GetSpellRangerLevel();
                        int paladinLevel = spell.GetSpellPaladinLevel();
                        int bardLevel = spell.GetSpellBardLevel();

                        // Find the lowest spell level.
                        int lowestSpellLevel = wizardLevel;
                        if (lowestSpellLevel > clericLevel)
                            lowestSpellLevel = clericLevel;
                        if (lowestSpellLevel > druidLevel)
                            lowestSpellLevel = druidLevel;

                        float costLevel = lowestSpellLevel;
                        if (lowestSpellLevel == 0)
                            costLevel = 0.5F;

                        if ((lowestSpellLevel < 255))
                        {
                            if ((targets & 2) != 0 && lowestSpellLevel <= 3 && spell.GetSpellHostile() != 1 && !nonpotion(spellId))
                            {
                                // Can target a creature, ie can be a potion.
                                Potion potion = new Potion(ip, spellId, lowestSpellLevel, casterLevel, spell);
                                Globals.AddBlueprint(potion.blueprint);
                                potionStore.addToPotionItems(potion.blueprint);
                            }
                            DebugWindow.PrintDebugMessage("Potion handled.");

                            if (lowestSpellLevel <= 4)
                            {
                                // Can be a wand.
                                Wand wand = new Wand(ip, spellId, lowestSpellLevel, casterLevel, spell);
                                addClassRestrictions(wand.blueprint, bardLevel, clericLevel, druidLevel, paladinLevel, rangerLevel, wizardLevel);
                                Globals.AddBlueprint(wand.blueprint);
                                wandStore.addToPotionItems(wand.blueprint);
                            }
                            DebugWindow.PrintDebugMessage("Wand handled.");

                            int lowestDivineLevel = clericLevel;
                            if (druidLevel < clericLevel)
                            {
                                lowestDivineLevel = druidLevel;
                            }
                            if (lowestDivineLevel == 255)
                            {
                                lowestDivineLevel = rangerLevel;
                                if (lowestDivineLevel > paladinLevel)
                                    lowestDivineLevel = paladinLevel;
                            }
                            if (lowestDivineLevel < 255)
                            {
                                // Can be a divine scroll.
                                Scroll scroll = new DivineScroll(ip, spellId, lowestSpellLevel, casterLevel, spell, icon);
                                addClassRestrictions(scroll.blueprint, 255, clericLevel, druidLevel, paladinLevel, rangerLevel, 255);
                                Globals.AddBlueprint(scroll.blueprint);
                                scrollStore.addToPotionItems(scroll.blueprint);
                            }
                            DebugWindow.PrintDebugMessage("Divine Scroll handled.");

                            int lowestArcaneLevel = wizardLevel;
                            if (wizardLevel == 255)
                            {
                                lowestArcaneLevel = bardLevel;
                            }

                            if (wizardLevel < 255 && !tradeScrollList.Contains(spellId))
                            {
                                // Can be a trade scroll.
                                TradeScroll tradescroll = new TradeScroll(ip, spellId, lowestSpellLevel, spell);
                                Globals.AddBlueprint(tradescroll.blueprint);
                                tradeScrollList.Add(spellId);
                            }
                            DebugWindow.PrintDebugMessage("Trade scroll handled.");

                            if (lowestArcaneLevel < 255)
                            {
                                // Can be an arcane scroll.
                                Scroll scroll = new ArcaneScroll(ip, spellId, lowestSpellLevel, casterLevel, spell, icon);
                                addClassRestrictions(scroll.blueprint, bardLevel, 255, 255, 255, 255, wizardLevel);
                                Globals.AddBlueprint(scroll.blueprint);
                                scrollStore.addToPotionItems(scroll.blueprint);
                            }
                            DebugWindow.PrintDebugMessage("Arcane scroll handled.");
                        }
                    }
                }
            }
            DebugWindow.PrintDebugMessage("Items in blueprint collection: " + Globals.items.Count);

            NotfyIconsNotFoundFor("Potions", Potion.iconsMissing);
            NotfyIconsNotFoundFor("Wand", Wand.iconsMissing);
            NotfyIconsNotFoundFor("Scroll", Scroll.iconsMissing);

            ipHash = new HashSet<String>();
        }
    }
}