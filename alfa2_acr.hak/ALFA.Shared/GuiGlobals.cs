//
// This module contains GUI global variable constant definitions.
//
// Keep in sync with acr_guiglobals_i.nss.
// 

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// This class defines GUI variable constants that are used with the custom
    /// GUI system.  GUI global variable constants must be coordinated across
    /// all users of the GUI system.
    /// 
    /// These constants should be kept in sync with acr_guiglobals_i.nss.
    /// </summary>
    public static class GuiGlobals
    {
        // Used by the DM creator chooser to identify the valid target list.
        public const int ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST = 198;

        // Used by the DM creator chooser to identify the target script name.
        public const int ACR_GUI_GLOBAL_CREATOR_TARGET_SCRIPT_NAME = 199;

        // Used by the DM creator chooser to identify the target script parameter.
        public const int ACR_GUI_GLOBAL_CREATOR_TARGET_SCRIPT_NAME_PARAM = 200;

        // Used by the DM creator chooser to identify the created object type.
        public const int ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE = 201;
    }
}
