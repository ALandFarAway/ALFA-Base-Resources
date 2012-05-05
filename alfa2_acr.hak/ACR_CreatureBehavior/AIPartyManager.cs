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
    /// This class manages creation and removal (and tracking) of all AI
    /// controlled parties in the system.
    /// </summary>
    public class AIPartyManager
    {
        /// <summary>
        /// Construct an empty party manager.
        /// </summary>
        public AIPartyManager()
        {
        }

        /// <summary>
        /// Create a new party for use.  The party has no members initially and
        /// must be explicitly removed via RemoveParty if nobody will be added
        /// to the party.  Once any members have been added to the party, the
        /// party automatically dissolves when the last party member departs.
        /// </summary>
        /// <returns>The new party object.</returns>
        public AIParty CreateNewParty()
        {
            return new AIParty(this);
        }

        /// <summary>
        /// Add a party to the party list.  Called from the AIParty constructor
        /// only, use CreateParty to make a new party.
        /// </summary>
        /// <param name="Party"></param>
        public void AddParty(AIParty Party)
        {
            Parties.Add(Party);
        }

        /// <summary>
        /// Remove a party from the party list.  Called when the party is going
        /// away, or if a zero member party needs to be removed before anyone
        /// was ever added to it.
        /// </summary>
        /// <param name="Party"></param>
        public void RemoveParty(AIParty Party)
        {
            Parties.Remove(Party);
        }

        /// <summary>
        /// The list of all AI parties active system-wide.
        /// </summary>
        public List<AIParty> Parties = new List<AIParty>();
    }
}
