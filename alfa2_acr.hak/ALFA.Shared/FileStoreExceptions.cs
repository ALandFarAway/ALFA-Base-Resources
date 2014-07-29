using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// An exception thrown if a conditional file operation failed due to the
    /// condition not being evaluated to true.
    /// </summary>
    public class FileStoreConditionNotMetException : ApplicationException
    {
        public FileStoreConditionNotMetException(Exception InnerException) : base(InnerException.Message, InnerException)
        {
        }
    }
}