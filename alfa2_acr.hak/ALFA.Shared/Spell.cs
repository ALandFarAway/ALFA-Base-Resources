using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class Spell
    {
        [TwoDAColumn(Index = true)]
        public int SpellId { get; set; }
        [TwoDAColumn(TalkString = true)]
        public string Name { get; set; }
        [TwoDAColumn(ColumnName = "IconResRef")]
        public string Icon { get; set; }
        [TwoDAColumn]
        public string School { get; set; }
        [TwoDAColumn]
        public string Range { get; set; }
        [TwoDAColumn(ColumnName = "VS")]
        public string Components { get; set; }
        [TwoDAColumn(Default = (int)-1)]
        public uint MetaMagic { get; set; }
        [TwoDAColumn(Default = (int)-1)]
        public uint TargetType { get; set; }
        [TwoDAColumn]
        public string ImpactScript { get; set; }
        [TwoDAColumn(ColumnName = "Bard", Default = (int)-1)]
        public int BardLevel { get; set; }
        [TwoDAColumn(ColumnName = "Cleric", Default = (int)-1)]
        public int ClericLevel { get; set; }
        [TwoDAColumn(ColumnName = "Druid", Default = (int)-1)]
        public int DruidLevel { get; set; }
        [TwoDAColumn(ColumnName = "Paladin", Default = (int)-1)]
        public int PaladinLevel { get; set; }
        [TwoDAColumn(ColumnName = "Ranger", Default = (int)-1)]
        public int RangerLevel { get; set; }
        [TwoDAColumn(ColumnName = "Wiz_Sorc", Default = (int)-1)]
        public int WizardLevel { get; set; }
        [TwoDAColumn(ColumnName = "Warlock", Default = (int)-1)]
        public int WarlockLevel { get; set; }
        [TwoDAColumn(ColumnName = "Innate", Default = (int)-1)]
        public int InnateLevel { get; set; }
        [TwoDAColumn]
        public string ImmunityType { get; set; }
        [TwoDAColumn(SerializeAs = typeof(int))]
        public bool ItemImmunity { get; set; }
        public List<int> SubSpells { get; set; }
        [TwoDAColumn(ColumnName = "Master", Default = (int)-1)]
        public int MasterSpell { get; set; }
        public List<int> CounterSpells { get; set; }
        [TwoDAColumn(ColumnName = "REMOVED", Default = false, SerializeAs = typeof(int))]
        public bool Removed { get; set; }

        public override string ToString() { return String.Format("Spell[{0}] {1} Components {2} Removed {3}", SpellId, Name, Components, Removed); }
    }
}
