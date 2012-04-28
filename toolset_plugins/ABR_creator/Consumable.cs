using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Rules;
using OEIShared.IO.TwoDA;
using OEIShared.IO.TalkTable;
using OEIShared.IO.GFF;
using NWN2Toolset.NWN2.Data.Templates;

/* System.NullReferenceException: Object reference not set to an instance of an object.
   at NWN2Toolset.NWN2.Data.Blueprints.NWN2ItemBlueprint.set_ResourceName(OEIResRef value)
   at ABM_creator.Consumable..ctor(Int32 ip, Int32 spellId, Int32 spellLevel, Int32 casterLevel, CNWSpell spell)
   at ABM_creator.ConsumableCreator.Run()
 */

namespace ABM_creator
{
    abstract class Consumable
    {
        public abstract string tagPrefix { get; }
        public abstract string baseDescription { get; }        
        public abstract string baseCategory { get; }

        public abstract int baseType { get; }
        public abstract int baseCost { get; }

        public virtual NWN2ItemPropertyInfo itemProperty(int castSpellIp)
        {
            return ALFAItemProperty.CastSpellOnceItemProperty((ushort)castSpellIp);
        }

        public abstract string baseName(int spellId);

        public abstract Dictionary<int, string> GetMissingIcons();

        protected void flagIconMissingForSpell(int spellId, string spellName)
        {
            try { GetMissingIcons().Add(spellId, spellName); }
            catch { }
        }

        public NWN2ItemBlueprint blueprint;
        
        protected abstract string findIconName(int spellId, CNWSpell spell, int spellLevel);

        private string GetAuraStrength(int spellLevel)
        {
            string auraStrength;
            if (spellLevel <= 3)
                auraStrength = "faint";
            else if (spellLevel <= 6)
                auraStrength = "moderate";
            else if (spellLevel <= 9)
                auraStrength = "strong";
            else auraStrength = "overwhelming";

            return auraStrength;
        }

        protected virtual string GetAuraDescription(int spellLevel, CNWSpell spell)
        {
            return "\n\nThis item radiates a " + GetAuraStrength(spellLevel) + " aura of " + Globals.spellschools2da["Label"][spell.GetSpellSchool()].ToLower();
        }

        private string GetSpellName(NWN2Toolset.NWN2.Rules.CNWSpell spell)
        {
            string spellName;
            uint spellNameId = (uint)spell.GetSpellName();
            if (spellNameId >= OEIShared.IO.TalkTable.TalkTable.nCustomMask)
                spellName = Globals.customTlk[spellNameId].String;
            else spellName = spell.GetSpellNameText().CStr();

            return spellName;
        }

        private string ConsumableName(CNWSpell spell, int spellId, int spellLevel, int casterLevel)
        {

            string sCasterLevel = "";
            if (casterLevel < 10)
                sCasterLevel = "0" + casterLevel;
            else sCasterLevel = "" + casterLevel;

            return "{" + spellLevel + ", CL " + sCasterLevel + "} " + GetSpellName(spell) + ", " + baseName(spellId);
        }

        protected virtual int cost(int spellLevel, int casterLevel)
        {
            if (spellLevel == 0)
                return (casterLevel * baseCost) / 2;
            return spellLevel * casterLevel * baseCost;
        }

        public Consumable(int ip, int spellId, int spellLevel, int casterLevel, CNWSpell spell, bool adjustCost = true, string iconName = null)
        {
            blueprint = new NWN2ItemBlueprint();

            string tag = tagPrefix + spellId.ToString() + "_" + casterLevel.ToString();
            ushort resType = OEIShared.Utils.BWResourceTypes.GetResourceType("UTI");

            blueprint.Resource = Globals.repository.CreateResource(new OEIShared.Utils.OEIResRef(tag), resType);
            
            blueprint.TemplateResRef = new OEIShared.Utils.OEIResRef(tag);
            blueprint.Tag = tag;
            blueprint.ResourceName = new OEIShared.Utils.OEIResRef(tag);

            blueprint.BaseItem = new OEIShared.IO.TwoDA.TwoDAReference("baseitems", "Name", true, baseType);

            string name = ConsumableName(spell, spellId, spellLevel, casterLevel);
            blueprint.LocalizedName = new OEIShared.Utils.OEIExoLocString();
            blueprint.LocalizedName[OEIShared.Utils.BWLanguages.BWLanguage.English] = name;

            blueprint.LocalizedDescriptionIdentified = new OEIShared.Utils.OEIExoLocString();
            blueprint.LocalizedDescriptionIdentified[OEIShared.Utils.BWLanguages.BWLanguage.English] = baseDescription + "\n\n" + spell.GetSpellDescriptionText().CStr() + GetAuraDescription(spellLevel, spell);

            if (ip >= 0) blueprint.Properties.Add(itemProperty(ip));

            blueprint.Classification = baseCategory;

            if (iconName == null)
                iconName = findIconName(spellId, spell, spellLevel);
            int iconId = Globals.getIconId(iconName);
            if (iconId == 0)
                flagIconMissingForSpell(spellId, GetSpellName(spell));
            blueprint.Icon = new TwoDAReference("nwn2_icons", "ICON", false, iconId);

            blueprint.CalculateBaseCosts();
            if (adjustCost)
                blueprint.AdditionalCost = cost(spellLevel, casterLevel) - (int)blueprint.Cost;
        }
    }

    abstract class Scroll : Consumable
    {

        override public string tagPrefix { get { return "abr_it_sc_"; } }
        override public string baseDescription { get { return "A scroll is a heavy sheet of fine vellum or high-quality paper. An area about 8 ½ inches wide and 11 inches long is sufficient to hold one spell. The sheet is reinforced at the top and bottom with strips of leather slightly longer than the sheet is wide. To protect it from wrinkling or tearing, a scroll is rolled up from both ends to form a double cylinder. (This also helps the user unroll the scroll quickly.) The scroll is placed in a tube of ivory, jade, leather, metal, or wood, which is often sealed to keep out water and other liquids. Most scroll cases are inscribed with magic symbols which often identify the owner or the spells stored on the scrolls inside. A scroll has AC 9, 1 hit point, hardness 0, and a break DC of 8."; } }
        
        override public string baseName(int spellId) { return "scroll"; }

        override public int baseType { get { return 75; } }
        override public int baseCost { get { return 25; } }

        public Scroll(int ip, int spellId, int spellLevel, int casterLevel, CNWSpell spell, string icon) : base(ip, spellId, spellLevel, casterLevel, spell, true, icon) { }

        static public Dictionary<int, string> iconsMissing = new Dictionary<int, string>();
        public override Dictionary<int, string> GetMissingIcons() { return iconsMissing; }

        static protected Dictionary<int, string> scrollIcons = new Dictionary<int, string>();

        protected override string findIconName(int spellId, CNWSpell spell, int spellLevel)
        {
            return null;
        }
    }

    class ArcaneScroll : Scroll
    {
        override public string baseCategory { get { return "ALFA_Scrolls_Arcane"; } }

        public ArcaneScroll(int ip, int spellId, int spellLevel, int casterLevel, CNWSpell spell, string icon) : base(ip, spellId, spellLevel, casterLevel, spell, icon) {}
    }

    class DivineScroll : Scroll
    {
        override public string baseCategory { get { return "ALFA_Scrolls_Divine"; } }

        public DivineScroll(int ip, int spellId, int spellLevel, int casterLevel, CNWSpell spell, string icon) : base(ip, spellId, spellLevel, casterLevel, spell, icon) {}
    }

    class TradeScroll : Scroll
    {
        override public string baseCategory { get { return "ALFA_Scrolls_Trade"; } }
        override public string tagPrefix { get { return "abr_it_sc_trade_"; } }

        override public string baseDescription { get { return base.baseDescription + "\n\nA tradescroll is a text teaching a wizard how to prepare a spell, similar to a spell in her spellbook. It cannot be cast."; } }

        override public string baseName(int spellId) { return "trade scroll"; }

        override protected int cost(int spellLevel, int casterLevel)
        {
            if (spellLevel == 0)
                return 12;
            else if (spellLevel == 1)
                return 25;
            else return spellLevel * 50;
        }

        override protected string GetAuraDescription(int spellLevel, CNWSpell spell) { return ""; }

        public TradeScroll(int spellId, int spellLevel, CNWSpell spell) : base(-1, spellId, spellLevel, 0, spell, "it_yellowparch") {
            blueprint.Tag = "acr_it_tradescroll";
        }
    }

    class Potion : Consumable
    {
        override public string baseCategory { get { return "ALFA_Potions"; } }
        override public string tagPrefix { get { return "abr_it_po_"; } }
        override public string baseDescription { get { return "A typical potion consists of 1 ounce of liquid held in a ceramic or glass vial fitted with a tight stopper. The stoppered container is usually no more than 1 inch wide and 2 inches high. The vial has AC 13, 1 hit point, hardness 1, and a break DC of 12. Vials hold 1 ounce of liquid."; } }

        override public string baseName(int spellId)
        {
            switch (spellId)
            {
                case 537:
                case 542:
                case 544:
                case 545:
                case 861:
                case 546:
                case 100:
                    return "oil";
                default: return "potion";
            }
        }

        override public int baseType { get { return 49; } }
        override public int baseCost { get { return 50; } }

        public Potion(int ip, int spellId, int spellLevel, int casterLevel, CNWSpell spell) : base(ip, spellId, spellLevel, casterLevel, spell) {}

        protected override string findIconName(int spellId, CNWSpell spell, int spellLevel)
        {
            switch(spellId)
            {
                case 1: return "it_aidpotion"; // Aid
                case 97: return "it_pot_salveofchauntea"; // Lesser restoration
                case 126: return "it_ps_centstrong"; // Neutralize poison
            }

            switch(spell.GetSpellSchoolString().CStr())
            {
                case "A":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_pot_greentube";
                        case 2: return "it_pot_greenbot";
                        case 3: return "it_pot_greenflask";
                    }
                    break;
                case "C":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_healpotion";
                        case 2: return "it_pot_bluebot";
                        case 3: return "it_pot_blueflask";
                    }
                    break;
                case "D":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_pot_whitetube";
                        case 2: return "it_pot_whitebot";
                        case 3: return "it_pot_whiteflask";
                    }
                    break;
                case "E":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_pot_orangetube";
                        case 2: return "it_pot_orangebot";
                        case 3: return "it_pot_orangeflask";
                    }
                    break;
                case "I":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_pot_purpletube";
                        case 2: return "it_pot_purplebot";
                        case 3: return "it_pot_purpleflask";
                    }
                    break;
                case "N":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_ps_scorpmild";
                        case 2: return "it_ps_scorpavg";
                        case 3: return "it_ps_scorpstrong";
                    }
                    break;
                case "T":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_pot_orangetube";
                        case 2: return "it_pot_orangebot";
                        case 3: return "it_pot_orangeflask";
                    }
                    break;
                case "V":
                    switch(spellLevel)
                    {
                        case 0:
                        case 1: return "it_pot_blacktube";
                        case 2: return "it_pot_blackbot";
                        case 3: return "it_pot_blackflask";
                    }
                    break;
            }

            return null;
        }

        static public Dictionary<int, string> iconsMissing = new Dictionary<int, string>();
        public override Dictionary<int, string> GetMissingIcons() { return iconsMissing; }
    }

    class Wand : Consumable
    {
        override public string baseCategory { get { return "ALFA_Wands"; } }
        override public string tagPrefix { get { return "abr_it_wa_"; } }
        override public string baseDescription { get { return "A typical wand is 6 inches to 12 inches long and about ¼ inch thick, and often weighs no more than 1 ounce. Most wands are wood, but some are bone. A rare few are metal, glass, or even ceramic, but these are quite exotic. Occasionally, a wand has a gem or some device at its tip, and most are decorated with carvings or runes. A typical wand has AC 7, 5 hit points, hardness 5, and a break DC of 16."; } }
        override public string baseName(int spellId) { return "wand"; }

        override public int baseType { get { return 46; } }
        override public int baseCost { get { return 750; } }

        public Wand(int ip, int spellId, int spellLevel, int casterLevel, CNWSpell spell) : base(ip, spellId, spellLevel, casterLevel, spell, false)
        {
            blueprint.Charges = 50;
        }

        static public Dictionary<int, string> iconsMissing = new Dictionary<int, string>();
        public override Dictionary<int, string> GetMissingIcons() { return iconsMissing; }

        public override NWN2ItemPropertyInfo itemProperty(int castSpellIp)
        {
            return ALFAItemProperty.CastSpell1ChargeItemProperty((ushort)castSpellIp);
        }

        protected override string findIconName(int spellId, CNWSpell spell, int spellLevel)
        {
            switch (spellId)
            {
                case 32:
                case 33:
                case 1021:
                    return "it_wm_wandcureLwound";

                case 34:
                case 35:
                case 1020:
                    return "it_wm_wandcureCwound";

                case 10:
                case 58:
                case 59:
                case 61:
                case 191:
                case 461:
                case 518:
                case 542:
                case 851:
                case 1099:
                case 1208:
                case 1055: return "it_wm_wandfire";

                case 25:
                case 144:
                    return "it_wm_rodfrost";

                case 165:
                case 855:
                    return "it_wm_wandsleep";

                case 100:
                case 419:
                    return "it_wm_rodthundlight";

                case 107:
                case 447:
                    return "it_wm_wandmagicmis";
                
                case 11:
                case 101:
                case 847:
                case 1162:
                case 1198:
                case 1207:
                    return "it_wm_wandlightning";
            }

            switch (spell.GetSpellSchoolString().CStr())
            {
                case "A": return "it_wm_rodreversal";
                case "C": return "it_wm_wandsummon";
                case "D": return "it_wm_wandlesssummon";
                case "E": return "it_wm_rodbeguile";
                case "I": return "it_wm_rodwonder";
                case "N": return "it_wm_wanddisjunct";
                case "T": return "it_wm_wandnegenergy";
                case "V": return "it_wd_qstaff05";
            }

            return null;
        }
    }
}