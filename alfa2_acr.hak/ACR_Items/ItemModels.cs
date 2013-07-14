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

        public static void AddArmorPiece(OEIShared.IO.GFF.GFFFile armor, string type, Dictionary<int, List<int>> availableTypes)
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
