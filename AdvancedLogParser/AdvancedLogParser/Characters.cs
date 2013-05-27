using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AdvancedLogParser
{
    public static class Characters
    {
        public static Dictionary<uint, Character> List;
    }

    public class Character
    {
        public uint Id;
        public uint ServerId;
        public uint PlayerId;
        public string Name;
        public uint Level;
        public uint Race;
        public uint SubRace;
        public string Deity;
        public uint Gender;
        public uint HitPoints;
        public uint XP;
        public uint GP;
        public uint Wealth;
        public uint Ethics;
        public uint Morals;
        public uint Class1;
        public uint Level1;
        public uint Class2;
        public uint Level2;
        public uint Class3;
        public uint Level3;
        public uint Strength;
        public uint Dexterity;
        public uint Constitution;
        public uint Intelligence;
        public uint Wisdom;
        public uint Charisma;
        public uint Damage;
        public uint Deaths;
        public uint Status;
        public bool IsOnline;
        public bool IsDeleted;
        public bool IsPlayable;
        public sbyte RetiredStatus;

        public float DMTime;
    }
}
