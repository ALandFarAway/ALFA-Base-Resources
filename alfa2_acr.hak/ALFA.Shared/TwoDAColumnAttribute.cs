using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// This class allows fields to be marked for 2DA serialization.
    /// </summary>
    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
    public class TwoDAColumnAttribute : Attribute
    {
        /// <summary>
        /// Mark a field as 2DA serializable with the column name deriving from
        /// the field name.  If an override column name is explicitly specified
        /// then it takes precedence over the field name.
        /// </summary>
        public TwoDAColumnAttribute()
        {
            ColumnName = null;
            SerializeAs = null;
            TalkString = false;
            Default = null;
            Index = false;
        }

        /// <summary>
        /// Get the override column name.  If null, the field name of the
        /// associated field should be used instead.
        /// </summary>
        public string ColumnName { get; set; }

        /// <summary>
        /// The type to serialize as.  If null, the type of the field is used.
        /// </summary>
        public Type SerializeAs { get; set; }

        /// <summary>
        /// If true, look up the value as a talk string.
        /// </summary>
        public bool TalkString { get; set; }

        /// <summary>
        /// Default value to assign if conversion fails.  Otherwise, the field
        /// is not assigned.
        /// </summary>
        public object Default { get; set; }

        /// <summary>
        /// If true, this field receives the row index of the current row, and
        /// not a column value.
        /// </summary>
        public bool Index { get; set; }

    }
}
