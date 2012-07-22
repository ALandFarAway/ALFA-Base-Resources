using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace DeploymentStager
{
    class DeploymentStager
    {
        public void Run()
        {
            // Load the imput file.
            XDocument InputDoc = XDocument.Load(InputFilename);
            XDocument PatchDoc = XDocument.Load(PatchFilename);
            List<XElement> resources = PatchDoc.Root.Element("files").Elements().ToList();
            for (int i = 0; i < resources.Count; i++)
            {
                string filepath = "";
                DependencyResource resource = new DependencyResource(resources[i], filepath);

                // Find the record in the patch.
                XElement patchElement = null;
                List<XElement> patchFiles = PatchDoc.Root.Element("files").Elements().ToList();
                for (int j = 0; j < patchFiles.Count; j++)
                {
                    if (patchFiles[j].Name.ToString().Equals(resource.name))
                    {
                        patchElement = patchFiles[i];
                        break;
                    }
                }

                // Stage the differences.
                resource.Stage(this, patchElement);
            }

            // Save the patch.
            PatchDoc.Save(PatchFilename);
        }

        public static string InputFilename = "input.xml";
        public static string PatchFilename = "patch.xml";
    }
}
