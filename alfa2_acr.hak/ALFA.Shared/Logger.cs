using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CLRScriptFramework;

namespace ALFA.Shared
{
    /// <summary>
    /// This class encapsulates a deferred log that is safe to use even in a
    /// context where scripts cannot directly invoke server script APIs.  It is
    /// periodically polled by the ACR_ServerCommunicator in order to flush the
    /// deferred log contents to the server log.
    /// </summary>
    public static class Logger
    {

        /// <summary>
        /// Write a deferred log message to the log.
        /// </summary>
        /// <param name="Format">Supplies the String.Format format string.
        /// </param>
        /// <param name="Inserts">Supplies any optional formatting inserts, as
        /// per String.Format.</param>
        public static void Log(string Format, params object[] Inserts)
        {
            try
            {
                string Message = String.Format(Format, Inserts);

                lock (LogMessages)
                {
                    LogMessages.Add(Message);
                }
            }
            catch
            {
            }
        }

        /// <summary>
        /// Flush any buffered log messages to the server main log file.
        /// 
        /// N.B.  The current time is used as the log message time stamp.  It
        ///       is assumed that the caller invokes the FlushLogMessages()
        ///       function sufficiently often that the time stamp is "close
        ///       enough" to meet.
        /// </summary>
        /// <param name="Script">Supplies the CLR script object.</param>
        public static void FlushLogMessages(CLRScriptBase Script)
        {
            lock (LogMessages)
            {
                if (LogMessages.Count == 0)
                    return;

                foreach (string Message in LogMessages)
                {
                    Script.WriteTimestampedLogEntry(Message);
                }

                LogMessages.Clear();
            }
        }

        /// <summary>
        /// A list of log messages available.
        /// </summary>
        private static List<string> LogMessages;
    }
}
