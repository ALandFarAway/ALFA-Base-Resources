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
    /// This class represents a creature within the game.
    /// </summary>
    public class CreatureObject : GameObject
    {

        /// <summary>
        /// Construct a creature object and insert it into the object table.
        /// </summary>
        /// <param name="ObjectId">Supplies the creature object id.</param>
        /// <param name="ObjectManager">Supplies the object manager.</param>
        public CreatureObject(uint ObjectId, GameObjectManager ObjectManager) : base(ObjectId, GameObjectType.Creature, ObjectManager)
        {
            //
            // Cache state that doesn't change over the lifetime of the object
            // so as to avoid a need to call down into the engine for these
            // fields.
            //

            CreatureIsPC = Script.GetIsPC(ObjectId) != CLRScriptBase.FALSE ? true : false;
            CreatureIsDM = Script.GetIsDM(ObjectId) != CLRScriptBase.FALSE ? true : false;
            PerceivedObjects = new List<PerceptionNode>();
        }

        /// <summary>
        /// Called when the C# object state is being run down because the game
        /// engine half of the object has been deleted.  This might occur after
        /// the fact.
        /// </summary>
        public override void OnRundown()
        {
            if (Party != null)
                Party.RemovePartyMember(this);
        }

        /// <summary>
        /// Called when a spell is cast on the creature.
        /// </summary>
        /// <param name="CasterObjectId">Supplies the spell caster object id.
        /// </param>
        /// <param name="SpellId">Supplies the spell id.</param>
        public void OnSpellCastAt(uint CasterObjectId, int SpellId)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the creature is attacked.
        /// </summary>
        /// <param name="AttackerObjectId">Supplies the attacker object id.
        /// </param>
        public void OnAttacked(uint AttackerObjectId)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the creature is damaged.
        /// </summary>
        /// <param name="DamagerObjectId">Supplies the damager object id.
        /// </param>
        /// <param name="TotalDamageDealt">Supplies the total damage dealt.
        /// </param>
        public void OnDamaged(uint DamagerObjectId, int TotalDamageDealt)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the creature dies.
        /// </summary>
        /// <param name="KillerObjectId">Supplies the killer object id.</param>
        public void OnDeath(uint KillerObjectId)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the creature's movement is blocked.
        /// </summary>
        /// <param name="BlockerObjectId">Supplies the blocker object
        /// id.</param>
        public void OnBlocked(uint BlockerObjectId)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the perception state of the creature changes.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="Heard">True if the object is now heard.</param>
        /// <param name="Inaudible">True if the object is now not
        /// heard.</param>
        /// <param name="Seen">True if the object is now seen.</param>
        /// <param name="Vanished">True if the object is now not seen.</param>
        public void OnPerception(uint PerceivedObjectId, bool Heard, bool Inaudible, bool Seen, bool Vanished)
        {
            //
            // No need to manage perception tracking for PC or DM avatars as
            // these will never be AI controlled.
            //

            if (IsPC || IsDM)
                return;

            //
            // Update the perception list.  This is done even if we are not yet
            // AI controlled (as control could be temporarily suspended e.g. by
            // DM command).
            //

            PerceptionNode Node = (from PN in PerceivedObjects
                                   where PN.PerceivedObjectId == PerceivedObjectId
                                   select PN).FirstOrDefault();
            bool NewNode = false;
            bool RemoveNode = false;

            if (Node == null)
            {
                if (Heard || Seen)
                {
                    Node = new PerceptionNode(PerceivedObjectId);
                    NewNode = true;
                    PerceivedObjects.Add(Node);
                }
                else
                {
                    return;
                }
            }

            if (Heard)
            {
                Node.Heard = true;
                OnPerceptionSeenObject(PerceivedObjectId, NewNode);
            }

            if (Seen)
            {
                Node.Seen = true;
                OnPerceptionHeardObject(PerceivedObjectId, NewNode);
            }

            if (Vanished)
            {
                Node.Seen = false;

                if (!Node.Heard)
                {
                    RemoveNode = true;
                    PerceivedObjects.Remove(Node);
                }

                OnPerceptionLostSightObject(PerceivedObjectId, RemoveNode);
            }

            if (Inaudible)
            {
                Node.Heard = false;

                if (!Node.Seen)
                {
                    RemoveNode = true;
                    PerceivedObjects.Remove(Node);
                }

                OnPerceptionLostHearingObject(PerceivedObjectId, RemoveNode);
            }
        }

        /// <summary>
        /// Called when an object first sees an object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="InitialDetection">True if this is the first detection
        /// event for the perceived object since it last became undetected.
        /// </param>
        private void OnPerceptionSeenObject(uint PerceivedObjectId,
            bool InitialDetection)
        {
        
        }

        /// <summary>
        /// Called when an object first hears an object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="InitialDetection">True if this is the first detection
        /// event for the perceived object since it last became undetected.
        /// </param>
        private void OnPerceptionHeardObject(uint PerceivedObjectId,
            bool InitialDetection)
        {
        
        }

        /// <summary>
        /// Called when an object loses sight of another object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="LastDetection">True if this is the last detection
        /// method for the perceived object.
        /// </param>
        private void OnPerceptionLostSightObject(uint PerceivedObjectId,
            bool LastDetection)
        {
        
        }

        /// <summary>
        /// Called when an object loses hearing of another object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="LastDetection">True if this is the last detection
        /// method for the perceived object.
        /// </param>
        private void OnPerceptionLostHearingObject(uint PerceivedObjectId,
            bool LastDetection)
        {
        
        }



        /// <summary>
        /// Get whether the creature is a player avatar (includes DMs).
        /// </summary>
        public bool IsPC { get { return CreatureIsPC; } }

        /// <summary>
        /// Get whether the creature is a DM avatar.
        /// </summary>
        public bool IsDM { get { return CreatureIsDM; } }

        /// <summary>
        /// Get whether a player or DM is controlling the creature.
        /// </summary>
        public bool IsPlayerControlled { get { return Script.GetControlledCharacter(ObjectId) != OBJECT_INVALID; } }

        /// <summary>
        /// Get or set whether the object is managed by the AI subsystem.  This
        /// should be only set at startup time for the object, generally.
        /// </summary>
        public bool IsAIControlled { get { return AIControlled && !IsPlayerControlled; } set { AIControlled = value; } }

        /// <summary>
        /// The list of perceived objects.
        /// </summary>
        public List<PerceptionNode> PerceivedObjects { get; set; }

        /// <summary>
        /// The associated AI party, if any.
        /// </summary>
        public AIParty Party { get; set; }

        /// <summary>
        /// The leader of the party, if any.
        /// </summary>
        public CreatureObject PartyLeader
        {
            get
            {
                if (Party == null)
                    return null;
                else
                    return Party.PartyLeader;
            }
        }



        /// <summary>
        /// The creature is PC flag (DMs are also PCs).
        /// </summary>
        private bool CreatureIsPC;

        /// <summary>
        /// The creature is DM flag.
        /// </summary>
        private bool CreatureIsDM;

        /// <summary>
        /// True if the object is controlled by the AI subsystem.
        /// </summary>
        private bool AIControlled;


        /// <summary>
        /// This class records what objects are perceived by this object.
        /// </summary>
        public class PerceptionNode
        {
            /// <summary>
            /// Create a new, blank perception node relating to perception of a
            /// given object.
            /// </summary>
            /// <param name="ObjectId">Supplies the object whose perception
            /// state is being tracked.</param>
            public PerceptionNode(uint ObjectId)
            {
                PerceivedObjectId = ObjectId;
            }

            /// <summary>
            /// The object id that is being perceived.
            /// </summary>
            public uint PerceivedObjectId;

            /// <summary>
            /// True if the object is seen.
            /// </summary>
            public bool Seen;

            /// <summary>
            /// True if the object is heard.
            /// </summary>
            public bool Heard;
        }
    }
}
