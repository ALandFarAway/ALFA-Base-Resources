using ALFA.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;


namespace ACR_Quest
{
    public class RandomDungeon
    {
        public NWLocation retLoc;
        public int CR;
        public string SpawnType = "";

        Random rnd = new Random();

        public RandomDungeon(string areaPrefix, int areasToGenerate, int cr, string name, CLRScriptBase script)
        {
            CR = cr;
            DungeonStore.FindAvailableAreas(areaPrefix);

            List<RandomDungeonArea> sourceAreas;

            if (areasToGenerate >= 6) sourceAreas = DungeonStore.AvailableAreas[areaPrefix];
            else if(areasToGenerate > 1)
            {
                sourceAreas = new List<RandomDungeonArea>();
                foreach(RandomDungeonArea area in DungeonStore.AvailableAreas[areaPrefix])
                {
                    if(area.AreaExits.Count <= areasToGenerate && area.AreaExits.Count > 1)
                    {
                        sourceAreas.Add(area);
                    }
                }
            }
            else
            {
                sourceAreas = new List<RandomDungeonArea>();
                foreach (RandomDungeonArea area in DungeonStore.AvailableAreas[areaPrefix])
                {
                    if (area.AreaExits.Count == 1)
                    {
                        sourceAreas.Add(area);
                    }
                }
            }

            RandomDungeonArea template = sourceAreas[rnd.Next(sourceAreas.Count)];
            RandomDungeonArea toAdd = new RandomDungeonArea();
            toAdd.TemplateAreaId = template.AreaId;
            toAdd.DungeonName = name;
            toAdd.AreaExits = new List<ExitDirection>();
            toAdd.AreaExits.AddRange(template.AreaExits);
            toAdd.DungeonExit = toAdd.AreaExits[rnd.Next(toAdd.AreaExits.Count)];
            toAdd.AreaExits.Remove(toAdd.DungeonExit);
            toAdd.X = areasToGenerate + 1;
            toAdd.Y = areasToGenerate + 1;
            toAdd.Z = areasToGenerate + 1;
            toAdd.CR = cr;
            areasToGenerate -= toAdd.AreaExits.Count;
            areasToGenerate -= 1;
            AreasOfDungeon.Add(toAdd);

            if (areasToGenerate == 0) return;

            List<RandomDungeonArea> areasNeedingAdjacentAreas = new List<RandomDungeonArea>();
            areasNeedingAdjacentAreas.Add(toAdd);

            while(areasToGenerate > 0)
            {
                // Early return if we don't actually have any areas left to expand.
                if (areasNeedingAdjacentAreas.Count == 0) return;

                // Randomly select one of our bare ends to build out from.
                RandomDungeonArea toExpand = areasNeedingAdjacentAreas[rnd.Next(areasNeedingAdjacentAreas.Count)];

                // Build a temporary collection of exit directions from this area, but
                // don't count the directions that already have adjacent areas.
                List<ExitDirection> NextAreaDirections = new List<ExitDirection>();
                NextAreaDirections.AddRange(toExpand.AreaExits);
                foreach(ExitDirection used in toExpand.AdjacentAreas.Keys)
                {
                    NextAreaDirections.Remove(used);
                }
                if(NextAreaDirections.Count == 0)
                {
                    // If that's all of the exits, then this area shouldn't actually be on the list
                    // of candidates to expand.
                    areasNeedingAdjacentAreas.Remove(toExpand);
                    continue;
                }

                // Pick a random direction out of those available and set the new area's coordinates
                // appropriately.
                ExitDirection nextAreaDirection = NextAreaDirections[rnd.Next(NextAreaDirections.Count)];
                toAdd = new RandomDungeonArea();
                switch(nextAreaDirection)
                {
                    case ExitDirection.North:
                        toAdd.X = toExpand.X;
                        toAdd.Y = toExpand.Y + 1;
                        toAdd.Z = toExpand.Z;
                        break;
                    case ExitDirection.East:
                        toAdd.X = toExpand.X + 1;
                        toAdd.Y = toExpand.Y;
                        toAdd.Z = toExpand.Z;
                        break;
                    case ExitDirection.South:
                        toAdd.X = toExpand.X;
                        toAdd.Y = toExpand.Y - 1;
                        toAdd.Z = toExpand.Z;
                        break;
                    case ExitDirection.West:
                        toAdd.X = toExpand.X - 1;
                        toAdd.Y = toExpand.Y;
                        toAdd.Z = toExpand.Z;
                        break;
                    case ExitDirection.Up:
                        toAdd.X = toExpand.X;
                        toAdd.Y = toExpand.Y;
                        toAdd.Z = toExpand.Z + 1;
                        break;
                    case ExitDirection.Down:
                        toAdd.X = toExpand.X;
                        toAdd.Y = toExpand.Y;
                        toAdd.Z = toExpand.Z - 1;
                        break;
                }

                // Scan for adjacent areas, and determine the necessary parts of the target area.
                Dictionary<ExitDirection, bool> necessaryBorders = new Dictionary<ExitDirection,bool>();
                Dictionary<ExitDirection, RandomDungeonArea> adjacentToBe = new Dictionary<ExitDirection,RandomDungeonArea>();
                foreach(RandomDungeonArea area in AreasOfDungeon)
                {
                    if(area.X == toAdd.X && area.Y == toAdd.Y && area.Z == toAdd.Z + 1)
                    {
                        // Area is above the new area.
                        if(area.AreaExits.Contains(ExitDirection.Down))
                        {
                            necessaryBorders.Add(ExitDirection.Up, true);
                            adjacentToBe.Add(ExitDirection.Up, area);
                        }
                        else if(!necessaryBorders.ContainsKey(ExitDirection.Up))
                        {
                            // This location might have double end caps in it.
                            necessaryBorders.Add(ExitDirection.Up, false);
                        }
                    }
                    else if(area.X == toAdd.X && area.Y == toAdd.Y && area.Z == toAdd.Z - 1)
                    {
                        if(area.AreaExits.Contains(ExitDirection.Up))
                        {
                            necessaryBorders.Add(ExitDirection.Down, true);
                            adjacentToBe.Add(ExitDirection.Down, area);
                        }
                        else if(!necessaryBorders.ContainsKey(ExitDirection.Down))
                        {
                            necessaryBorders.Add(ExitDirection.Down, false);
                        }
                    }
                    else if(area.X == toAdd.X + 1 && area.Y == toAdd.Y && area.Z == toAdd.Z)
                    {
                        if(area.AreaExits.Contains(ExitDirection.West))
                        {
                            necessaryBorders.Add(ExitDirection.East, true);
                            adjacentToBe.Add(ExitDirection.East, area);
                        }
                        else if(!necessaryBorders.ContainsKey(ExitDirection.East))
                        {
                            necessaryBorders.Add(ExitDirection.East, false);
                        }
                    }
                    else if(area.X == toAdd.X - 1 && area.Y == toAdd.Y && area.Z == toAdd.Z)
                    {
                        if(area.AreaExits.Contains(ExitDirection.East))
                        {
                            necessaryBorders.Add(ExitDirection.West, true);
                            adjacentToBe.Add(ExitDirection.West, area);
                        }
                        else if(!necessaryBorders.ContainsKey(ExitDirection.West))
                        {
                            necessaryBorders.Add(ExitDirection.West, false);
                        }
                    }
                    else if(area.X == toAdd.X && area.Y == toAdd.Y + 1 && area.Z == toAdd.Z)
                    {
                        if(area.AreaExits.Contains(ExitDirection.South))
                        {
                            necessaryBorders.Add(ExitDirection.North, true);
                            adjacentToBe.Add(ExitDirection.North, area);
                        }
                        else if(!necessaryBorders.ContainsKey(ExitDirection.North))
                        {
                            necessaryBorders.Add(ExitDirection.North, false);
                        }
                    }
                    else if(area.X == toAdd.X && area.Y == toAdd.Y - 1 && area.Z == toAdd.Z)
                    {
                        if(area.AreaExits.Contains(ExitDirection.North))
                        {
                            necessaryBorders.Add(ExitDirection.South, true);
                            adjacentToBe.Add(ExitDirection.South, area);
                        }
                        else if(!necessaryBorders.ContainsKey(ExitDirection.South))
                        {
                            necessaryBorders.Add(ExitDirection.South, false);
                        }
                    }
                }

                // Now that we know where the area is and what borders it has to maintain, we
                // loop through the areas that are available and build a list of all of the ones
                // that fit the restrictions of the area's location.
                sourceAreas.Clear();
                foreach(RandomDungeonArea area in DungeonStore.AvailableAreas[areaPrefix])
                {
                    bool areaUseful = true;
                    foreach(KeyValuePair<ExitDirection, bool> dir in necessaryBorders)
                    {
                        if(dir.Value)
                        {
                            if(!area.AreaExits.Contains(dir.Key)) areaUseful = false;
                        }
                        if(!dir.Value)
                        {
                            if(area.AreaExits.Contains(dir.Key)) areaUseful = false;
                        }
                        if(!areaUseful) break;
                    }
                    if(!areaUseful) break;
                    sourceAreas.Add(area);
                }

                if(sourceAreas.Count >= 1)
                {
                    // If we have more at least one area that fits the bill, we'll try to use that, so that
                    // the dungeon feels as connected and continuous as possible.
                    toAdd = new RandomDungeonArea();
                    template = sourceAreas[rnd.Next(sourceAreas.Count)];
                    toAdd.TemplateAreaId = template.AreaId;
                    toAdd.DungeonName = name;
                    toAdd.AreaExits = new List<ExitDirection>();
                    toAdd.AreaExits.AddRange(template.AreaExits);
                    toAdd.DungeonExit = toAdd.AreaExits[rnd.Next(toAdd.AreaExits.Count)];
                    toAdd.AreaExits.Remove(toAdd.DungeonExit);
                    toAdd.CR = cr;
                    areasToGenerate -= (toAdd.AreaExits.Count - toAdd.AdjacentAreas.Count);
                    foreach(KeyValuePair<ExitDirection, RandomDungeonArea> adj in adjacentToBe)
                    {
                        toAdd.AdjacentAreas.Add(adj.Key, adj.Value);
                        switch(adj.Key)
                        {
                            case ExitDirection.North:
                                adj.Value.AdjacentAreas.Add(ExitDirection.South, toAdd);
                                break;
                            case ExitDirection.South:
                                adj.Value.AdjacentAreas.Add(ExitDirection.North, toAdd);
                                break;
                            case ExitDirection.East:
                                adj.Value.AdjacentAreas.Add(ExitDirection.West, toAdd);
                                break;
                            case ExitDirection.West:
                                adj.Value.AdjacentAreas.Add(ExitDirection.East, toAdd);
                                break;
                            case ExitDirection.Up:
                                adj.Value.AdjacentAreas.Add(ExitDirection.Down, toAdd);
                                break;
                            case ExitDirection.Down:
                                adj.Value.AdjacentAreas.Add(ExitDirection.Up, toAdd);
                                break;
                        }
                    }
                    AreasOfDungeon.Add(toAdd);
                }
                else
                {
                    // But if no area fits the bill, we loop over each of the exits we're expecting and
                    // attach the dead end area with the appropriate exit to them.
                    foreach(KeyValuePair<ExitDirection, RandomDungeonArea> adj in adjacentToBe)
                    {
                        int X = toAdd.X;
                        int Y = toAdd.Y;
                        int Z = toAdd.Z;
                        switch(adj.Key)
                        {
                            case ExitDirection.North:
                                template = getSingleExitArea(ExitDirection.South, areaPrefix);
                                break;
                            case ExitDirection.South:
                                template = getSingleExitArea(ExitDirection.North, areaPrefix);
                                break;
                            case ExitDirection.East:
                                template = getSingleExitArea(ExitDirection.West, areaPrefix);
                                break;
                            case ExitDirection.West:
                                template = getSingleExitArea(ExitDirection.East, areaPrefix);
                                break;
                            case ExitDirection.Up:
                                template = getSingleExitArea(ExitDirection.Down, areaPrefix);
                                break;
                            case ExitDirection.Down:
                                template = getSingleExitArea(ExitDirection.Up, areaPrefix);
                                break;
                        }
                        toAdd = new RandomDungeonArea();
                        toAdd.X = X;
                        toAdd.Y = Y;
                        toAdd.Z = Z;
                        toAdd.TemplateAreaId = template.AreaId;
                        toAdd.DungeonName = name;
                        toAdd.AreaExits = new List<ExitDirection>();
                        toAdd.AreaExits.AddRange(template.AreaExits);
                        toAdd.DungeonExit = toAdd.AreaExits[rnd.Next(toAdd.AreaExits.Count)];
                        toAdd.AreaExits.Remove(toAdd.DungeonExit);
                        areasToGenerate -= (toAdd.AreaExits.Count - toAdd.AdjacentAreas.Count);
                        toAdd.AdjacentAreas.Add(adj.Key, adj.Value);
                        switch(adj.Key)
                        {
                            case ExitDirection.North:
                                adj.Value.AdjacentAreas.Add(ExitDirection.South, toAdd);
                                break;
                            case ExitDirection.South:
                                adj.Value.AdjacentAreas.Add(ExitDirection.North, toAdd);
                                break;
                            case ExitDirection.East:
                                adj.Value.AdjacentAreas.Add(ExitDirection.West, toAdd);
                                break;
                            case ExitDirection.West:
                                adj.Value.AdjacentAreas.Add(ExitDirection.East, toAdd);
                                break;
                            case ExitDirection.Up:
                                adj.Value.AdjacentAreas.Add(ExitDirection.Down, toAdd);
                                break;
                            case ExitDirection.Down:
                                adj.Value.AdjacentAreas.Add(ExitDirection.Up, toAdd);
                                break;
                        }
                        AreasOfDungeon.Add(toAdd);
                    }
                }
            }
        }

        public RandomDungeonArea GetEntranceArea()
        {
            foreach(RandomDungeonArea area in AreasOfDungeon)
            {
                if(area.DungeonExit != ExitDirection.None)
                {
                    return area;
                }
            }
            return null;
        }

        public RandomDungeonArea GetCurrentArea(CLRScriptBase script)
        {
            uint currentArea = script.GetArea(script.OBJECT_SELF);
            RandomDungeonArea currentAreaObject = null;
            foreach (RandomDungeonArea area in AreasOfDungeon)
            {
                if (area.AreaId == currentArea)
                {
                    currentAreaObject = area;
                    break;
                }
            }
            return currentAreaObject;
        }

        public RandomDungeonArea GetAdjacentArea(CLRScriptBase script, ExitDirection exit, RandomDungeonArea CurrentArea)
        {
            int X = CurrentArea.X;
            int Y = CurrentArea.Y;
            int Z = CurrentArea.Z;

            switch(exit)
            {
                case ExitDirection.North:
                    Y++;
                    break;
                case ExitDirection.East:
                    X++;
                    break;
                case ExitDirection.South:
                    Y--;
                    break;
                case ExitDirection.West:
                    X--;
                    break;
                case ExitDirection.Up:
                    Z++;
                    break;
                case ExitDirection.Down:
                    Z--;
                    break;
            }

            RandomDungeonArea targetArea = null;
            foreach(RandomDungeonArea area in AreasOfDungeon)
            {
                if(area.X == X && area.Y == Y && area.Z == Z)
                {
                    targetArea = area;
                    break;
                }
            }
            return targetArea;
        }

        private RandomDungeonArea getSingleExitArea(ExitDirection exit, string prefix)
        {
            foreach(RandomDungeonArea area in DungeonStore.AvailableAreas[prefix])
            {
                if(area.AreaExits.Contains(exit) && area.AreaExits.Count == 1)
                {
                    return area;
                }
            }
            return null;
        }

        public List<RandomDungeonArea> AreasOfDungeon = new List<RandomDungeonArea>();
    }

    public static class DungeonStore
    {
        public static Dictionary<string, RandomDungeon> Dungeons = new Dictionary<string, RandomDungeon>();

        public static Dictionary<string, List<RandomDungeonArea>> AvailableAreas = new Dictionary<string, List<RandomDungeonArea>>();

        public static Dictionary<uint, List<uint>> CachedAreas = new Dictionary<uint, List<uint>>();

        public static Dictionary<string, Dictionary<int, List<string>>> DungeonSpawns = new Dictionary<string, Dictionary<int, List<string>>>();

        public static ExitDirection GetOppositeDirection(ExitDirection original)
        {
            switch(original)
            {
                case ExitDirection.North: return ExitDirection.South;
                case ExitDirection.East: return ExitDirection.West;
                case ExitDirection.South: return ExitDirection.North;
                case ExitDirection.West: return ExitDirection.East;
                case ExitDirection.Up: return ExitDirection.Down;
                case ExitDirection.Down: return ExitDirection.Up;
            }
            return ExitDirection.None;
        }

        public static void FindAvailableAreas(string areaPrefix)
        {
            areaPrefix = areaPrefix.ToLower();

            // I guess we already cached this one. Do nothing else.
            if (AvailableAreas.ContainsKey(areaPrefix)) { return; }

            AvailableAreas.Add(areaPrefix, new List<RandomDungeonArea>());

            foreach (KeyValuePair<uint, ActiveArea> area in ALFA.Shared.Modules.InfoStore.ActiveAreas)
            {
                if(area.Value.Tag.Contains(areaPrefix))
                {
                    RandomDungeonArea genericArea = new RandomDungeonArea();
                    string north = area.Value.Tag.Substring(area.Value.Tag.Length - 6, 1);
                    string east = area.Value.Tag.Substring(area.Value.Tag.Length - 5, 1);
                    string south = area.Value.Tag.Substring(area.Value.Tag.Length - 4, 1);
                    string west = area.Value.Tag.Substring(area.Value.Tag.Length - 3, 1);
                    string up = area.Value.Tag.Substring(area.Value.Tag.Length - 2, 1);
                    string down = area.Value.Tag.Substring(area.Value.Tag.Length - 1, 1);

                    int n, e, s, w, u, d;
                    if (Int32.TryParse(north, out n) && n == 1) genericArea.AreaExits.Add(ExitDirection.North);
                    if (Int32.TryParse(east, out e) && e == 1) genericArea.AreaExits.Add(ExitDirection.East);
                    if (Int32.TryParse(south, out s) && s == 1) genericArea.AreaExits.Add(ExitDirection.South);
                    if (Int32.TryParse(west, out w) && w == 1) genericArea.AreaExits.Add(ExitDirection.West);
                    if (Int32.TryParse(up, out u) && u == 1) genericArea.AreaExits.Add(ExitDirection.Up);
                    if (Int32.TryParse(down, out d) && d == 1) genericArea.AreaExits.Add(ExitDirection.Down);

                    genericArea.AreaId = area.Key;
                    AvailableAreas[areaPrefix].Add(genericArea);
                }
            }
        }
    }
}
