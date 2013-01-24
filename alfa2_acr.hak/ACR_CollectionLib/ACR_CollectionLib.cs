using System;
using System.Collections;
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

namespace ACR_CollectionLib
{
    public partial class ACR_CollectionLib : CLRScriptBase, IGeneratedScriptProgram
    {

        // Generic array.
        private static Dictionary<string, ArrayList> m_ArrayList = new Dictionary<string, ArrayList>();

        // Lists for the NW data types.
        private static Dictionary<string, List<int>> m_IntList = new Dictionary<string, List<int>>();
        //public Dictionary<string, List<float>> m_FloatList;
        //public Dictionary<string, List<string>> m_StringList;
        //public Dictionary<string, List<int>> m_ObjectList;

        // Dictionaries for NW data types.
        //public Dictionary<string, Dictionary<string, int>> m_IntDict;
        //public Dictionary<string, Dictionary<string, float>> m_FloatDict;
        //public Dictionary<string, Dictionary<string, string>> m_StringDict;
        //public Dictionary<string, Dictionary<string, int>> m_ObjectDict;

        // Queues for NWN2 data types.
        //public Dictionary<string, Queue<int>> m_IntQueue;
        //public Dictionary<string, Queue<float>> m_FloatQueue;
        //public Dictionary<string, Queue<string>> m_StringQueue;
        //public Dictionary<string, Queue<int>> m_ObjectQueue;

        // Stacks for NWN2 data types.
        //public Dictionary<string, Stack<int>> m_IntStack;
        //public Dictionary<string, Stack<float>> m_FloatStack;
        //public Dictionary<string, Stack<string>> m_StringStack;
        //public Dictionary<string, Stack<int>> m_ObjectStack;

        /// <summary>
        /// Define type codes for request collection types to ScriptMain.
        /// </summary>
        private enum COLLECTION_CODE
        {
            ARRAY_LIST,
            INT_LIST,
            FLOAT_LIST,
            STRING_LIST,
            OBJECT_LIST,
            INT_DICTIONARY,
            FLOAT_DICTIONARY,
            STRING_DICTIONARY,
            OBJECT_DICTIONARY,
            INT_QUEUE,
            FLOAT_QUEUE,
            STRING_QUEUE,
            OBJECT_QUEUE,
            INT_STACK,
            FLOAT_STACK,
            STRING_STACK,
            OBJECT_STACK,
            RESULT
        }

        private enum METHOD_CODE
        {
            CREATE,
            CREATE_IF_NOT_EXISTS,
            DELETE,
            DELETE_IF_EXISTS,
            EXISTS,
            ADD,
            COUNT,
            CLEAR,
            CONTAINS,
            CONTAINS_KEY,
            CONTAINS_VALUE,
            ELEMENT_AT,
            FIND,
            FIND_LAST,
            FIRST,
            INDEX_OF,
            INSERT,
            LAST,
            LAST_INDEX_OF,
            MAX,
            MIN,
            PEEK,
            POP,
            PUSH,
            REMOVE,
            REMOVE_AT,
            REMOVE_RANGE,
            REVERSE,
            SET_AT_INDEX,
            SORT,
            SUM
        }

        /// <summary>
        /// Define type codes for request collection types to ScriptMain.
        /// </summary>
        private enum DATA_TYPE
        {
            INT,
            FLOAT,
            STRING,
            OBJECT
        }

        // Module variables for return values.
        const string ACR_COLLECTION_RESULT_VAR_INT = "ACR_COLLECTION_RES_INT";
        const string ACR_COLLECTION_RESULT_VAR_FLOAT = "ACR_COLLECTION_RES_FLT";
        const string ACR_COLLECTION_RESULT_VAR_STRING = "ACR_COLLECTION_RES_STR";
        const string ACR_COLLECTION_RESULT_VAR_OBJECT = "ACR_COLLECTION_RES_OBJ";

        public ACR_CollectionLib([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_CollectionLib([In] ACR_CollectionLib Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        // ACR_CollectionLib( COLLECTION_CODE nCollection, METHOD_CODE nMethodCode, string sCollectionName, int nParamInt1, int nParamInt2, float fParamFlt1, float fParamFlt2, string sParamStr1, string sParamStr2 );
        public static Type[] ScriptParameterTypes = { typeof(int), typeof(int), typeof(string), typeof(int), typeof(int), typeof(float), typeof(float), typeof(string), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            // Parse our parameters.
            int nCollection = (int)ScriptParameters[0];
            int nMethodCode = (int)ScriptParameters[1];
            string sCollectionName = (string)ScriptParameters[2];
            int nParamInt1 = (int)ScriptParameters[3];
            int nParamInt2 = (int)ScriptParameters[4];
            float fParamFlt1 = (float)ScriptParameters[5];
            float fParamFlt2 = (float)ScriptParameters[6];
            string sParamStr1 = (string)ScriptParameters[7];
            string sParamStr2 = (string)ScriptParameters[8];


            // Return value.
            Int32 nReturnValue = DefaultReturnCode;

            // What type of request are we making?
            switch ((COLLECTION_CODE)nCollection)
            {
                case COLLECTION_CODE.INT_LIST:
                    nReturnValue = HandleIntList(sCollectionName, (METHOD_CODE)nMethodCode, nParamInt1, nParamInt2);
                    break;
            }

            return nReturnValue;
        }

        private void SetReturnInt(int nValue)
        {
            SetLocalInt(GetModule(), ACR_COLLECTION_RESULT_VAR_INT, nValue);
        }

        private void SetReturnFloat(float fValue)
        {
            SetLocalFloat(GetModule(), ACR_COLLECTION_RESULT_VAR_FLOAT, fValue);
        }

        private void SetReturnString(string sValue)
        {
            SetLocalString(GetModule(), ACR_COLLECTION_RESULT_VAR_STRING, sValue);
        }

        private void SetReturnObject(uint uValue)
        {
            SetLocalObject(GetModule(), ACR_COLLECTION_RESULT_VAR_OBJECT, uValue);
        }

        private Int32 HandleIntList(string sCollectionName, METHOD_CODE nMethodCode, int nParam1, int nParam2)
        {
            Int32 nReturnValue = 0;

            // Make sure the collection does (or does not) exist.
            if (nMethodCode == METHOD_CODE.CREATE)
            {
                if (m_IntList.ContainsKey(sCollectionName))
                {
                    // This collection already exists.
                    return -3401;
                }
            }
            else
            {
                if (!m_IntList.ContainsKey(sCollectionName))
                {
                    // Collection does not exist, cannot be accessed.
                    return -3402;
                }
            }

            // Handle the request.
            switch (nMethodCode)
            {
                case METHOD_CODE.CREATE:
                    m_IntList.Add(sCollectionName, new List<int>());
                    break;
                case METHOD_CODE.DELETE:
                    m_IntList.Remove(sCollectionName);
                    break;
                case METHOD_CODE.ADD:
                    m_IntList[sCollectionName].Add(nParam1);
                    break;
                case METHOD_CODE.CLEAR:
                    m_IntList[sCollectionName].Clear();
                    break;
                case METHOD_CODE.CONTAINS:
                    SetReturnInt(Convert.ToInt32(m_IntList[sCollectionName].Contains(nParam1)));
                    break;
                case METHOD_CODE.COUNT:
                    SetReturnInt(m_IntList[sCollectionName].Count());
                    break;
                case METHOD_CODE.ELEMENT_AT:
                    SetReturnInt(m_IntList[sCollectionName].ElementAt(nParam1));
                    break;
                case METHOD_CODE.FIRST:
                    SetReturnInt(m_IntList[sCollectionName].First());
                    break;
                case METHOD_CODE.INDEX_OF:
                    SetReturnInt(m_IntList[sCollectionName].IndexOf(nParam1));
                    break;
                case METHOD_CODE.INSERT:
                    m_IntList[sCollectionName].Insert(nParam1, nParam2);
                    break;
                case METHOD_CODE.MAX:
                    SetReturnInt(m_IntList[sCollectionName].Max());
                    break;
                case METHOD_CODE.MIN:
                    SetReturnInt(m_IntList[sCollectionName].Min());
                    break;
                case METHOD_CODE.REMOVE:
                    m_IntList[sCollectionName].Remove(nParam1);
                    break;
                case METHOD_CODE.REMOVE_AT:
                    m_IntList[sCollectionName].RemoveAt(nParam1);
                    break;
                case METHOD_CODE.REMOVE_RANGE:
                    m_IntList[sCollectionName].RemoveRange(nParam1, nParam2);
                    break;
                case METHOD_CODE.REVERSE:
                    m_IntList[sCollectionName].Reverse();
                    break;
                case METHOD_CODE.SET_AT_INDEX:
                    m_IntList[sCollectionName].Sort();
                    break;
                case METHOD_CODE.SUM:
                    SetReturnInt(m_IntList[sCollectionName].Sum());
                    break;
                default:
                    nReturnValue = -3403;
                    break;
            }

            return nReturnValue;
        }

    }
}
