using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class SpellCastItemProperties
    {
        [TwoDAColumn(TalkString = true)]
        public string Name;
        [TwoDAColumn(ColumnName = "CasterLvl", Default = (int)1)]
        public int CasterLevel;
        [TwoDAColumn(ColumnName = "InnateLvl", Default = (int)0)]
        public int InnateLevel;
        public Spell Spell;

        [TwoDAColumn(ColumnName = "PotionUse", Default = false, SerializeAs = typeof(int))]
        public bool Potion;
        [TwoDAColumn(ColumnName = "WandUse", Default = false, SerializeAs = typeof(int))]
        public bool Wand;
        [TwoDAColumn(ColumnName = "GeneralUse", Default = false, SerializeAs = typeof(int))]
        public bool Scroll;
    }
}
