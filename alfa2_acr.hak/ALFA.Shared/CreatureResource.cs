using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class CreatureResource : IComparable<CreatureResource>
    {
        public volatile string FirstName;
        public volatile string LastName;
        public volatile string Classification;
        public volatile string TemplateResRef;
        public volatile string Tag;
        public volatile bool IsImmortal;
        public volatile float ChallengeRating;
        public volatile int FactionID;
        public volatile int LawfulChaotic;
        public volatile int GoodEvil;
        public volatile string AlignmentSummary;

        public CreatureResource() { }

        public int CompareTo(CreatureResource other)
        {
            if (other == null) return 1;
            if (other.FirstName == null) return 1;
            if (String.IsNullOrEmpty(other.FirstName)) return 1;
            if (this == null) return -1;
            if (FirstName == null) return -1;
            if (String.IsNullOrEmpty(FirstName)) return -1;

            return FirstName.CompareTo(other.FirstName);
        }
    }
}