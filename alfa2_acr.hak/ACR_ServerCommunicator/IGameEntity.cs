using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This interface encapsulates common methods available for a game entity.
    /// </summary>
    interface IGameEntity
    {

        /// <summary>
        /// This property returns the database id of the object.
        /// </summary>
        int DatabaseId { get; }

        /// <summary>
        /// This property returns the name of the object.
        /// </summary>
        string Name { get; }

        /// <summary>
        /// Populate the contents of the entity from the database.  It is
        /// assumed that the entity id has been set already.
        /// </summary>
        void PopulateFromDatabase();
    }
}
