using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class Spell
    {
        public string Name { get; set; }
        public string Icon { get; set; }
        public string School { get; set; }
        public string Range { get; set; }
        public string Components { get; set; }
        public int MetaMagic { get; set; }
        public int TargetType { get; set; }
        public string ImpactScript { get; set; }
        public int BardLevel { get; set; }
        public int ClericLevel { get; set; }
        public int DruidLevel { get; set; }
        public int PaladinLevel { get; set; }
        public int RangerLevel { get; set; }
        public int WizardLevel { get; set; }
        public int WarlockLevel { get; set; }
        public int InnateLevel { get; set; }
        public string ImmunityType { get; set; }
        public bool ItemImmunity { get; set; }
        public List<int> SubSpells { get; set; }
        public int MasterSpell { get; set; }
        public List<int> CounterSpells { get; set; }
        public bool Removed { get; set; }
    }
}
