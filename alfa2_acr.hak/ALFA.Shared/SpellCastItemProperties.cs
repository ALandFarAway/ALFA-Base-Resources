using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class SpellCastItemProperties
    {
        public string Name;
        public int CasterLevel;
        public int InnateLevel;
        public Spell Spell;

        public bool Potion;
        public bool Wand;
        public bool Scroll;
    }
}
