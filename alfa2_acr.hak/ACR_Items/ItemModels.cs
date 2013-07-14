using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using OEIShared.IO.GFF;

namespace ACR_Items
{
    public class ItemModels
    {
        public static int GetPreviousModel(List<int> models, int currentModel)
        {
            for (int c = 0; c < models.Count; c++)
            {
                if (models[c] == currentModel)
                {
                    if (c == 0)
                    {
                        return models[models.Count - 1];
                    }
                    else
                    {
                        return models[c - 1];
                    }
                }
            }
            return models[0];
        }

        public static int GetNextModel(List<int> models, int currentModel)
        {
            for (int c = 0; c < models.Count; c++)
            {
                if (models[c] == currentModel)
                {
                    if (c == (models.Count - 1))
                    {
                        return models[0];
                    }
                    else
                    {
                        return models[c + 1];
                    }
                }
            }
            return models[0];
        }

        public static int GetPreviousKey(Dictionary<int, List<int>> models, int currentModel)
        {
            int prevModel = -1;
            foreach (int key in models.Keys)
            {
                if (key == currentModel)
                {
                    if (prevModel != -1)
                    {
                        return prevModel;
                    }
                }
                prevModel = key;
            }
            return prevModel;
        }

        public static int GetNextKey(Dictionary<int, List<int>> models, int currentModel)
        {
            bool found = true;
            foreach (int key in models.Keys)
            {
                if (found) return key;
                if (key == currentModel)
                {
                    found = true;
                }
            }

            // either the current key is the last one or we hit an error. Return the first key.
            foreach (int key in models.Keys)
            {
                return key;
            }
            return -1;
        }

        public static void TakeArmorStyle(GFFFile armor, ArmorSet set)
        {
            armor.TopLevelStruct["ArmorVisualType"].ValueByte = (byte)set.ArmorVisualType;
            armor.TopLevelStruct["Variation"].ValueByte = (byte)set.ArmorVariation;

            List<GFFField> removals = new List<GFFField>();
            foreach (GFFField armorPiece in armor.TopLevelStruct.Fields.Values)
            {
                if (armorPiece.StringLabel == "Belt")
                {
                    if (set.BeltVariation < 0 || set.BeltVisualType < 0)
                    {
                        removals.Add(armorPiece);
                    }
                    else
                    {
                        armorPiece.ValueStruct["Variation"].ValueByte = (byte)set.BeltVariation;
                        armorPiece.ValueStruct["ArmorVisualType"].ValueByte = (byte)set.BeltVisualType;
                    }
                }
                else if (armorPiece.StringLabel == "Boots")
                {
                    if (set.BootsVariation < 0 || set.BootsVisualType < 0)
                    {
                        removals.Add(armorPiece);
                    }
                    else
                    {
                        armorPiece.ValueStruct["Variation"].ValueByte = (byte)set.BootsVariation;
                        armorPiece.ValueStruct["ArmorVisualType"].ValueByte = (byte)set.BootsVisualType;
                    }
                }
                else if (armorPiece.StringLabel == "Cloak")
                {
                    if (set.BootsVariation < 0 || set.BootsVisualType < 0)
                    {
                        removals.Add(armorPiece);
                    }
                    else
                    {
                        armorPiece.ValueStruct["Variation"].ValueByte = (byte)set.CloakVariation;
                        armorPiece.ValueStruct["ArmorVisualType"].ValueByte = (byte)set.CloakVisualType;
                    }
                }
                else if (armorPiece.StringLabel == "Gloves")
                {
                    if (set.GlovesVariation < 0 || set.GlovesVisualType < 0)
                    {
                        removals.Add(armorPiece);
                    }
                    else
                    {
                        armorPiece.ValueStruct["Variation"].ValueByte = (byte)set.GlovesVariation;
                        armorPiece.ValueStruct["ArmorVisualType"].ValueByte = (byte)set.GlovesVisualType;
                    }
                }
                else if (armorPiece.StringLabel == "Helm")
                {
                    if (set.GlovesVariation < 0 || set.GlovesVisualType < 0)
                    {
                        removals.Add(armorPiece);
                    }
                    else
                    {
                        armorPiece.ValueStruct["Variation"].ValueByte = (byte)set.HelmetVariation;
                        armorPiece.ValueStruct["ArmorVisualType"].ValueByte = (byte)set.HelmetVisualType;
                    }
                }
            }
            foreach (GFFField toRemove in removals)
            {
                armor.TopLevelStruct.Fields.Remove(toRemove);
            }

            armor.TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftAnkle; 
            armor.TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftArm; 
            armor.TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftBracer; 
            armor.TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftElbow; 
            armor.TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftFoot; 
            armor.TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftHip; 
            armor.TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftKnee; 
            armor.TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftLeg; 
            armor.TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftShin;
            armor.TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte = (byte)set.LeftShoulder; 
            armor.TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte = (byte)set.RightAnkle; 
            armor.TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte = (byte)set.RightArm; 
            armor.TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte = (byte)set.RightBracer; 
            armor.TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte = (byte)set.RightElbow; 
            armor.TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte = (byte)set.RightFoot; 
            armor.TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte = (byte)set.RightHip; 
            armor.TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte = (byte)set.RightKnee; 
            armor.TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte = (byte)set.RightLeg; 
            armor.TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte = (byte)set.RightShin; 
            armor.TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte = (byte)set.RightShoulder; 
            armor.TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte = (byte)set.FrontHip; 
            armor.TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte = (byte)set.BackHip; 
        }

        public static void AddArmorPiece(GFFFile armor, string type, Dictionary<int, List<int>> availableTypes)
        {
            GFFStructField pieceTop = new GFFStructField();
            pieceTop.StringLabel = type;
            pieceTop.ValueStruct = new GFFStruct();

            GFFByteField variation = new GFFByteField();
            variation.StringLabel = "Variation";
            variation.ValueByte = 0;
            GFFByteField visualType = new GFFByteField();
            visualType.StringLabel = "ArmorVisualType";
            visualType.ValueByte = 0;
            GFFStructField tintTop = new GFFStructField();
            tintTop.StringLabel = "ArmorTint";
            tintTop.ValueStruct = new GFFStruct();
            pieceTop.ValueStruct.Fields.Add("Variation", variation);
            pieceTop.ValueStruct.Fields.Add("ArmorVisualType", visualType);
            pieceTop.ValueStruct.Fields.Add("ArmorTint", tintTop);

            GFFStructField tintOne = new GFFStructField();
            tintOne.StringLabel = "1";
            tintOne.ValueStruct = new GFFStruct();
            GFFStructField tintTwo = new GFFStructField();
            tintTwo.StringLabel = "2";
            tintTwo.ValueStruct = new GFFStruct();
            GFFStructField tintThree = new GFFStructField();
            tintThree.StringLabel = "3";
            tintThree.ValueStruct = new GFFStruct();
            pieceTop.ValueStruct["ArmorTint"].ValueStruct.Fields.Add("1", tintOne);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct.Fields.Add("2", tintTwo);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct.Fields.Add("3", tintThree);

            GFFByteField rOne = new GFFByteField();
            rOne.ValueByte = 255;
            rOne.StringLabel = "r";
            GFFByteField gOne = new GFFByteField();
            gOne.ValueByte = 255;
            gOne.StringLabel = "g";
            GFFByteField bOne = new GFFByteField();
            bOne.ValueByte = 255;
            bOne.StringLabel = "b";
            GFFByteField aOne = new GFFByteField();
            aOne.ValueByte = 255;
            aOne.StringLabel = "a";
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["1"].ValueStruct.Fields.Add("r", rOne);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["1"].ValueStruct.Fields.Add("g", gOne);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["1"].ValueStruct.Fields.Add("b", bOne);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["1"].ValueStruct.Fields.Add("a", aOne);

            GFFByteField rTwo = new GFFByteField();
            rTwo.ValueByte = 255;
            rTwo.StringLabel = "r";
            GFFByteField gTwo = new GFFByteField();
            gTwo.ValueByte = 255;
            gTwo.StringLabel = "g";
            GFFByteField bTwo = new GFFByteField();
            bTwo.ValueByte = 255;
            bTwo.StringLabel = "b";
            GFFByteField aTwo = new GFFByteField();
            aTwo.ValueByte = 255;
            aTwo.StringLabel = "a";
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["2"].ValueStruct.Fields.Add("r", rTwo);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["2"].ValueStruct.Fields.Add("g", gTwo);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["2"].ValueStruct.Fields.Add("b", bTwo);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["2"].ValueStruct.Fields.Add("a", aTwo);

            GFFByteField rThree = new GFFByteField();
            rThree.ValueByte = 255;
            rThree.StringLabel = "r";
            GFFByteField gThree = new GFFByteField();
            gThree.ValueByte = 255;
            gThree.StringLabel = "g";
            GFFByteField bThree = new GFFByteField();
            bThree.ValueByte = 255;
            bThree.StringLabel = "b";
            GFFByteField aThree = new GFFByteField();
            aThree.ValueByte = 255;
            aThree.StringLabel = "a";
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["3"].ValueStruct.Fields.Add("r", rThree);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["3"].ValueStruct.Fields.Add("g", gThree);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["3"].ValueStruct.Fields.Add("b", bThree);
            pieceTop.ValueStruct["ArmorTint"].ValueStruct["3"].ValueStruct.Fields.Add("a", aThree);

            armor.TopLevelStruct.Fields.Add(type, pieceTop);
        }
    }
}
