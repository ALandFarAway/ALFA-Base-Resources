using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using OEIShared.IO.TwoDA;

namespace ALFA.Shared
{
    /// <summary>
    /// This class reads a 2DA and converts it to a type.
    /// </summary>
    public static class TwoDAReader
    {
        /// <summary>
        /// Read each row from a 2DA file and convert it to a collection of
        /// custom types that are 2DA serializable.
        /// </summary>
        /// <typeparam name="T">Supplies the type to instantiate for each 2DA
        /// row.</typeparam>
        /// <typeparam name="TCollection">Supplies the type of collection to
        /// store the row values into.</typeparam>
        /// <param name="DataFile">Supplies the .2DA data file to read.</param>
        /// <returns>Returns a TCollection containing one T for each row in the
        /// .2DA file.</returns>
        public static TCollection Read2DA<T, TCollection>(TwoDAFile DataFile)
            where T : new()
            where TCollection : ICollection<T>, new()
        {
            TCollection Values = new TCollection();
            var ColumnFields = GetColumnFieldInfo(typeof(T));

            //
            // Sweep through each row in the .2DA and assign field values for each .2DA serializable
            // field to a new row object that will be added to the row values collection.
            //

            for (int RowIndex = 0; RowIndex < DataFile.RowCount; RowIndex += 1)
            {
                T Value = Read2DARow<T>(DataFile, RowIndex, ColumnFields);
                Values.Add(Value);
            }

            return Values;
        }

        /// <summary>
        /// Read a single row from a 2DA file and convert it to a collection of
        /// custom types that are 2DA serializable.
        /// </summary>
        /// <typeparam name="T">Supplies the type to instantiate for the row.
        /// </typeparam>
        /// <param name="DataFile">Supplies the .2DA data file to read.</param>
        /// <param name="RowIndex">Supplies the .2DA row number to
        /// read.</param>
        /// <param name="ColumnFields">Supplies the column field map which must
        /// be returned by GetColumnFieldInfo().</param>
        /// <returns>Returns a new T representing the .2DA row.<returns>
        public static T Read2DARow<T>(TwoDAFile DataFile, int RowIndex, IEnumerable<ColumnFieldInfo> ColumnFields)
            where T : new()
        {
            T Value = new T();

            //
            // Sweep through each column in the .2DA and assign fields based on
            // the TwoDAColumnAttribute deserialization descriptor assigned to
            // each .2DA deserializable field in the type.
            //

            foreach (TwoDAColumn Column in DataFile.Columns)
            {
                var ColumnInfo = ColumnFields.
                    Where(x => GetColumnName(x.Field, x.Column) == Column.Title).FirstOrDefault();

                if (ColumnInfo == null)
                    continue;

                object FieldValue = ColumnInfo.Column.Default;
                string RawValue = Column.LiteralValue(RowIndex);
                Type ValueType = ColumnInfo.ValueType;

                if (ColumnInfo.Column.Index)
                {
                    FieldValue = RowIndex;
                }
                else if (ColumnInfo.Column.TalkString)
                {
                    uint TalkIndex;

                    if (uint.TryParse(RawValue, out TalkIndex))
                        FieldValue = Modules.InfoStore.GetTalkString(TalkIndex);
                }
                else
                {
                    Type SerializeAs = ColumnInfo.Column.SerializeAs;

                    if (SerializeAs == null)
                        SerializeAs = ValueType;

                    if (SerializeAs == typeof(string))
                    {
                        FieldValue = RawValue;
                    }
                    else if (SerializeAs == typeof(int))
                    {
                        int ParsedValue;

                        if (int.TryParse(RawValue, out ParsedValue))
                            FieldValue = ParsedValue;
                    }
                    else if (SerializeAs == typeof(uint))
                    {
                        uint ParsedValue;

                        if (uint.TryParse(RawValue, out ParsedValue))
                            FieldValue = ParsedValue;
                    }
                    else if (SerializeAs == typeof(bool))
                    {
                        int IntValue;
                        bool ParsedValue;

                        if (bool.TryParse(RawValue, out ParsedValue))
                            FieldValue = ParsedValue;
                        else if (int.TryParse(RawValue, out IntValue))
                            FieldValue = (IntValue != 0);
                    }
                    else
                    {
                        throw new InvalidOperationException("Type " + typeof(T) + " cannot be converted from .2DA row; field " + ColumnInfo.Field.Name + " does not have a convertible type supported by TwoDAReader.Read2DA<T, TCollection>.");
                    }
                }

                //
                // Null field values are not assigned.
                //

                if (FieldValue == null)
                    continue;

                //
                // If necessary, coerce the serialized as type to the field
                // type.
                //

                if (FieldValue.GetType() != ValueType)
                    FieldValue = Convert.ChangeType(FieldValue, ValueType);

                ColumnInfo.SetValue(Value, FieldValue);
            }

            return Value;
        }

        /// <summary>
        /// Retrieve a tuple of (Field, 2DAColumnAttribute) for each public
        /// instance field that is .2DA serializable in the generic type T.
        /// If the type has no .2DA serializable fields, then an
        /// InvalidOperationException is raised.
        /// </summary>
        /// <param name="T">Supplies the type to retrieve the data for.</param>
        /// <returns>A map of fields to .2DA serialization data.</returns>
        public static IEnumerable<ColumnFieldInfo> GetColumnFieldInfo(Type T)
        {
            var ColumnFields = T.GetMembers(BindingFlags.Public | BindingFlags.Instance)
                .Select(Fld => new ColumnFieldInfo { Field = Fld, Column = (TwoDAColumnAttribute)(Fld.GetCustomAttributes(typeof(TwoDAColumnAttribute), false).FirstOrDefault()) })
                .Where(ColFld => ColFld.Column != null && ColFld.ValueType != null);

            //
            // The type should have at least one serializable field.
            //

            if (ColumnFields.Any() == false)
                throw new InvalidOperationException("Type " + T.ToString() + " is not .2DA serializable.");

            return ColumnFields;
        }

        /// <summary>
        /// Map of field to .2DA deserialization information.
        /// </summary>
        public class ColumnFieldInfo
        {
            /// <summary>
            /// The field data.
            /// </summary>
            public MemberInfo Field;
            /// <summary>
            /// The associated .2DA deserialization descriptor.
            /// </summary>
            public TwoDAColumnAttribute Column;

            /// <summary>
            /// The type of the member.
            /// </summary>
            public Type ValueType
            {
                get
                {
                    FieldInfo Fld = Field as FieldInfo;

                    if (Fld != null)
                        return Fld.FieldType;

                    PropertyInfo Prop = Field as PropertyInfo;

                    if (Prop != null)
                        return Prop.PropertyType;

                    return null;
                }
            }

            /// <summary>
            /// Set the property or field value.
            /// </summary>
            /// <param name="Obj">Supplies the parent object.</param>
            /// <param name="Value">Supplies the value to assign.</param>
            public void SetValue(object Obj, object Value)
            {
                FieldInfo Fld = Field as FieldInfo;

                if (Fld != null)
                {
                    Fld.SetValue(Obj, Value);
                    return;
                }

                PropertyInfo Prop = Field as PropertyInfo;

                if (Prop != null)
                {
                    Prop.SetValue(Obj, Value, null);
                    return;
                }

                throw new InvalidOperationException("TwoDAColumnAttribute applied to invalid member.");
            }
        }

        /// <summary>
        /// Get the effective column name of a .2DA serializable field.
        /// </summary>
        /// <param name="Field">Supplies the field descriptor.</param>
        /// <param name="ColumnInfo">Supplies the .2DA serialization
        /// descriptor.</param>
        /// <returns>The effective column name.</returns>
        private static string GetColumnName(MemberInfo Field, TwoDAColumnAttribute ColumnInfo)
        {
            if (ColumnInfo.ColumnName != null)
                return ColumnInfo.ColumnName;
            else
                return Field.Name;
        }
    }
}
