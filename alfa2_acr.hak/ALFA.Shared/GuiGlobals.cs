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


        // Used to create a script-calling target UI that is a 5' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_SINGLE = "target_single.xml";
        public const string ACR_GUI_GLOBAL_UINAME_SINGLE = "TARGET_SINGLE";

        // Used to create a script-calling target UI that is a 10' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_10FT = "target_circle6.xml";
        public const string ACR_GUI_GLOBAL_UINAME_10FT = "TARGET_CIRCLE6";

        // Used to create a script-calling target UI that is a 20' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_20FT = "target_circle9.xml";
        public const string ACR_GUI_GLOBAL_UINAME_20FT = "TARGET_CIRCLE9";

        // Used to create a script-calling target UI that is a 30' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_30FT = "target_circle12.xml";
        public const string ACR_GUI_GLOBAL_UINAME_30FT = "TARGET_CIRCLE12";

        // Used to create a script-calling target UI that is a 40' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_40FT = "target_circle15.xml";
        public const string ACR_GUI_GLOBAL_UINAME_40FT = "TARGET_CIRCLE15";

        // Used to create a script-calling target UI that is a 50' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_50FT = "target_circle18.xml";
        public const string ACR_GUI_GLOBAL_UINAME_50FT = "TARGET_CIRCLE18";

        // Used to create a script-calling target UI that is a 60' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_60FT = "target_circle24.xml";
        public const string ACR_GUI_GLOBAL_UINAME_60FT = "TARGET_CIRCLE24";

        // Used to create a script-calling target UI that is a 80' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_80FT = "target_circle30.xml";
        public const string ACR_GUI_GLOBAL_UINAME_80FT = "TARGET_CIRCLE30";

        // Used to create a script-calling target UI that is a 100' circle.
        public const string ACR_GUI_GLOBAL_TARGETUI_100FT = "target_circle36.xml";
        public const string ACR_GUI_GLOBAL_UINAME_100FT = "TARGET_CIRCLE36";
    }
}
