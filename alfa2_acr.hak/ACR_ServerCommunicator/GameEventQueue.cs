using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA;
using CLRScriptFramework;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This class represents recorded game events that need to be dispatched
    /// from within a script context.
    /// 
    /// Synchronization is assumed to be externally provided.
    /// </summary>
    class GameEventQueue
    {

        /// <summary>
        /// Create a new GameEventQueue.
        /// </summary>
        /// <param name="WorldManager">Supplies the associated WorldManager
        /// object.</param>
        public GameEventQueue(GameWorldManager WorldManager)
        {
            this.WorldManager = WorldManager;
        }

        /// <summary>
        /// Push an event onto the event queue.
        /// </summary>
        /// <param name="Event">Supplies the event to push.</param>
        public void EnqueueEvent(IGameEventQueueEvent Event)
        {
            EventQueue.Enqueue(Event);
        }

        /// <summary>
        /// Run the event queue down.  All events in the queue are given a
        /// chance to run.
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void RunQueue(CLRScriptBase Script, ALFA.Database Database)
        {
            while (!Empty())
            {
                IGameEventQueueEvent Event = EventQueue.Dequeue();

                Event.DispatchEvent(Script, Database);
            }
        }

        /// <summary>
        /// Check if the queue is empty.
        /// </summary>
        /// <returns>True if the queue is empty.</returns>
        public bool Empty()
        {
            return (EventQueue.Count == 0);
        }

        /// <summary>
        /// The associated game world manager.
        /// </summary>
        private GameWorldManager WorldManager;

        /// <summary>
        /// The associated event queue.
        /// </summary>
        private Queue<IGameEventQueueEvent> EventQueue = new Queue<IGameEventQueueEvent>();
    }

    /// <summary>
    /// This interface represents a packaged up event that needs to be handled
    /// in the script context.
    /// </summary>
    interface IGameEventQueueEvent
    {

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        void DispatchEvent(CLRScriptBase Script, ALFA.Database Database);
    }
}
