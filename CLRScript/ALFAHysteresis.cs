//
// This module contains logic for implementing an exponential backoff with
// historical decay (based on configurable parameters).
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{

    /// <summary>
    /// This class encapsulates state for implementing exponential backoff with
    /// historical decay.
    /// </summary>
    public class Hysteresis
    {

        /// <summary>
        /// Create a new Hysteresis object and initializes it to a default
        /// state.
        /// </summary>
        /// <param name="MinimumDelay">Supplies the lower bound limit on the
        /// delay returned, as expressed in milliseconds.</param>
        /// <param name="MaximumDelay">Supplies the upper bound limit on the
        /// delay returned, as expressed in milliseconds.</param>
        /// <param name="ResetDelay">Supplies the reset time at which the
        /// historical state of the system is thrown away.  This value must be
        /// greater than MaximumDelay.</param>
        public Hysteresis(uint MinimumDelay, uint MaximumDelay, uint ResetDelay)
        {
            this.MinimumDelay = MinimumDelay;
            this.MaximumDelay = MaximumDelay;
            this.ResetDelay = ResetDelay;
            this.LastUpdateTime = (uint)Environment.TickCount - ResetDelay;
            this.CurrentDelay = MinimumDelay;
        }

        /// <summary>
        /// This method calculates the next delay time to return, by examining
        /// the historical behavior of the system and returning a delay that is
        /// appropriate.
        /// 
        /// If at least ResetDelay milliseconds have passed since the
        /// immediately preceeding call to GetNextDelayTime(), the minimum
        /// configured delay time is returned.  Otherwise, twice the previous
        /// delay time is returned (up to the maximum delay time value).
        /// </summary>
        /// <returns>The next logical delay time is returned.</returns>
        public uint GetNextDelayTime()
        {
            uint Now = (uint)Environment.TickCount;
            uint TimePassed = Now - LastUpdateTime;

            if (TimePassed >= ResetDelay)
            {
                CurrentDelay = MinimumDelay;
            }
            else
            {
                CurrentDelay = Math.Max(CurrentDelay * 2, MaximumDelay);
            }

            LastUpdateTime = Now;

            return CurrentDelay;
        }

        /// <summary>
        /// The lower bound delay, in milliseconds.
        /// </summary>
        private uint MinimumDelay;

        /// <summary>
        /// The upper bound delay, in milliseconds.
        /// </summary>
        private uint MaximumDelay;

        /// <summary>
        /// The time, in milliseconds, after which a subsequent call to
        /// GetNextDelayTime will return the initial delay time.
        /// </summary>
        private uint ResetDelay;

        /// <summary>
        /// The last time that the delay was updated.
        /// </summary>
        private uint LastUpdateTime;

        /// <summary>
        /// The current delay time to return.
        /// </summary>
        private uint CurrentDelay;

    }   
}

