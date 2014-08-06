using System;
using System.Collections.Generic;
using System.Text;

using NWN2Toolset.NWN2.Data.Templates;
using NWN2Toolset.NWN2.Rules;

namespace ACR_BuilderPlugin
{
    static class CreatureHelper
    {
        public enum HPType
        {
            Ignore = -1,
            PenAndPaper = 1,
            Maximum = 2
        }

        public static short GetHitPointsPNP(NWN2CreatureTemplate creature)
        {
            int maxHP = CalcMaxHitpointsFromHitDice(creature) / 2;

            int newHP = (int)((float)maxHP / (float)creature.GetStatsCore().GetLevel() / 2);
            newHP += creature.GetStatsCore().CalcHitPointModsFromFeats(1);
            newHP += CalcHitPointModsFromStats(creature);
            return (short)newHP;
        }

        public static short GetHitPointsMax(NWN2CreatureTemplate creature)
        {
            int newHP = CalcMaxHitpointsFromHitDice(creature);
            newHP += creature.GetStatsCore().CalcHitPointModsFromFeats(1);
            newHP += CalcHitPointModsFromStats(creature);
            return (short)newHP;
        }

        public static int CalcMaxHitpointsFromHitDice(NWN2CreatureTemplate creature)
        {
            if (GetIsUndead(creature)) return creature.GetStatsCore().GetLevel() * 12;
            return creature.GetStatsCore().CalcMaxHitpointsFromHitDice();
        }

        public static int CalcHitPointModsFromStats(NWN2CreatureTemplate creature)
        {
            if (GetIsUndead(creature)) return 0;
            if (GetIsConstruct(creature)) return 0;
            return creature.GetStatsCore().CalcHitPointModsFromStats();
        }

        public static bool GetIsConstruct(NWN2CreatureTemplate creature)
        {
            if (creature.Variables.GetVariable("ACR_CRE_ISCONSTRUCT").ValueInt == 1) return true;
            if (creature.Variables.GetVariable("ACR_CRE_ISCONSTRUCT").ValueInt == 2) return false;
            if (creature.Race.Row == 10) return true;
            if (creature.GetStatsCore().GetHasClass(13) == 1) return true;
            return false;
        }

        public static bool GetIsUndead(NWN2CreatureTemplate creature)
        {
            if (creature.Variables.GetVariable("ACR_CRE_ISUNDEAD").ValueInt == 1) return true;
            if (creature.Variables.GetVariable("ACR_CRE_ISUNDEAD").ValueInt == 2) return false;
            if (creature.Race.Row == 24) return true;
            if (creature.GetStatsCore().GetHasClass(19) == 1) return true;
            return false;
        }
    }
}
