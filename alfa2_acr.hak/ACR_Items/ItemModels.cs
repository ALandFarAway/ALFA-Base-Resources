using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

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
                        return models[models.Count];
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
    }
}
