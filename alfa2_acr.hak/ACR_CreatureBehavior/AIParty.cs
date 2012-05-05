using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_CreatureBehavior
{
    /// <summary>
    /// This class describe a party of AI controlled characters that work
    /// together.  An AI controlled character can be a member of zero or one
    /// parties.
    /// </summary>
    public class AIParty
    {
        /// <summary>
        /// Create a new, empty AI party.
        /// </summary>
        /// <param name="PartyManager">Supplies the party manager that the
        /// party will be attached to.</param>
        public AIParty(AIPartyManager PartyManager)
        {
            this.PartyManager = PartyManager;

            PartyManager.AddParty(this);
        }

        /// <summary>
        /// Add a party member.
        /// </summary>
        /// <param name="Creature">Supplies the creature to add.</param>
        public void AddPartyMember(CreatureObject Creature)
        {
            if (Creature.Party != null)
            {
                throw new ApplicationException(String.Format(
                    "Adding creature {0} to party, but it is already joined to a party."));
            }

            PartyMembers.Add(Creature);
            Creature.Party = this;
        }

        /// <summary>
        /// Remove a party member.  If the party member was the last in the
        /// party, then the party is dissolved.
        /// </summary>
        /// <param name="Creature">Supplies the creature to remove.</param>
        public void RemovePartyMember(CreatureObject Creature)
        {
            if (Creature.Party != this)
            {
                throw new ApplicationException(String.Format(
                    "Removing creature {0} from party, but it is not in this party."));
            }

            PartyMembers.Remove(Creature);
            Creature.Party = null;

            if (PartyLeader == Creature)
                PartyLeader = null;

            if (PartyMembers.Count == 0)
                PartyManager.RemoveParty(this);
        }

        /// <summary>
        /// Promote a creature in the party to party leader.
        /// </summary>
        /// <param name="PartyLeader">Supplies the new party leader.</param>
        public void PromotePartyLeader(CreatureObject PartyLeader)
        {
            if (PartyLeader != null)
            {
                if (PartyLeader.Party != this)
                {
                    throw new ApplicationException(String.Format(
                        "Trying to promote creature {0} to party leader, but it is not in this party.",
                        PartyLeader));
                }
            }

            this.PartyLeader = PartyLeader;
        }


        /// <summary>
        /// The list of objects in the party.
        /// </summary>
        public List<CreatureObject> PartyMembers = new List<CreatureObject>();

        /// <summary>
        /// The designated party leader (if one is still alive).
        /// </summary>
        public CreatureObject PartyLeader = null;

        /// <summary>
        /// The associated party manager.
        /// </summary>
        public AIPartyManager PartyManager = null;
    }
}
