using System;
using System.Collections.Generic;
using System.Text;
using NWN2Toolset.Plugins;
using TD.SandBar;

namespace ABM_creator
{
    class DoorCreator
    {
        NWN2Toolset.NWN2.Data.NWN2GameModule mod;
        NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint baseDoorBlueprint;
        OEIShared.IO.GFF.GFFStruct baseDoorStruct;

        public DoorCreator(string baseDoorResref)
        {
            baseDoorStruct = new OEIShared.IO.GFF.GFFStruct();
            baseDoorBlueprint.SaveEverythingIntoGFFStruct(baseDoorStruct, true);
        }

        void AddBlueprint(NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint dbp) {
            dbp.BlueprintLocation = mod.BlueprintLocation;
            dbp.Resource = mod.Repository.CreateResource(new OEIShared.Utils.OEIResRef(dbp.TemplateResRef.Value), dbp.ResourceType);
            mod.GetBlueprintCollectionForType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Door).Add(dbp);
        }

        NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint CreateDoor(string name, string description, string catigory, string resref, byte lockDC)
        {
            //new OEIShared.Utils.OEIResRef
            //NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint bdbp = mod.GetBlueprintCollectionForType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Door)[
            baseDoorStruct["TemplateResRef"].ValueCResRef = new OEIShared.Utils.OEIResRef(resref);
            NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint dbp = new NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint(baseDoorStruct);
            dbp.Classification = catigory;
            dbp.LocalizedName[OEIShared.Utils.BWLanguages.BWLanguage.English] = name;
            dbp.CloseLockDC = lockDC;
            dbp.OpenLockDC = lockDC;
            return dbp;
        }

        void CreateDoorsWithAllLocks(string catigory, string resref, string description, byte hardness, uint hitpoints, int breakStuckDC, int breakLockedDC, int listenMod)
        {
            CreateDoorType(resref + "_20", catigory + "|Lock: Very Simple", description, hardness, hitpoints, breakStuckDC, breakLockedDC, listenMod, 20);
            CreateDoorType(resref + "_25", catigory + "|Lock: Average", description, hardness, hitpoints, breakStuckDC, breakLockedDC, listenMod, 25);
            CreateDoorType(resref + "_30", catigory + "|Lock: Good", description, hardness, hitpoints, breakStuckDC, breakLockedDC, listenMod, 30);
            CreateDoorType(resref + "_35", catigory + "|Lock: Excellent", description, hardness, hitpoints, breakStuckDC, breakLockedDC, listenMod, 35);
            CreateDoorType(resref + "_40", catigory + "|Lock: Amazing", description, hardness, hitpoints, breakStuckDC, breakLockedDC, listenMod, 40);
        }

        void CreateDoorType(string resref, string catigory, string description, byte hardness, uint hitpoints, int breakStuckDC, int breakLockedDC, int listenMod, byte lockDC)
        {
            NWN2Toolset.NWN2.Data.Blueprints.NWN2DoorBlueprint dbp;

            dbp = CreateDoor("{ autoclose }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_CLOSE_DELAY"] = (float)300.0;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ autolock }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_AUTO_LOCK "] = (int)1;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ autolock, autoclose }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_CLOSE_DELAY"] = (float)300.0;
            dbp.Variables["ACR_DOOR_AUTO_LOCK "] = (int)1;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ locks days }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_UNLOCK_HOUR"] = (int)7;
            dbp.Variables["ACR_DOOR_LOCK_HOUR"] = (int)19;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ locks days, autoclose }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_UNLOCK_HOUR"] = (int)7;
            dbp.Variables["ACR_DOOR_LOCK_HOUR"] = (int)19;
            dbp.Variables["ACR_DOOR_CLOSE_DELAY"] = (float)300.0;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ locks nights }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_UNLOCK_HOUR"] = (int)19;
            dbp.Variables["ACR_DOOR_LOCK_HOUR"] = (int)7;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ locks nights, autoclose }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_UNLOCK_HOUR"] = (int)19;
            dbp.Variables["ACR_DOOR_LOCK_HOUR"] = (int)7;
            dbp.Variables["ACR_DOOR_CLOSE_DELAY"] = (float)300.0;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ no properties }", description, catigory, resref, lockDC);
            AddBlueprint(dbp);

            dbp = CreateDoor("{ stuck }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_STUCK_DC"] = (int)breakStuckDC;
            AddBlueprint(dbp);

            dbp = CreateDoor("{ unmoveable }", description, catigory, resref, lockDC);
            dbp.Variables["ACR_DOOR_UNMOVABLE"] = (int)1;
            AddBlueprint(dbp);
        }

        void Run()
        {
            CreateDoorsWithAllLocks("ALFA|Wood|Simple", "abr_do_w15", "", 5, 10, 13, 15, 4);
            CreateDoorsWithAllLocks("ALFA|Wood|Good", "abr_do_w18", "", 5, 15, 16, 18, 5);
            CreateDoorsWithAllLocks("ALFA|Wood|Strong", "abr_do_w25", "", 5, 20, 23, 25, 6);
            //CreateDoorType("ALFA|Wood|Portcullis", 5, 30, 25, 25, 8);

            CreateDoorsWithAllLocks("ALFA|Stone|Simple", "abr_do_s25", "", 8, 40, 25, 25, 8);
            CreateDoorsWithAllLocks("ALFA|Stone|Good", "abr_do_s28", "", 8, 60, 28, 28, 10);
            CreateDoorsWithAllLocks("ALFA|Stone|Strong", "abr_do_s35", "", 8, 80, 35, 35, 12);

            CreateDoorsWithAllLocks("ALFA|Iron|Simple", "abr_do_i25", "", 10, 40, 25, 25, 8);
            CreateDoorsWithAllLocks("ALFA|Iron|Good", "abr_do_i28", "", 10, 60, 28, 28, 10);
            CreateDoorsWithAllLocks("ALFA|Iron|Strong", "abr_do_i35", "", 10, 80, 35, 35, 12);
            //CreateDoorType("ALFA|Iron|Portcullis", 10, 60, 25, 25, 8);

            CreateDoorsWithAllLocks("ALFA|Gate, wooden|Simple", "abr_do_wg29", "", 5, 67, 29, 29, 8);
            CreateDoorsWithAllLocks("ALFA|Gate, wooden|Good", "abr_do_wg32", "", 5, 100, 32, 32, 10);
            CreateDoorsWithAllLocks("ALFA|Gate, wooden|Strong", "abr_do_wg39", "", 5, 133, 39, 39, 12);

            CreateDoorsWithAllLocks("ALFA|Gate, iron|Simple", "abr_do_ig33", "", 10, 93, 33, 33, 8);
            CreateDoorsWithAllLocks("ALFA|Gate, iron|Good", "abr_do_ig36", "", 10, 140, 36, 36, 10);
            CreateDoorsWithAllLocks("ALFA|Gate, iron|Strong", "abr_do_ig43", "", 10, 187, 43, 43, 12);

            CreateDoorsWithAllLocks("ALFA|Gate, stone|Simple", "abr_do_sg33", "", 8, 93, 33, 33, 13);
            CreateDoorsWithAllLocks("ALFA|Gate, stone|Good", "abr_do_sg36", "", 8, 140, 36, 36, 15);
            CreateDoorsWithAllLocks("ALFA|Gate, stone|Strong", "abr_do_sg43", "", 8, 187, 43, 43, 17);
        }

    }
}
